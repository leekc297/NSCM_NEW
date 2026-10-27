# AS-IS 액션 대조표 — DMF0053

> 원천: `Doc/asisfacts/screens/DMF0053/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 301행 · 메서드 43 · 종류 DATA_OP 54 · RETURN 25 · ENDPOINT 25 · POPUP 24 · UI_PROP 23 · GRID_INIT 23 · FLAG 22 · LIST_REBIND 22 · GRID_SET 22 · VALUE_SET 10 · STATE 10 · UI_MISC 10 · MESSAGE 7 · CALL_EXT 7 · COMBO_DATA 6 · VALUE_CLEAR 4 · LIST_BIND 2 · GRID_COMBO 2 · THROW 1 · GRID_BIND 1 · GRID_LOCK 1 · ⚠ 의미 확인 필요 7


## DMF0053_CustFcstWaterfall.btnColumn_Click

진입점: this.btnColumn.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b8a1f43b | this.btnColumn.Click | DMF0053_CustFcstWaterfall.cs:1328 |  | POPUP | new DM0002_TitleSetForm_Popup | ("DMF0053", SpdSheet.shtMain, true, cboDivision.ControlValues) | 팝업/폼 생성 |  |  |  |
| AC-a1fecfc0 | this.btnColumn.Click | DMF0053_CustFcstWaterfall.cs:1329 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-e1cc05f1 | this.btnColumn.Click | DMF0053_CustFcstWaterfall.cs:1330 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## DMF0053_CustFcstWaterfall.btnItemId_Click

진입점: this.btnItemId.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fef0cfd2 | this.btnItemId.Click | DMF0053_CustFcstWaterfall.cs:1311 |  | POPUP | new DM0002_ItembyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-39ea0a0a | this.btnItemId.Click | DMF0053_CustFcstWaterfall.cs:1314 |  | POPUP | popItem.Form_Load | (false, sDivision, sTeam, sEndCustomer, sScmSite, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-e91014f9 | this.btnItemId.Click | DMF0053_CustFcstWaterfall.cs:1315 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-1bd1a665 | this.btnItemId.Click | DMF0053_CustFcstWaterfall.cs:1316 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-39eea231 | this.btnItemId.Click | DMF0053_CustFcstWaterfall.cs:1322 | if (popItem.ItemID != "") | VALUE_SET | txtItemId.Text | sItemId | 컨트롤 값 설정 |  |  |  |

## DMF0053_CustFcstWaterfall.btnMeasure_Click

진입점: this.btnMeasure.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a8566b91 | this.btnMeasure.Click | DMF0053_CustFcstWaterfall.cs:1340 |  | POPUP | new DM0002_TitleSetForm_Popup | ("DMF0053", SpdSheet.shtMain, false, cboDivision.ControlValues) | 팝업/폼 생성 |  |  |  |
| AC-a334c364 | this.btnMeasure.Click | DMF0053_CustFcstWaterfall.cs:1342 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-4b26edb0 | this.btnMeasure.Click | DMF0053_CustFcstWaterfall.cs:1343 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## DMF0053_CustFcstWaterfall.btnOwner_Click

진입점: this.btnOwner.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-246c5414 | this.btnOwner.Click | DMF0053_CustFcstWaterfall.cs:1713 |  | POPUP | new DM0020_OwnerbyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-7c6b67b9 | this.btnOwner.Click | DMF0053_CustFcstWaterfall.cs:1716 |  | POPUP | popItem.Form_Load | (true, sDivision, sTeam, sEndCustomer, sScmSiteId, sProject, sItemId, sOwner) | 팝업 초기화(인자 전달) |  |  |  |
| AC-17db374b | this.btnOwner.Click | DMF0053_CustFcstWaterfall.cs:1717 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-a05b94bd | this.btnOwner.Click | DMF0053_CustFcstWaterfall.cs:1718 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-34009bca | this.btnOwner.Click | DMF0053_CustFcstWaterfall.cs:1720 |  | VALUE_SET | txtOwner.Text | popItem.OwnerID | 컨트롤 값 설정 |  |  |  |

## DMF0053_CustFcstWaterfall.btnProject_Click

진입점: this.btnProject.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8c858468 | this.btnProject.Click | DMF0053_CustFcstWaterfall.cs:1286 |  | POPUP | new SCM0002_ProjectbyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-d356d91a | this.btnProject.Click | DMF0053_CustFcstWaterfall.cs:1288 |  | POPUP | popProject.Form_Load | (true, sDivision, sTeam, sEndCustomer, sScmSiteID, sProject) | 팝업 초기화(인자 전달) |  |  |  |
| AC-08c1e1f0 | this.btnProject.Click | DMF0053_CustFcstWaterfall.cs:1289 |  | UI_PROP | popProject.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-2e2c4b85 | this.btnProject.Click | DMF0053_CustFcstWaterfall.cs:1290 |  | POPUP | popProject.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-93647de2 | this.btnProject.Click | DMF0053_CustFcstWaterfall.cs:1296 | if (popProject.ProjectCode != "") | VALUE_SET | txtProject.Text | sProjectCode | 컨트롤 값 설정 |  |  |  |

## DMF0053_CustFcstWaterfall.btnVersion_Click

진입점: this.btnVersion.Click / this.txtVersion.KeyDown

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0e869bcd | this.btnVersion.Click 외 1 | DMF0053_CustFcstWaterfall.cs:1664 |  | POPUP | new SCM0002_VersionByWaterfallPopup | () | 팝업/폼 생성 |  |  |  |
| AC-02015930 | this.btnVersion.Click 외 1 | DMF0053_CustFcstWaterfall.cs:1665 |  | POPUP | popVersion.Form_Load | (true, "CF", sDivision, sStartTime, sEndTinme) | 팝업 초기화(인자 전달) |  |  |  |
| AC-6ee08805 | this.btnVersion.Click 외 1 | DMF0053_CustFcstWaterfall.cs:1666 |  | UI_PROP | popVersion.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-17695231 | this.btnVersion.Click 외 1 | DMF0053_CustFcstWaterfall.cs:1667 |  | POPUP | popVersion.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-ea4ec8e8 | this.btnVersion.Click 외 1 | DMF0053_CustFcstWaterfall.cs:1671 | if (popVersion.sVersions != "") | VALUE_SET | txtVersion.Text | popVersion.sVersions | 컨트롤 값 설정 |  |  |  |
| AC-373dbb01 | this.btnVersion.Click 외 1 | DMF0053_CustFcstWaterfall.cs:1672 | if (popVersion.sVersions != "") | VALUE_SET | drpPeriod.InitValue | popVersion.sPeriod | 컨트롤 값 설정 |  |  |  |

## DMF0053_CustFcstWaterfall.cboBucketType_SelectedIndexChanged

진입점: this.cboBucketType.SelectedIndexChanged / cboBucketType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-49a8bc1c | this.cboBucketType.SelectedIndexChanged 외 1 | DMF0053_CustFcstWaterfall.cs:1127 | if (siMain != null) | FLAG | sBucket | cboBucketType.ControlValues | 화면 필드/플래그 변경 |  |  |  |

## DMF0053_CustFcstWaterfall.cboDivision_SelectedIndexChanged

진입점: this.Load / cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c14d4c2a | this.Load 외 1 | DMF0053_CustFcstWaterfall.cs:945 |  | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-3a00cc28 | this.Load 외 1 | DMF0053_CustFcstWaterfall.cs:953 | if (sDivision != null && sDivision != "") ▸ if ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | STATE | lblProject.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-d3b7cf87 | this.Load 외 1 | DMF0053_CustFcstWaterfall.cs:954 | if (sDivision != null && sDivision != "") ▸ if ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | STATE | lblPlantSite.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-83f23d25 | this.Load 외 1 | DMF0053_CustFcstWaterfall.cs:955 | if (sDivision != null && sDivision != "") ▸ if ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | STATE | btnProject.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-4d73262b | this.Load 외 1 | DMF0053_CustFcstWaterfall.cs:963 | if (sDivision != null && sDivision != "") ▸ if ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | LIST_REBIND | clsCtrl.setListBox | (dtCustomer, clbCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-6f077311 | this.Load 외 1 | DMF0053_CustFcstWaterfall.cs:971 | if (sDivision != null && sDivision != "") ▸ if ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-89a7065d | this.Load 외 1 | DMF0053_CustFcstWaterfall.cs:977 | if (sDivision != null && sDivision != "") ▸ if ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | LIST_REBIND | clsCtrl.setListBox | (dtBizType, clbBizType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-07150b3d | this.Load 외 1 | DMF0053_CustFcstWaterfall.cs:981 | if (sDivision != null && sDivision != "") ▸ else of ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | STATE | lblProject.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-504d95a5 | this.Load 외 1 | DMF0053_CustFcstWaterfall.cs:982 | if (sDivision != null && sDivision != "") ▸ else of ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | STATE | lblPlantSite.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-6a48641b | this.Load 외 1 | DMF0053_CustFcstWaterfall.cs:983 | if (sDivision != null && sDivision != "") ▸ else of ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | STATE | btnProject.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-ac7659b8 | this.Load 외 1 | DMF0053_CustFcstWaterfall.cs:990 | if (sDivision != null && sDivision != "") ▸ else of ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | LIST_REBIND | clsCtrl.setListBox | (dtCustomer, clbCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-55a64a8f | this.Load 외 1 | DMF0053_CustFcstWaterfall.cs:999 | if (sDivision != null && sDivision != "") ▸ else of ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-eb2092b8 | this.Load 외 1 | DMF0053_CustFcstWaterfall.cs:1005 | if (sDivision != null && sDivision != "") ▸ else of ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | LIST_REBIND | clsCtrl.setListBox | (dtBizType, clbBizType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-b6ed488e | this.Load 외 1 | DMF0053_CustFcstWaterfall.cs:1011 |  | STATE | lblBizType.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-1f1e50d0 | this.Load 외 1 | DMF0053_CustFcstWaterfall.cs:1018 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantSite, clbPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-35f187cb | this.Load 외 1 | DMF0053_CustFcstWaterfall.cs:1020 |  | VALUE_CLEAR | this.txtProject.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-b64574d4 | this.Load 외 1 | DMF0053_CustFcstWaterfall.cs:1021 |  | VALUE_CLEAR | this.txtItemId.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-223cf410 | this.Load 외 1 | DMF0053_CustFcstWaterfall.cs:1022 |  | VALUE_CLEAR | this.txtVersion.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-2475559d | this.Load 외 1 | DMF0053_CustFcstWaterfall.cs:1023 |  | VALUE_CLEAR | this.txtOwner.Text | "" | 컨트롤 값 비움 |  |  |  |

## DMF0053_CustFcstWaterfall.cboQTY_SelectedIndexChanged

진입점: this.cboQTY.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-843e83b3 | this.cboQTY.SelectedIndexChanged | DMF0053_CustFcstWaterfall.cs:1726 | if (siMain == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DMF0053_CustFcstWaterfall.clbCustomer_SelectedIndexChanged

진입점: this.clbCustomer.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-50b061a3 | this.clbCustomer.SelectedIndexChanged | DMF0053_CustFcstWaterfall.cs:1089 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |

## DMF0053_CustFcstWaterfall.clbTeam_SelectedIndexChanged

진입점: this.clbTeam.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-22bfd6ee | this.clbTeam.SelectedIndexChanged | DMF0053_CustFcstWaterfall.cs:1043 | if (sDivision != null && sDivision != "") ▸ if ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | LIST_REBIND | clsCtrl.setListBox | (dtCustomer, clbCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-b21c283c | this.clbTeam.SelectedIndexChanged | DMF0053_CustFcstWaterfall.cs:1055 | if (sDivision != null && sDivision != "") ▸ else of ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | LIST_REBIND | clsCtrl.setListBox | (dtCustomer, clbCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-3be6e6f7 | this.clbTeam.SelectedIndexChanged | DMF0053_CustFcstWaterfall.cs:1062 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |

## DMF0053_CustFcstWaterfall.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d12d6f7a | this.Load | DMF0053_CustFcstWaterfall.cs:379 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 3, 1, 20) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-ead328fe | this.Load | DMF0053_CustFcstWaterfall.cs:380 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-a65888ce | this.Load | DMF0053_CustFcstWaterfall.cs:381 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0053_CustFcstWaterfall.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6444695d | this.Load | DMF0053_CustFcstWaterfall.cs:373 |  | UI_PROP | usrConditionPanel1.Height | 105 | 속성 Height 설정 |  |  |  |
| AC-2f54bb74 | this.Load | DMF0053_CustFcstWaterfall.cs:374 |  | VALUE_SET | cboBucketType.ControlValues | BucketType.Monthly | 컨트롤 값 설정 |  |  |  |

## DMF0053_CustFcstWaterfall.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3ce80b7a | Dispose | DMF0053_CustFcstWaterfall.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## DMF0053_CustFcstWaterfall.EditButton

진입점: this.cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if (!siMain.IsLock(siMain.SheetName))] / cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if (!siMain.IsLock(siMain.SheetName))] / EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-56d54ec9 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0053_CustFcstWaterfall.cs:591 | if (this.fps != null) | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-54ebebf1 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0053_CustFcstWaterfall.cs:592 | if (this.fps != null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DMF0053_CustFcstWaterfall.ExcelButton

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-342c6c5b | ExcelButton | DMF0053_CustFcstWaterfall.cs:607 |  | UI_PROP | exportOption.Merge | ExcelMergeOption.None | 속성 Merge 설정 |  |  |  |
| AC-74b27f4b | ExcelButton | DMF0053_CustFcstWaterfall.cs:608 |  | UI_PROP | exportOption.Border | ExcelBorderOption.All | 속성 Border 설정 |  |  |  |
| AC-843b7c71 | ExcelButton | DMF0053_CustFcstWaterfall.cs:609 |  | UI_PROP | exportOption.AheadZeroOption | ZeroOption.HideZero | 속성 AheadZeroOption 설정 |  |  |  |
| AC-1ddb8d9e | ExcelButton | DMF0053_CustFcstWaterfall.cs:610 |  | UI_PROP | exportOption.AmendZeroOption | ZeroOption.ShowZero | 속성 AmendZeroOption 설정 |  |  |  |
| AC-eb6d27a1 | ExcelButton | DMF0053_CustFcstWaterfall.cs:611 |  | UI_PROP | exportOption.AmendNullToZero | false | 속성 AmendNullToZero 설정 |  |  |  |
| AC-56ba5668 | ExcelButton | DMF0053_CustFcstWaterfall.cs:612 |  | UI_PROP | exportOption.AheadNullToZero | false | 속성 AheadNullToZero 설정 |  |  |  |
| AC-2fff59c4 | ExcelButton | DMF0053_CustFcstWaterfall.cs:614 |  | UI_PROP | exportOption.UserName | UserInfo.UserId | 속성 UserName 설정 |  |  |  |
| AC-6fd904a2 | ExcelButton | DMF0053_CustFcstWaterfall.cs:615 |  | UI_PROP | exportOption.FileName | sFileName | 속성 FileName 설정 |  |  |  |
| AC-4c88c2f7 | ExcelButton | DMF0053_CustFcstWaterfall.cs:617 |  | UI_PROP | exportOption.AmendDecimalFormat | "#,##0;[Red]-#,##0" | 속성 AmendDecimalFormat 설정 |  |  |  |
| AC-96d071c8 | ExcelButton | DMF0053_CustFcstWaterfall.cs:622 | try | CALL_EXT | SimplexelService.ExportFpSpread | (fps, exportOption) | ⚠ 의미 확인 필요 |  |  |  |
| AC-302fa143 | ExcelButton | DMF0053_CustFcstWaterfall.cs:627 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-71d4a463 | ExcelButton | DMF0053_CustFcstWaterfall.cs:631 | finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## DMF0053_CustFcstWaterfall.FindData

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a44745ff | FindButton | DMF0053_CustFcstWaterfall.cs:664 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-a34f6d07 | FindButton | DMF0053_CustFcstWaterfall.cs:672 | try | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-78e3cd55 | FindButton | DMF0053_CustFcstWaterfall.cs:679 | try ▸ if (sDivision == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00097") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3e519573 | FindButton | DMF0053_CustFcstWaterfall.cs:681 | try ▸ if (sDivision == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a1e0488d | FindButton | DMF0053_CustFcstWaterfall.cs:688 | try ▸ if (int.Parse(sPeriod[0]) > int.Parse(sPeriod[1])) | MESSAGE | MessageHelper.GMessageBox | ("MSG00108") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-428e512e | FindButton | DMF0053_CustFcstWaterfall.cs:689 | try ▸ if (int.Parse(sPeriod[0]) > int.Parse(sPeriod[1])) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a89922c4 | FindButton | DMF0053_CustFcstWaterfall.cs:694 | try ▸ if (drpPeriod.Value1.AddYears(3) < drpPeriod.Value2) | MESSAGE | MessageHelper.GMessageBox | ("MSG00164") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c9755e08 | FindButton | DMF0053_CustFcstWaterfall.cs:696 | try ▸ if (drpPeriod.Value1.AddYears(3) < drpPeriod.Value2) | UI_PROP | drpPeriod.Value2 | drpPeriod.Value1.AddYears(3) | 속성 Value2 설정 |  |  |  |
| AC-c4a17ced | FindButton | DMF0053_CustFcstWaterfall.cs:698 | try ▸ if (drpPeriod.Value1.AddYears(3) < drpPeriod.Value2) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bb34778e | FindButton | DMF0053_CustFcstWaterfall.cs:705 | try ▸ if (int.Parse(sCreateDate[0]) > int.Parse(sCreateDate[1])) | MESSAGE | MessageHelper.GMessageBox | ("MSG00108") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e0d0d591 | FindButton | DMF0053_CustFcstWaterfall.cs:706 | try ▸ if (int.Parse(sCreateDate[0]) > int.Parse(sCreateDate[1])) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bce73834 | FindButton | DMF0053_CustFcstWaterfall.cs:711 | try ▸ if (drpCreateDate.Value1.AddYears(3) < drpCreateDate.Value2) | MESSAGE | MessageHelper.GMessageBox | ("MSG00164") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ccd5a451 | FindButton | DMF0053_CustFcstWaterfall.cs:713 | try ▸ if (drpCreateDate.Value1.AddYears(3) < drpCreateDate.Value2) | UI_PROP | drpCreateDate.Value2 | drpCreateDate.Value1.AddYears(3) | 속성 Value2 설정 |  |  |  |
| AC-77912467 | FindButton | DMF0053_CustFcstWaterfall.cs:715 | try ▸ if (drpCreateDate.Value1.AddYears(3) < drpCreateDate.Value2) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b1580e94 | FindButton | DMF0053_CustFcstWaterfall.cs:719 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-dd1a79e7 | FindButton | DMF0053_CustFcstWaterfall.cs:727 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-a10238d9 | FindButton | DMF0053_CustFcstWaterfall.cs:730 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { va… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a358b4d1 | FindButton | DMF0053_CustFcstWaterfall.cs:734 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("DM.DMF0053_GET_CUST_FCST_WATERFALL") ⇒ DM.DMF0053_GET_CUST_FCST_WATERFALL | 엔드포인트 요청 생성 |  |  |  |
| AC-6bffec5d | FindButton | DMF0053_CustFcstWaterfall.cs:735 | try ▸ lambda | UI_PROP | request.CommandTimeout | 10 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-c72e10c4 | FindButton | DMF0053_CustFcstWaterfall.cs:736 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-47212913 | FindButton | DMF0053_CustFcstWaterfall.cs:737 | try ▸ lambda | DATA_OP | request.Parameters["p_dept_id"] | clbTeam.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-e2874b3b | FindButton | DMF0053_CustFcstWaterfall.cs:738 | try ▸ lambda | DATA_OP | request.Parameters["p_end_customer"] | clbCustomer.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-75dea391 | FindButton | DMF0053_CustFcstWaterfall.cs:739 | try ▸ lambda | DATA_OP | request.Parameters["p_scm_site_id"] | clbSalesSite.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-d77e643a | FindButton | DMF0053_CustFcstWaterfall.cs:740 | try ▸ lambda | DATA_OP | request.Parameters["p_project_code"] | txtProject.Text | 행/컬럼 값 대입 |  |  |  |
| AC-6ac3cee0 | FindButton | DMF0053_CustFcstWaterfall.cs:741 | try ▸ lambda | DATA_OP | request.Parameters["p_item_id"] | txtItemId.Text | 행/컬럼 값 대입 |  |  |  |
| AC-621239e4 | FindButton | DMF0053_CustFcstWaterfall.cs:742 | try ▸ lambda | DATA_OP | request.Parameters["p_item_type"] | clbItemType.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-c37555ff | FindButton | DMF0053_CustFcstWaterfall.cs:743 | try ▸ lambda | DATA_OP | request.Parameters["p_from_yyyymmdd"] | sPeriod[0] | 행/컬럼 값 대입 |  |  |  |
| AC-f3ccb304 | FindButton | DMF0053_CustFcstWaterfall.cs:744 | try ▸ lambda | DATA_OP | request.Parameters["p_to_yyyymmdd"] | sPeriod[1] | 행/컬럼 값 대입 |  |  |  |
| AC-44d1fd38 | FindButton | DMF0053_CustFcstWaterfall.cs:745 | try ▸ lambda | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-4c7e2e00 | FindButton | DMF0053_CustFcstWaterfall.cs:746 | try ▸ lambda | DATA_OP | request.Parameters["p_plant_site_id"] | clbPlantSite.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-8fe2cb4f | FindButton | DMF0053_CustFcstWaterfall.cs:747 | try ▸ lambda | DATA_OP | request.Parameters["p_biz_type"] | clbBizType.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-8b981fb3 | FindButton | DMF0053_CustFcstWaterfall.cs:748 | try ▸ lambda | DATA_OP | request.Parameters["p_owner"] | txtOwner.Text.Trim() | 행/컬럼 값 대입 |  |  |  |
| AC-a061b4a7 | FindButton | DMF0053_CustFcstWaterfall.cs:749 | try ▸ lambda | DATA_OP | request.Parameters["p_version_no"] | txtVersion.Text | 행/컬럼 값 대입 |  |  |  |
| AC-646abd4d | FindButton | DMF0053_CustFcstWaterfall.cs:750 | try ▸ lambda | DATA_OP | request.Parameters["p_bucket"] | p_bucket | 행/컬럼 값 대입 |  |  |  |
| AC-7d61bc29 | FindButton | DMF0053_CustFcstWaterfall.cs:752 | try ▸ lambda | DATA_OP | request.Parameters["p_user_dept_id"] | UserInfoContext.Current["Dept_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-9d1e984f | FindButton | DMF0053_CustFcstWaterfall.cs:753 | try ▸ lambda | DATA_OP | request.Parameters["p_group_id"] | UserInfoContext.Current["NowGroupID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-38a82fc0 | FindButton | DMF0053_CustFcstWaterfall.cs:756 | try ▸ lambda | DATA_OP | request.Parameters["p_from_createdate"] | sCreateDate[0] | 행/컬럼 값 대입 |  |  |  |
| AC-a07953e8 | FindButton | DMF0053_CustFcstWaterfall.cs:757 | try ▸ lambda | DATA_OP | request.Parameters["p_to_createdate"] | sCreateDate[1] | 행/컬럼 값 대입 |  |  |  |
| AC-7be8cd49 | FindButton | DMF0053_CustFcstWaterfall.cs:759 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-4eb87d28 | FindButton | DMF0053_CustFcstWaterfall.cs:761 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-2daa5369 | FindButton | DMF0053_CustFcstWaterfall.cs:780 | try ▸ if (ds.Tables[0] != null) | UI_PROP | dv.Sort | sOrderBy | 속성 Sort 설정 |  |  |  |
| AC-371bd3f2 | FindButton | DMF0053_CustFcstWaterfall.cs:782 | try ▸ if (ds.Tables[0] != null) | DATA_OP | dsSort.Tables.Add | (dv.ToTable()) | 데이터 객체 조작/조회 |  |  |  |
| AC-0d1e0bb2 | FindButton | DMF0053_CustFcstWaterfall.cs:782 | try ▸ if (ds.Tables[0] != null) | DATA_OP | dv.ToTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-08e39c54 | FindButton | DMF0053_CustFcstWaterfall.cs:784 | try ▸ if (ds.Tables[0] != null) | GRID_BIND | siMain.Query | (dsSort) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-fd554cab | FindButton | DMF0053_CustFcstWaterfall.cs:785 | try ▸ if (ds.Tables[0] != null) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8d1a1a45 | FindButton | DMF0053_CustFcstWaterfall.cs:786 | try ▸ if (ds.Tables[0] != null) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-452724e2 | FindButton | DMF0053_CustFcstWaterfall.cs:790 | try ▸ if (ds.Tables[0] != null) ▸ if (dsOrigianlCopy != null) | UI_MISC | dsOrigianlCopy.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-c62576b5 | FindButton | DMF0053_CustFcstWaterfall.cs:791 | try ▸ if (ds.Tables[0] != null) ▸ if (dsOrigianlCopy != null) | FLAG | dsOrigianlCopy | null | 화면 필드/플래그 변경 |  |  |  |
| AC-37bbc5a2 | FindButton | DMF0053_CustFcstWaterfall.cs:799 | try ▸ if (siMain.GetMaxRowIndex() > 0) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7193fa5f | FindButton | DMF0053_CustFcstWaterfall.cs:801 | try ▸ if (siMain.GetMaxRowIndex() > 0) | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-e782ea50 | FindButton | DMF0053_CustFcstWaterfall.cs:804 | try | FLAG | this_YYYYMMWW | "W_" + DateTime.Today.ToString("yyyyMM") + ds.Tables[1].Rows[0]["ISO_WEEK"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-87bb275c | FindButton | DMF0053_CustFcstWaterfall.cs:809 | try | FLAG | iso_week | ds.Tables[1].Rows[0]["ISO_WEEK"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-b915e5f6 | FindButton | DMF0053_CustFcstWaterfall.cs:904 | try | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-7beaa965 | FindButton | DMF0053_CustFcstWaterfall.cs:918 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2bb4a35d | FindButton | DMF0053_CustFcstWaterfall.cs:922 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## DMF0053_CustFcstWaterfall.fnValidation

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1caf9c2b | (진입점 미연결) | DMF0053_CustFcstWaterfall.cs:1481 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (iValidation > 1) | RETURN | return bValidation; |  | 처리 중단/반환 |  |  |  |
| AC-edb81040 | (진입점 미연결) | DMF0053_CustFcstWaterfall.cs:1485 |  | RETURN | return bValidation; |  | 처리 중단/반환 |  |  |  |

## DMF0053_CustFcstWaterfall.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d7ad6397 | this.Load | DMF0053_CustFcstWaterfall.cs:183 |  | FLAG | miFormLoad | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-8f23b01c | this.Load | DMF0053_CustFcstWaterfall.cs:185 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-4e8024fb | this.Load | DMF0053_CustFcstWaterfall.cs:186 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-9fdde19a | this.Load | DMF0053_CustFcstWaterfall.cs:193 |  | FLAG | miFormLoad | 1 | 화면 필드/플래그 변경 |  |  |  |

## DMF0053_CustFcstWaterfall.GetBizTypebyDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b669cfc4 | (진입점 미연결) | DMF0053_CustFcstWaterfall.cs:1649 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION") ⇒ SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-be38eb91 | (진입점 미연결) | DMF0053_CustFcstWaterfall.cs:1650 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-33ebcddd | (진입점 미연결) | DMF0053_CustFcstWaterfall.cs:1651 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f81b4813 | (진입점 미연결) | DMF0053_CustFcstWaterfall.cs:1654 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0053_CustFcstWaterfall.GetBucketType

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6a19e2eb | this.Load | DMF0053_CustFcstWaterfall.cs:1579 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0003_GET_REPORT_BUCKET_TYPE_CODE") ⇒ DM.DMF0003_GET_REPORT_BUCKET_TYPE_CODE | 엔드포인트 요청 생성 |  |  |  |
| AC-7bf07647 | this.Load | DMF0053_CustFcstWaterfall.cs:1580 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-b739df35 | this.Load | DMF0053_CustFcstWaterfall.cs:1583 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0053_CustFcstWaterfall.GetCustomerbyDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-11502217 | (진입점 미연결) | DMF0053_CustFcstWaterfall.cs:1634 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_CUSTOMER_BY_DIVISION") ⇒ SCM.SCM0001_GET_CUSTOMER_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-dfbe3632 | (진입점 미연결) | DMF0053_CustFcstWaterfall.cs:1635 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-f7b90fe8 | (진입점 미연결) | DMF0053_CustFcstWaterfall.cs:1636 |  | DATA_OP | request.Parameters["p_dept_id"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-ce5d7985 | (진입점 미연결) | DMF0053_CustFcstWaterfall.cs:1637 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-2e32b88a | (진입점 미연결) | DMF0053_CustFcstWaterfall.cs:1640 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0053_CustFcstWaterfall.GetDayRange

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-02f44045 | this.Load | DMF0053_CustFcstWaterfall.cs:1540 |  | ENDPOINT | new FoxDataRequest | ("DM.PR_GET_DAY_RANGE") ⇒ DM.PR_GET_DAY_RANGE | 엔드포인트 요청 생성 |  |  |  |
| AC-b8bc3336 | this.Load | DMF0053_CustFcstWaterfall.cs:1541 |  | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-d262114e | this.Load | DMF0053_CustFcstWaterfall.cs:1544 | if (parameter == "Period") | DATA_OP | request.Parameters["p_month"] | 6 | 행/컬럼 값 대입 |  |  |  |
| AC-73775d0e | this.Load | DMF0053_CustFcstWaterfall.cs:1548 | else of (parameter == "Period") | DATA_OP | request.Parameters["p_month"] | 1 | 행/컬럼 값 대입 |  |  |  |
| AC-bfcf4045 | this.Load | DMF0053_CustFcstWaterfall.cs:1550 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-8da5c187 | this.Load | DMF0053_CustFcstWaterfall.cs:1553 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |

## DMF0053_CustFcstWaterfall.GetDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-020fb4b4 | (진입점 미연결) | DMF0053_CustFcstWaterfall.cs:1494 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_DIVISION") ⇒ SCM.SCM0001_GET_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-67cdab97 | (진입점 미연결) | DMF0053_CustFcstWaterfall.cs:1496 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-117016f2 | (진입점 미연결) | DMF0053_CustFcstWaterfall.cs:1499 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0053_CustFcstWaterfall.GetItemType

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-103b338c | this.Load | DMF0053_CustFcstWaterfall.cs:1605 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_LOOKUP_VALUES") ⇒ SCM.SCM0001_GET_LOOKUP_VALUES | 엔드포인트 요청 생성 |  |  |  |
| AC-f926acc9 | this.Load | DMF0053_CustFcstWaterfall.cs:1606 |  | DATA_OP | request.Parameters["p_lookup_type"] | "ITEM_TYPE_CODE" | 행/컬럼 값 대입 |  |  |  |
| AC-45718ba4 | this.Load | DMF0053_CustFcstWaterfall.cs:1607 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d841f923 | this.Load | DMF0053_CustFcstWaterfall.cs:1610 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0053_CustFcstWaterfall.GetLastWeekSunDayByDate

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-65f1c4a3 | (진입점 미연결) | DMF0053_CustFcstWaterfall.cs:1699 |  | RETURN | return sYYYYMMDD; |  | 처리 중단/반환 |  |  |  |

## DMF0053_CustFcstWaterfall.GetPlantSitebyEndCustomer

진입점: this.spdMain.ComboSelChange [if (e.Column == siMain.GetColumnIndex(DefColumns.Division))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b212f239 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DMF0053_CustFcstWaterfall.cs:1524 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER") ⇒ SCM.SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER | 엔드포인트 요청 생성 |  |  |  |
| AC-dfcbfd5e | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DMF0053_CustFcstWaterfall.cs:1525 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-5c80d384 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DMF0053_CustFcstWaterfall.cs:1526 |  | DATA_OP | request.Parameters["p_dept_id"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-953889a6 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DMF0053_CustFcstWaterfall.cs:1527 |  | DATA_OP | request.Parameters["p_end_customer"] | sEdnCustomer | 행/컬럼 값 대입 |  |  |  |
| AC-adadebe1 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DMF0053_CustFcstWaterfall.cs:1528 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-ce788d7f | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DMF0053_CustFcstWaterfall.cs:1531 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0053_CustFcstWaterfall.GetQtyData

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f242b26c | this.Load | DMF0053_CustFcstWaterfall.cs:1592 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0003_GET_QTY_TYPE_CODE") ⇒ DM.DMF0003_GET_QTY_TYPE_CODE | 엔드포인트 요청 생성 |  |  |  |
| AC-2a6406bf | this.Load | DMF0053_CustFcstWaterfall.cs:1593 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-c2d1bafc | this.Load | DMF0053_CustFcstWaterfall.cs:1596 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0053_CustFcstWaterfall.GetScmSitebyDivision

진입점: this.spdMain.ComboSelChange [if (e.Column == siMain.GetColumnIndex(DefColumns.Division))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-de379d5b | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DMF0053_CustFcstWaterfall.cs:1508 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_SITE_BY_DIVISION") ⇒ SCM.SCM0001_GET_SITE_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-3a49449e | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DMF0053_CustFcstWaterfall.cs:1509 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-4d41589b | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DMF0053_CustFcstWaterfall.cs:1510 |  | DATA_OP | request.Parameters["p_dept_id"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-7d7daa82 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DMF0053_CustFcstWaterfall.cs:1511 |  | DATA_OP | request.Parameters["p_end_customer"] | sEdnCustomer | 행/컬럼 값 대입 |  |  |  |
| AC-b4bfd101 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DMF0053_CustFcstWaterfall.cs:1512 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-abc866cc | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DMF0053_CustFcstWaterfall.cs:1515 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0053_CustFcstWaterfall.GetSpdTitle

진입점: this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)] / this.cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if ((fBucket == BucketType.Weekly \|\| fBucket == BucketType.Monthly) && sBucket == BucketType.Daily)] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK)] / this.Load / cboDivision.SelectedIndexChanged [if (miFormLoad == 1)] / cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if ((fBucket == BucketType.Weekly \|\| fBucket == BucketType.Monthly) && sBucket == BucketType.Daily)] / FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-371454ba | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 6 | DMF0053_CustFcstWaterfall.cs:1559 |  | FLAG | fBucket | cboBucketType.ControlValues | 화면 필드/플래그 변경 |  |  |  |
| AC-96487041 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 6 | DMF0053_CustFcstWaterfall.cs:1563 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0053_GET_SPREAD_TITLE") ⇒ DM.DMF0053_GET_SPREAD_TITLE | 엔드포인트 요청 생성 |  |  |  |
| AC-f1896984 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 6 | DMF0053_CustFcstWaterfall.cs:1564 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | sMonth[0] | 행/컬럼 값 대입 |  |  |  |
| AC-7922e998 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 6 | DMF0053_CustFcstWaterfall.cs:1565 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | sMonth[1] | 행/컬럼 값 대입 |  |  |  |
| AC-276417fc | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 6 | DMF0053_CustFcstWaterfall.cs:1566 |  | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-002370f8 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 6 | DMF0053_CustFcstWaterfall.cs:1567 |  | DATA_OP | request.Parameters["p_division_id"] | cboDivision.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-5115bd5b | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 6 | DMF0053_CustFcstWaterfall.cs:1568 |  | DATA_OP | request.Parameters["p_bucket"] | fBucket | 행/컬럼 값 대입 |  |  |  |
| AC-c808748e | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 6 | DMF0053_CustFcstWaterfall.cs:1570 |  | FLAG | dtTitle | client.ExecuteDataSet(request).DataSet.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-6ad58b21 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 6 | DMF0053_CustFcstWaterfall.cs:1570 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## DMF0053_CustFcstWaterfall.GetTeambyDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0b418b14 | (진입점 미연결) | DMF0053_CustFcstWaterfall.cs:1620 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_TEAM_BY_DIVISION") ⇒ SCM.SCM0001_GET_TEAM_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-acdd044f | (진입점 미연결) | DMF0053_CustFcstWaterfall.cs:1621 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-632523ea | (진입점 미연결) | DMF0053_CustFcstWaterfall.cs:1622 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-09d1efeb | (진입점 미연결) | DMF0053_CustFcstWaterfall.cs:1625 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0053_CustFcstWaterfall.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-80f5dc75 | this.Load | DMF0053_CustFcstWaterfall.cs:266 |  | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtMain) | 데이터 객체 조작/조회 |  |  |  |
| AC-18a31520 | this.Load | DMF0053_CustFcstWaterfall.cs:272 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, cboDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-cc8d4fde | this.Load | DMF0053_CustFcstWaterfall.cs:281 |  | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-6c14ecbd | this.Load | DMF0053_CustFcstWaterfall.cs:292 | if ((cboDivision.ControlValues.Substring(0, 2) == "81") \|\| (cboDivision.ControlValues == "82")) | LIST_REBIND | clsCtrl.setListBox | (dtCustomer, clbCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-9409b0ce | this.Load | DMF0053_CustFcstWaterfall.cs:306 | else of ((cboDivision.ControlValues.Substring(0, 2) == "81") \|\| (cboDivision.ControlValues == "82")) | LIST_REBIND | clsCtrl.setListBox | (dtCustomer, clbCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-ecbf9adf | this.Load | DMF0053_CustFcstWaterfall.cs:317 |  | LIST_REBIND | clsCtrl.setListBox | (dtBizType, clbBizType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-9228904c | this.Load | DMF0053_CustFcstWaterfall.cs:322 |  | STATE | lblBizType.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-d2e4b409 | this.Load | DMF0053_CustFcstWaterfall.cs:323 |  | VALUE_SET | chkSum.Checked | false | 컨트롤 값 설정 |  |  |  |
| AC-1ad7f30b | this.Load | DMF0053_CustFcstWaterfall.cs:332 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-2d6fa50c | this.Load | DMF0053_CustFcstWaterfall.cs:338 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantSite, clbPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-0d6d30c3 | this.Load | DMF0053_CustFcstWaterfall.cs:340 |  | FLAG | dtBucketType | GetBucketType() | 화면 필드/플래그 변경 |  |  |  |
| AC-27540e15 | this.Load | DMF0053_CustFcstWaterfall.cs:341 |  | LIST_REBIND | clsCtrl.setListBox | (dtBucketType, cboBucketType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-ea650947 | this.Load | DMF0053_CustFcstWaterfall.cs:349 |  | VALUE_SET | drpPeriod.InitValue | GetDayRange("Period") | 컨트롤 값 설정 |  |  |  |
| AC-58c5b00e | this.Load | DMF0053_CustFcstWaterfall.cs:350 |  | VALUE_SET | drpCreateDate.InitValue | GetDayRange("CreateDate") | 컨트롤 값 설정 |  |  |  |
| AC-4381cf33 | this.Load | DMF0053_CustFcstWaterfall.cs:352 |  | FLAG | dtItemType | GetItemType() | 화면 필드/플래그 변경 |  |  |  |
| AC-779d6381 | this.Load | DMF0053_CustFcstWaterfall.cs:353 |  | LIST_REBIND | clsCtrl.setListBox | (dtItemType, clbItemType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-a3040488 | this.Load | DMF0053_CustFcstWaterfall.cs:356 |  | FLAG | dtQty | GetQtyData() | 화면 필드/플래그 변경 |  |  |  |
| AC-a48510ca | this.Load | DMF0053_CustFcstWaterfall.cs:357 |  | LIST_REBIND | clsCtrl.setListBox | (dtQty, cboQTY, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## DMF0053_CustFcstWaterfall.InitSpread

진입점: this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)] / this.cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if ((fBucket == BucketType.Weekly \|\| fBucket == BucketType.Monthly) && sBucket == BucketType.Daily)] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK)] / this.Load / cboDivision.SelectedIndexChanged [if (miFormLoad == 1)] / cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if ((fBucket == BucketType.Weekly \|\| fBucket == BucketType.Monthly) && sBucket == BucketType.Daily)] / FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-951204b9 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 6 | DMF0053_CustFcstWaterfall.cs:389 |  | GRID_INIT | siMain.CreateSheetHeaderColumn | (siMain, 3, dtTitle) | 그리드 재구성/초기화 |  |  |  |
| AC-f691be7f | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 6 | DMF0053_CustFcstWaterfall.cs:396 | if (dtTitle != null && dtTitle.Rows.Count > 0) ▸ if (cboBucketType.ControlValues == BucketType.ONLY_WEEKLY) | STATE | chkSum.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-f8b739c9 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 6 | DMF0053_CustFcstWaterfall.cs:397 | if (dtTitle != null && dtTitle.Rows.Count > 0) ▸ if (cboBucketType.ControlValues == BucketType.ONLY_WEEKLY) | VALUE_SET | chkSum.Checked | false | 컨트롤 값 설정 |  |  |  |
| AC-93e5689b | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 6 | DMF0053_CustFcstWaterfall.cs:403 | if (dtTitle != null && dtTitle.Rows.Count > 0) ▸ else of (cboBucketType.ControlValues == BucketType.ONLY_WEEKLY) | STATE | chkSum.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## DMF0053_CustFcstWaterfall.InitSpreadFooterSum

진입점: this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / this.cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if ((fBucket == BucketType.Weekly \|\| fBucket == BucketType.Monthly) && sBucket == BucketType.Daily) ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / this.Load [if (dtTitle != null && dtTitle.Rows.Count > 0)] / cboDivision.SelectedIndexChanged [if (miFormLoad == 1) ▸ if (dtTitle != null && dtTitle.Row…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-60febb49 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 6 | DMF0053_CustFcstWaterfall.cs:417 |  | GRID_SET | siMain.ActiveSheet.ColumnFooter.Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-11268721 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 6 | DMF0053_CustFcstWaterfall.cs:418 |  | GRID_SET | siMain.ActiveSheet.ColumnFooter.Cells[0, 1].Value | "Sum" | 그리드 속성/값 설정 |  |  |  |
| AC-eac00e34 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 6 | DMF0053_CustFcstWaterfall.cs:425 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("M_") == … | CALL_EXT | siMain.ActiveSheet.ColumnFooter.SetAggregationFormat | (0, iCol, "{0:#,##0.###}") | ⚠ 의미 확인 필요 |  |  |  |
| AC-20648245 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 6 | DMF0053_CustFcstWaterfall.cs:426 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("M_") == … | CALL_EXT | siMain.ActiveSheet.ColumnFooter.SetAggregationType | (0, iCol, FarPoint.Win.Spread.Model.AggregationType.SumIgnoreHidden) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f4864783 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 6 | DMF0053_CustFcstWaterfall.cs:427 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("M_") == … | GRID_SET | siMain.ActiveSheet.ColumnFooter.Cells[0, iCol].BackColor | Color.LightGray | 그리드 속성/값 설정 |  |  |  |
| AC-af264d93 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 6 | DMF0053_CustFcstWaterfall.cs:428 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("M_") == … | GRID_SET | siMain.ActiveSheet.ColumnFooter.Cells[0, iCol].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |

## DMF0053_CustFcstWaterfall.SetAmountCalculating

진입점: this.cboQTY.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1a31a712 | this.cboQTY.SelectedIndexChanged | DMF0053_CustFcstWaterfall.cs:1736 | if (siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e3813efc | this.cboQTY.SelectedIndexChanged | DMF0053_CustFcstWaterfall.cs:1740 | if (dsOrigianlCopy == null) | FLAG | dsOrigianlCopy | siMain.SpreadObject.DataSource as DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-fb8c58a9 | this.cboQTY.SelectedIndexChanged | DMF0053_CustFcstWaterfall.cs:1746 | if (cboQTY.SelectedIndex == 0) | LIST_BIND | siMain.SpreadObject.DataSource | dsOrigianlCopy | 목록/그리드 데이터 원천 연결 |  |  |  |
| AC-5770e29c | this.cboQTY.SelectedIndexChanged | DMF0053_CustFcstWaterfall.cs:1747 | if (cboQTY.SelectedIndex == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-118af3c3 | this.cboQTY.SelectedIndexChanged | DMF0053_CustFcstWaterfall.cs:1750 |  | DATA_OP | dsOrigianlCopy.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-094c2ba0 | this.cboQTY.SelectedIndexChanged | DMF0053_CustFcstWaterfall.cs:1752 |  | DATA_OP | dsKrw.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-ee14fcde | this.cboQTY.SelectedIndexChanged | DMF0053_CustFcstWaterfall.cs:1792 | for (i < dsOrigianlCopy.Tables[0].Rows.Count) ▸ for (j < dsKrw.Tables[0].Columns.Count) ▸ if (dsKrw.Tables[0].Columns[j].ColumnName.IndexOf(… | GRID_SET | dsKrw.Tables[0].Rows[i][j] | Math.Round(Convert.ToDouble(slValue) / dbQtyDivideAmount, 2) | 그리드 속성/값 설정 |  |  |  |
| AC-56946693 | this.cboQTY.SelectedIndexChanged | DMF0053_CustFcstWaterfall.cs:1798 |  | DATA_OP | dsKrw.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-4284bdaa | this.cboQTY.SelectedIndexChanged | DMF0053_CustFcstWaterfall.cs:1804 | if (ds != null) | UI_MISC | ds.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-a6314063 | this.cboQTY.SelectedIndexChanged | DMF0053_CustFcstWaterfall.cs:1808 |  | LIST_BIND | siMain.SpreadObject.DataSource | dsKrw | 목록/그리드 데이터 원천 연결 |  |  |  |
| AC-9ff33fb1 | this.cboQTY.SelectedIndexChanged | DMF0053_CustFcstWaterfall.cs:1812 | if (dsKrw != null) | UI_MISC | dsKrw.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-dabbd6c5 | this.cboQTY.SelectedIndexChanged | DMF0053_CustFcstWaterfall.cs:1815 |  | CALL_EXT | GC.Collect | () | ⚠ 의미 확인 필요 |  |  |  |

## DMF0053_CustFcstWaterfall.SetChangeControl

진입점: this.Load / cboDivision.SelectedIndexChanged / this.clbTeam.SelectedIndexChanged [if (sDivision != null && sDivision != "") ▸ if ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82"))] / this.clbCustomer.SelectedIndexChanged [if (sDivision != null && sDivision != "") ▸ if ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82"))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-595be09f | this.Load 외 3 | DMF0053_CustFcstWaterfall.cs:209 |  | DATA_OP | Filter["GROUP_ID"] | UserInfoContext.Current["NowGroupID"] | 행/컬럼 값 대입 |  |  |  |
| AC-ddbcd56a | this.Load 외 3 | DMF0053_CustFcstWaterfall.cs:210 |  | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-1a234cbc | this.Load 외 3 | DMF0053_CustFcstWaterfall.cs:216 | switch (triggerControl) case "MyDivision": | FLAG | dtDivision | DataService.GetDMInnerTable("MyDivision", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-b918ac70 | this.Load 외 3 | DMF0053_CustFcstWaterfall.cs:216 | switch (triggerControl) case "MyDivision": | COMBO_DATA | DataService.GetDMInnerTable | ("MyDivision", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-657b19bb | this.Load 외 3 | DMF0053_CustFcstWaterfall.cs:221 | switch (triggerControl) case "UserTeamByDivision": | DATA_OP | Filter["DIVISION_ID"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-be5f679c | this.Load 외 3 | DMF0053_CustFcstWaterfall.cs:223 | switch (triggerControl) case "UserTeamByDivision": | FLAG | dtTeam | DataService.GetDMInnerTable("UserTeamByDivision", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-17d8f1ee | this.Load 외 3 | DMF0053_CustFcstWaterfall.cs:223 | switch (triggerControl) case "UserTeamByDivision": | COMBO_DATA | DataService.GetDMInnerTable | ("UserTeamByDivision", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-9481ff26 | this.Load 외 3 | DMF0053_CustFcstWaterfall.cs:228 | switch (triggerControl) case "EndCustomerByDivision": | DATA_OP | Filter["DIVISION_ID"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-2016e93d | this.Load 외 3 | DMF0053_CustFcstWaterfall.cs:229 | switch (triggerControl) case "EndCustomerByDivision": | DATA_OP | Filter["DEPT_ID"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-60280b3c | this.Load 외 3 | DMF0053_CustFcstWaterfall.cs:231 | switch (triggerControl) case "EndCustomerByDivision": | FLAG | dtCustomer | DataService.GetDMInnerTable("EndCustomerByDivision", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-1186da2d | this.Load 외 3 | DMF0053_CustFcstWaterfall.cs:231 | switch (triggerControl) case "EndCustomerByDivision": | COMBO_DATA | DataService.GetDMInnerTable | ("EndCustomerByDivision", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-27f6ce70 | this.Load 외 3 | DMF0053_CustFcstWaterfall.cs:236 | switch (triggerControl) case "BizType": | DATA_OP | Filter["DIVISION_ID"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-4b8e7491 | this.Load 외 3 | DMF0053_CustFcstWaterfall.cs:238 | switch (triggerControl) case "BizType": | FLAG | dtBizType | DataService.GetDMInnerTable("BizType", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-3788eefa | this.Load 외 3 | DMF0053_CustFcstWaterfall.cs:238 | switch (triggerControl) case "BizType": | COMBO_DATA | DataService.GetDMInnerTable | ("BizType", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-13860e6e | this.Load 외 3 | DMF0053_CustFcstWaterfall.cs:243 | switch (triggerControl) case "UserSiteByEndCustomer": | DATA_OP | Filter["DIVISION_ID"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-ebbb358b | this.Load 외 3 | DMF0053_CustFcstWaterfall.cs:244 | switch (triggerControl) case "UserSiteByEndCustomer": | DATA_OP | Filter["DEPT_ID"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-ebef19d0 | this.Load 외 3 | DMF0053_CustFcstWaterfall.cs:245 | switch (triggerControl) case "UserSiteByEndCustomer": | DATA_OP | Filter["END_CUSTOMER"] | sEndCustomer | 행/컬럼 값 대입 |  |  |  |
| AC-d01462fb | this.Load 외 3 | DMF0053_CustFcstWaterfall.cs:247 | switch (triggerControl) case "UserSiteByEndCustomer": | FLAG | dtSalesSite | DataService.GetDMInnerTable("UserSiteByEndCustomer", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-7ab54209 | this.Load 외 3 | DMF0053_CustFcstWaterfall.cs:247 | switch (triggerControl) case "UserSiteByEndCustomer": | COMBO_DATA | DataService.GetDMInnerTable | ("UserSiteByEndCustomer", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-97373821 | this.Load 외 3 | DMF0053_CustFcstWaterfall.cs:252 | switch (triggerControl) case "UserPlantSiteByDivision": | DATA_OP | Filter["DIVISION_ID"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-074e5b8b | this.Load 외 3 | DMF0053_CustFcstWaterfall.cs:254 | switch (triggerControl) case "UserPlantSiteByDivision": | FLAG | dtPlantSite | DataService.GetDMInnerTable("UserPlantSiteByDivision", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-a1366392 | this.Load 외 3 | DMF0053_CustFcstWaterfall.cs:254 | switch (triggerControl) case "UserPlantSiteByDivision": | COMBO_DATA | DataService.GetDMInnerTable | ("UserPlantSiteByDivision", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |

## DMF0053_CustFcstWaterfall.SetSpreadColumn

진입점: this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / this.chkSum.CheckedChanged [if (siMain != null)] / this.cboBucketType.SelectedIndexChanged [if (siMain != null)] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / this.Load [if (dtTitle != null && dtTitle.Rows.Count > 0)] / cboDivision.SelectedIndexChanged [if (miFormLoad == 1) ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / cboBucketType.SelectedIndexChanged [if (siMain != null)] / FindButton [try ▸ if (siMai…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-00806ebd | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 8 | DMF0053_CustFcstWaterfall.cs:1380 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siMain.GetColumnTag(iCol).IndexOf("D_"… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-8cbc89d0 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 8 | DMF0053_CustFcstWaterfall.cs:1383 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siMain.GetColumnTag(iCol).IndexOf("M_"… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-c950e81d | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 8 | DMF0053_CustFcstWaterfall.cs:1388 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Bu… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-6f98149d | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 8 | DMF0053_CustFcstWaterfall.cs:1390 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Bu… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-c95eff03 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 8 | DMF0053_CustFcstWaterfall.cs:1393 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Bu… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-a53022ea | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 8 | DMF0053_CustFcstWaterfall.cs:1398 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboBucketType.ControlValues … | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-8adfa318 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 8 | DMF0053_CustFcstWaterfall.cs:1400 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboBucketType.ControlValues … | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |

## DMF0053_CustFcstWaterfall.SetSpreadHeader

진입점: this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dtTitle != null && dtTitle.Rows.Count > 0) ▸ if (cboBucketType.ControlValues == BucketType.ONLY_WEEKLY)] / this.cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if ((fBucket == BucketType.Weekly \|\| fBucket == BucketType.Monthly) && sBucket == BucketType.Daily) ▸ if (dtTitle != null && dtTitle.Rows.Count > 0) ▸ if (cboBucketType.ControlValues == BucketType.ONLY_WEEKLY)] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dtTitle != null && dtTitle.Rows.Count > 0) ▸ if (cboBucketType.ControlValues…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-de5d9751 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 6 | DMF0053_CustFcstWaterfall.cs:449 | foreach (DataRow dr in dt.Rows) ▸ if (iCellCnt < iStartCol) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iCellCnt, 3, 1, 20, sColumnLabel, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3a04fdb9 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 6 | DMF0053_CustFcstWaterfall.cs:457 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt < iStartCol) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, iStartCol, 0, iStartCol].Text | sLargeLabelName | 그리드 속성/값 설정 |  |  |  |
| AC-7aca0441 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 6 | DMF0053_CustFcstWaterfall.cs:458 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt < iStartCol) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[1, iStartCol, 1, iStartCol].Text | sSmallLabelName | 그리드 속성/값 설정 |  |  |  |
| AC-536334c5 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 6 | DMF0053_CustFcstWaterfall.cs:459 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt < iStartCol) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[2, iStartCol, 2, iStartCol].Text | "SUM" | 그리드 속성/값 설정 |  |  |  |
| AC-b65f4d76 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 6 | DMF0053_CustFcstWaterfall.cs:463 |  | GRID_INIT | siMain.Freeze | (0, siMain.GetColumnIndex(DefColumns.Measure) + 1) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-54707fee | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 6 | DMF0053_CustFcstWaterfall.cs:464 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0053_CustFcstWaterfall.SetSpreadHeaderSpan

진입점: this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dtTitle != null && dtTitle.Rows.Count > 0) ▸ else of (cboBucketType.ControlValues == BucketType.ONLY_WEEKLY)] / this.cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if ((fBucket == BucketType.Weekly \|\| fBucket == BucketType.Monthly) && sBucket == BucketType.Daily) ▸ if (dtTitle != null && dtTitle.Rows.Count > 0) ▸ else of (cboBucketType.ControlValues == BucketType.ONLY_WEEKLY)] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dtTitle != null && dtTitle.Rows.Count > 0) ▸ else of (cboBucketTyp…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d04242a4 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 6 | DMF0053_CustFcstWaterfall.cs:493 | foreach (DataRow dr in dt.Rows) ▸ if (iCellCnt <= iSmallStartCol) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iCellCnt, 3, 1, 20, sColumnLabel, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4f9e2f46 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 6 | DMF0053_CustFcstWaterfall.cs:501 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (dr[DefColumns.ColumnName].ToString().IndexOf("B_") > 0) | GRID_INIT | siMain.VisibleColumns | (iCellCnt, false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-88040be3 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 6 | DMF0053_CustFcstWaterfall.cs:514 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ else of (dr[DefColumns.ColumnName].ToString().IndexOf("B_") > 0) ▸ … | GRID_SET | siMain.Sheet().ColumnHeader.Cells[2, iCellCnt].ForeColor | dr[DefColumns.DayCode].ToString() == DefColumnsLabel.Saturday ? Color.Blue : Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-22b1e4f0 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 6 | DMF0053_CustFcstWaterfall.cs:522 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-92a2a47f | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 6 | DMF0053_CustFcstWaterfall.cs:523 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ac8910fd | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 6 | DMF0053_CustFcstWaterfall.cs:528 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-807fa575 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 6 | DMF0053_CustFcstWaterfall.cs:529 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 30, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-33e12fcb | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 6 | DMF0053_CustFcstWaterfall.cs:536 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName !=… | GRID_INIT | siMain.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-92831270 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 6 | DMF0053_CustFcstWaterfall.cs:537 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName !=… | GRID_INIT | siMain.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e4a8c3ec | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 6 | DMF0053_CustFcstWaterfall.cs:548 |  | GRID_INIT | siMain.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-858ef4d1 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 6 | DMF0053_CustFcstWaterfall.cs:549 |  | GRID_INIT | siMain.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-78712431 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 6 | DMF0053_CustFcstWaterfall.cs:550 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c10fb1c5 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 6 | DMF0053_CustFcstWaterfall.cs:551 |  | GRID_INIT | siMain.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b21e0f5c | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 6 | DMF0053_CustFcstWaterfall.cs:553 |  | GRID_INIT | siMain.Freeze | (0, siMain.GetColumnIndex(DefColumns.Measure) + 1) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-7783831a | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 6 | DMF0053_CustFcstWaterfall.cs:554 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0053_CustFcstWaterfall.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-917097a7 | this.spdMain.CellDoubleClick | DMF0053_CustFcstWaterfall.cs:1169 | if (e.ColumnHeader) ▸ if (siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColum… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | !siMain.ActiveSheet.Columns[iCol].Visible | 그리드 속성/값 설정 |  |  |  |
| AC-e08fae4a | this.spdMain.CellDoubleClick | DMF0053_CustFcstWaterfall.cs:1175 | if (e.ColumnHeader) ▸ if (siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (siMain.Get… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | !siMain.ActiveSheet.Columns[iCol].Visible | 그리드 속성/값 설정 |  |  |  |
| AC-7098a8b7 | this.spdMain.CellDoubleClick | DMF0053_CustFcstWaterfall.cs:1181 | if (e.ColumnHeader) ▸ if (siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (siMain.Get… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | !siMain.ActiveSheet.Columns[iCol].Visible | 그리드 속성/값 설정 |  |  |  |
| AC-1b32932b | this.spdMain.CellDoubleClick | DMF0053_CustFcstWaterfall.cs:1199 | if (e.ColumnHeader) ▸ else of (siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ▸ if (siMain.GetColumnTag(e.Column).IndexOf("W_") == 0) ▸ f… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | !siMain.ActiveSheet.Columns[iCol].Visible | 그리드 속성/값 설정 |  |  |  |
| AC-c9a7a608 | this.spdMain.CellDoubleClick | DMF0053_CustFcstWaterfall.cs:1214 | else of (e.ColumnHeader) ▸ if (siMain.IsLock(siMain.SheetName) \|\| siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) !… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-848486fb | this.spdMain.CellDoubleClick | DMF0053_CustFcstWaterfall.cs:1221 | else of (e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.Project)) | POPUP | new SCM0002_ProjectbyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-3b708868 | this.spdMain.CellDoubleClick | DMF0053_CustFcstWaterfall.cs:1223 | else of (e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.Project)) | POPUP | popProject.Form_Load | (false, sDivision, sProject) | 팝업 초기화(인자 전달) |  |  |  |
| AC-75c7561b | this.spdMain.CellDoubleClick | DMF0053_CustFcstWaterfall.cs:1224 | else of (e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.Project)) | UI_PROP | popProject.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-9952e162 | this.spdMain.CellDoubleClick | DMF0053_CustFcstWaterfall.cs:1225 | else of (e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.Project)) | POPUP | popProject.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-da9882e4 | this.spdMain.CellDoubleClick | DMF0053_CustFcstWaterfall.cs:1229 | else of (e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.Project)) | GRID_SET | siMain.SetText | (e.Row, e.Column, sProject) | 그리드 값 설정 |  |  |  |
| AC-02583e7f | this.spdMain.CellDoubleClick | DMF0053_CustFcstWaterfall.cs:1238 | else of (e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumn… | POPUP | new SCM0002_ItembyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-775d7397 | this.spdMain.CellDoubleClick | DMF0053_CustFcstWaterfall.cs:1240 | else of (e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumn… | POPUP | popItem.Form_Load | (false, sDivision, sScmSiteId, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-1d020114 | this.spdMain.CellDoubleClick | DMF0053_CustFcstWaterfall.cs:1241 | else of (e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumn… | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-e7c2bc59 | this.spdMain.CellDoubleClick | DMF0053_CustFcstWaterfall.cs:1242 | else of (e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumn… | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-93d34918 | this.spdMain.CellDoubleClick | DMF0053_CustFcstWaterfall.cs:1246 | else of (e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumn… | GRID_SET | siMain.SetText | (e.Row, e.Column, sItemId) | 그리드 값 설정 |  |  |  |

## DMF0053_CustFcstWaterfall.spdMain_ComboSelChange

진입점: this.spdMain.ComboSelChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-35cb3078 | this.spdMain.ComboSelChange | DMF0053_CustFcstWaterfall.cs:1152 | if (e.Column == siMain.GetColumnIndex(DefColumns.Division)) | FLAG | dtSalesSite | GetScmSitebyDivision(siMain.GetValue(e.Row, e.Column).ToString(), CAppSetting.StringALL, C… | 화면 필드/플래그 변경 |  |  |  |
| AC-231af578 | this.spdMain.ComboSelChange | DMF0053_CustFcstWaterfall.cs:1153 | if (e.Column == siMain.GetColumnIndex(DefColumns.Division)) | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.ScmSiteId), dtSalesSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-bdf08d3c | this.spdMain.ComboSelChange | DMF0053_CustFcstWaterfall.cs:1155 | if (e.Column == siMain.GetColumnIndex(DefColumns.Division)) | FLAG | dtPlantSite | GetPlantSitebyEndCustomer(siMain.GetValue(e.Row, e.Column).ToString(), CAppSetting.StringA… | 화면 필드/플래그 변경 |  |  |  |
| AC-16765bcd | this.spdMain.ComboSelChange | DMF0053_CustFcstWaterfall.cs:1156 | if (e.Column == siMain.GetColumnIndex(DefColumns.Division)) | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.PlantSiteId), dtPlantSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |

## DMF0053_CustFcstWaterfall.spdMain_KeyUp

진입점: this.spdMain.KeyUp

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f6931cff | this.spdMain.KeyUp | DMF0053_CustFcstWaterfall.cs:1260 | if (siMain.GetColumnIndex(DefColumns.Measure) >= siMain.ActiveColumnIndex) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c88c495d | this.spdMain.KeyUp | DMF0053_CustFcstWaterfall.cs:1264 | if (e.Control == true && e.KeyCode == Keys.V \|\| e.Control == false && e.KeyCode == Keys.V) | CALL_EXT | spdMain.ActiveSheet.ClipboardPaste | (ClipboardPasteOptions.AsStringSkipHidden) | ⚠ 의미 확인 필요 |  |  |  |
| AC-fa8d08a6 | this.spdMain.KeyUp | DMF0053_CustFcstWaterfall.cs:1270 | if (e.Control == true && e.KeyCode == Keys.C \|\| e.Control == false && e.KeyCode == Keys.C) | CALL_EXT | Clipboard.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-1fb41048 | this.spdMain.KeyUp | DMF0053_CustFcstWaterfall.cs:1271 | if (e.Control == true && e.KeyCode == Keys.C \|\| e.Control == false && e.KeyCode == Keys.C) | CALL_EXT | spdMain.Sheets[0].ClipboardCopy | (ClipboardCopyOptions.AsStringSkipHidden) | ⚠ 의미 확인 필요 |  |  |  |

## DMF0053_CustFcstWaterfall.spdMain_TopChange

진입점: this.spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7ca1617d | this.spdMain.TopChange | DMF0053_CustFcstWaterfall.cs:1254 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

