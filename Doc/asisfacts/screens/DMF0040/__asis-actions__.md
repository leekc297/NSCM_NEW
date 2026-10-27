# AS-IS 액션 대조표 — DMF0040

> 원천: `Doc/asisfacts/screens/DMF0040/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 313행 · 메서드 44 · 종류 DATA_OP 56 · ENDPOINT 28 · RETURN 26 · POPUP 24 · UI_PROP 23 · GRID_INIT 23 · LIST_REBIND 22 · GRID_SET 21 · FLAG 20 · STATE 12 · VALUE_SET 11 · UI_MISC 11 · CALL_EXT 9 · MESSAGE 6 · COMBO_DATA 6 · VALUE_CLEAR 4 · GRID_STYLE 3 · LIST_BIND 2 · GRID_COMBO 2 · THROW 1 · VALIDATE 1 · GRID_BIND 1 · GRID_LOCK 1 · ⚠ 의미 확인 필요 9


## DMF0040_MktFcst_Comparison.btnColumn_Click

진입점: this.btnColumn.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-84a2f731 | this.btnColumn.Click | DMF0040_MktFcst_Comparison.cs:1335 |  | POPUP | new DM0002_TitleSetForm_Popup | ("DMF0040", SpdSheet.shtMain, true, cboDivision.ControlValues) | 팝업/폼 생성 |  |  |  |
| AC-2af07cee | this.btnColumn.Click | DMF0040_MktFcst_Comparison.cs:1336 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-cbbd8138 | this.btnColumn.Click | DMF0040_MktFcst_Comparison.cs:1337 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## DMF0040_MktFcst_Comparison.btnItemId_Click

진입점: this.btnItemId.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fd53e1a7 | this.btnItemId.Click | DMF0040_MktFcst_Comparison.cs:1318 |  | POPUP | new DM0002_ItembyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-5e1dffd1 | this.btnItemId.Click | DMF0040_MktFcst_Comparison.cs:1321 |  | POPUP | popItem.Form_Load | (false, sDivision, sTeam, sEndCustomer, sScmSite, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-a02ccf6b | this.btnItemId.Click | DMF0040_MktFcst_Comparison.cs:1322 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-8210cf70 | this.btnItemId.Click | DMF0040_MktFcst_Comparison.cs:1323 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-1c9b1093 | this.btnItemId.Click | DMF0040_MktFcst_Comparison.cs:1329 | if (popItem.ItemID != "") | VALUE_SET | txtItemId.Text | sItemId | 컨트롤 값 설정 |  |  |  |

## DMF0040_MktFcst_Comparison.btnMeasure_Click

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ff8f8694 | (진입점 미연결) | DMF0040_MktFcst_Comparison.cs:1347 |  | POPUP | new DM0002_TitleSetForm_Popup | ("DMF0035", SpdSheet.shtMain, false, cboDivision.ControlValues) | 팝업/폼 생성 |  |  |  |
| AC-622db175 | (진입점 미연결) | DMF0040_MktFcst_Comparison.cs:1349 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-55692574 | (진입점 미연결) | DMF0040_MktFcst_Comparison.cs:1350 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## DMF0040_MktFcst_Comparison.btnOwner_Click

진입점: this.btnOwner.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-57bdaf6f | this.btnOwner.Click | DMF0040_MktFcst_Comparison.cs:1717 |  | POPUP | new DM0020_OwnerbyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-66e3097c | this.btnOwner.Click | DMF0040_MktFcst_Comparison.cs:1720 |  | POPUP | popItem.Form_Load | (true, sDivision, sTeam, sEndCustomer, sScmSiteId, sProject, sItemId, sOwner) | 팝업 초기화(인자 전달) |  |  |  |
| AC-e2bf3619 | this.btnOwner.Click | DMF0040_MktFcst_Comparison.cs:1721 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-41b62bc1 | this.btnOwner.Click | DMF0040_MktFcst_Comparison.cs:1722 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-bf69b132 | this.btnOwner.Click | DMF0040_MktFcst_Comparison.cs:1724 |  | VALUE_SET | txtOwner.Text | popItem.OwnerID | 컨트롤 값 설정 |  |  |  |

## DMF0040_MktFcst_Comparison.btnProject_Click

진입점: this.btnProject.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-798ee78b | this.btnProject.Click | DMF0040_MktFcst_Comparison.cs:1293 |  | POPUP | new DMF000_ProjectbyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-cfee82fd | this.btnProject.Click | DMF0040_MktFcst_Comparison.cs:1295 |  | POPUP | popProject.Form_Load | (true, sDivision, sTeam, sEndCustomer, sScmSiteID, sProject, false) | 팝업 초기화(인자 전달) |  |  |  |
| AC-cac6f7dd | this.btnProject.Click | DMF0040_MktFcst_Comparison.cs:1296 |  | UI_PROP | popProject.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-13e50690 | this.btnProject.Click | DMF0040_MktFcst_Comparison.cs:1297 |  | POPUP | popProject.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-0a87a9d4 | this.btnProject.Click | DMF0040_MktFcst_Comparison.cs:1303 | if (popProject.ProjectCode != "") | VALUE_SET | txtProject.Text | sProjectCode | 컨트롤 값 설정 |  |  |  |

## DMF0040_MktFcst_Comparison.btnVersion_Click

진입점: this.btnVersion.Click / this.txtVersion.KeyDown

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-62022f62 | this.btnVersion.Click 외 1 | DMF0040_MktFcst_Comparison.cs:1636 |  | POPUP | new DMF0000_VersionByWaterfallPopup | () | 팝업/폼 생성 |  |  |  |
| AC-7d44e218 | this.btnVersion.Click 외 1 | DMF0040_MktFcst_Comparison.cs:1637 |  | POPUP | popVersion.Form_Load | (true, "MF", sDivision, sStartTime, sEndTinme) | 팝업 초기화(인자 전달) |  |  |  |
| AC-8fd40e71 | this.btnVersion.Click 외 1 | DMF0040_MktFcst_Comparison.cs:1638 |  | UI_PROP | popVersion.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-33af8c17 | this.btnVersion.Click 외 1 | DMF0040_MktFcst_Comparison.cs:1639 |  | POPUP | popVersion.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-f4585fc6 | this.btnVersion.Click 외 1 | DMF0040_MktFcst_Comparison.cs:1646 | if (popVersion.sVersions != "") ▸ if (sVersion.Length > 2) | MESSAGE | MessageHelper.GMessageBox | ("MSG00255", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-94978466 | this.btnVersion.Click 외 1 | DMF0040_MktFcst_Comparison.cs:1647 | if (popVersion.sVersions != "") ▸ if (sVersion.Length > 2) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1b8b509f | this.btnVersion.Click 외 1 | DMF0040_MktFcst_Comparison.cs:1651 | if (popVersion.sVersions != "") ▸ else of (sVersion.Length > 2) | VALUE_SET | txtVersion.Text | popVersion.sVersions | 컨트롤 값 설정 |  |  |  |
| AC-77e3bbe5 | this.btnVersion.Click 외 1 | DMF0040_MktFcst_Comparison.cs:1652 | if (popVersion.sVersions != "") ▸ else of (sVersion.Length > 2) | VALUE_SET | drpPeriod.InitValue | popVersion.sPeriod | 컨트롤 값 설정 |  |  |  |

## DMF0040_MktFcst_Comparison.cboDivision_SelectedIndexChanged

진입점: this.Load / cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-879e16da | this.Load 외 1 | DMF0040_MktFcst_Comparison.cs:963 |  | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-f726cb7a | this.Load 외 1 | DMF0040_MktFcst_Comparison.cs:970 | if (sDivision == "40") | STATE | lblProject.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-942daad6 | this.Load 외 1 | DMF0040_MktFcst_Comparison.cs:971 | if (sDivision == "40") | STATE | lblPlantSite.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-3e81ca56 | this.Load 외 1 | DMF0040_MktFcst_Comparison.cs:972 | if (sDivision == "40") | STATE | btnProject.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-a54d8f42 | this.Load 외 1 | DMF0040_MktFcst_Comparison.cs:973 | if (sDivision == "40") | STATE | cboCellQty.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-ae99b7fd | this.Load 외 1 | DMF0040_MktFcst_Comparison.cs:979 | if (sDivision == "40") | LIST_REBIND | clsCtrl.setListBox | (dtCustomer, clbCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-cdf60615 | this.Load 외 1 | DMF0040_MktFcst_Comparison.cs:987 | if (sDivision == "40") | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-eeeb76c6 | this.Load 외 1 | DMF0040_MktFcst_Comparison.cs:993 | if (sDivision == "40") | LIST_REBIND | clsCtrl.setListBox | (dtBizType, clbBizType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-d4c96c69 | this.Load 외 1 | DMF0040_MktFcst_Comparison.cs:997 | else of (sDivision == "40") | STATE | lblProject.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-b328690f | this.Load 외 1 | DMF0040_MktFcst_Comparison.cs:998 | else of (sDivision == "40") | STATE | lblPlantSite.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-4925b515 | this.Load 외 1 | DMF0040_MktFcst_Comparison.cs:999 | else of (sDivision == "40") | STATE | btnProject.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-fb9c6b34 | this.Load 외 1 | DMF0040_MktFcst_Comparison.cs:1000 | else of (sDivision == "40") | STATE | cboCellQty.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-3387b07e | this.Load 외 1 | DMF0040_MktFcst_Comparison.cs:1006 | else of (sDivision == "40") | LIST_REBIND | clsCtrl.setListBox | (dtCustomer, clbCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-76f40ff8 | this.Load 외 1 | DMF0040_MktFcst_Comparison.cs:1014 | else of (sDivision == "40") | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-784f94a0 | this.Load 외 1 | DMF0040_MktFcst_Comparison.cs:1020 | else of (sDivision == "40") | LIST_REBIND | clsCtrl.setListBox | (dtBizType, clbBizType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-53ff98ab | this.Load 외 1 | DMF0040_MktFcst_Comparison.cs:1026 |  | STATE | lblBizType.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-a6ff0761 | this.Load 외 1 | DMF0040_MktFcst_Comparison.cs:1032 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantSite, clbPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-51b19691 | this.Load 외 1 | DMF0040_MktFcst_Comparison.cs:1037 |  | VALUE_CLEAR | this.txtProject.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-50370eea | this.Load 외 1 | DMF0040_MktFcst_Comparison.cs:1038 |  | VALUE_CLEAR | this.txtItemId.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-7e8a2a37 | this.Load 외 1 | DMF0040_MktFcst_Comparison.cs:1039 |  | VALUE_CLEAR | this.txtVersion.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-04e40145 | this.Load 외 1 | DMF0040_MktFcst_Comparison.cs:1040 |  | VALUE_CLEAR | this.txtOwner.Text | "" | 컨트롤 값 비움 |  |  |  |

## DMF0040_MktFcst_Comparison.cboQTY_SelectedIndexChanged

진입점: this.cboQTY.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9c3cf72b | this.cboQTY.SelectedIndexChanged | DMF0040_MktFcst_Comparison.cs:1730 | if (siMain == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DMF0040_MktFcst_Comparison.clbCustomer_SelectedIndexChanged

진입점: this.clbCustomer.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b72a97c9 | this.clbCustomer.SelectedIndexChanged | DMF0040_MktFcst_Comparison.cs:1107 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |

## DMF0040_MktFcst_Comparison.clbTeam_SelectedIndexChanged

진입점: this.clbTeam.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-56ea8d21 | this.clbTeam.SelectedIndexChanged | DMF0040_MktFcst_Comparison.cs:1059 | if (sDivision.Substring(0, 2) != null && sDivision.Substring(0, 2) != "") ▸ if ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")… | LIST_REBIND | clsCtrl.setListBox | (dtCustomer, clbCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-f20e11e4 | this.clbTeam.SelectedIndexChanged | DMF0040_MktFcst_Comparison.cs:1072 | if (sDivision.Substring(0, 2) != null && sDivision.Substring(0, 2) != "") ▸ else of ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == … | LIST_REBIND | clsCtrl.setListBox | (dtCustomer, clbCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-cf4ceaac | this.clbTeam.SelectedIndexChanged | DMF0040_MktFcst_Comparison.cs:1080 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |

## DMF0040_MktFcst_Comparison.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5939f387 | this.Load | DMF0040_MktFcst_Comparison.cs:388 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 3, 1, 20) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-bc4b3cad | this.Load | DMF0040_MktFcst_Comparison.cs:389 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-8078486f | this.Load | DMF0040_MktFcst_Comparison.cs:390 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0040_MktFcst_Comparison.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e256822a | this.Load | DMF0040_MktFcst_Comparison.cs:382 |  | UI_PROP | usrConditionPanel1.Height | 105 | 속성 Height 설정 |  |  |  |
| AC-1e7f82c1 | this.Load | DMF0040_MktFcst_Comparison.cs:383 |  | VALUE_SET | cboBucketType.ControlValues | BucketType.Monthly | 컨트롤 값 설정 |  |  |  |

## DMF0040_MktFcst_Comparison.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3cabe59e | Dispose | DMF0040_MktFcst_Comparison.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## DMF0040_MktFcst_Comparison.EditButton

진입점: this.cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if (!siMain.IsLock(siMain.SheetName))] / cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if (!siMain.IsLock(siMain.SheetName))] / EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-34b25823 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0040_MktFcst_Comparison.cs:593 | if (this.fps != null) | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-84fe754b | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0040_MktFcst_Comparison.cs:594 | if (this.fps != null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DMF0040_MktFcst_Comparison.ExcelButton

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6cfc4147 | ExcelButton | DMF0040_MktFcst_Comparison.cs:610 |  | UI_PROP | exportOption.Merge | ExcelMergeOption.None | 속성 Merge 설정 |  |  |  |
| AC-3f1467b8 | ExcelButton | DMF0040_MktFcst_Comparison.cs:611 |  | UI_PROP | exportOption.Border | ExcelBorderOption.All | 속성 Border 설정 |  |  |  |
| AC-7de28e19 | ExcelButton | DMF0040_MktFcst_Comparison.cs:612 |  | UI_PROP | exportOption.AheadZeroOption | ZeroOption.HideZero | 속성 AheadZeroOption 설정 |  |  |  |
| AC-167b4aee | ExcelButton | DMF0040_MktFcst_Comparison.cs:613 |  | UI_PROP | exportOption.AmendZeroOption | ZeroOption.ShowZero | 속성 AmendZeroOption 설정 |  |  |  |
| AC-f773a715 | ExcelButton | DMF0040_MktFcst_Comparison.cs:614 |  | UI_PROP | exportOption.AmendNullToZero | false | 속성 AmendNullToZero 설정 |  |  |  |
| AC-3cf5ca7f | ExcelButton | DMF0040_MktFcst_Comparison.cs:615 |  | UI_PROP | exportOption.AheadNullToZero | false | 속성 AheadNullToZero 설정 |  |  |  |
| AC-94b4fae0 | ExcelButton | DMF0040_MktFcst_Comparison.cs:617 |  | UI_PROP | exportOption.UserName | UserInfo.UserId | 속성 UserName 설정 |  |  |  |
| AC-7b630cdb | ExcelButton | DMF0040_MktFcst_Comparison.cs:618 |  | UI_PROP | exportOption.FileName | sFileName | 속성 FileName 설정 |  |  |  |
| AC-13b2642b | ExcelButton | DMF0040_MktFcst_Comparison.cs:620 |  | UI_PROP | exportOption.AmendDecimalFormat | "#,##0.000;[Red]-#,##0.000" | 속성 AmendDecimalFormat 설정 |  |  |  |
| AC-de5ad51b | ExcelButton | DMF0040_MktFcst_Comparison.cs:629 | try | CALL_EXT | SimplexelService.ExportFpSpread | (fps, exportOption) | ⚠ 의미 확인 필요 |  |  |  |
| AC-961b2dd9 | ExcelButton | DMF0040_MktFcst_Comparison.cs:634 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-23186dae | ExcelButton | DMF0040_MktFcst_Comparison.cs:638 | finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## DMF0040_MktFcst_Comparison.FindData

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-10ff9c5a | FindButton | DMF0040_MktFcst_Comparison.cs:657 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-1849a8a4 | FindButton | DMF0040_MktFcst_Comparison.cs:658 |  | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-cfd5e235 | FindButton | DMF0040_MktFcst_Comparison.cs:662 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-676d2162 | FindButton | DMF0040_MktFcst_Comparison.cs:662 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e3a5e301 | FindButton | DMF0040_MktFcst_Comparison.cs:666 | try | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-ef058b13 | FindButton | DMF0040_MktFcst_Comparison.cs:673 | try ▸ if (sDivision == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00097") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c494841b | FindButton | DMF0040_MktFcst_Comparison.cs:675 | try ▸ if (sDivision == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6ac0f3e5 | FindButton | DMF0040_MktFcst_Comparison.cs:682 | try ▸ if (int.Parse(sPeriod[0]) > int.Parse(sPeriod[1])) | MESSAGE | MessageHelper.GMessageBox | ("MSG00108") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-56ba7b16 | FindButton | DMF0040_MktFcst_Comparison.cs:683 | try ▸ if (int.Parse(sPeriod[0]) > int.Parse(sPeriod[1])) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1bb67eb1 | FindButton | DMF0040_MktFcst_Comparison.cs:688 | try ▸ if (drpPeriod.Value1.AddYears(2) < drpPeriod.Value2) | MESSAGE | MessageHelper.GMessageBox | ("MSG00164") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a41db4e5 | FindButton | DMF0040_MktFcst_Comparison.cs:690 | try ▸ if (drpPeriod.Value1.AddYears(2) < drpPeriod.Value2) | UI_PROP | drpPeriod.Value2 | drpPeriod.Value1.AddYears(2) | 속성 Value2 설정 |  |  |  |
| AC-7e9866fe | FindButton | DMF0040_MktFcst_Comparison.cs:692 | try ▸ if (drpPeriod.Value1.AddYears(2) < drpPeriod.Value2) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-feb37fa2 | FindButton | DMF0040_MktFcst_Comparison.cs:702 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-f63ced7a | FindButton | DMF0040_MktFcst_Comparison.cs:703 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { va… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-56341f11 | FindButton | DMF0040_MktFcst_Comparison.cs:707 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("DM.DMF0040_GET_MKT_FCST_COMPARISON") ⇒ DM.DMF0040_GET_MKT_FCST_COMPARISON | 엔드포인트 요청 생성 |  |  |  |
| AC-63fcacb2 | FindButton | DMF0040_MktFcst_Comparison.cs:709 | try ▸ lambda | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-3b303080 | FindButton | DMF0040_MktFcst_Comparison.cs:711 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-66eb64f7 | FindButton | DMF0040_MktFcst_Comparison.cs:712 | try ▸ lambda | DATA_OP | request.Parameters["p_scm_site_id"] | clbSalesSite.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-df65fc42 | FindButton | DMF0040_MktFcst_Comparison.cs:713 | try ▸ lambda | DATA_OP | request.Parameters["p_plant_site_id"] | clbPlantSite.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-3f043ce0 | FindButton | DMF0040_MktFcst_Comparison.cs:715 | try ▸ lambda | DATA_OP | request.Parameters["p_team_id"] | clbTeam.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-436c347c | FindButton | DMF0040_MktFcst_Comparison.cs:716 | try ▸ lambda | DATA_OP | request.Parameters["p_customer"] | clbCustomer.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-7fdc043f | FindButton | DMF0040_MktFcst_Comparison.cs:717 | try ▸ lambda | DATA_OP | request.Parameters["p_biz_type"] | clbBizType.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-0d707ede | FindButton | DMF0040_MktFcst_Comparison.cs:718 | try ▸ lambda | DATA_OP | request.Parameters["p_project_code"] | txtProject.Text | 행/컬럼 값 대입 |  |  |  |
| AC-cad35c4e | FindButton | DMF0040_MktFcst_Comparison.cs:719 | try ▸ lambda | DATA_OP | request.Parameters["p_item_id"] | txtItemId.Text | 행/컬럼 값 대입 |  |  |  |
| AC-12e06d15 | FindButton | DMF0040_MktFcst_Comparison.cs:720 | try ▸ lambda | DATA_OP | request.Parameters["p_from_yyyymmdd"] | sPeriod[0] | 행/컬럼 값 대입 |  |  |  |
| AC-d6bafcd5 | FindButton | DMF0040_MktFcst_Comparison.cs:721 | try ▸ lambda | DATA_OP | request.Parameters["p_to_yyyymmdd"] | sPeriod[1] | 행/컬럼 값 대입 |  |  |  |
| AC-e3d8a4e6 | FindButton | DMF0040_MktFcst_Comparison.cs:722 | try ▸ lambda | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-4ca9957e | FindButton | DMF0040_MktFcst_Comparison.cs:723 | try ▸ lambda | DATA_OP | request.Parameters["p_version_no"] | txtVersion.Text | 행/컬럼 값 대입 |  |  |  |
| AC-feeccc4d | FindButton | DMF0040_MktFcst_Comparison.cs:724 | try ▸ lambda | DATA_OP | request.Parameters["p_item_type"] | clbItemType.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-e6d9d30f | FindButton | DMF0040_MktFcst_Comparison.cs:725 | try ▸ lambda | DATA_OP | request.Parameters["p_owner"] | txtOwner.Text.Trim() | 행/컬럼 값 대입 |  |  |  |
| AC-cd1484ab | FindButton | DMF0040_MktFcst_Comparison.cs:726 | try ▸ lambda | DATA_OP | request.Parameters["p_diff_only"] | cboDiff.Checked | 행/컬럼 값 대입 |  |  |  |
| AC-da38d772 | FindButton | DMF0040_MktFcst_Comparison.cs:727 | try ▸ lambda | DATA_OP | request.Parameters["p_bucket"] | sBucket | 행/컬럼 값 대입 |  |  |  |
| AC-86104e40 | FindButton | DMF0040_MktFcst_Comparison.cs:728 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-cc6823ef | FindButton | DMF0040_MktFcst_Comparison.cs:730 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-a0c749f2 | FindButton | DMF0040_MktFcst_Comparison.cs:775 | try ▸ if (ds.Tables[0] != null) | UI_PROP | dv.Sort | sOrderBy | 속성 Sort 설정 |  |  |  |
| AC-2cc8a44b | FindButton | DMF0040_MktFcst_Comparison.cs:777 | try ▸ if (ds.Tables[0] != null) | DATA_OP | dsSort.Tables.Add | (dv.ToTable()) | 데이터 객체 조작/조회 |  |  |  |
| AC-afb68c8f | FindButton | DMF0040_MktFcst_Comparison.cs:777 | try ▸ if (ds.Tables[0] != null) | DATA_OP | dv.ToTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-1a85e43b | FindButton | DMF0040_MktFcst_Comparison.cs:779 | try ▸ if (ds.Tables[0] != null) | GRID_BIND | siMain.Query | (dsSort) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-fc0676e3 | FindButton | DMF0040_MktFcst_Comparison.cs:780 | try ▸ if (ds.Tables[0] != null) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2d732683 | FindButton | DMF0040_MktFcst_Comparison.cs:781 | try ▸ if (ds.Tables[0] != null) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-889b5245 | FindButton | DMF0040_MktFcst_Comparison.cs:785 | try ▸ if (ds.Tables[0] != null) ▸ if (dsOrigianlCopy != null) | UI_MISC | dsOrigianlCopy.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-80c522c0 | FindButton | DMF0040_MktFcst_Comparison.cs:786 | try ▸ if (ds.Tables[0] != null) ▸ if (dsOrigianlCopy != null) | FLAG | dsOrigianlCopy | null | 화면 필드/플래그 변경 |  |  |  |
| AC-dee7818d | FindButton | DMF0040_MktFcst_Comparison.cs:794 | try ▸ if (siMain.GetMaxRowIndex() > 0) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-bf668ac0 | FindButton | DMF0040_MktFcst_Comparison.cs:796 | try ▸ if (siMain.GetMaxRowIndex() > 0) | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-02a76c78 | FindButton | DMF0040_MktFcst_Comparison.cs:851 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Only_Weekly) | CALL_EXT | calendar.GetWeekOfYear | (referenceDate, CalendarWeekRule.FirstFourDayWeek, DayOfWeek.Monday) | ⚠ 의미 확인 필요 |  |  |  |
| AC-bea0c3b4 | FindButton | DMF0040_MktFcst_Comparison.cs:902 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetColumnIndex(sLockDate) >= 0) | GRID_STYLE | siMain.SetBGColor | (i, iStartCol, i, iResultCol, Color.Gainsboro) | 그리드 표시 설정 |  |  |  |
| AC-921d98b9 | FindButton | DMF0040_MktFcst_Comparison.cs:907 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetColumnIndex(sLockDate) >= 0) ▸ if (siMain.GetColumnIndex(sUnLockMonth) > 0) | GRID_STYLE | siMain.SetBGColor | (i, iResultMonth, i, iResultMonth, Color.White) | 그리드 표시 설정 |  |  |  |
| AC-de3501ac | FindButton | DMF0040_MktFcst_Comparison.cs:915 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetText(i, siMain.GetColumnIndex(DefColumns.Measure)) == "Difference") | GRID_STYLE | siMain.SetForeColor | (i, siMain.GetColumnIndex(DefColumns.Measure) + 1, i, siMain.GetMaxColumnIndex(), Color.Bl… | 그리드 표시 설정 |  |  |  |
| AC-1a6e972d | FindButton | DMF0040_MktFcst_Comparison.cs:928 | try | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-8df5b99a | FindButton | DMF0040_MktFcst_Comparison.cs:932 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-fd60dda8 | FindButton | DMF0040_MktFcst_Comparison.cs:936 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-cc30c1d8 | FindButton | DMF0040_MktFcst_Comparison.cs:937 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## DMF0040_MktFcst_Comparison.fnValidation

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-20a7ed21 | (진입점 미연결) | DMF0040_MktFcst_Comparison.cs:1458 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (iValidation > 1) | RETURN | return bValidation; |  | 처리 중단/반환 |  |  |  |
| AC-da59d342 | (진입점 미연결) | DMF0040_MktFcst_Comparison.cs:1462 |  | RETURN | return bValidation; |  | 처리 중단/반환 |  |  |  |

## DMF0040_MktFcst_Comparison.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-042ac747 | this.Load | DMF0040_MktFcst_Comparison.cs:190 |  | FLAG | miFormLoad | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-4658733c | this.Load | DMF0040_MktFcst_Comparison.cs:192 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-14353528 | this.Load | DMF0040_MktFcst_Comparison.cs:193 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-a78db4e7 | this.Load | DMF0040_MktFcst_Comparison.cs:200 |  | FLAG | miFormLoad | 1 | 화면 필드/플래그 변경 |  |  |  |

## DMF0040_MktFcst_Comparison.GetBizTypebyDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cd9f0094 | (진입점 미연결) | DMF0040_MktFcst_Comparison.cs:1621 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION") ⇒ SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-73da0d7a | (진입점 미연결) | DMF0040_MktFcst_Comparison.cs:1622 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-c88331f4 | (진입점 미연결) | DMF0040_MktFcst_Comparison.cs:1623 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e4c43d2d | (진입점 미연결) | DMF0040_MktFcst_Comparison.cs:1626 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0040_MktFcst_Comparison.GetBucketType

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8d0ab8c3 | this.Load | DMF0040_MktFcst_Comparison.cs:1550 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0003_GET_REPORT_BUCKET_TYPE_CODE") ⇒ DM.DMF0003_GET_REPORT_BUCKET_TYPE_CODE | 엔드포인트 요청 생성 |  |  |  |
| AC-37d6db6a | this.Load | DMF0040_MktFcst_Comparison.cs:1551 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e8adfe56 | this.Load | DMF0040_MktFcst_Comparison.cs:1554 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0040_MktFcst_Comparison.GetCustomerbyDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-713e2124 | (진입점 미연결) | DMF0040_MktFcst_Comparison.cs:1606 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_CUSTOMER_BY_DIVISION") ⇒ SCM.SCM0001_GET_CUSTOMER_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-820f8220 | (진입점 미연결) | DMF0040_MktFcst_Comparison.cs:1607 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-b587f284 | (진입점 미연결) | DMF0040_MktFcst_Comparison.cs:1608 |  | DATA_OP | request.Parameters["p_dept_id"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-9c931af2 | (진입점 미연결) | DMF0040_MktFcst_Comparison.cs:1609 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-37694fce | (진입점 미연결) | DMF0040_MktFcst_Comparison.cs:1612 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0040_MktFcst_Comparison.GetDayRange

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9a3cac86 | this.Load | DMF0040_MktFcst_Comparison.cs:1517 |  | ENDPOINT | new FoxDataRequest | ("DM.PR_GET_DAY_RANGE") ⇒ DM.PR_GET_DAY_RANGE | 엔드포인트 요청 생성 |  |  |  |
| AC-d2d5ba65 | this.Load | DMF0040_MktFcst_Comparison.cs:1518 |  | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-ffaca488 | this.Load | DMF0040_MktFcst_Comparison.cs:1519 |  | DATA_OP | request.Parameters["p_month"] | 6 | 행/컬럼 값 대입 |  |  |  |
| AC-0443b2f3 | this.Load | DMF0040_MktFcst_Comparison.cs:1521 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-168f68ac | this.Load | DMF0040_MktFcst_Comparison.cs:1524 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |

## DMF0040_MktFcst_Comparison.GetDefaultVersion

진입점: this.Load / cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0c4c5950 | this.Load 외 1 | DMF0040_MktFcst_Comparison.cs:1838 |  | ENDPOINT | new FoxDataRequest | ("DM.SCM0002_GET_VERSIONBYWATERFALLPOPUP") ⇒ DM.SCM0002_GET_VERSIONBYWATERFALLPOPUP | 엔드포인트 요청 생성 |  |  |  |
| AC-71be9fed | this.Load 외 1 | DMF0040_MktFcst_Comparison.cs:1839 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | sStartDate | 행/컬럼 값 대입 |  |  |  |
| AC-36d1d3d0 | this.Load 외 1 | DMF0040_MktFcst_Comparison.cs:1840 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | sEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-011ac50f | this.Load 외 1 | DMF0040_MktFcst_Comparison.cs:1841 |  | DATA_OP | request.Parameters["p_created_by"] | p_created_by | 행/컬럼 값 대입 |  |  |  |
| AC-4c7a14a2 | this.Load 외 1 | DMF0040_MktFcst_Comparison.cs:1842 |  | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-4e27b535 | this.Load 외 1 | DMF0040_MktFcst_Comparison.cs:1843 |  | DATA_OP | request.Parameters["p_version_type"] | p_version_type | 행/컬럼 값 대입 |  |  |  |
| AC-fb910d4d | this.Load 외 1 | DMF0040_MktFcst_Comparison.cs:1844 |  | DATA_OP | request.Parameters["p_version_no"] | p_version_no | 행/컬럼 값 대입 |  |  |  |
| AC-26601b16 | this.Load 외 1 | DMF0040_MktFcst_Comparison.cs:1845 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-14bf4d3f | this.Load 외 1 | DMF0040_MktFcst_Comparison.cs:1846 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-64844876 | this.Load 외 1 | DMF0040_MktFcst_Comparison.cs:1871 | if ((ds != null) && (ds.Tables.Count > 0) && (ds.Tables[0].Rows.Count > 0)) | VALUE_SET | txtVersion.Text | sDefaultVersion | 컨트롤 값 설정 |  |  |  |

## DMF0040_MktFcst_Comparison.GetDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1f227c6a | (진입점 미연결) | DMF0040_MktFcst_Comparison.cs:1471 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_DIVISION") ⇒ SCM.SCM0001_GET_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-b03cb87a | (진입점 미연결) | DMF0040_MktFcst_Comparison.cs:1473 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-bbb40969 | (진입점 미연결) | DMF0040_MktFcst_Comparison.cs:1476 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0040_MktFcst_Comparison.GetItemType

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-44f7e03b | this.Load | DMF0040_MktFcst_Comparison.cs:1577 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_LOOKUP_VALUES") ⇒ SCM.SCM0001_GET_LOOKUP_VALUES | 엔드포인트 요청 생성 |  |  |  |
| AC-0ec88896 | this.Load | DMF0040_MktFcst_Comparison.cs:1578 |  | DATA_OP | request.Parameters["p_lookup_type"] | "ITEM_TYPE_CODE" | 행/컬럼 값 대입 |  |  |  |
| AC-48302c53 | this.Load | DMF0040_MktFcst_Comparison.cs:1579 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-46eb31dd | this.Load | DMF0040_MktFcst_Comparison.cs:1582 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0040_MktFcst_Comparison.GetLastWeekSunDayByDate

진입점: FindButton [try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (sVersion.ToUpper() == "CURRENT" \|\| sVersion.ToUpper() == "")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d13c3607 | FindButton [try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else … | DMF0040_MktFcst_Comparison.cs:1703 |  | RETURN | return sYYYYMMDD; |  | 처리 중단/반환 |  |  |  |

## DMF0040_MktFcst_Comparison.GetPlantSitebyEndCustomer

진입점: this.spdMain.ComboSelChange [if (e.Column == siMain.GetColumnIndex(DefColumns.Division))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b1019658 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DMF0040_MktFcst_Comparison.cs:1501 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER") ⇒ SCM.SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER | 엔드포인트 요청 생성 |  |  |  |
| AC-4aef0a52 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DMF0040_MktFcst_Comparison.cs:1502 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-9384ba9f | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DMF0040_MktFcst_Comparison.cs:1503 |  | DATA_OP | request.Parameters["p_dept_id"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-c817e0f7 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DMF0040_MktFcst_Comparison.cs:1504 |  | DATA_OP | request.Parameters["p_end_customer"] | sEdnCustomer | 행/컬럼 값 대입 |  |  |  |
| AC-5a7256a5 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DMF0040_MktFcst_Comparison.cs:1505 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-42d81001 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DMF0040_MktFcst_Comparison.cs:1508 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0040_MktFcst_Comparison.GetQtyData

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a1d5b1e4 | this.Load | DMF0040_MktFcst_Comparison.cs:1564 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0003_GET_QTY_TYPE_CODE") ⇒ DM.DMF0003_GET_QTY_TYPE_CODE | 엔드포인트 요청 생성 |  |  |  |
| AC-b9465c71 | this.Load | DMF0040_MktFcst_Comparison.cs:1565 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a8d167af | this.Load | DMF0040_MktFcst_Comparison.cs:1568 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0040_MktFcst_Comparison.GetScmSitebyDivision

진입점: this.spdMain.ComboSelChange [if (e.Column == siMain.GetColumnIndex(DefColumns.Division))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b0dabf85 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DMF0040_MktFcst_Comparison.cs:1485 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_SITE_BY_DIVISION") ⇒ SCM.SCM0001_GET_SITE_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-d792f681 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DMF0040_MktFcst_Comparison.cs:1486 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-0f33340f | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DMF0040_MktFcst_Comparison.cs:1487 |  | DATA_OP | request.Parameters["p_dept_id"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-ad4b533c | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DMF0040_MktFcst_Comparison.cs:1488 |  | DATA_OP | request.Parameters["p_end_customer"] | sEdnCustomer | 행/컬럼 값 대입 |  |  |  |
| AC-8da8459c | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DMF0040_MktFcst_Comparison.cs:1489 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-46d8d904 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DMF0040_MktFcst_Comparison.cs:1492 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0040_MktFcst_Comparison.GetSpdTitle

진입점: this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)] / this.cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if (cboBucketType.ControlValues == BucketType.Only_Weekly \|\| fBucket == BucketType.Only_Weekly)] / this.Load / cboDivision.SelectedIndexChanged [if (miFormLoad == 1)] / cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if (cboBucketType.ControlValues == BucketType.Only_Weekly \|\| fBucket == BucketType.Only_Weekly)] / FindButton [try] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c3defc26 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 6 | DMF0040_MktFcst_Comparison.cs:1530 |  | FLAG | fBucket | cboBucketType.ControlValues | 화면 필드/플래그 변경 |  |  |  |
| AC-1bcfe357 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 6 | DMF0040_MktFcst_Comparison.cs:1534 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0040_GET_SPREAD_TITLE") ⇒ DM.DMF0040_GET_SPREAD_TITLE | 엔드포인트 요청 생성 |  |  |  |
| AC-2e39f296 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 6 | DMF0040_MktFcst_Comparison.cs:1535 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | sMonth[0] | 행/컬럼 값 대입 |  |  |  |
| AC-45303cef | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 6 | DMF0040_MktFcst_Comparison.cs:1536 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | sMonth[1] | 행/컬럼 값 대입 |  |  |  |
| AC-17cb042f | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 6 | DMF0040_MktFcst_Comparison.cs:1537 |  | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-989d9182 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 6 | DMF0040_MktFcst_Comparison.cs:1538 |  | DATA_OP | request.Parameters["p_division_id"] | cboDivision.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-673256f3 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 6 | DMF0040_MktFcst_Comparison.cs:1539 |  | DATA_OP | request.Parameters["p_bucket"] | cboBucketType.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-e97fd22e | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 6 | DMF0040_MktFcst_Comparison.cs:1541 |  | FLAG | dtTitle | client.ExecuteDataSet(request).DataSet.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-e0c0b9d4 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 6 | DMF0040_MktFcst_Comparison.cs:1541 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## DMF0040_MktFcst_Comparison.GetTeambyDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9f158990 | (진입점 미연결) | DMF0040_MktFcst_Comparison.cs:1592 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_TEAM_BY_DIVISION") ⇒ SCM.SCM0001_GET_TEAM_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-56da66de | (진입점 미연결) | DMF0040_MktFcst_Comparison.cs:1593 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-8b7c6db5 | (진입점 미연결) | DMF0040_MktFcst_Comparison.cs:1594 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-9513001c | (진입점 미연결) | DMF0040_MktFcst_Comparison.cs:1597 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0040_MktFcst_Comparison.GetThisWeekMonday

진입점: FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cf0550db | FindButton [try] | DMF0040_MktFcst_Comparison.cs:1673 | while (true) ▸ if (dtStart.DayOfWeek == DayOfWeek.Monday) | FLAG | thisWeekDate | dtStart | 화면 필드/플래그 변경 |  |  |  |
| AC-e5bde649 | FindButton [try] | DMF0040_MktFcst_Comparison.cs:1680 |  | RETURN | return sYYYYMMDD; |  | 처리 중단/반환 |  |  |  |

## DMF0040_MktFcst_Comparison.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4ea35814 | this.Load | DMF0040_MktFcst_Comparison.cs:273 |  | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtMain) | 데이터 객체 조작/조회 |  |  |  |
| AC-192a0022 | this.Load | DMF0040_MktFcst_Comparison.cs:279 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, cboDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-c3b89a43 | this.Load | DMF0040_MktFcst_Comparison.cs:288 |  | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-7eb74ae0 | this.Load | DMF0040_MktFcst_Comparison.cs:301 | if (sDivision != null && sDivision != "") ▸ if ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | LIST_REBIND | clsCtrl.setListBox | (dtCustomer, clbCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-895c97a9 | this.Load | DMF0040_MktFcst_Comparison.cs:313 | if (sDivision != null && sDivision != "") ▸ else of ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | LIST_REBIND | clsCtrl.setListBox | (dtCustomer, clbCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-56beb89d | this.Load | DMF0040_MktFcst_Comparison.cs:322 | if (sDivision != null && sDivision != "") | LIST_REBIND | clsCtrl.setListBox | (dtBizType, clbBizType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-6088896b | this.Load | DMF0040_MktFcst_Comparison.cs:327 |  | STATE | lblBizType.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-daf54d16 | this.Load | DMF0040_MktFcst_Comparison.cs:328 |  | VALUE_SET | chkSum.Checked | false | 컨트롤 값 설정 |  |  |  |
| AC-26547065 | this.Load | DMF0040_MktFcst_Comparison.cs:330 |  | UI_PROP | layoutControlItem10.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-cf29d1c5 | this.Load | DMF0040_MktFcst_Comparison.cs:341 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-0e89ac02 | this.Load | DMF0040_MktFcst_Comparison.cs:347 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantSite, clbPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-8ea43d40 | this.Load | DMF0040_MktFcst_Comparison.cs:349 |  | FLAG | dtBucketType | GetBucketType() | 화면 필드/플래그 변경 |  |  |  |
| AC-07fd9920 | this.Load | DMF0040_MktFcst_Comparison.cs:350 |  | LIST_REBIND | clsCtrl.setListBox | (dtBucketType, cboBucketType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-5b645fd6 | this.Load | DMF0040_MktFcst_Comparison.cs:360 |  | VALUE_SET | drpPeriod.InitValue | GetDayRange() | 컨트롤 값 설정 |  |  |  |
| AC-036572b0 | this.Load | DMF0040_MktFcst_Comparison.cs:362 |  | FLAG | dtItemType | GetItemType() | 화면 필드/플래그 변경 |  |  |  |
| AC-66d39a58 | this.Load | DMF0040_MktFcst_Comparison.cs:363 |  | LIST_REBIND | clsCtrl.setListBox | (dtItemType, clbItemType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-045981a1 | this.Load | DMF0040_MktFcst_Comparison.cs:366 |  | FLAG | dtQty | GetQtyData() | 화면 필드/플래그 변경 |  |  |  |
| AC-fbf0808a | this.Load | DMF0040_MktFcst_Comparison.cs:367 |  | LIST_REBIND | clsCtrl.setListBox | (dtQty, cboQTY, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-dde918a1 | this.Load | DMF0040_MktFcst_Comparison.cs:371 |  | CALL_EXT | toolTip1.SetToolTip | (btnColumn, "Column Show") | ⚠ 의미 확인 필요 |  |  |  |
| AC-ae3edf61 | this.Load | DMF0040_MktFcst_Comparison.cs:376 | if (dtDivision.Rows.Count > 1) | VALUE_SET | cboDivision.SelectedIndex | 1 | 컨트롤 값 설정 |  |  |  |

## DMF0040_MktFcst_Comparison.InitSpread

진입점: this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)] / this.cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if (cboBucketType.ControlValues == BucketType.Only_Weekly \|\| fBucket == BucketType.Only_Weekly)] / this.Load / cboDivision.SelectedIndexChanged [if (miFormLoad == 1)] / cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if (cboBucketType.ControlValues == BucketType.Only_Weekly \|\| fBucket == BucketType.Only_Weekly)] / FindButton [try] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2e10e92e | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 6 | DMF0040_MktFcst_Comparison.cs:398 |  | GRID_INIT | siMain.CreateSheetHeaderColumn | (siMain, 3, dtTitle) | 그리드 재구성/초기화 |  |  |  |
| AC-e00b4196 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 6 | DMF0040_MktFcst_Comparison.cs:404 | if (dtTitle != null && dtTitle.Rows.Count > 0) ▸ if (cboBucketType.ControlValues == BucketType.Only_Weekly) | STATE | chkSum.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-bc392419 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 6 | DMF0040_MktFcst_Comparison.cs:405 | if (dtTitle != null && dtTitle.Rows.Count > 0) ▸ if (cboBucketType.ControlValues == BucketType.Only_Weekly) | VALUE_SET | chkSum.Checked | false | 컨트롤 값 설정 |  |  |  |
| AC-77c291d3 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 6 | DMF0040_MktFcst_Comparison.cs:410 | if (dtTitle != null && dtTitle.Rows.Count > 0) ▸ else of (cboBucketType.ControlValues == BucketType.Only_Weekly) | STATE | chkSum.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## DMF0040_MktFcst_Comparison.InitSpreadFooterSum

진입점: this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / this.cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if (cboBucketType.ControlValues == BucketType.Only_Weekly \|\| fBucket == BucketType.Only_Weekly) ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / this.Load [if (dtTitle != null && dtTitle.Rows.Count > 0)] / cboDivision.SelectedIndexChanged [if (miFormLoad == 1) ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if (cboBucketType.ControlValues == BucketType.…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6ae69fcb | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 6 | DMF0040_MktFcst_Comparison.cs:423 |  | GRID_SET | siMain.ActiveSheet.ColumnFooter.Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-d836d893 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 6 | DMF0040_MktFcst_Comparison.cs:424 |  | GRID_SET | siMain.ActiveSheet.ColumnFooter.Cells[0, 1].Value | "Sum" | 그리드 속성/값 설정 |  |  |  |
| AC-c88fe59f | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 6 | DMF0040_MktFcst_Comparison.cs:431 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("M_") == … | CALL_EXT | siMain.ActiveSheet.ColumnFooter.SetAggregationFormat | (0, iCol, "{0:#,##0.###}") | ⚠ 의미 확인 필요 |  |  |  |
| AC-0caee328 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 6 | DMF0040_MktFcst_Comparison.cs:432 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("M_") == … | CALL_EXT | siMain.ActiveSheet.ColumnFooter.SetAggregationType | (0, iCol, FarPoint.Win.Spread.Model.AggregationType.SumIgnoreHidden) | ⚠ 의미 확인 필요 |  |  |  |
| AC-fca0024c | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 6 | DMF0040_MktFcst_Comparison.cs:433 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("M_") == … | GRID_SET | siMain.ActiveSheet.ColumnFooter.Cells[0, iCol].BackColor | Color.LightGray | 그리드 속성/값 설정 |  |  |  |
| AC-378f9092 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 6 | DMF0040_MktFcst_Comparison.cs:434 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("M_") == … | GRID_SET | siMain.ActiveSheet.ColumnFooter.Cells[0, iCol].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |

## DMF0040_MktFcst_Comparison.SetAmountCalculating

진입점: this.cboQTY.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ad53acca | this.cboQTY.SelectedIndexChanged | DMF0040_MktFcst_Comparison.cs:1740 | if (siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-def02d6b | this.cboQTY.SelectedIndexChanged | DMF0040_MktFcst_Comparison.cs:1744 | if (dsOrigianlCopy == null) | FLAG | dsOrigianlCopy | siMain.SpreadObject.DataSource as DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-98e3d77e | this.cboQTY.SelectedIndexChanged | DMF0040_MktFcst_Comparison.cs:1750 | if (cboQTY.SelectedIndex == 0) | LIST_BIND | siMain.SpreadObject.DataSource | dsOrigianlCopy | 목록/그리드 데이터 원천 연결 |  |  |  |
| AC-8ad2bc88 | this.cboQTY.SelectedIndexChanged | DMF0040_MktFcst_Comparison.cs:1751 | if (cboQTY.SelectedIndex == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9dee58f6 | this.cboQTY.SelectedIndexChanged | DMF0040_MktFcst_Comparison.cs:1754 |  | DATA_OP | dsOrigianlCopy.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-8e30d9e0 | this.cboQTY.SelectedIndexChanged | DMF0040_MktFcst_Comparison.cs:1756 |  | DATA_OP | dsKrw.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-ac6e9de5 | this.cboQTY.SelectedIndexChanged | DMF0040_MktFcst_Comparison.cs:1798 | for (i < dsOrigianlCopy.Tables[0].Rows.Count) ▸ for (j < dsKrw.Tables[0].Columns.Count) ▸ if (dsKrw.Tables[0].Columns[j].ColumnName.IndexOf(… | GRID_SET | dsKrw.Tables[0].Rows[i][j] | Math.Round(Convert.ToDouble(slValue) / dbQtyDivideAmount, 2) | 그리드 속성/값 설정 |  |  |  |
| AC-d7e44c7e | this.cboQTY.SelectedIndexChanged | DMF0040_MktFcst_Comparison.cs:1804 |  | DATA_OP | dsKrw.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-bbc9a79b | this.cboQTY.SelectedIndexChanged | DMF0040_MktFcst_Comparison.cs:1810 | if (ds != null) | UI_MISC | ds.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-41768deb | this.cboQTY.SelectedIndexChanged | DMF0040_MktFcst_Comparison.cs:1814 |  | LIST_BIND | siMain.SpreadObject.DataSource | dsKrw | 목록/그리드 데이터 원천 연결 |  |  |  |
| AC-dc8b74c8 | this.cboQTY.SelectedIndexChanged | DMF0040_MktFcst_Comparison.cs:1818 | if (dsKrw != null) | UI_MISC | dsKrw.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-72f78543 | this.cboQTY.SelectedIndexChanged | DMF0040_MktFcst_Comparison.cs:1821 |  | CALL_EXT | GC.Collect | () | ⚠ 의미 확인 필요 |  |  |  |

## DMF0040_MktFcst_Comparison.SetChangeControl

진입점: this.Load / cboDivision.SelectedIndexChanged / this.clbTeam.SelectedIndexChanged [if (sDivision.Substring(0, 2) != null && sDivision.Substring(0, 2) != "") ▸ if ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82"))] / this.clbCustomer.SelectedIndexChanged [if (sDivision != null && sDivision != "") ▸ if ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82"))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e51327c6 | this.Load 외 3 | DMF0040_MktFcst_Comparison.cs:216 |  | DATA_OP | Filter["GROUP_ID"] | UserInfoContext.Current["NowGroupID"] | 행/컬럼 값 대입 |  |  |  |
| AC-de289ee3 | this.Load 외 3 | DMF0040_MktFcst_Comparison.cs:217 |  | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-16c87be8 | this.Load 외 3 | DMF0040_MktFcst_Comparison.cs:223 | switch (triggerControl) case "MyDivision": | FLAG | dtDivision | DataService.GetDMInnerTable("MyDivision", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-d74908a1 | this.Load 외 3 | DMF0040_MktFcst_Comparison.cs:223 | switch (triggerControl) case "MyDivision": | COMBO_DATA | DataService.GetDMInnerTable | ("MyDivision", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-8ee8507a | this.Load 외 3 | DMF0040_MktFcst_Comparison.cs:228 | switch (triggerControl) case "UserTeamByDivision": | DATA_OP | Filter["DIVISION_ID"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-630f2629 | this.Load 외 3 | DMF0040_MktFcst_Comparison.cs:230 | switch (triggerControl) case "UserTeamByDivision": | FLAG | dtTeam | DataService.GetDMInnerTable("UserTeamByDivision", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-14343186 | this.Load 외 3 | DMF0040_MktFcst_Comparison.cs:230 | switch (triggerControl) case "UserTeamByDivision": | COMBO_DATA | DataService.GetDMInnerTable | ("UserTeamByDivision", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-b9756b15 | this.Load 외 3 | DMF0040_MktFcst_Comparison.cs:235 | switch (triggerControl) case "EndCustomerByDivision": | DATA_OP | Filter["DIVISION_ID"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-a98daa14 | this.Load 외 3 | DMF0040_MktFcst_Comparison.cs:236 | switch (triggerControl) case "EndCustomerByDivision": | DATA_OP | Filter["DEPT_ID"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-259959aa | this.Load 외 3 | DMF0040_MktFcst_Comparison.cs:238 | switch (triggerControl) case "EndCustomerByDivision": | FLAG | dtCustomer | DataService.GetDMInnerTable("EndCustomerByDivision", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-2a2fbbc2 | this.Load 외 3 | DMF0040_MktFcst_Comparison.cs:238 | switch (triggerControl) case "EndCustomerByDivision": | COMBO_DATA | DataService.GetDMInnerTable | ("EndCustomerByDivision", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-81391e43 | this.Load 외 3 | DMF0040_MktFcst_Comparison.cs:243 | switch (triggerControl) case "BizType": | DATA_OP | Filter["DIVISION_ID"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-f0910dec | this.Load 외 3 | DMF0040_MktFcst_Comparison.cs:245 | switch (triggerControl) case "BizType": | FLAG | dtBizType | DataService.GetDMInnerTable("BizType", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-75472d9c | this.Load 외 3 | DMF0040_MktFcst_Comparison.cs:245 | switch (triggerControl) case "BizType": | COMBO_DATA | DataService.GetDMInnerTable | ("BizType", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-b816639a | this.Load 외 3 | DMF0040_MktFcst_Comparison.cs:250 | switch (triggerControl) case "UserSiteByEndCustomer": | DATA_OP | Filter["DIVISION_ID"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-64bd1ce9 | this.Load 외 3 | DMF0040_MktFcst_Comparison.cs:251 | switch (triggerControl) case "UserSiteByEndCustomer": | DATA_OP | Filter["DEPT_ID"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-b69f97ba | this.Load 외 3 | DMF0040_MktFcst_Comparison.cs:252 | switch (triggerControl) case "UserSiteByEndCustomer": | DATA_OP | Filter["END_CUSTOMER"] | sEndCustomer | 행/컬럼 값 대입 |  |  |  |
| AC-0cb16f47 | this.Load 외 3 | DMF0040_MktFcst_Comparison.cs:254 | switch (triggerControl) case "UserSiteByEndCustomer": | FLAG | dtSalesSite | DataService.GetDMInnerTable("UserSiteByEndCustomer", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-fa7b20e7 | this.Load 외 3 | DMF0040_MktFcst_Comparison.cs:254 | switch (triggerControl) case "UserSiteByEndCustomer": | COMBO_DATA | DataService.GetDMInnerTable | ("UserSiteByEndCustomer", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-28d31ea7 | this.Load 외 3 | DMF0040_MktFcst_Comparison.cs:259 | switch (triggerControl) case "UserPlantSiteByDivision": | DATA_OP | Filter["DIVISION_ID"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-acd13ec8 | this.Load 외 3 | DMF0040_MktFcst_Comparison.cs:261 | switch (triggerControl) case "UserPlantSiteByDivision": | FLAG | dtPlantSite | DataService.GetDMInnerTable("UserPlantSiteByDivision", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-adffffed | this.Load 외 3 | DMF0040_MktFcst_Comparison.cs:261 | switch (triggerControl) case "UserPlantSiteByDivision": | COMBO_DATA | DataService.GetDMInnerTable | ("UserPlantSiteByDivision", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |

## DMF0040_MktFcst_Comparison.SetSpreadColumn

진입점: this.chkSum.CheckedChanged [if (siMain != null)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / this.cboBucketType.SelectedIndexChanged [if (siMain != null)] / this.Load [if (dtTitle != null && dtTitle.Rows.Count > 0)] / cboDivision.SelectedIndexChanged [if (miFormLoad == 1) ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / cboBucketType.SelectedIndexChanged [if (siMain != null)] / FindButton [try ▸ if (siMain.GetMaxRowIndex() > 0)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2114305b | this.chkSum.CheckedChanged [if (siMain != null)] 외 7 | DMF0040_MktFcst_Comparison.cs:1379 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siMain.GetColumnTag(iCol).IndexOf("D_"… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-abfaed6b | this.chkSum.CheckedChanged [if (siMain != null)] 외 7 | DMF0040_MktFcst_Comparison.cs:1384 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siMain.GetColumnTag(iCol).IndexOf("M_"… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-237388a7 | this.chkSum.CheckedChanged [if (siMain != null)] 외 7 | DMF0040_MktFcst_Comparison.cs:1391 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Bu… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-6226d129 | this.chkSum.CheckedChanged [if (siMain != null)] 외 7 | DMF0040_MktFcst_Comparison.cs:1395 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Bu… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-52b150db | this.chkSum.CheckedChanged [if (siMain != null)] 외 7 | DMF0040_MktFcst_Comparison.cs:1400 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Bu… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-fc27f14a | this.chkSum.CheckedChanged [if (siMain != null)] 외 7 | DMF0040_MktFcst_Comparison.cs:1407 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboBucketType.ControlValues … | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-08d4179e | this.chkSum.CheckedChanged [if (siMain != null)] 외 7 | DMF0040_MktFcst_Comparison.cs:1411 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboBucketType.ControlValues … | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |

## DMF0040_MktFcst_Comparison.SetSpreadHeader

진입점: this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dtTitle != null && dtTitle.Rows.Count > 0) ▸ if (cboBucketType.ControlValues == BucketType.Only_Weekly)] / this.cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if (cboBucketType.ControlValues == BucketType.Only_Weekly \|\| fBucket == BucketType.Only_Weekly) ▸ if (dtTitle != null && dtTitle.Rows.Count > 0) ▸ if (cboBucketType.ControlValues == BucketType.Only_Weekly)] / this.Load [if (dtTitle != null && dtTitle.Rows.Count > 0) ▸ if (cboBucketType.ControlValues == BucketType.Only_Weekly)] / cboDivision.SelectedIndexCha…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-86c631ff | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 6 | DMF0040_MktFcst_Comparison.cs:455 | foreach (DataRow dr in dt.Rows) ▸ if (iCellCnt < iStartCol) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iCellCnt, 3, 1, 20, sColumnLabel, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5abc8b60 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 6 | DMF0040_MktFcst_Comparison.cs:463 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt < iStartCol) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, iStartCol, 0, iStartCol].Text | sLargeLabelName | 그리드 속성/값 설정 |  |  |  |
| AC-ada84335 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 6 | DMF0040_MktFcst_Comparison.cs:464 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt < iStartCol) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[1, iStartCol, 1, iStartCol].Text | sSmallLabelName | 그리드 속성/값 설정 |  |  |  |
| AC-b143b960 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 6 | DMF0040_MktFcst_Comparison.cs:465 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt < iStartCol) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[2, iStartCol, 2, iStartCol].Text | "SUM" | 그리드 속성/값 설정 |  |  |  |
| AC-f644679c | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 6 | DMF0040_MktFcst_Comparison.cs:469 |  | GRID_INIT | siMain.Freeze | (0, siMain.GetColumnIndex(DefColumns.Measure) + 1) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-78ad99c7 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 6 | DMF0040_MktFcst_Comparison.cs:470 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0040_MktFcst_Comparison.SetSpreadHeaderSpan

진입점: this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dtTitle != null && dtTitle.Rows.Count > 0) ▸ else of (cboBucketType.ControlValues == BucketType.Only_Weekly)] / this.cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if (cboBucketType.ControlValues == BucketType.Only_Weekly \|\| fBucket == BucketType.Only_Weekly) ▸ if (dtTitle != null && dtTitle.Rows.Count > 0) ▸ else of (cboBucketType.ControlValues == BucketType.Only_Weekly)] / this.Load [if (dtTitle != null && dtTitle.Rows.Count > 0) ▸ else of (cboBucketType.ControlValues == BucketType.Only_Weekly)] / cboDivision.S…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cd95deec | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 6 | DMF0040_MktFcst_Comparison.cs:500 | foreach (DataRow dr in dt.Rows) ▸ if (iCellCnt <= iSmallStartCol) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iCellCnt, 3, 1, 20, sColumnLabel, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4a9e6a7d | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 6 | DMF0040_MktFcst_Comparison.cs:508 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (dr[DefColumns.ColumnName].ToString().IndexOf("B_") > 0) | GRID_INIT | siMain.VisibleColumns | (iCellCnt, false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-eef6b188 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 6 | DMF0040_MktFcst_Comparison.cs:519 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ else of (dr[DefColumns.ColumnName].ToString().IndexOf("B_") > 0) ▸ … | GRID_SET | siMain.Sheet().ColumnHeader.Cells[2, iCellCnt].ForeColor | dr[DefColumns.DayCode].ToString() == DefColumnsLabel.Saturday ? Color.Blue : Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-09ff249f | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 6 | DMF0040_MktFcst_Comparison.cs:526 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-542d4f51 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 6 | DMF0040_MktFcst_Comparison.cs:527 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-20056474 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 6 | DMF0040_MktFcst_Comparison.cs:532 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-fa65438f | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 6 | DMF0040_MktFcst_Comparison.cs:533 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 30, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9d5a83b8 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 6 | DMF0040_MktFcst_Comparison.cs:540 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName !=… | GRID_INIT | siMain.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-50e96820 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 6 | DMF0040_MktFcst_Comparison.cs:541 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName !=… | GRID_INIT | siMain.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0ccdf4e4 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 6 | DMF0040_MktFcst_Comparison.cs:552 |  | GRID_INIT | siMain.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c1d6d224 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 6 | DMF0040_MktFcst_Comparison.cs:553 |  | GRID_INIT | siMain.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e62fb6b7 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 6 | DMF0040_MktFcst_Comparison.cs:554 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b85e85b9 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 6 | DMF0040_MktFcst_Comparison.cs:555 |  | GRID_INIT | siMain.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4e4fa243 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 6 | DMF0040_MktFcst_Comparison.cs:557 |  | GRID_INIT | siMain.Freeze | (0, siMain.GetColumnIndex(DefColumns.Measure) + 1) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-a9a28709 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 6 | DMF0040_MktFcst_Comparison.cs:558 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0040_MktFcst_Comparison.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9bf959fd | this.spdMain.CellDoubleClick | DMF0040_MktFcst_Comparison.cs:1184 | if (e.ColumnHeader) ▸ if (siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ▸ for (iCol < siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumn… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | !siMain.ActiveSheet.Columns[iCol].Visible | 그리드 속성/값 설정 |  |  |  |
| AC-81a3a803 | this.spdMain.CellDoubleClick | DMF0040_MktFcst_Comparison.cs:1190 | if (e.ColumnHeader) ▸ if (siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ▸ for (iCol < siMain.GetMaxColumnIndex()) ▸ else of (siMain.GetC… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | !siMain.ActiveSheet.Columns[iCol].Visible | 그리드 속성/값 설정 |  |  |  |
| AC-f30f844f | this.spdMain.CellDoubleClick | DMF0040_MktFcst_Comparison.cs:1206 | if (e.ColumnHeader) ▸ else of (siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ▸ if (siMain.GetColumnTag(e.Column).IndexOf("W_") == 0) ▸ f… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | !siMain.ActiveSheet.Columns[iCol].Visible | 그리드 속성/값 설정 |  |  |  |
| AC-64be0669 | this.spdMain.CellDoubleClick | DMF0040_MktFcst_Comparison.cs:1220 | else of (e.ColumnHeader) ▸ if (siMain.IsLock(siMain.SheetName) \|\| siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) !… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-459cd7b2 | this.spdMain.CellDoubleClick | DMF0040_MktFcst_Comparison.cs:1228 | else of (e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.Project)) | POPUP | new SCM0002_ProjectbyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-a2036c82 | this.spdMain.CellDoubleClick | DMF0040_MktFcst_Comparison.cs:1230 | else of (e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.Project)) | POPUP | popProject.Form_Load | (false, sDivision, sProject) | 팝업 초기화(인자 전달) |  |  |  |
| AC-79251611 | this.spdMain.CellDoubleClick | DMF0040_MktFcst_Comparison.cs:1231 | else of (e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.Project)) | UI_PROP | popProject.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-5c8ae241 | this.spdMain.CellDoubleClick | DMF0040_MktFcst_Comparison.cs:1232 | else of (e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.Project)) | POPUP | popProject.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-51c65d93 | this.spdMain.CellDoubleClick | DMF0040_MktFcst_Comparison.cs:1236 | else of (e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.Project)) | GRID_SET | siMain.SetText | (e.Row, e.Column, sProject) | 그리드 값 설정 |  |  |  |
| AC-5800c01d | this.spdMain.CellDoubleClick | DMF0040_MktFcst_Comparison.cs:1245 | else of (e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumn… | POPUP | new SCM0002_ItembyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-f2b6acd1 | this.spdMain.CellDoubleClick | DMF0040_MktFcst_Comparison.cs:1247 | else of (e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumn… | POPUP | popItem.Form_Load | (false, sDivision, sScmSiteId, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-9280e789 | this.spdMain.CellDoubleClick | DMF0040_MktFcst_Comparison.cs:1248 | else of (e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumn… | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-83df7b5e | this.spdMain.CellDoubleClick | DMF0040_MktFcst_Comparison.cs:1249 | else of (e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumn… | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-7777f139 | this.spdMain.CellDoubleClick | DMF0040_MktFcst_Comparison.cs:1253 | else of (e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumn… | GRID_SET | siMain.SetText | (e.Row, e.Column, sItemId) | 그리드 값 설정 |  |  |  |

## DMF0040_MktFcst_Comparison.spdMain_ComboSelChange

진입점: this.spdMain.ComboSelChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5d7a8afb | this.spdMain.ComboSelChange | DMF0040_MktFcst_Comparison.cs:1166 | if (e.Column == siMain.GetColumnIndex(DefColumns.Division)) | FLAG | dtSalesSite | GetScmSitebyDivision(siMain.GetValue(e.Row, e.Column).ToString(), CAppSetting.StringALL, C… | 화면 필드/플래그 변경 |  |  |  |
| AC-dec023a6 | this.spdMain.ComboSelChange | DMF0040_MktFcst_Comparison.cs:1167 | if (e.Column == siMain.GetColumnIndex(DefColumns.Division)) | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.ScmSiteId), dtSalesSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-0fd60f63 | this.spdMain.ComboSelChange | DMF0040_MktFcst_Comparison.cs:1169 | if (e.Column == siMain.GetColumnIndex(DefColumns.Division)) | FLAG | dtPlantSite | GetPlantSitebyEndCustomer(siMain.GetValue(e.Row, e.Column).ToString(), CAppSetting.StringA… | 화면 필드/플래그 변경 |  |  |  |
| AC-7245d55d | this.spdMain.ComboSelChange | DMF0040_MktFcst_Comparison.cs:1170 | if (e.Column == siMain.GetColumnIndex(DefColumns.Division)) | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.PlantSiteId), dtPlantSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |

## DMF0040_MktFcst_Comparison.spdMain_KeyUp

진입점: this.spdMain.KeyUp

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-37bf13c1 | this.spdMain.KeyUp | DMF0040_MktFcst_Comparison.cs:1267 | if (siMain.GetColumnIndex(DefColumns.Measure) >= siMain.ActiveColumnIndex) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9ebd4859 | this.spdMain.KeyUp | DMF0040_MktFcst_Comparison.cs:1271 | if (e.Control == true && e.KeyCode == Keys.V \|\| e.Control == false && e.KeyCode == Keys.V) | CALL_EXT | spdMain.ActiveSheet.ClipboardPaste | (ClipboardPasteOptions.AsStringSkipHidden) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d000e7e7 | this.spdMain.KeyUp | DMF0040_MktFcst_Comparison.cs:1277 | if (e.Control == true && e.KeyCode == Keys.C \|\| e.Control == false && e.KeyCode == Keys.C) | CALL_EXT | Clipboard.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-dfffdbdb | this.spdMain.KeyUp | DMF0040_MktFcst_Comparison.cs:1278 | if (e.Control == true && e.KeyCode == Keys.C \|\| e.Control == false && e.KeyCode == Keys.C) | CALL_EXT | spdMain.Sheets[0].ClipboardCopy | (ClipboardCopyOptions.AsStringSkipHidden) | ⚠ 의미 확인 필요 |  |  |  |

## DMF0040_MktFcst_Comparison.spdMain_TopChange

진입점: this.spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c72f968e | this.spdMain.TopChange | DMF0040_MktFcst_Comparison.cs:1261 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

