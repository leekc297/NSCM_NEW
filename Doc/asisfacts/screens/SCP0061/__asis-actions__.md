# AS-IS 액션 대조표 — SCP0061

> 원천: `Doc/asisfacts/screens/SCP0061/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 314행 · 메서드 32 · 종류 DATA_OP 111 · FLAG 26 · ENDPOINT 22 · GRID_INIT 21 · RETURN 20 · COMBO_DATA 20 · MESSAGE 18 · GRID_SET 15 · UI_PROP 10 · VALUE_SET 9 · LIST_REBIND 9 · CALL_EXT 8 · UI_MISC 7 · POPUP 6 · STATE 4 · VALIDATE 4 · GRID_BIND 1 · GRID_LOCK 1 · LIST_CLEAR 1 · VALUE_CLEAR 1 · ⚠ 의미 확인 필요 8


## SCP0061_ProductionPlanFix_JV.btnItemId_Click

진입점: this.btnItemId.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-363f092a | this.btnItemId.Click | SCP0061_ProductionPlanFix_JV.cs:486 |  | CALL_EXT | UIUtils.GetAllDivisionCheckedElectrode | (cboDivision) | ⚠ 의미 확인 필요 |  |  |  |
| AC-22824d97 | this.btnItemId.Click | SCP0061_ProductionPlanFix_JV.cs:493 |  | POPUP | new SCM0002_ItembyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-946c02e1 | this.btnItemId.Click | SCP0061_ProductionPlanFix_JV.cs:495 |  | POPUP | popItem.Form_Load | (true, division, sScmSite, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-8443d15f | this.btnItemId.Click | SCP0061_ProductionPlanFix_JV.cs:496 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-df69634b | this.btnItemId.Click | SCP0061_ProductionPlanFix_JV.cs:497 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-87e3baa4 | this.btnItemId.Click | SCP0061_ProductionPlanFix_JV.cs:503 | if (popItem.ItemID != "") | VALUE_SET | txtItemId.Text | sItemId | 컨트롤 값 설정 |  |  |  |

## SCP0061_ProductionPlanFix_JV.BtnUnfix_Click

진입점: btnUnfix.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a5b566f3 | btnUnfix.Click | SCP0061_ProductionPlanFix_JV.cs:1128 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d73a98db | btnUnfix.Click | SCP0061_ProductionPlanFix_JV.cs:1129 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0061_ProductionPlanFix_JV.BtnW26_Click

진입점: this.btnW26.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-832cc14d | this.btnW26.Click | SCP0061_ProductionPlanFix_JV.cs:1139 |  | VALUE_SET | drpPeriod.InitValue | GetDayRange(PeriodType.W26) | 컨트롤 값 설정 |  |  |  |

## SCP0061_ProductionPlanFix_JV.BtnW52_Click

진입점: this.btnW52.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-60d50686 | this.btnW52.Click | SCP0061_ProductionPlanFix_JV.cs:1144 |  | VALUE_SET | drpPeriod.InitValue | GetDayRange(PeriodType.W52) | 컨트롤 값 설정 |  |  |  |

## SCP0061_ProductionPlanFix_JV.BtnWLast_Click

진입점: this.btnWLast.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bb2a624a | this.btnWLast.Click | SCP0061_ProductionPlanFix_JV.cs:1154 |  | VALUE_SET | drpPeriod.InitValue | GetDayRange(sPeriod) | 컨트롤 값 설정 |  |  |  |

## SCP0061_ProductionPlanFix_JV.CboDivision_SelectedIndexChanged

진입점: cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-280f284c | cboDivision.SelectedIndexChanged | SCP0061_ProductionPlanFix_JV.cs:951 |  | VALUE_SET | btnWLast.Text | "W" + dailyPlanPeriod | 컨트롤 값 설정 |  |  |  |

## SCP0061_ProductionPlanFix_JV.CboOperationGroup_SelectedIndexChanged

진입점: cboOperationGroup.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f79a7d75 | cboOperationGroup.SelectedIndexChanged | SCP0061_ProductionPlanFix_JV.cs:984 | if (division.Substring(0, 2).Equals("EE")) | CALL_EXT | dic_JV_Plant.TryGetValue | (division, out get_JV_Value) | ⚠ 의미 확인 필요 |  |  |  |
| AC-705845da | cboOperationGroup.SelectedIndexChanged | SCP0061_ProductionPlanFix_JV.cs:997 | if (division.Substring(0, 2).Equals("EE")) ▸ if (get_JV_Value != "") | FLAG | dtPlantSiteByDivision | Data_SCP.Common(Data_SCP.Type.PlantSiteProdPlan, false, division, pOperationGroup, "JV Pla… | 화면 필드/플래그 변경 |  |  |  |
| AC-569c3e6a | cboOperationGroup.SelectedIndexChanged | SCP0061_ProductionPlanFix_JV.cs:997 | if (division.Substring(0, 2).Equals("EE")) ▸ if (get_JV_Value != "") | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.PlantSiteProdPlan, false, division, pOperationGroup, "JV Planner", get_JV_V… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-76044c74 | cboOperationGroup.SelectedIndexChanged | SCP0061_ProductionPlanFix_JV.cs:1001 | if (division.Substring(0, 2).Equals("EE")) ▸ else of (get_JV_Value != "") | FLAG | dtPlantSiteByDivision | Data_SCP.Common(Data_SCP.Type.PlantSiteProdPlan, false, division, pOperationGroup, "JV Pla… | 화면 필드/플래그 변경 |  |  |  |
| AC-60def28d | cboOperationGroup.SelectedIndexChanged | SCP0061_ProductionPlanFix_JV.cs:1001 | if (division.Substring(0, 2).Equals("EE")) ▸ else of (get_JV_Value != "") | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.PlantSiteProdPlan, false, division, pOperationGroup, "JV Planner", "9999!!!… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-8fc0d45f | cboOperationGroup.SelectedIndexChanged | SCP0061_ProductionPlanFix_JV.cs:1008 | else of (division.Substring(0, 2).Equals("EE")) | CALL_EXT | dic_JV_Plant.TryGetValue | (division, out get_JV_Value) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d370c993 | cboOperationGroup.SelectedIndexChanged | SCP0061_ProductionPlanFix_JV.cs:1012 | else of (division.Substring(0, 2).Equals("EE")) ▸ if (get_JV_Value != "") | FLAG | dtPlantSiteByDivision | Data.Common(Data.Type.PlantByDivisionOperation, false, division, pOperationGroup, "JV Plan… ⇒ biz:CommonData.CommonDataList [code=PlantByDivisionOperation] | 화면 필드/플래그 변경 |  |  |  |
| AC-ca229ab4 | cboOperationGroup.SelectedIndexChanged | SCP0061_ProductionPlanFix_JV.cs:1012 | else of (division.Substring(0, 2).Equals("EE")) ▸ if (get_JV_Value != "") | COMBO_DATA | Data.Common | (Data.Type.PlantByDivisionOperation, false, division, pOperationGroup, "JV Planner", get_J… ⇒ biz:CommonData.CommonDataList [code=PlantByDivisionOperation] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-7a951cb6 | cboOperationGroup.SelectedIndexChanged | SCP0061_ProductionPlanFix_JV.cs:1016 | else of (division.Substring(0, 2).Equals("EE")) ▸ else of (get_JV_Value != "") | FLAG | dtPlantSiteByDivision | Data.Common(Data.Type.PlantByDivisionOperation, false, "9999!!!!", pOperationGroup, "JV Pl… ⇒ biz:CommonData.CommonDataList [code=PlantByDivisionOperation] | 화면 필드/플래그 변경 |  |  |  |
| AC-bbe6a2e8 | cboOperationGroup.SelectedIndexChanged | SCP0061_ProductionPlanFix_JV.cs:1016 | else of (division.Substring(0, 2).Equals("EE")) ▸ else of (get_JV_Value != "") | COMBO_DATA | Data.Common | (Data.Type.PlantByDivisionOperation, false, "9999!!!!", pOperationGroup, "JV Planner", get… ⇒ biz:CommonData.CommonDataList [code=PlantByDivisionOperation] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-1ede8076 | cboOperationGroup.SelectedIndexChanged | SCP0061_ProductionPlanFix_JV.cs:1020 | if (dtPlantSiteByDivision.Rows.Count < 1) | UI_PROP | clbPlantSite.ALL_VIEW | false | 속성 ALL_VIEW 설정 |  |  |  |
| AC-4f0fdb73 | cboOperationGroup.SelectedIndexChanged | SCP0061_ProductionPlanFix_JV.cs:1021 | else of (dtPlantSiteByDivision.Rows.Count < 1) | UI_PROP | clbPlantSite.ALL_VIEW | true | 속성 ALL_VIEW 설정 |  |  |  |
| AC-615fc305 | cboOperationGroup.SelectedIndexChanged | SCP0061_ProductionPlanFix_JV.cs:1023 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantSiteByDivision, clbPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-925b2e02 | cboOperationGroup.SelectedIndexChanged | SCP0061_ProductionPlanFix_JV.cs:1030 | if (division.Substring(0, 2).Equals("EE")) ▸ if (pPlantSite == "") | FLAG | dtLine | Data_SCP.Common(Data_SCP.Type.LineProdPlanLine, false, "9999!!!!", pOperationGroup, pPlant… | 화면 필드/플래그 변경 |  |  |  |
| AC-dd1e5571 | cboOperationGroup.SelectedIndexChanged | SCP0061_ProductionPlanFix_JV.cs:1030 | if (division.Substring(0, 2).Equals("EE")) ▸ if (pPlantSite == "") | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.LineProdPlanLine, false, "9999!!!!", pOperationGroup, pPlantSite) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-967a4255 | cboOperationGroup.SelectedIndexChanged | SCP0061_ProductionPlanFix_JV.cs:1031 | if (division.Substring(0, 2).Equals("EE")) ▸ else of (pPlantSite == "") | FLAG | dtLine | Data_SCP.Common(Data_SCP.Type.LineProdPlanLine, false, division, pOperationGroup, pPlantSi… | 화면 필드/플래그 변경 |  |  |  |
| AC-bbaf7407 | cboOperationGroup.SelectedIndexChanged | SCP0061_ProductionPlanFix_JV.cs:1031 | if (division.Substring(0, 2).Equals("EE")) ▸ else of (pPlantSite == "") | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.LineProdPlanLine, false, division, pOperationGroup, pPlantSite) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c2e2f5be | cboOperationGroup.SelectedIndexChanged | SCP0061_ProductionPlanFix_JV.cs:1035 | else of (division.Substring(0, 2).Equals("EE")) ▸ if (pPlantSite == "") | FLAG | dtLine | Data_SCP.Common(Data_SCP.Type.LineByOperationAddOSP, false, "9999!!!!", "", "", "", pPlant… | 화면 필드/플래그 변경 |  |  |  |
| AC-af757602 | cboOperationGroup.SelectedIndexChanged | SCP0061_ProductionPlanFix_JV.cs:1035 | else of (division.Substring(0, 2).Equals("EE")) ▸ if (pPlantSite == "") | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.LineByOperationAddOSP, false, "9999!!!!", "", "", "", pPlantSite) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-a9cbb501 | cboOperationGroup.SelectedIndexChanged | SCP0061_ProductionPlanFix_JV.cs:1036 | else of (division.Substring(0, 2).Equals("EE")) ▸ else of (pPlantSite == "") | FLAG | dtLine | Data_SCP.Common(Data_SCP.Type.LineByOperationAddOSP, false, division, "", "", "", pPlantSi… | 화면 필드/플래그 변경 |  |  |  |
| AC-1af25b97 | cboOperationGroup.SelectedIndexChanged | SCP0061_ProductionPlanFix_JV.cs:1036 | else of (division.Substring(0, 2).Equals("EE")) ▸ else of (pPlantSite == "") | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.LineByOperationAddOSP, false, division, "", "", "", pPlantSite) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-054fc0a5 | cboOperationGroup.SelectedIndexChanged | SCP0061_ProductionPlanFix_JV.cs:1038 |  | LIST_REBIND | clsCtrl.setListBox | (dtLine, clbLine, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0061_ProductionPlanFix_JV.ClbPlantSite_SelectedIndexChanged

진입점: clbPlantSite.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a9745ab4 | clbPlantSite.SelectedIndexChanged | SCP0061_ProductionPlanFix_JV.cs:964 | if (division.Substring(0, 2).Equals("EE")) | FLAG | dtLine | Data_SCP.Common(Data_SCP.Type.LineProdPlanLine, false, division, pOperationGroup, pPlantSi… | 화면 필드/플래그 변경 |  |  |  |
| AC-54369cac | clbPlantSite.SelectedIndexChanged | SCP0061_ProductionPlanFix_JV.cs:964 | if (division.Substring(0, 2).Equals("EE")) | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.LineProdPlanLine, false, division, pOperationGroup, pPlantSiteID) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-2081f69e | clbPlantSite.SelectedIndexChanged | SCP0061_ProductionPlanFix_JV.cs:966 | else of (division.Substring(0, 2).Equals("EE")) | FLAG | dtLine | Data_SCP.Common(Data_SCP.Type.LineByOperationAddOSP, false, division, "", pFactoryID, pOpe… | 화면 필드/플래그 변경 |  |  |  |
| AC-4486807d | clbPlantSite.SelectedIndexChanged | SCP0061_ProductionPlanFix_JV.cs:966 | else of (division.Substring(0, 2).Equals("EE")) | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.LineByOperationAddOSP, false, division, "", pFactoryID, pOperationID, pPlan… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-78bd0fa9 | clbPlantSite.SelectedIndexChanged | SCP0061_ProductionPlanFix_JV.cs:970 |  | LIST_REBIND | clsCtrl.setListBox | (dtLine, clbLine, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0061_ProductionPlanFix_JV.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c25041c5 | this.Load | SCP0061_ProductionPlanFix_JV.cs:226 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 3, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-1a0866f4 | this.Load | SCP0061_ProductionPlanFix_JV.cs:227 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, 0) | 화면 필드/플래그 변경 |  |  |  |
| AC-fa498b48 | this.Load | SCP0061_ProductionPlanFix_JV.cs:229 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0061_ProductionPlanFix_JV.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6a236e89 | this.Load | SCP0061_ProductionPlanFix_JV.cs:180 |  | VALUE_SET | cboBucketType.ControlValues | BucketType.Daily | 컨트롤 값 설정 |  |  |  |
| AC-03fd07b3 | this.Load | SCP0061_ProductionPlanFix_JV.cs:181 |  | VALUE_SET | chkSum.Checked | false | 컨트롤 값 설정 |  |  |  |

## SCP0061_ProductionPlanFix_JV.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4032f860 | Dispose | SCP0061_ProductionPlanFix_JV.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0061_ProductionPlanFix_JV.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0255c167 | EditButton | SCP0061_ProductionPlanFix_JV.cs:458 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-35f2cc29 | EditButton | SCP0061_ProductionPlanFix_JV.cs:459 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0061_ProductionPlanFix_JV.FindButton

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-658e7be2 | FindButton | SCP0061_ProductionPlanFix_JV.cs:425 | if (checkPlantSite == 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00352") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3d27e11c | FindButton | SCP0061_ProductionPlanFix_JV.cs:426 | if (checkPlantSite == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-165f815a | FindButton | SCP0061_ProductionPlanFix_JV.cs:438 | if (strValue == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00352") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ec7eb6de | FindButton | SCP0061_ProductionPlanFix_JV.cs:439 | if (strValue == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0061_ProductionPlanFix_JV.FindData_Division

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cc437341 | this.Load | SCP0061_ProductionPlanFix_JV.cs:1771 |  | STATE | clbPlantSite.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-2ecdc01d | this.Load | SCP0061_ProductionPlanFix_JV.cs:1774 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SystemMgmt.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-faa4dcdf | this.Load | SCP0061_ProductionPlanFix_JV.cs:1778 | lambda | ENDPOINT | new FoxDataRequest | ("SystemManager.UP_FX_GetUserGroupAuthExtentionList") ⇒ SystemManager.UP_FX_GetUserGroupAuthExtentionList | 엔드포인트 요청 생성 |  |  |  |
| AC-fdd019db | this.Load | SCP0061_ProductionPlanFix_JV.cs:1780 | lambda | DATA_OP | request.Parameters["GroupID"] | "JV Planner" | 행/컬럼 값 대입 |  |  |  |
| AC-b20a9cb1 | this.Load | SCP0061_ProductionPlanFix_JV.cs:1781 | lambda | DATA_OP | request.Parameters["UserID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-7d5d9ab3 | this.Load | SCP0061_ProductionPlanFix_JV.cs:1782 | lambda | DATA_OP | request.Parameters["AuthType"] | "J" | 행/컬럼 값 대입 |  |  |  |
| AC-71c01f75 | this.Load | SCP0061_ProductionPlanFix_JV.cs:1783 | lambda | DATA_OP | request.Parameters["DivisionID"] | string.Empty | 행/컬럼 값 대입 |  |  |  |
| AC-012d72c0 | this.Load | SCP0061_ProductionPlanFix_JV.cs:1784 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-9f680f33 | this.Load | SCP0061_ProductionPlanFix_JV.cs:1786 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-10cb1172 | this.Load | SCP0061_ProductionPlanFix_JV.cs:1795 | for (i < ds.Tables[0].Rows.Count) | DATA_OP | dic_JV_Plant.Add | (Code, JV_PLANT_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-a6ddb91e | this.Load | SCP0061_ProductionPlanFix_JV.cs:1797 |  | STATE | clbPlantSite.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## SCP0061_ProductionPlanFix_JV.FindData_Main

진입점: btnUnfix.Click [if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S"))] / FindButton / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-913c701b | btnUnfix.Click [if (fps.Name == "spdMain") ▸ if (siMain != n… 외 2 | SCP0061_ProductionPlanFix_JV.cs:673 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-07136b41 | btnUnfix.Click [if (fps.Name == "spdMain") ▸ if (siMain != n… 외 2 | SCP0061_ProductionPlanFix_JV.cs:677 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-5f5b0f85 | btnUnfix.Click [if (fps.Name == "spdMain") ▸ if (siMain != n… 외 2 | SCP0061_ProductionPlanFix_JV.cs:677 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b9aaf328 | btnUnfix.Click [if (fps.Name == "spdMain") ▸ if (siMain != n… 외 2 | SCP0061_ProductionPlanFix_JV.cs:679 | try | VALIDATE | DateUtil.Check_PeriodDate_New | (drpPeriod, "1", "7") | 프레임워크 검증 |  |  |  |
| AC-76394316 | btnUnfix.Click [if (fps.Name == "spdMain") ▸ if (siMain != n… 외 2 | SCP0061_ProductionPlanFix_JV.cs:679 | try ▸ if (!DateUtil.Check_PeriodDate_New(drpPeriod, "1", "7")) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2fa5d6a9 | btnUnfix.Click [if (fps.Name == "spdMain") ▸ if (siMain != n… 외 2 | SCP0061_ProductionPlanFix_JV.cs:683 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-6799b172 | btnUnfix.Click [if (fps.Name == "spdMain") ▸ if (siMain != n… 외 2 | SCP0061_ProductionPlanFix_JV.cs:706 | try | UI_PROP | proxyPivot.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-e8e070ac | btnUnfix.Click [if (fps.Name == "spdMain") ▸ if (siMain != n… 외 2 | SCP0061_ProductionPlanFix_JV.cs:707 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, "GSCM.SCP.Analy… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-1c15aed5 | btnUnfix.Click [if (fps.Name == "spdMain") ▸ if (siMain != n… 외 2 | SCP0061_ProductionPlanFix_JV.cs:711 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0024_GET_PRODUCTION_PLAN_FIX") ⇒ SCP.SCP0024_GET_PRODUCTION_PLAN_FIX | 엔드포인트 요청 생성 |  |  |  |
| AC-96e95778 | btnUnfix.Click [if (fps.Name == "spdMain") ▸ if (siMain != n… 외 2 | SCP0061_ProductionPlanFix_JV.cs:712 | try ▸ lambda | UI_PROP | req.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-f75a8e9b | btnUnfix.Click [if (fps.Name == "spdMain") ▸ if (siMain != n… 외 2 | SCP0061_ProductionPlanFix_JV.cs:713 | try ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-858ae419 | btnUnfix.Click [if (fps.Name == "spdMain") ▸ if (siMain != n… 외 2 | SCP0061_ProductionPlanFix_JV.cs:714 | try ▸ lambda | DATA_OP | req.Parameters["p_operation_group"] | p_operation_group | 행/컬럼 값 대입 |  |  |  |
| AC-f8c15286 | btnUnfix.Click [if (fps.Name == "spdMain") ▸ if (siMain != n… 외 2 | SCP0061_ProductionPlanFix_JV.cs:715 | try ▸ lambda | DATA_OP | req.Parameters["p_scm_site_id"] | p_scm_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-b76f4a29 | btnUnfix.Click [if (fps.Name == "spdMain") ▸ if (siMain != n… 외 2 | SCP0061_ProductionPlanFix_JV.cs:716 | try ▸ lambda | DATA_OP | req.Parameters["p_line_id"] | p_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-0f95c91b | btnUnfix.Click [if (fps.Name == "spdMain") ▸ if (siMain != n… 외 2 | SCP0061_ProductionPlanFix_JV.cs:717 | try ▸ lambda | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-e7d8c935 | btnUnfix.Click [if (fps.Name == "spdMain") ▸ if (siMain != n… 외 2 | SCP0061_ProductionPlanFix_JV.cs:718 | try ▸ lambda | DATA_OP | req.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-8033db8f | btnUnfix.Click [if (fps.Name == "spdMain") ▸ if (siMain != n… 외 2 | SCP0061_ProductionPlanFix_JV.cs:719 | try ▸ lambda | DATA_OP | req.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-9c3060e2 | btnUnfix.Click [if (fps.Name == "spdMain") ▸ if (siMain != n… 외 2 | SCP0061_ProductionPlanFix_JV.cs:720 | try ▸ lambda | DATA_OP | req.Parameters["p_electrode_type"] | p_electrode_type | 행/컬럼 값 대입 |  |  |  |
| AC-7a04f2db | btnUnfix.Click [if (fps.Name == "spdMain") ▸ if (siMain != n… 외 2 | SCP0061_ProductionPlanFix_JV.cs:721 | try ▸ lambda | DATA_OP | req.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-ff66c4fa | btnUnfix.Click [if (fps.Name == "spdMain") ▸ if (siMain != n… 외 2 | SCP0061_ProductionPlanFix_JV.cs:722 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-33613ddb | btnUnfix.Click [if (fps.Name == "spdMain") ▸ if (siMain != n… 외 2 | SCP0061_ProductionPlanFix_JV.cs:723 | try ▸ lambda | RETURN | return res.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-2cba8d9e | btnUnfix.Click [if (fps.Name == "spdMain") ▸ if (siMain != n… 외 2 | SCP0061_ProductionPlanFix_JV.cs:730 | try | GRID_BIND | siMain.Query | (dsBinding) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-1bf19c33 | btnUnfix.Click [if (fps.Name == "spdMain") ▸ if (siMain != n… 외 2 | SCP0061_ProductionPlanFix_JV.cs:732 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-6c84482d | btnUnfix.Click [if (fps.Name == "spdMain") ▸ if (siMain != n… 외 2 | SCP0061_ProductionPlanFix_JV.cs:733 | try | UI_MISC | SetSearchCount | (dsBinding) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-dbcdd396 | btnUnfix.Click [if (fps.Name == "spdMain") ▸ if (siMain != n… 외 2 | SCP0061_ProductionPlanFix_JV.cs:745 | try ▸ for (iRow < siMain.ActiveSheet.RowCount) ▸ for (iCol < siMain.ActiveSheet.ColumnCount) | GRID_SET | siMain.ActiveSheet.Cells[iRow, iCol].HorizontalAlignment | CellHorizontalAlignment.Right | 그리드 속성/값 설정 |  |  |  |
| AC-03739336 | btnUnfix.Click [if (fps.Name == "spdMain") ▸ if (siMain != n… 외 2 | SCP0061_ProductionPlanFix_JV.cs:746 | try ▸ for (iRow < siMain.ActiveSheet.RowCount) ▸ for (iCol < siMain.ActiveSheet.ColumnCount) | GRID_SET | siMain.ActiveSheet.Cells[iRow, iCol].VerticalAlignment | CellVerticalAlignment.Center | 그리드 속성/값 설정 |  |  |  |
| AC-f2079321 | btnUnfix.Click [if (fps.Name == "spdMain") ▸ if (siMain != n… 외 2 | SCP0061_ProductionPlanFix_JV.cs:760 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-bf5acb31 | btnUnfix.Click [if (fps.Name == "spdMain") ▸ if (siMain != n… 외 2 | SCP0061_ProductionPlanFix_JV.cs:769 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0061_ProductionPlanFix_JV.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2548959c | this.Load | SCP0061_ProductionPlanFix_JV.cs:163 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0061_ProductionPlanFix_JV.GetBucketType

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-642ed917 | this.Load | SCP0061_ProductionPlanFix_JV.cs:572 |  | ENDPOINT | new FoxDataRequest | ("DM.DM0003_GET_BUCKET_TYPE_CODE") ⇒ DM.DM0003_GET_BUCKET_TYPE_CODE | 엔드포인트 요청 생성 |  |  |  |
| AC-66ff3c76 | this.Load | SCP0061_ProductionPlanFix_JV.cs:573 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-3b3b1110 | this.Load | SCP0061_ProductionPlanFix_JV.cs:576 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SCP0061_ProductionPlanFix_JV.GetDayRange

진입점: this.Load / this.btnW26.Click / this.btnW52.Click / this.btnWLast.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c59b72bb | this.Load 외 3 | SCP0061_ProductionPlanFix_JV.cs:1087 |  | CALL_EXT | DateUtil.GetDayRange | (cboDivision.ControlValues, cboBucketType.ControlValues, "", "12") | ⚠ 의미 확인 필요 |  |  |  |
| AC-1e169e3b | this.Load 외 3 | SCP0061_ProductionPlanFix_JV.cs:1089 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |
| AC-8a8f5e81 | this.Load 외 3 | SCP0061_ProductionPlanFix_JV.cs:1111 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCM0001_GET_SCP_DAY_PERIOD") ⇒ SCP.SCM0001_GET_SCP_DAY_PERIOD | 엔드포인트 요청 생성 |  |  |  |
| AC-6e9e2837 | this.Load 외 3 | SCP0061_ProductionPlanFix_JV.cs:1112 |  | DATA_OP | request.Parameters["p_from_date"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-31abb611 | this.Load 외 3 | SCP0061_ProductionPlanFix_JV.cs:1113 |  | DATA_OP | request.Parameters["p_offset_day"] | Convert.ToInt32(periodType) * 7 - 1 | 행/컬럼 값 대입 |  |  |  |
| AC-b3700837 | this.Load 외 3 | SCP0061_ProductionPlanFix_JV.cs:1114 |  | DATA_OP | request.Parameters["p_timezone"] | UserInfoContext.Current[UserInfoProperites.TimeZone] | 행/컬럼 값 대입 |  |  |  |
| AC-d3205cef | this.Load 외 3 | SCP0061_ProductionPlanFix_JV.cs:1115 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-87e6ccba | this.Load 외 3 | SCP0061_ProductionPlanFix_JV.cs:1117 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |

## SCP0061_ProductionPlanFix_JV.GetLastRange

진입점: this.Load / cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d8cb0e6f | this.Load 외 1 | SCP0061_ProductionPlanFix_JV.cs:1098 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCM0001_GET_SCP_DAILY_PLAN_PERIOD") ⇒ SCP.SCM0001_GET_SCP_DAILY_PLAN_PERIOD | 엔드포인트 요청 생성 |  |  |  |
| AC-d878484d | this.Load 외 1 | SCP0061_ProductionPlanFix_JV.cs:1099 |  | DATA_OP | request.Parameters["p_division_id"] | divisionId | 행/컬럼 값 대입 |  |  |  |
| AC-55fddeed | this.Load 외 1 | SCP0061_ProductionPlanFix_JV.cs:1100 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-350db16f | this.Load 외 1 | SCP0061_ProductionPlanFix_JV.cs:1102 |  | RETURN | return dailyPlanPeriod; |  | 처리 중단/반환 |  |  |  |

## SCP0061_ProductionPlanFix_JV.GetSpdTitle

진입점: this.Load / btnUnfix.Click [if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S")) ▸ try] / FindButton [try] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-be90ae05 | this.Load 외 3 | SCP0061_ProductionPlanFix_JV.cs:1062 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN") ⇒ SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | 엔드포인트 요청 생성 |  |  |  |
| AC-18be252f | this.Load 외 3 | SCP0061_ProductionPlanFix_JV.cs:1067 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | drpPeriod.Text1.Replace("-", "") | 행/컬럼 값 대입 |  |  |  |
| AC-3aed8fbc | this.Load 외 3 | SCP0061_ProductionPlanFix_JV.cs:1068 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | drpPeriod.Text2.Replace("-", "") | 행/컬럼 값 대입 |  |  |  |
| AC-bc410067 | this.Load 외 3 | SCP0061_ProductionPlanFix_JV.cs:1070 |  | FLAG | dsSpdTitle | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-05f4fb91 | this.Load 외 3 | SCP0061_ProductionPlanFix_JV.cs:1070 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SCP0061_ProductionPlanFix_JV.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-da59f279 | this.Load | SCP0061_ProductionPlanFix_JV.cs:187 |  | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtMain) | 데이터 객체 조작/조회 |  |  |  |
| AC-faa45e12 | this.Load | SCP0061_ProductionPlanFix_JV.cs:189 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-509cfb8c | this.Load | SCP0061_ProductionPlanFix_JV.cs:193 |  | LIST_REBIND | clsCtrl.setListBox | (dtMyDivision, cboDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-67a3c6b0 | this.Load | SCP0061_ProductionPlanFix_JV.cs:196 | if (dtMyDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-366813b4 | this.Load | SCP0061_ProductionPlanFix_JV.cs:202 |  | LIST_REBIND | clsCtrl.setListBox | (dtElectrodeType, cboElectrode, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-c951785a | this.Load | SCP0061_ProductionPlanFix_JV.cs:206 |  | VALUE_SET | drpPeriod.InitValue | GetDayRange(PeriodType.W52) | 컨트롤 값 설정 |  |  |  |
| AC-7cfd7e1c | this.Load | SCP0061_ProductionPlanFix_JV.cs:208 |  | FLAG | dtBucketType | GetBucketType() | 화면 필드/플래그 변경 |  |  |  |
| AC-0f41983f | this.Load | SCP0061_ProductionPlanFix_JV.cs:209 |  | LIST_REBIND | clsCtrl.setListBox | (dtBucketType, cboBucketType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-fe3e7a5f | this.Load | SCP0061_ProductionPlanFix_JV.cs:218 | if (dailyPlanPeriod == PeriodType.W52) | UI_PROP | layoutControlItem12.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-95586b5b | this.Load | SCP0061_ProductionPlanFix_JV.cs:221 |  | VALUE_SET | btnWLast.Text | "W" + dailyPlanPeriod | 컨트롤 값 설정 |  |  |  |

## SCP0061_ProductionPlanFix_JV.InitSpread

진입점: this.Load / btnUnfix.Click [if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S")) ▸ try] / FindButton [try] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4eed110b | this.Load 외 3 | SCP0061_ProductionPlanFix_JV.cs:242 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.InitSheet | (SpdSheet.shtMain) | 그리드 재구성/초기화 |  |  |  |
| AC-e3fec0a8 | this.Load 외 3 | SCP0061_ProductionPlanFix_JV.cs:244 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.SetSheetHeaderColumn | (spdInfo, 3) | 그리드 재구성/초기화 |  |  |  |
| AC-e00cd07c | this.Load 외 3 | SCP0061_ProductionPlanFix_JV.cs:249 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-48f97542 | this.Load 외 3 | SCP0061_ProductionPlanFix_JV.cs:250 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-18ab5a34 | this.Load 외 3 | SCP0061_ProductionPlanFix_JV.cs:254 | if (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (!division.Substring(0, 2).Equals("EE")) | GRID_SET | spdInfo.ActiveSheet.Columns[siMain.GetColumnIndex("ORIGIN_DIVISION_ID")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-b6ba4365 | this.Load 외 3 | SCP0061_ProductionPlanFix_JV.cs:255 | if (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (!division.Substring(0, 2).Equals("EE")) | GRID_SET | spdInfo.ActiveSheet.Columns[siMain.GetColumnIndex("ELECTRODE_TYPE")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-7605716e | this.Load 외 3 | SCP0061_ProductionPlanFix_JV.cs:259 | if (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (!division.Substring(0, 2).Equals("EE")) | GRID_SET | spdInfo.ActiveSheet.Columns[siMain.GetColumnIndex("ORIGIN_DIVISION_ID")].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-5bae84c5 | this.Load 외 3 | SCP0061_ProductionPlanFix_JV.cs:260 | if (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (!division.Substring(0, 2).Equals("EE")) | GRID_SET | spdInfo.ActiveSheet.Columns[siMain.GetColumnIndex("ELECTRODE_TYPE")].Visible | true | 그리드 속성/값 설정 |  |  |  |

## SCP0061_ProductionPlanFix_JV.InitSpreadDateColumn

진입점: this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] / btnUnfix.Click [if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S")) ▸ try ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / FindButton [try ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5f93223e | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 3 | SCP0061_ProductionPlanFix_JV.cs:334 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.AddTextColumn | (sColumnLabelname, sColumnName, FPMerge.None, 0, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8edf689b | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 3 | SCP0061_ProductionPlanFix_JV.cs:339 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.AddTextColumn | (sColumnLabelname, sColumnName, FPMerge.None, 70, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a992244a | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 3 | SCP0061_ProductionPlanFix_JV.cs:343 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) ▸ if (sDayCode == DefColumnsLabel.Saturday \|\| … | GRID_SET | spdInfo.Sheet().ColumnHeader.Cells[2, spdInfo.GetMaxColumnIndex()].ForeColor | sDayCode == DefColumnsLabel.Saturday ? Color.Blue : Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-37bd7976 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 3 | SCP0061_ProductionPlanFix_JV.cs:350 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6eab751d | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 3 | SCP0061_ProductionPlanFix_JV.cs:351 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-05719076 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 3 | SCP0061_ProductionPlanFix_JV.cs:356 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f3ca5c6f | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 3 | SCP0061_ProductionPlanFix_JV.cs:357 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 30, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a7840621 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 3 | SCP0061_ProductionPlanFix_JV.cs:365 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName != sSmallLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ca901817 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 3 | SCP0061_ProductionPlanFix_JV.cs:366 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName != sSmallLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-abf5bf8d | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 3 | SCP0061_ProductionPlanFix_JV.cs:376 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9eaaec9e | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 3 | SCP0061_ProductionPlanFix_JV.cs:377 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7b51ec57 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 3 | SCP0061_ProductionPlanFix_JV.cs:378 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-439c1c63 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 3 | SCP0061_ProductionPlanFix_JV.cs:379 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0061_ProductionPlanFix_JV.InitSpreadFixReason

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bf9f40a8 | (진입점 미연결) | SCP0061_ProductionPlanFix_JV.cs:918 | for (iRow < siMain.ActiveSheet.RowCount) ▸ for (iCol < siMain.ActiveSheet.ColumnCount) ▸ if (siMain.ActiveSheet.Columns[iCol].Tag.ToString()… | GRID_INIT | siMain.SetCellTypeText | (iRow, iCol) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-1c94d1bf | (진입점 미연결) | SCP0061_ProductionPlanFix_JV.cs:920 | for (iRow < siMain.ActiveSheet.RowCount) ▸ for (iCol < siMain.ActiveSheet.ColumnCount) ▸ if (siMain.ActiveSheet.Columns[iCol].Tag.ToString()… | DATA_OP | dtFixReason.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-81575fe1 | (진입점 미연결) | SCP0061_ProductionPlanFix_JV.cs:930 | for (iRow < siMain.ActiveSheet.RowCount) ▸ for (iCol < siMain.ActiveSheet.ColumnCount) ▸ if (siMain.ActiveSheet.Columns[iCol].Tag.ToString()… | GRID_SET | siMain.SetValue | (iRow, iCol, dr[DefColumns.FIX_REASON].ToString()) | 그리드 값 설정 |  |  |  |

## SCP0061_ProductionPlanFix_JV.SaveData

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ebe704dc | (진입점 미연결) | SCP0061_ProductionPlanFix_JV.cs:794 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-4d54e6b1 | (진입점 미연결) | SCP0061_ProductionPlanFix_JV.cs:794 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c752d7b2 | (진입점 미연결) | SCP0061_ProductionPlanFix_JV.cs:845 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("SCP.SCP0024_SAVE_PRODUCTION_PLAN_FIX") ⇒ SCP.SCP0024_SAVE_PRODUCTION_PLAN_FIX | 엔드포인트 요청 생성 |  |  |  |
| AC-866ee255 | (진입점 미연결) | SCP0061_ProductionPlanFix_JV.cs:850 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0) | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Analysis.WSL/FoxDataServi… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d3779aa8 | (진입점 미연결) | SCP0061_ProductionPlanFix_JV.cs:854 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-ef7245b2 | (진입점 미연결) | SCP0061_ProductionPlanFix_JV.cs:855 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-3a881be3 | (진입점 미연결) | SCP0061_ProductionPlanFix_JV.cs:856 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_operation_group"] | p_operation_group | 행/컬럼 값 대입 |  |  |  |
| AC-a46616f5 | (진입점 미연결) | SCP0061_ProductionPlanFix_JV.cs:857 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_scm_site_id"] | p_scm_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-250884f7 | (진입점 미연결) | SCP0061_ProductionPlanFix_JV.cs:858 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_line_id"] | p_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-a50649bd | (진입점 미연결) | SCP0061_ProductionPlanFix_JV.cs:859 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-77a21fc4 | (진입점 미연결) | SCP0061_ProductionPlanFix_JV.cs:860 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_operation_id"] | p_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-33c0f6f9 | (진입점 미연결) | SCP0061_ProductionPlanFix_JV.cs:861 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_measure"] | p_measure | 행/컬럼 값 대입 |  |  |  |
| AC-0c58cb12 | (진입점 미연결) | SCP0061_ProductionPlanFix_JV.cs:862 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_yyyymmdd"] | p_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-9acfb8f1 | (진입점 미연결) | SCP0061_ProductionPlanFix_JV.cs:863 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_qty"] | p_qty | 행/컬럼 값 대입 |  |  |  |
| AC-1ee4b59c | (진입점 미연결) | SCP0061_ProductionPlanFix_JV.cs:864 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_fix_reason"] | p_fix_reason | 행/컬럼 값 대입 |  |  |  |
| AC-73523104 | (진입점 미연결) | SCP0061_ProductionPlanFix_JV.cs:865 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_last_updated_by"] | p_last_updated_by | 행/컬럼 값 대입 |  |  |  |
| AC-64fbd867 | (진입점 미연결) | SCP0061_ProductionPlanFix_JV.cs:867 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0) ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-0988ef3a | (진입점 미연결) | SCP0061_ProductionPlanFix_JV.cs:867 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0) ▸ lambda | RETURN | return client.ExecuteDataSet(request); |  | 처리 중단/반환 |  |  |  |
| AC-769064a0 | (진입점 미연결) | SCP0061_ProductionPlanFix_JV.cs:876 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToSt… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { t.DataSet.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a8337e1e | (진입점 미연결) | SCP0061_ProductionPlanFix_JV.cs:885 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0) ▸ if (t.Success) ▸ else of (t.DataSet.Tables[0].Rows[0][0]… | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SCP0061_ProductionPlanFix_JV.SaveData_FixInfo

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d8e5fdcf | (진입점 미연결) | SCP0061_ProductionPlanFix_JV.cs:1482 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (siMain.ActiveSheet.Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-da3666e6 | (진입점 미연결) | SCP0061_ProductionPlanFix_JV.cs:1506 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (selCells.Length < 1) | MESSAGE | MessageHelper.GMessageBox | ("MSG00134", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-659cc593 | (진입점 미연결) | SCP0061_ProductionPlanFix_JV.cs:1507 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (selCells.Length < 1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-71fd9156 | (진입점 미연결) | SCP0061_ProductionPlanFix_JV.cs:1697 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | MESSAGE | MessageHelper.GMessageBox | ("MSG00016") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-843d16bd | (진입점 미연결) | SCP0061_ProductionPlanFix_JV.cs:1697 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (MessageHelper.GMe… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f8447550 | (진입점 미연결) | SCP0061_ProductionPlanFix_JV.cs:1705 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | ENDPOINT | new FoxDataRequest | ("SCP.SCP0024_SAVE_PRODUCTION_PLAN_FIX") ⇒ SCP.SCP0024_SAVE_PRODUCTION_PLAN_FIX | 엔드포인트 요청 생성 |  |  |  |
| AC-772b3dc3 | (진입점 미연결) | SCP0061_ProductionPlanFix_JV.cs:1707 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | UI_PROP | request.CommandTimeout | 60 * 15 | 속성 CommandTimeout 설정 |  |  |  |
| AC-ade732b7 | (진입점 미연결) | SCP0061_ProductionPlanFix_JV.cs:1709 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-5156bac7 | (진입점 미연결) | SCP0061_ProductionPlanFix_JV.cs:1710 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-42e41944 | (진입점 미연결) | SCP0061_ProductionPlanFix_JV.cs:1711 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_operation_group"] | p_operation_group | 행/컬럼 값 대입 |  |  |  |
| AC-61f15c51 | (진입점 미연결) | SCP0061_ProductionPlanFix_JV.cs:1712 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_scm_site_id"] | p_scm_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-555575dd | (진입점 미연결) | SCP0061_ProductionPlanFix_JV.cs:1713 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_line_id"] | p_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-af51dcb7 | (진입점 미연결) | SCP0061_ProductionPlanFix_JV.cs:1714 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-f83561dc | (진입점 미연결) | SCP0061_ProductionPlanFix_JV.cs:1715 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_operation_id"] | p_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-02294bba | (진입점 미연결) | SCP0061_ProductionPlanFix_JV.cs:1716 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_yyyymmdd"] | p_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-f2bf6823 | (진입점 미연결) | SCP0061_ProductionPlanFix_JV.cs:1717 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_qty"] | p_qty | 행/컬럼 값 대입 |  |  |  |
| AC-5aa3947a | (진입점 미연결) | SCP0061_ProductionPlanFix_JV.cs:1718 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_fix_reason"] | strReason | 행/컬럼 값 대입 |  |  |  |
| AC-d87c9df7 | (진입점 미연결) | SCP0061_ProductionPlanFix_JV.cs:1719 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_user_id"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-91ab665f | (진입점 미연결) | SCP0061_ProductionPlanFix_JV.cs:1720 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_origin_division_id"] | p_origin_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-51d2e3ed | (진입점 미연결) | SCP0061_ProductionPlanFix_JV.cs:1721 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_electrode_type"] | p_electrode_type | 행/컬럼 값 대입 |  |  |  |
| AC-b4f1261e | (진입점 미연결) | SCP0061_ProductionPlanFix_JV.cs:1722 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-fedaf61d | (진입점 미연결) | SCP0061_ProductionPlanFix_JV.cs:1724 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-ba36c62a | (진입점 미연결) | SCP0061_ProductionPlanFix_JV.cs:1729 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { response.DataSet.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2e61ba52 | (진입점 미연결) | SCP0061_ProductionPlanFix_JV.cs:1742 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ else of (response.Dat… | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2fa7c5e4 | (진입점 미연결) | SCP0061_ProductionPlanFix_JV.cs:1750 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-19d4536a | (진입점 미연결) | SCP0061_ProductionPlanFix_JV.cs:1761 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ else of (iCount > 0) ▸ if (strAction == "D") | MESSAGE | MessageHelper.GMessageBox | ("MSG00046", new object[] { null }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SCP0061_ProductionPlanFix_JV.SaveData_FixInfo_U

진입점: btnUnfix.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9e7b7b2a | btnUnfix.Click | SCP0061_ProductionPlanFix_JV.cs:1162 | if (fps.Name == "spdMain") | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-0cd2d5cf | btnUnfix.Click | SCP0061_ProductionPlanFix_JV.cs:1168 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (siMain.ActiveSheet.Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7070936e | btnUnfix.Click | SCP0061_ProductionPlanFix_JV.cs:1172 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dt.Columns.Add | ("A", typeof(char)) | 데이터 객체 조작/조회 |  |  |  |
| AC-fcc64a6c | btnUnfix.Click | SCP0061_ProductionPlanFix_JV.cs:1173 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dt.Columns.Add | ("p_active_flag") | 데이터 객체 조작/조회 |  |  |  |
| AC-646b3527 | btnUnfix.Click | SCP0061_ProductionPlanFix_JV.cs:1174 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dt.Columns.Add | ("p_division_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-56f3aca7 | btnUnfix.Click | SCP0061_ProductionPlanFix_JV.cs:1175 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dt.Columns.Add | ("p_plan_start_yyyymmdd") | 데이터 객체 조작/조회 |  |  |  |
| AC-88c91eb8 | btnUnfix.Click | SCP0061_ProductionPlanFix_JV.cs:1176 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dt.Columns.Add | ("p_plan_type") | 데이터 객체 조작/조회 |  |  |  |
| AC-d4ea7cea | btnUnfix.Click | SCP0061_ProductionPlanFix_JV.cs:1177 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dt.Columns.Add | ("p_seq") | 데이터 객체 조작/조회 |  |  |  |
| AC-f2615e29 | btnUnfix.Click | SCP0061_ProductionPlanFix_JV.cs:1178 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dt.Columns.Add | ("p_operation_group") | 데이터 객체 조작/조회 |  |  |  |
| AC-1d2075cc | btnUnfix.Click | SCP0061_ProductionPlanFix_JV.cs:1179 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dt.Columns.Add | ("p_scm_site_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-eddae917 | btnUnfix.Click | SCP0061_ProductionPlanFix_JV.cs:1180 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dt.Columns.Add | ("p_item_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-64e2f683 | btnUnfix.Click | SCP0061_ProductionPlanFix_JV.cs:1181 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dt.Columns.Add | ("p_line_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-1a384a8f | btnUnfix.Click | SCP0061_ProductionPlanFix_JV.cs:1182 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dt.Columns.Add | ("p_operation_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-8daf81de | btnUnfix.Click | SCP0061_ProductionPlanFix_JV.cs:1183 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dt.Columns.Add | ("p_measure") | 데이터 객체 조작/조회 |  |  |  |
| AC-1db5b3c9 | btnUnfix.Click | SCP0061_ProductionPlanFix_JV.cs:1184 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dt.Columns.Add | ("p_yyyymmdd") | 데이터 객체 조작/조회 |  |  |  |
| AC-340454c6 | btnUnfix.Click | SCP0061_ProductionPlanFix_JV.cs:1185 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dt.Columns.Add | ("p_qty") | 데이터 객체 조작/조회 |  |  |  |
| AC-5d9e4954 | btnUnfix.Click | SCP0061_ProductionPlanFix_JV.cs:1186 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dt.Columns.Add | ("p_fix_reason") | 데이터 객체 조작/조회 |  |  |  |
| AC-34db231d | btnUnfix.Click | SCP0061_ProductionPlanFix_JV.cs:1187 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dt.Columns.Add | ("p_user_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-7b83f530 | btnUnfix.Click | SCP0061_ProductionPlanFix_JV.cs:1188 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dt.Columns.Add | ("p_fix") | 데이터 객체 조작/조회 |  |  |  |
| AC-e8d2b471 | btnUnfix.Click | SCP0061_ProductionPlanFix_JV.cs:1189 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dt.Columns.Add | ("p_loc_flag") | 데이터 객체 조작/조회 |  |  |  |
| AC-63a73b56 | btnUnfix.Click | SCP0061_ProductionPlanFix_JV.cs:1190 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dt.Columns.Add | ("p_program_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-b3d63a66 | btnUnfix.Click | SCP0061_ProductionPlanFix_JV.cs:1191 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dt.Columns.Add | ("debug_mode") | 데이터 객체 조작/조회 |  |  |  |
| AC-79243f89 | btnUnfix.Click | SCP0061_ProductionPlanFix_JV.cs:1192 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dt.Columns.Add | ("p_origin_division_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-231d519b | btnUnfix.Click | SCP0061_ProductionPlanFix_JV.cs:1193 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dt.Columns.Add | ("p_electrode_type") | 데이터 객체 조작/조회 |  |  |  |
| AC-375976b3 | btnUnfix.Click | SCP0061_ProductionPlanFix_JV.cs:1194 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dt.Columns.Add | ("p_bucket_type") | 데이터 객체 조작/조회 |  |  |  |
| AC-26b3016a | btnUnfix.Click | SCP0061_ProductionPlanFix_JV.cs:1195 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dt.Columns.Add | ("p_from_yyyymmdd") | 데이터 객체 조작/조회 |  |  |  |
| AC-be9b0fec | btnUnfix.Click | SCP0061_ProductionPlanFix_JV.cs:1196 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dt.Columns.Add | ("p_to_yyyymmdd") | 데이터 객체 조작/조회 |  |  |  |
| AC-5e828ae0 | btnUnfix.Click | SCP0061_ProductionPlanFix_JV.cs:1198 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dsInput.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-b66916c1 | btnUnfix.Click | SCP0061_ProductionPlanFix_JV.cs:1223 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (selCells.Length < 1) | MESSAGE | MessageHelper.GMessageBox | ("MSG00134", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2ca1f07f | btnUnfix.Click | SCP0061_ProductionPlanFix_JV.cs:1224 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (selCells.Length < 1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3c939a45 | btnUnfix.Click | SCP0061_ProductionPlanFix_JV.cs:1228 | if (fps.Name == "spdMain") ▸ if (siMain != null) | MESSAGE | MessageHelper.GMessageBox | ("MSG00016") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b26fe6a2 | btnUnfix.Click | SCP0061_ProductionPlanFix_JV.cs:1228 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (MessageHelper.GMessageBox("MSG00016") != DialogResult.Yes) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8e0276b4 | btnUnfix.Click | SCP0061_ProductionPlanFix_JV.cs:1300 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dsInput.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-f8193975 | btnUnfix.Click | SCP0061_ProductionPlanFix_JV.cs:1301 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_active_flag"] | strAction | 행/컬럼 값 대입 |  |  |  |
| AC-d3554a01 | btnUnfix.Click | SCP0061_ProductionPlanFix_JV.cs:1302 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_division_id"] | str_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-1d697f93 | btnUnfix.Click | SCP0061_ProductionPlanFix_JV.cs:1303 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_operation_group"] | str_operation_group | 행/컬럼 값 대입 |  |  |  |
| AC-55d72db9 | btnUnfix.Click | SCP0061_ProductionPlanFix_JV.cs:1304 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_scm_site_id"] | str_scm_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-34eefa1e | btnUnfix.Click | SCP0061_ProductionPlanFix_JV.cs:1305 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_line_id"] | str_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-7b2f4cd6 | btnUnfix.Click | SCP0061_ProductionPlanFix_JV.cs:1306 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_item_id"] | str_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-5788db97 | btnUnfix.Click | SCP0061_ProductionPlanFix_JV.cs:1307 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_operation_id"] | str_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-b230ac9e | btnUnfix.Click | SCP0061_ProductionPlanFix_JV.cs:1308 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_yyyymmdd"] | strYYYYMMDD | 행/컬럼 값 대입 |  |  |  |
| AC-fb3564ee | btnUnfix.Click | SCP0061_ProductionPlanFix_JV.cs:1309 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_qty"] | siMain.GetValue(i, j).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e4b779ca | btnUnfix.Click | SCP0061_ProductionPlanFix_JV.cs:1310 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_fix_reason"] | strReason | 행/컬럼 값 대입 |  |  |  |
| AC-73bbcedf | btnUnfix.Click | SCP0061_ProductionPlanFix_JV.cs:1311 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_origin_division_id"] | str_origin_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-9b8fb1ae | btnUnfix.Click | SCP0061_ProductionPlanFix_JV.cs:1312 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_electrode_type"] | str_electrode_type | 행/컬럼 값 대입 |  |  |  |
| AC-379575d5 | btnUnfix.Click | SCP0061_ProductionPlanFix_JV.cs:1313 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-fd897e79 | btnUnfix.Click | SCP0061_ProductionPlanFix_JV.cs:1314 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dsInput.Tables[0].Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-76d258f4 | btnUnfix.Click | SCP0061_ProductionPlanFix_JV.cs:1350 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dsInput.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-4b9f0f8e | btnUnfix.Click | SCP0061_ProductionPlanFix_JV.cs:1351 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_active_flag"] | strAction | 행/컬럼 값 대입 |  |  |  |
| AC-e459b19a | btnUnfix.Click | SCP0061_ProductionPlanFix_JV.cs:1352 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_division_id"] | str_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-16a8e6dc | btnUnfix.Click | SCP0061_ProductionPlanFix_JV.cs:1353 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_operation_group"] | str_operation_group | 행/컬럼 값 대입 |  |  |  |
| AC-1afde27e | btnUnfix.Click | SCP0061_ProductionPlanFix_JV.cs:1354 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_scm_site_id"] | str_scm_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-a681ddb0 | btnUnfix.Click | SCP0061_ProductionPlanFix_JV.cs:1355 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_line_id"] | str_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-052b9136 | btnUnfix.Click | SCP0061_ProductionPlanFix_JV.cs:1356 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_item_id"] | str_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-51ad5d51 | btnUnfix.Click | SCP0061_ProductionPlanFix_JV.cs:1357 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_operation_id"] | str_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-28ede6ff | btnUnfix.Click | SCP0061_ProductionPlanFix_JV.cs:1358 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_yyyymmdd"] | strYYYYMMDD | 행/컬럼 값 대입 |  |  |  |
| AC-48399561 | btnUnfix.Click | SCP0061_ProductionPlanFix_JV.cs:1359 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_qty"] | siMain.GetValue(i, j + nDayCntOfWeek).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-dc2b60fd | btnUnfix.Click | SCP0061_ProductionPlanFix_JV.cs:1360 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_fix_reason"] | strReason | 행/컬럼 값 대입 |  |  |  |
| AC-897e8c80 | btnUnfix.Click | SCP0061_ProductionPlanFix_JV.cs:1361 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_origin_division_id"] | str_origin_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-2389cba1 | btnUnfix.Click | SCP0061_ProductionPlanFix_JV.cs:1362 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_electrode_type"] | str_electrode_type | 행/컬럼 값 대입 |  |  |  |
| AC-cbd40498 | btnUnfix.Click | SCP0061_ProductionPlanFix_JV.cs:1363 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-90c81e4d | btnUnfix.Click | SCP0061_ProductionPlanFix_JV.cs:1364 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dsInput.Tables[0].Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-cbe18346 | btnUnfix.Click | SCP0061_ProductionPlanFix_JV.cs:1384 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (iCount > 0) | DATA_OP | dsInput.Tables[0].AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-acd3a1e5 | btnUnfix.Click | SCP0061_ProductionPlanFix_JV.cs:1398 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (iCount > 0) ▸ try | CALL_EXT | sql.AddParameter | (SqlDbType.Structured, "@SCP0013", dsInput.Tables[0]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-bfdf2495 | btnUnfix.Click | SCP0061_ProductionPlanFix_JV.cs:1399 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (iCount > 0) ▸ try | ENDPOINT | sql.ExcuteProcedure | ("dbo.SCP0024_SAVE_PRODUCTION_PLAN_FIX_DATASET") ⇒ biz:AppService.GeneralRunProcedureCustomTable [procedure=dbo.SCP0024_SAVE_PRODUC… | 엔드포인트 호출 |  |  |  |
| AC-53e5fd8c | btnUnfix.Click | SCP0061_ProductionPlanFix_JV.cs:1402 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (iCount > 0) ▸ try | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-768c9f26 | btnUnfix.Click | SCP0061_ProductionPlanFix_JV.cs:1407 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["re… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { result.Rows[0]["result_cnt"].ToString() }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a07e9926 | btnUnfix.Click | SCP0061_ProductionPlanFix_JV.cs:1416 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (iCount > 0) ▸ try ▸ else of (result != null && result.Rows.Count > 0 && result.Rows[0… | MESSAGE | MessageHelper.GMessageBox | ("MSG00003", new object[] { ReErrorMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-cac9de03 | btnUnfix.Click | SCP0061_ProductionPlanFix_JV.cs:1425 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (iCount > 0) ▸ catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-10f2d335 | btnUnfix.Click | SCP0061_ProductionPlanFix_JV.cs:1426 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (iCount > 0) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1bff188e | btnUnfix.Click | SCP0061_ProductionPlanFix_JV.cs:1432 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (iCount > 0) ▸ finally ▸ if (!prgCloseF) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-077f14c5 | btnUnfix.Click | SCP0061_ProductionPlanFix_JV.cs:1442 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ else of (iCount > 0) ▸ if (strAction == "D") | MESSAGE | MessageHelper.GMessageBox | ("MSG00046", new object[] { null }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SCP0061_ProductionPlanFix_JV.SCM_SYS_LOG_BATCH

진입점: btnUnfix.Click [if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (iCount > 0) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4b4f85ed | btnUnfix.Click [if (fps.Name == "spdMain") ▸ if (siMain != n… | SCP0061_ProductionPlanFix_JV.cs:1458 | try | ENDPOINT | new FoxDataRequest | ("SCP.PR_SCM_SYS_LOG_BATCH") ⇒ SCP.PR_SCM_SYS_LOG_BATCH | 엔드포인트 요청 생성 |  |  |  |
| AC-eecb06c8 | btnUnfix.Click [if (fps.Name == "spdMain") ▸ if (siMain != n… | SCP0061_ProductionPlanFix_JV.cs:1459 | try | DATA_OP | request.Parameters["p_program_name"] | p_program_name | 행/컬럼 값 대입 |  |  |  |
| AC-68a0c133 | btnUnfix.Click [if (fps.Name == "spdMain") ▸ if (siMain != n… | SCP0061_ProductionPlanFix_JV.cs:1460 | try | DATA_OP | request.Parameters["p_log_type"] | p_log_type | 행/컬럼 값 대입 |  |  |  |
| AC-571fcd93 | btnUnfix.Click [if (fps.Name == "spdMain") ▸ if (siMain != n… | SCP0061_ProductionPlanFix_JV.cs:1461 | try | DATA_OP | request.Parameters["p_log_count"] | p_log_count | 행/컬럼 값 대입 |  |  |  |
| AC-869c6849 | btnUnfix.Click [if (fps.Name == "spdMain") ▸ if (siMain != n… | SCP0061_ProductionPlanFix_JV.cs:1462 | try | DATA_OP | request.Parameters["p_log_message"] | p_log_message | 행/컬럼 값 대입 |  |  |  |
| AC-828668eb | btnUnfix.Click [if (fps.Name == "spdMain") ▸ if (siMain != n… | SCP0061_ProductionPlanFix_JV.cs:1463 | try | DATA_OP | request.Parameters["p_description"] | p_description | 행/컬럼 값 대입 |  |  |  |
| AC-79ee872d | btnUnfix.Click [if (fps.Name == "spdMain") ▸ if (siMain != n… | SCP0061_ProductionPlanFix_JV.cs:1464 | try | DATA_OP | request.Parameters["p_event_date"] | DateTime.Now | 행/컬럼 값 대입 |  |  |  |
| AC-c97d57ae | btnUnfix.Click [if (fps.Name == "spdMain") ▸ if (siMain != n… | SCP0061_ProductionPlanFix_JV.cs:1466 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SCP0061_ProductionPlanFix_JV.SetChangedControl

진입점: this.Load / cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5142dbd1 | this.Load 외 1 | SCP0061_ProductionPlanFix_JV.cs:583 |  | LIST_CLEAR | clbPlantSite.Items.Clear | () | 목록 항목 비움 |  |  |  |
| AC-122ac28c | this.Load 외 1 | SCP0061_ProductionPlanFix_JV.cs:584 |  | UI_PROP | clbPlantSite.ALL_VIEW | false | 속성 ALL_VIEW 설정 |  |  |  |
| AC-923647c3 | this.Load 외 1 | SCP0061_ProductionPlanFix_JV.cs:590 | if (division.Substring(0, 2).Equals("EE")) | FLAG | dtOperationGroup | Data_SCP.Common(Data_SCP.Type.OperationGroupEE, false) | 화면 필드/플래그 변경 |  |  |  |
| AC-b500056d | this.Load 외 1 | SCP0061_ProductionPlanFix_JV.cs:590 | if (division.Substring(0, 2).Equals("EE")) | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.OperationGroupEE, false) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-b4078e66 | this.Load 외 1 | SCP0061_ProductionPlanFix_JV.cs:592 | else of (division.Substring(0, 2).Equals("EE")) | FLAG | dtOperationGroup | Data_SCP.Common(Data_SCP.Type.OperationGroup, false) | 화면 필드/플래그 변경 |  |  |  |
| AC-3c480872 | this.Load 외 1 | SCP0061_ProductionPlanFix_JV.cs:592 | else of (division.Substring(0, 2).Equals("EE")) | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.OperationGroup, false) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d5bc3458 | this.Load 외 1 | SCP0061_ProductionPlanFix_JV.cs:593 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperationGroup, cboOperationGroup, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-86da9f1e | this.Load 외 1 | SCP0061_ProductionPlanFix_JV.cs:602 | if (division.Substring(0, 2).Equals("EE")) | CALL_EXT | dic_JV_Plant.TryGetValue | (division, out get_JV_Value) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a08a0f23 | this.Load 외 1 | SCP0061_ProductionPlanFix_JV.cs:615 | if (division.Substring(0, 2).Equals("EE")) ▸ if (get_JV_Value != "") | FLAG | dtPlantSiteByDivision | Data_SCP.Common(Data_SCP.Type.PlantSiteProdPlan, false, division, pOperationGroup, "JV Pla… | 화면 필드/플래그 변경 |  |  |  |
| AC-582c3962 | this.Load 외 1 | SCP0061_ProductionPlanFix_JV.cs:615 | if (division.Substring(0, 2).Equals("EE")) ▸ if (get_JV_Value != "") | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.PlantSiteProdPlan, false, division, pOperationGroup, "JV Planner", get_JV_V… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-79ff1c3e | this.Load 외 1 | SCP0061_ProductionPlanFix_JV.cs:619 | if (division.Substring(0, 2).Equals("EE")) ▸ else of (get_JV_Value != "") | FLAG | dtPlantSiteByDivision | Data_SCP.Common(Data_SCP.Type.PlantSiteProdPlan, false, division, pOperationGroup, "JV Pla… | 화면 필드/플래그 변경 |  |  |  |
| AC-4a27f247 | this.Load 외 1 | SCP0061_ProductionPlanFix_JV.cs:619 | if (division.Substring(0, 2).Equals("EE")) ▸ else of (get_JV_Value != "") | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.PlantSiteProdPlan, false, division, pOperationGroup, "JV Planner", "9999!!!… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-70e396d9 | this.Load 외 1 | SCP0061_ProductionPlanFix_JV.cs:626 | else of (division.Substring(0, 2).Equals("EE")) | CALL_EXT | dic_JV_Plant.TryGetValue | (division, out get_JV_Value) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b6f365d8 | this.Load 외 1 | SCP0061_ProductionPlanFix_JV.cs:630 | else of (division.Substring(0, 2).Equals("EE")) ▸ if (get_JV_Value != "") | FLAG | dtPlantSiteByDivision | Data.Common(Data.Type.PlantByDivisionOperation, false, division, pOperationGroup, "JV Plan… ⇒ biz:CommonData.CommonDataList [code=PlantByDivisionOperation] | 화면 필드/플래그 변경 |  |  |  |
| AC-246ad791 | this.Load 외 1 | SCP0061_ProductionPlanFix_JV.cs:630 | else of (division.Substring(0, 2).Equals("EE")) ▸ if (get_JV_Value != "") | COMBO_DATA | Data.Common | (Data.Type.PlantByDivisionOperation, false, division, pOperationGroup, "JV Planner", get_J… ⇒ biz:CommonData.CommonDataList [code=PlantByDivisionOperation] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-635cb4c9 | this.Load 외 1 | SCP0061_ProductionPlanFix_JV.cs:634 | else of (division.Substring(0, 2).Equals("EE")) ▸ else of (get_JV_Value != "") | FLAG | dtPlantSiteByDivision | Data.Common(Data.Type.PlantByDivisionOperation, false, "9999!!!!", pOperationGroup, "JV Pl… ⇒ biz:CommonData.CommonDataList [code=PlantByDivisionOperation] | 화면 필드/플래그 변경 |  |  |  |
| AC-b66a7c98 | this.Load 외 1 | SCP0061_ProductionPlanFix_JV.cs:634 | else of (division.Substring(0, 2).Equals("EE")) ▸ else of (get_JV_Value != "") | COMBO_DATA | Data.Common | (Data.Type.PlantByDivisionOperation, false, "9999!!!!", pOperationGroup, "JV Planner", get… ⇒ biz:CommonData.CommonDataList [code=PlantByDivisionOperation] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e7a8b1f5 | this.Load 외 1 | SCP0061_ProductionPlanFix_JV.cs:638 | if (dtPlantSiteByDivision.Rows.Count < 1) | UI_PROP | clbPlantSite.ALL_VIEW | false | 속성 ALL_VIEW 설정 |  |  |  |
| AC-0543645e | this.Load 외 1 | SCP0061_ProductionPlanFix_JV.cs:639 | else of (dtPlantSiteByDivision.Rows.Count < 1) | UI_PROP | clbPlantSite.ALL_VIEW | true | 속성 ALL_VIEW 설정 |  |  |  |
| AC-4e28e1a8 | this.Load 외 1 | SCP0061_ProductionPlanFix_JV.cs:641 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantSiteByDivision, clbPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-61bb25eb | this.Load 외 1 | SCP0061_ProductionPlanFix_JV.cs:648 | if (division.Substring(0, 2).Equals("EE")) ▸ if (pPlantSite == "") | FLAG | dtLine | Data_SCP.Common(Data_SCP.Type.LineProdPlanLine, false, "9999!!!!", pOperationGroup, pPlant… | 화면 필드/플래그 변경 |  |  |  |
| AC-d5e655c9 | this.Load 외 1 | SCP0061_ProductionPlanFix_JV.cs:648 | if (division.Substring(0, 2).Equals("EE")) ▸ if (pPlantSite == "") | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.LineProdPlanLine, false, "9999!!!!", pOperationGroup, pPlantSite) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-cfa3d96a | this.Load 외 1 | SCP0061_ProductionPlanFix_JV.cs:649 | if (division.Substring(0, 2).Equals("EE")) ▸ else of (pPlantSite == "") | FLAG | dtLine | Data_SCP.Common(Data_SCP.Type.LineProdPlanLine, false, division, pOperationGroup, pPlantSi… | 화면 필드/플래그 변경 |  |  |  |
| AC-46aec961 | this.Load 외 1 | SCP0061_ProductionPlanFix_JV.cs:649 | if (division.Substring(0, 2).Equals("EE")) ▸ else of (pPlantSite == "") | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.LineProdPlanLine, false, division, pOperationGroup, pPlantSite) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-97edea08 | this.Load 외 1 | SCP0061_ProductionPlanFix_JV.cs:653 | else of (division.Substring(0, 2).Equals("EE")) ▸ if (pPlantSite == "") | FLAG | dtLine | Data_SCP.Common(Data_SCP.Type.LineByOperationAddOSP, false, "9999!!!!", "", "", "", pPlant… | 화면 필드/플래그 변경 |  |  |  |
| AC-5e5d63e8 | this.Load 외 1 | SCP0061_ProductionPlanFix_JV.cs:653 | else of (division.Substring(0, 2).Equals("EE")) ▸ if (pPlantSite == "") | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.LineByOperationAddOSP, false, "9999!!!!", "", "", "", pPlantSite) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-78630ca1 | this.Load 외 1 | SCP0061_ProductionPlanFix_JV.cs:654 | else of (division.Substring(0, 2).Equals("EE")) ▸ else of (pPlantSite == "") | FLAG | dtLine | Data_SCP.Common(Data_SCP.Type.LineByOperationAddOSP, false, division, "", "", "", pPlantSi… | 화면 필드/플래그 변경 |  |  |  |
| AC-cf2414dc | this.Load 외 1 | SCP0061_ProductionPlanFix_JV.cs:654 | else of (division.Substring(0, 2).Equals("EE")) ▸ else of (pPlantSite == "") | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.LineByOperationAddOSP, false, division, "", "", "", pPlantSite) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-0450f9d8 | this.Load 외 1 | SCP0061_ProductionPlanFix_JV.cs:658 |  | LIST_REBIND | clsCtrl.setListBox | (dtLine, clbLine, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-2e538055 | this.Load 외 1 | SCP0061_ProductionPlanFix_JV.cs:662 | if (!division.Substring(0, 2).Equals("EE")) | VALUE_CLEAR | cboElectrode.ControlValues | "" | 컨트롤 값 비움 |  |  |  |
| AC-39e0bd7c | this.Load 외 1 | SCP0061_ProductionPlanFix_JV.cs:663 | if (!division.Substring(0, 2).Equals("EE")) | STATE | cboElectrode.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-d136e6d5 | this.Load 외 1 | SCP0061_ProductionPlanFix_JV.cs:667 | else of (!division.Substring(0, 2).Equals("EE")) | STATE | cboElectrode.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## SCP0061_ProductionPlanFix_JV.SetSpreadColumn

진입점: this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] / this.cboBucketType.SelectedIndexChanged / this.chkSum.CheckedChanged / btnUnfix.Click [if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S")) ▸ try ▸ if (siMain.GetMaxRowIndex() > 0)] / FindButton [try ▸ if (siMain.GetMaxRowIndex() > 0)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0513c39d | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 5 | SCP0061_ProductionPlanFix_JV.cs:526 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siObj.GetColumnTag(iCol).IndexOf("D_") … | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-29d127ad | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 5 | SCP0061_ProductionPlanFix_JV.cs:531 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siObj.GetColumnTag(iCol).IndexOf("M_") … | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-5c979139 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 5 | SCP0061_ProductionPlanFix_JV.cs:538 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Buc… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-1accbe7b | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 5 | SCP0061_ProductionPlanFix_JV.cs:542 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Buc… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-a7f4a705 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 5 | SCP0061_ProductionPlanFix_JV.cs:547 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Buc… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-ae707ebb | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 5 | SCP0061_ProductionPlanFix_JV.cs:554 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboBucketType.ControlValues =… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-b4cf9f15 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 5 | SCP0061_ProductionPlanFix_JV.cs:558 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboBucketType.ControlValues =… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |

## SCP0061_ProductionPlanFix_JV.SpdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7ab836ec | this.spdMain.CellDoubleClick | SCP0061_ProductionPlanFix_JV.cs:1046 | if (e.ColumnHeader) | CALL_EXT | siMain.SetDblClickColumnShowHide | (sender, e) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c803899e | this.spdMain.CellDoubleClick | SCP0061_ProductionPlanFix_JV.cs:1051 | if (!e.ColumnHeader && e.Row >= 0) | FLAG | nSelRowOfMain | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-15c535d3 | this.spdMain.CellDoubleClick | SCP0061_ProductionPlanFix_JV.cs:1052 | if (!e.ColumnHeader && e.Row >= 0) | FLAG | nSelColOfMain | e.Column | 화면 필드/플래그 변경 |  |  |  |

## SCP0061_ProductionPlanFix_JV.SpdMain_TopChange

진입점: this.spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1fd00a98 | this.spdMain.TopChange | SCP0061_ProductionPlanFix_JV.cs:412 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

