# AS-IS 액션 대조표 — DMF0022

> 원천: `Doc/asisfacts/screens/DMF0022/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 806행 · 메서드 107 · 종류 DATA_OP 136 · RETURN 89 · FLAG 85 · ENDPOINT 68 · GRID_INIT 55 · GRID_SET 52 · CALL_EXT 50 · LIST_REBIND 44 · POPUP 36 · STATE 36 · COMBO_DATA 31 · UI_PROP 30 · UI_MISC 24 · VALUE_SET 19 · MESSAGE 13 · VALUE_CLEAR 12 · THROW 7 · GRID_STYLE 5 · LIST_BIND 4 · GRID_COMBO 4 · VALIDATE 2 · GRID_BIND 2 · GRID_LOCK 2 · ⚠ 의미 확인 필요 50


## DMF0022_SalesPlanWaterfall.btnColumn_Click

진입점: this.btnColumn.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9e359319 | this.btnColumn.Click | DMF0022_SalesPlanWaterfall.cs:1809 |  | POPUP | new DM0002_TitleSetForm_Popup | (sProgram_Id, SpdSheet.shtMain, true, clbDivision.ControlValues) | 팝업/폼 생성 |  |  |  |
| AC-b83eea6e | this.btnColumn.Click | DMF0022_SalesPlanWaterfall.cs:1810 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-cf605340 | this.btnColumn.Click | DMF0022_SalesPlanWaterfall.cs:1811 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## DMF0022_SalesPlanWaterfall.btnItemId_Click

진입점: this.btnItemId.Click / this.txtItemId.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1d541f9f | this.btnItemId.Click 외 1 | DMF0022_SalesPlanWaterfall.cs:1798 |  | POPUP | new DM0002_ItembyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-df2a8fd5 | this.btnItemId.Click 외 1 | DMF0022_SalesPlanWaterfall.cs:1800 |  | POPUP | popItem.Form_Load | (true, sDivision, sTeam, sEndCustomer, sScmSiteId, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-44ed933e | this.btnItemId.Click 외 1 | DMF0022_SalesPlanWaterfall.cs:1801 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-331ae27e | this.btnItemId.Click 외 1 | DMF0022_SalesPlanWaterfall.cs:1802 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-5d7ef2cf | this.btnItemId.Click 외 1 | DMF0022_SalesPlanWaterfall.cs:1804 |  | VALUE_SET | txtItemId.Text | popItem.ItemID | 컨트롤 값 설정 |  |  |  |

## DMF0022_SalesPlanWaterfall.btnMeasure_Click

진입점: this.btnMeasure.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4abb3ee3 | this.btnMeasure.Click | DMF0022_SalesPlanWaterfall.cs:1822 |  | POPUP | new DM0002_TitleSetForm_Popup | (sProgram_Id, SpdSheet.shtMain, false, clbDivision.ControlValues) | 팝업/폼 생성 |  |  |  |
| AC-ffc1c61d | this.btnMeasure.Click | DMF0022_SalesPlanWaterfall.cs:1823 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-d761150f | this.btnMeasure.Click | DMF0022_SalesPlanWaterfall.cs:1824 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## DMF0022_SalesPlanWaterfall.btnOwner_Click

진입점: this.usrButton1.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d858d359 | this.usrButton1.Click | DMF0022_SalesPlanWaterfall.cs:2738 |  | POPUP | new DM0020_OwnerbyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-3b5a7036 | this.usrButton1.Click | DMF0022_SalesPlanWaterfall.cs:2741 |  | POPUP | popItem.Form_Load | (true, sDivision, sTeam, sEndCustomer, sScmSiteId, sProject, sItemId, sOwner) | 팝업 초기화(인자 전달) |  |  |  |
| AC-49d06478 | this.usrButton1.Click | DMF0022_SalesPlanWaterfall.cs:2742 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-fdb5aaf7 | this.usrButton1.Click | DMF0022_SalesPlanWaterfall.cs:2743 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-ff4fecd6 | this.usrButton1.Click | DMF0022_SalesPlanWaterfall.cs:2745 |  | VALUE_SET | txtOwner.Text | popItem.OwnerID | 컨트롤 값 설정 |  |  |  |

## DMF0022_SalesPlanWaterfall.btnProject_Click

진입점: this.btnProject.Click / this.txtProject.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2d1e23de | this.btnProject.Click 외 1 | DMF0022_SalesPlanWaterfall.cs:1780 |  | POPUP | new SCM0002_ProjectbyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-15d6b654 | this.btnProject.Click 외 1 | DMF0022_SalesPlanWaterfall.cs:1781 |  | POPUP | popProject.Form_Load | (true, sDivision, sTeam, sEndCustomer, sScmSite, sProject) | 팝업 초기화(인자 전달) |  |  |  |
| AC-ebb3f5ad | this.btnProject.Click 외 1 | DMF0022_SalesPlanWaterfall.cs:1782 |  | UI_PROP | popProject.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-99722432 | this.btnProject.Click 외 1 | DMF0022_SalesPlanWaterfall.cs:1783 |  | POPUP | popProject.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-f511abdb | this.btnProject.Click 외 1 | DMF0022_SalesPlanWaterfall.cs:1785 |  | VALUE_SET | txtProject.Text | popProject.ProjectCode | 컨트롤 값 설정 |  |  |  |

## DMF0022_SalesPlanWaterfall.btnVersion_Click

진입점: this.btnVersion.Click / this.txtVersion.KeyDown

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a3ac14cc | this.btnVersion.Click 외 1 | DMF0022_SalesPlanWaterfall.cs:2690 |  | POPUP | new GSCM.DM.Master.UIL.DMF0073_VersionBySalesPricePopup | () | 팝업/폼 생성 |  |  |  |
| AC-b19e96ae | this.btnVersion.Click 외 1 | DMF0022_SalesPlanWaterfall.cs:2703 |  | POPUP | popVersion.Form_Load | (true, "SP", sDivision, sStartTime, sEndTinme) | 팝업 초기화(인자 전달) |  |  |  |
| AC-39690c47 | this.btnVersion.Click 외 1 | DMF0022_SalesPlanWaterfall.cs:2704 |  | UI_PROP | popVersion.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-60a49f61 | this.btnVersion.Click 외 1 | DMF0022_SalesPlanWaterfall.cs:2705 |  | POPUP | popVersion.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-41a51d4a | this.btnVersion.Click 외 1 | DMF0022_SalesPlanWaterfall.cs:2709 | if (popVersion.sVersions != "") | VALUE_SET | txtVersion.Text | popVersion.sVersions | 컨트롤 값 설정 |  |  |  |
| AC-6da50e8c | this.btnVersion.Click 외 1 | DMF0022_SalesPlanWaterfall.cs:2710 | if (popVersion.sVersions != "") | VALUE_SET | drpPeriod.InitValue | popVersion.sPeriod | 컨트롤 값 설정 |  |  |  |

## DMF0022_SalesPlanWaterfall.cboBucketType_SelectedIndexChanged

진입점: this.cboBucketType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1bb521fc | this.cboBucketType.SelectedIndexChanged | DMF0022_SalesPlanWaterfall.cs:1666 | if (siMain != null) | FLAG | sBucket | cboBucketType.ControlValues | 화면 필드/플래그 변경 |  |  |  |

## DMF0022_SalesPlanWaterfall.cboKRW_SelectedIndexChanged

진입점: this.cboKRW.SelectedIndexChanged / cboKRW.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-681f0b30 | this.cboKRW.SelectedIndexChanged 외 1 | DMF0022_SalesPlanWaterfall.cs:2326 | if (siMain == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DMF0022_SalesPlanWaterfall.cboLOC_SelectedIndexChanged

진입점: this.cboLOC.SelectedIndexChanged / cboLOC.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-524aee79 | this.cboLOC.SelectedIndexChanged 외 1 | DMF0022_SalesPlanWaterfall.cs:2347 | if (siMain == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DMF0022_SalesPlanWaterfall.cboQTY_SelectedIndexChanged

진입점: this.cboQTY.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ff88eb40 | this.cboQTY.SelectedIndexChanged | DMF0022_SalesPlanWaterfall.cs:2357 | if (siMain == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DMF0022_SalesPlanWaterfall.cboUSD_SelectedIndexChanged

진입점: this.cboUSD.SelectedIndexChanged / cboUSD.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-069c4063 | this.cboUSD.SelectedIndexChanged 외 1 | DMF0022_SalesPlanWaterfall.cs:2337 | if (siMain == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DMF0022_SalesPlanWaterfall.clbCustomer_SelectedIndexChanged

진입점: this.clbCustomer.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6f2f2e80 | this.clbCustomer.SelectedIndexChanged | DMF0022_SalesPlanWaterfall.cs:2312 | if (blnInit) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c15c9fd4 | this.clbCustomer.SelectedIndexChanged | DMF0022_SalesPlanWaterfall.cs:2314 | if (base.IsInitOpen) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a7b9605f | this.clbCustomer.SelectedIndexChanged | DMF0022_SalesPlanWaterfall.cs:2320 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |

## DMF0022_SalesPlanWaterfall.ClbDivision_SelectedIndexChanged

진입점: this.clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-899cc5c5 | this.clbDivision.SelectedIndexChanged | DMF0022_SalesPlanWaterfall.cs:1519 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-4e89a3db | this.clbDivision.SelectedIndexChanged | DMF0022_SalesPlanWaterfall.cs:1527 | try | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-3ecf017f | this.clbDivision.SelectedIndexChanged | DMF0022_SalesPlanWaterfall.cs:1545 | try ▸ if (sDivision == "40") | LIST_REBIND | clsCtrl.setListBox | (dtBizType, clbBizType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-82f3df07 | this.clbDivision.SelectedIndexChanged | DMF0022_SalesPlanWaterfall.cs:1548 | try ▸ if (sDivision == "40") | STATE | lblProject.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-9e502cda | this.clbDivision.SelectedIndexChanged | DMF0022_SalesPlanWaterfall.cs:1549 | try ▸ if (sDivision == "40") | STATE | lblPlantSite.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-6d300dab | this.clbDivision.SelectedIndexChanged | DMF0022_SalesPlanWaterfall.cs:1550 | try ▸ if (sDivision == "40") | STATE | layoutControlItem3.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-312b870f | this.clbDivision.SelectedIndexChanged | DMF0022_SalesPlanWaterfall.cs:1551 | try ▸ if (sDivision == "40") | STATE | cboCellQty.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-e5c2c07a | this.clbDivision.SelectedIndexChanged | DMF0022_SalesPlanWaterfall.cs:1565 | try ▸ else of (sDivision == "40") | LIST_REBIND | clsCtrl.setListBox | (dtBizType, clbBizType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-b3342724 | this.clbDivision.SelectedIndexChanged | DMF0022_SalesPlanWaterfall.cs:1568 | try ▸ else of (sDivision == "40") | STATE | lblProject.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-92a6840f | this.clbDivision.SelectedIndexChanged | DMF0022_SalesPlanWaterfall.cs:1569 | try ▸ else of (sDivision == "40") | STATE | lblPlantSite.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-33a8694f | this.clbDivision.SelectedIndexChanged | DMF0022_SalesPlanWaterfall.cs:1570 | try ▸ else of (sDivision == "40") | STATE | layoutControlItem3.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-e1a3c260 | this.clbDivision.SelectedIndexChanged | DMF0022_SalesPlanWaterfall.cs:1571 | try ▸ else of (sDivision == "40") | STATE | cboCellQty.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-86a99c41 | this.clbDivision.SelectedIndexChanged | DMF0022_SalesPlanWaterfall.cs:1572 | try ▸ else of (sDivision == "40") | VALUE_SET | cboCellQty.Checked | false | 컨트롤 값 설정 |  |  |  |
| AC-192d02c7 | this.clbDivision.SelectedIndexChanged | DMF0022_SalesPlanWaterfall.cs:1578 | try | STATE | lblBizType.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-7e222ea5 | this.clbDivision.SelectedIndexChanged | DMF0022_SalesPlanWaterfall.cs:1582 | try | LIST_REBIND | clsCtrl.setListBox | (dtEndCustomer, clbCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-eaa7c532 | this.clbDivision.SelectedIndexChanged | DMF0022_SalesPlanWaterfall.cs:1590 | try | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-c2ec6f4c | this.clbDivision.SelectedIndexChanged | DMF0022_SalesPlanWaterfall.cs:1599 | try | LIST_REBIND | clsCtrl.setListBox | (dtPlantSiteByDivision, clbPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-40b5da85 | this.clbDivision.SelectedIndexChanged | DMF0022_SalesPlanWaterfall.cs:1609 | try | VALUE_CLEAR | this.txtProject.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-0852de26 | this.clbDivision.SelectedIndexChanged | DMF0022_SalesPlanWaterfall.cs:1610 | try | VALUE_CLEAR | this.txtItemId.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-88e9ad7b | this.clbDivision.SelectedIndexChanged | DMF0022_SalesPlanWaterfall.cs:1611 | try | VALUE_CLEAR | this.txtOwner.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-2b0cddb9 | this.clbDivision.SelectedIndexChanged | DMF0022_SalesPlanWaterfall.cs:1612 | try | VALUE_CLEAR | this.txtVersion.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-4b92c60e | this.clbDivision.SelectedIndexChanged | DMF0022_SalesPlanWaterfall.cs:1620 | catch ((Exception ex)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-1c7b606e | this.clbDivision.SelectedIndexChanged | DMF0022_SalesPlanWaterfall.cs:1621 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |
| AC-bb02cf30 | this.clbDivision.SelectedIndexChanged | DMF0022_SalesPlanWaterfall.cs:1625 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

## DMF0022_SalesPlanWaterfall.ClbPlantSite_SelectedIndexChanged

진입점: clbPlantSite.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-87556479 | clbPlantSite.SelectedIndexChanged | DMF0022_SalesPlanWaterfall.cs:1645 | if (blnInit) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-67358746 | clbPlantSite.SelectedIndexChanged | DMF0022_SalesPlanWaterfall.cs:1647 | if (base.IsInitOpen) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DMF0022_SalesPlanWaterfall.ClbSalesSite_SelectedIndexChanged

진입점: clbSalesSite.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-714e455e | clbSalesSite.SelectedIndexChanged | DMF0022_SalesPlanWaterfall.cs:1634 | if (blnInit) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-527b763c | clbSalesSite.SelectedIndexChanged | DMF0022_SalesPlanWaterfall.cs:1636 | if (base.IsInitOpen) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DMF0022_SalesPlanWaterfall.clbTeam_SelectedIndexChanged

진입점: this.clbTeam.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0d4d081b | this.clbTeam.SelectedIndexChanged | DMF0022_SalesPlanWaterfall.cs:2603 | if (blnInit) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c2565f50 | this.clbTeam.SelectedIndexChanged | DMF0022_SalesPlanWaterfall.cs:2605 | if (base.IsInitOpen) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1c031e84 | this.clbTeam.SelectedIndexChanged | DMF0022_SalesPlanWaterfall.cs:2628 |  | LIST_REBIND | clsCtrl.setListBox | (dtEndCustomer, clbCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-4d7db31e | this.clbTeam.SelectedIndexChanged | DMF0022_SalesPlanWaterfall.cs:2636 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |

## DMF0022_SalesPlanWaterfall.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6c27a053 | this.Load | DMF0022_SalesPlanWaterfall.cs:473 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 3, 1, 45) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-b2986716 | this.Load | DMF0022_SalesPlanWaterfall.cs:474 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-5942d801 | this.Load | DMF0022_SalesPlanWaterfall.cs:475 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0022_SalesPlanWaterfall.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-93868d41 | this.Load | DMF0022_SalesPlanWaterfall.cs:444 |  | UI_PROP | usrConditionPanel1.Height | 105 | 속성 Height 설정 |  |  |  |
| AC-57049c5f | this.Load | DMF0022_SalesPlanWaterfall.cs:445 |  | VALUE_SET | cboBucketType.ControlValues | BucketType.Monthly | 컨트롤 값 설정 |  |  |  |
| AC-efbc7d59 | this.Load | DMF0022_SalesPlanWaterfall.cs:448 |  | FLAG | dtStartPeriod | drpPeriod.Value1 | 화면 필드/플래그 변경 |  |  |  |
| AC-149d905f | this.Load | DMF0022_SalesPlanWaterfall.cs:449 |  | FLAG | dtEndPeriod | drpPeriod.Value2 | 화면 필드/플래그 변경 |  |  |  |

## DMF0022_SalesPlanWaterfall.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b8e8672f | Dispose | DMF0022_SalesPlanWaterfall.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## DMF0022_SalesPlanWaterfall.DM0022_SalesPlanWaterfall_FormClosed

진입점: this.FormClosed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-598c8d72 | this.FormClosed | DMF0022_SalesPlanWaterfall.cs:2718 | try | CALL_EXT | GC.SuppressFinalize | (this) | ⚠ 의미 확인 필요 |  |  |  |
| AC-eb41af01 | this.FormClosed | DMF0022_SalesPlanWaterfall.cs:2720 | try | CALL_EXT | GC.Collect | (0, GCCollectionMode.Forced, true, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-daa83a76 | this.FormClosed | DMF0022_SalesPlanWaterfall.cs:2721 | try | CALL_EXT | GC.Collect | (1, GCCollectionMode.Forced, true, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e4a86c95 | this.FormClosed | DMF0022_SalesPlanWaterfall.cs:2722 | try | CALL_EXT | GC.Collect | (2, GCCollectionMode.Forced, true, true) | ⚠ 의미 확인 필요 |  |  |  |

## DMF0022_SalesPlanWaterfall.Draw

진입점: FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c7c17668 | FindButton [try] | DMF0022_SalesPlanWaterfall.cs:1244 |  | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-bb6b1c59 | FindButton [try] | DMF0022_SalesPlanWaterfall.cs:1261 | try ▸ if (data_start_pos < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-67c6cb7f | FindButton [try] | DMF0022_SalesPlanWaterfall.cs:1274 | try ▸ for (j < maxCol) | DATA_OP | colnames[j - data_start_pos] | siMain.GetColumnTag(j) | 행/컬럼 값 대입 |  |  |  |
| AC-10d8b4ad | FindButton [try] | DMF0022_SalesPlanWaterfall.cs:1278 | try ▸ for (j < maxCol) ▸ for (i < maxRow) | DATA_OP | rNotation[i] | ds.Tables[0].Rows[i]["NOTATION"].String().ToUpper() | 행/컬럼 값 대입 |  |  |  |
| AC-38769dc1 | FindButton [try] | DMF0022_SalesPlanWaterfall.cs:1278 | try ▸ for (j < maxCol) ▸ for (i < maxRow) | CALL_EXT | ds.Tables[0].Rows[i]["NOTATION"].String | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-0e0d45f8 | FindButton [try] | DMF0022_SalesPlanWaterfall.cs:1292 | try ▸ for (j < maxCol) ▸ for (i < maxRow) ▸ else of (Val == "" \|\| rNotation[i] == "DEFAULT") ▸ switch (rNotation[i]) case "INTEGER": | DATA_OP | rMeasureType[i] | 1 | 행/컬럼 값 대입 |  |  |  |
| AC-de76518e | FindButton [try] | DMF0022_SalesPlanWaterfall.cs:1295 | try ▸ for (j < maxCol) ▸ for (i < maxRow) ▸ else of (Val == "" \|\| rNotation[i] == "DEFAULT") ▸ switch (rNotation[i]) case "POINT": | DATA_OP | rMeasureType[i] | 2 | 행/컬럼 값 대입 |  |  |  |
| AC-7225e187 | FindButton [try] | DMF0022_SalesPlanWaterfall.cs:1298 | try ▸ for (j < maxCol) ▸ for (i < maxRow) ▸ else of (Val == "" \|\| rNotation[i] == "DEFAULT") ▸ switch (rNotation[i]) case "POINT3": | DATA_OP | rMeasureType[i] | 3 | 행/컬럼 값 대입 |  |  |  |
| AC-28d158e2 | FindButton [try] | DMF0022_SalesPlanWaterfall.cs:1309 | try ▸ for (j < maxCol) ▸ for (i < maxRow) ▸ else of (Val == "" \|\| rNotation[i] == "DEFAULT") ▸ switch (rMeasureType[i]) case 1: ▸ if (Val.… | CALL_EXT | siMain.SetRowFormat | (i, j, maxCol - data_start_pos, "###,###,###,##0") | ⚠ 의미 확인 필요 |  |  |  |
| AC-cd36dbcd | FindButton [try] | DMF0022_SalesPlanWaterfall.cs:1311 | try ▸ for (j < maxCol) ▸ for (i < maxRow) ▸ else of (Val == "" \|\| rNotation[i] == "DEFAULT") ▸ switch (rMeasureType[i]) case 1: ▸ else of … | CALL_EXT | siMain.SetRowFormat | (i, j, maxCol - data_start_pos, "###,###,###,###") | ⚠ 의미 확인 필요 |  |  |  |
| AC-9580ae14 | FindButton [try] | DMF0022_SalesPlanWaterfall.cs:1318 | try ▸ for (j < maxCol) ▸ for (i < maxRow) ▸ else of (Val == "" \|\| rNotation[i] == "DEFAULT") ▸ switch (rMeasureType[i]) case 2: ▸ if (Val … | CALL_EXT | siMain.SetRowFormat | (i, j, maxCol - data_start_pos, "###,###,###,##0") | ⚠ 의미 확인 필요 |  |  |  |
| AC-f91965f8 | FindButton [try] | DMF0022_SalesPlanWaterfall.cs:1321 | try ▸ for (j < maxCol) ▸ for (i < maxRow) ▸ else of (Val == "" \|\| rNotation[i] == "DEFAULT") ▸ switch (rMeasureType[i]) case 2: ▸ else of … | CALL_EXT | siMain.SetRowFormat | (i, j, maxCol - data_start_pos, "0.###") | ⚠ 의미 확인 필요 |  |  |  |
| AC-8dc0dbd4 | FindButton [try] | DMF0022_SalesPlanWaterfall.cs:1324 | try ▸ for (j < maxCol) ▸ for (i < maxRow) ▸ else of (Val == "" \|\| rNotation[i] == "DEFAULT") ▸ switch (rMeasureType[i]) case 2: ▸ else of … | CALL_EXT | siMain.SetRowFormat | (i, j, maxCol - data_start_pos, "###,###,###,###") | ⚠ 의미 확인 필요 |  |  |  |
| AC-8cb8be65 | FindButton [try] | DMF0022_SalesPlanWaterfall.cs:1327 | try ▸ for (j < maxCol) ▸ for (i < maxRow) ▸ else of (Val == "" \|\| rNotation[i] == "DEFAULT") ▸ switch (rMeasureType[i]) case 2: ▸ else of … | CALL_EXT | siMain.SetRowFormat | (i, j, maxCol - data_start_pos, "###,###,###,###.###") | ⚠ 의미 확인 필요 |  |  |  |
| AC-f194c5ca | FindButton [try] | DMF0022_SalesPlanWaterfall.cs:1334 | try ▸ for (j < maxCol) ▸ for (i < maxRow) ▸ else of (Val == "" \|\| rNotation[i] == "DEFAULT") ▸ switch (rMeasureType[i]) case 3: ▸ if (Val … | CALL_EXT | siMain.SetRowFormat | (i, j, maxCol - data_start_pos, "###,###,###,##0") | ⚠ 의미 확인 필요 |  |  |  |
| AC-2aee1fad | FindButton [try] | DMF0022_SalesPlanWaterfall.cs:1337 | try ▸ for (j < maxCol) ▸ for (i < maxRow) ▸ else of (Val == "" \|\| rNotation[i] == "DEFAULT") ▸ switch (rMeasureType[i]) case 3: ▸ else of … | CALL_EXT | siMain.SetRowFormat | (i, j, maxCol - data_start_pos, "0.#00") | ⚠ 의미 확인 필요 |  |  |  |
| AC-444f461b | FindButton [try] | DMF0022_SalesPlanWaterfall.cs:1340 | try ▸ for (j < maxCol) ▸ for (i < maxRow) ▸ else of (Val == "" \|\| rNotation[i] == "DEFAULT") ▸ switch (rMeasureType[i]) case 3: ▸ else of … | CALL_EXT | siMain.SetRowFormat | (i, j, maxCol - data_start_pos, "0.##0") | ⚠ 의미 확인 필요 |  |  |  |
| AC-6aec6164 | FindButton [try] | DMF0022_SalesPlanWaterfall.cs:1343 | try ▸ for (j < maxCol) ▸ for (i < maxRow) ▸ else of (Val == "" \|\| rNotation[i] == "DEFAULT") ▸ switch (rMeasureType[i]) case 3: ▸ else of … | CALL_EXT | siMain.SetRowFormat | (i, j, maxCol - data_start_pos, "0.###") | ⚠ 의미 확인 필요 |  |  |  |
| AC-b190818b | FindButton [try] | DMF0022_SalesPlanWaterfall.cs:1346 | try ▸ for (j < maxCol) ▸ for (i < maxRow) ▸ else of (Val == "" \|\| rNotation[i] == "DEFAULT") ▸ switch (rMeasureType[i]) case 3: ▸ else of … | CALL_EXT | siMain.SetRowFormat | (i, j, maxCol - data_start_pos, "###,###,###,###.#00") | ⚠ 의미 확인 필요 |  |  |  |
| AC-6ec43668 | FindButton [try] | DMF0022_SalesPlanWaterfall.cs:1349 | try ▸ for (j < maxCol) ▸ for (i < maxRow) ▸ else of (Val == "" \|\| rNotation[i] == "DEFAULT") ▸ switch (rMeasureType[i]) case 3: ▸ else of … | CALL_EXT | siMain.SetRowFormat | (i, j, maxCol - data_start_pos, "###,###,###,###.##0") | ⚠ 의미 확인 필요 |  |  |  |
| AC-9be2df2a | FindButton [try] | DMF0022_SalesPlanWaterfall.cs:1352 | try ▸ for (j < maxCol) ▸ for (i < maxRow) ▸ else of (Val == "" \|\| rNotation[i] == "DEFAULT") ▸ switch (rMeasureType[i]) case 3: ▸ else of … | CALL_EXT | siMain.SetRowFormat | (i, j, maxCol - data_start_pos, "###,###,###,###.###") | ⚠ 의미 확인 필요 |  |  |  |
| AC-98833640 | FindButton [try] | DMF0022_SalesPlanWaterfall.cs:1367 | if (siMain.GetMaxRowIndex() > 0 && ds != null) | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-99bcea42 | FindButton [try] | DMF0022_SalesPlanWaterfall.cs:1376 | for (i <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetColumnIndex(DefColumns.CELL_PROD_SITE_ID) != -1) | GRID_SET | siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(DefColumns.CELL_PROD_SITE_ID)].VerticalA… | CellVerticalAlignment.Center | 그리드 속성/값 설정 |  |  |  |
| AC-e90644b0 | FindButton [try] | DMF0022_SalesPlanWaterfall.cs:1384 |  | FLAG | this_YYYYMMWW | "W_" + DateTime.Today.ToString("yyyyMM") + ds.Tables[1].Rows[0]["ISO_WEEK"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-b040f7c7 | FindButton [try] | DMF0022_SalesPlanWaterfall.cs:1385 |  | FLAG | iso_week | ds.Tables[1].Rows[0]["ISO_WEEK"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-d686d1c1 | FindButton [try] | DMF0022_SalesPlanWaterfall.cs:1389 | if (chkMem.Checked == true) | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-0cc44d7f | FindButton [try] | DMF0022_SalesPlanWaterfall.cs:1437 | if (chkMem.Checked == true) ▸ for (i <= siMain.GetMaxRowIndex()) | CALL_EXT | calendar.GetWeekOfYear | (referenceDate, CalendarWeekRule.FirstFourDayWeek, DayOfWeek.Monday) | ⚠ 의미 확인 필요 |  |  |  |
| AC-bd1e1b47 | FindButton [try] | DMF0022_SalesPlanWaterfall.cs:1467 | if (chkMem.Checked == true) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetColumnIndex(sLockDate) >= 0) | GRID_STYLE | siMain.SetBGColor | (i, iStartCol, i, iResultCol, Color.Gainsboro) | 그리드 표시 설정 |  |  |  |
| AC-6b6c5af2 | FindButton [try] | DMF0022_SalesPlanWaterfall.cs:1472 | if (chkMem.Checked == true) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetColumnIndex(sLockDate) >= 0) ▸ if (siMain.GetColumnIndex(sU… | GRID_STYLE | siMain.SetBGColor | (i, iResultMonth, i, iResultMonth, Color.White) | 그리드 표시 설정 |  |  |  |
| AC-ae95eac6 | FindButton [try] | DMF0022_SalesPlanWaterfall.cs:1480 | if (dsOrigianlCopy != null) | UI_MISC | dsOrigianlCopy.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-da261a66 | FindButton [try] | DMF0022_SalesPlanWaterfall.cs:1481 | if (dsOrigianlCopy != null) | FLAG | dsOrigianlCopy | null | 화면 필드/플래그 변경 |  |  |  |
| AC-72cc878d | FindButton [try] | DMF0022_SalesPlanWaterfall.cs:1492 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0022_SalesPlanWaterfall.EditButton

진입점: this.cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if (!siMain.IsLock(siMain.SheetName))] / EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6cba2fd9 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0022_SalesPlanWaterfall.cs:697 | if (this.fps != null) | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a99b3d93 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0022_SalesPlanWaterfall.cs:698 | if (this.fps != null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DMF0022_SalesPlanWaterfall.ExcelButton

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3d000486 | ExcelButton | DMF0022_SalesPlanWaterfall.cs:994 |  | UI_PROP | exportOption.Merge | ExcelMergeOption.None | 속성 Merge 설정 |  |  |  |
| AC-c53a583f | ExcelButton | DMF0022_SalesPlanWaterfall.cs:995 |  | UI_PROP | exportOption.Border | ExcelBorderOption.All | 속성 Border 설정 |  |  |  |
| AC-d46cf7e7 | ExcelButton | DMF0022_SalesPlanWaterfall.cs:996 |  | UI_PROP | exportOption.AheadZeroOption | ZeroOption.HideZero | 속성 AheadZeroOption 설정 |  |  |  |
| AC-5a0628f6 | ExcelButton | DMF0022_SalesPlanWaterfall.cs:997 |  | UI_PROP | exportOption.AmendZeroOption | ZeroOption.ShowZero | 속성 AmendZeroOption 설정 |  |  |  |
| AC-c8ec4596 | ExcelButton | DMF0022_SalesPlanWaterfall.cs:998 |  | UI_PROP | exportOption.AmendNullToZero | false | 속성 AmendNullToZero 설정 |  |  |  |
| AC-ea3c9638 | ExcelButton | DMF0022_SalesPlanWaterfall.cs:999 |  | UI_PROP | exportOption.AheadNullToZero | false | 속성 AheadNullToZero 설정 |  |  |  |
| AC-6e6709da | ExcelButton | DMF0022_SalesPlanWaterfall.cs:1001 |  | UI_PROP | exportOption.UserName | UserInfo.UserId | 속성 UserName 설정 |  |  |  |
| AC-212d655b | ExcelButton | DMF0022_SalesPlanWaterfall.cs:1002 |  | UI_PROP | exportOption.FileName | sFileName | 속성 FileName 설정 |  |  |  |
| AC-c944cb34 | ExcelButton | DMF0022_SalesPlanWaterfall.cs:1004 |  | UI_PROP | exportOption.AmendDecimalFormat | "#,##0.000;[Red]-#,##0.000" | 속성 AmendDecimalFormat 설정 |  |  |  |
| AC-529d58c1 | ExcelButton | DMF0022_SalesPlanWaterfall.cs:1008 |  | UI_PROP | exportOption.CellFormatter | SimplexelService.DefaultCellFormat | 속성 CellFormatter 설정 |  |  |  |
| AC-7bf16008 | ExcelButton | DMF0022_SalesPlanWaterfall.cs:1013 | try | CALL_EXT | SimplexelService.ExportFpSpread | (fps, exportOption) | ⚠ 의미 확인 필요 |  |  |  |
| AC-db5c99fb | ExcelButton | DMF0022_SalesPlanWaterfall.cs:1018 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-640fe410 | ExcelButton | DMF0022_SalesPlanWaterfall.cs:1022 | finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## DMF0022_SalesPlanWaterfall.FindData

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-829abc44 | FindButton | DMF0022_SalesPlanWaterfall.cs:1040 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-e9a5b1f0 | FindButton | DMF0022_SalesPlanWaterfall.cs:1047 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-efa62b31 | FindButton | DMF0022_SalesPlanWaterfall.cs:1048 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b35a1c21 | FindButton | DMF0022_SalesPlanWaterfall.cs:1051 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-c17b6585 | FindButton | DMF0022_SalesPlanWaterfall.cs:1053 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-b50430cc | FindButton | DMF0022_SalesPlanWaterfall.cs:1053 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6d0fb763 | FindButton | DMF0022_SalesPlanWaterfall.cs:1063 | try ▸ if (int.Parse(sPeriod[0]) > int.Parse(sPeriod[1])) | MESSAGE | MessageHelper.GMessageBox | ("MSG00108") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c9e92123 | FindButton | DMF0022_SalesPlanWaterfall.cs:1064 | try ▸ if (int.Parse(sPeriod[0]) > int.Parse(sPeriod[1])) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-84fd1b45 | FindButton | DMF0022_SalesPlanWaterfall.cs:1070 | try ▸ if (drpPeriod.Value1.AddYears(3) < drpPeriod.Value2) | MESSAGE | MessageHelper.GMessageBox | ("MSG00164") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5e566513 | FindButton | DMF0022_SalesPlanWaterfall.cs:1072 | try ▸ if (drpPeriod.Value1.AddYears(3) < drpPeriod.Value2) | UI_PROP | drpPeriod.Value2 | drpPeriod.Value1.AddYears(3) | 속성 Value2 설정 |  |  |  |
| AC-f39c61ee | FindButton | DMF0022_SalesPlanWaterfall.cs:1074 | try ▸ if (drpPeriod.Value1.AddYears(3) < drpPeriod.Value2) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2d4c38ac | FindButton | DMF0022_SalesPlanWaterfall.cs:1078 | try | CALL_EXT | drpPeriod.Value1.CompareTo | (thisWeekDate) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f17e490f | FindButton | DMF0022_SalesPlanWaterfall.cs:1080 | try | CALL_EXT | Convert.ToInt32(sEndDate).CompareTo | (Convert.ToInt32(sNowDate)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4911ac24 | FindButton | DMF0022_SalesPlanWaterfall.cs:1100 | try ▸ if (p_division_id == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00097") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-bd20e9a1 | FindButton | DMF0022_SalesPlanWaterfall.cs:1101 | try ▸ if (p_division_id == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d81715b2 | FindButton | DMF0022_SalesPlanWaterfall.cs:1105 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-1c6e00f4 | FindButton | DMF0022_SalesPlanWaterfall.cs:1115 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-452b68ae | FindButton | DMF0022_SalesPlanWaterfall.cs:1117 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { va… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e2939b74 | FindButton | DMF0022_SalesPlanWaterfall.cs:1122 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("DM.DMF0022_GET_DM_PLN_SALES_PLAN_WATERFALL") ⇒ DM.DMF0022_GET_DM_PLN_SALES_PLAN_WATERFALL | 엔드포인트 요청 생성 |  |  |  |
| AC-f68ba63a | FindButton | DMF0022_SalesPlanWaterfall.cs:1124 | try ▸ lambda | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-37f936e2 | FindButton | DMF0022_SalesPlanWaterfall.cs:1126 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-8ffae17a | FindButton | DMF0022_SalesPlanWaterfall.cs:1127 | try ▸ lambda | DATA_OP | request.Parameters["p_dept_id"] | p_dept_id | 행/컬럼 값 대입 |  |  |  |
| AC-bca0be60 | FindButton | DMF0022_SalesPlanWaterfall.cs:1128 | try ▸ lambda | DATA_OP | request.Parameters["p_end_customer"] | p_end_customer | 행/컬럼 값 대입 |  |  |  |
| AC-8998ab6d | FindButton | DMF0022_SalesPlanWaterfall.cs:1129 | try ▸ lambda | DATA_OP | request.Parameters["p_scm_site_id"] | p_scm_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-53b778a8 | FindButton | DMF0022_SalesPlanWaterfall.cs:1130 | try ▸ lambda | DATA_OP | request.Parameters["p_project_code"] | p_project_code | 행/컬럼 값 대입 |  |  |  |
| AC-d2888271 | FindButton | DMF0022_SalesPlanWaterfall.cs:1131 | try ▸ lambda | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-744fa2ef | FindButton | DMF0022_SalesPlanWaterfall.cs:1132 | try ▸ lambda | DATA_OP | request.Parameters["p_item_type"] | p_item_type | 행/컬럼 값 대입 |  |  |  |
| AC-c74cc1af | FindButton | DMF0022_SalesPlanWaterfall.cs:1133 | try ▸ lambda | DATA_OP | request.Parameters["p_from_yyyymmdd"] | sStartDate | 행/컬럼 값 대입 |  |  |  |
| AC-ebc0aaeb | FindButton | DMF0022_SalesPlanWaterfall.cs:1134 | try ▸ lambda | DATA_OP | request.Parameters["p_now_yyyymmdd"] | sNowDate | 행/컬럼 값 대입 |  |  |  |
| AC-a5ac6ae2 | FindButton | DMF0022_SalesPlanWaterfall.cs:1135 | try ▸ lambda | DATA_OP | request.Parameters["p_to_yyyymmdd"] | sEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-c2a065a8 | FindButton | DMF0022_SalesPlanWaterfall.cs:1136 | try ▸ lambda | DATA_OP | request.Parameters["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-a3e5638c | FindButton | DMF0022_SalesPlanWaterfall.cs:1137 | try ▸ lambda | DATA_OP | request.Parameters["p_plant_site_id"] | p_plant_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-0b62c58a | FindButton | DMF0022_SalesPlanWaterfall.cs:1138 | try ▸ lambda | DATA_OP | request.Parameters["p_biztype"] | p_biztype | 행/컬럼 값 대입 |  |  |  |
| AC-514f9e6d | FindButton | DMF0022_SalesPlanWaterfall.cs:1139 | try ▸ lambda | DATA_OP | request.Parameters["p_version_type"] | p_version_type | 행/컬럼 값 대입 |  |  |  |
| AC-d25cd0e3 | FindButton | DMF0022_SalesPlanWaterfall.cs:1140 | try ▸ lambda | DATA_OP | request.Parameters["p_owner"] | p_owner | 행/컬럼 값 대입 |  |  |  |
| AC-1ee22aea | FindButton | DMF0022_SalesPlanWaterfall.cs:1141 | try ▸ lambda | DATA_OP | request.Parameters["p_internal_yn"] | (InternalYN.Checked == true) ? "Y" : "N" | 행/컬럼 값 대입 |  |  |  |
| AC-200efa6b | FindButton | DMF0022_SalesPlanWaterfall.cs:1142 | try ▸ lambda | DATA_OP | request.Parameters["p_cell_yn"] | (cboCellQty.Checked == true) ? "Y" : "N" | 행/컬럼 값 대입 |  |  |  |
| AC-3ba73cdd | FindButton | DMF0022_SalesPlanWaterfall.cs:1143 | try ▸ lambda | DATA_OP | request.Parameters["p_bucket"] | p_bucket | 행/컬럼 값 대입 |  |  |  |
| AC-2aaef0bf | FindButton | DMF0022_SalesPlanWaterfall.cs:1145 | try ▸ lambda | DATA_OP | request.Parameters["p_user_dept_id"] | UserInfoContext.Current["Dept_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-3240b62c | FindButton | DMF0022_SalesPlanWaterfall.cs:1146 | try ▸ lambda | DATA_OP | request.Parameters["p_group_id"] | UserInfoContext.Current["NowGroupID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-cebef329 | FindButton | DMF0022_SalesPlanWaterfall.cs:1149 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-791a466d | FindButton | DMF0022_SalesPlanWaterfall.cs:1151 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-b51d35e7 | FindButton | DMF0022_SalesPlanWaterfall.cs:1156 | try ▸ if (ds.Tables[0].Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-78d9ca2d | FindButton | DMF0022_SalesPlanWaterfall.cs:1162 | try ▸ if (ds.Tables[0].Rows[ds.Tables[0].Rows.Count - 1]["MEASURE"].ToString() != "") | DATA_OP | ds.Tables[0].Columns.Add | ("Action", typeof(char)) | 데이터 객체 조작/조회 |  |  |  |
| AC-8cef30d5 | FindButton | DMF0022_SalesPlanWaterfall.cs:1164 | try ▸ if (ds.Tables[0].Rows[ds.Tables[0].Rows.Count - 1]["MEASURE"].ToString() != "") | DATA_OP | ds.Tables[0].AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-0ed3c6b7 | FindButton | DMF0022_SalesPlanWaterfall.cs:1165 | try ▸ if (ds.Tables[0].Rows[ds.Tables[0].Rows.Count - 1]["MEASURE"].ToString() != "") | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-60974dde | FindButton | DMF0022_SalesPlanWaterfall.cs:1166 | try ▸ if (ds.Tables[0].Rows[ds.Tables[0].Rows.Count - 1]["MEASURE"].ToString() != "") | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-0f81289f | FindButton | DMF0022_SalesPlanWaterfall.cs:1170 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-61443433 | FindButton | DMF0022_SalesPlanWaterfall.cs:1176 | try | FLAG | dsMain | ds | 화면 필드/플래그 변경 |  |  |  |
| AC-e4eac3d2 | FindButton | DMF0022_SalesPlanWaterfall.cs:1216 | catch ((Exception ex)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-1bebad19 | FindButton | DMF0022_SalesPlanWaterfall.cs:1223 | catch ((Exception ex)) ▸ if (this.Visible) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-565680db | FindButton | DMF0022_SalesPlanWaterfall.cs:1229 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-3901c413 | FindButton | DMF0022_SalesPlanWaterfall.cs:1230 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-c091f8a6 | FindButton | DMF0022_SalesPlanWaterfall.cs:1231 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## DMF0022_SalesPlanWaterfall.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-de39ac09 | this.Load | DMF0022_SalesPlanWaterfall.cs:220 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-acd9b298 | this.Load | DMF0022_SalesPlanWaterfall.cs:222 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## DMF0022_SalesPlanWaterfall.GetBizTypebyDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3dfa93b2 | (진입점 미연결) | DMF0022_SalesPlanWaterfall.cs:2229 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION") ⇒ SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-89021968 | (진입점 미연결) | DMF0022_SalesPlanWaterfall.cs:2230 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-cc3554ff | (진입점 미연결) | DMF0022_SalesPlanWaterfall.cs:2231 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-269a26c6 | (진입점 미연결) | DMF0022_SalesPlanWaterfall.cs:2234 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0022_SalesPlanWaterfall.GetBizTypebyDivisionAsync

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0662a3f0 | (진입점 미연결) | DMF0022_SalesPlanWaterfall.cs:2243 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION") ⇒ SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-012964d5 | (진입점 미연결) | DMF0022_SalesPlanWaterfall.cs:2244 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-cfcb2abc | (진입점 미연결) | DMF0022_SalesPlanWaterfall.cs:2245 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-bd427fdf | (진입점 미연결) | DMF0022_SalesPlanWaterfall.cs:2248 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0022_SalesPlanWaterfall.GetBucketType

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b9780795 | this.Load [try] | DMF0022_SalesPlanWaterfall.cs:2144 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0003_GET_REPORT_BUCKET_TYPE_CODE") ⇒ DM.DMF0003_GET_REPORT_BUCKET_TYPE_CODE | 엔드포인트 요청 생성 |  |  |  |
| AC-560f53c7 | this.Load [try] | DMF0022_SalesPlanWaterfall.cs:2145 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-cb8ee7ce | this.Load [try] | DMF0022_SalesPlanWaterfall.cs:2148 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0022_SalesPlanWaterfall.GetCustomerbyDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b4c97a9a | (진입점 미연결) | DMF0022_SalesPlanWaterfall.cs:2199 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_CUSTOMER_BY_DIVISION") ⇒ SCM.SCM0001_GET_CUSTOMER_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-4fb174c4 | (진입점 미연결) | DMF0022_SalesPlanWaterfall.cs:2200 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-9132a270 | (진입점 미연결) | DMF0022_SalesPlanWaterfall.cs:2201 |  | DATA_OP | request.Parameters["p_dept_id"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-76342545 | (진입점 미연결) | DMF0022_SalesPlanWaterfall.cs:2202 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-6146a4f0 | (진입점 미연결) | DMF0022_SalesPlanWaterfall.cs:2205 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0022_SalesPlanWaterfall.GetCustomerbyDivisionAsync

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f81e10a7 | (진입점 미연결) | DMF0022_SalesPlanWaterfall.cs:2214 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_CUSTOMER_BY_DIVISION") ⇒ SCM.SCM0001_GET_CUSTOMER_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-ad57e11a | (진입점 미연결) | DMF0022_SalesPlanWaterfall.cs:2215 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-7fc22e78 | (진입점 미연결) | DMF0022_SalesPlanWaterfall.cs:2216 |  | DATA_OP | request.Parameters["p_dept_id"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-afddc0ad | (진입점 미연결) | DMF0022_SalesPlanWaterfall.cs:2217 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-5a1f7b94 | (진입점 미연결) | DMF0022_SalesPlanWaterfall.cs:2220 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0022_SalesPlanWaterfall.GetDataTableMeargeForDate

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-004dc4fa | (진입점 미연결) | DMF0022_SalesPlanWaterfall.cs:2645 |  | CALL_EXT | sv.GetArray | (0, 0, sv.RowCount - 1, sv.ColumnCount - 1) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5b389ca8 | (진입점 미연결) | DMF0022_SalesPlanWaterfall.cs:2662 | for (i < sv.ColumnCount) | DATA_OP | table.Columns.Add | (sFieldName, typeof(decimal)) | 데이터 객체 조작/조회 |  |  |  |
| AC-13693ccb | (진입점 미연결) | DMF0022_SalesPlanWaterfall.cs:2664 |  | DATA_OP | ds2.Tables.Add | (table) | 데이터 객체 조작/조회 |  |  |  |
| AC-1c8a9445 | (진입점 미연결) | DMF0022_SalesPlanWaterfall.cs:2668 |  | DATA_OP | ds.Tables[0].Merge | (ds2.Tables[0]) | 데이터 객체 조작/조회 |  |  |  |
| AC-27790362 | (진입점 미연결) | DMF0022_SalesPlanWaterfall.cs:2672 | if (ds2 != null) | UI_MISC | ds2.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-337422bb | (진입점 미연결) | DMF0022_SalesPlanWaterfall.cs:2674 |  | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## DMF0022_SalesPlanWaterfall.GetDayRange

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c1641896 | this.Load [try] | DMF0022_SalesPlanWaterfall.cs:2107 |  | ENDPOINT | new FoxDataRequest | ("DM.PR_GET_DAY_RANGE") ⇒ DM.PR_GET_DAY_RANGE | 엔드포인트 요청 생성 |  |  |  |
| AC-33549467 | this.Load [try] | DMF0022_SalesPlanWaterfall.cs:2108 |  | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-df9c6cc7 | this.Load [try] | DMF0022_SalesPlanWaterfall.cs:2109 |  | DATA_OP | request.Parameters["p_month"] | 6 | 행/컬럼 값 대입 |  |  |  |
| AC-f4720db0 | this.Load [try] | DMF0022_SalesPlanWaterfall.cs:2111 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a56c9477 | this.Load [try] | DMF0022_SalesPlanWaterfall.cs:2114 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |

## DMF0022_SalesPlanWaterfall.GetItemType

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-129ced9c | this.Load [try] | DMF0022_SalesPlanWaterfall.cs:2157 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_LOOKUP_VALUES") ⇒ SCM.SCM0001_GET_LOOKUP_VALUES | 엔드포인트 요청 생성 |  |  |  |
| AC-19b20884 | this.Load [try] | DMF0022_SalesPlanWaterfall.cs:2158 |  | DATA_OP | request.Parameters["p_lookup_type"] | "ITEM_TYPE_CODE" | 행/컬럼 값 대입 |  |  |  |
| AC-535419c7 | this.Load [try] | DMF0022_SalesPlanWaterfall.cs:2159 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-4210cd91 | this.Load [try] | DMF0022_SalesPlanWaterfall.cs:2162 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0022_SalesPlanWaterfall.GetLastWeekSunDayByDate

진입점: FindButton [try ▸ if (chkMem.Checked == true)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8e65c729 | FindButton [try ▸ if (chkMem.Checked == true)] | DMF0022_SalesPlanWaterfall.cs:2305 |  | RETURN | return sYYYYMMDD; |  | 처리 중단/반환 |  |  |  |

## DMF0022_SalesPlanWaterfall.GetLookupValues

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8c404898 | (진입점 미연결) | DMF0022_SalesPlanWaterfall.cs:2756 |  | ENDPOINT | new FoxDataRequest | ("DM.UP_FX_GetCommonDataList_DM") ⇒ DM.UP_FX_GetCommonDataList_DM | 엔드포인트 요청 생성 |  |  |  |
| AC-f8fe8b18 | (진입점 미연결) | DMF0022_SalesPlanWaterfall.cs:2757 |  | DATA_OP | request.Parameters["CODE"] | p_code | 행/컬럼 값 대입 |  |  |  |
| AC-4a6106d2 | (진입점 미연결) | DMF0022_SalesPlanWaterfall.cs:2758 |  | DATA_OP | request.Parameters["PARAM1"] | p_param1 | 행/컬럼 값 대입 |  |  |  |
| AC-a804e908 | (진입점 미연결) | DMF0022_SalesPlanWaterfall.cs:2759 |  | DATA_OP | request.Parameters["PARAM2"] | p_param2 | 행/컬럼 값 대입 |  |  |  |
| AC-e8b849e6 | (진입점 미연결) | DMF0022_SalesPlanWaterfall.cs:2760 |  | DATA_OP | request.Parameters["PARAM3"] | p_param3 | 행/컬럼 값 대입 |  |  |  |
| AC-cef63129 | (진입점 미연결) | DMF0022_SalesPlanWaterfall.cs:2761 |  | DATA_OP | request.Parameters["PARAM4"] | p_param4 | 행/컬럼 값 대입 |  |  |  |
| AC-a6ebfb44 | (진입점 미연결) | DMF0022_SalesPlanWaterfall.cs:2762 |  | DATA_OP | request.Parameters["PARAM5"] | p_param5 | 행/컬럼 값 대입 |  |  |  |
| AC-9f1f1882 | (진입점 미연결) | DMF0022_SalesPlanWaterfall.cs:2763 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-9805c079 | (진입점 미연결) | DMF0022_SalesPlanWaterfall.cs:2765 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0022_SalesPlanWaterfall.GetPlantSitebyEndCustomer

진입점: this.spdMain.ComboSelChange [if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-56c54f4e | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DMF0022_SalesPlanWaterfall.cs:2075 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER") ⇒ SCM.SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER | 엔드포인트 요청 생성 |  |  |  |
| AC-d33bbcd1 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DMF0022_SalesPlanWaterfall.cs:2076 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-b4e48821 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DMF0022_SalesPlanWaterfall.cs:2077 |  | DATA_OP | request.Parameters["p_dept_id"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-b7d1b3e8 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DMF0022_SalesPlanWaterfall.cs:2078 |  | DATA_OP | request.Parameters["p_end_customer"] | sEdnCustomer | 행/컬럼 값 대입 |  |  |  |
| AC-08d08801 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DMF0022_SalesPlanWaterfall.cs:2079 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f5b93832 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DMF0022_SalesPlanWaterfall.cs:2082 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0022_SalesPlanWaterfall.GetPlantSitebyEndCustomerAsync

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-19fb7da4 | (진입점 미연결) | DMF0022_SalesPlanWaterfall.cs:2091 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER") ⇒ SCM.SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER | 엔드포인트 요청 생성 |  |  |  |
| AC-e9fb9fcd | (진입점 미연결) | DMF0022_SalesPlanWaterfall.cs:2092 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-9ef22f0a | (진입점 미연결) | DMF0022_SalesPlanWaterfall.cs:2093 |  | DATA_OP | request.Parameters["p_dept_id"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-af4d900d | (진입점 미연결) | DMF0022_SalesPlanWaterfall.cs:2094 |  | DATA_OP | request.Parameters["p_end_customer"] | sEdnCustomer | 행/컬럼 값 대입 |  |  |  |
| AC-d661daed | (진입점 미연결) | DMF0022_SalesPlanWaterfall.cs:2095 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e68b95f1 | (진입점 미연결) | DMF0022_SalesPlanWaterfall.cs:2098 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0022_SalesPlanWaterfall.GetQtyData

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-721227ff | this.Load [try] | DMF0022_SalesPlanWaterfall.cs:2257 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0003_GET_QTY_TYPE_CODE") ⇒ DM.DMF0003_GET_QTY_TYPE_CODE | 엔드포인트 요청 생성 |  |  |  |
| AC-8f983b1e | this.Load [try] | DMF0022_SalesPlanWaterfall.cs:2258 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d58ae1cd | this.Load [try] | DMF0022_SalesPlanWaterfall.cs:2261 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0022_SalesPlanWaterfall.GetScmSitebyDivision

진입점: this.spdMain.ComboSelChange [if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-695f0152 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DMF0022_SalesPlanWaterfall.cs:2043 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_SITE_BY_DIVISION") ⇒ SCM.SCM0001_GET_SITE_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-e556c853 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DMF0022_SalesPlanWaterfall.cs:2044 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-91e0fa6b | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DMF0022_SalesPlanWaterfall.cs:2045 |  | DATA_OP | request.Parameters["p_dept_id"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-e6074c48 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DMF0022_SalesPlanWaterfall.cs:2046 |  | DATA_OP | request.Parameters["p_end_customer"] | sEdnCustomer | 행/컬럼 값 대입 |  |  |  |
| AC-91ce852a | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DMF0022_SalesPlanWaterfall.cs:2047 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-6b0c341d | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DMF0022_SalesPlanWaterfall.cs:2050 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0022_SalesPlanWaterfall.GetScmSitebyDivisionAsync

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a5307997 | (진입점 미연결) | DMF0022_SalesPlanWaterfall.cs:2059 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_SITE_BY_DIVISION") ⇒ SCM.SCM0001_GET_SITE_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-509bdb3b | (진입점 미연결) | DMF0022_SalesPlanWaterfall.cs:2060 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-008b563c | (진입점 미연결) | DMF0022_SalesPlanWaterfall.cs:2061 |  | DATA_OP | request.Parameters["p_dept_id"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-9fdbeb81 | (진입점 미연결) | DMF0022_SalesPlanWaterfall.cs:2062 |  | DATA_OP | request.Parameters["p_end_customer"] | sEdnCustomer | 행/컬럼 값 대입 |  |  |  |
| AC-19d85972 | (진입점 미연결) | DMF0022_SalesPlanWaterfall.cs:2063 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-767a2d26 | (진입점 미연결) | DMF0022_SalesPlanWaterfall.cs:2066 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0022_SalesPlanWaterfall.GetSpdTitle

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of ((dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpP…)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of ((dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpP…)] / this.cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if ((fBucket == BucketType.Weekly \|\| fBucket == BucketType.Monthly) && sBucket == BucketType.Daily) ▸ try ▸ else of ((dtSt…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-134c7a29 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0022_SalesPlanWaterfall.cs:2120 |  | FLAG | fBucket | cboBucketType.ControlValues | 화면 필드/플래그 변경 |  |  |  |
| AC-947b2173 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0022_SalesPlanWaterfall.cs:2125 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0022_GET_SPREAD_TITLE") ⇒ DM.DMF0022_GET_SPREAD_TITLE | 엔드포인트 요청 생성 |  |  |  |
| AC-c579481e | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0022_SalesPlanWaterfall.cs:2126 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | sMonth[0] | 행/컬럼 값 대입 |  |  |  |
| AC-39eca5aa | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0022_SalesPlanWaterfall.cs:2127 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | sMonth[1] | 행/컬럼 값 대입 |  |  |  |
| AC-80e3fec1 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0022_SalesPlanWaterfall.cs:2128 |  | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-7e86efbb | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0022_SalesPlanWaterfall.cs:2129 |  | DATA_OP | request.Parameters["p_division_id"] | clbDivision.SelectedValue | 행/컬럼 값 대입 |  |  |  |
| AC-131d4f50 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0022_SalesPlanWaterfall.cs:2131 |  | DATA_OP | request.Parameters["p_bucket"] | fBucket | 행/컬럼 값 대입 |  |  |  |
| AC-958da302 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0022_SalesPlanWaterfall.cs:2133 |  | FLAG | dsSpdTitle | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-c4fccb26 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0022_SalesPlanWaterfall.cs:2133 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-96716ddf | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0022_SalesPlanWaterfall.cs:2136 |  | RETURN | return dsSpdTitle.Tables[0]; |  | 처리 중단/반환 |  |  |  |

## DMF0022_SalesPlanWaterfall.GetTeambyDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2360117c | (진입점 미연결) | DMF0022_SalesPlanWaterfall.cs:2172 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_TEAM_BY_DIVISION") ⇒ SCM.SCM0001_GET_TEAM_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-160edf43 | (진입점 미연결) | DMF0022_SalesPlanWaterfall.cs:2173 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-e4eca2df | (진입점 미연결) | DMF0022_SalesPlanWaterfall.cs:2174 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-baf4d137 | (진입점 미연결) | DMF0022_SalesPlanWaterfall.cs:2177 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0022_SalesPlanWaterfall.GetTeambyDivisionAsync

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eff50b38 | (진입점 미연결) | DMF0022_SalesPlanWaterfall.cs:2186 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_TEAM_BY_DIVISION") ⇒ SCM.SCM0001_GET_TEAM_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-9ceaa23f | (진입점 미연결) | DMF0022_SalesPlanWaterfall.cs:2187 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-3a60d7d2 | (진입점 미연결) | DMF0022_SalesPlanWaterfall.cs:2188 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-ef203232 | (진입점 미연결) | DMF0022_SalesPlanWaterfall.cs:2190 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0022_SalesPlanWaterfall.GetThisWeekMonday

진입점: FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-44e697a5 | FindButton [try] | DMF0022_SalesPlanWaterfall.cs:2282 |  | RETURN | return sYYYYMMDD; |  | 처리 중단/반환 |  |  |  |

## DMF0022_SalesPlanWaterfall.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e7ad117e | this.Load | DMF0022_SalesPlanWaterfall.cs:310 | try | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtMain) | 데이터 객체 조작/조회 |  |  |  |
| AC-fe95b339 | this.Load | DMF0022_SalesPlanWaterfall.cs:313 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-17d3c960 | this.Load | DMF0022_SalesPlanWaterfall.cs:314 | try | FLAG | blnInit | true | 화면 필드/플래그 변경 |  |  |  |
| AC-594b9c8a | this.Load | DMF0022_SalesPlanWaterfall.cs:316 | try | VALUE_SET | drpPeriod.InitValue | GetDayRange() | 컨트롤 값 설정 |  |  |  |
| AC-a45d7d4a | this.Load | DMF0022_SalesPlanWaterfall.cs:324 | try | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-1070a5ca | this.Load | DMF0022_SalesPlanWaterfall.cs:333 | try | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-a05bdbda | this.Load | DMF0022_SalesPlanWaterfall.cs:343 | try ▸ if (sDivision == "40") | LIST_REBIND | clsCtrl.setListBox | (dtBizType, clbBizType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-f63af30c | this.Load | DMF0022_SalesPlanWaterfall.cs:351 | try ▸ if (sDivision == "40") | STATE | lblProject.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-ccaa9d13 | this.Load | DMF0022_SalesPlanWaterfall.cs:352 | try ▸ if (sDivision == "40") | STATE | lblPlantSite.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-a1ad9c10 | this.Load | DMF0022_SalesPlanWaterfall.cs:353 | try ▸ if (sDivision == "40") | STATE | layoutControlItem3.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-5f7f6cf2 | this.Load | DMF0022_SalesPlanWaterfall.cs:354 | try ▸ if (sDivision == "40") | STATE | cboCellQty.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-ddedddbf | this.Load | DMF0022_SalesPlanWaterfall.cs:356 | try ▸ if (sDivision == "40") | VALUE_CLEAR | txtProject.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-9b751cf6 | this.Load | DMF0022_SalesPlanWaterfall.cs:357 | try ▸ if (sDivision == "40") | VALUE_CLEAR | clbPlantSite.ControlValues | "" | 컨트롤 값 비움 |  |  |  |
| AC-51ee65e5 | this.Load | DMF0022_SalesPlanWaterfall.cs:373 | try ▸ else of (sDivision == "40") | LIST_REBIND | clsCtrl.setListBox | (dtBizType, clbBizType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-47b1b7d9 | this.Load | DMF0022_SalesPlanWaterfall.cs:376 | try ▸ else of (sDivision == "40") | STATE | lblProject.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-a0caed89 | this.Load | DMF0022_SalesPlanWaterfall.cs:377 | try ▸ else of (sDivision == "40") | STATE | lblPlantSite.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-24bdc0ab | this.Load | DMF0022_SalesPlanWaterfall.cs:378 | try ▸ else of (sDivision == "40") | STATE | layoutControlItem3.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-93c9665c | this.Load | DMF0022_SalesPlanWaterfall.cs:379 | try ▸ else of (sDivision == "40") | STATE | lblBizType.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-666a6e58 | this.Load | DMF0022_SalesPlanWaterfall.cs:380 | try ▸ else of (sDivision == "40") | STATE | cboCellQty.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-da6cd0af | this.Load | DMF0022_SalesPlanWaterfall.cs:381 | try ▸ else of (sDivision == "40") | VALUE_SET | cboCellQty.Checked | false | 컨트롤 값 설정 |  |  |  |
| AC-9619adc8 | this.Load | DMF0022_SalesPlanWaterfall.cs:384 | try | VALUE_SET | chkMem.Checked | false | 컨트롤 값 설정 |  |  |  |
| AC-26e3421c | this.Load | DMF0022_SalesPlanWaterfall.cs:385 | try | VALUE_SET | chkSum.Checked | false | 컨트롤 값 설정 |  |  |  |
| AC-6b519328 | this.Load | DMF0022_SalesPlanWaterfall.cs:387 | try | LIST_REBIND | clsCtrl.setListBox | (dtEndCustomer, clbCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-ec0a39a9 | this.Load | DMF0022_SalesPlanWaterfall.cs:393 | try | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-1cd3e158 | this.Load | DMF0022_SalesPlanWaterfall.cs:399 | try | LIST_REBIND | clsCtrl.setListBox | (dtPlantSite, clbPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-9e405219 | this.Load | DMF0022_SalesPlanWaterfall.cs:401 | try | FLAG | dtBucketType | GetBucketType() | 화면 필드/플래그 변경 |  |  |  |
| AC-0b98de76 | this.Load | DMF0022_SalesPlanWaterfall.cs:402 | try | LIST_REBIND | clsCtrl.setListBox | (dtBucketType, cboBucketType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-724a9e42 | this.Load | DMF0022_SalesPlanWaterfall.cs:410 | try | FLAG | dtItemType | GetItemType() | 화면 필드/플래그 변경 |  |  |  |
| AC-aa1e63d0 | this.Load | DMF0022_SalesPlanWaterfall.cs:411 | try | LIST_REBIND | clsCtrl.setListBox | (dtItemType, clbItemType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-ab78d43b | this.Load | DMF0022_SalesPlanWaterfall.cs:414 | try | FLAG | dtAmoutKrw | Data.Common(Data.Type.SALES_PLAN_AMOUNT_KRW, false, UserInfoContext.Current["NowGroupID"],… ⇒ biz:CommonData.CommonDataList [code=SALES_PLAN_AMOUNT_KRW] | 화면 필드/플래그 변경 |  |  |  |
| AC-d3c5e920 | this.Load | DMF0022_SalesPlanWaterfall.cs:414 | try | COMBO_DATA | Data.Common | (Data.Type.SALES_PLAN_AMOUNT_KRW, false, UserInfoContext.Current["NowGroupID"], UserInfoCo… ⇒ biz:CommonData.CommonDataList [code=SALES_PLAN_AMOUNT_KRW] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-b6b34a42 | this.Load | DMF0022_SalesPlanWaterfall.cs:415 | try | LIST_REBIND | clsCtrl.setListBox | (dtAmoutKrw, cboKRW, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-0185bffc | this.Load | DMF0022_SalesPlanWaterfall.cs:416 | try | FLAG | dtAmoutUsd | Data.Common(Data.Type.SALES_PLAN_AMOUNT_USD, false, UserInfoContext.Current["NowGroupID"],… ⇒ biz:CommonData.CommonDataList [code=SALES_PLAN_AMOUNT_USD] | 화면 필드/플래그 변경 |  |  |  |
| AC-d43961ab | this.Load | DMF0022_SalesPlanWaterfall.cs:416 | try | COMBO_DATA | Data.Common | (Data.Type.SALES_PLAN_AMOUNT_USD, false, UserInfoContext.Current["NowGroupID"], UserInfoCo… ⇒ biz:CommonData.CommonDataList [code=SALES_PLAN_AMOUNT_USD] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-b00ba328 | this.Load | DMF0022_SalesPlanWaterfall.cs:417 | try | LIST_REBIND | clsCtrl.setListBox | (dtAmoutUsd, cboUSD, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-7dec84ab | this.Load | DMF0022_SalesPlanWaterfall.cs:418 | try | FLAG | dtAmoutLoc | Data.Common(Data.Type.SALES_PLAN_AMOUNT_LOC, false, UserInfoContext.Current["NowGroupID"],… ⇒ biz:CommonData.CommonDataList [code=SALES_PLAN_AMOUNT_LOC] | 화면 필드/플래그 변경 |  |  |  |
| AC-41ab4b6b | this.Load | DMF0022_SalesPlanWaterfall.cs:418 | try | COMBO_DATA | Data.Common | (Data.Type.SALES_PLAN_AMOUNT_LOC, false, UserInfoContext.Current["NowGroupID"], UserInfoCo… ⇒ biz:CommonData.CommonDataList [code=SALES_PLAN_AMOUNT_LOC] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c08d0615 | this.Load | DMF0022_SalesPlanWaterfall.cs:419 | try | LIST_REBIND | clsCtrl.setListBox | (dtAmoutLoc, cboLOC, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-cf688ece | this.Load | DMF0022_SalesPlanWaterfall.cs:422 | try | FLAG | dtQty | GetQtyData() | 화면 필드/플래그 변경 |  |  |  |
| AC-17751d2b | this.Load | DMF0022_SalesPlanWaterfall.cs:423 | try | LIST_REBIND | clsCtrl.setListBox | (dtQty, cboQTY, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-525d0ef8 | this.Load | DMF0022_SalesPlanWaterfall.cs:426 | try | CALL_EXT | toolTip1.SetToolTip | (btnColumn, "Column Show") | ⚠ 의미 확인 필요 |  |  |  |
| AC-7edc5960 | this.Load | DMF0022_SalesPlanWaterfall.cs:427 | try | CALL_EXT | toolTip1.SetToolTip | (btnMeasure, "Measure") | ⚠ 의미 확인 필요 |  |  |  |
| AC-217161ce | this.Load | DMF0022_SalesPlanWaterfall.cs:432 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |
| AC-ca31f145 | this.Load | DMF0022_SalesPlanWaterfall.cs:436 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-c3d6d50e | this.Load | DMF0022_SalesPlanWaterfall.cs:437 | finally | FLAG | blnInit | false | 화면 필드/플래그 변경 |  |  |  |

## DMF0022_SalesPlanWaterfall.InitSpread

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)] / this.cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if ((fBucket == BucketType.Weekly \|\| fBucket == BucketType.Monthly) && sBucket == BucketType.Daily)] / this.Load / this.clbDivision.SelectedIndexChanged [try] / FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b8713659 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0022_SalesPlanWaterfall.cs:490 | try ▸ if ((dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpP…) | CALL_EXT | siMain.RemoveRowAll | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-0db4b180 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0022_SalesPlanWaterfall.cs:495 | try ▸ else of ((dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpP…) | FLAG | dtStartPeriod | drpPeriod.Value1 | 화면 필드/플래그 변경 |  |  |  |
| AC-23b06812 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0022_SalesPlanWaterfall.cs:496 | try ▸ else of ((dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpP…) | FLAG | dtEndPeriod | drpPeriod.Value2 | 화면 필드/플래그 변경 |  |  |  |
| AC-dd650d82 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0022_SalesPlanWaterfall.cs:500 | try ▸ else of ((dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpP…) | GRID_INIT | siMain.CreateSheetHeaderColumn | (siMain, 3, dtTitle) | 그리드 재구성/초기화 |  |  |  |
| AC-9bbae544 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0022_SalesPlanWaterfall.cs:506 | try ▸ else of ((dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpP…) ▸ … | STATE | chkSum.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-1f25163a | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0022_SalesPlanWaterfall.cs:507 | try ▸ else of ((dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpP…) ▸ … | VALUE_SET | chkSum.Checked | false | 컨트롤 값 설정 |  |  |  |
| AC-e16f6f93 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0022_SalesPlanWaterfall.cs:513 | try ▸ else of ((dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpP…) ▸ … | STATE | chkSum.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-cbc44e24 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0022_SalesPlanWaterfall.cs:525 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |

## DMF0022_SalesPlanWaterfall.InitSpreadFooterSum

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of ((dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpP…)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of ((dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpP…)] / this.cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if ((fBucket == BucketType.Weekly \|\| fBucket == BucketType.Monthly) && sBucket == BucketType.Daily) ▸ try ▸ else of ((dtSt…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a8e74b0a | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0022_SalesPlanWaterfall.cs:536 |  | GRID_SET | siMain.ActiveSheet.ColumnFooter.Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-18f841e5 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0022_SalesPlanWaterfall.cs:537 |  | GRID_SET | siMain.ActiveSheet.ColumnFooter.Cells[0, 1].Value | "Sum" | 그리드 속성/값 설정 |  |  |  |
| AC-909394c2 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0022_SalesPlanWaterfall.cs:544 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("M_") == … | CALL_EXT | siMain.ActiveSheet.ColumnFooter.SetAggregationFormat | (0, iCol, "{0:#,##0.###}") | ⚠ 의미 확인 필요 |  |  |  |
| AC-d89c5a9c | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0022_SalesPlanWaterfall.cs:545 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("M_") == … | CALL_EXT | siMain.ActiveSheet.ColumnFooter.SetAggregationType | (0, iCol, FarPoint.Win.Spread.Model.AggregationType.SumIgnoreHidden) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9f4b7025 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0022_SalesPlanWaterfall.cs:546 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("M_") == … | GRID_SET | siMain.ActiveSheet.ColumnFooter.Cells[0, iCol].BackColor | Color.LightGray | 그리드 속성/값 설정 |  |  |  |
| AC-96f52275 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0022_SalesPlanWaterfall.cs:547 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("M_") == … | GRID_SET | siMain.ActiveSheet.ColumnFooter.Cells[0, iCol].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |

## DMF0022_SalesPlanWaterfall.SetAmountCalculating

진입점: this.cboLOC.SelectedIndexChanged / this.cboKRW.SelectedIndexChanged / this.cboUSD.SelectedIndexChanged / this.cboQTY.SelectedIndexChanged / cboKRW.SelectedIndexChanged / cboUSD.SelectedIndexChanged / cboLOC.SelectedIndexChanged / FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5297168b | this.cboLOC.SelectedIndexChanged 외 7 | DMF0022_SalesPlanWaterfall.cs:2367 | if (siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e0804e05 | this.cboLOC.SelectedIndexChanged 외 7 | DMF0022_SalesPlanWaterfall.cs:2371 | if (dsOrigianlCopy == null) | FLAG | dsOrigianlCopy | siMain.SpreadObject.DataSource as DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-153d3a4b | this.cboLOC.SelectedIndexChanged 외 7 | DMF0022_SalesPlanWaterfall.cs:2377 | if (cboKRW.SelectedIndex == 0 && cboUSD.SelectedIndex == 0 && cboLOC.SelectedIndex == 0 && cboQTY.SelectedIndex == 0) | LIST_BIND | siMain.SpreadObject.DataSource | dsOrigianlCopy | 목록/그리드 데이터 원천 연결 |  |  |  |
| AC-a979948a | this.cboLOC.SelectedIndexChanged 외 7 | DMF0022_SalesPlanWaterfall.cs:2378 | if (cboKRW.SelectedIndex == 0 && cboUSD.SelectedIndex == 0 && cboLOC.SelectedIndex == 0 && cboQTY.SelectedIndex == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ddb23ddd | this.cboLOC.SelectedIndexChanged 외 7 | DMF0022_SalesPlanWaterfall.cs:2381 |  | DATA_OP | dsOrigianlCopy.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-43fde94d | this.cboLOC.SelectedIndexChanged 외 7 | DMF0022_SalesPlanWaterfall.cs:2383 |  | DATA_OP | dsKrw.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-0464b86e | this.cboLOC.SelectedIndexChanged 외 7 | DMF0022_SalesPlanWaterfall.cs:2562 | for (i < dsOrigianlCopy.Tables[0].Rows.Count) ▸ for (j < dsKrw.Tables[0].Columns.Count) ▸ if (dsKrw.Tables[0].Columns[j].ColumnName.IndexOf(… | GRID_SET | dsKrw.Tables[0].Rows[i][j] | Math.Round(Convert.ToDouble(slValue) / dbKrwDivideAmount, 2) | 그리드 속성/값 설정 |  |  |  |
| AC-205e89ea | this.cboLOC.SelectedIndexChanged 외 7 | DMF0022_SalesPlanWaterfall.cs:2564 | for (i < dsOrigianlCopy.Tables[0].Rows.Count) ▸ for (j < dsKrw.Tables[0].Columns.Count) ▸ if (dsKrw.Tables[0].Columns[j].ColumnName.IndexOf(… | GRID_SET | dsKrw.Tables[0].Rows[i][j] | Math.Round(Convert.ToDouble(slValue) / dbUsdDivideAmount, 2) | 그리드 속성/값 설정 |  |  |  |
| AC-93f470cb | this.cboLOC.SelectedIndexChanged 외 7 | DMF0022_SalesPlanWaterfall.cs:2566 | for (i < dsOrigianlCopy.Tables[0].Rows.Count) ▸ for (j < dsKrw.Tables[0].Columns.Count) ▸ if (dsKrw.Tables[0].Columns[j].ColumnName.IndexOf(… | GRID_SET | dsKrw.Tables[0].Rows[i][j] | Math.Round(Convert.ToDouble(slValue) / dbLocDivideAmount, 2) | 그리드 속성/값 설정 |  |  |  |
| AC-0bff46fb | this.cboLOC.SelectedIndexChanged 외 7 | DMF0022_SalesPlanWaterfall.cs:2571 | for (i < dsOrigianlCopy.Tables[0].Rows.Count) ▸ for (j < dsKrw.Tables[0].Columns.Count) ▸ if (dsKrw.Tables[0].Columns[j].ColumnName.IndexOf(… | GRID_SET | dsKrw.Tables[0].Rows[i][j] | Math.Round(Convert.ToDouble(slValue) / dbQtyDivideAmount, 2) | 그리드 속성/값 설정 |  |  |  |
| AC-e0dfd162 | this.cboLOC.SelectedIndexChanged 외 7 | DMF0022_SalesPlanWaterfall.cs:2577 |  | DATA_OP | dsKrw.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-4a2e4b2b | this.cboLOC.SelectedIndexChanged 외 7 | DMF0022_SalesPlanWaterfall.cs:2583 | if (ds != null) | UI_MISC | ds.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-31d2efd1 | this.cboLOC.SelectedIndexChanged 외 7 | DMF0022_SalesPlanWaterfall.cs:2587 |  | LIST_BIND | siMain.SpreadObject.DataSource | dsKrw | 목록/그리드 데이터 원천 연결 |  |  |  |
| AC-b85efeaa | this.cboLOC.SelectedIndexChanged 외 7 | DMF0022_SalesPlanWaterfall.cs:2591 | if (dsKrw != null) | UI_MISC | dsKrw.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-9d12d75d | this.cboLOC.SelectedIndexChanged 외 7 | DMF0022_SalesPlanWaterfall.cs:2594 |  | CALL_EXT | GC.Collect | () | ⚠ 의미 확인 필요 |  |  |  |

## DMF0022_SalesPlanWaterfall.SetChangeControl

진입점: this.clbCustomer.SelectedIndexChanged / this.clbTeam.SelectedIndexChanged [if (sDivision == "40")] / this.Load [try] / this.clbDivision.SelectedIndexChanged [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-03a484a1 | this.clbCustomer.SelectedIndexChanged 외 3 | DMF0022_SalesPlanWaterfall.cs:243 |  | DATA_OP | Filter["GROUP_ID"] | UserInfoContext.Current["NowGroupID"] | 행/컬럼 값 대입 |  |  |  |
| AC-033db440 | this.clbCustomer.SelectedIndexChanged 외 3 | DMF0022_SalesPlanWaterfall.cs:244 |  | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-e9cf468d | this.clbCustomer.SelectedIndexChanged 외 3 | DMF0022_SalesPlanWaterfall.cs:250 | switch (triggerControl) case "MyDivision": | FLAG | dtDivision | DataService.GetDMInnerTable("MyDivision", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-bce3a0cf | this.clbCustomer.SelectedIndexChanged 외 3 | DMF0022_SalesPlanWaterfall.cs:250 | switch (triggerControl) case "MyDivision": | COMBO_DATA | DataService.GetDMInnerTable | ("MyDivision", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-bce4ae2e | this.clbCustomer.SelectedIndexChanged 외 3 | DMF0022_SalesPlanWaterfall.cs:255 | switch (triggerControl) case "UserTeamByDivision": | DATA_OP | Filter["DIVISION_ID"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-06744776 | this.clbCustomer.SelectedIndexChanged 외 3 | DMF0022_SalesPlanWaterfall.cs:257 | switch (triggerControl) case "UserTeamByDivision": | FLAG | dtTeam | DataService.GetDMInnerTable("UserTeamByDivision", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-84e187c0 | this.clbCustomer.SelectedIndexChanged 외 3 | DMF0022_SalesPlanWaterfall.cs:257 | switch (triggerControl) case "UserTeamByDivision": | COMBO_DATA | DataService.GetDMInnerTable | ("UserTeamByDivision", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-10c7902a | this.clbCustomer.SelectedIndexChanged 외 3 | DMF0022_SalesPlanWaterfall.cs:262 | switch (triggerControl) case "EndCustomerByDivision": | DATA_OP | Filter["DIVISION_ID"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-1aa3e332 | this.clbCustomer.SelectedIndexChanged 외 3 | DMF0022_SalesPlanWaterfall.cs:263 | switch (triggerControl) case "EndCustomerByDivision": | DATA_OP | Filter["DEPT_ID"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-e7d948de | this.clbCustomer.SelectedIndexChanged 외 3 | DMF0022_SalesPlanWaterfall.cs:265 | switch (triggerControl) case "EndCustomerByDivision": | FLAG | dtEndCustomer | DataService.GetDMInnerTable("EndCustomerByDivision", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-58674a3a | this.clbCustomer.SelectedIndexChanged 외 3 | DMF0022_SalesPlanWaterfall.cs:265 | switch (triggerControl) case "EndCustomerByDivision": | COMBO_DATA | DataService.GetDMInnerTable | ("EndCustomerByDivision", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-fd321fee | this.clbCustomer.SelectedIndexChanged 외 3 | DMF0022_SalesPlanWaterfall.cs:270 | switch (triggerControl) case "BizType": | DATA_OP | Filter["DIVISION_ID"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-6ca972cd | this.clbCustomer.SelectedIndexChanged 외 3 | DMF0022_SalesPlanWaterfall.cs:272 | switch (triggerControl) case "BizType": | FLAG | dtBizType | DataService.GetDMInnerTable("BizType", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-1d1c191b | this.clbCustomer.SelectedIndexChanged 외 3 | DMF0022_SalesPlanWaterfall.cs:272 | switch (triggerControl) case "BizType": | COMBO_DATA | DataService.GetDMInnerTable | ("BizType", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-1ee382a1 | this.clbCustomer.SelectedIndexChanged 외 3 | DMF0022_SalesPlanWaterfall.cs:277 | switch (triggerControl) case "UserSiteByEndCustomer": | DATA_OP | Filter["DIVISION_ID"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-fa384341 | this.clbCustomer.SelectedIndexChanged 외 3 | DMF0022_SalesPlanWaterfall.cs:278 | switch (triggerControl) case "UserSiteByEndCustomer": | DATA_OP | Filter["DEPT_ID"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-14f4f14e | this.clbCustomer.SelectedIndexChanged 외 3 | DMF0022_SalesPlanWaterfall.cs:279 | switch (triggerControl) case "UserSiteByEndCustomer": | DATA_OP | Filter["END_CUSTOMER"] | sEndCustomer | 행/컬럼 값 대입 |  |  |  |
| AC-d7462685 | this.clbCustomer.SelectedIndexChanged 외 3 | DMF0022_SalesPlanWaterfall.cs:281 | switch (triggerControl) case "UserSiteByEndCustomer": | FLAG | dtSalesSite | DataService.GetDMInnerTable("UserSiteByEndCustomer", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-ba45369b | this.clbCustomer.SelectedIndexChanged 외 3 | DMF0022_SalesPlanWaterfall.cs:281 | switch (triggerControl) case "UserSiteByEndCustomer": | COMBO_DATA | DataService.GetDMInnerTable | ("UserSiteByEndCustomer", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-a15c545c | this.clbCustomer.SelectedIndexChanged 외 3 | DMF0022_SalesPlanWaterfall.cs:286 | switch (triggerControl) case "UserPlantSiteByEndCustomer": | DATA_OP | Filter["DIVISION_ID"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-a6f94919 | this.clbCustomer.SelectedIndexChanged 외 3 | DMF0022_SalesPlanWaterfall.cs:287 | switch (triggerControl) case "UserPlantSiteByEndCustomer": | DATA_OP | Filter["END_CUSTOMER"] | sEndCustomer | 행/컬럼 값 대입 |  |  |  |
| AC-b0a59688 | this.clbCustomer.SelectedIndexChanged 외 3 | DMF0022_SalesPlanWaterfall.cs:289 | switch (triggerControl) case "UserPlantSiteByEndCustomer": | FLAG | dtPlantSite | DataService.GetDMInnerTable("UserPlantSiteByEndCustomer", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-4cb3d44b | this.clbCustomer.SelectedIndexChanged 외 3 | DMF0022_SalesPlanWaterfall.cs:289 | switch (triggerControl) case "UserPlantSiteByEndCustomer": | COMBO_DATA | DataService.GetDMInnerTable | ("UserPlantSiteByEndCustomer", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-59bb3288 | this.clbCustomer.SelectedIndexChanged 외 3 | DMF0022_SalesPlanWaterfall.cs:294 | switch (triggerControl) case "UserPlantSiteByDivision": | DATA_OP | Filter["DIVISION_ID"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-37e81582 | this.clbCustomer.SelectedIndexChanged 외 3 | DMF0022_SalesPlanWaterfall.cs:296 | switch (triggerControl) case "UserPlantSiteByDivision": | FLAG | dtPlantSiteByDivision | DataService.GetDMInnerTable("UserPlantSiteByDivision", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-08609298 | this.clbCustomer.SelectedIndexChanged 외 3 | DMF0022_SalesPlanWaterfall.cs:296 | switch (triggerControl) case "UserPlantSiteByDivision": | COMBO_DATA | DataService.GetDMInnerTable | ("UserPlantSiteByDivision", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |

## DMF0022_SalesPlanWaterfall.SetSpreadColumn

진입점: this.chkMem.CheckedChanged [if (siMain != null)] / this.chkSum.CheckedChanged [if (siMain != null)] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of ((dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpP…)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of ((dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpP…)] / this.cboBucketType.SelectedIndexChanged [if (siMain != null)] / this.Load [try ▸ else…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-81af2009 | this.chkMem.CheckedChanged [if (siMain != null)] 외 7 | DMF0022_SalesPlanWaterfall.cs:1977 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siMain.GetColumnTag(iCol).IndexOf("D_"… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-c28110a0 | this.chkMem.CheckedChanged [if (siMain != null)] 외 7 | DMF0022_SalesPlanWaterfall.cs:1980 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siMain.GetColumnTag(iCol).IndexOf("M_"… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-ad4b7add | this.chkMem.CheckedChanged [if (siMain != null)] 외 7 | DMF0022_SalesPlanWaterfall.cs:1985 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Bu… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-99df1461 | this.chkMem.CheckedChanged [if (siMain != null)] 외 7 | DMF0022_SalesPlanWaterfall.cs:1987 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Bu… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-61f0f635 | this.chkMem.CheckedChanged [if (siMain != null)] 외 7 | DMF0022_SalesPlanWaterfall.cs:1990 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Bu… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-8ddfeffb | this.chkMem.CheckedChanged [if (siMain != null)] 외 7 | DMF0022_SalesPlanWaterfall.cs:1995 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboBucketType.ControlValues … | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-4f9d374b | this.chkMem.CheckedChanged [if (siMain != null)] 외 7 | DMF0022_SalesPlanWaterfall.cs:1997 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboBucketType.ControlValues … | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-b2917a0a | this.chkMem.CheckedChanged [if (siMain != null)] 외 7 | DMF0022_SalesPlanWaterfall.cs:2006 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (chkMem.Checked == false) ▸ if (siMain.GetColumnTag(iCol).IndexOf("M_") == 0) ▸ if (siMain.Get… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Columns[iCol].ForeColor | Color.Green | 그리드 속성/값 설정 |  |  |  |
| AC-375450f7 | this.chkMem.CheckedChanged [if (siMain != null)] 외 7 | DMF0022_SalesPlanWaterfall.cs:2007 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (chkMem.Checked == false) ▸ if (siMain.GetColumnTag(iCol).IndexOf("M_") == 0) ▸ if (siMain.Get… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Columns[iCol].Font | new System.Drawing.Font("굴림", 9F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUn… | 그리드 속성/값 설정 |  |  |  |
| AC-ce97b6c4 | this.chkMem.CheckedChanged [if (siMain != null)] 외 7 | DMF0022_SalesPlanWaterfall.cs:2008 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (chkMem.Checked == false) ▸ if (siMain.GetColumnTag(iCol).IndexOf("M_") == 0) ▸ if (siMain.Get… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Columns[iCol].Width | 60 | 그리드 속성/값 설정 |  |  |  |
| AC-e86faac8 | this.chkMem.CheckedChanged [if (siMain != null)] 외 7 | DMF0022_SalesPlanWaterfall.cs:2015 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (chkMem.Checked == false) ▸ else of (siMain.GetColumnTag(iCol).IndexOf("M_") == 0) ▸ if (siMai… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Columns[iCol].ForeColor | Color.Green | 그리드 속성/값 설정 |  |  |  |
| AC-d496c59f | this.chkMem.CheckedChanged [if (siMain != null)] 외 7 | DMF0022_SalesPlanWaterfall.cs:2016 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (chkMem.Checked == false) ▸ else of (siMain.GetColumnTag(iCol).IndexOf("M_") == 0) ▸ if (siMai… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Columns[iCol].Font | new System.Drawing.Font("굴림", 9F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUn… | 그리드 속성/값 설정 |  |  |  |
| AC-57417c36 | this.chkMem.CheckedChanged [if (siMain != null)] 외 7 | DMF0022_SalesPlanWaterfall.cs:2023 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (chkMem.Checked == false) ▸ else of (siMain.GetColumnTag(iCol).IndexOf("M_") == 0) ▸ if (siMai… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Columns[iCol].ForeColor | Color.Green | 그리드 속성/값 설정 |  |  |  |
| AC-0f804129 | this.chkMem.CheckedChanged [if (siMain != null)] 외 7 | DMF0022_SalesPlanWaterfall.cs:2024 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (chkMem.Checked == false) ▸ else of (siMain.GetColumnTag(iCol).IndexOf("M_") == 0) ▸ if (siMai… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Columns[iCol].Font | new System.Drawing.Font("굴림", 9F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUn… | 그리드 속성/값 설정 |  |  |  |
| AC-6411b0d8 | this.chkMem.CheckedChanged [if (siMain != null)] 외 7 | DMF0022_SalesPlanWaterfall.cs:2031 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (chkMem.Checked == false) ▸ if (chkMem.Checked == true) | GRID_STYLE | siMain.ActiveSheet.ColumnHeader.Columns[iCol].ResetForeColor | () | 그리드 표시 설정 |  |  |  |
| AC-e050f7fa | this.chkMem.CheckedChanged [if (siMain != null)] 외 7 | DMF0022_SalesPlanWaterfall.cs:2032 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (chkMem.Checked == false) ▸ if (chkMem.Checked == true) | CALL_EXT | siMain.ActiveSheet.ColumnHeader.Columns[iCol].ResetFont | () | ⚠ 의미 확인 필요 |  |  |  |

## DMF0022_SalesPlanWaterfall.SetSpreadHeader

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of ((dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpP…) ▸ if (cboBucketType.ControlValues == BucketType.ONLY_WEEKLY)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of ((dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpP…) ▸ if (cboBucketType.ControlValues == BucketType.ONLY_WEEKLY)] / this.cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fe4fa5de | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0022_SalesPlanWaterfall.cs:1945 | foreach (DataRow dr in dt.Rows) ▸ if (iCellCnt < iStartCol) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iCellCnt, 3, 1, 20, sColumnLabel, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e22033fa | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0022_SalesPlanWaterfall.cs:1953 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt < iStartCol) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, iStartCol, 0, iStartCol].Text | sLargeLabelName | 그리드 속성/값 설정 |  |  |  |
| AC-04d49b6a | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0022_SalesPlanWaterfall.cs:1954 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt < iStartCol) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[1, iStartCol, 1, iStartCol].Text | sSmallLabelName | 그리드 속성/값 설정 |  |  |  |
| AC-be5a1003 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0022_SalesPlanWaterfall.cs:1955 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt < iStartCol) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[2, iStartCol, 2, iStartCol].Text | "SUM" | 그리드 속성/값 설정 |  |  |  |
| AC-5a229d70 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0022_SalesPlanWaterfall.cs:1960 |  | GRID_INIT | siMain.Freeze | (0, siMain.GetColumnIndex(DefColumns.MEASURE) + 1) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-cbc9bdfb | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0022_SalesPlanWaterfall.cs:1961 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0022_SalesPlanWaterfall.SetSpreadHeaderSpan

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of ((dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpP…) ▸ else of (cboBucketType.ControlValues == BucketType.ONLY_WEEKLY)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of ((dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpP…) ▸ else of (cboBucketType.ControlValues == BucketType.ONLY_WEEKLY)] / this.cboBucketType.SelectedIndexChanged [if (siMain != …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e30cfd5d | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0022_SalesPlanWaterfall.cs:1869 | foreach (DataRow dr in dt.Rows) ▸ if (iCellCnt <= iSmallStartCol) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iCellCnt, 3, 1, 20, sColumnLabel, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9b0daf32 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0022_SalesPlanWaterfall.cs:1877 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (dr[DefColumns.ColumnName].ToString().IndexOf("B_") > 0) | GRID_INIT | siMain.VisibleColumns | (iCellCnt, false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-b22d2dd5 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0022_SalesPlanWaterfall.cs:1887 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ else of (dr[DefColumns.ColumnName].ToString().IndexOf("B_") > 0) ▸ … | GRID_SET | siMain.Sheet().ColumnHeader.Cells[2, iCellCnt].ForeColor | dr[DefColumns.DayCode].ToString() == DefColumnsLabel.Saturday ? Color.Blue : Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-f897c554 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0022_SalesPlanWaterfall.cs:1893 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1c6cf6d8 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0022_SalesPlanWaterfall.cs:1894 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-43ec3d81 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0022_SalesPlanWaterfall.cs:1899 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e12fb95e | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0022_SalesPlanWaterfall.cs:1900 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 30, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ab5c4999 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0022_SalesPlanWaterfall.cs:1907 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName !=… | GRID_INIT | siMain.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-cc6f0ea7 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0022_SalesPlanWaterfall.cs:1908 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName !=… | GRID_INIT | siMain.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b13187d2 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0022_SalesPlanWaterfall.cs:1919 |  | GRID_INIT | siMain.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3fd3fce0 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0022_SalesPlanWaterfall.cs:1920 |  | GRID_INIT | siMain.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1e7e7b1f | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0022_SalesPlanWaterfall.cs:1921 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f675f82b | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0022_SalesPlanWaterfall.cs:1922 |  | GRID_INIT | siMain.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5f385768 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0022_SalesPlanWaterfall.cs:1924 |  | GRID_INIT | siMain.Freeze | (0, siMain.GetColumnIndex(DefColumns.MEASURE) + 1) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-5b3f05e3 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0022_SalesPlanWaterfall.cs:1926 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0022_SalesPlanWaterfall.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4ded7bf7 | this.spdMain.CellDoubleClick | DMF0022_SalesPlanWaterfall.cs:1709 | if (e.ColumnHeader) ▸ if (siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColum… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | !siMain.ActiveSheet.Columns[iCol].Visible | 그리드 속성/값 설정 |  |  |  |
| AC-90d4c12d | this.spdMain.CellDoubleClick | DMF0022_SalesPlanWaterfall.cs:1715 | if (e.ColumnHeader) ▸ if (siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (siMain.Get… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | !siMain.ActiveSheet.Columns[iCol].Visible | 그리드 속성/값 설정 |  |  |  |
| AC-45d2889b | this.spdMain.CellDoubleClick | DMF0022_SalesPlanWaterfall.cs:1721 | if (e.ColumnHeader) ▸ if (siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (siMain.Get… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | !siMain.ActiveSheet.Columns[iCol].Visible | 그리드 속성/값 설정 |  |  |  |
| AC-fcc0285b | this.spdMain.CellDoubleClick | DMF0022_SalesPlanWaterfall.cs:1735 | if (e.ColumnHeader) ▸ else of (siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ▸ if (siMain.GetColumnTag(e.Column).IndexOf("W_") == 0) ▸ f… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | !siMain.ActiveSheet.Columns[iCol].Visible | 그리드 속성/값 설정 |  |  |  |
| AC-736d5864 | this.spdMain.CellDoubleClick | DMF0022_SalesPlanWaterfall.cs:1746 | else of (e.ColumnHeader) ▸ if (siMain.IsLock(siMain.SheetName) \|\| siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) !… | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DMF0022_SalesPlanWaterfall.spdMain_ComboSelChange

진입점: this.spdMain.ComboSelChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a99319d8 | this.spdMain.ComboSelChange | DMF0022_SalesPlanWaterfall.cs:1692 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | FLAG | dtSalesSite | GetScmSitebyDivision(siMain.GetValue(e.Row, e.Column).ToString(), CAppSetting.StringALL, C… | 화면 필드/플래그 변경 |  |  |  |
| AC-36937a79 | this.spdMain.ComboSelChange | DMF0022_SalesPlanWaterfall.cs:1693 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), dtSalesSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-1b6bec12 | this.spdMain.ComboSelChange | DMF0022_SalesPlanWaterfall.cs:1695 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | FLAG | dtPlantSite | GetPlantSitebyEndCustomer(siMain.GetValue(e.Row, e.Column).ToString(), CAppSetting.StringA… | 화면 필드/플래그 변경 |  |  |  |
| AC-ab445c9a | this.spdMain.ComboSelChange | DMF0022_SalesPlanWaterfall.cs:1696 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), dtPlantSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |

## DMF0022_SalesPlanWaterfall.spdMain_KeyUp

진입점: this.spdMain.KeyUp

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-44d49992 | this.spdMain.KeyUp | DMF0022_SalesPlanWaterfall.cs:1759 | if (siMain.GetColumnIndex(DefColumns.MEASURE) >= siMain.ActiveColumnIndex) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5ac4a856 | this.spdMain.KeyUp | DMF0022_SalesPlanWaterfall.cs:1762 | if (e.Control == true && e.KeyCode == Keys.V \|\| e.Control == false && e.KeyCode == Keys.V) | CALL_EXT | spdMain.ActiveSheet.ClipboardPaste | (ClipboardPasteOptions.AsStringSkipHidden) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b8cfe444 | this.spdMain.KeyUp | DMF0022_SalesPlanWaterfall.cs:1766 | if (e.Control == true && e.KeyCode == Keys.C \|\| e.Control == false && e.KeyCode == Keys.C) | CALL_EXT | Clipboard.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-e6832c34 | this.spdMain.KeyUp | DMF0022_SalesPlanWaterfall.cs:1767 | if (e.Control == true && e.KeyCode == Keys.C \|\| e.Control == false && e.KeyCode == Keys.C) | CALL_EXT | spdMain.Sheets[0].ClipboardCopy | (ClipboardCopyOptions.AsStringSkipHidden) | ⚠ 의미 확인 필요 |  |  |  |

## DMF0022_SalesPlanWaterfall.spdMain_TopChange

진입점: this.spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cdfac18a | this.spdMain.TopChange | DMF0022_SalesPlanWaterfall.cs:1753 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0022_SalesPlanWaterfall2.btnColumn_Click

진입점: this.btnColumn.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c87fc2be | this.btnColumn.Click | DMF0022_SalesPlanWaterfall2.cs:1499 |  | POPUP | new DM0002_TitleSetForm_Popup | (sProgram_Id, SpdSheet.shtMain, true, clbDivision.ControlValues) | 팝업/폼 생성 |  |  |  |
| AC-eb1a6439 | this.btnColumn.Click | DMF0022_SalesPlanWaterfall2.cs:1500 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-d17496c1 | this.btnColumn.Click | DMF0022_SalesPlanWaterfall2.cs:1501 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## DMF0022_SalesPlanWaterfall2.btnItemId_Click

진입점: this.btnItemId.Click / this.txtItemId.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3c0ee1a3 | this.btnItemId.Click 외 1 | DMF0022_SalesPlanWaterfall2.cs:1487 |  | POPUP | new DM0002_ItembyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-1cd7d0eb | this.btnItemId.Click 외 1 | DMF0022_SalesPlanWaterfall2.cs:1489 |  | POPUP | popItem.Form_Load | (true, sDivision, sTeam, sEndCustomer, sScmSiteId, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-28ec39a7 | this.btnItemId.Click 외 1 | DMF0022_SalesPlanWaterfall2.cs:1490 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-37f0bc46 | this.btnItemId.Click 외 1 | DMF0022_SalesPlanWaterfall2.cs:1491 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-d498612b | this.btnItemId.Click 외 1 | DMF0022_SalesPlanWaterfall2.cs:1493 |  | VALUE_SET | txtItemId.Text | popItem.ItemID | 컨트롤 값 설정 |  |  |  |

## DMF0022_SalesPlanWaterfall2.btnMeasure_Click

진입점: this.btnMeasure.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d4c02dfa | this.btnMeasure.Click | DMF0022_SalesPlanWaterfall2.cs:1512 |  | POPUP | new DM0002_TitleSetForm_Popup | (sProgram_Id, SpdSheet.shtMain, false, clbDivision.ControlValues) | 팝업/폼 생성 |  |  |  |
| AC-4372ee72 | this.btnMeasure.Click | DMF0022_SalesPlanWaterfall2.cs:1513 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-5b62567a | this.btnMeasure.Click | DMF0022_SalesPlanWaterfall2.cs:1514 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## DMF0022_SalesPlanWaterfall2.btnOwner_Click

진입점: this.usrButton1.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-33ed0f3a | this.usrButton1.Click | DMF0022_SalesPlanWaterfall2.cs:2415 |  | POPUP | new DM0020_OwnerbyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-669d2b07 | this.usrButton1.Click | DMF0022_SalesPlanWaterfall2.cs:2418 |  | POPUP | popItem.Form_Load | (true, sDivision, sTeam, sEndCustomer, sScmSiteId, sProject, sItemId, sOwner) | 팝업 초기화(인자 전달) |  |  |  |
| AC-6fc40108 | this.usrButton1.Click | DMF0022_SalesPlanWaterfall2.cs:2419 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-ed548b15 | this.usrButton1.Click | DMF0022_SalesPlanWaterfall2.cs:2420 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-3629a495 | this.usrButton1.Click | DMF0022_SalesPlanWaterfall2.cs:2422 |  | VALUE_SET | txtOwner.Text | popItem.OwnerID | 컨트롤 값 설정 |  |  |  |

## DMF0022_SalesPlanWaterfall2.btnProject_Click

진입점: this.btnProject.Click / this.txtProject.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d579b450 | this.btnProject.Click 외 1 | DMF0022_SalesPlanWaterfall2.cs:1468 |  | POPUP | new SCM0002_ProjectbyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-edf552d8 | this.btnProject.Click 외 1 | DMF0022_SalesPlanWaterfall2.cs:1469 |  | POPUP | popProject.Form_Load | (true, sDivision, sTeam, sEndCustomer, sScmSite, sProject) | 팝업 초기화(인자 전달) |  |  |  |
| AC-8332763d | this.btnProject.Click 외 1 | DMF0022_SalesPlanWaterfall2.cs:1470 |  | UI_PROP | popProject.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-3fc6143f | this.btnProject.Click 외 1 | DMF0022_SalesPlanWaterfall2.cs:1471 |  | POPUP | popProject.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-2389dda3 | this.btnProject.Click 외 1 | DMF0022_SalesPlanWaterfall2.cs:1473 |  | VALUE_SET | txtProject.Text | popProject.ProjectCode | 컨트롤 값 설정 |  |  |  |

## DMF0022_SalesPlanWaterfall2.btnVersion_Click

진입점: this.btnVersion.Click / this.txtVersion.KeyDown

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eda8b393 | this.btnVersion.Click 외 1 | DMF0022_SalesPlanWaterfall2.cs:2374 |  | POPUP | new SCM0002_VersionByWaterfallPopup | () | 팝업/폼 생성 |  |  |  |
| AC-c7925acd | this.btnVersion.Click 외 1 | DMF0022_SalesPlanWaterfall2.cs:2375 |  | POPUP | popVersion.Form_Load | (true, "SP", sDivision, sStartTime, sEndTinme) | 팝업 초기화(인자 전달) |  |  |  |
| AC-ef591974 | this.btnVersion.Click 외 1 | DMF0022_SalesPlanWaterfall2.cs:2376 |  | UI_PROP | popVersion.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-74dd172d | this.btnVersion.Click 외 1 | DMF0022_SalesPlanWaterfall2.cs:2377 |  | POPUP | popVersion.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-26c080ae | this.btnVersion.Click 외 1 | DMF0022_SalesPlanWaterfall2.cs:2381 | if (popVersion.sVersions != "") | VALUE_SET | txtVersion.Text | popVersion.sVersions | 컨트롤 값 설정 |  |  |  |
| AC-df974e11 | this.btnVersion.Click 외 1 | DMF0022_SalesPlanWaterfall2.cs:2382 | if (popVersion.sVersions != "") | VALUE_SET | drpPeriod.InitValue | popVersion.sPeriod | 컨트롤 값 설정 |  |  |  |

## DMF0022_SalesPlanWaterfall2.cboKRW_SelectedIndexChanged

진입점: this.cboKRW.SelectedIndexChanged / cboKRW.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-488cd6fc | this.cboKRW.SelectedIndexChanged 외 1 | DMF0022_SalesPlanWaterfall2.cs:2019 | if (siMain == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DMF0022_SalesPlanWaterfall2.cboLOC_SelectedIndexChanged

진입점: this.cboLOC.SelectedIndexChanged / cboLOC.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7d8d4205 | this.cboLOC.SelectedIndexChanged 외 1 | DMF0022_SalesPlanWaterfall2.cs:2040 | if (siMain == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DMF0022_SalesPlanWaterfall2.cboQTY_SelectedIndexChanged

진입점: this.cboQTY.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-66056e17 | this.cboQTY.SelectedIndexChanged | DMF0022_SalesPlanWaterfall2.cs:2050 | if (siMain == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DMF0022_SalesPlanWaterfall2.cboUSD_SelectedIndexChanged

진입점: this.cboUSD.SelectedIndexChanged / cboUSD.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1094bc86 | this.cboUSD.SelectedIndexChanged 외 1 | DMF0022_SalesPlanWaterfall2.cs:2030 | if (siMain == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DMF0022_SalesPlanWaterfall2.clbCustomer_SelectedIndexChanged

진입점: this.clbCustomer.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9a96b5c8 | this.clbCustomer.SelectedIndexChanged | DMF0022_SalesPlanWaterfall2.cs:2008 | if (blnInit) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-940b62c7 | this.clbCustomer.SelectedIndexChanged | DMF0022_SalesPlanWaterfall2.cs:2010 | if (base.IsInitOpen) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b6cffe43 | this.clbCustomer.SelectedIndexChanged | DMF0022_SalesPlanWaterfall2.cs:2012 |  | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-603cc43d | this.clbCustomer.SelectedIndexChanged | DMF0022_SalesPlanWaterfall2.cs:2012 |  | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, clbDivision.Contro… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-9d2bb4aa | this.clbCustomer.SelectedIndexChanged | DMF0022_SalesPlanWaterfall2.cs:2013 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |

## DMF0022_SalesPlanWaterfall2.ClbDivision_SelectedIndexChanged

진입점: clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dc21b892 | clbDivision.SelectedIndexChanged | DMF0022_SalesPlanWaterfall2.cs:1163 | try ▸ if (blnInit) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3e0734c7 | clbDivision.SelectedIndexChanged | DMF0022_SalesPlanWaterfall2.cs:1165 | try ▸ if (base.IsInitOpen) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-674322c0 | clbDivision.SelectedIndexChanged | DMF0022_SalesPlanWaterfall2.cs:1171 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-454df287 | clbDivision.SelectedIndexChanged | DMF0022_SalesPlanWaterfall2.cs:1174 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-c192df88 | clbDivision.SelectedIndexChanged | DMF0022_SalesPlanWaterfall2.cs:1193 | try | FLAG | dtTeam | Data.UserTeamByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.Use… | 화면 필드/플래그 변경 |  |  |  |
| AC-84805bbd | clbDivision.SelectedIndexChanged | DMF0022_SalesPlanWaterfall2.cs:1193 | try | COMBO_DATA | Data.UserTeamByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-9284babb | clbDivision.SelectedIndexChanged | DMF0022_SalesPlanWaterfall2.cs:1194 | try | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-4566f1d8 | clbDivision.SelectedIndexChanged | DMF0022_SalesPlanWaterfall2.cs:1201 | try ▸ if (clbDivision.SelectedValue.ToString() == "40") | FLAG | dtCustomer | Data.Common(Data.Type.EndCustomerByDivision40, false, "", clbTeam.ControlValues, UserInfoC… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 화면 필드/플래그 변경 |  |  |  |
| AC-a3d52f27 | clbDivision.SelectedIndexChanged | DMF0022_SalesPlanWaterfall2.cs:1201 | try ▸ if (clbDivision.SelectedValue.ToString() == "40") | COMBO_DATA | Data.Common | (Data.Type.EndCustomerByDivision40, false, "", clbTeam.ControlValues, UserInfoContext.Curr… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-eb1ad8ad | clbDivision.SelectedIndexChanged | DMF0022_SalesPlanWaterfall2.cs:1207 | try ▸ if (clbDivision.SelectedValue.ToString() == "40") | FLAG | dtBizType | Data.Common(Data.Type.DM_BIZ_TYPE, false, "", "", "", "") ⇒ biz:CommonData.CommonDataList [code=DM_BIZ_TYPE] | 화면 필드/플래그 변경 |  |  |  |
| AC-219ce619 | clbDivision.SelectedIndexChanged | DMF0022_SalesPlanWaterfall2.cs:1207 | try ▸ if (clbDivision.SelectedValue.ToString() == "40") | COMBO_DATA | Data.Common | (Data.Type.DM_BIZ_TYPE, false, "", "", "", "") ⇒ biz:CommonData.CommonDataList [code=DM_BIZ_TYPE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-b6397e98 | clbDivision.SelectedIndexChanged | DMF0022_SalesPlanWaterfall2.cs:1208 | try ▸ if (clbDivision.SelectedValue.ToString() == "40") | LIST_REBIND | clsCtrl.setListBox | (dtBizType, clbBizType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-0bfdabaa | clbDivision.SelectedIndexChanged | DMF0022_SalesPlanWaterfall2.cs:1211 | try ▸ if (clbDivision.SelectedValue.ToString() == "40") | STATE | lblProject.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-7c0356c1 | clbDivision.SelectedIndexChanged | DMF0022_SalesPlanWaterfall2.cs:1212 | try ▸ if (clbDivision.SelectedValue.ToString() == "40") | STATE | lblPlantSite.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-ed6b8d89 | clbDivision.SelectedIndexChanged | DMF0022_SalesPlanWaterfall2.cs:1213 | try ▸ if (clbDivision.SelectedValue.ToString() == "40") | STATE | layoutControlItem3.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-db87779c | clbDivision.SelectedIndexChanged | DMF0022_SalesPlanWaterfall2.cs:1214 | try ▸ if (clbDivision.SelectedValue.ToString() == "40") | STATE | cboCellQty.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-720d2023 | clbDivision.SelectedIndexChanged | DMF0022_SalesPlanWaterfall2.cs:1218 | try ▸ else of (clbDivision.SelectedValue.ToString() == "40") | FLAG | dtCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-edc69b8f | clbDivision.SelectedIndexChanged | DMF0022_SalesPlanWaterfall2.cs:1218 | try ▸ else of (clbDivision.SelectedValue.ToString() == "40") | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-cb6aeae4 | clbDivision.SelectedIndexChanged | DMF0022_SalesPlanWaterfall2.cs:1225 | try ▸ else of (clbDivision.SelectedValue.ToString() == "40") | FLAG | dtBizType | GetBizTypebyDivisionAsync(clbDivision.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-8d5b0f1d | clbDivision.SelectedIndexChanged | DMF0022_SalesPlanWaterfall2.cs:1226 | try ▸ else of (clbDivision.SelectedValue.ToString() == "40") | LIST_REBIND | clsCtrl.setListBox | (dtBizType, clbBizType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-03a9d202 | clbDivision.SelectedIndexChanged | DMF0022_SalesPlanWaterfall2.cs:1229 | try ▸ else of (clbDivision.SelectedValue.ToString() == "40") | STATE | lblProject.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-71bc5154 | clbDivision.SelectedIndexChanged | DMF0022_SalesPlanWaterfall2.cs:1230 | try ▸ else of (clbDivision.SelectedValue.ToString() == "40") | STATE | lblPlantSite.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-bce3451f | clbDivision.SelectedIndexChanged | DMF0022_SalesPlanWaterfall2.cs:1231 | try ▸ else of (clbDivision.SelectedValue.ToString() == "40") | STATE | layoutControlItem3.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-0533801e | clbDivision.SelectedIndexChanged | DMF0022_SalesPlanWaterfall2.cs:1232 | try ▸ else of (clbDivision.SelectedValue.ToString() == "40") | STATE | cboCellQty.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-617f9332 | clbDivision.SelectedIndexChanged | DMF0022_SalesPlanWaterfall2.cs:1234 | try | LIST_REBIND | clsCtrl.setListBox | (dtCustomer, clbCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-013f692a | clbDivision.SelectedIndexChanged | DMF0022_SalesPlanWaterfall2.cs:1238 | try | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-a8089aca | clbDivision.SelectedIndexChanged | DMF0022_SalesPlanWaterfall2.cs:1238 | try | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-862e5e44 | clbDivision.SelectedIndexChanged | DMF0022_SalesPlanWaterfall2.cs:1239 | try | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-24845512 | clbDivision.SelectedIndexChanged | DMF0022_SalesPlanWaterfall2.cs:1241 | try | FLAG | dtPlantSite | Data.UserPlantSiteByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Curren… | 화면 필드/플래그 변경 |  |  |  |
| AC-151afae6 | clbDivision.SelectedIndexChanged | DMF0022_SalesPlanWaterfall2.cs:1241 | try | COMBO_DATA | Data.UserPlantSiteByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-01de42e6 | clbDivision.SelectedIndexChanged | DMF0022_SalesPlanWaterfall2.cs:1242 | try | LIST_REBIND | clsCtrl.setListBox | (dtPlantSite, clbPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-466f8fb8 | clbDivision.SelectedIndexChanged | DMF0022_SalesPlanWaterfall2.cs:1257 | try | VALUE_CLEAR | this.txtProject.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-2075c5d7 | clbDivision.SelectedIndexChanged | DMF0022_SalesPlanWaterfall2.cs:1258 | try | VALUE_CLEAR | this.txtItemId.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-470f90c8 | clbDivision.SelectedIndexChanged | DMF0022_SalesPlanWaterfall2.cs:1259 | try | VALUE_CLEAR | this.txtOwner.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-dc63c06b | clbDivision.SelectedIndexChanged | DMF0022_SalesPlanWaterfall2.cs:1260 | try | VALUE_CLEAR | this.txtVersion.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-2fa4e775 | clbDivision.SelectedIndexChanged | DMF0022_SalesPlanWaterfall2.cs:1268 | catch ((Exception ex)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-7fa96814 | clbDivision.SelectedIndexChanged | DMF0022_SalesPlanWaterfall2.cs:1269 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |
| AC-364bdf61 | clbDivision.SelectedIndexChanged | DMF0022_SalesPlanWaterfall2.cs:1273 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

## DMF0022_SalesPlanWaterfall2.ClbPlantSite_SelectedIndexChanged

진입점: clbPlantSite.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-32598366 | clbPlantSite.SelectedIndexChanged | DMF0022_SalesPlanWaterfall2.cs:1293 | if (blnInit) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9dd1f218 | clbPlantSite.SelectedIndexChanged | DMF0022_SalesPlanWaterfall2.cs:1295 | if (base.IsInitOpen) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DMF0022_SalesPlanWaterfall2.ClbSalesSite_SelectedIndexChanged

진입점: clbSalesSite.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-10ec24ff | clbSalesSite.SelectedIndexChanged | DMF0022_SalesPlanWaterfall2.cs:1282 | if (blnInit) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-841f1045 | clbSalesSite.SelectedIndexChanged | DMF0022_SalesPlanWaterfall2.cs:1284 | if (base.IsInitOpen) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DMF0022_SalesPlanWaterfall2.clbTeam_SelectedIndexChanged

진입점: this.clbTeam.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a164b5bc | this.clbTeam.SelectedIndexChanged | DMF0022_SalesPlanWaterfall2.cs:2299 | if (blnInit) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9a463329 | this.clbTeam.SelectedIndexChanged | DMF0022_SalesPlanWaterfall2.cs:2301 | if (base.IsInitOpen) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-55e28556 | this.clbTeam.SelectedIndexChanged | DMF0022_SalesPlanWaterfall2.cs:2309 | if (clbDivision.SelectedValue.ToString() == "40") | FLAG | dtCustomer | Data.Common(Data.Type.EndCustomerByDivision40, false, "", clbTeam.ControlValues, UserInfoC… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 화면 필드/플래그 변경 |  |  |  |
| AC-56424207 | this.clbTeam.SelectedIndexChanged | DMF0022_SalesPlanWaterfall2.cs:2309 | if (clbDivision.SelectedValue.ToString() == "40") | COMBO_DATA | Data.Common | (Data.Type.EndCustomerByDivision40, false, "", clbTeam.ControlValues, UserInfoContext.Curr… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-cf6d31aa | this.clbTeam.SelectedIndexChanged | DMF0022_SalesPlanWaterfall2.cs:2313 | else of (clbDivision.SelectedValue.ToString() == "40") | FLAG | dtCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-f1b692cf | this.clbTeam.SelectedIndexChanged | DMF0022_SalesPlanWaterfall2.cs:2313 | else of (clbDivision.SelectedValue.ToString() == "40") | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-6d649735 | this.clbTeam.SelectedIndexChanged | DMF0022_SalesPlanWaterfall2.cs:2315 |  | LIST_REBIND | clsCtrl.setListBox | (dtCustomer, clbCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-6ee07dcc | this.clbTeam.SelectedIndexChanged | DMF0022_SalesPlanWaterfall2.cs:2319 |  | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-69349093 | this.clbTeam.SelectedIndexChanged | DMF0022_SalesPlanWaterfall2.cs:2319 |  | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ea819467 | this.clbTeam.SelectedIndexChanged | DMF0022_SalesPlanWaterfall2.cs:2320 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |

## DMF0022_SalesPlanWaterfall2.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8beeb932 | this.Load | DMF0022_SalesPlanWaterfall2.cs:401 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 3, 1, 45) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-218c9498 | this.Load | DMF0022_SalesPlanWaterfall2.cs:402 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-6b54a270 | this.Load | DMF0022_SalesPlanWaterfall2.cs:403 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0022_SalesPlanWaterfall2.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d7b6f5fa | this.Load | DMF0022_SalesPlanWaterfall2.cs:372 |  | UI_PROP | usrConditionPanel1.Height | 105 | 속성 Height 설정 |  |  |  |
| AC-e34e8cac | this.Load | DMF0022_SalesPlanWaterfall2.cs:373 |  | VALUE_SET | cboBucketType.ControlValues | BucketType.Weekly | 컨트롤 값 설정 |  |  |  |
| AC-612ce377 | this.Load | DMF0022_SalesPlanWaterfall2.cs:376 |  | FLAG | dtStartPeriod | drpPeriod.Value1 | 화면 필드/플래그 변경 |  |  |  |
| AC-bc3da6e0 | this.Load | DMF0022_SalesPlanWaterfall2.cs:377 |  | FLAG | dtEndPeriod | drpPeriod.Value2 | 화면 필드/플래그 변경 |  |  |  |

## DMF0022_SalesPlanWaterfall2.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-92861bba | Dispose | DMF0022_SalesPlanWaterfall2.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## DMF0022_SalesPlanWaterfall2.DM0022_SalesPlanWaterfall_FormClosed

진입점: this.FormClosed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-93d48dad | this.FormClosed | DMF0022_SalesPlanWaterfall2.cs:2395 | try | CALL_EXT | GC.SuppressFinalize | (this) | ⚠ 의미 확인 필요 |  |  |  |
| AC-379c0cae | this.FormClosed | DMF0022_SalesPlanWaterfall2.cs:2397 | try | CALL_EXT | GC.Collect | (0, GCCollectionMode.Forced, true, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-0a1d938a | this.FormClosed | DMF0022_SalesPlanWaterfall2.cs:2398 | try | CALL_EXT | GC.Collect | (1, GCCollectionMode.Forced, true, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b1fdd30b | this.FormClosed | DMF0022_SalesPlanWaterfall2.cs:2399 | try | CALL_EXT | GC.Collect | (2, GCCollectionMode.Forced, true, true) | ⚠ 의미 확인 필요 |  |  |  |

## DMF0022_SalesPlanWaterfall2.EditButton

진입점: this.cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if (!siMain.IsLock(siMain.SheetName))] / EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-11848f66 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0022_SalesPlanWaterfall2.cs:675 | if (this.fps != null) | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e3ea140a | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0022_SalesPlanWaterfall2.cs:676 | if (this.fps != null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DMF0022_SalesPlanWaterfall2.FindData

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2286dfe6 | FindButton | DMF0022_SalesPlanWaterfall2.cs:691 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-c0efd9c7 | FindButton | DMF0022_SalesPlanWaterfall2.cs:698 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4f6ff09f | FindButton | DMF0022_SalesPlanWaterfall2.cs:699 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8e9bad00 | FindButton | DMF0022_SalesPlanWaterfall2.cs:702 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-e3abbee5 | FindButton | DMF0022_SalesPlanWaterfall2.cs:704 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-b4fd74c0 | FindButton | DMF0022_SalesPlanWaterfall2.cs:704 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-01e9ccd6 | FindButton | DMF0022_SalesPlanWaterfall2.cs:714 | try ▸ if (int.Parse(sPeriod[0]) > int.Parse(sPeriod[1])) | MESSAGE | MessageHelper.GMessageBox | ("MSG00108") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0ae931d8 | FindButton | DMF0022_SalesPlanWaterfall2.cs:715 | try ▸ if (int.Parse(sPeriod[0]) > int.Parse(sPeriod[1])) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-027640d7 | FindButton | DMF0022_SalesPlanWaterfall2.cs:721 | try ▸ if (drpPeriod.Value1.AddYears(2) < drpPeriod.Value2) | MESSAGE | MessageHelper.GMessageBox | ("MSG00164") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5edd2ef9 | FindButton | DMF0022_SalesPlanWaterfall2.cs:723 | try ▸ if (drpPeriod.Value1.AddYears(2) < drpPeriod.Value2) | UI_PROP | drpPeriod.Value2 | drpPeriod.Value1.AddYears(2) | 속성 Value2 설정 |  |  |  |
| AC-b5f41e66 | FindButton | DMF0022_SalesPlanWaterfall2.cs:725 | try ▸ if (drpPeriod.Value1.AddYears(2) < drpPeriod.Value2) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-24109be1 | FindButton | DMF0022_SalesPlanWaterfall2.cs:729 | try | CALL_EXT | drpPeriod.Value1.CompareTo | (thisWeekDate) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a56fce94 | FindButton | DMF0022_SalesPlanWaterfall2.cs:731 | try | CALL_EXT | drpPeriod.Value2.CompareTo | (thisWeekDate) | ⚠ 의미 확인 필요 |  |  |  |
| AC-340f1e38 | FindButton | DMF0022_SalesPlanWaterfall2.cs:751 | try ▸ if (p_division_id == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00097") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-03daa00e | FindButton | DMF0022_SalesPlanWaterfall2.cs:752 | try ▸ if (p_division_id == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-eb8a21fb | FindButton | DMF0022_SalesPlanWaterfall2.cs:756 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-7b81b0ee | FindButton | DMF0022_SalesPlanWaterfall2.cs:766 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-1a97ef6a | FindButton | DMF0022_SalesPlanWaterfall2.cs:767 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { va… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-789f1c7e | FindButton | DMF0022_SalesPlanWaterfall2.cs:772 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("DM.DMF0022_GET_DM_PLN_SALES_PLAN_WATERFALL2") ⇒ DM.DMF0022_GET_DM_PLN_SALES_PLAN_WATERFALL2 | 엔드포인트 요청 생성 |  |  |  |
| AC-4d30db1b | FindButton | DMF0022_SalesPlanWaterfall2.cs:774 | try ▸ lambda | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-8eb88fc7 | FindButton | DMF0022_SalesPlanWaterfall2.cs:776 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-2d127186 | FindButton | DMF0022_SalesPlanWaterfall2.cs:777 | try ▸ lambda | DATA_OP | request.Parameters["p_dept_id"] | p_dept_id | 행/컬럼 값 대입 |  |  |  |
| AC-abac74af | FindButton | DMF0022_SalesPlanWaterfall2.cs:778 | try ▸ lambda | DATA_OP | request.Parameters["p_end_customer"] | p_end_customer | 행/컬럼 값 대입 |  |  |  |
| AC-5177f3fe | FindButton | DMF0022_SalesPlanWaterfall2.cs:779 | try ▸ lambda | DATA_OP | request.Parameters["p_scm_site_id"] | p_scm_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-94dc53bb | FindButton | DMF0022_SalesPlanWaterfall2.cs:780 | try ▸ lambda | DATA_OP | request.Parameters["p_project_code"] | p_project_code | 행/컬럼 값 대입 |  |  |  |
| AC-9ea2184a | FindButton | DMF0022_SalesPlanWaterfall2.cs:781 | try ▸ lambda | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-a9519c8d | FindButton | DMF0022_SalesPlanWaterfall2.cs:782 | try ▸ lambda | DATA_OP | request.Parameters["p_item_type"] | p_item_type | 행/컬럼 값 대입 |  |  |  |
| AC-ecf0f840 | FindButton | DMF0022_SalesPlanWaterfall2.cs:783 | try ▸ lambda | DATA_OP | request.Parameters["p_from_yyyymmdd"] | sStartDate | 행/컬럼 값 대입 |  |  |  |
| AC-79cd14fc | FindButton | DMF0022_SalesPlanWaterfall2.cs:784 | try ▸ lambda | DATA_OP | request.Parameters["p_now_yyyymmdd"] | sNowDate | 행/컬럼 값 대입 |  |  |  |
| AC-335505d4 | FindButton | DMF0022_SalesPlanWaterfall2.cs:785 | try ▸ lambda | DATA_OP | request.Parameters["p_to_yyyymmdd"] | sEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-bdf5a616 | FindButton | DMF0022_SalesPlanWaterfall2.cs:786 | try ▸ lambda | DATA_OP | request.Parameters["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-ddca3c35 | FindButton | DMF0022_SalesPlanWaterfall2.cs:787 | try ▸ lambda | DATA_OP | request.Parameters["p_plant_site_id"] | p_plant_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-1af86233 | FindButton | DMF0022_SalesPlanWaterfall2.cs:788 | try ▸ lambda | DATA_OP | request.Parameters["p_biztype"] | p_biztype | 행/컬럼 값 대입 |  |  |  |
| AC-eb5952c6 | FindButton | DMF0022_SalesPlanWaterfall2.cs:789 | try ▸ lambda | DATA_OP | request.Parameters["p_owner"] | p_owner | 행/컬럼 값 대입 |  |  |  |
| AC-63f0e86e | FindButton | DMF0022_SalesPlanWaterfall2.cs:790 | try ▸ lambda | DATA_OP | request.Parameters["p_internal_yn"] | (InternalYN.Checked == true) ? "Y" : "N" | 행/컬럼 값 대입 |  |  |  |
| AC-ef39fba9 | FindButton | DMF0022_SalesPlanWaterfall2.cs:791 | try ▸ lambda | DATA_OP | request.Parameters["p_unit_yn"] | (cboUnitYN.Checked == true) ? "Y" : "N" | 행/컬럼 값 대입 |  |  |  |
| AC-4e126705 | FindButton | DMF0022_SalesPlanWaterfall2.cs:792 | try ▸ lambda | DATA_OP | request.Parameters["p_cell_yn"] | (cboCellQty.Checked == true) ? "Y" : "N" | 행/컬럼 값 대입 |  |  |  |
| AC-f13fac55 | FindButton | DMF0022_SalesPlanWaterfall2.cs:793 | try ▸ lambda | DATA_OP | request.Parameters["p_userinfo"] | UserInfoContext.Current["NowGroupID"] | 행/컬럼 값 대입 |  |  |  |
| AC-a8133336 | FindButton | DMF0022_SalesPlanWaterfall2.cs:794 | try ▸ lambda | DATA_OP | request.Parameters["p_version_type"] | p_version_type | 행/컬럼 값 대입 |  |  |  |
| AC-c1e3bd2c | FindButton | DMF0022_SalesPlanWaterfall2.cs:796 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-67481689 | FindButton | DMF0022_SalesPlanWaterfall2.cs:798 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-9714c3f3 | FindButton | DMF0022_SalesPlanWaterfall2.cs:803 | try ▸ if (ds.Tables[0].Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a82c5e6b | FindButton | DMF0022_SalesPlanWaterfall2.cs:809 | try ▸ if (ds.Tables[0].Rows[ds.Tables[0].Rows.Count - 1]["MEASURE"].ToString() != "") | DATA_OP | ds.Tables[0].Columns.Add | ("Action", typeof(char)) | 데이터 객체 조작/조회 |  |  |  |
| AC-34c7dc95 | FindButton | DMF0022_SalesPlanWaterfall2.cs:812 | try ▸ if (ds.Tables[0].Rows[ds.Tables[0].Rows.Count - 1]["MEASURE"].ToString() != "") | DATA_OP | ds.Tables[0].AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-36deadfe | FindButton | DMF0022_SalesPlanWaterfall2.cs:814 | try ▸ if (ds.Tables[0].Rows[ds.Tables[0].Rows.Count - 1]["MEASURE"].ToString() != "") | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-8e19daef | FindButton | DMF0022_SalesPlanWaterfall2.cs:815 | try ▸ if (ds.Tables[0].Rows[ds.Tables[0].Rows.Count - 1]["MEASURE"].ToString() != "") | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-ee27a7f7 | FindButton | DMF0022_SalesPlanWaterfall2.cs:818 | try ▸ if (ds.Tables[0].Rows[ds.Tables[0].Rows.Count - 1]["MEASURE"].ToString() != "") ▸ if (ds != null) | UI_MISC | ds.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-b5c28dc1 | FindButton | DMF0022_SalesPlanWaterfall2.cs:822 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2e5f2672 | FindButton | DMF0022_SalesPlanWaterfall2.cs:842 | try ▸ try ▸ if (chkMem.Checked == true) | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-3eb4e247 | FindButton | DMF0022_SalesPlanWaterfall2.cs:930 | try ▸ try ▸ if (chkMem.Checked == true) ▸ if (siMain.GetMaxRowIndex() >= 0) | GRID_STYLE | siMain.SetBGColor | (0, siMain.GetColumnIndex(DefColumns.MEASURE) + 1, siMain.GetMaxRowIndex(), iResultCol, Co… | 그리드 표시 설정 |  |  |  |
| AC-43aa3458 | FindButton | DMF0022_SalesPlanWaterfall2.cs:934 | try ▸ try ▸ if (chkMem.Checked == true) ▸ if (siMain.GetMaxRowIndex() >= 0) | GRID_STYLE | siMain.SetBGColor | (0, iResultMonth, siMain.GetMaxRowIndex(), iResultMonth, Color.White) | 그리드 표시 설정 |  |  |  |
| AC-15baa694 | FindButton | DMF0022_SalesPlanWaterfall2.cs:1067 | try ▸ catch ((Exception e)) | MESSAGE | MessageBox.Show | ("1_2:" + e.ToString()) | 메시지 표시 |  |  |  |
| AC-f83d5d4f | FindButton | DMF0022_SalesPlanWaterfall2.cs:1088 | try ▸ if (dsOrigianlCopy != null) | UI_MISC | dsOrigianlCopy.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-331f0d0f | FindButton | DMF0022_SalesPlanWaterfall2.cs:1089 | try ▸ if (dsOrigianlCopy != null) | FLAG | dsOrigianlCopy | null | 화면 필드/플래그 변경 |  |  |  |
| AC-2af42a04 | FindButton | DMF0022_SalesPlanWaterfall2.cs:1104 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4e8bb906 | FindButton | DMF0022_SalesPlanWaterfall2.cs:1136 | catch ((Exception ex)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-0d3d5b73 | FindButton | DMF0022_SalesPlanWaterfall2.cs:1141 | catch ((Exception ex)) ▸ if (this.Visible) | MESSAGE | MessageBox.Show | ("2_2:" + ex.ToString()) | 메시지 표시 |  |  |  |
| AC-0c9c58f6 | FindButton | DMF0022_SalesPlanWaterfall2.cs:1148 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-8b1aa0e8 | FindButton | DMF0022_SalesPlanWaterfall2.cs:1149 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-35ad2894 | FindButton | DMF0022_SalesPlanWaterfall2.cs:1150 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## DMF0022_SalesPlanWaterfall2.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d0459ab7 | this.Load | DMF0022_SalesPlanWaterfall2.cs:201 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-8a4df785 | this.Load | DMF0022_SalesPlanWaterfall2.cs:207 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## DMF0022_SalesPlanWaterfall2.GetBizTypebyDivision

진입점: this.Load [try ▸ else of (clbDivision.SelectedValue.ToString() == "40")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e5ab1eac | this.Load [try ▸ else of (clbDivision.SelectedValue.ToString… | DMF0022_SalesPlanWaterfall2.cs:1919 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION") ⇒ SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-574966a5 | this.Load [try ▸ else of (clbDivision.SelectedValue.ToString… | DMF0022_SalesPlanWaterfall2.cs:1920 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-7574a7c4 | this.Load [try ▸ else of (clbDivision.SelectedValue.ToString… | DMF0022_SalesPlanWaterfall2.cs:1921 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-2de462f4 | this.Load [try ▸ else of (clbDivision.SelectedValue.ToString… | DMF0022_SalesPlanWaterfall2.cs:1924 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0022_SalesPlanWaterfall2.GetBizTypebyDivisionAsync

진입점: clbDivision.SelectedIndexChanged [try ▸ else of (clbDivision.SelectedValue.ToString() == "40")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8319cf70 | clbDivision.SelectedIndexChanged [try ▸ else of (clbDivision… | DMF0022_SalesPlanWaterfall2.cs:1933 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION") ⇒ SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-d587107e | clbDivision.SelectedIndexChanged [try ▸ else of (clbDivision… | DMF0022_SalesPlanWaterfall2.cs:1934 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-a1ea3831 | clbDivision.SelectedIndexChanged [try ▸ else of (clbDivision… | DMF0022_SalesPlanWaterfall2.cs:1935 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-312ac4a5 | clbDivision.SelectedIndexChanged [try ▸ else of (clbDivision… | DMF0022_SalesPlanWaterfall2.cs:1938 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0022_SalesPlanWaterfall2.GetBucketType

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e93a9650 | this.Load [try] | DMF0022_SalesPlanWaterfall2.cs:1821 |  | ENDPOINT | new FoxDataRequest | ("DM.DM0003_GET_BUCKET_TYPE_CODE") ⇒ DM.DM0003_GET_BUCKET_TYPE_CODE | 엔드포인트 요청 생성 |  |  |  |
| AC-59617a20 | this.Load [try] | DMF0022_SalesPlanWaterfall2.cs:1822 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-6d9ca06e | this.Load [try] | DMF0022_SalesPlanWaterfall2.cs:1825 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0022_SalesPlanWaterfall2.GetCustomerbyDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e7273939 | (진입점 미연결) | DMF0022_SalesPlanWaterfall2.cs:1882 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_CUSTOMER_BY_DIVISION") ⇒ SCM.SCM0001_GET_CUSTOMER_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-8a7eb236 | (진입점 미연결) | DMF0022_SalesPlanWaterfall2.cs:1883 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-3f752315 | (진입점 미연결) | DMF0022_SalesPlanWaterfall2.cs:1884 |  | DATA_OP | request.Parameters["p_dept_id"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-2ac616b8 | (진입점 미연결) | DMF0022_SalesPlanWaterfall2.cs:1885 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-65035ed3 | (진입점 미연결) | DMF0022_SalesPlanWaterfall2.cs:1888 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0022_SalesPlanWaterfall2.GetCustomerbyDivisionAsync

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-38095842 | (진입점 미연결) | DMF0022_SalesPlanWaterfall2.cs:1897 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_CUSTOMER_BY_DIVISION") ⇒ SCM.SCM0001_GET_CUSTOMER_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-4b31b80a | (진입점 미연결) | DMF0022_SalesPlanWaterfall2.cs:1898 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-43376945 | (진입점 미연결) | DMF0022_SalesPlanWaterfall2.cs:1899 |  | DATA_OP | request.Parameters["p_dept_id"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-76ff36cd | (진입점 미연결) | DMF0022_SalesPlanWaterfall2.cs:1900 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-5a026443 | (진입점 미연결) | DMF0022_SalesPlanWaterfall2.cs:1903 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0022_SalesPlanWaterfall2.GetDataTableMeargeForDate

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3850d502 | (진입점 미연결) | DMF0022_SalesPlanWaterfall2.cs:2329 |  | CALL_EXT | sv.GetArray | (0, 0, sv.RowCount - 1, sv.ColumnCount - 1) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c37eabce | (진입점 미연결) | DMF0022_SalesPlanWaterfall2.cs:2346 | for (i < sv.ColumnCount) | DATA_OP | table.Columns.Add | (sFieldName, typeof(decimal)) | 데이터 객체 조작/조회 |  |  |  |
| AC-bfb25cae | (진입점 미연결) | DMF0022_SalesPlanWaterfall2.cs:2348 |  | DATA_OP | ds2.Tables.Add | (table) | 데이터 객체 조작/조회 |  |  |  |
| AC-8ac0482b | (진입점 미연결) | DMF0022_SalesPlanWaterfall2.cs:2352 |  | DATA_OP | ds.Tables[0].Merge | (ds2.Tables[0]) | 데이터 객체 조작/조회 |  |  |  |
| AC-31ada53e | (진입점 미연결) | DMF0022_SalesPlanWaterfall2.cs:2356 | if (ds2 != null) | UI_MISC | ds2.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-a3074636 | (진입점 미연결) | DMF0022_SalesPlanWaterfall2.cs:2358 |  | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## DMF0022_SalesPlanWaterfall2.GetDayRange

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4f944af0 | this.Load [try] | DMF0022_SalesPlanWaterfall2.cs:1773 |  | COMBO_DATA | Data.MultiTimeZone | (UserInfoContext.Current["TimeZone"]) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-3f80b9a4 | this.Load [try] | DMF0022_SalesPlanWaterfall2.cs:1778 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |

## DMF0022_SalesPlanWaterfall2.GetItemType

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1c690fbc | this.Load [try] | DMF0022_SalesPlanWaterfall2.cs:1834 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_LOOKUP_VALUES") ⇒ SCM.SCM0001_GET_LOOKUP_VALUES | 엔드포인트 요청 생성 |  |  |  |
| AC-b179d297 | this.Load [try] | DMF0022_SalesPlanWaterfall2.cs:1835 |  | DATA_OP | request.Parameters["p_lookup_type"] | "ITEM_TYPE_CODE" | 행/컬럼 값 대입 |  |  |  |
| AC-e4afc511 | this.Load [try] | DMF0022_SalesPlanWaterfall2.cs:1836 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-b864cc86 | this.Load [try] | DMF0022_SalesPlanWaterfall2.cs:1839 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0022_SalesPlanWaterfall2.GetLastWeekSunDayByDate

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ed2ad9ee | (진입점 미연결) | DMF0022_SalesPlanWaterfall2.cs:2001 |  | RETURN | return sYYYYMMDD; |  | 처리 중단/반환 |  |  |  |

## DMF0022_SalesPlanWaterfall2.GetPlantSitebyEndCustomer

진입점: this.spdMain.ComboSelChange [if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1763a1c6 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DMF0022_SalesPlanWaterfall2.cs:1727 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER") ⇒ SCM.SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER | 엔드포인트 요청 생성 |  |  |  |
| AC-77df7277 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DMF0022_SalesPlanWaterfall2.cs:1728 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-6cf5b5e5 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DMF0022_SalesPlanWaterfall2.cs:1729 |  | DATA_OP | request.Parameters["p_dept_id"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-457ae852 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DMF0022_SalesPlanWaterfall2.cs:1730 |  | DATA_OP | request.Parameters["p_end_customer"] | sEdnCustomer | 행/컬럼 값 대입 |  |  |  |
| AC-d3ab77b0 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DMF0022_SalesPlanWaterfall2.cs:1731 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-12d5cacf | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DMF0022_SalesPlanWaterfall2.cs:1734 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0022_SalesPlanWaterfall2.GetPlantSitebyEndCustomerAsync

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b95a19d9 | (진입점 미연결) | DMF0022_SalesPlanWaterfall2.cs:1743 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER") ⇒ SCM.SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER | 엔드포인트 요청 생성 |  |  |  |
| AC-45975531 | (진입점 미연결) | DMF0022_SalesPlanWaterfall2.cs:1744 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-9f52f9e7 | (진입점 미연결) | DMF0022_SalesPlanWaterfall2.cs:1745 |  | DATA_OP | request.Parameters["p_dept_id"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-c0d1ecd8 | (진입점 미연결) | DMF0022_SalesPlanWaterfall2.cs:1746 |  | DATA_OP | request.Parameters["p_end_customer"] | sEdnCustomer | 행/컬럼 값 대입 |  |  |  |
| AC-bae0edb7 | (진입점 미연결) | DMF0022_SalesPlanWaterfall2.cs:1747 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-c7f62906 | (진입점 미연결) | DMF0022_SalesPlanWaterfall2.cs:1750 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0022_SalesPlanWaterfall2.GetQtyData

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-be097488 | this.Load [try] | DMF0022_SalesPlanWaterfall2.cs:1953 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0003_GET_QTY_TYPE_CODE") ⇒ DM.DMF0003_GET_QTY_TYPE_CODE | 엔드포인트 요청 생성 |  |  |  |
| AC-d0e7571f | this.Load [try] | DMF0022_SalesPlanWaterfall2.cs:1954 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-60cfbaf3 | this.Load [try] | DMF0022_SalesPlanWaterfall2.cs:1957 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0022_SalesPlanWaterfall2.GetScmSitebyDivision

진입점: this.spdMain.ComboSelChange [if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c076f341 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DMF0022_SalesPlanWaterfall2.cs:1687 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_SITE_BY_DIVISION") ⇒ SCM.SCM0001_GET_SITE_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-4e6888df | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DMF0022_SalesPlanWaterfall2.cs:1688 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-19737863 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DMF0022_SalesPlanWaterfall2.cs:1689 |  | DATA_OP | request.Parameters["p_dept_id"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-02c1d1f6 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DMF0022_SalesPlanWaterfall2.cs:1690 |  | DATA_OP | request.Parameters["p_end_customer"] | sEdnCustomer | 행/컬럼 값 대입 |  |  |  |
| AC-961e48d8 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DMF0022_SalesPlanWaterfall2.cs:1691 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-1e915ce4 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DMF0022_SalesPlanWaterfall2.cs:1694 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0022_SalesPlanWaterfall2.GetScmSitebyDivisionAsync

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9ceb9785 | (진입점 미연결) | DMF0022_SalesPlanWaterfall2.cs:1703 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_SITE_BY_DIVISION") ⇒ SCM.SCM0001_GET_SITE_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-5defbcee | (진입점 미연결) | DMF0022_SalesPlanWaterfall2.cs:1704 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-d4ffb9f8 | (진입점 미연결) | DMF0022_SalesPlanWaterfall2.cs:1705 |  | DATA_OP | request.Parameters["p_dept_id"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-9ffb81eb | (진입점 미연결) | DMF0022_SalesPlanWaterfall2.cs:1706 |  | DATA_OP | request.Parameters["p_end_customer"] | sEdnCustomer | 행/컬럼 값 대입 |  |  |  |
| AC-8d200a5d | (진입점 미연결) | DMF0022_SalesPlanWaterfall2.cs:1707 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-c1e3e3d3 | (진입점 미연결) | DMF0022_SalesPlanWaterfall2.cs:1710 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0022_SalesPlanWaterfall2.GetSpdTitle

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of ((dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpP…)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of ((dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpP…)] / this.Load [try ▸ else of ((dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpP…)] / clbDivision.SelectedIndexChanged [t…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0bba9e48 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DMF0022_SalesPlanWaterfall2.cs:1803 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0022_GET_SPREAD_TITLE") ⇒ DM.DMF0022_GET_SPREAD_TITLE | 엔드포인트 요청 생성 |  |  |  |
| AC-466e9297 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DMF0022_SalesPlanWaterfall2.cs:1804 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | sMonth[0] | 행/컬럼 값 대입 |  |  |  |
| AC-42b1d289 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DMF0022_SalesPlanWaterfall2.cs:1805 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | sMonth[1] | 행/컬럼 값 대입 |  |  |  |
| AC-7b7f8d63 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DMF0022_SalesPlanWaterfall2.cs:1806 |  | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-8cb1ae92 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DMF0022_SalesPlanWaterfall2.cs:1807 |  | DATA_OP | request.Parameters["p_division_id"] | clbDivision.SelectedValue | 행/컬럼 값 대입 |  |  |  |
| AC-5f4d9cdb | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DMF0022_SalesPlanWaterfall2.cs:1810 |  | FLAG | dsSpdTitle | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-c2f24508 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DMF0022_SalesPlanWaterfall2.cs:1810 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-27c9ecdc | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DMF0022_SalesPlanWaterfall2.cs:1813 |  | RETURN | return dsSpdTitle.Tables[0]; |  | 처리 중단/반환 |  |  |  |

## DMF0022_SalesPlanWaterfall2.GetTeambyDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-03fc7176 | (진입점 미연결) | DMF0022_SalesPlanWaterfall2.cs:1849 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_TEAM_BY_DIVISION") ⇒ SCM.SCM0001_GET_TEAM_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-b1cd9bf2 | (진입점 미연결) | DMF0022_SalesPlanWaterfall2.cs:1850 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-ea15ee16 | (진입점 미연결) | DMF0022_SalesPlanWaterfall2.cs:1851 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a222a0ea | (진입점 미연결) | DMF0022_SalesPlanWaterfall2.cs:1854 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0022_SalesPlanWaterfall2.GetTeambyDivisionAsync

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-57f614b8 | (진입점 미연결) | DMF0022_SalesPlanWaterfall2.cs:1863 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_TEAM_BY_DIVISION") ⇒ SCM.SCM0001_GET_TEAM_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-9e0182de | (진입점 미연결) | DMF0022_SalesPlanWaterfall2.cs:1864 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-5ba6d6e1 | (진입점 미연결) | DMF0022_SalesPlanWaterfall2.cs:1865 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-17c42716 | (진입점 미연결) | DMF0022_SalesPlanWaterfall2.cs:1867 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0022_SalesPlanWaterfall2.GetThisWeekMonday

진입점: FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5eea0843 | FindButton [try] | DMF0022_SalesPlanWaterfall2.cs:1978 |  | RETURN | return sYYYYMMDD; |  | 처리 중단/반환 |  |  |  |

## DMF0022_SalesPlanWaterfall2.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e49d7975 | this.Load | DMF0022_SalesPlanWaterfall2.cs:224 | try | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtMain) | 데이터 객체 조작/조회 |  |  |  |
| AC-05363804 | this.Load | DMF0022_SalesPlanWaterfall2.cs:227 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-affda3b2 | this.Load | DMF0022_SalesPlanWaterfall2.cs:228 | try | FLAG | blnInit | true | 화면 필드/플래그 변경 |  |  |  |
| AC-ab38e9e5 | this.Load | DMF0022_SalesPlanWaterfall2.cs:230 | try | VALUE_SET | drpPeriod.InitValue | GetDayRange() | 컨트롤 값 설정 |  |  |  |
| AC-ac6fc8ac | this.Load | DMF0022_SalesPlanWaterfall2.cs:260 | try | FLAG | dtDivision | Data.Common(Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoCo… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 화면 필드/플래그 변경 |  |  |  |
| AC-a217610e | this.Load | DMF0022_SalesPlanWaterfall2.cs:260 | try | COMBO_DATA | Data.Common | (Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoContext.Curre… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-6daa2604 | this.Load | DMF0022_SalesPlanWaterfall2.cs:262 | try | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-8878b118 | this.Load | DMF0022_SalesPlanWaterfall2.cs:265 | try | FLAG | dtTeam | Data.UserTeamByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.Use… | 화면 필드/플래그 변경 |  |  |  |
| AC-b8c7dde1 | this.Load | DMF0022_SalesPlanWaterfall2.cs:265 | try | COMBO_DATA | Data.UserTeamByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, clbDivision.Contro… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-14ac4cfb | this.Load | DMF0022_SalesPlanWaterfall2.cs:266 | try | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-0caa7253 | this.Load | DMF0022_SalesPlanWaterfall2.cs:283 | try ▸ if (clbDivision.SelectedValue.ToString() == "40") | FLAG | dtBizType | Data.Common(Data.Type.DM_BIZ_TYPE, false, "", "", "", "") ⇒ biz:CommonData.CommonDataList [code=DM_BIZ_TYPE] | 화면 필드/플래그 변경 |  |  |  |
| AC-effa6fde | this.Load | DMF0022_SalesPlanWaterfall2.cs:283 | try ▸ if (clbDivision.SelectedValue.ToString() == "40") | COMBO_DATA | Data.Common | (Data.Type.DM_BIZ_TYPE, false, "", "", "", "") ⇒ biz:CommonData.CommonDataList [code=DM_BIZ_TYPE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-25f9d8ff | this.Load | DMF0022_SalesPlanWaterfall2.cs:284 | try ▸ if (clbDivision.SelectedValue.ToString() == "40") | LIST_REBIND | clsCtrl.setListBox | (dtBizType, clbBizType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-92cc1f49 | this.Load | DMF0022_SalesPlanWaterfall2.cs:286 | try ▸ if (clbDivision.SelectedValue.ToString() == "40") | FLAG | dtEndCustomer | Data.Common(Data.Type.EndCustomerByDivision40, false, "", clbTeam.ControlValues, UserInfoC… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 화면 필드/플래그 변경 |  |  |  |
| AC-2da61222 | this.Load | DMF0022_SalesPlanWaterfall2.cs:286 | try ▸ if (clbDivision.SelectedValue.ToString() == "40") | COMBO_DATA | Data.Common | (Data.Type.EndCustomerByDivision40, false, "", clbTeam.ControlValues, UserInfoContext.Curr… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c3df2e3b | this.Load | DMF0022_SalesPlanWaterfall2.cs:289 | try ▸ if (clbDivision.SelectedValue.ToString() == "40") | STATE | lblProject.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-42465597 | this.Load | DMF0022_SalesPlanWaterfall2.cs:290 | try ▸ if (clbDivision.SelectedValue.ToString() == "40") | STATE | lblPlantSite.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-00cc5a5b | this.Load | DMF0022_SalesPlanWaterfall2.cs:291 | try ▸ if (clbDivision.SelectedValue.ToString() == "40") | STATE | layoutControlItem3.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-4abe41c9 | this.Load | DMF0022_SalesPlanWaterfall2.cs:292 | try ▸ if (clbDivision.SelectedValue.ToString() == "40") | STATE | cboUnitYN.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-53efe06a | this.Load | DMF0022_SalesPlanWaterfall2.cs:294 | try ▸ if (clbDivision.SelectedValue.ToString() == "40") | VALUE_CLEAR | txtProject.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-2a270078 | this.Load | DMF0022_SalesPlanWaterfall2.cs:295 | try ▸ if (clbDivision.SelectedValue.ToString() == "40") | VALUE_CLEAR | clbPlantSite.ControlValues | "" | 컨트롤 값 비움 |  |  |  |
| AC-09c31436 | this.Load | DMF0022_SalesPlanWaterfall2.cs:299 | try ▸ else of (clbDivision.SelectedValue.ToString() == "40") | FLAG | dtEndCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-bc1d4274 | this.Load | DMF0022_SalesPlanWaterfall2.cs:299 | try ▸ else of (clbDivision.SelectedValue.ToString() == "40") | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, clbDivision.Contro… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-bcebf62d | this.Load | DMF0022_SalesPlanWaterfall2.cs:301 | try ▸ else of (clbDivision.SelectedValue.ToString() == "40") | FLAG | dtBizType | GetBizTypebyDivision(clbDivision.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-8336ece6 | this.Load | DMF0022_SalesPlanWaterfall2.cs:302 | try ▸ else of (clbDivision.SelectedValue.ToString() == "40") | LIST_REBIND | clsCtrl.setListBox | (dtBizType, clbBizType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-df44ade4 | this.Load | DMF0022_SalesPlanWaterfall2.cs:305 | try ▸ else of (clbDivision.SelectedValue.ToString() == "40") | STATE | lblProject.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-eace2b92 | this.Load | DMF0022_SalesPlanWaterfall2.cs:306 | try ▸ else of (clbDivision.SelectedValue.ToString() == "40") | STATE | lblPlantSite.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-6e63ebde | this.Load | DMF0022_SalesPlanWaterfall2.cs:307 | try ▸ else of (clbDivision.SelectedValue.ToString() == "40") | STATE | layoutControlItem3.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-c3e91e81 | this.Load | DMF0022_SalesPlanWaterfall2.cs:308 | try ▸ else of (clbDivision.SelectedValue.ToString() == "40") | STATE | cboUnitYN.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-fa28d6c5 | this.Load | DMF0022_SalesPlanWaterfall2.cs:310 | try | LIST_REBIND | clsCtrl.setListBox | (dtEndCustomer, clbCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-f682de75 | this.Load | DMF0022_SalesPlanWaterfall2.cs:318 | try | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-a3ff635e | this.Load | DMF0022_SalesPlanWaterfall2.cs:318 | try | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, clbDivision.Contro… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-adb9565d | this.Load | DMF0022_SalesPlanWaterfall2.cs:319 | try | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-ddc2d428 | this.Load | DMF0022_SalesPlanWaterfall2.cs:321 | try | FLAG | dtPlantSite | Data.UserPlantSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Cur… | 화면 필드/플래그 변경 |  |  |  |
| AC-802dea14 | this.Load | DMF0022_SalesPlanWaterfall2.cs:321 | try | COMBO_DATA | Data.UserPlantSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, clbDivision.Contro… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-8b8d37cb | this.Load | DMF0022_SalesPlanWaterfall2.cs:322 | try | LIST_REBIND | clsCtrl.setListBox | (dtPlantSite, clbPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-529a41b0 | this.Load | DMF0022_SalesPlanWaterfall2.cs:324 | try | FLAG | dtBucketType | GetBucketType() | 화면 필드/플래그 변경 |  |  |  |
| AC-f2270a97 | this.Load | DMF0022_SalesPlanWaterfall2.cs:325 | try | LIST_REBIND | clsCtrl.setListBox | (dtBucketType, cboBucketType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-a23707a5 | this.Load | DMF0022_SalesPlanWaterfall2.cs:338 | try | FLAG | dtItemType | GetItemType() | 화면 필드/플래그 변경 |  |  |  |
| AC-839a8cba | this.Load | DMF0022_SalesPlanWaterfall2.cs:339 | try | LIST_REBIND | clsCtrl.setListBox | (dtItemType, clbItemType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-192c912e | this.Load | DMF0022_SalesPlanWaterfall2.cs:342 | try | FLAG | dtAmoutKrw | Data.Common(Data.Type.SALES_PLAN_AMOUNT_KRW, false, UserInfoContext.Current["NowGroupID"],… ⇒ biz:CommonData.CommonDataList [code=SALES_PLAN_AMOUNT_KRW] | 화면 필드/플래그 변경 |  |  |  |
| AC-6c9b17a6 | this.Load | DMF0022_SalesPlanWaterfall2.cs:342 | try | COMBO_DATA | Data.Common | (Data.Type.SALES_PLAN_AMOUNT_KRW, false, UserInfoContext.Current["NowGroupID"], UserInfoCo… ⇒ biz:CommonData.CommonDataList [code=SALES_PLAN_AMOUNT_KRW] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-da3232f7 | this.Load | DMF0022_SalesPlanWaterfall2.cs:343 | try | LIST_REBIND | clsCtrl.setListBox | (dtAmoutKrw, cboKRW, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-f3c17f48 | this.Load | DMF0022_SalesPlanWaterfall2.cs:344 | try | FLAG | dtAmoutUsd | Data.Common(Data.Type.SALES_PLAN_AMOUNT_USD, false, UserInfoContext.Current["NowGroupID"],… ⇒ biz:CommonData.CommonDataList [code=SALES_PLAN_AMOUNT_USD] | 화면 필드/플래그 변경 |  |  |  |
| AC-752ae8ee | this.Load | DMF0022_SalesPlanWaterfall2.cs:344 | try | COMBO_DATA | Data.Common | (Data.Type.SALES_PLAN_AMOUNT_USD, false, UserInfoContext.Current["NowGroupID"], UserInfoCo… ⇒ biz:CommonData.CommonDataList [code=SALES_PLAN_AMOUNT_USD] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-7897dbd3 | this.Load | DMF0022_SalesPlanWaterfall2.cs:345 | try | LIST_REBIND | clsCtrl.setListBox | (dtAmoutUsd, cboUSD, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-bbe5e77a | this.Load | DMF0022_SalesPlanWaterfall2.cs:346 | try | FLAG | dtAmoutLoc | Data.Common(Data.Type.SALES_PLAN_AMOUNT_LOC, false, UserInfoContext.Current["NowGroupID"],… ⇒ biz:CommonData.CommonDataList [code=SALES_PLAN_AMOUNT_LOC] | 화면 필드/플래그 변경 |  |  |  |
| AC-14bcd42b | this.Load | DMF0022_SalesPlanWaterfall2.cs:346 | try | COMBO_DATA | Data.Common | (Data.Type.SALES_PLAN_AMOUNT_LOC, false, UserInfoContext.Current["NowGroupID"], UserInfoCo… ⇒ biz:CommonData.CommonDataList [code=SALES_PLAN_AMOUNT_LOC] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-878d2a01 | this.Load | DMF0022_SalesPlanWaterfall2.cs:347 | try | LIST_REBIND | clsCtrl.setListBox | (dtAmoutLoc, cboLOC, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-b9301b63 | this.Load | DMF0022_SalesPlanWaterfall2.cs:350 | try | FLAG | dtQty | GetQtyData() | 화면 필드/플래그 변경 |  |  |  |
| AC-8f75c25c | this.Load | DMF0022_SalesPlanWaterfall2.cs:351 | try | LIST_REBIND | clsCtrl.setListBox | (dtQty, cboQTY, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-c01fc66d | this.Load | DMF0022_SalesPlanWaterfall2.cs:354 | try | CALL_EXT | toolTip1.SetToolTip | (btnColumn, "Column Show") | ⚠ 의미 확인 필요 |  |  |  |
| AC-1bfc408d | this.Load | DMF0022_SalesPlanWaterfall2.cs:355 | try | CALL_EXT | toolTip1.SetToolTip | (btnMeasure, "Measure") | ⚠ 의미 확인 필요 |  |  |  |
| AC-071ea2a0 | this.Load | DMF0022_SalesPlanWaterfall2.cs:360 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |
| AC-c00bc868 | this.Load | DMF0022_SalesPlanWaterfall2.cs:364 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-311e88e8 | this.Load | DMF0022_SalesPlanWaterfall2.cs:365 | finally | FLAG | blnInit | false | 화면 필드/플래그 변경 |  |  |  |

## DMF0022_SalesPlanWaterfall2.InitSpread

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)] / this.Load / clbDivision.SelectedIndexChanged [try] / FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4c57743b | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DMF0022_SalesPlanWaterfall2.cs:427 | try | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-4fb316d3 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DMF0022_SalesPlanWaterfall2.cs:433 | try ▸ if ((dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpP…) | CALL_EXT | siMain.RemoveRowAll | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-7db459ae | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DMF0022_SalesPlanWaterfall2.cs:438 | try ▸ else of ((dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpP…) | FLAG | dtStartPeriod | drpPeriod.Value1 | 화면 필드/플래그 변경 |  |  |  |
| AC-22c8c381 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DMF0022_SalesPlanWaterfall2.cs:439 | try ▸ else of ((dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpP…) | FLAG | dtEndPeriod | drpPeriod.Value2 | 화면 필드/플래그 변경 |  |  |  |
| AC-b305c4c2 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DMF0022_SalesPlanWaterfall2.cs:443 | try ▸ else of ((dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpP…) | GRID_INIT | siMain.CreateSheetHeaderColumn | (siMain, 3, dtTitle) | 그리드 재구성/초기화 |  |  |  |
| AC-5c35ce70 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DMF0022_SalesPlanWaterfall2.cs:455 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |
| AC-b82f3d58 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DMF0022_SalesPlanWaterfall2.cs:459 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## DMF0022_SalesPlanWaterfall2.InitSpread_X

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e434d5e2 | (진입점 미연결) | DMF0022_SalesPlanWaterfall2.cs:508 |  | CALL_EXT | siMain.ColumnHeaderSpanRow | (0, siMain.GetColumnIndex(DefColumns.MEASURE)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4d8c6ac5 | (진입점 미연결) | DMF0022_SalesPlanWaterfall2.cs:527 |  | DATA_OP | nvc["p_start_yyyymmdd"] | sStartDate | 행/컬럼 값 대입 |  |  |  |
| AC-39a9c9cb | (진입점 미연결) | DMF0022_SalesPlanWaterfall2.cs:528 |  | DATA_OP | nvc["p_end_yyyymmdd"] | sEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-52749cea | (진입점 미연결) | DMF0022_SalesPlanWaterfall2.cs:529 |  | DATA_OP | nvc["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-35c97340 | (진입점 미연결) | DMF0022_SalesPlanWaterfall2.cs:531 |  | ENDPOINT | (new CUIControl()).GetDataUsingByDBEx | ("DM_H.DM0022_GET_SPREAD_TITLE_DATE", nvc) ⇒ DM_H.DM0022_GET_SPREAD_TITLE_DATE | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-322a8dfa | (진입점 미연결) | DMF0022_SalesPlanWaterfall2.cs:531 |  | ENDPOINT | new CUIControl | () ⇒ DM_H.DM0022_GET_SPREAD_TITLE_DATE | 엔드포인트 요청 생성 |  |  |  |
| AC-4d6a7e31 | (진입점 미연결) | DMF0022_SalesPlanWaterfall2.cs:553 | for (i < dt.Rows.Count) ▸ if (i == 0) | GRID_INIT | siMain.AddNumColumn | ("M_" + sFYear, "M_" + sFYear, FPMerge.None, 100, true, FPHAlign.Right, FPVAlign.Center, 2… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9fada4ac | (진입점 미연결) | DMF0022_SalesPlanWaterfall2.cs:555 | for (i < dt.Rows.Count) ▸ if (i == 0) | GRID_INIT | siMain.ColumnHeaderSpan | (1, iFCow, 2, 1, 25, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2f9203a7 | (진입점 미연결) | DMF0022_SalesPlanWaterfall2.cs:567 | for (i < dt.Rows.Count) ▸ if (i == 0) | GRID_INIT | siMain.AddNumColumn | ("SUM", "W_" + sFWeek, FPMerge.None, 100, true, FPHAlign.Right, FPVAlign.Center, 2, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-51dbb0a3 | (진입점 미연결) | DMF0022_SalesPlanWaterfall2.cs:578 | for (i < dt.Rows.Count) ▸ if (sFYear != dt.Rows[i]["BASIS_YYYYMM"].ToString()) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iFCow, 1, iLCow - 1, 25, sYear, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9caa5482 | (진입점 미연결) | DMF0022_SalesPlanWaterfall2.cs:583 | for (i < dt.Rows.Count) ▸ if (sFYear != dt.Rows[i]["BASIS_YYYYMM"].ToString()) | GRID_INIT | siMain.AddNumColumn | ("M_" + sFYear, "M_" + sFYear, FPMerge.None, 100, true, FPHAlign.Right, FPVAlign.Center, 2… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-118fd2eb | (진입점 미연결) | DMF0022_SalesPlanWaterfall2.cs:585 | for (i < dt.Rows.Count) ▸ if (sFYear != dt.Rows[i]["BASIS_YYYYMM"].ToString()) | GRID_INIT | siMain.ColumnHeaderSpan | (1, iFCow, 2, 1, 25, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5178e66b | (진입점 미연결) | DMF0022_SalesPlanWaterfall2.cs:593 | for (i < dt.Rows.Count) ▸ if (sFWeek != dt.Rows[i]["COL_WEEK_NAME"].ToString()) | GRID_INIT | siMain.ColumnHeaderSpan | (1, iWeekFRow, 1, iWeekLRow - 1, 25, sWeekName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-741038bf | (진입점 미연결) | DMF0022_SalesPlanWaterfall2.cs:600 | for (i < dt.Rows.Count) ▸ if (sFWeek != dt.Rows[i]["COL_WEEK_NAME"].ToString()) | GRID_INIT | siMain.AddNumColumn | ("SUM", "W_" + sFWeek, FPMerge.None, 100, true, FPHAlign.Right, FPVAlign.Center, 2, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d5a1feb6 | (진입점 미연결) | DMF0022_SalesPlanWaterfall2.cs:608 | for (i < dt.Rows.Count) | GRID_INIT | siMain.AddNumColumn | (dt.Rows[i]["CALENDAR_DAY"].ToString(), dt.Rows[i]["BASIS_YYYYMMDD"].ToString(), FPMerge.N… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-650d7ce1 | (진입점 미연결) | DMF0022_SalesPlanWaterfall2.cs:610 | for (i < dt.Rows.Count) ▸ if (dt.Rows[i]["DAYOFWEEK"].ToString() == "SAT") | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[2, siMain.GetColumnIndex(dt.Rows[i]["BASIS_YYYYMMDD"… | System.Drawing.Color.Blue | 그리드 속성/값 설정 |  |  |  |
| AC-571ca9d5 | (진입점 미연결) | DMF0022_SalesPlanWaterfall2.cs:612 | for (i < dt.Rows.Count) ▸ else of (dt.Rows[i]["DAYOFWEEK"].ToString() == "SAT") ▸ if (dt.Rows[i]["DAYOFWEEK"].ToString() == "SUN") | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[2, siMain.GetColumnIndex(dt.Rows[i]["BASIS_YYYYMMDD"… | System.Drawing.Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-f211bf9d | (진입점 미연결) | DMF0022_SalesPlanWaterfall2.cs:621 | for (i < dt.Rows.Count) ▸ if (i == dt.Rows.Count - 1) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iFCow, 1, iLCow, 25, sYear, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-550158a0 | (진입점 미연결) | DMF0022_SalesPlanWaterfall2.cs:628 | for (i < dt.Rows.Count) ▸ if (i == dt.Rows.Count - 1) | GRID_INIT | siMain.ColumnHeaderSpan | (1, iWeekFRow, 1, iWeekLRow, 25, sWeekName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a926b2e7 | (진입점 미연결) | DMF0022_SalesPlanWaterfall2.cs:634 |  | GRID_INIT | siMain.Freeze | (0, siMain.GetColumnIndex(DefColumns.MEASURE) + 1) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## DMF0022_SalesPlanWaterfall2.InitSpreadFooterSum

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of ((dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpP…)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of ((dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpP…)] / this.Load [try ▸ else of ((dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpP…)] / clbDivision.SelectedIndexChanged [t…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4c7f9632 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DMF0022_SalesPlanWaterfall2.cs:466 |  | GRID_SET | siMain.ActiveSheet.ColumnFooter.Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-fa7bf22a | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DMF0022_SalesPlanWaterfall2.cs:467 |  | GRID_SET | siMain.ActiveSheet.ColumnFooter.Cells[0, 1].Value | "Sum" | 그리드 속성/값 설정 |  |  |  |
| AC-e48b64ae | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DMF0022_SalesPlanWaterfall2.cs:474 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("M_") == … | CALL_EXT | siMain.ActiveSheet.ColumnFooter.SetAggregationFormat | (0, iCol, "{0:#,##0.###}") | ⚠ 의미 확인 필요 |  |  |  |
| AC-1aac9258 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DMF0022_SalesPlanWaterfall2.cs:475 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("M_") == … | CALL_EXT | siMain.ActiveSheet.ColumnFooter.SetAggregationType | (0, iCol, FarPoint.Win.Spread.Model.AggregationType.SumIgnoreHidden) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1e987c75 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DMF0022_SalesPlanWaterfall2.cs:476 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("M_") == … | GRID_SET | siMain.ActiveSheet.ColumnFooter.Cells[0, iCol].BackColor | Color.LightGray | 그리드 속성/값 설정 |  |  |  |
| AC-09ec26a0 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DMF0022_SalesPlanWaterfall2.cs:477 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("M_") == … | GRID_SET | siMain.ActiveSheet.ColumnFooter.Cells[0, iCol].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |

## DMF0022_SalesPlanWaterfall2.SetAmountCalculating

진입점: this.cboLOC.SelectedIndexChanged / this.cboKRW.SelectedIndexChanged / this.cboUSD.SelectedIndexChanged / this.cboQTY.SelectedIndexChanged / cboKRW.SelectedIndexChanged / cboUSD.SelectedIndexChanged / cboLOC.SelectedIndexChanged / FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b693dd7b | this.cboLOC.SelectedIndexChanged 외 7 | DMF0022_SalesPlanWaterfall2.cs:2060 | if (siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7aa79c42 | this.cboLOC.SelectedIndexChanged 외 7 | DMF0022_SalesPlanWaterfall2.cs:2064 | if (dsOrigianlCopy == null) | FLAG | dsOrigianlCopy | siMain.SpreadObject.DataSource as DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-51a613e2 | this.cboLOC.SelectedIndexChanged 외 7 | DMF0022_SalesPlanWaterfall2.cs:2070 | if (cboKRW.SelectedIndex == 0 && cboUSD.SelectedIndex == 0 && cboLOC.SelectedIndex == 0 && cboQTY.SelectedIndex == 0) | LIST_BIND | siMain.SpreadObject.DataSource | dsOrigianlCopy | 목록/그리드 데이터 원천 연결 |  |  |  |
| AC-70746921 | this.cboLOC.SelectedIndexChanged 외 7 | DMF0022_SalesPlanWaterfall2.cs:2071 | if (cboKRW.SelectedIndex == 0 && cboUSD.SelectedIndex == 0 && cboLOC.SelectedIndex == 0 && cboQTY.SelectedIndex == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b9fb03c3 | this.cboLOC.SelectedIndexChanged 외 7 | DMF0022_SalesPlanWaterfall2.cs:2077 |  | DATA_OP | dsOrigianlCopy.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-58fc25c9 | this.cboLOC.SelectedIndexChanged 외 7 | DMF0022_SalesPlanWaterfall2.cs:2079 |  | DATA_OP | dsKrw.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-905e49ee | this.cboLOC.SelectedIndexChanged 외 7 | DMF0022_SalesPlanWaterfall2.cs:2258 | for (i < dsOrigianlCopy.Tables[0].Rows.Count) ▸ for (j < dsKrw.Tables[0].Columns.Count) ▸ if (dsKrw.Tables[0].Columns[j].ColumnName.IndexOf(… | GRID_SET | dsKrw.Tables[0].Rows[i][j] | Math.Round(Convert.ToDouble(slValue) / dbKrwDivideAmount, 2) | 그리드 속성/값 설정 |  |  |  |
| AC-4f706252 | this.cboLOC.SelectedIndexChanged 외 7 | DMF0022_SalesPlanWaterfall2.cs:2260 | for (i < dsOrigianlCopy.Tables[0].Rows.Count) ▸ for (j < dsKrw.Tables[0].Columns.Count) ▸ if (dsKrw.Tables[0].Columns[j].ColumnName.IndexOf(… | GRID_SET | dsKrw.Tables[0].Rows[i][j] | Math.Round(Convert.ToDouble(slValue) / dbUsdDivideAmount, 2) | 그리드 속성/값 설정 |  |  |  |
| AC-9ba9352a | this.cboLOC.SelectedIndexChanged 외 7 | DMF0022_SalesPlanWaterfall2.cs:2262 | for (i < dsOrigianlCopy.Tables[0].Rows.Count) ▸ for (j < dsKrw.Tables[0].Columns.Count) ▸ if (dsKrw.Tables[0].Columns[j].ColumnName.IndexOf(… | GRID_SET | dsKrw.Tables[0].Rows[i][j] | Math.Round(Convert.ToDouble(slValue) / dbLocDivideAmount, 2) | 그리드 속성/값 설정 |  |  |  |
| AC-1321737f | this.cboLOC.SelectedIndexChanged 외 7 | DMF0022_SalesPlanWaterfall2.cs:2267 | for (i < dsOrigianlCopy.Tables[0].Rows.Count) ▸ for (j < dsKrw.Tables[0].Columns.Count) ▸ if (dsKrw.Tables[0].Columns[j].ColumnName.IndexOf(… | GRID_SET | dsKrw.Tables[0].Rows[i][j] | Math.Round(Convert.ToDouble(slValue) / dbQtyDivideAmount, 2) | 그리드 속성/값 설정 |  |  |  |
| AC-83570416 | this.cboLOC.SelectedIndexChanged 외 7 | DMF0022_SalesPlanWaterfall2.cs:2273 |  | DATA_OP | dsKrw.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-fd72bdd4 | this.cboLOC.SelectedIndexChanged 외 7 | DMF0022_SalesPlanWaterfall2.cs:2279 | if (ds != null) | UI_MISC | ds.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-4f1dba10 | this.cboLOC.SelectedIndexChanged 외 7 | DMF0022_SalesPlanWaterfall2.cs:2283 |  | LIST_BIND | siMain.SpreadObject.DataSource | dsKrw | 목록/그리드 데이터 원천 연결 |  |  |  |
| AC-5c28fce7 | this.cboLOC.SelectedIndexChanged 외 7 | DMF0022_SalesPlanWaterfall2.cs:2287 | if (dsKrw != null) | UI_MISC | dsKrw.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-312aa89d | this.cboLOC.SelectedIndexChanged 외 7 | DMF0022_SalesPlanWaterfall2.cs:2290 |  | CALL_EXT | GC.Collect | () | ⚠ 의미 확인 필요 |  |  |  |

## DMF0022_SalesPlanWaterfall2.SetSpreadColumn

진입점: this.chkSum.CheckedChanged [if (siMain != null)] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of ((dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpP…)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of ((dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpP…)] / this.cboBucketType.SelectedIndexChanged [if (siMain != null)] / this.Load [try ▸ else of ((dtStartPeriod.ToString("yyyyMMdd") == drpPeri…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3746cbf0 | this.chkSum.CheckedChanged [if (siMain != null)] 외 6 | DMF0022_SalesPlanWaterfall2.cs:1643 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siMain.GetColumnTag(iCol).IndexOf("D_"… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-1afd1425 | this.chkSum.CheckedChanged [if (siMain != null)] 외 6 | DMF0022_SalesPlanWaterfall2.cs:1648 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siMain.GetColumnTag(iCol).IndexOf("M_"… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-6630221d | this.chkSum.CheckedChanged [if (siMain != null)] 외 6 | DMF0022_SalesPlanWaterfall2.cs:1655 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Bu… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-9783354d | this.chkSum.CheckedChanged [if (siMain != null)] 외 6 | DMF0022_SalesPlanWaterfall2.cs:1659 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Bu… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-48114cef | this.chkSum.CheckedChanged [if (siMain != null)] 외 6 | DMF0022_SalesPlanWaterfall2.cs:1664 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Bu… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-72eb8046 | this.chkSum.CheckedChanged [if (siMain != null)] 외 6 | DMF0022_SalesPlanWaterfall2.cs:1671 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboBucketType.ControlValues … | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-5fe11d52 | this.chkSum.CheckedChanged [if (siMain != null)] 외 6 | DMF0022_SalesPlanWaterfall2.cs:1675 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboBucketType.ControlValues … | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |

## DMF0022_SalesPlanWaterfall2.SetSpreadHeaderSpan

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of ((dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpP…)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of ((dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpP…)] / this.Load [try ▸ else of ((dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpP…)] / clbDivision.SelectedIndexChanged [t…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7b7f8746 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DMF0022_SalesPlanWaterfall2.cs:1557 | foreach (DataRow dr in dt.Rows) ▸ if (iCellCnt <= iSmallStartCol) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iCellCnt, 3, 1, 20, sColumnLabel, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3ba11890 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DMF0022_SalesPlanWaterfall2.cs:1565 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (dr[DefColumns.ColumnName].ToString().IndexOf("B_") > 0) | GRID_INIT | siMain.VisibleColumns | (iCellCnt, false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-2afe27d8 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DMF0022_SalesPlanWaterfall2.cs:1578 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ else of (dr[DefColumns.ColumnName].ToString().IndexOf("B_") > 0) ▸ … | GRID_SET | siMain.Sheet().ColumnHeader.Cells[2, iCellCnt].ForeColor | dr[DefColumns.DayCode].ToString() == DefColumnsLabel.Saturday ? Color.Blue : Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-cd56a94a | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DMF0022_SalesPlanWaterfall2.cs:1597 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-dbbba022 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DMF0022_SalesPlanWaterfall2.cs:1598 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-58c1567b | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DMF0022_SalesPlanWaterfall2.cs:1603 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-296b380b | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DMF0022_SalesPlanWaterfall2.cs:1604 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 30, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a703775b | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DMF0022_SalesPlanWaterfall2.cs:1611 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName !=… | GRID_INIT | siMain.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2b4ed6fa | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DMF0022_SalesPlanWaterfall2.cs:1612 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName !=… | GRID_INIT | siMain.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-34252c8b | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DMF0022_SalesPlanWaterfall2.cs:1623 |  | GRID_INIT | siMain.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5fb9fd79 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DMF0022_SalesPlanWaterfall2.cs:1624 |  | GRID_INIT | siMain.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-dead31cf | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DMF0022_SalesPlanWaterfall2.cs:1625 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e1390fbf | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DMF0022_SalesPlanWaterfall2.cs:1626 |  | GRID_INIT | siMain.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-888b5712 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DMF0022_SalesPlanWaterfall2.cs:1628 |  | GRID_INIT | siMain.Freeze | (0, siMain.GetColumnIndex(DefColumns.MEASURE) + 1) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-7078e557 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DMF0022_SalesPlanWaterfall2.cs:1630 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0022_SalesPlanWaterfall2.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8bc47994 | this.spdMain.CellDoubleClick | DMF0022_SalesPlanWaterfall2.cs:1360 | if (e.ColumnHeader) ▸ if (siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColum… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | !siMain.ActiveSheet.Columns[iCol].Visible | 그리드 속성/값 설정 |  |  |  |
| AC-3069bc4e | this.spdMain.CellDoubleClick | DMF0022_SalesPlanWaterfall2.cs:1366 | if (e.ColumnHeader) ▸ if (siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (siMain.Get… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | !siMain.ActiveSheet.Columns[iCol].Visible | 그리드 속성/값 설정 |  |  |  |
| AC-397da8d5 | this.spdMain.CellDoubleClick | DMF0022_SalesPlanWaterfall2.cs:1382 | if (e.ColumnHeader) ▸ else of (siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ▸ if (siMain.GetColumnTag(e.Column).IndexOf("W_") == 0) ▸ f… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | !siMain.ActiveSheet.Columns[iCol].Visible | 그리드 속성/값 설정 |  |  |  |
| AC-9f7eab48 | this.spdMain.CellDoubleClick | DMF0022_SalesPlanWaterfall2.cs:1396 | else of (e.ColumnHeader) ▸ if (siMain.IsLock(siMain.SheetName) \|\| siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) !… | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DMF0022_SalesPlanWaterfall2.spdMain_ComboSelChange

진입점: this.spdMain.ComboSelChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a1eff932 | this.spdMain.ComboSelChange | DMF0022_SalesPlanWaterfall2.cs:1342 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | FLAG | dtSalesSite | GetScmSitebyDivision(siMain.GetValue(e.Row, e.Column).ToString(), CAppSetting.StringALL, C… | 화면 필드/플래그 변경 |  |  |  |
| AC-ca20b9a8 | this.spdMain.ComboSelChange | DMF0022_SalesPlanWaterfall2.cs:1343 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), dtSalesSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-e74d6c98 | this.spdMain.ComboSelChange | DMF0022_SalesPlanWaterfall2.cs:1345 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | FLAG | dtPlantSite | GetPlantSitebyEndCustomer(siMain.GetValue(e.Row, e.Column).ToString(), CAppSetting.StringA… | 화면 필드/플래그 변경 |  |  |  |
| AC-112f041e | this.spdMain.ComboSelChange | DMF0022_SalesPlanWaterfall2.cs:1346 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), dtPlantSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |

## DMF0022_SalesPlanWaterfall2.spdMain_KeyUp

진입점: this.spdMain.KeyUp

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9069b2b3 | this.spdMain.KeyUp | DMF0022_SalesPlanWaterfall2.cs:1443 | if (siMain.GetColumnIndex(DefColumns.MEASURE) >= siMain.ActiveColumnIndex) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-71fc2951 | this.spdMain.KeyUp | DMF0022_SalesPlanWaterfall2.cs:1447 | if (e.Control == true && e.KeyCode == Keys.V \|\| e.Control == false && e.KeyCode == Keys.V) | CALL_EXT | spdMain.ActiveSheet.ClipboardPaste | (ClipboardPasteOptions.AsStringSkipHidden) | ⚠ 의미 확인 필요 |  |  |  |
| AC-794405cb | this.spdMain.KeyUp | DMF0022_SalesPlanWaterfall2.cs:1453 | if (e.Control == true && e.KeyCode == Keys.C \|\| e.Control == false && e.KeyCode == Keys.C) | CALL_EXT | Clipboard.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-a7b60777 | this.spdMain.KeyUp | DMF0022_SalesPlanWaterfall2.cs:1454 | if (e.Control == true && e.KeyCode == Keys.C \|\| e.Control == false && e.KeyCode == Keys.C) | CALL_EXT | spdMain.Sheets[0].ClipboardCopy | (ClipboardCopyOptions.AsStringSkipHidden) | ⚠ 의미 확인 필요 |  |  |  |

## DMF0022_SalesPlanWaterfall2.spdMain_TopChange

진입점: this.spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-04474641 | this.spdMain.TopChange | DMF0022_SalesPlanWaterfall2.cs:1437 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

