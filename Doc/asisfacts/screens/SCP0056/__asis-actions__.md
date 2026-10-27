# AS-IS 액션 대조표 — SCP0056

> 원천: `Doc/asisfacts/screens/SCP0056/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 256행 · 메서드 30 · 종류 GRID_SET 88 · DATA_OP 38 · FLAG 29 · LIST_REBIND 22 · COMBO_DATA 20 · GRID_INIT 15 · RETURN 9 · UI_MISC 6 · GRID_LOCK 6 · ENDPOINT 6 · UI_PROP 5 · MESSAGE 4 · POPUP 3 · CALL_EXT 2 · STATE_RESET 1 · GRID_BIND 1 · VALIDATE 1 · ⚠ 의미 확인 필요 2


## SCP0056_MPP_Result_Mgmt.checkValidN0

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ae619e95 | (진입점 미연결) | SCP0056_MPP_Result_Mgmt.cs:1067 |  | RETURN | return isPass; |  | 처리 중단/반환 |  |  |  |

## SCP0056_MPP_Result_Mgmt.ClbBuilding_SelectedIndexChanged

진입점: clbBuilding.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cb405308 | clbBuilding.SelectedIndexChanged | SCP0056_MPP_Result_Mgmt.cs:341 |  | FLAG | dtLineByOperationPlantId | Data_SCP.Common(Data_SCP.Type.LineByOperationPlantId, false, division, pPlantID, pFactoryI… | 화면 필드/플래그 변경 |  |  |  |
| AC-94d2b238 | clbBuilding.SelectedIndexChanged | SCP0056_MPP_Result_Mgmt.cs:341 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.LineByOperationPlantId, false, division, pPlantID, pFactoryID, pGroupID) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-2bcb2322 | clbBuilding.SelectedIndexChanged | SCP0056_MPP_Result_Mgmt.cs:342 |  | LIST_REBIND | clsCtrl.setListBox | (dtLineByOperationPlantId, clbLine, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-51b85eb2 | clbBuilding.SelectedIndexChanged | SCP0056_MPP_Result_Mgmt.cs:346 |  | FLAG | dtOperationByLine | Data_SCP.Common(Data_SCP.Type.OperationForMPP, false) | 화면 필드/플래그 변경 |  |  |  |
| AC-4c60579f | clbBuilding.SelectedIndexChanged | SCP0056_MPP_Result_Mgmt.cs:346 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.OperationForMPP, false) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-5d61b32f | clbBuilding.SelectedIndexChanged | SCP0056_MPP_Result_Mgmt.cs:347 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperationByLine, clbOperation, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0056_MPP_Result_Mgmt.clbGroup_SelectedIndexChanged

진입점: clbGroup.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bf6c2453 | clbGroup.SelectedIndexChanged | SCP0056_MPP_Result_Mgmt.cs:1085 |  | FLAG | dtPlantByGroup | Data_SCP.Common(Data_SCP.Type.PlantByGroup, false, sDivisionID, pGroupID) | 화면 필드/플래그 변경 |  |  |  |
| AC-c5acc644 | clbGroup.SelectedIndexChanged | SCP0056_MPP_Result_Mgmt.cs:1085 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.PlantByGroup, false, sDivisionID, pGroupID) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-2ae09e8b | clbGroup.SelectedIndexChanged | SCP0056_MPP_Result_Mgmt.cs:1086 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantByGroup, clbPlant, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-7ddd45f9 | clbGroup.SelectedIndexChanged | SCP0056_MPP_Result_Mgmt.cs:1089 |  | FLAG | dtBuildingByPlantSite | Data_SCP.Common(Data_SCP.Type.BuildingByShopGroupId, false, sDivisionID, pPlantID, pGroupI… | 화면 필드/플래그 변경 |  |  |  |
| AC-287c8867 | clbGroup.SelectedIndexChanged | SCP0056_MPP_Result_Mgmt.cs:1089 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.BuildingByShopGroupId, false, sDivisionID, pPlantID, pGroupID) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c1f8f565 | clbGroup.SelectedIndexChanged | SCP0056_MPP_Result_Mgmt.cs:1090 |  | LIST_REBIND | clsCtrl.setListBox | (dtBuildingByPlantSite, clbBuilding, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-a13c84f0 | clbGroup.SelectedIndexChanged | SCP0056_MPP_Result_Mgmt.cs:1093 |  | FLAG | dtLineByOperationPlantId | Data_SCP.Common(Data_SCP.Type.LineByOperationPlantId, false, sDivisionID, pPlantID, pFacto… | 화면 필드/플래그 변경 |  |  |  |
| AC-524fad4c | clbGroup.SelectedIndexChanged | SCP0056_MPP_Result_Mgmt.cs:1093 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.LineByOperationPlantId, false, sDivisionID, pPlantID, pFactoryID, pGroupID) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-561a3cb0 | clbGroup.SelectedIndexChanged | SCP0056_MPP_Result_Mgmt.cs:1094 |  | LIST_REBIND | clsCtrl.setListBox | (dtLineByOperationPlantId, clbLine, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-fdf4a8b7 | clbGroup.SelectedIndexChanged | SCP0056_MPP_Result_Mgmt.cs:1097 |  | FLAG | dtOperationByLine | Data.Common(Data.Type.OperationByLine, false, sDivisionID, pPlantID, pFactoryID, pLineId, … ⇒ biz:CommonData.CommonDataList [code=OperationByLine] | 화면 필드/플래그 변경 |  |  |  |
| AC-e798d8c7 | clbGroup.SelectedIndexChanged | SCP0056_MPP_Result_Mgmt.cs:1097 |  | COMBO_DATA | Data.Common | (Data.Type.OperationByLine, false, sDivisionID, pPlantID, pFactoryID, pLineId, pGroupID) ⇒ biz:CommonData.CommonDataList [code=OperationByLine] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-a8bdfcd5 | clbGroup.SelectedIndexChanged | SCP0056_MPP_Result_Mgmt.cs:1099 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperationByLine, clbOperation, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0056_MPP_Result_Mgmt.clbItemExtraSpec_SelectedIndexChanged

진입점: clbItemExtraSpec.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-744beb8e | clbItemExtraSpec.SelectedIndexChanged | SCP0056_MPP_Result_Mgmt.cs:393 |  | FLAG | dtItemClass | Data_SCP.Common(Data_SCP.Type.ItemClass, false, sDivisionID, sPlantID, sOperationGroup, sO… | 화면 필드/플래그 변경 |  |  |  |
| AC-2dfb70e8 | clbItemExtraSpec.SelectedIndexChanged | SCP0056_MPP_Result_Mgmt.cs:393 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.ItemClass, false, sDivisionID, sPlantID, sOperationGroup, sOperation, sExtr… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-1b2163f1 | clbItemExtraSpec.SelectedIndexChanged | SCP0056_MPP_Result_Mgmt.cs:395 |  | LIST_REBIND | clsCtrl.setListBox | (dtCellTypeGr, cboCellTypeGr, false) | 목록 컨트롤 재구성 |  |  |  |

## SCP0056_MPP_Result_Mgmt.ClbLine_SelectedIndexChanged

진입점: clbLine.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bde3c411 | clbLine.SelectedIndexChanged | SCP0056_MPP_Result_Mgmt.cs:358 |  | FLAG | dtOperationByLine | Data.Common(Data.Type.OperationByLine, false, division, pPlantID, pFactoryID, pLineID, pGr… ⇒ biz:CommonData.CommonDataList [code=OperationByLine] | 화면 필드/플래그 변경 |  |  |  |
| AC-ee27d39d | clbLine.SelectedIndexChanged | SCP0056_MPP_Result_Mgmt.cs:358 |  | COMBO_DATA | Data.Common | (Data.Type.OperationByLine, false, division, pPlantID, pFactoryID, pLineID, pGroupID) ⇒ biz:CommonData.CommonDataList [code=OperationByLine] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-2dc96113 | clbLine.SelectedIndexChanged | SCP0056_MPP_Result_Mgmt.cs:360 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperationByLine, clbOperation, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0056_MPP_Result_Mgmt.clbOperation_SelectedIndexChanged

진입점: clbOperation.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9e3c83b5 | clbOperation.SelectedIndexChanged | SCP0056_MPP_Result_Mgmt.cs:373 |  | FLAG | dtItemExtraSpec | Data_SCP.Common(Data_SCP.Type.ItemExtraSpec, false, sDivisionID, sPlantID, sOperationGroup… | 화면 필드/플래그 변경 |  |  |  |
| AC-6ff6bfe0 | clbOperation.SelectedIndexChanged | SCP0056_MPP_Result_Mgmt.cs:373 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.ItemExtraSpec, false, sDivisionID, sPlantID, sOperationGroup, sOperation, n… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d06cb59f | clbOperation.SelectedIndexChanged | SCP0056_MPP_Result_Mgmt.cs:374 |  | LIST_REBIND | clsCtrl.setListBox | (dtItemExtraSpec, clbItemExtraSpec, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-029dfc8e | clbOperation.SelectedIndexChanged | SCP0056_MPP_Result_Mgmt.cs:377 |  | FLAG | dtItemClass | Data_SCP.Common(Data_SCP.Type.ItemClass, false, sDivisionID, sPlantID, sOperationGroup, sO… | 화면 필드/플래그 변경 |  |  |  |
| AC-cf2eaa6c | clbOperation.SelectedIndexChanged | SCP0056_MPP_Result_Mgmt.cs:377 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.ItemClass, false, sDivisionID, sPlantID, sOperationGroup, sOperation, sExtr… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-5057ea0e | clbOperation.SelectedIndexChanged | SCP0056_MPP_Result_Mgmt.cs:379 |  | LIST_REBIND | clsCtrl.setListBox | (dtCellTypeGr, cboCellTypeGr, false) | 목록 컨트롤 재구성 |  |  |  |

## SCP0056_MPP_Result_Mgmt.ClbPlantSite_SelectedIndexChanged

진입점: clbPlant.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-693bbda5 | clbPlant.SelectedIndexChanged | SCP0056_MPP_Result_Mgmt.cs:1108 |  | FLAG | dtBuildingByPlantSite | Data_SCP.Common(Data_SCP.Type.BuildingByShopGroupId, false, division, pPlantID, pGroupID) | 화면 필드/플래그 변경 |  |  |  |
| AC-a2e1817f | clbPlant.SelectedIndexChanged | SCP0056_MPP_Result_Mgmt.cs:1108 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.BuildingByShopGroupId, false, division, pPlantID, pGroupID) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-7dc7e119 | clbPlant.SelectedIndexChanged | SCP0056_MPP_Result_Mgmt.cs:1109 |  | LIST_REBIND | clsCtrl.setListBox | (dtBuildingByPlantSite, clbBuilding, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-151c51d6 | clbPlant.SelectedIndexChanged | SCP0056_MPP_Result_Mgmt.cs:1112 |  | FLAG | dtLineByOperationPlantId | Data_SCP.Common(Data_SCP.Type.LineByOperationPlantId, false, division, pPlantID, pFactoryI… | 화면 필드/플래그 변경 |  |  |  |
| AC-b7b64e41 | clbPlant.SelectedIndexChanged | SCP0056_MPP_Result_Mgmt.cs:1112 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.LineByOperationPlantId, false, division, pPlantID, pFactoryID, pGroupID) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c363f61b | clbPlant.SelectedIndexChanged | SCP0056_MPP_Result_Mgmt.cs:1113 |  | LIST_REBIND | clsCtrl.setListBox | (dtLineByOperationPlantId, clbLine, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-d77b7137 | clbPlant.SelectedIndexChanged | SCP0056_MPP_Result_Mgmt.cs:1117 |  | FLAG | dtOperationByLine | Data.Common(Data.Type.OperationByLine, false, division, pPlantID, pFactoryID, pLineId, pGr… ⇒ biz:CommonData.CommonDataList [code=OperationByLine] | 화면 필드/플래그 변경 |  |  |  |
| AC-556ed02f | clbPlant.SelectedIndexChanged | SCP0056_MPP_Result_Mgmt.cs:1117 |  | COMBO_DATA | Data.Common | (Data.Type.OperationByLine, false, division, pPlantID, pFactoryID, pLineId, pGroupID) ⇒ biz:CommonData.CommonDataList [code=OperationByLine] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-337382cd | clbPlant.SelectedIndexChanged | SCP0056_MPP_Result_Mgmt.cs:1119 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperationByLine, clbOperation, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0056_MPP_Result_Mgmt.ClearUsrCheckedList

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-772decde | (진입점 미연결) | SCP0056_MPP_Result_Mgmt.cs:206 | if (dt != null) | STATE_RESET | dt.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-9ee03ef1 | (진입점 미연결) | SCP0056_MPP_Result_Mgmt.cs:207 | if (dt != null) | LIST_REBIND | clsCtrl.setListBox | (dt, control, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0056_MPP_Result_Mgmt.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-43804850 | this.Load | SCP0056_MPP_Result_Mgmt.cs:269 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 2, 1, 50) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-3c812cb3 | this.Load | SCP0056_MPP_Result_Mgmt.cs:270 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-6fe00ede | this.Load | SCP0056_MPP_Result_Mgmt.cs:272 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b4350291 | this.Load | SCP0056_MPP_Result_Mgmt.cs:277 |  | GRID_INIT | siMain.SetReNumerCellType | (siMain, siMain.GetColumnIndex("RATIO"), -9999999999, 2) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0056_MPP_Result_Mgmt.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3c6aa2ff | DeleteButton | SCP0056_MPP_Result_Mgmt.cs:756 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0056_MPP_Result_Mgmt.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7b021e67 | Dispose | SCP0056_MPP_Result_Mgmt.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0056_MPP_Result_Mgmt.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-de28b6a5 | EditButton | SCP0056_MPP_Result_Mgmt.cs:688 | if (fps != null) ▸ if (RdoCellCheck.Checked) | POPUP | FoxMessageBox.Show | ("Cell이 선택된 상태에서 차질사유 입력이 불가능 합니다.") | 팝업/폼 열기 |  |  |  |
| AC-d0ad9020 | EditButton | SCP0056_MPP_Result_Mgmt.cs:689 | if (fps != null) ▸ if (RdoCellCheck.Checked) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c8319bdd | EditButton | SCP0056_MPP_Result_Mgmt.cs:730 | if (fps != null) ▸ if (fps.Name == "spdMain" && spdMain.ActiveSheetIndex == 0) | UI_PROP | rtb.Multiline | true | 속성 Multiline 설정 |  |  |  |
| AC-ffc137bf | EditButton | SCP0056_MPP_Result_Mgmt.cs:731 | if (fps != null) ▸ if (fps.Name == "spdMain" && spdMain.ActiveSheetIndex == 0) | UI_PROP | rtb.WordWrap | true | 속성 WordWrap 설정 |  |  |  |
| AC-f9e03448 | EditButton | SCP0056_MPP_Result_Mgmt.cs:733 | if (fps != null) ▸ if (fps.Name == "spdMain" && spdMain.ActiveSheetIndex == 0) | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-2663e9a8 | EditButton | SCP0056_MPP_Result_Mgmt.cs:734 | if (fps != null) ▸ if (fps.Name == "spdMain" && spdMain.ActiveSheetIndex == 0) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-e586a1ba | EditButton | SCP0056_MPP_Result_Mgmt.cs:736 | if (fps != null) ▸ if (fps.Name == "spdMain" && spdMain.ActiveSheetIndex == 0) | GRID_LOCK | siMain.LockColumn | (iColIdx_GROUP, iColIdx_RATIO, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-1866ade4 | EditButton | SCP0056_MPP_Result_Mgmt.cs:737 | if (fps != null) ▸ if (fps.Name == "spdMain" && spdMain.ActiveSheetIndex == 0) | GRID_LOCK | siMain.LockColumn | (iColIdx_PRODUCT_OVER, iColIdx_PRODUCT_OVER, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-044422dd | EditButton | SCP0056_MPP_Result_Mgmt.cs:738 | if (fps != null) ▸ if (fps.Name == "spdMain" && spdMain.ActiveSheetIndex == 0) | GRID_LOCK | siMain.LockColumn | (iColIdx_PRODUCT_OVER_CELL, iColIdx_PRODUCT_OVER_CELL, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-2da16668 | EditButton | SCP0056_MPP_Result_Mgmt.cs:746 | if (fps != null) ▸ if (fps.Name == "spdMain" && spdMain.ActiveSheetIndex == 0) ▸ for (i < svMain.RowCount) ▸ if (svMain.Rows[i].BackColor !=… | GRID_LOCK | siMain.LockRange | (i, iColIdx_DEMAND, i, iColIdx_NOTE3, true) | 그리드 편집 잠금/해제 |  |  |  |

## SCP0056_MPP_Result_Mgmt.FindData_Main

진입점: FindButton [if (siMain.ActiveSheet != null)] / SaveButton [if (fps.Name == "spdMain" && spdMain.ActiveSheetIndex == 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-10f89050 | FindButton [if (siMain.ActiveSheet != null)] 외 1 | SCP0056_MPP_Result_Mgmt.cs:849 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-d905abcb | FindButton [if (siMain.ActiveSheet != null)] 외 1 | SCP0056_MPP_Result_Mgmt.cs:853 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-b4990a8c | FindButton [if (siMain.ActiveSheet != null)] 외 1 | SCP0056_MPP_Result_Mgmt.cs:855 | try | CALL_EXT | FoxUserInfoContext.CreateScope | (new FoxUserInfoContext(p_user_id.ToString())) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4f341888 | FindButton [if (siMain.ActiveSheet != null)] 외 1 | SCP0056_MPP_Result_Mgmt.cs:871 | try ▸ if (p_sort_condition.Length > 0) ▸ if (sEnd == ',') | DATA_OP | p_sort_condition.Remove | (p_sort_condition.Length - 1, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-9118c207 | FindButton [if (siMain.ActiveSheet != null)] 외 1 | SCP0056_MPP_Result_Mgmt.cs:874 | try | ENDPOINT | new FoxDataRequest | ("SCP.SCP0056_GET_MPP") ⇒ SCP.SCP0056_GET_MPP | 엔드포인트 요청 생성 |  |  |  |
| AC-9e266a28 | FindButton [if (siMain.ActiveSheet != null)] 외 1 | SCP0056_MPP_Result_Mgmt.cs:876 | try | UI_PROP | req.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-0ec2efab | FindButton [if (siMain.ActiveSheet != null)] 외 1 | SCP0056_MPP_Result_Mgmt.cs:878 | try | DATA_OP | req.Parameters["P_DIVISION_ID"] | division | 행/컬럼 값 대입 |  |  |  |
| AC-7a238ad0 | FindButton [if (siMain.ActiveSheet != null)] 외 1 | SCP0056_MPP_Result_Mgmt.cs:879 | try | DATA_OP | req.Parameters["P_BIZ_TYPE"] | p_cell_type_group | 행/컬럼 값 대입 |  |  |  |
| AC-4a63a9f4 | FindButton [if (siMain.ActiveSheet != null)] 외 1 | SCP0056_MPP_Result_Mgmt.cs:880 | try | DATA_OP | req.Parameters["P_PLANT_SITE"] | p_Plant_Site | 행/컬럼 값 대입 |  |  |  |
| AC-c20b50ee | FindButton [if (siMain.ActiveSheet != null)] 외 1 | SCP0056_MPP_Result_Mgmt.cs:881 | try | DATA_OP | req.Parameters["P_BUILDING"] | p_Building | 행/컬럼 값 대입 |  |  |  |
| AC-eb6c6c7f | FindButton [if (siMain.ActiveSheet != null)] 외 1 | SCP0056_MPP_Result_Mgmt.cs:882 | try | DATA_OP | req.Parameters["P_LINE_ID"] | p_Line | 행/컬럼 값 대입 |  |  |  |
| AC-9b8d4ef8 | FindButton [if (siMain.ActiveSheet != null)] 외 1 | SCP0056_MPP_Result_Mgmt.cs:883 | try | DATA_OP | req.Parameters["P_OPERATION_ID"] | p_Operation | 행/컬럼 값 대입 |  |  |  |
| AC-ae5771c0 | FindButton [if (siMain.ActiveSheet != null)] 외 1 | SCP0056_MPP_Result_Mgmt.cs:884 | try | DATA_OP | req.Parameters["P_ITEM_ID"] | txtMaterial.Text | 행/컬럼 값 대입 |  |  |  |
| AC-a347e657 | FindButton [if (siMain.ActiveSheet != null)] 외 1 | SCP0056_MPP_Result_Mgmt.cs:885 | try | DATA_OP | req.Parameters["P_EXTRASPEC"] | p_ExtraSpec | 행/컬럼 값 대입 |  |  |  |
| AC-5cffcf41 | FindButton [if (siMain.ActiveSheet != null)] 외 1 | SCP0056_MPP_Result_Mgmt.cs:886 | try | DATA_OP | req.Parameters["P_ITEMCLASS"] | p_ItemClass | 행/컬럼 값 대입 |  |  |  |
| AC-cf08b5cb | FindButton [if (siMain.ActiveSheet != null)] 외 1 | SCP0056_MPP_Result_Mgmt.cs:887 | try | DATA_OP | req.Parameters["P_PROJECT"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-0c427066 | FindButton [if (siMain.ActiveSheet != null)] 외 1 | SCP0056_MPP_Result_Mgmt.cs:888 | try | DATA_OP | req.Parameters["P_NICKNAME"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-ba02f90d | FindButton [if (siMain.ActiveSheet != null)] 외 1 | SCP0056_MPP_Result_Mgmt.cs:889 | try | DATA_OP | req.Parameters["P_FROM_YYYYMMDD"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-4dba5c9c | FindButton [if (siMain.ActiveSheet != null)] 외 1 | SCP0056_MPP_Result_Mgmt.cs:890 | try | DATA_OP | req.Parameters["P_TO_YYYYMMDD"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-7ad30930 | FindButton [if (siMain.ActiveSheet != null)] 외 1 | SCP0056_MPP_Result_Mgmt.cs:891 | try | DATA_OP | req.Parameters["P_SORT_CONDITION"] | p_sort_condition | 행/컬럼 값 대입 |  |  |  |
| AC-80698279 | FindButton [if (siMain.ActiveSheet != null)] 외 1 | SCP0056_MPP_Result_Mgmt.cs:892 | try | DATA_OP | req.Parameters["P_PROGRAM_ID"] | "SCP0056" | 행/컬럼 값 대입 |  |  |  |
| AC-f6d32798 | FindButton [if (siMain.ActiveSheet != null)] 외 1 | SCP0056_MPP_Result_Mgmt.cs:893 | try | DATA_OP | req.Parameters["P_SHEET_NAME"] | p_sheet_name | 행/컬럼 값 대입 |  |  |  |
| AC-521cd5b0 | FindButton [if (siMain.ActiveSheet != null)] 외 1 | SCP0056_MPP_Result_Mgmt.cs:894 | try | DATA_OP | req.Parameters["P_USER_ID"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-2990d8ef | FindButton [if (siMain.ActiveSheet != null)] 외 1 | SCP0056_MPP_Result_Mgmt.cs:895 | try | DATA_OP | req.Parameters["DEBUG_MODE"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-9e3f4931 | FindButton [if (siMain.ActiveSheet != null)] 외 1 | SCP0056_MPP_Result_Mgmt.cs:897 | try | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-844a3598 | FindButton [if (siMain.ActiveSheet != null)] 외 1 | SCP0056_MPP_Result_Mgmt.cs:906 | try | GRID_BIND | siMain.Query | (dsResult) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-3d33d111 | FindButton [if (siMain.ActiveSheet != null)] 외 1 | SCP0056_MPP_Result_Mgmt.cs:909 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-8094534d | FindButton [if (siMain.ActiveSheet != null)] 외 1 | SCP0056_MPP_Result_Mgmt.cs:910 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-069aa4b7 | FindButton [if (siMain.ActiveSheet != null)] 외 1 | SCP0056_MPP_Result_Mgmt.cs:919 | try ▸ for (i < ViewCount) ▸ if (compare.Length == 7) | GRID_SET | svView.Rows[i].BackColor | cColor_Month | 그리드 속성/값 설정 |  |  |  |
| AC-3fe86a9d | FindButton [if (siMain.ActiveSheet != null)] 외 1 | SCP0056_MPP_Result_Mgmt.cs:923 | try ▸ for (i < ViewCount) ▸ else of (compare.Length == 7) ▸ if (compare.Length>7 && compare.Length < 10) | GRID_SET | svView.Rows[i].BackColor | cColor_Week | 그리드 속성/값 설정 |  |  |  |
| AC-a8fa9ddf | FindButton [if (siMain.ActiveSheet != null)] 외 1 | SCP0056_MPP_Result_Mgmt.cs:927 | try | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-99734afb | FindButton [if (siMain.ActiveSheet != null)] 외 1 | SCP0056_MPP_Result_Mgmt.cs:932 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-d2692aa0 | FindButton [if (siMain.ActiveSheet != null)] 외 1 | SCP0056_MPP_Result_Mgmt.cs:934 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1f37b7dc | FindButton [if (siMain.ActiveSheet != null)] 외 1 | SCP0056_MPP_Result_Mgmt.cs:938 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-19124e4b | FindButton [if (siMain.ActiveSheet != null)] 외 1 | SCP0056_MPP_Result_Mgmt.cs:939 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SCP0056_MPP_Result_Mgmt.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-211ed4f2 | this.Load | SCP0056_MPP_Result_Mgmt.cs:151 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0056_MPP_Result_Mgmt.GetBucketType

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9299ea85 | (진입점 미연결) | SCP0056_MPP_Result_Mgmt.cs:261 |  | ENDPOINT | new FoxDataRequest | ("DM.DM0003_GET_BUCKET_TYPE_CODE") ⇒ DM.DM0003_GET_BUCKET_TYPE_CODE | 엔드포인트 요청 생성 |  |  |  |
| AC-fc3ecec2 | (진입점 미연결) | SCP0056_MPP_Result_Mgmt.cs:262 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-6b8c4e63 | (진입점 미연결) | SCP0056_MPP_Result_Mgmt.cs:264 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SCP0056_MPP_Result_Mgmt.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4e5c4da9 | this.Load | SCP0056_MPP_Result_Mgmt.cs:170 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-fdfcdd44 | this.Load | SCP0056_MPP_Result_Mgmt.cs:173 | if (dtMyDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-8d0d72b5 | this.Load | SCP0056_MPP_Result_Mgmt.cs:175 |  | LIST_REBIND | clsCtrl.setListBox | (dtMyDivision, cboDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-81218712 | this.Load | SCP0056_MPP_Result_Mgmt.cs:177 |  | UI_PROP | dCalendar.Value1 | DateTime.Now.AddMonths(-1) | 속성 Value1 설정 |  |  |  |
| AC-7bc79b45 | this.Load | SCP0056_MPP_Result_Mgmt.cs:178 |  | UI_PROP | dCalendar.Value2 | DateTime.Now.AddMonths(1) | 속성 Value2 설정 |  |  |  |

## SCP0056_MPP_Result_Mgmt.InitSpread

진입점: this.Load / FindButton [if (siMain.ActiveSheet != null)] / SaveButton [if (fps.Name == "spdMain" && spdMain.ActiveSheetIndex == 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-500ca6e7 | this.Load 외 2 | SCP0056_MPP_Result_Mgmt.cs:283 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-187c5880 | this.Load 외 2 | SCP0056_MPP_Result_Mgmt.cs:284 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0056_MPP_Result_Mgmt.InitSpreadDateColumn

진입점: this.Load / FindButton [if (siMain.ActiveSheet != null)] / SaveButton [if (fps.Name == "spdMain" && spdMain.ActiveSheetIndex == 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c1d1e320 | this.Load 외 2 | SCP0056_MPP_Result_Mgmt.cs:294 |  | GRID_INIT | spdInfo.SetSheetHeaderColumn | (spdInfo, 2) | 그리드 재구성/초기화 |  |  |  |

## SCP0056_MPP_Result_Mgmt.InsertButton

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4456ac51 | InsertButton | SCP0056_MPP_Result_Mgmt.cs:763 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0056_MPP_Result_Mgmt.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c4d4182f | SaveButton | SCP0056_MPP_Result_Mgmt.cs:536 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-47f28b36 | SaveButton | SCP0056_MPP_Result_Mgmt.cs:638 | if (fps.Name == "spdMain" && spdMain.ActiveSheetIndex == 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ try | ENDPOINT | new FoxDataRequest | ("SCP.SCP0056_SET_MPP_NOTE") ⇒ SCP.SCP0056_SET_MPP_NOTE | 엔드포인트 요청 생성 |  |  |  |
| AC-d744b5c8 | SaveButton | SCP0056_MPP_Result_Mgmt.cs:640 | if (fps.Name == "spdMain" && spdMain.ActiveSheetIndex == 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ try | DATA_OP | request.Parameters["P_DIVISION_ID"] | sDIVISION_ID | 행/컬럼 값 대입 |  |  |  |
| AC-7eef415c | SaveButton | SCP0056_MPP_Result_Mgmt.cs:641 | if (fps.Name == "spdMain" && spdMain.ActiveSheetIndex == 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ try | DATA_OP | request.Parameters["P_SITE_ID"] | sSITE_ID | 행/컬럼 값 대입 |  |  |  |
| AC-efe2c2eb | SaveButton | SCP0056_MPP_Result_Mgmt.cs:642 | if (fps.Name == "spdMain" && spdMain.ActiveSheetIndex == 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ try | DATA_OP | request.Parameters["P_OPERATION_ID"] | sOPERATION_ID | 행/컬럼 값 대입 |  |  |  |
| AC-ed484afb | SaveButton | SCP0056_MPP_Result_Mgmt.cs:643 | if (fps.Name == "spdMain" && spdMain.ActiveSheetIndex == 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ try | DATA_OP | request.Parameters["P_LINE_ID"] | sLINE_ID | 행/컬럼 값 대입 |  |  |  |
| AC-356ce1f7 | SaveButton | SCP0056_MPP_Result_Mgmt.cs:644 | if (fps.Name == "spdMain" && spdMain.ActiveSheetIndex == 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ try | DATA_OP | request.Parameters["P_BASIC_CODE"] | sBASIC_CODE | 행/컬럼 값 대입 |  |  |  |
| AC-a290c884 | SaveButton | SCP0056_MPP_Result_Mgmt.cs:645 | if (fps.Name == "spdMain" && spdMain.ActiveSheetIndex == 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ try | DATA_OP | request.Parameters["P_PLAN_DATE"] | sPLAN_DATE | 행/컬럼 값 대입 |  |  |  |
| AC-605a21c2 | SaveButton | SCP0056_MPP_Result_Mgmt.cs:646 | if (fps.Name == "spdMain" && spdMain.ActiveSheetIndex == 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ try | DATA_OP | request.Parameters["P_DEMAND"] | (String.IsNullOrEmpty(sDEMAND)) ? "0" : sDEMAND | 행/컬럼 값 대입 |  |  |  |
| AC-98a4a2a6 | SaveButton | SCP0056_MPP_Result_Mgmt.cs:647 | if (fps.Name == "spdMain" && spdMain.ActiveSheetIndex == 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ try | DATA_OP | request.Parameters["P_PRODUCT_MOD"] | (String.IsNullOrEmpty(sPRODUCT_MOD)) ? "0" : sPRODUCT_MOD | 행/컬럼 값 대입 |  |  |  |
| AC-3b58b333 | SaveButton | SCP0056_MPP_Result_Mgmt.cs:648 | if (fps.Name == "spdMain" && spdMain.ActiveSheetIndex == 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ try | DATA_OP | request.Parameters["P_PRODUCT_SETBACK"] | (String.IsNullOrEmpty(sPRODUCT_SETBACK)) ? "0" : sPRODUCT_SETBACK | 행/컬럼 값 대입 |  |  |  |
| AC-6212837f | SaveButton | SCP0056_MPP_Result_Mgmt.cs:649 | if (fps.Name == "spdMain" && spdMain.ActiveSheetIndex == 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ try | DATA_OP | request.Parameters["P_SEMI_PRODUCT"] | (String.IsNullOrEmpty(sSEMI_PRODUCT)) ? "0" : sSEMI_PRODUCT | 행/컬럼 값 대입 |  |  |  |
| AC-0816600f | SaveButton | SCP0056_MPP_Result_Mgmt.cs:650 | if (fps.Name == "spdMain" && spdMain.ActiveSheetIndex == 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ try | DATA_OP | request.Parameters["P_MATERIAL"] | (String.IsNullOrEmpty(sMATERIAL)) ? "0" : sMATERIAL | 행/컬럼 값 대입 |  |  |  |
| AC-cd37417c | SaveButton | SCP0056_MPP_Result_Mgmt.cs:651 | if (fps.Name == "spdMain" && spdMain.ActiveSheetIndex == 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ try | DATA_OP | request.Parameters["P_ETC_REASON"] | (String.IsNullOrEmpty(sETC_REASON)) ? "0" : sETC_REASON | 행/컬럼 값 대입 |  |  |  |
| AC-f15cad93 | SaveButton | SCP0056_MPP_Result_Mgmt.cs:652 | if (fps.Name == "spdMain" && spdMain.ActiveSheetIndex == 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ try | DATA_OP | request.Parameters["P_PRODUCT_OVER"] | (String.IsNullOrEmpty(sPRODUCT_OVER)) ? "0" : sPRODUCT_OVER | 행/컬럼 값 대입 |  |  |  |
| AC-45e9723d | SaveButton | SCP0056_MPP_Result_Mgmt.cs:653 | if (fps.Name == "spdMain" && spdMain.ActiveSheetIndex == 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ try | DATA_OP | request.Parameters["P_NOTE1"] | sNOTE1 | 행/컬럼 값 대입 |  |  |  |
| AC-359c8aa3 | SaveButton | SCP0056_MPP_Result_Mgmt.cs:654 | if (fps.Name == "spdMain" && spdMain.ActiveSheetIndex == 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ try | DATA_OP | request.Parameters["P_NOTE2"] | sNOTE2 | 행/컬럼 값 대입 |  |  |  |
| AC-ac8b5665 | SaveButton | SCP0056_MPP_Result_Mgmt.cs:655 | if (fps.Name == "spdMain" && spdMain.ActiveSheetIndex == 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ try | DATA_OP | request.Parameters["P_NOTE3"] | sNOTE3 | 행/컬럼 값 대입 |  |  |  |
| AC-40c18e5a | SaveButton | SCP0056_MPP_Result_Mgmt.cs:657 | if (fps.Name == "spdMain" && spdMain.ActiveSheetIndex == 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ try | DATA_OP | request.Parameters["P_PROD_TYPE"] | sPROD_TYPE | 행/컬럼 값 대입 |  |  |  |
| AC-2ddf339b | SaveButton | SCP0056_MPP_Result_Mgmt.cs:658 | if (fps.Name == "spdMain" && spdMain.ActiveSheetIndex == 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ try | DATA_OP | request.Parameters["P_PROGRAM_ID"] | "SCP0056" | 행/컬럼 값 대입 |  |  |  |
| AC-36524519 | SaveButton | SCP0056_MPP_Result_Mgmt.cs:659 | if (fps.Name == "spdMain" && spdMain.ActiveSheetIndex == 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ try | DATA_OP | request.Parameters["P_USER_ID"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-3a3b8a87 | SaveButton | SCP0056_MPP_Result_Mgmt.cs:661 | if (fps.Name == "spdMain" && spdMain.ActiveSheetIndex == 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-47cd615c | SaveButton | SCP0056_MPP_Result_Mgmt.cs:668 | if (fps.Name == "spdMain" && spdMain.ActiveSheetIndex == 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b623c414 | SaveButton | SCP0056_MPP_Result_Mgmt.cs:676 | if (fps.Name == "spdMain" && spdMain.ActiveSheetIndex == 0) ▸ if (iCount > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { iCount }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SCP0056_MPP_Result_Mgmt.Set_SumValues

진입점: FindButton [if (siMain.ActiveSheet != null) ▸ try ▸ if (dsResult.Tables[0].Rows.Count > 0)] / SaveButton [if (fps.Name == "spdMain" && spdMain.ActiveSheetIndex == 0) ▸ try ▸ if (dsResult.Tables[0].Rows.Count > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-aa0605ed | FindButton [if (siMain.ActiveSheet != null) ▸ try ▸ if (dsRe… 외 1 | SCP0056_MPP_Result_Mgmt.cs:990 | try | GRID_SET | dsBinding.Tables[0].Rows[0][gap_acc_idx] | dGap + dGap_acc | 그리드 속성/값 설정 |  |  |  |
| AC-9f47ccc7 | FindButton [if (siMain.ActiveSheet != null) ▸ try ▸ if (dsRe… 외 1 | SCP0056_MPP_Result_Mgmt.cs:991 | try | GRID_SET | dsBinding.Tables[0].Rows[0][gap_acc_cell_idx] | dGap_cell + dGap_acc_cell | 그리드 속성/값 설정 |  |  |  |
| AC-e346427a | FindButton [if (siMain.ActiveSheet != null) ▸ try ▸ if (dsRe… 외 1 | SCP0056_MPP_Result_Mgmt.cs:1022 | try ▸ for (iRow < dsBinding.Tables[0].Rows.Count) ▸ if (s_division_id.Equals(prev_division_id) && s_site_id.Equals(prev_site_id) && s_factor… | GRID_SET | dsBinding.Tables[0].Rows[iRow][gap_acc_idx] | dGap + dGap_acc_prev | 그리드 속성/값 설정 |  |  |  |
| AC-9bed8d1f | FindButton [if (siMain.ActiveSheet != null) ▸ try ▸ if (dsRe… 외 1 | SCP0056_MPP_Result_Mgmt.cs:1024 | try ▸ for (iRow < dsBinding.Tables[0].Rows.Count) ▸ if (s_division_id.Equals(prev_division_id) && s_site_id.Equals(prev_site_id) && s_factor… | GRID_SET | dsBinding.Tables[0].Rows[iRow][gap_acc_cell_idx] | dGap_cell + dGap_acc_cell_prev | 그리드 속성/값 설정 |  |  |  |
| AC-68c6690a | FindButton [if (siMain.ActiveSheet != null) ▸ try ▸ if (dsRe… 외 1 | SCP0056_MPP_Result_Mgmt.cs:1038 | try ▸ for (iRow < dsBinding.Tables[0].Rows.Count) ▸ else of (s_division_id.Equals(prev_division_id) && s_site_id.Equals(prev_site_id) && s_f… | GRID_SET | dsBinding.Tables[0].Rows[iRow][gap_acc_idx] | dGap | 그리드 속성/값 설정 |  |  |  |
| AC-2a69ce54 | FindButton [if (siMain.ActiveSheet != null) ▸ try ▸ if (dsRe… 외 1 | SCP0056_MPP_Result_Mgmt.cs:1040 | try ▸ for (iRow < dsBinding.Tables[0].Rows.Count) ▸ else of (s_division_id.Equals(prev_division_id) && s_site_id.Equals(prev_site_id) && s_f… | GRID_SET | dsBinding.Tables[0].Rows[iRow][gap_acc_cell_idx] | dGap_cell | 그리드 속성/값 설정 |  |  |  |
| AC-ceab1eae | FindButton [if (siMain.ActiveSheet != null) ▸ try ▸ if (dsRe… 외 1 | SCP0056_MPP_Result_Mgmt.cs:1048 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SCP0056_MPP_Result_Mgmt.SetChangedControl

진입점: this.Load / cboDivision.SelectedIndexChanged [if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain)] / this.spdMain.ActiveSheetChanged [if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3ef1d1d5 | this.Load 외 2 | SCP0056_MPP_Result_Mgmt.cs:218 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | FLAG | dtShopGroup | Data_SCP.Common(Data_SCP.Type.OperationGroup, false, sDivisionID) | 화면 필드/플래그 변경 |  |  |  |
| AC-0989cf0d | this.Load 외 2 | SCP0056_MPP_Result_Mgmt.cs:218 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.OperationGroup, false, sDivisionID) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ea1295df | this.Load 외 2 | SCP0056_MPP_Result_Mgmt.cs:219 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | LIST_REBIND | clsCtrl.setListBox | (dtShopGroup, clbGroup, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-94306f73 | this.Load 외 2 | SCP0056_MPP_Result_Mgmt.cs:222 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | FLAG | dtPlantByGroup | Data_SCP.Common(Data_SCP.Type.PlantByGroup, false, sDivisionID, sOperationGroup) | 화면 필드/플래그 변경 |  |  |  |
| AC-04d8736b | this.Load 외 2 | SCP0056_MPP_Result_Mgmt.cs:222 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.PlantByGroup, false, sDivisionID, sOperationGroup) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-debac971 | this.Load 외 2 | SCP0056_MPP_Result_Mgmt.cs:223 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | LIST_REBIND | clsCtrl.setListBox | (dtPlantByGroup, clbPlant, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-f7f5b42b | this.Load 외 2 | SCP0056_MPP_Result_Mgmt.cs:229 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | FLAG | dtBuildingByPlantSite | Data_SCP.Common(Data_SCP.Type.BuildingByShopGroupId, false, sDivisionID, sPlantId, sOperat… | 화면 필드/플래그 변경 |  |  |  |
| AC-069aa56e | this.Load 외 2 | SCP0056_MPP_Result_Mgmt.cs:229 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.BuildingByShopGroupId, false, sDivisionID, sPlantId, sOperationGroup) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-efd7f2fb | this.Load 외 2 | SCP0056_MPP_Result_Mgmt.cs:230 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | LIST_REBIND | clsCtrl.setListBox | (dtBuildingByPlantSite, clbBuilding, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-003a9af9 | this.Load 외 2 | SCP0056_MPP_Result_Mgmt.cs:234 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | FLAG | dtLineByOperationPlantId | Data_SCP.Common(Data_SCP.Type.LineByOperationPlantId, false, sDivisionID, sPlantId, sBuild… | 화면 필드/플래그 변경 |  |  |  |
| AC-6477d3df | this.Load 외 2 | SCP0056_MPP_Result_Mgmt.cs:234 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.LineByOperationPlantId, false, sDivisionID, sPlantId, sBuilding, sOperation… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ff7f2660 | this.Load 외 2 | SCP0056_MPP_Result_Mgmt.cs:235 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | LIST_REBIND | clsCtrl.setListBox | (dtLineByOperationPlantId, clbLine, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-57f52df3 | this.Load 외 2 | SCP0056_MPP_Result_Mgmt.cs:239 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | FLAG | dtOperationByLine | Data.Common(Data.Type.OperationByLine, false, sDivisionID, sPlantId, sBuilding, sLineId, s… ⇒ biz:CommonData.CommonDataList [code=OperationByLine] | 화면 필드/플래그 변경 |  |  |  |
| AC-3cc91861 | this.Load 외 2 | SCP0056_MPP_Result_Mgmt.cs:239 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | COMBO_DATA | Data.Common | (Data.Type.OperationByLine, false, sDivisionID, sPlantId, sBuilding, sLineId, sOperationGr… ⇒ biz:CommonData.CommonDataList [code=OperationByLine] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-3ea4306b | this.Load 외 2 | SCP0056_MPP_Result_Mgmt.cs:241 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | LIST_REBIND | clsCtrl.setListBox | (dtOperationByLine, clbOperation, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-f431862a | this.Load 외 2 | SCP0056_MPP_Result_Mgmt.cs:244 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | FLAG | dtItemExtraSpec | Data_SCP.Common(Data_SCP.Type.ItemExtraSpec, false, sDivisionID, sPlantId, sOperationGroup… | 화면 필드/플래그 변경 |  |  |  |
| AC-3b54ee95 | this.Load 외 2 | SCP0056_MPP_Result_Mgmt.cs:244 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.ItemExtraSpec, false, sDivisionID, sPlantId, sOperationGroup, sOperation, n… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-5e6ed5e0 | this.Load 외 2 | SCP0056_MPP_Result_Mgmt.cs:245 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | LIST_REBIND | clsCtrl.setListBox | (dtItemExtraSpec, clbItemExtraSpec, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-6083b30e | this.Load 외 2 | SCP0056_MPP_Result_Mgmt.cs:248 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | FLAG | dtItemClass | Data_SCP.Common(Data_SCP.Type.ItemClass, false, sDivisionID, sPlantId, sOperationGroup, sO… | 화면 필드/플래그 변경 |  |  |  |
| AC-747ddb38 | this.Load 외 2 | SCP0056_MPP_Result_Mgmt.cs:248 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.ItemClass, false, sDivisionID, sPlantId, sOperationGroup, sOperation, sExtr… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-5335534a | this.Load 외 2 | SCP0056_MPP_Result_Mgmt.cs:250 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | LIST_REBIND | clsCtrl.setListBox | (dtCellTypeGr, cboCellTypeGr, false) | 목록 컨트롤 재구성 |  |  |  |

## SCP0056_MPP_Result_Mgmt.SetReasonColumn

진입점: cbNote.CheckedChanged / FindButton [if (siMain.ActiveSheet != null) ▸ try] / SaveButton [if (fps.Name == "spdMain" && spdMain.ActiveSheetIndex == 0) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1a9843a2 | cbNote.CheckedChanged 외 2 | SCP0056_MPP_Result_Mgmt.cs:412 | if (cbNote.Checked) ▸ if (RdoUOMCheck.Checked) | GRID_SET | siMain.ActiveSheet.Columns["MPP_OUT"].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-897a5848 | cbNote.CheckedChanged 외 2 | SCP0056_MPP_Result_Mgmt.cs:413 | if (cbNote.Checked) ▸ if (RdoUOMCheck.Checked) | GRID_SET | siMain.ActiveSheet.Columns["RESULT_RP"].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-646ab1d2 | cbNote.CheckedChanged 외 2 | SCP0056_MPP_Result_Mgmt.cs:414 | if (cbNote.Checked) ▸ if (RdoUOMCheck.Checked) | GRID_SET | siMain.ActiveSheet.Columns["GAP"].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-391614e2 | cbNote.CheckedChanged 외 2 | SCP0056_MPP_Result_Mgmt.cs:415 | if (cbNote.Checked) ▸ if (RdoUOMCheck.Checked) | GRID_SET | siMain.ActiveSheet.Columns["GAP_ACC"].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-04132ee9 | cbNote.CheckedChanged 외 2 | SCP0056_MPP_Result_Mgmt.cs:416 | if (cbNote.Checked) ▸ if (RdoUOMCheck.Checked) | GRID_SET | siMain.ActiveSheet.Columns["GAP_CELL"].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-ee7a9327 | cbNote.CheckedChanged 외 2 | SCP0056_MPP_Result_Mgmt.cs:417 | if (cbNote.Checked) ▸ if (RdoUOMCheck.Checked) | GRID_SET | siMain.ActiveSheet.Columns["GAP_ACC_CELL"].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-11ba48c2 | cbNote.CheckedChanged 외 2 | SCP0056_MPP_Result_Mgmt.cs:419 | if (cbNote.Checked) ▸ if (RdoUOMCheck.Checked) | GRID_SET | siMain.ActiveSheet.Columns["DEMAND"].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-567becd7 | cbNote.CheckedChanged 외 2 | SCP0056_MPP_Result_Mgmt.cs:420 | if (cbNote.Checked) ▸ if (RdoUOMCheck.Checked) | GRID_SET | siMain.ActiveSheet.Columns["PRODUCT_MOD"].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-0970530a | cbNote.CheckedChanged 외 2 | SCP0056_MPP_Result_Mgmt.cs:421 | if (cbNote.Checked) ▸ if (RdoUOMCheck.Checked) | GRID_SET | siMain.ActiveSheet.Columns["PRODUCT_SETBACK"].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-ead7277c | cbNote.CheckedChanged 외 2 | SCP0056_MPP_Result_Mgmt.cs:422 | if (cbNote.Checked) ▸ if (RdoUOMCheck.Checked) | GRID_SET | siMain.ActiveSheet.Columns["SEMI_PRODUCT"].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-eacdb054 | cbNote.CheckedChanged 외 2 | SCP0056_MPP_Result_Mgmt.cs:423 | if (cbNote.Checked) ▸ if (RdoUOMCheck.Checked) | GRID_SET | siMain.ActiveSheet.Columns["MATERIAL"].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-49d1da38 | cbNote.CheckedChanged 외 2 | SCP0056_MPP_Result_Mgmt.cs:424 | if (cbNote.Checked) ▸ if (RdoUOMCheck.Checked) | GRID_SET | siMain.ActiveSheet.Columns["ETC_REASON"].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-a6e7c210 | cbNote.CheckedChanged 외 2 | SCP0056_MPP_Result_Mgmt.cs:425 | if (cbNote.Checked) ▸ if (RdoUOMCheck.Checked) | GRID_SET | siMain.ActiveSheet.Columns["PRODUCT_OVER"].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-ebf54180 | cbNote.CheckedChanged 외 2 | SCP0056_MPP_Result_Mgmt.cs:427 | if (cbNote.Checked) ▸ if (RdoUOMCheck.Checked) | GRID_SET | siMain.ActiveSheet.Columns["MPP_OUT_CELL"].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-a828d808 | cbNote.CheckedChanged 외 2 | SCP0056_MPP_Result_Mgmt.cs:428 | if (cbNote.Checked) ▸ if (RdoUOMCheck.Checked) | GRID_SET | siMain.ActiveSheet.Columns["RESULT_RP_CELL"].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-99b80112 | cbNote.CheckedChanged 외 2 | SCP0056_MPP_Result_Mgmt.cs:429 | if (cbNote.Checked) ▸ if (RdoUOMCheck.Checked) | GRID_SET | siMain.ActiveSheet.Columns["DEMAND_CELL"].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-98bb209f | cbNote.CheckedChanged 외 2 | SCP0056_MPP_Result_Mgmt.cs:430 | if (cbNote.Checked) ▸ if (RdoUOMCheck.Checked) | GRID_SET | siMain.ActiveSheet.Columns["PRODUCT_MOD_CELL"].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-06326f10 | cbNote.CheckedChanged 외 2 | SCP0056_MPP_Result_Mgmt.cs:431 | if (cbNote.Checked) ▸ if (RdoUOMCheck.Checked) | GRID_SET | siMain.ActiveSheet.Columns["PRODUCT_SETBACK_CELL"].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-69dcfeda | cbNote.CheckedChanged 외 2 | SCP0056_MPP_Result_Mgmt.cs:432 | if (cbNote.Checked) ▸ if (RdoUOMCheck.Checked) | GRID_SET | siMain.ActiveSheet.Columns["SEMI_PRODUCT_CELL"].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-22a6a996 | cbNote.CheckedChanged 외 2 | SCP0056_MPP_Result_Mgmt.cs:433 | if (cbNote.Checked) ▸ if (RdoUOMCheck.Checked) | GRID_SET | siMain.ActiveSheet.Columns["MATERIAL_CELL"].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-63c23ed8 | cbNote.CheckedChanged 외 2 | SCP0056_MPP_Result_Mgmt.cs:434 | if (cbNote.Checked) ▸ if (RdoUOMCheck.Checked) | GRID_SET | siMain.ActiveSheet.Columns["ETC_REASON_CELL"].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-3ceb35bd | cbNote.CheckedChanged 외 2 | SCP0056_MPP_Result_Mgmt.cs:435 | if (cbNote.Checked) ▸ if (RdoUOMCheck.Checked) | GRID_SET | siMain.ActiveSheet.Columns["PRODUCT_OVER_CELL"].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-14d63d2e | cbNote.CheckedChanged 외 2 | SCP0056_MPP_Result_Mgmt.cs:439 | if (cbNote.Checked) ▸ else of (RdoUOMCheck.Checked) | GRID_SET | siMain.ActiveSheet.Columns["MPP_OUT"].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-e9449208 | cbNote.CheckedChanged 외 2 | SCP0056_MPP_Result_Mgmt.cs:440 | if (cbNote.Checked) ▸ else of (RdoUOMCheck.Checked) | GRID_SET | siMain.ActiveSheet.Columns["RESULT_RP"].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-c25bf139 | cbNote.CheckedChanged 외 2 | SCP0056_MPP_Result_Mgmt.cs:441 | if (cbNote.Checked) ▸ else of (RdoUOMCheck.Checked) | GRID_SET | siMain.ActiveSheet.Columns["GAP"].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-ed57fb85 | cbNote.CheckedChanged 외 2 | SCP0056_MPP_Result_Mgmt.cs:442 | if (cbNote.Checked) ▸ else of (RdoUOMCheck.Checked) | GRID_SET | siMain.ActiveSheet.Columns["GAP_ACC"].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-3136c3fe | cbNote.CheckedChanged 외 2 | SCP0056_MPP_Result_Mgmt.cs:443 | if (cbNote.Checked) ▸ else of (RdoUOMCheck.Checked) | GRID_SET | siMain.ActiveSheet.Columns["GAP_CELL"].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-44e5cbef | cbNote.CheckedChanged 외 2 | SCP0056_MPP_Result_Mgmt.cs:444 | if (cbNote.Checked) ▸ else of (RdoUOMCheck.Checked) | GRID_SET | siMain.ActiveSheet.Columns["GAP_ACC_CELL"].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-c9a92fad | cbNote.CheckedChanged 외 2 | SCP0056_MPP_Result_Mgmt.cs:446 | if (cbNote.Checked) ▸ else of (RdoUOMCheck.Checked) | GRID_SET | siMain.ActiveSheet.Columns["DEMAND"].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-ae500239 | cbNote.CheckedChanged 외 2 | SCP0056_MPP_Result_Mgmt.cs:447 | if (cbNote.Checked) ▸ else of (RdoUOMCheck.Checked) | GRID_SET | siMain.ActiveSheet.Columns["PRODUCT_MOD"].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-48d2b173 | cbNote.CheckedChanged 외 2 | SCP0056_MPP_Result_Mgmt.cs:448 | if (cbNote.Checked) ▸ else of (RdoUOMCheck.Checked) | GRID_SET | siMain.ActiveSheet.Columns["PRODUCT_SETBACK"].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-26ffb624 | cbNote.CheckedChanged 외 2 | SCP0056_MPP_Result_Mgmt.cs:449 | if (cbNote.Checked) ▸ else of (RdoUOMCheck.Checked) | GRID_SET | siMain.ActiveSheet.Columns["SEMI_PRODUCT"].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-ae5f9cb0 | cbNote.CheckedChanged 외 2 | SCP0056_MPP_Result_Mgmt.cs:450 | if (cbNote.Checked) ▸ else of (RdoUOMCheck.Checked) | GRID_SET | siMain.ActiveSheet.Columns["MATERIAL"].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-3d2f46d2 | cbNote.CheckedChanged 외 2 | SCP0056_MPP_Result_Mgmt.cs:451 | if (cbNote.Checked) ▸ else of (RdoUOMCheck.Checked) | GRID_SET | siMain.ActiveSheet.Columns["ETC_REASON"].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-6d283989 | cbNote.CheckedChanged 외 2 | SCP0056_MPP_Result_Mgmt.cs:452 | if (cbNote.Checked) ▸ else of (RdoUOMCheck.Checked) | GRID_SET | siMain.ActiveSheet.Columns["PRODUCT_OVER"].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-d5fec150 | cbNote.CheckedChanged 외 2 | SCP0056_MPP_Result_Mgmt.cs:454 | if (cbNote.Checked) ▸ else of (RdoUOMCheck.Checked) | GRID_SET | siMain.ActiveSheet.Columns["MPP_OUT_CELL"].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-baa963fa | cbNote.CheckedChanged 외 2 | SCP0056_MPP_Result_Mgmt.cs:455 | if (cbNote.Checked) ▸ else of (RdoUOMCheck.Checked) | GRID_SET | siMain.ActiveSheet.Columns["RESULT_RP_CELL"].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-7109ed96 | cbNote.CheckedChanged 외 2 | SCP0056_MPP_Result_Mgmt.cs:456 | if (cbNote.Checked) ▸ else of (RdoUOMCheck.Checked) | GRID_SET | siMain.ActiveSheet.Columns["DEMAND_CELL"].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-ff29a943 | cbNote.CheckedChanged 외 2 | SCP0056_MPP_Result_Mgmt.cs:457 | if (cbNote.Checked) ▸ else of (RdoUOMCheck.Checked) | GRID_SET | siMain.ActiveSheet.Columns["PRODUCT_MOD_CELL"].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-daafbd59 | cbNote.CheckedChanged 외 2 | SCP0056_MPP_Result_Mgmt.cs:458 | if (cbNote.Checked) ▸ else of (RdoUOMCheck.Checked) | GRID_SET | siMain.ActiveSheet.Columns["PRODUCT_SETBACK_CELL"].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-65a6804c | cbNote.CheckedChanged 외 2 | SCP0056_MPP_Result_Mgmt.cs:459 | if (cbNote.Checked) ▸ else of (RdoUOMCheck.Checked) | GRID_SET | siMain.ActiveSheet.Columns["SEMI_PRODUCT_CELL"].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-b799612b | cbNote.CheckedChanged 외 2 | SCP0056_MPP_Result_Mgmt.cs:460 | if (cbNote.Checked) ▸ else of (RdoUOMCheck.Checked) | GRID_SET | siMain.ActiveSheet.Columns["MATERIAL_CELL"].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-2879ebff | cbNote.CheckedChanged 외 2 | SCP0056_MPP_Result_Mgmt.cs:461 | if (cbNote.Checked) ▸ else of (RdoUOMCheck.Checked) | GRID_SET | siMain.ActiveSheet.Columns["ETC_REASON_CELL"].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-661f2de1 | cbNote.CheckedChanged 외 2 | SCP0056_MPP_Result_Mgmt.cs:462 | if (cbNote.Checked) ▸ else of (RdoUOMCheck.Checked) | GRID_SET | siMain.ActiveSheet.Columns["PRODUCT_OVER_CELL"].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-baccc05d | cbNote.CheckedChanged 외 2 | SCP0056_MPP_Result_Mgmt.cs:464 | if (cbNote.Checked) | GRID_SET | siMain.ActiveSheet.Columns["NOTE1"].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-62c4c9cb | cbNote.CheckedChanged 외 2 | SCP0056_MPP_Result_Mgmt.cs:465 | if (cbNote.Checked) | GRID_SET | siMain.ActiveSheet.Columns["NOTE2"].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-0d466fa6 | cbNote.CheckedChanged 외 2 | SCP0056_MPP_Result_Mgmt.cs:466 | if (cbNote.Checked) | GRID_SET | siMain.ActiveSheet.Columns["NOTE3"].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-5eba2d24 | cbNote.CheckedChanged 외 2 | SCP0056_MPP_Result_Mgmt.cs:472 | else of (cbNote.Checked) ▸ if (RdoUOMCheck.Checked) | GRID_SET | siMain.ActiveSheet.Columns["MPP_OUT"].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-90225c47 | cbNote.CheckedChanged 외 2 | SCP0056_MPP_Result_Mgmt.cs:473 | else of (cbNote.Checked) ▸ if (RdoUOMCheck.Checked) | GRID_SET | siMain.ActiveSheet.Columns["RESULT_RP"].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-84090b4b | cbNote.CheckedChanged 외 2 | SCP0056_MPP_Result_Mgmt.cs:474 | else of (cbNote.Checked) ▸ if (RdoUOMCheck.Checked) | GRID_SET | siMain.ActiveSheet.Columns["GAP"].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-00570fa5 | cbNote.CheckedChanged 외 2 | SCP0056_MPP_Result_Mgmt.cs:475 | else of (cbNote.Checked) ▸ if (RdoUOMCheck.Checked) | GRID_SET | siMain.ActiveSheet.Columns["GAP_ACC"].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-cb907990 | cbNote.CheckedChanged 외 2 | SCP0056_MPP_Result_Mgmt.cs:477 | else of (cbNote.Checked) ▸ if (RdoUOMCheck.Checked) | GRID_SET | siMain.ActiveSheet.Columns["MPP_OUT_CELL"].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-8386c3d7 | cbNote.CheckedChanged 외 2 | SCP0056_MPP_Result_Mgmt.cs:478 | else of (cbNote.Checked) ▸ if (RdoUOMCheck.Checked) | GRID_SET | siMain.ActiveSheet.Columns["RESULT_RP_CELL"].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-cd817f50 | cbNote.CheckedChanged 외 2 | SCP0056_MPP_Result_Mgmt.cs:479 | else of (cbNote.Checked) ▸ if (RdoUOMCheck.Checked) | GRID_SET | siMain.ActiveSheet.Columns["GAP_CELL"].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-cfd1c3ef | cbNote.CheckedChanged 외 2 | SCP0056_MPP_Result_Mgmt.cs:480 | else of (cbNote.Checked) ▸ if (RdoUOMCheck.Checked) | GRID_SET | siMain.ActiveSheet.Columns["GAP_ACC_CELL"].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-e89b9dc8 | cbNote.CheckedChanged 외 2 | SCP0056_MPP_Result_Mgmt.cs:484 | else of (cbNote.Checked) ▸ else of (RdoUOMCheck.Checked) | GRID_SET | siMain.ActiveSheet.Columns["MPP_OUT"].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-37e495e4 | cbNote.CheckedChanged 외 2 | SCP0056_MPP_Result_Mgmt.cs:485 | else of (cbNote.Checked) ▸ else of (RdoUOMCheck.Checked) | GRID_SET | siMain.ActiveSheet.Columns["RESULT_RP"].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-63c9153d | cbNote.CheckedChanged 외 2 | SCP0056_MPP_Result_Mgmt.cs:486 | else of (cbNote.Checked) ▸ else of (RdoUOMCheck.Checked) | GRID_SET | siMain.ActiveSheet.Columns["GAP"].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-072aeee8 | cbNote.CheckedChanged 외 2 | SCP0056_MPP_Result_Mgmt.cs:487 | else of (cbNote.Checked) ▸ else of (RdoUOMCheck.Checked) | GRID_SET | siMain.ActiveSheet.Columns["GAP_ACC"].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-c0acb4b6 | cbNote.CheckedChanged 외 2 | SCP0056_MPP_Result_Mgmt.cs:489 | else of (cbNote.Checked) ▸ else of (RdoUOMCheck.Checked) | GRID_SET | siMain.ActiveSheet.Columns["MPP_OUT_CELL"].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-bb52ea53 | cbNote.CheckedChanged 외 2 | SCP0056_MPP_Result_Mgmt.cs:490 | else of (cbNote.Checked) ▸ else of (RdoUOMCheck.Checked) | GRID_SET | siMain.ActiveSheet.Columns["RESULT_RP_CELL"].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-813bd338 | cbNote.CheckedChanged 외 2 | SCP0056_MPP_Result_Mgmt.cs:491 | else of (cbNote.Checked) ▸ else of (RdoUOMCheck.Checked) | GRID_SET | siMain.ActiveSheet.Columns["GAP_CELL"].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-2b62f1ee | cbNote.CheckedChanged 외 2 | SCP0056_MPP_Result_Mgmt.cs:492 | else of (cbNote.Checked) ▸ else of (RdoUOMCheck.Checked) | GRID_SET | siMain.ActiveSheet.Columns["GAP_ACC_CELL"].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-f228d10c | cbNote.CheckedChanged 외 2 | SCP0056_MPP_Result_Mgmt.cs:494 | else of (cbNote.Checked) | GRID_SET | siMain.ActiveSheet.Columns["DEMAND"].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-90407d2e | cbNote.CheckedChanged 외 2 | SCP0056_MPP_Result_Mgmt.cs:495 | else of (cbNote.Checked) | GRID_SET | siMain.ActiveSheet.Columns["PRODUCT_MOD"].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-97d5434e | cbNote.CheckedChanged 외 2 | SCP0056_MPP_Result_Mgmt.cs:496 | else of (cbNote.Checked) | GRID_SET | siMain.ActiveSheet.Columns["PRODUCT_SETBACK"].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-467b00eb | cbNote.CheckedChanged 외 2 | SCP0056_MPP_Result_Mgmt.cs:497 | else of (cbNote.Checked) | GRID_SET | siMain.ActiveSheet.Columns["SEMI_PRODUCT"].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-868a83a3 | cbNote.CheckedChanged 외 2 | SCP0056_MPP_Result_Mgmt.cs:498 | else of (cbNote.Checked) | GRID_SET | siMain.ActiveSheet.Columns["MATERIAL"].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-c7f8c52c | cbNote.CheckedChanged 외 2 | SCP0056_MPP_Result_Mgmt.cs:499 | else of (cbNote.Checked) | GRID_SET | siMain.ActiveSheet.Columns["ETC_REASON"].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-5f81dd5b | cbNote.CheckedChanged 외 2 | SCP0056_MPP_Result_Mgmt.cs:500 | else of (cbNote.Checked) | GRID_SET | siMain.ActiveSheet.Columns["PRODUCT_OVER"].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-52509569 | cbNote.CheckedChanged 외 2 | SCP0056_MPP_Result_Mgmt.cs:502 | else of (cbNote.Checked) | GRID_SET | siMain.ActiveSheet.Columns["DEMAND_CELL"].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-9a76e671 | cbNote.CheckedChanged 외 2 | SCP0056_MPP_Result_Mgmt.cs:503 | else of (cbNote.Checked) | GRID_SET | siMain.ActiveSheet.Columns["PRODUCT_MOD_CELL"].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-0f502cb8 | cbNote.CheckedChanged 외 2 | SCP0056_MPP_Result_Mgmt.cs:504 | else of (cbNote.Checked) | GRID_SET | siMain.ActiveSheet.Columns["PRODUCT_SETBACK_CELL"].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-add7b107 | cbNote.CheckedChanged 외 2 | SCP0056_MPP_Result_Mgmt.cs:505 | else of (cbNote.Checked) | GRID_SET | siMain.ActiveSheet.Columns["SEMI_PRODUCT_CELL"].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-d279ee98 | cbNote.CheckedChanged 외 2 | SCP0056_MPP_Result_Mgmt.cs:506 | else of (cbNote.Checked) | GRID_SET | siMain.ActiveSheet.Columns["MATERIAL_CELL"].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-be8da38d | cbNote.CheckedChanged 외 2 | SCP0056_MPP_Result_Mgmt.cs:507 | else of (cbNote.Checked) | GRID_SET | siMain.ActiveSheet.Columns["ETC_REASON_CELL"].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-b8fdf202 | cbNote.CheckedChanged 외 2 | SCP0056_MPP_Result_Mgmt.cs:508 | else of (cbNote.Checked) | GRID_SET | siMain.ActiveSheet.Columns["PRODUCT_OVER_CELL"].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-39107dde | cbNote.CheckedChanged 외 2 | SCP0056_MPP_Result_Mgmt.cs:510 | else of (cbNote.Checked) | GRID_SET | siMain.ActiveSheet.Columns["NOTE1"].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-cc18458a | cbNote.CheckedChanged 외 2 | SCP0056_MPP_Result_Mgmt.cs:511 | else of (cbNote.Checked) | GRID_SET | siMain.ActiveSheet.Columns["NOTE2"].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-a773454f | cbNote.CheckedChanged 외 2 | SCP0056_MPP_Result_Mgmt.cs:512 | else of (cbNote.Checked) | GRID_SET | siMain.ActiveSheet.Columns["NOTE3"].Visible | false | 그리드 속성/값 설정 |  |  |  |

## SCP0056_MPP_Result_Mgmt.SetSpreadInit

진입점: this.Load / FindButton [if (siMain.ActiveSheet != null)] / SaveButton [if (fps.Name == "spdMain" && spdMain.ActiveSheetIndex == 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6195b3bf | this.Load 외 2 | SCP0056_MPP_Result_Mgmt.cs:301 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9749be39 | this.Load 외 2 | SCP0056_MPP_Result_Mgmt.cs:302 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-26ddb6a2 | this.Load 외 2 | SCP0056_MPP_Result_Mgmt.cs:303 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.SetSheetHeaderColumn | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-a89ebdcf | this.Load 외 2 | SCP0056_MPP_Result_Mgmt.cs:304 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ba658372 | this.Load 외 2 | SCP0056_MPP_Result_Mgmt.cs:305 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0056_MPP_Result_Mgmt.SpdMain_ActiveSheetChanged

진입점: this.spdMain.ActiveSheetChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ea453c9e | this.spdMain.ActiveSheetChanged | SCP0056_MPP_Result_Mgmt.cs:1169 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMain) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7d3ae73d | this.spdMain.ActiveSheetChanged | SCP0056_MPP_Result_Mgmt.cs:1170 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0056_MPP_Result_Mgmt.SpdMain_CellClick

진입점: spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ae3f8d75 | spdMain.CellClick | SCP0056_MPP_Result_Mgmt.cs:1130 |  | CALL_EXT | siMain.IsLockCell | (e.Row, e.Column) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0056_MPP_Result_Mgmt.SpdMain_CellDoubleClick

진입점: spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9baea5f2 | spdMain.CellDoubleClick | SCP0056_MPP_Result_Mgmt.cs:186 | if (siMain.Sheet().Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-095a67ad | spdMain.CellDoubleClick | SCP0056_MPP_Result_Mgmt.cs:190 | if (!e.ColumnHeader && e.Row >= 0) | FLAG | this.nMainSelRow | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-33aa9e40 | spdMain.CellDoubleClick | SCP0056_MPP_Result_Mgmt.cs:191 | if (!e.ColumnHeader && e.Row >= 0) | FLAG | this.nMainSelCol | e.Column | 화면 필드/플래그 변경 |  |  |  |

## SCP0056_MPP_Result_Mgmt.SpdMain_Changed

진입점: dsdmMain.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0270b377 | dsdmMain.Changed | SCP0056_MPP_Result_Mgmt.cs:1138 | if (!this.CanModelChange \|\| e.Row == -1 \|\| e.Column == -1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8fd4408d | dsdmMain.Changed | SCP0056_MPP_Result_Mgmt.cs:1139 | if (siMain == null \|\| siMain.IsLock(siMain.SheetName) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8ca6b65b | dsdmMain.Changed | SCP0056_MPP_Result_Mgmt.cs:1148 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) | FLAG | this._siMainCellRowIdx | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-67532b82 | dsdmMain.Changed | SCP0056_MPP_Result_Mgmt.cs:1149 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) | FLAG | this._siMainCellColIdx | e.Column | 화면 필드/플래그 변경 |  |  |  |

## SCP0056_MPP_Result_Mgmt.SpdMain_EditChange

진입점: this.spdMain.EditChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fbad2b57 | this.spdMain.EditChange | SCP0056_MPP_Result_Mgmt.cs:1178 |  | FLAG | this._siMainCellRowIdx | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-0cabb567 | this.spdMain.EditChange | SCP0056_MPP_Result_Mgmt.cs:1179 |  | FLAG | this._siMainCellColIdx | e.Column | 화면 필드/플래그 변경 |  |  |  |

## SCP0056_MPP_Result_Mgmt.SpdMain_TopChange

진입점: spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-abdd6305 | spdMain.TopChange | SCP0056_MPP_Result_Mgmt.cs:198 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

