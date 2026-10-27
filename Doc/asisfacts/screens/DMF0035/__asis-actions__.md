# AS-IS 액션 대조표 — DMF0035

> 원천: `Doc/asisfacts/screens/DMF0035/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 362행 · 메서드 45 · 종류 DATA_OP 64 · GRID_SET 29 · ENDPOINT 27 · RETURN 26 · FLAG 25 · LIST_REBIND 25 · CALL_EXT 25 · POPUP 24 · UI_PROP 23 · GRID_INIT 23 · STATE 18 · VALUE_SET 13 · UI_MISC 12 · COMBO_DATA 8 · MESSAGE 5 · VALUE_CLEAR 4 · GRID_STYLE 3 · LIST_BIND 2 · GRID_COMBO 2 · GRID_BIND 1 · GRID_LOCK 1 · THROW 1 · VALIDATE 1 · ⚠ 의미 확인 필요 25


## DMF0035_MktFcstWaterfall.btnColumn_Click

진입점: this.btnColumn.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0c70a3d8 | this.btnColumn.Click | DMF0035_MktFcstWaterfall.cs:1799 |  | POPUP | new DM0002_TitleSetForm_Popup | ("DMF0035", SpdSheet.shtMain, true, cboDivision.ControlValues) | 팝업/폼 생성 |  |  |  |
| AC-99953508 | this.btnColumn.Click | DMF0035_MktFcstWaterfall.cs:1800 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-c7323367 | this.btnColumn.Click | DMF0035_MktFcstWaterfall.cs:1801 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## DMF0035_MktFcstWaterfall.btnItemId_Click

진입점: this.btnItemId.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4398066c | this.btnItemId.Click | DMF0035_MktFcstWaterfall.cs:1782 |  | POPUP | new DM0002_ItembyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-8bda39c2 | this.btnItemId.Click | DMF0035_MktFcstWaterfall.cs:1785 |  | POPUP | popItem.Form_Load | (false, sDivision, sTeam, sEndCustomer, sScmSite, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-1efbbf66 | this.btnItemId.Click | DMF0035_MktFcstWaterfall.cs:1786 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-57ed6c5e | this.btnItemId.Click | DMF0035_MktFcstWaterfall.cs:1787 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-a8751d7a | this.btnItemId.Click | DMF0035_MktFcstWaterfall.cs:1793 | if (popItem.ItemID != "") | VALUE_SET | txtItemId.Text | sItemId | 컨트롤 값 설정 |  |  |  |

## DMF0035_MktFcstWaterfall.btnMeasure_Click

진입점: this.btnMeasure.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-df81d766 | this.btnMeasure.Click | DMF0035_MktFcstWaterfall.cs:1811 |  | POPUP | new DM0002_TitleSetForm_Popup | ("DMF0035", SpdSheet.shtMain, false, cboDivision.ControlValues) | 팝업/폼 생성 |  |  |  |
| AC-98a5b743 | this.btnMeasure.Click | DMF0035_MktFcstWaterfall.cs:1813 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-fd15d469 | this.btnMeasure.Click | DMF0035_MktFcstWaterfall.cs:1814 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## DMF0035_MktFcstWaterfall.btnOwner_Click

진입점: this.btnOwner.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-96ad8452 | this.btnOwner.Click | DMF0035_MktFcstWaterfall.cs:2183 |  | POPUP | new DM0020_OwnerbyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-9ad6842c | this.btnOwner.Click | DMF0035_MktFcstWaterfall.cs:2186 |  | POPUP | popItem.Form_Load | (true, sDivision, sTeam, sEndCustomer, sScmSiteId, sProject, sItemId, sOwner) | 팝업 초기화(인자 전달) |  |  |  |
| AC-8ff4be58 | this.btnOwner.Click | DMF0035_MktFcstWaterfall.cs:2187 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-a7f8be7b | this.btnOwner.Click | DMF0035_MktFcstWaterfall.cs:2188 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-15457d7d | this.btnOwner.Click | DMF0035_MktFcstWaterfall.cs:2190 |  | VALUE_SET | txtOwner.Text | popItem.OwnerID | 컨트롤 값 설정 |  |  |  |

## DMF0035_MktFcstWaterfall.btnProject_Click

진입점: this.btnProject.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ef25b19a | this.btnProject.Click | DMF0035_MktFcstWaterfall.cs:1757 |  | POPUP | new SCM0002_ProjectbyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-0e2a4011 | this.btnProject.Click | DMF0035_MktFcstWaterfall.cs:1759 |  | POPUP | popProject.Form_Load | (true, sDivision, sTeam, sEndCustomer, sScmSiteID, sProject) | 팝업 초기화(인자 전달) |  |  |  |
| AC-e4356931 | this.btnProject.Click | DMF0035_MktFcstWaterfall.cs:1760 |  | UI_PROP | popProject.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-8517ca34 | this.btnProject.Click | DMF0035_MktFcstWaterfall.cs:1761 |  | POPUP | popProject.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-74d1a35d | this.btnProject.Click | DMF0035_MktFcstWaterfall.cs:1767 | if (popProject.ProjectCode != "") | VALUE_SET | txtProject.Text | sProjectCode | 컨트롤 값 설정 |  |  |  |

## DMF0035_MktFcstWaterfall.btnVersion_Click

진입점: this.btnVersion.Click / this.txtVersion.KeyDown

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bb499d53 | this.btnVersion.Click 외 1 | DMF0035_MktFcstWaterfall.cs:2130 |  | POPUP | new SCM0002_VersionByWaterfallPopup | () | 팝업/폼 생성 |  |  |  |
| AC-b6ba1d8e | this.btnVersion.Click 외 1 | DMF0035_MktFcstWaterfall.cs:2135 |  | POPUP | popVersion.Form_Load | (true, "MF_SF", sDivision, sStartTime, sEndTinme) | 팝업 초기화(인자 전달) |  |  |  |
| AC-86ae68cb | this.btnVersion.Click 외 1 | DMF0035_MktFcstWaterfall.cs:2136 |  | UI_PROP | popVersion.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-1ed4d18f | this.btnVersion.Click 외 1 | DMF0035_MktFcstWaterfall.cs:2137 |  | POPUP | popVersion.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-26bb65d7 | this.btnVersion.Click 외 1 | DMF0035_MktFcstWaterfall.cs:2141 | if (popVersion.sVersions != "") | VALUE_SET | txtVersion.Text | popVersion.sVersions | 컨트롤 값 설정 |  |  |  |
| AC-ca84fdac | this.btnVersion.Click 외 1 | DMF0035_MktFcstWaterfall.cs:2142 | if (popVersion.sVersions != "") | VALUE_SET | drpPeriod.InitValue | popVersion.sPeriod | 컨트롤 값 설정 |  |  |  |

## DMF0035_MktFcstWaterfall.cboBucketType_SelectedIndexChanged

진입점: this.cboBucketType.SelectedIndexChanged / cboBucketType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-49720300 | this.cboBucketType.SelectedIndexChanged 외 1 | DMF0035_MktFcstWaterfall.cs:1598 | if (siMain != null) | FLAG | sBucket | cboBucketType.ControlValues | 화면 필드/플래그 변경 |  |  |  |

## DMF0035_MktFcstWaterfall.cboDivision_SelectedIndexChanged

진입점: this.Load / cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8caa68e8 | this.Load 외 1 | DMF0035_MktFcstWaterfall.cs:1404 |  | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-333398a5 | this.Load 외 1 | DMF0035_MktFcstWaterfall.cs:1408 |  | STATE | lblEDISender.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-1239c68f | this.Load 외 1 | DMF0035_MktFcstWaterfall.cs:1414 |  | LIST_REBIND | clsCtrl.setListBox | (dtEdiSender, clbEDISender, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-81430647 | this.Load 외 1 | DMF0035_MktFcstWaterfall.cs:1420 | if (sDivision != null && sDivision != "") ▸ if ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | STATE | lblProject.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-47a3840c | this.Load 외 1 | DMF0035_MktFcstWaterfall.cs:1421 | if (sDivision != null && sDivision != "") ▸ if ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | STATE | lblPlantSite.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-9fdda8e6 | this.Load 외 1 | DMF0035_MktFcstWaterfall.cs:1422 | if (sDivision != null && sDivision != "") ▸ if ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | STATE | btnProject.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-9033a8c7 | this.Load 외 1 | DMF0035_MktFcstWaterfall.cs:1423 | if (sDivision != null && sDivision != "") ▸ if ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | STATE | cboCellQty.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-c8295efb | this.Load 외 1 | DMF0035_MktFcstWaterfall.cs:1424 | if (sDivision != null && sDivision != "") ▸ if ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | VALUE_SET | cboCellQty.Checked | false | 컨트롤 값 설정 |  |  |  |
| AC-45ee94e7 | this.Load 외 1 | DMF0035_MktFcstWaterfall.cs:1428 | if (sDivision != null && sDivision != "") ▸ if ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) ▸ if (sDivision == "81") | STATE | lblEDISender.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-f44148b7 | this.Load 외 1 | DMF0035_MktFcstWaterfall.cs:1435 | if (sDivision != null && sDivision != "") ▸ if ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | LIST_REBIND | clsCtrl.setListBox | (dtCustomer, clbCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-c8132163 | this.Load 외 1 | DMF0035_MktFcstWaterfall.cs:1443 | if (sDivision != null && sDivision != "") ▸ if ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-d28f05ea | this.Load 외 1 | DMF0035_MktFcstWaterfall.cs:1449 | if (sDivision != null && sDivision != "") ▸ if ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | LIST_REBIND | clsCtrl.setListBox | (dtBizType, clbBizType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-2722c114 | this.Load 외 1 | DMF0035_MktFcstWaterfall.cs:1453 | if (sDivision != null && sDivision != "") ▸ else of ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | STATE | lblProject.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-9a8d7853 | this.Load 외 1 | DMF0035_MktFcstWaterfall.cs:1454 | if (sDivision != null && sDivision != "") ▸ else of ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | STATE | lblPlantSite.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-23005f41 | this.Load 외 1 | DMF0035_MktFcstWaterfall.cs:1455 | if (sDivision != null && sDivision != "") ▸ else of ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | STATE | btnProject.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-712bdfad | this.Load 외 1 | DMF0035_MktFcstWaterfall.cs:1456 | if (sDivision != null && sDivision != "") ▸ else of ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | STATE | cboCellQty.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-a60234bd | this.Load 외 1 | DMF0035_MktFcstWaterfall.cs:1462 | if (sDivision != null && sDivision != "") ▸ else of ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | LIST_REBIND | clsCtrl.setListBox | (dtCustomer, clbCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-5c7b2a62 | this.Load 외 1 | DMF0035_MktFcstWaterfall.cs:1471 | if (sDivision != null && sDivision != "") ▸ else of ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-a64a2e3e | this.Load 외 1 | DMF0035_MktFcstWaterfall.cs:1477 | if (sDivision != null && sDivision != "") ▸ else of ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | LIST_REBIND | clsCtrl.setListBox | (dtBizType, clbBizType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-c45041d1 | this.Load 외 1 | DMF0035_MktFcstWaterfall.cs:1483 |  | STATE | lblBizType.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-02f254e8 | this.Load 외 1 | DMF0035_MktFcstWaterfall.cs:1489 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantSite, clbPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-ef8ee93f | this.Load 외 1 | DMF0035_MktFcstWaterfall.cs:1493 |  | VALUE_CLEAR | this.txtProject.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-62aed776 | this.Load 외 1 | DMF0035_MktFcstWaterfall.cs:1494 |  | VALUE_CLEAR | this.txtItemId.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-2f219dd8 | this.Load 외 1 | DMF0035_MktFcstWaterfall.cs:1495 |  | VALUE_CLEAR | this.txtVersion.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-e3fb4b2d | this.Load 외 1 | DMF0035_MktFcstWaterfall.cs:1496 |  | VALUE_CLEAR | this.txtOwner.Text | "" | 컨트롤 값 비움 |  |  |  |

## DMF0035_MktFcstWaterfall.cboQTY_SelectedIndexChanged

진입점: this.cboQTY.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-287e346d | this.cboQTY.SelectedIndexChanged | DMF0035_MktFcstWaterfall.cs:2196 | if (siMain == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DMF0035_MktFcstWaterfall.clbCustomer_SelectedIndexChanged

진입점: this.clbCustomer.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-46637195 | this.clbCustomer.SelectedIndexChanged | DMF0035_MktFcstWaterfall.cs:1560 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |

## DMF0035_MktFcstWaterfall.clbTeam_SelectedIndexChanged

진입점: this.clbTeam.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4050f742 | this.clbTeam.SelectedIndexChanged | DMF0035_MktFcstWaterfall.cs:1514 | if (sDivision != null && sDivision != "") ▸ if ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | LIST_REBIND | clsCtrl.setListBox | (dtCustomer, clbCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-16ee54fc | this.clbTeam.SelectedIndexChanged | DMF0035_MktFcstWaterfall.cs:1516 | if (sDivision != null && sDivision != "") ▸ if ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-83eb040f | this.clbTeam.SelectedIndexChanged | DMF0035_MktFcstWaterfall.cs:1516 | if (sDivision != null && sDivision != "") ▸ if ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, clbCust… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-35eb40f6 | this.clbTeam.SelectedIndexChanged | DMF0035_MktFcstWaterfall.cs:1526 | if (sDivision != null && sDivision != "") ▸ else of ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | LIST_REBIND | clsCtrl.setListBox | (dtCustomer, clbCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-3fff2020 | this.clbTeam.SelectedIndexChanged | DMF0035_MktFcstWaterfall.cs:1533 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |

## DMF0035_MktFcstWaterfall.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5a0ed17f | this.Load | DMF0035_MktFcstWaterfall.cs:435 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 3, 1, 20) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-689bfe92 | this.Load | DMF0035_MktFcstWaterfall.cs:436 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-0c7a832f | this.Load | DMF0035_MktFcstWaterfall.cs:437 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0035_MktFcstWaterfall.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-45911821 | this.Load | DMF0035_MktFcstWaterfall.cs:429 |  | UI_PROP | usrConditionPanel1.Height | 105 | 속성 Height 설정 |  |  |  |
| AC-bc96da9e | this.Load | DMF0035_MktFcstWaterfall.cs:430 |  | VALUE_SET | cboBucketType.ControlValues | BucketType.Monthly | 컨트롤 값 설정 |  |  |  |

## DMF0035_MktFcstWaterfall.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3d59b81d | Dispose | DMF0035_MktFcstWaterfall.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## DMF0035_MktFcstWaterfall.Draw

진입점: this.btnDrawTest.Click / FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-207bf95d | this.btnDrawTest.Click 외 1 | DMF0035_MktFcstWaterfall.cs:1136 | if (ds.Tables[1] != null) | FLAG | this_YYYYMMWW | "W_" + DateTime.Today.ToString("yyyyMM") + ds.Tables[1].Rows[0]["ISO_WEEK"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-95054423 | this.btnDrawTest.Click 외 1 | DMF0035_MktFcstWaterfall.cs:1140 | if (ds.Tables[0] != null) | FLAG | iso_week | ds.Tables[1].Rows[0]["ISO_WEEK"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-fceabe10 | this.btnDrawTest.Click 외 1 | DMF0035_MktFcstWaterfall.cs:1149 | if (ds.Tables[0] != null) | UI_PROP | dv.Sort | sOrderBy | 속성 Sort 설정 |  |  |  |
| AC-d10c6392 | this.btnDrawTest.Click 외 1 | DMF0035_MktFcstWaterfall.cs:1151 | if (ds.Tables[0] != null) | DATA_OP | dsSort.Tables.Add | (dv.ToTable()) | 데이터 객체 조작/조회 |  |  |  |
| AC-98776207 | this.btnDrawTest.Click 외 1 | DMF0035_MktFcstWaterfall.cs:1151 | if (ds.Tables[0] != null) | DATA_OP | dv.ToTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-3553ec1a | this.btnDrawTest.Click 외 1 | DMF0035_MktFcstWaterfall.cs:1153 | if (ds.Tables[0] != null) | GRID_BIND | siMain.Query | (dsSort) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-7214da84 | this.btnDrawTest.Click 외 1 | DMF0035_MktFcstWaterfall.cs:1154 | if (ds.Tables[0] != null) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2effc2ae | this.btnDrawTest.Click 외 1 | DMF0035_MktFcstWaterfall.cs:1155 | if (ds.Tables[0] != null) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-93460b8e | this.btnDrawTest.Click 외 1 | DMF0035_MktFcstWaterfall.cs:1162 | if (siMain.GetMaxRowIndex() > 0) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1264fb9d | this.btnDrawTest.Click 외 1 | DMF0035_MktFcstWaterfall.cs:1164 | if (siMain.GetMaxRowIndex() > 0) | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-d43adb27 | this.btnDrawTest.Click 외 1 | DMF0035_MktFcstWaterfall.cs:1166 |  | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-6a4bd7e4 | this.btnDrawTest.Click 외 1 | DMF0035_MktFcstWaterfall.cs:1183 | try ▸ if (data_start_pos < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-635d5987 | this.btnDrawTest.Click 외 1 | DMF0035_MktFcstWaterfall.cs:1196 | try ▸ for (j < maxCol) | DATA_OP | colnames[j - data_start_pos] | siMain.GetColumnTag(j) | 행/컬럼 값 대입 |  |  |  |
| AC-4efccda0 | this.btnDrawTest.Click 외 1 | DMF0035_MktFcstWaterfall.cs:1199 | try ▸ for (j < maxCol) ▸ for (i < maxRow) | DATA_OP | rNotation[i] | ds.Tables[0].Rows[i]["NOTATION"].String().ToUpper() | 행/컬럼 값 대입 |  |  |  |
| AC-c621a163 | this.btnDrawTest.Click 외 1 | DMF0035_MktFcstWaterfall.cs:1199 | try ▸ for (j < maxCol) ▸ for (i < maxRow) | CALL_EXT | ds.Tables[0].Rows[i]["NOTATION"].String | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-c00988f2 | this.btnDrawTest.Click 외 1 | DMF0035_MktFcstWaterfall.cs:1213 | try ▸ for (j < maxCol) ▸ for (i < maxRow) ▸ else of (Val == "" \|\| rNotation[i] == "DEFAULT") ▸ switch (rNotation[i]) case "INTEGER": | DATA_OP | rMeasureType[i] | 1 | 행/컬럼 값 대입 |  |  |  |
| AC-4dcc65a3 | this.btnDrawTest.Click 외 1 | DMF0035_MktFcstWaterfall.cs:1216 | try ▸ for (j < maxCol) ▸ for (i < maxRow) ▸ else of (Val == "" \|\| rNotation[i] == "DEFAULT") ▸ switch (rNotation[i]) case "POINT": | DATA_OP | rMeasureType[i] | 2 | 행/컬럼 값 대입 |  |  |  |
| AC-2f2d2901 | this.btnDrawTest.Click 외 1 | DMF0035_MktFcstWaterfall.cs:1219 | try ▸ for (j < maxCol) ▸ for (i < maxRow) ▸ else of (Val == "" \|\| rNotation[i] == "DEFAULT") ▸ switch (rNotation[i]) case "POINT3": | DATA_OP | rMeasureType[i] | 3 | 행/컬럼 값 대입 |  |  |  |
| AC-5ed97a9c | this.btnDrawTest.Click 외 1 | DMF0035_MktFcstWaterfall.cs:1230 | try ▸ for (j < maxCol) ▸ for (i < maxRow) ▸ else of (Val == "" \|\| rNotation[i] == "DEFAULT") ▸ switch (rMeasureType[i]) case 1: ▸ if (Val.… | CALL_EXT | siMain.SetRowFormat | (i, j, maxCol - data_start_pos, "###,###,###,##0") | ⚠ 의미 확인 필요 |  |  |  |
| AC-3f9842c3 | this.btnDrawTest.Click 외 1 | DMF0035_MktFcstWaterfall.cs:1232 | try ▸ for (j < maxCol) ▸ for (i < maxRow) ▸ else of (Val == "" \|\| rNotation[i] == "DEFAULT") ▸ switch (rMeasureType[i]) case 1: ▸ else of … | CALL_EXT | siMain.SetRowFormat | (i, j, maxCol - data_start_pos, "###,###,###,###") | ⚠ 의미 확인 필요 |  |  |  |
| AC-ef3ba371 | this.btnDrawTest.Click 외 1 | DMF0035_MktFcstWaterfall.cs:1239 | try ▸ for (j < maxCol) ▸ for (i < maxRow) ▸ else of (Val == "" \|\| rNotation[i] == "DEFAULT") ▸ switch (rMeasureType[i]) case 2: ▸ if (Val … | CALL_EXT | siMain.SetRowFormat | (i, j, maxCol - data_start_pos, "###,###,###,##0") | ⚠ 의미 확인 필요 |  |  |  |
| AC-83784971 | this.btnDrawTest.Click 외 1 | DMF0035_MktFcstWaterfall.cs:1242 | try ▸ for (j < maxCol) ▸ for (i < maxRow) ▸ else of (Val == "" \|\| rNotation[i] == "DEFAULT") ▸ switch (rMeasureType[i]) case 2: ▸ else of … | CALL_EXT | siMain.SetRowFormat | (i, j, maxCol - data_start_pos, "0.###") | ⚠ 의미 확인 필요 |  |  |  |
| AC-18bd5530 | this.btnDrawTest.Click 외 1 | DMF0035_MktFcstWaterfall.cs:1245 | try ▸ for (j < maxCol) ▸ for (i < maxRow) ▸ else of (Val == "" \|\| rNotation[i] == "DEFAULT") ▸ switch (rMeasureType[i]) case 2: ▸ else of … | CALL_EXT | siMain.SetRowFormat | (i, j, maxCol - data_start_pos, "###,###,###,###") | ⚠ 의미 확인 필요 |  |  |  |
| AC-60fa5fb0 | this.btnDrawTest.Click 외 1 | DMF0035_MktFcstWaterfall.cs:1248 | try ▸ for (j < maxCol) ▸ for (i < maxRow) ▸ else of (Val == "" \|\| rNotation[i] == "DEFAULT") ▸ switch (rMeasureType[i]) case 2: ▸ else of … | CALL_EXT | siMain.SetRowFormat | (i, j, maxCol - data_start_pos, "###,###,###,###.###") | ⚠ 의미 확인 필요 |  |  |  |
| AC-d7c3b788 | this.btnDrawTest.Click 외 1 | DMF0035_MktFcstWaterfall.cs:1255 | try ▸ for (j < maxCol) ▸ for (i < maxRow) ▸ else of (Val == "" \|\| rNotation[i] == "DEFAULT") ▸ switch (rMeasureType[i]) case 3: ▸ if (Val … | CALL_EXT | siMain.SetRowFormat | (i, j, maxCol - data_start_pos, "###,###,###,##0") | ⚠ 의미 확인 필요 |  |  |  |
| AC-8edd094b | this.btnDrawTest.Click 외 1 | DMF0035_MktFcstWaterfall.cs:1258 | try ▸ for (j < maxCol) ▸ for (i < maxRow) ▸ else of (Val == "" \|\| rNotation[i] == "DEFAULT") ▸ switch (rMeasureType[i]) case 3: ▸ else of … | CALL_EXT | siMain.SetRowFormat | (i, j, maxCol - data_start_pos, "0.#00") | ⚠ 의미 확인 필요 |  |  |  |
| AC-addf4e2b | this.btnDrawTest.Click 외 1 | DMF0035_MktFcstWaterfall.cs:1261 | try ▸ for (j < maxCol) ▸ for (i < maxRow) ▸ else of (Val == "" \|\| rNotation[i] == "DEFAULT") ▸ switch (rMeasureType[i]) case 3: ▸ else of … | CALL_EXT | siMain.SetRowFormat | (i, j, maxCol - data_start_pos, "0.##0") | ⚠ 의미 확인 필요 |  |  |  |
| AC-37c9183b | this.btnDrawTest.Click 외 1 | DMF0035_MktFcstWaterfall.cs:1264 | try ▸ for (j < maxCol) ▸ for (i < maxRow) ▸ else of (Val == "" \|\| rNotation[i] == "DEFAULT") ▸ switch (rMeasureType[i]) case 3: ▸ else of … | CALL_EXT | siMain.SetRowFormat | (i, j, maxCol - data_start_pos, "0.###") | ⚠ 의미 확인 필요 |  |  |  |
| AC-a4a9556e | this.btnDrawTest.Click 외 1 | DMF0035_MktFcstWaterfall.cs:1267 | try ▸ for (j < maxCol) ▸ for (i < maxRow) ▸ else of (Val == "" \|\| rNotation[i] == "DEFAULT") ▸ switch (rMeasureType[i]) case 3: ▸ else of … | CALL_EXT | siMain.SetRowFormat | (i, j, maxCol - data_start_pos, "###,###,###,###.#00") | ⚠ 의미 확인 필요 |  |  |  |
| AC-7d37e912 | this.btnDrawTest.Click 외 1 | DMF0035_MktFcstWaterfall.cs:1270 | try ▸ for (j < maxCol) ▸ for (i < maxRow) ▸ else of (Val == "" \|\| rNotation[i] == "DEFAULT") ▸ switch (rMeasureType[i]) case 3: ▸ else of … | CALL_EXT | siMain.SetRowFormat | (i, j, maxCol - data_start_pos, "###,###,###,###.##0") | ⚠ 의미 확인 필요 |  |  |  |
| AC-733ba72c | this.btnDrawTest.Click 외 1 | DMF0035_MktFcstWaterfall.cs:1273 | try ▸ for (j < maxCol) ▸ for (i < maxRow) ▸ else of (Val == "" \|\| rNotation[i] == "DEFAULT") ▸ switch (rMeasureType[i]) case 3: ▸ else of … | CALL_EXT | siMain.SetRowFormat | (i, j, maxCol - data_start_pos, "###,###,###,###.###") | ⚠ 의미 확인 필요 |  |  |  |
| AC-2e1f3c27 | this.btnDrawTest.Click 외 1 | DMF0035_MktFcstWaterfall.cs:1335 | if (chkColor.Checked == true) ▸ for (i <= siMain.GetMaxRowIndex()) | CALL_EXT | calendar.GetWeekOfYear | (referenceDate, CalendarWeekRule.FirstFourDayWeek, DayOfWeek.Monday) | ⚠ 의미 확인 필요 |  |  |  |
| AC-50c94cc7 | this.btnDrawTest.Click 외 1 | DMF0035_MktFcstWaterfall.cs:1365 | if (chkColor.Checked == true) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetColumnIndex(sLockDate) >= 0) | GRID_STYLE | siMain.SetBGColor | (i, iStartCol, i, iResultCol, Color.Gainsboro) | 그리드 표시 설정 |  |  |  |
| AC-a941f885 | this.btnDrawTest.Click 외 1 | DMF0035_MktFcstWaterfall.cs:1370 | if (chkColor.Checked == true) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetColumnIndex(sLockDate) >= 0) ▸ if (siMain.GetColumnIndex(… | GRID_STYLE | siMain.SetBGColor | (i, iResultMonth, i, iResultMonth, Color.White) | 그리드 표시 설정 |  |  |  |
| AC-f6f0e046 | this.btnDrawTest.Click 외 1 | DMF0035_MktFcstWaterfall.cs:1376 |  | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-1d5c44af | this.btnDrawTest.Click 외 1 | DMF0035_MktFcstWaterfall.cs:1380 | if (dsOrigianlCopy != null) | UI_MISC | dsOrigianlCopy.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-50087cf1 | this.btnDrawTest.Click 외 1 | DMF0035_MktFcstWaterfall.cs:1381 | if (dsOrigianlCopy != null) | FLAG | dsOrigianlCopy | null | 화면 필드/플래그 변경 |  |  |  |

## DMF0035_MktFcstWaterfall.EditButton

진입점: this.cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if (!siMain.IsLock(siMain.SheetName))] / cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if (!siMain.IsLock(siMain.SheetName))] / EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-01831091 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0035_MktFcstWaterfall.cs:647 | if (this.fps != null) | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2017ae71 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0035_MktFcstWaterfall.cs:648 | if (this.fps != null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DMF0035_MktFcstWaterfall.ExcelButton

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a2f8b5a2 | ExcelButton | DMF0035_MktFcstWaterfall.cs:938 |  | UI_PROP | exportOption.Merge | ExcelMergeOption.None | 속성 Merge 설정 |  |  |  |
| AC-4f7a7784 | ExcelButton | DMF0035_MktFcstWaterfall.cs:939 |  | UI_PROP | exportOption.Border | ExcelBorderOption.All | 속성 Border 설정 |  |  |  |
| AC-16a75756 | ExcelButton | DMF0035_MktFcstWaterfall.cs:940 |  | UI_PROP | exportOption.AheadZeroOption | ZeroOption.HideZero | 속성 AheadZeroOption 설정 |  |  |  |
| AC-3a6457ed | ExcelButton | DMF0035_MktFcstWaterfall.cs:941 |  | UI_PROP | exportOption.AmendZeroOption | ZeroOption.ShowZero | 속성 AmendZeroOption 설정 |  |  |  |
| AC-50c440b4 | ExcelButton | DMF0035_MktFcstWaterfall.cs:942 |  | UI_PROP | exportOption.AmendNullToZero | false | 속성 AmendNullToZero 설정 |  |  |  |
| AC-36cc5a1f | ExcelButton | DMF0035_MktFcstWaterfall.cs:943 |  | UI_PROP | exportOption.AheadNullToZero | false | 속성 AheadNullToZero 설정 |  |  |  |
| AC-1aeb7b90 | ExcelButton | DMF0035_MktFcstWaterfall.cs:945 |  | UI_PROP | exportOption.UserName | UserInfo.UserId | 속성 UserName 설정 |  |  |  |
| AC-2445d2ff | ExcelButton | DMF0035_MktFcstWaterfall.cs:946 |  | UI_PROP | exportOption.FileName | sFileName | 속성 FileName 설정 |  |  |  |
| AC-eb5399ce | ExcelButton | DMF0035_MktFcstWaterfall.cs:948 |  | UI_PROP | exportOption.AmendDecimalFormat | "#,##0.##0;[Red]-#,##0.##0" | 속성 AmendDecimalFormat 설정 |  |  |  |
| AC-8667f8ec | ExcelButton | DMF0035_MktFcstWaterfall.cs:957 | try | CALL_EXT | SimplexelService.ExportFpSpread | (fps, exportOption) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a64e2abb | ExcelButton | DMF0035_MktFcstWaterfall.cs:962 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-53db0915 | ExcelButton | DMF0035_MktFcstWaterfall.cs:966 | finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## DMF0035_MktFcstWaterfall.FindData

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ec7de455 | FindButton | DMF0035_MktFcstWaterfall.cs:1002 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-175914fe | FindButton | DMF0035_MktFcstWaterfall.cs:1006 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-e7e6fc2c | FindButton | DMF0035_MktFcstWaterfall.cs:1006 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6f80fe1b | FindButton | DMF0035_MktFcstWaterfall.cs:1010 | try | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-b0e3131f | FindButton | DMF0035_MktFcstWaterfall.cs:1017 | try ▸ if (sDivision == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00097") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ddacddb9 | FindButton | DMF0035_MktFcstWaterfall.cs:1019 | try ▸ if (sDivision == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7b387d89 | FindButton | DMF0035_MktFcstWaterfall.cs:1026 | try ▸ if (int.Parse(sPeriod[0]) > int.Parse(sPeriod[1])) | MESSAGE | MessageHelper.GMessageBox | ("MSG00108") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-82e19108 | FindButton | DMF0035_MktFcstWaterfall.cs:1027 | try ▸ if (int.Parse(sPeriod[0]) > int.Parse(sPeriod[1])) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d509b6f9 | FindButton | DMF0035_MktFcstWaterfall.cs:1032 | try ▸ if (drpPeriod.Value1.AddYears(3) < drpPeriod.Value2) | MESSAGE | MessageHelper.GMessageBox | ("MSG00164") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-882ca768 | FindButton | DMF0035_MktFcstWaterfall.cs:1034 | try ▸ if (drpPeriod.Value1.AddYears(3) < drpPeriod.Value2) | UI_PROP | drpPeriod.Value2 | drpPeriod.Value1.AddYears(3) | 속성 Value2 설정 |  |  |  |
| AC-eb4b38a1 | FindButton | DMF0035_MktFcstWaterfall.cs:1036 | try ▸ if (drpPeriod.Value1.AddYears(3) < drpPeriod.Value2) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-abc1275a | FindButton | DMF0035_MktFcstWaterfall.cs:1040 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-e3990004 | FindButton | DMF0035_MktFcstWaterfall.cs:1048 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-601e5783 | FindButton | DMF0035_MktFcstWaterfall.cs:1050 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { //… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-903cb26a | FindButton | DMF0035_MktFcstWaterfall.cs:1055 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("DM.DMF0035_GET_MKT_FCST_WATERFALL") ⇒ DM.DMF0035_GET_MKT_FCST_WATERFALL | 엔드포인트 요청 생성 |  |  |  |
| AC-9bbb3feb | FindButton | DMF0035_MktFcstWaterfall.cs:1057 | try ▸ lambda | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-f69dca28 | FindButton | DMF0035_MktFcstWaterfall.cs:1059 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-0ab682eb | FindButton | DMF0035_MktFcstWaterfall.cs:1060 | try ▸ lambda | DATA_OP | request.Parameters["p_scm_site_id"] | clbSalesSite.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-663f471b | FindButton | DMF0035_MktFcstWaterfall.cs:1061 | try ▸ lambda | DATA_OP | request.Parameters["p_plant_site_id"] | clbPlantSite.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-0ccbdcb5 | FindButton | DMF0035_MktFcstWaterfall.cs:1062 | try ▸ lambda | DATA_OP | request.Parameters["p_biz_type"] | clbBizType.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-d00130ff | FindButton | DMF0035_MktFcstWaterfall.cs:1063 | try ▸ lambda | DATA_OP | request.Parameters["p_project_code"] | txtProject.Text | 행/컬럼 값 대입 |  |  |  |
| AC-5035559d | FindButton | DMF0035_MktFcstWaterfall.cs:1064 | try ▸ lambda | DATA_OP | request.Parameters["p_item_id"] | txtItemId.Text | 행/컬럼 값 대입 |  |  |  |
| AC-85f1bb1f | FindButton | DMF0035_MktFcstWaterfall.cs:1065 | try ▸ lambda | DATA_OP | request.Parameters["p_from_yyyymmdd"] | sPeriod[0] | 행/컬럼 값 대입 |  |  |  |
| AC-8975828b | FindButton | DMF0035_MktFcstWaterfall.cs:1066 | try ▸ lambda | DATA_OP | request.Parameters["p_to_yyyymmdd"] | sPeriod[1] | 행/컬럼 값 대입 |  |  |  |
| AC-83e54b79 | FindButton | DMF0035_MktFcstWaterfall.cs:1067 | try ▸ lambda | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-67943b0b | FindButton | DMF0035_MktFcstWaterfall.cs:1068 | try ▸ lambda | DATA_OP | request.Parameters["p_version_no"] | txtVersion.Text | 행/컬럼 값 대입 |  |  |  |
| AC-7d404a46 | FindButton | DMF0035_MktFcstWaterfall.cs:1069 | try ▸ lambda | DATA_OP | request.Parameters["p_item_type"] | clbItemType.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-bc8b5e9a | FindButton | DMF0035_MktFcstWaterfall.cs:1070 | try ▸ lambda | DATA_OP | request.Parameters["p_dept_id"] | clbTeam.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-8d9e3134 | FindButton | DMF0035_MktFcstWaterfall.cs:1071 | try ▸ lambda | DATA_OP | request.Parameters["p_end_customer"] | clbCustomer.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-583182b9 | FindButton | DMF0035_MktFcstWaterfall.cs:1072 | try ▸ lambda | DATA_OP | request.Parameters["p_owner"] | txtOwner.Text.Trim() | 행/컬럼 값 대입 |  |  |  |
| AC-3c87ed62 | FindButton | DMF0035_MktFcstWaterfall.cs:1073 | try ▸ lambda | DATA_OP | request.Parameters["p_bucket"] | p_bucket | 행/컬럼 값 대입 |  |  |  |
| AC-52f3a72c | FindButton | DMF0035_MktFcstWaterfall.cs:1075 | try ▸ lambda | DATA_OP | request.Parameters["p_user_dept_id"] | UserInfoContext.Current["Dept_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-925f65f1 | FindButton | DMF0035_MktFcstWaterfall.cs:1076 | try ▸ lambda | DATA_OP | request.Parameters["p_group_id"] | UserInfoContext.Current["NowGroupID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-1f20ffa9 | FindButton | DMF0035_MktFcstWaterfall.cs:1077 | try ▸ lambda | DATA_OP | request.Parameters["p_cell_yn"] | (cboCellQty.Checked == true) ? "Y" : "N" | 행/컬럼 값 대입 |  |  |  |
| AC-42226de5 | FindButton | DMF0035_MktFcstWaterfall.cs:1078 | try ▸ lambda | DATA_OP | request.Parameters["p_sender_code"] | clbEDISender.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-19a816ac | FindButton | DMF0035_MktFcstWaterfall.cs:1081 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-5831c078 | FindButton | DMF0035_MktFcstWaterfall.cs:1083 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-b59c5f46 | FindButton | DMF0035_MktFcstWaterfall.cs:1092 | try | FLAG | dsMain | ds | 화면 필드/플래그 변경 |  |  |  |
| AC-eebd91e1 | FindButton | DMF0035_MktFcstWaterfall.cs:1095 | try | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-53e5156d | FindButton | DMF0035_MktFcstWaterfall.cs:1120 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c6b35d5f | FindButton | DMF0035_MktFcstWaterfall.cs:1124 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## DMF0035_MktFcstWaterfall.fnValidation

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e55fcdfb | (진입점 미연결) | DMF0035_MktFcstWaterfall.cs:1952 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (iValidation > 1) | RETURN | return bValidation; |  | 처리 중단/반환 |  |  |  |
| AC-87ee328b | (진입점 미연결) | DMF0035_MktFcstWaterfall.cs:1956 |  | RETURN | return bValidation; |  | 처리 중단/반환 |  |  |  |

## DMF0035_MktFcstWaterfall.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-abf5e2c6 | this.Load | DMF0035_MktFcstWaterfall.cs:207 |  | FLAG | miFormLoad | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-2ed7b5cb | this.Load | DMF0035_MktFcstWaterfall.cs:211 |  | UI_PROP | layoutBtnRedraw.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-e10e7fba | this.Load | DMF0035_MktFcstWaterfall.cs:213 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-7ebc649d | this.Load | DMF0035_MktFcstWaterfall.cs:214 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-be0d95b6 | this.Load | DMF0035_MktFcstWaterfall.cs:221 |  | FLAG | miFormLoad | 1 | 화면 필드/플래그 변경 |  |  |  |

## DMF0035_MktFcstWaterfall.GetBizTypebyDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ee20873d | (진입점 미연결) | DMF0035_MktFcstWaterfall.cs:2115 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION") ⇒ SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-19858d0f | (진입점 미연결) | DMF0035_MktFcstWaterfall.cs:2116 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-f2f0d2d2 | (진입점 미연결) | DMF0035_MktFcstWaterfall.cs:2117 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e34faa71 | (진입점 미연결) | DMF0035_MktFcstWaterfall.cs:2120 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0035_MktFcstWaterfall.GetBucketType

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-90f61943 | this.Load | DMF0035_MktFcstWaterfall.cs:2044 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0003_GET_REPORT_BUCKET_TYPE_CODE") ⇒ DM.DMF0003_GET_REPORT_BUCKET_TYPE_CODE | 엔드포인트 요청 생성 |  |  |  |
| AC-25af1bd3 | this.Load | DMF0035_MktFcstWaterfall.cs:2045 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-07712a49 | this.Load | DMF0035_MktFcstWaterfall.cs:2048 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0035_MktFcstWaterfall.GetCustomerbyDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-03435af1 | (진입점 미연결) | DMF0035_MktFcstWaterfall.cs:2100 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_CUSTOMER_BY_DIVISION") ⇒ SCM.SCM0001_GET_CUSTOMER_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-34b60de8 | (진입점 미연결) | DMF0035_MktFcstWaterfall.cs:2101 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-8af65663 | (진입점 미연결) | DMF0035_MktFcstWaterfall.cs:2102 |  | DATA_OP | request.Parameters["p_dept_id"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-8e0c47ed | (진입점 미연결) | DMF0035_MktFcstWaterfall.cs:2103 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-6c3eb26d | (진입점 미연결) | DMF0035_MktFcstWaterfall.cs:2106 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0035_MktFcstWaterfall.GetDayRange

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0a07618a | this.Load | DMF0035_MktFcstWaterfall.cs:2011 |  | ENDPOINT | new FoxDataRequest | ("DM.PR_GET_DAY_RANGE") ⇒ DM.PR_GET_DAY_RANGE | 엔드포인트 요청 생성 |  |  |  |
| AC-75201c7e | this.Load | DMF0035_MktFcstWaterfall.cs:2012 |  | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-f411aaf8 | this.Load | DMF0035_MktFcstWaterfall.cs:2013 |  | DATA_OP | request.Parameters["p_month"] | 6 | 행/컬럼 값 대입 |  |  |  |
| AC-090910b1 | this.Load | DMF0035_MktFcstWaterfall.cs:2015 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-06b35b94 | this.Load | DMF0035_MktFcstWaterfall.cs:2018 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |

## DMF0035_MktFcstWaterfall.GetDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d4e8d691 | (진입점 미연결) | DMF0035_MktFcstWaterfall.cs:1965 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_DIVISION") ⇒ SCM.SCM0001_GET_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-b701542e | (진입점 미연결) | DMF0035_MktFcstWaterfall.cs:1967 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-fb3badb3 | (진입점 미연결) | DMF0035_MktFcstWaterfall.cs:1970 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0035_MktFcstWaterfall.GetEdiSender

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e6a4b174 | (진입점 미연결) | DMF0035_MktFcstWaterfall.cs:2296 |  | ENDPOINT | new FoxDataRequest | ("DM.UP_FX_GetCommonDataList_DM") ⇒ DM.UP_FX_GetCommonDataList_DM | 엔드포인트 요청 생성 |  |  |  |
| AC-182fe1e8 | (진입점 미연결) | DMF0035_MktFcstWaterfall.cs:2297 |  | DATA_OP | request.Parameters["CODE"] | "EDI_SENDER_CODE" | 행/컬럼 값 대입 |  |  |  |
| AC-57c290f7 | (진입점 미연결) | DMF0035_MktFcstWaterfall.cs:2298 |  | DATA_OP | request.Parameters["PARAM1"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-6bc05bd1 | (진입점 미연결) | DMF0035_MktFcstWaterfall.cs:2299 |  | DATA_OP | request.Parameters["PARAM2"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-96745e1a | (진입점 미연결) | DMF0035_MktFcstWaterfall.cs:2300 |  | DATA_OP | request.Parameters["PARAM3"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-bb3981f3 | (진입점 미연결) | DMF0035_MktFcstWaterfall.cs:2301 |  | DATA_OP | request.Parameters["PARAM4"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-e3f0b606 | (진입점 미연결) | DMF0035_MktFcstWaterfall.cs:2302 |  | DATA_OP | request.Parameters["PARAM5"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-bfe0b638 | (진입점 미연결) | DMF0035_MktFcstWaterfall.cs:2303 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-143a52ac | (진입점 미연결) | DMF0035_MktFcstWaterfall.cs:2305 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0035_MktFcstWaterfall.GetItemType

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-079a82b9 | this.Load | DMF0035_MktFcstWaterfall.cs:2071 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_LOOKUP_VALUES") ⇒ SCM.SCM0001_GET_LOOKUP_VALUES | 엔드포인트 요청 생성 |  |  |  |
| AC-8e13ed7a | this.Load | DMF0035_MktFcstWaterfall.cs:2072 |  | DATA_OP | request.Parameters["p_lookup_type"] | "ITEM_TYPE_CODE" | 행/컬럼 값 대입 |  |  |  |
| AC-b768b6b6 | this.Load | DMF0035_MktFcstWaterfall.cs:2073 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-5c92e791 | this.Load | DMF0035_MktFcstWaterfall.cs:2076 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0035_MktFcstWaterfall.GetLastWeekSunDayByDate

진입점: this.btnDrawTest.Click [if (chkColor.Checked == true)] / FindButton [try ▸ if (chkColor.Checked == true)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a78dd94d | this.btnDrawTest.Click [if (chkColor.Checked == true)] 외 1 | DMF0035_MktFcstWaterfall.cs:2169 |  | RETURN | return sYYYYMMDD; |  | 처리 중단/반환 |  |  |  |

## DMF0035_MktFcstWaterfall.GetPlantSitebyEndCustomer

진입점: this.spdMain.ComboSelChange [if (e.Column == siMain.GetColumnIndex(DefColumns.Division))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4c80c94b | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DMF0035_MktFcstWaterfall.cs:1995 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER") ⇒ SCM.SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER | 엔드포인트 요청 생성 |  |  |  |
| AC-62196cd3 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DMF0035_MktFcstWaterfall.cs:1996 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-91ba40e5 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DMF0035_MktFcstWaterfall.cs:1997 |  | DATA_OP | request.Parameters["p_dept_id"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-17c3dfa6 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DMF0035_MktFcstWaterfall.cs:1998 |  | DATA_OP | request.Parameters["p_end_customer"] | sEdnCustomer | 행/컬럼 값 대입 |  |  |  |
| AC-ea90a20e | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DMF0035_MktFcstWaterfall.cs:1999 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-5415a259 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DMF0035_MktFcstWaterfall.cs:2002 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0035_MktFcstWaterfall.GetQtyData

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a1d20578 | this.Load | DMF0035_MktFcstWaterfall.cs:2058 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0003_GET_QTY_TYPE_CODE") ⇒ DM.DMF0003_GET_QTY_TYPE_CODE | 엔드포인트 요청 생성 |  |  |  |
| AC-7a250dce | this.Load | DMF0035_MktFcstWaterfall.cs:2059 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-944ba81d | this.Load | DMF0035_MktFcstWaterfall.cs:2062 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0035_MktFcstWaterfall.GetScmSitebyDivision

진입점: this.spdMain.ComboSelChange [if (e.Column == siMain.GetColumnIndex(DefColumns.Division))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f1211738 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DMF0035_MktFcstWaterfall.cs:1979 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_SITE_BY_DIVISION") ⇒ SCM.SCM0001_GET_SITE_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-1382ccb6 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DMF0035_MktFcstWaterfall.cs:1980 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-9540daa3 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DMF0035_MktFcstWaterfall.cs:1981 |  | DATA_OP | request.Parameters["p_dept_id"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-bc273d99 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DMF0035_MktFcstWaterfall.cs:1982 |  | DATA_OP | request.Parameters["p_end_customer"] | sEdnCustomer | 행/컬럼 값 대입 |  |  |  |
| AC-5cd76409 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DMF0035_MktFcstWaterfall.cs:1983 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e7770f85 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DMF0035_MktFcstWaterfall.cs:1986 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0035_MktFcstWaterfall.GetSpdTitle

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)] / this.cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if ((fBucket == BucketType.Weekly \|\| fBucket == BucketType.Monthly) && sBucket == BucketType.Daily)] / this.Load / cboDivision.SelectedIndexChanged [if (miFormLoad == 1)] / cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if ((fBucket == BucketType.Weekly \|\| fBucket == BucketType.Monthly) && sBucket == BucketType.Daily)] / FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4d4f2c13 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 6 | DMF0035_MktFcstWaterfall.cs:2024 |  | FLAG | fBucket | cboBucketType.ControlValues | 화면 필드/플래그 변경 |  |  |  |
| AC-f69c63a0 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 6 | DMF0035_MktFcstWaterfall.cs:2028 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0035_GET_SPREAD_TITLE") ⇒ DM.DMF0035_GET_SPREAD_TITLE | 엔드포인트 요청 생성 |  |  |  |
| AC-5b18dca7 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 6 | DMF0035_MktFcstWaterfall.cs:2029 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | sMonth[0] | 행/컬럼 값 대입 |  |  |  |
| AC-8a09f630 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 6 | DMF0035_MktFcstWaterfall.cs:2030 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | sMonth[1] | 행/컬럼 값 대입 |  |  |  |
| AC-ed61992a | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 6 | DMF0035_MktFcstWaterfall.cs:2031 |  | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-d347740b | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 6 | DMF0035_MktFcstWaterfall.cs:2032 |  | DATA_OP | request.Parameters["p_division_id"] | cboDivision.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-9e0392cd | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 6 | DMF0035_MktFcstWaterfall.cs:2033 |  | DATA_OP | request.Parameters["p_bucket"] | fBucket | 행/컬럼 값 대입 |  |  |  |
| AC-ad57ed25 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 6 | DMF0035_MktFcstWaterfall.cs:2035 |  | FLAG | dtTitle | client.ExecuteDataSet(request).DataSet.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-2a2c54b2 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 6 | DMF0035_MktFcstWaterfall.cs:2035 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## DMF0035_MktFcstWaterfall.GetTeambyDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-995f7285 | (진입점 미연결) | DMF0035_MktFcstWaterfall.cs:2086 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_TEAM_BY_DIVISION") ⇒ SCM.SCM0001_GET_TEAM_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-2ae23d09 | (진입점 미연결) | DMF0035_MktFcstWaterfall.cs:2087 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-5826919b | (진입점 미연결) | DMF0035_MktFcstWaterfall.cs:2088 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-272b8421 | (진입점 미연결) | DMF0035_MktFcstWaterfall.cs:2091 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0035_MktFcstWaterfall.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-93a366a9 | this.Load | DMF0035_MktFcstWaterfall.cs:312 |  | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtMain) | 데이터 객체 조작/조회 |  |  |  |
| AC-31da0336 | this.Load | DMF0035_MktFcstWaterfall.cs:318 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, cboDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-bb2e65ef | this.Load | DMF0035_MktFcstWaterfall.cs:327 |  | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-f05bd8e6 | this.Load | DMF0035_MktFcstWaterfall.cs:332 |  | STATE | lblEDISender.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-ba2dc0c1 | this.Load | DMF0035_MktFcstWaterfall.cs:340 | if ((cboDivision.ControlValues.Substring(0, 2) == "81") \|\| (cboDivision.ControlValues == "82")) | LIST_REBIND | clsCtrl.setListBox | (dtCustomer, clbCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-0626052f | this.Load | DMF0035_MktFcstWaterfall.cs:346 | if ((cboDivision.ControlValues.Substring(0, 2) == "81") \|\| (cboDivision.ControlValues == "82")) | LIST_REBIND | clsCtrl.setListBox | (dtBizType, clbBizType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-d47acbca | this.Load | DMF0035_MktFcstWaterfall.cs:347 | if ((cboDivision.ControlValues.Substring(0, 2) == "81") \|\| (cboDivision.ControlValues == "82")) | STATE | cboCellQty.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-cd5d797c | this.Load | DMF0035_MktFcstWaterfall.cs:348 | if ((cboDivision.ControlValues.Substring(0, 2) == "81") \|\| (cboDivision.ControlValues == "82")) | VALUE_SET | cboCellQty.Checked | false | 컨트롤 값 설정 |  |  |  |
| AC-4ef6816b | this.Load | DMF0035_MktFcstWaterfall.cs:352 | if ((cboDivision.ControlValues.Substring(0, 2) == "81") \|\| (cboDivision.ControlValues == "82")) ▸ if (sDivision == "81") | STATE | lblEDISender.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-bf239117 | this.Load | DMF0035_MktFcstWaterfall.cs:358 | if ((cboDivision.ControlValues.Substring(0, 2) == "81") \|\| (cboDivision.ControlValues == "82")) ▸ if (sDivision == "81") | LIST_REBIND | clsCtrl.setListBox | (dtEdiSender, clbEDISender, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-d76b3f92 | this.Load | DMF0035_MktFcstWaterfall.cs:367 | else of ((cboDivision.ControlValues.Substring(0, 2) == "81") \|\| (cboDivision.ControlValues == "82")) | LIST_REBIND | clsCtrl.setListBox | (dtCustomer, clbCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-ecc321f0 | this.Load | DMF0035_MktFcstWaterfall.cs:373 | else of ((cboDivision.ControlValues.Substring(0, 2) == "81") \|\| (cboDivision.ControlValues == "82")) | LIST_REBIND | clsCtrl.setListBox | (dtBizType, clbBizType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-ad297fee | this.Load | DMF0035_MktFcstWaterfall.cs:374 | else of ((cboDivision.ControlValues.Substring(0, 2) == "81") \|\| (cboDivision.ControlValues == "82")) | STATE | cboCellQty.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-d96ccdc0 | this.Load | DMF0035_MktFcstWaterfall.cs:379 |  | STATE | lblBizType.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-14298560 | this.Load | DMF0035_MktFcstWaterfall.cs:380 |  | VALUE_SET | chkSum.Checked | false | 컨트롤 값 설정 |  |  |  |
| AC-ef060d79 | this.Load | DMF0035_MktFcstWaterfall.cs:381 |  | VALUE_SET | chkColor.Checked | false | 컨트롤 값 설정 |  |  |  |
| AC-aa2c0669 | this.Load | DMF0035_MktFcstWaterfall.cs:389 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-ac939b96 | this.Load | DMF0035_MktFcstWaterfall.cs:395 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantSite, clbPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-6bd3fc5e | this.Load | DMF0035_MktFcstWaterfall.cs:397 |  | FLAG | dtBucketType | GetBucketType() | 화면 필드/플래그 변경 |  |  |  |
| AC-757bd1d6 | this.Load | DMF0035_MktFcstWaterfall.cs:398 |  | LIST_REBIND | clsCtrl.setListBox | (dtBucketType, cboBucketType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-c03b9140 | this.Load | DMF0035_MktFcstWaterfall.cs:406 |  | VALUE_SET | drpPeriod.InitValue | GetDayRange() | 컨트롤 값 설정 |  |  |  |
| AC-6521c7e9 | this.Load | DMF0035_MktFcstWaterfall.cs:408 |  | FLAG | dtItemType | GetItemType() | 화면 필드/플래그 변경 |  |  |  |
| AC-3aa25d0f | this.Load | DMF0035_MktFcstWaterfall.cs:409 |  | LIST_REBIND | clsCtrl.setListBox | (dtItemType, clbItemType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-bd7afa16 | this.Load | DMF0035_MktFcstWaterfall.cs:412 |  | FLAG | dtQty | GetQtyData() | 화면 필드/플래그 변경 |  |  |  |
| AC-53915ca8 | this.Load | DMF0035_MktFcstWaterfall.cs:413 |  | LIST_REBIND | clsCtrl.setListBox | (dtQty, cboQTY, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-5dadcb0d | this.Load | DMF0035_MktFcstWaterfall.cs:417 |  | CALL_EXT | toolTip1.SetToolTip | (btnColumn, "Column Show") | ⚠ 의미 확인 필요 |  |  |  |
| AC-5d1cbf6d | this.Load | DMF0035_MktFcstWaterfall.cs:418 |  | CALL_EXT | toolTip1.SetToolTip | (btnMeasure, "Measure") | ⚠ 의미 확인 필요 |  |  |  |
| AC-91280104 | this.Load | DMF0035_MktFcstWaterfall.cs:422 | if (dtDivision.Rows.Count > 1) | VALUE_SET | cboDivision.SelectedIndex | 1 | 컨트롤 값 설정 |  |  |  |

## DMF0035_MktFcstWaterfall.InitSpread

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)] / this.cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if ((fBucket == BucketType.Weekly \|\| fBucket == BucketType.Monthly) && sBucket == BucketType.Daily)] / this.Load / cboDivision.SelectedIndexChanged [if (miFormLoad == 1)] / cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if ((fBucket == BucketType.Weekly \|\| fBucket == BucketType.Monthly) && sBucket == BucketType.Daily)] / FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d3ec3c37 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 6 | DMF0035_MktFcstWaterfall.cs:445 |  | GRID_INIT | siMain.CreateSheetHeaderColumn | (siMain, 3, dtTitle) | 그리드 재구성/초기화 |  |  |  |
| AC-75ccab69 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 6 | DMF0035_MktFcstWaterfall.cs:452 | if (dtTitle != null && dtTitle.Rows.Count > 0) ▸ if (cboBucketType.ControlValues == BucketType.ONLY_WEEKLY) | STATE | chkSum.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-1e05fd1d | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 6 | DMF0035_MktFcstWaterfall.cs:453 | if (dtTitle != null && dtTitle.Rows.Count > 0) ▸ if (cboBucketType.ControlValues == BucketType.ONLY_WEEKLY) | VALUE_SET | chkSum.Checked | false | 컨트롤 값 설정 |  |  |  |
| AC-6a8fffa7 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 6 | DMF0035_MktFcstWaterfall.cs:459 | if (dtTitle != null && dtTitle.Rows.Count > 0) ▸ else of (cboBucketType.ControlValues == BucketType.ONLY_WEEKLY) | STATE | chkSum.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## DMF0035_MktFcstWaterfall.InitSpreadFooterSum

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / this.cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if ((fBucket == BucketType.Weekly \|\| fBucket == BucketType.Monthly) && sBucket == BucketType.Daily) ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / this.Load [if (dtTitle != null && dtTitle.Rows.Count > 0)] / cboDivision.SelectedIndexChanged [if (miFormLoad == 1) ▸ if (dtTitle != null && dtTitle.Row…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5b7cbd14 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 6 | DMF0035_MktFcstWaterfall.cs:473 |  | GRID_SET | siMain.ActiveSheet.ColumnFooter.Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-ffe1f796 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 6 | DMF0035_MktFcstWaterfall.cs:474 |  | GRID_SET | siMain.ActiveSheet.ColumnFooter.Cells[0, 1].Value | "Sum" | 그리드 속성/값 설정 |  |  |  |
| AC-25567736 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 6 | DMF0035_MktFcstWaterfall.cs:481 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("M_") == … | CALL_EXT | siMain.ActiveSheet.ColumnFooter.SetAggregationFormat | (0, iCol, "{0:#,##0.###}") | ⚠ 의미 확인 필요 |  |  |  |
| AC-9b9f71e7 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 6 | DMF0035_MktFcstWaterfall.cs:482 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("M_") == … | CALL_EXT | siMain.ActiveSheet.ColumnFooter.SetAggregationType | (0, iCol, FarPoint.Win.Spread.Model.AggregationType.SumIgnoreHidden) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f646939a | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 6 | DMF0035_MktFcstWaterfall.cs:483 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("M_") == … | GRID_SET | siMain.ActiveSheet.ColumnFooter.Cells[0, iCol].BackColor | Color.LightGray | 그리드 속성/값 설정 |  |  |  |
| AC-d2fc9f30 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 6 | DMF0035_MktFcstWaterfall.cs:484 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("M_") == … | GRID_SET | siMain.ActiveSheet.ColumnFooter.Cells[0, iCol].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |

## DMF0035_MktFcstWaterfall.SetAmountCalculating

진입점: this.cboQTY.SelectedIndexChanged / FindButton [try ▸ if (sDivision == "40") ▸ if (cboQTY.SelectedIndex != 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f5a486fc | this.cboQTY.SelectedIndexChanged 외 1 | DMF0035_MktFcstWaterfall.cs:2206 | if (siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-edef280f | this.cboQTY.SelectedIndexChanged 외 1 | DMF0035_MktFcstWaterfall.cs:2210 | if (dsOrigianlCopy == null) | FLAG | dsOrigianlCopy | siMain.SpreadObject.DataSource as DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-5311e2b1 | this.cboQTY.SelectedIndexChanged 외 1 | DMF0035_MktFcstWaterfall.cs:2216 | if (cboQTY.SelectedIndex == 0) | LIST_BIND | siMain.SpreadObject.DataSource | dsOrigianlCopy | 목록/그리드 데이터 원천 연결 |  |  |  |
| AC-213eba7c | this.cboQTY.SelectedIndexChanged 외 1 | DMF0035_MktFcstWaterfall.cs:2217 | if (cboQTY.SelectedIndex == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3eb25a0a | this.cboQTY.SelectedIndexChanged 외 1 | DMF0035_MktFcstWaterfall.cs:2220 |  | DATA_OP | dsOrigianlCopy.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-45c82a8f | this.cboQTY.SelectedIndexChanged 외 1 | DMF0035_MktFcstWaterfall.cs:2222 |  | DATA_OP | dsKrw.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-14976196 | this.cboQTY.SelectedIndexChanged 외 1 | DMF0035_MktFcstWaterfall.cs:2262 | for (i < dsOrigianlCopy.Tables[0].Rows.Count) ▸ for (j < dsKrw.Tables[0].Columns.Count) ▸ if (dsKrw.Tables[0].Columns[j].ColumnName.IndexOf(… | GRID_SET | dsKrw.Tables[0].Rows[i][j] | Math.Round(Convert.ToDouble(slValue) / dbQtyDivideAmount, 2) | 그리드 속성/값 설정 |  |  |  |
| AC-ee862147 | this.cboQTY.SelectedIndexChanged 외 1 | DMF0035_MktFcstWaterfall.cs:2268 |  | DATA_OP | dsKrw.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-a99e9a6f | this.cboQTY.SelectedIndexChanged 외 1 | DMF0035_MktFcstWaterfall.cs:2274 | if (ds != null) | UI_MISC | ds.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-57303828 | this.cboQTY.SelectedIndexChanged 외 1 | DMF0035_MktFcstWaterfall.cs:2278 |  | LIST_BIND | siMain.SpreadObject.DataSource | dsKrw | 목록/그리드 데이터 원천 연결 |  |  |  |
| AC-65227dc4 | this.cboQTY.SelectedIndexChanged 외 1 | DMF0035_MktFcstWaterfall.cs:2282 | if (dsKrw != null) | UI_MISC | dsKrw.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-7b3cb1db | this.cboQTY.SelectedIndexChanged 외 1 | DMF0035_MktFcstWaterfall.cs:2285 |  | CALL_EXT | GC.Collect | () | ⚠ 의미 확인 필요 |  |  |  |

## DMF0035_MktFcstWaterfall.SetChangeControl

진입점: this.Load / cboDivision.SelectedIndexChanged / this.clbTeam.SelectedIndexChanged [if (sDivision != null && sDivision != "") ▸ if ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82"))] / this.clbCustomer.SelectedIndexChanged [if (sDivision != null && sDivision != "") ▸ if ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82"))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1e5df904 | this.Load 외 3 | DMF0035_MktFcstWaterfall.cs:237 |  | DATA_OP | Filter["GROUP_ID"] | UserInfoContext.Current["NowGroupID"] | 행/컬럼 값 대입 |  |  |  |
| AC-a5938b3d | this.Load 외 3 | DMF0035_MktFcstWaterfall.cs:238 |  | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-7e50d495 | this.Load 외 3 | DMF0035_MktFcstWaterfall.cs:244 | switch (triggerControl) case "MyDivision": | FLAG | dtDivision | DataService.GetDMInnerTable("MyDivision", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-a5b9e32d | this.Load 외 3 | DMF0035_MktFcstWaterfall.cs:244 | switch (triggerControl) case "MyDivision": | COMBO_DATA | DataService.GetDMInnerTable | ("MyDivision", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-d4bac998 | this.Load 외 3 | DMF0035_MktFcstWaterfall.cs:249 | switch (triggerControl) case "UserTeamByDivision": | DATA_OP | Filter["DIVISION_ID"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-08d8610a | this.Load 외 3 | DMF0035_MktFcstWaterfall.cs:251 | switch (triggerControl) case "UserTeamByDivision": | FLAG | dtTeam | DataService.GetDMInnerTable("UserTeamByDivision", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-c0830d64 | this.Load 외 3 | DMF0035_MktFcstWaterfall.cs:251 | switch (triggerControl) case "UserTeamByDivision": | COMBO_DATA | DataService.GetDMInnerTable | ("UserTeamByDivision", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-273155a6 | this.Load 외 3 | DMF0035_MktFcstWaterfall.cs:256 | switch (triggerControl) case "EndCustomerByDivision": | DATA_OP | Filter["DIVISION_ID"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-95e0ee28 | this.Load 외 3 | DMF0035_MktFcstWaterfall.cs:257 | switch (triggerControl) case "EndCustomerByDivision": | DATA_OP | Filter["DEPT_ID"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-d33fa0c3 | this.Load 외 3 | DMF0035_MktFcstWaterfall.cs:259 | switch (triggerControl) case "EndCustomerByDivision": | FLAG | dtCustomer | DataService.GetDMInnerTable("EndCustomerByDivision", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-0f376bfa | this.Load 외 3 | DMF0035_MktFcstWaterfall.cs:259 | switch (triggerControl) case "EndCustomerByDivision": | COMBO_DATA | DataService.GetDMInnerTable | ("EndCustomerByDivision", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-5a9891ac | this.Load 외 3 | DMF0035_MktFcstWaterfall.cs:264 | switch (triggerControl) case "BizType": | DATA_OP | Filter["DIVISION_ID"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-569256ff | this.Load 외 3 | DMF0035_MktFcstWaterfall.cs:266 | switch (triggerControl) case "BizType": | FLAG | dtBizType | DataService.GetDMInnerTable("BizType", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-a1813f24 | this.Load 외 3 | DMF0035_MktFcstWaterfall.cs:266 | switch (triggerControl) case "BizType": | COMBO_DATA | DataService.GetDMInnerTable | ("BizType", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-d20b60c3 | this.Load 외 3 | DMF0035_MktFcstWaterfall.cs:271 | switch (triggerControl) case "UserSiteByEndCustomer": | DATA_OP | Filter["DIVISION_ID"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-ba0077bf | this.Load 외 3 | DMF0035_MktFcstWaterfall.cs:272 | switch (triggerControl) case "UserSiteByEndCustomer": | DATA_OP | Filter["DEPT_ID"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-bbc9af7a | this.Load 외 3 | DMF0035_MktFcstWaterfall.cs:273 | switch (triggerControl) case "UserSiteByEndCustomer": | DATA_OP | Filter["END_CUSTOMER"] | sEndCustomer | 행/컬럼 값 대입 |  |  |  |
| AC-32e2e42b | this.Load 외 3 | DMF0035_MktFcstWaterfall.cs:275 | switch (triggerControl) case "UserSiteByEndCustomer": | FLAG | dtSalesSite | DataService.GetDMInnerTable("UserSiteByEndCustomer", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-2b4e2b39 | this.Load 외 3 | DMF0035_MktFcstWaterfall.cs:275 | switch (triggerControl) case "UserSiteByEndCustomer": | COMBO_DATA | DataService.GetDMInnerTable | ("UserSiteByEndCustomer", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-89b44696 | this.Load 외 3 | DMF0035_MktFcstWaterfall.cs:280 | switch (triggerControl) case "UserPlantSiteByDivision": | DATA_OP | Filter["DIVISION_ID"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-37ff2513 | this.Load 외 3 | DMF0035_MktFcstWaterfall.cs:282 | switch (triggerControl) case "UserPlantSiteByDivision": | FLAG | dtPlantSite | DataService.GetDMInnerTable("UserPlantSiteByDivision", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-cdf96712 | this.Load 외 3 | DMF0035_MktFcstWaterfall.cs:282 | switch (triggerControl) case "UserPlantSiteByDivision": | COMBO_DATA | DataService.GetDMInnerTable | ("UserPlantSiteByDivision", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-76662e37 | this.Load 외 3 | DMF0035_MktFcstWaterfall.cs:295 | switch (triggerControl) case "EdiSender": | FLAG | dtEdiSender | DataService.GetDMInnerTable("EdiSender", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-b4d6081a | this.Load 외 3 | DMF0035_MktFcstWaterfall.cs:295 | switch (triggerControl) case "EdiSender": | COMBO_DATA | DataService.GetDMInnerTable | ("EdiSender", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |

## DMF0035_MktFcstWaterfall.SetSpreadColumn

진입점: this.btnDrawTest.Click / this.chkColor.CheckedChanged [if (siMain != null)] / this.chkSum.CheckedChanged [if (siMain != null)] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / this.cboBucketType.SelectedIndexChanged [if (siMain != null)] / this.Load [if (dtTitle != null && dtTitle.Rows.Count > 0)] / cboDivision.SelectedIndexChanged [if (miFormLoad == 1) ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / cboBucke…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1380e95f | this.btnDrawTest.Click 외 9 | DMF0035_MktFcstWaterfall.cs:1851 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siMain.GetColumnTag(iCol).IndexOf("D_"… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-9a5b8026 | this.btnDrawTest.Click 외 9 | DMF0035_MktFcstWaterfall.cs:1854 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siMain.GetColumnTag(iCol).IndexOf("M_"… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-673f8f7a | this.btnDrawTest.Click 외 9 | DMF0035_MktFcstWaterfall.cs:1859 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Bu… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-2e82c9bd | this.btnDrawTest.Click 외 9 | DMF0035_MktFcstWaterfall.cs:1861 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Bu… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-ce5a00bc | this.btnDrawTest.Click 외 9 | DMF0035_MktFcstWaterfall.cs:1864 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Bu… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-ce3647e4 | this.btnDrawTest.Click 외 9 | DMF0035_MktFcstWaterfall.cs:1869 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboBucketType.ControlValues … | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-fe944fd6 | this.btnDrawTest.Click 외 9 | DMF0035_MktFcstWaterfall.cs:1871 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboBucketType.ControlValues … | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-2f3514a4 | this.btnDrawTest.Click 외 9 | DMF0035_MktFcstWaterfall.cs:1880 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (chkColor.Checked == false) ▸ if (siMain.GetColumnTag(iCol).IndexOf("M_") == 0) ▸ if (siMain.G… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Columns[iCol].ForeColor | Color.Green | 그리드 속성/값 설정 |  |  |  |
| AC-e4f6b195 | this.btnDrawTest.Click 외 9 | DMF0035_MktFcstWaterfall.cs:1881 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (chkColor.Checked == false) ▸ if (siMain.GetColumnTag(iCol).IndexOf("M_") == 0) ▸ if (siMain.G… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Columns[iCol].Font | new System.Drawing.Font("굴림", 9F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUn… | 그리드 속성/값 설정 |  |  |  |
| AC-002baab2 | this.btnDrawTest.Click 외 9 | DMF0035_MktFcstWaterfall.cs:1882 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (chkColor.Checked == false) ▸ if (siMain.GetColumnTag(iCol).IndexOf("M_") == 0) ▸ if (siMain.G… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Columns[iCol].Width | 60 | 그리드 속성/값 설정 |  |  |  |
| AC-74aa8bdb | this.btnDrawTest.Click 외 9 | DMF0035_MktFcstWaterfall.cs:1889 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (chkColor.Checked == false) ▸ else of (siMain.GetColumnTag(iCol).IndexOf("M_") == 0) ▸ if (siM… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Columns[iCol].ForeColor | Color.Green | 그리드 속성/값 설정 |  |  |  |
| AC-97870247 | this.btnDrawTest.Click 외 9 | DMF0035_MktFcstWaterfall.cs:1890 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (chkColor.Checked == false) ▸ else of (siMain.GetColumnTag(iCol).IndexOf("M_") == 0) ▸ if (siM… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Columns[iCol].Font | new System.Drawing.Font("굴림", 9F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUn… | 그리드 속성/값 설정 |  |  |  |
| AC-38db2db7 | this.btnDrawTest.Click 외 9 | DMF0035_MktFcstWaterfall.cs:1897 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (chkColor.Checked == false) ▸ else of (siMain.GetColumnTag(iCol).IndexOf("M_") == 0) ▸ if (siM… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Columns[iCol].ForeColor | Color.Green | 그리드 속성/값 설정 |  |  |  |
| AC-014b1176 | this.btnDrawTest.Click 외 9 | DMF0035_MktFcstWaterfall.cs:1898 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (chkColor.Checked == false) ▸ else of (siMain.GetColumnTag(iCol).IndexOf("M_") == 0) ▸ if (siM… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Columns[iCol].Font | new System.Drawing.Font("굴림", 9F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUn… | 그리드 속성/값 설정 |  |  |  |
| AC-57ce77b3 | this.btnDrawTest.Click 외 9 | DMF0035_MktFcstWaterfall.cs:1905 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (chkColor.Checked == false) ▸ if (chkColor.Checked == true) | GRID_STYLE | siMain.ActiveSheet.ColumnHeader.Columns[iCol].ResetForeColor | () | 그리드 표시 설정 |  |  |  |
| AC-c49212b5 | this.btnDrawTest.Click 외 9 | DMF0035_MktFcstWaterfall.cs:1906 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (chkColor.Checked == false) ▸ if (chkColor.Checked == true) | CALL_EXT | siMain.ActiveSheet.ColumnHeader.Columns[iCol].ResetFont | () | ⚠ 의미 확인 필요 |  |  |  |

## DMF0035_MktFcstWaterfall.SetSpreadHeader

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dtTitle != null && dtTitle.Rows.Count > 0) ▸ if (cboBucketType.ControlValues == BucketType.ONLY_WEEKLY)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dtTitle != null && dtTitle.Rows.Count > 0) ▸ if (cboBucketType.ControlValues == BucketType.ONLY_WEEKLY)] / this.cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if ((fBucket == BucketType.Weekly \|\| fBucket == BucketType.Monthly) && sBucket == BucketType.Daily) ▸ if (dtTitle != null && dtTitle.Rows.Count > 0) ▸ if (cboBucketType.ControlValues…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-085b69f9 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 6 | DMF0035_MktFcstWaterfall.cs:505 | foreach (DataRow dr in dt.Rows) ▸ if (iCellCnt < iStartCol) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iCellCnt, 3, 1, 20, sColumnLabel, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b3657f68 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 6 | DMF0035_MktFcstWaterfall.cs:513 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt < iStartCol) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, iStartCol, 0, iStartCol].Text | sLargeLabelName | 그리드 속성/값 설정 |  |  |  |
| AC-f0cc3534 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 6 | DMF0035_MktFcstWaterfall.cs:514 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt < iStartCol) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[1, iStartCol, 1, iStartCol].Text | sSmallLabelName | 그리드 속성/값 설정 |  |  |  |
| AC-4c8ae34c | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 6 | DMF0035_MktFcstWaterfall.cs:515 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt < iStartCol) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[2, iStartCol, 2, iStartCol].Text | "SUM" | 그리드 속성/값 설정 |  |  |  |
| AC-d4c7c0e9 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 6 | DMF0035_MktFcstWaterfall.cs:519 |  | GRID_INIT | siMain.Freeze | (0, siMain.GetColumnIndex(DefColumns.Measure) + 1) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-576e115d | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 6 | DMF0035_MktFcstWaterfall.cs:520 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0035_MktFcstWaterfall.SetSpreadHeaderSpan

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dtTitle != null && dtTitle.Rows.Count > 0) ▸ else of (cboBucketType.ControlValues == BucketType.ONLY_WEEKLY)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dtTitle != null && dtTitle.Rows.Count > 0) ▸ else of (cboBucketType.ControlValues == BucketType.ONLY_WEEKLY)] / this.cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if ((fBucket == BucketType.Weekly \|\| fBucket == BucketType.Monthly) && sBucket == BucketType.Daily) ▸ if (dtTitle != null && dtTitle.Rows.Count > 0) ▸ else of (cboBucketTyp…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-51b81450 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 6 | DMF0035_MktFcstWaterfall.cs:549 | foreach (DataRow dr in dt.Rows) ▸ if (iCellCnt <= iSmallStartCol) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iCellCnt, 3, 1, 20, sColumnLabel, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6f5fe542 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 6 | DMF0035_MktFcstWaterfall.cs:557 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (dr[DefColumns.ColumnName].ToString().IndexOf("B_") > 0) | GRID_INIT | siMain.VisibleColumns | (iCellCnt, false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-95b29f95 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 6 | DMF0035_MktFcstWaterfall.cs:570 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ else of (dr[DefColumns.ColumnName].ToString().IndexOf("B_") > 0) ▸ … | GRID_SET | siMain.Sheet().ColumnHeader.Cells[2, iCellCnt].ForeColor | dr[DefColumns.DayCode].ToString() == DefColumnsLabel.Saturday ? Color.Blue : Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-a899016d | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 6 | DMF0035_MktFcstWaterfall.cs:578 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1d0cbebc | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 6 | DMF0035_MktFcstWaterfall.cs:579 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f7957eaa | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 6 | DMF0035_MktFcstWaterfall.cs:584 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1051cc0e | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 6 | DMF0035_MktFcstWaterfall.cs:585 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 30, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c368b452 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 6 | DMF0035_MktFcstWaterfall.cs:592 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName !=… | GRID_INIT | siMain.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c3eed08d | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 6 | DMF0035_MktFcstWaterfall.cs:593 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName !=… | GRID_INIT | siMain.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-843a8265 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 6 | DMF0035_MktFcstWaterfall.cs:604 |  | GRID_INIT | siMain.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e836f746 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 6 | DMF0035_MktFcstWaterfall.cs:605 |  | GRID_INIT | siMain.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-df662f1d | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 6 | DMF0035_MktFcstWaterfall.cs:606 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-afe6352e | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 6 | DMF0035_MktFcstWaterfall.cs:607 |  | GRID_INIT | siMain.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-270aa2ef | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 6 | DMF0035_MktFcstWaterfall.cs:609 |  | GRID_INIT | siMain.Freeze | (0, siMain.GetColumnIndex(DefColumns.Measure) + 1) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-47b223d1 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 6 | DMF0035_MktFcstWaterfall.cs:610 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0035_MktFcstWaterfall.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9dcdf3db | this.spdMain.CellDoubleClick | DMF0035_MktFcstWaterfall.cs:1640 | if (e.ColumnHeader) ▸ if (siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColum… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | !siMain.ActiveSheet.Columns[iCol].Visible | 그리드 속성/값 설정 |  |  |  |
| AC-a151cff7 | this.spdMain.CellDoubleClick | DMF0035_MktFcstWaterfall.cs:1646 | if (e.ColumnHeader) ▸ if (siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (siMain.Get… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | !siMain.ActiveSheet.Columns[iCol].Visible | 그리드 속성/값 설정 |  |  |  |
| AC-4aacb00e | this.spdMain.CellDoubleClick | DMF0035_MktFcstWaterfall.cs:1652 | if (e.ColumnHeader) ▸ if (siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (siMain.Get… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | !siMain.ActiveSheet.Columns[iCol].Visible | 그리드 속성/값 설정 |  |  |  |
| AC-23eef758 | this.spdMain.CellDoubleClick | DMF0035_MktFcstWaterfall.cs:1670 | if (e.ColumnHeader) ▸ else of (siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ▸ if (siMain.GetColumnTag(e.Column).IndexOf("W_") == 0) ▸ f… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | !siMain.ActiveSheet.Columns[iCol].Visible | 그리드 속성/값 설정 |  |  |  |
| AC-0e371563 | this.spdMain.CellDoubleClick | DMF0035_MktFcstWaterfall.cs:1685 | else of (e.ColumnHeader) ▸ if (siMain.IsLock(siMain.SheetName) \|\| siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) !… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3ee79e36 | this.spdMain.CellDoubleClick | DMF0035_MktFcstWaterfall.cs:1692 | else of (e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.Project)) | POPUP | new SCM0002_ProjectbyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-c29885e2 | this.spdMain.CellDoubleClick | DMF0035_MktFcstWaterfall.cs:1694 | else of (e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.Project)) | POPUP | popProject.Form_Load | (false, sDivision, sProject) | 팝업 초기화(인자 전달) |  |  |  |
| AC-0099c3b6 | this.spdMain.CellDoubleClick | DMF0035_MktFcstWaterfall.cs:1695 | else of (e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.Project)) | UI_PROP | popProject.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-0abfceac | this.spdMain.CellDoubleClick | DMF0035_MktFcstWaterfall.cs:1696 | else of (e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.Project)) | POPUP | popProject.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-5bcd43b9 | this.spdMain.CellDoubleClick | DMF0035_MktFcstWaterfall.cs:1700 | else of (e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.Project)) | GRID_SET | siMain.SetText | (e.Row, e.Column, sProject) | 그리드 값 설정 |  |  |  |
| AC-9ce4d3dd | this.spdMain.CellDoubleClick | DMF0035_MktFcstWaterfall.cs:1709 | else of (e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumn… | POPUP | new SCM0002_ItembyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-bea25362 | this.spdMain.CellDoubleClick | DMF0035_MktFcstWaterfall.cs:1711 | else of (e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumn… | POPUP | popItem.Form_Load | (false, sDivision, sScmSiteId, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-08edfad7 | this.spdMain.CellDoubleClick | DMF0035_MktFcstWaterfall.cs:1712 | else of (e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumn… | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-25638e4e | this.spdMain.CellDoubleClick | DMF0035_MktFcstWaterfall.cs:1713 | else of (e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumn… | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-aac16b83 | this.spdMain.CellDoubleClick | DMF0035_MktFcstWaterfall.cs:1717 | else of (e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumn… | GRID_SET | siMain.SetText | (e.Row, e.Column, sItemId) | 그리드 값 설정 |  |  |  |

## DMF0035_MktFcstWaterfall.spdMain_ComboSelChange

진입점: this.spdMain.ComboSelChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b020c0b3 | this.spdMain.ComboSelChange | DMF0035_MktFcstWaterfall.cs:1623 | if (e.Column == siMain.GetColumnIndex(DefColumns.Division)) | FLAG | dtSalesSite | GetScmSitebyDivision(siMain.GetValue(e.Row, e.Column).ToString(), CAppSetting.StringALL, C… | 화면 필드/플래그 변경 |  |  |  |
| AC-c58dfbfc | this.spdMain.ComboSelChange | DMF0035_MktFcstWaterfall.cs:1624 | if (e.Column == siMain.GetColumnIndex(DefColumns.Division)) | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.ScmSiteId), dtSalesSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-ee8c3978 | this.spdMain.ComboSelChange | DMF0035_MktFcstWaterfall.cs:1626 | if (e.Column == siMain.GetColumnIndex(DefColumns.Division)) | FLAG | dtPlantSite | GetPlantSitebyEndCustomer(siMain.GetValue(e.Row, e.Column).ToString(), CAppSetting.StringA… | 화면 필드/플래그 변경 |  |  |  |
| AC-96ddf648 | this.spdMain.ComboSelChange | DMF0035_MktFcstWaterfall.cs:1627 | if (e.Column == siMain.GetColumnIndex(DefColumns.Division)) | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.PlantSiteId), dtPlantSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |

## DMF0035_MktFcstWaterfall.spdMain_KeyUp

진입점: this.spdMain.KeyUp

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-775f3f53 | this.spdMain.KeyUp | DMF0035_MktFcstWaterfall.cs:1731 | if (siMain.GetColumnIndex(DefColumns.Measure) >= siMain.ActiveColumnIndex) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-81682355 | this.spdMain.KeyUp | DMF0035_MktFcstWaterfall.cs:1735 | if (e.Control == true && e.KeyCode == Keys.V \|\| e.Control == false && e.KeyCode == Keys.V) | CALL_EXT | spdMain.ActiveSheet.ClipboardPaste | (ClipboardPasteOptions.AsStringSkipHidden) | ⚠ 의미 확인 필요 |  |  |  |
| AC-550a970b | this.spdMain.KeyUp | DMF0035_MktFcstWaterfall.cs:1741 | if (e.Control == true && e.KeyCode == Keys.C \|\| e.Control == false && e.KeyCode == Keys.C) | CALL_EXT | Clipboard.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-5f50dde6 | this.spdMain.KeyUp | DMF0035_MktFcstWaterfall.cs:1742 | if (e.Control == true && e.KeyCode == Keys.C \|\| e.Control == false && e.KeyCode == Keys.C) | CALL_EXT | spdMain.Sheets[0].ClipboardCopy | (ClipboardCopyOptions.AsStringSkipHidden) | ⚠ 의미 확인 필요 |  |  |  |

## DMF0035_MktFcstWaterfall.spdMain_TopChange

진입점: this.spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-64c4f9a0 | this.spdMain.TopChange | DMF0035_MktFcstWaterfall.cs:1725 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

