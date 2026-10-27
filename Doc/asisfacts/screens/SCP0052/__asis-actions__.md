# AS-IS 액션 대조표 — SCP0052

> 원천: `Doc/asisfacts/screens/SCP0052/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 926행 · 메서드 34 · 종류 UI_PROP 250 · DATA_OP 164 · GRID_INIT 76 · FLAG 60 · LIST_REBIND 48 · COMBO_DATA 44 · STATE 42 · ENDPOINT 36 · CALL_EXT 30 · UI_MISC 26 · RETURN 26 · GRID_SET 24 · GRID_STYLE 22 · POPUP 20 · MESSAGE 14 · VALUE_SET 14 · VALIDATE 8 · GRID_BIND 8 · GRID_LOCK 6 · VALUE_CLEAR 4 · GRID_CLEAR 2 · STATE_RESET 2 · ⚠ 의미 확인 필요 30


## SCP0052_CAPA_Report.BtnColumn_Click

진입점: this.btnColumn.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4ce87714 | this.btnColumn.Click | SCP0052_CAPA_Report.cs:1324 |  | POPUP | new SCM0002_TitleSetForm_Popup | ("SCP0052", sSheetName, true) | 팝업/폼 생성 |  |  |  |
| AC-b687d3f8 | this.btnColumn.Click | SCP0052_CAPA_Report.cs:1325 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-a8e4c72b | this.btnColumn.Click | SCP0052_CAPA_Report.cs:1326 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-8d0b5d94 | this.btnColumn.Click | SCP0052_CAPA_Report.cs:1324 |  | POPUP | new SCM0002_TitleSetForm_Popup | ("SCP0052", sSheetName, true) | 팝업/폼 생성 |  |  |  |
| AC-543835df | this.btnColumn.Click | SCP0052_CAPA_Report.cs:1325 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-a7fded52 | this.btnColumn.Click | SCP0052_CAPA_Report.cs:1326 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## SCP0052_CAPA_Report.CboDivision1_SelectedIndexChanged

진입점: cboDivision1.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cdf246a8 | cboDivision1.SelectedIndexChanged | SCP0052_CAPA_Report.cs:1088 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |
| AC-fe218890 | cboDivision1.SelectedIndexChanged | SCP0052_CAPA_Report.cs:1092 |  | FLAG | dtShopGroup1 | Data_SCP.Common(Data_SCP.Type.ShopGroupId, false, pDivisionID) | 화면 필드/플래그 변경 |  |  |  |
| AC-6cbed8a5 | cboDivision1.SelectedIndexChanged | SCP0052_CAPA_Report.cs:1092 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.ShopGroupId, false, pDivisionID) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-6d5a71ae | cboDivision1.SelectedIndexChanged | SCP0052_CAPA_Report.cs:1093 |  | LIST_REBIND | clsCtrl.setListBox | (dtShopGroup1, cboGroup1, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-1b48c6e3 | cboDivision1.SelectedIndexChanged | SCP0052_CAPA_Report.cs:1097 |  | FLAG | dtPlantByGroup1 | Data_SCP.Common(Data_SCP.Type.PlantByGroup, false, pDivisionID, pGroupId) | 화면 필드/플래그 변경 |  |  |  |
| AC-8b3df83b | cboDivision1.SelectedIndexChanged | SCP0052_CAPA_Report.cs:1097 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.PlantByGroup, false, pDivisionID, pGroupId) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-673b85a6 | cboDivision1.SelectedIndexChanged | SCP0052_CAPA_Report.cs:1098 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantByGroup1, clbPlant1, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-56d9ebdd | cboDivision1.SelectedIndexChanged | SCP0052_CAPA_Report.cs:1088 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |
| AC-0e66f7a7 | cboDivision1.SelectedIndexChanged | SCP0052_CAPA_Report.cs:1092 |  | FLAG | dtShopGroup1 | Data_SCP.Common(Data_SCP.Type.ShopGroupId, false, division) | 화면 필드/플래그 변경 |  |  |  |
| AC-2f576442 | cboDivision1.SelectedIndexChanged | SCP0052_CAPA_Report.cs:1092 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.ShopGroupId, false, division) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-f20f255c | cboDivision1.SelectedIndexChanged | SCP0052_CAPA_Report.cs:1093 |  | LIST_REBIND | clsCtrl.setListBox | (dtShopGroup1, cboGroup1, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-1b7af7a3 | cboDivision1.SelectedIndexChanged | SCP0052_CAPA_Report.cs:1097 |  | FLAG | dtPlantByGroup1 | Data_SCP.Common(Data_SCP.Type.PlantByGroup, false, division, pGroupId) | 화면 필드/플래그 변경 |  |  |  |
| AC-37457325 | cboDivision1.SelectedIndexChanged | SCP0052_CAPA_Report.cs:1097 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.PlantByGroup, false, division, pGroupId) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-98bda22f | cboDivision1.SelectedIndexChanged | SCP0052_CAPA_Report.cs:1098 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantByGroup1, clbPlant1, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0052_CAPA_Report.CboGroup1_SelectedIndexChanged

진입점: cboGroup1.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c65193c4 | cboGroup1.SelectedIndexChanged | SCP0052_CAPA_Report.cs:1141 |  | FLAG | dtPlantByGroup1 | Data_SCP.Common(Data_SCP.Type.PlantByGroup, false, pDivisionID, pGroupID) | 화면 필드/플래그 변경 |  |  |  |
| AC-862fd245 | cboGroup1.SelectedIndexChanged | SCP0052_CAPA_Report.cs:1141 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.PlantByGroup, false, pDivisionID, pGroupID) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-6ac27885 | cboGroup1.SelectedIndexChanged | SCP0052_CAPA_Report.cs:1142 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantByGroup1, clbPlant1, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-20a9d589 | cboGroup1.SelectedIndexChanged | SCP0052_CAPA_Report.cs:1141 |  | FLAG | dtPlantByGroup1 | Data_SCP.Common(Data_SCP.Type.PlantByGroup, false, division, pGroupID) | 화면 필드/플래그 변경 |  |  |  |
| AC-88cb25f4 | cboGroup1.SelectedIndexChanged | SCP0052_CAPA_Report.cs:1141 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.PlantByGroup, false, division, pGroupID) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-2fd62a12 | cboGroup1.SelectedIndexChanged | SCP0052_CAPA_Report.cs:1142 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantByGroup1, clbPlant1, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0052_CAPA_Report.ClbBuilding_SelectedIndexChanged

진입점: clbBuilding.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-aec16ccb | clbBuilding.SelectedIndexChanged | SCP0052_CAPA_Report.cs:1171 |  | FLAG | dtLineByOperationPlantId | Data_SCP.Common(Data_SCP.Type.LineByOperationPlantId, false, pDivisionID, pPlantID, pFacto… | 화면 필드/플래그 변경 |  |  |  |
| AC-37344852 | clbBuilding.SelectedIndexChanged | SCP0052_CAPA_Report.cs:1171 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.LineByOperationPlantId, false, pDivisionID, pPlantID, pFactoryID, pGroupID) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-aa5827e9 | clbBuilding.SelectedIndexChanged | SCP0052_CAPA_Report.cs:1172 |  | LIST_REBIND | clsCtrl.setListBox | (dtLineByOperationPlantId, clbLine, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-21171e1d | clbBuilding.SelectedIndexChanged | SCP0052_CAPA_Report.cs:1176 |  | FLAG | dtOperationByLine | Data.Common(Data.Type.OperationByLine, false,pDivisionID,pPlantID,pFactoryID, pLineId, pGr… ⇒ biz:CommonData.CommonDataList [code=OperationByLine] | 화면 필드/플래그 변경 |  |  |  |
| AC-9e6a1a85 | clbBuilding.SelectedIndexChanged | SCP0052_CAPA_Report.cs:1176 |  | COMBO_DATA | Data.Common | (Data.Type.OperationByLine, false,pDivisionID,pPlantID,pFactoryID, pLineId, pGroupID) ⇒ biz:CommonData.CommonDataList [code=OperationByLine] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-a7af9378 | clbBuilding.SelectedIndexChanged | SCP0052_CAPA_Report.cs:1177 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperationByLine, clbOperation, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-3c31e0e5 | clbBuilding.SelectedIndexChanged | SCP0052_CAPA_Report.cs:1171 |  | FLAG | dtLineByOperationPlantId | Data_SCP.Common(Data_SCP.Type.LineByOperationPlantId, false, division, pPlantID, pFactoryI… | 화면 필드/플래그 변경 |  |  |  |
| AC-7bfebff7 | clbBuilding.SelectedIndexChanged | SCP0052_CAPA_Report.cs:1171 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.LineByOperationPlantId, false, division, pPlantID, pFactoryID, pGroupID) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-4b0f4f0c | clbBuilding.SelectedIndexChanged | SCP0052_CAPA_Report.cs:1172 |  | LIST_REBIND | clsCtrl.setListBox | (dtLineByOperationPlantId, clbLine, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-2fac0ab8 | clbBuilding.SelectedIndexChanged | SCP0052_CAPA_Report.cs:1176 |  | FLAG | dtOperationByLine | Data.Common(Data.Type.OperationByLine, false,division,pPlantID,pFactoryID, pLineId, pGroup… ⇒ biz:CommonData.CommonDataList [code=OperationByLine] | 화면 필드/플래그 변경 |  |  |  |
| AC-a6e23e1a | clbBuilding.SelectedIndexChanged | SCP0052_CAPA_Report.cs:1176 |  | COMBO_DATA | Data.Common | (Data.Type.OperationByLine, false,division,pPlantID,pFactoryID, pLineId, pGroupID) ⇒ biz:CommonData.CommonDataList [code=OperationByLine] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-f293fa39 | clbBuilding.SelectedIndexChanged | SCP0052_CAPA_Report.cs:1177 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperationByLine, clbOperation, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0052_CAPA_Report.ClbGroup_SelectedIndexChanged

진입점: cboGroup.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-942e7f65 | cboGroup.SelectedIndexChanged | SCP0052_CAPA_Report.cs:1107 |  | FLAG | dtPlantByGroup | Data_SCP.Common(Data_SCP.Type.PlantByGroup, false, pDivisionID, pGroupID) | 화면 필드/플래그 변경 |  |  |  |
| AC-d0aeb72b | cboGroup.SelectedIndexChanged | SCP0052_CAPA_Report.cs:1107 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.PlantByGroup, false, pDivisionID, pGroupID) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-155c0777 | cboGroup.SelectedIndexChanged | SCP0052_CAPA_Report.cs:1108 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantByGroup, clbPlant, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-5464fa60 | cboGroup.SelectedIndexChanged | SCP0052_CAPA_Report.cs:1111 |  | FLAG | dtBuildingByShopGroupId | Data_SCP.Common(Data_SCP.Type.BuildingByShopGroupId, false, pDivisionID, pPlantID, pGroupI… | 화면 필드/플래그 변경 |  |  |  |
| AC-ab294c73 | cboGroup.SelectedIndexChanged | SCP0052_CAPA_Report.cs:1111 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.BuildingByShopGroupId, false, pDivisionID, pPlantID, pGroupID) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-1ae3658c | cboGroup.SelectedIndexChanged | SCP0052_CAPA_Report.cs:1112 |  | LIST_REBIND | clsCtrl.setListBox | (dtBuildingByShopGroupId, clbBuilding, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-a566999b | cboGroup.SelectedIndexChanged | SCP0052_CAPA_Report.cs:1115 |  | FLAG | dtLineByOperationPlantId | Data_SCP.Common(Data_SCP.Type.LineByOperationPlantId, false, pDivisionID, pPlantID, pFacto… | 화면 필드/플래그 변경 |  |  |  |
| AC-6afe4e74 | cboGroup.SelectedIndexChanged | SCP0052_CAPA_Report.cs:1115 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.LineByOperationPlantId, false, pDivisionID, pPlantID, pFactoryID,pGroupID) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-1aa3313a | cboGroup.SelectedIndexChanged | SCP0052_CAPA_Report.cs:1116 |  | LIST_REBIND | clsCtrl.setListBox | (dtLineByOperationPlantId, clbLine, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-2b8116e5 | cboGroup.SelectedIndexChanged | SCP0052_CAPA_Report.cs:1119 |  | FLAG | dtOperationByLine | Data.Common(Data.Type.OperationByLine, false, pDivisionID, pPlantID, pFactoryID, pLineId,p… ⇒ biz:CommonData.CommonDataList [code=OperationByLine] | 화면 필드/플래그 변경 |  |  |  |
| AC-4e158e27 | cboGroup.SelectedIndexChanged | SCP0052_CAPA_Report.cs:1119 |  | COMBO_DATA | Data.Common | (Data.Type.OperationByLine, false, pDivisionID, pPlantID, pFactoryID, pLineId,pGroupID) ⇒ biz:CommonData.CommonDataList [code=OperationByLine] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-b5e45d78 | cboGroup.SelectedIndexChanged | SCP0052_CAPA_Report.cs:1120 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperationByLine, clbOperation, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-e5b98d63 | cboGroup.SelectedIndexChanged | SCP0052_CAPA_Report.cs:1122 |  | FLAG | dtVersionId | Data_SCP.Common(Data_SCP.Type.MDMVersionId, false, pDivisionID, pGroupID) | 화면 필드/플래그 변경 |  |  |  |
| AC-76257c60 | cboGroup.SelectedIndexChanged | SCP0052_CAPA_Report.cs:1122 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.MDMVersionId, false, pDivisionID, pGroupID) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c93f7c84 | cboGroup.SelectedIndexChanged | SCP0052_CAPA_Report.cs:1123 |  | DATA_OP | dtVersionId.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-59adba08 | cboGroup.SelectedIndexChanged | SCP0052_CAPA_Report.cs:1124 |  | DATA_OP | drCurrentRow["CODE"] | "Current" | 행/컬럼 값 대입 |  |  |  |
| AC-01ae6236 | cboGroup.SelectedIndexChanged | SCP0052_CAPA_Report.cs:1125 |  | DATA_OP | drCurrentRow["NAME"] | "Current" | 행/컬럼 값 대입 |  |  |  |
| AC-2af6c93d | cboGroup.SelectedIndexChanged | SCP0052_CAPA_Report.cs:1126 |  | CALL_EXT | dtVersionId.Rows.InsertAt | (drCurrentRow, 0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f4ca44b3 | cboGroup.SelectedIndexChanged | SCP0052_CAPA_Report.cs:1127 |  | DATA_OP | dtVersionId.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-4add6af4 | cboGroup.SelectedIndexChanged | SCP0052_CAPA_Report.cs:1128 |  | LIST_REBIND | clsCtrl.setListBox | (dtVersionId, clbVersionId, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-a1155a69 | cboGroup.SelectedIndexChanged | SCP0052_CAPA_Report.cs:1107 |  | FLAG | dtPlantByGroup | Data_SCP.Common(Data_SCP.Type.PlantByGroup, false, division, pGroupID) | 화면 필드/플래그 변경 |  |  |  |
| AC-aa6e55b0 | cboGroup.SelectedIndexChanged | SCP0052_CAPA_Report.cs:1107 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.PlantByGroup, false, division, pGroupID) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-0b8b9338 | cboGroup.SelectedIndexChanged | SCP0052_CAPA_Report.cs:1108 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantByGroup, clbPlant, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-5cb8aa15 | cboGroup.SelectedIndexChanged | SCP0052_CAPA_Report.cs:1111 |  | FLAG | dtBuildingByShopGroupId | Data_SCP.Common(Data_SCP.Type.BuildingByShopGroupId, false, division, pPlantID, pGroupID) | 화면 필드/플래그 변경 |  |  |  |
| AC-34da6d60 | cboGroup.SelectedIndexChanged | SCP0052_CAPA_Report.cs:1111 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.BuildingByShopGroupId, false, division, pPlantID, pGroupID) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-1e97890e | cboGroup.SelectedIndexChanged | SCP0052_CAPA_Report.cs:1112 |  | LIST_REBIND | clsCtrl.setListBox | (dtBuildingByShopGroupId, clbBuilding, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-d3a74e93 | cboGroup.SelectedIndexChanged | SCP0052_CAPA_Report.cs:1115 |  | FLAG | dtLineByOperationPlantId | Data_SCP.Common(Data_SCP.Type.LineByOperationPlantId, false, division, pPlantID, pFactoryI… | 화면 필드/플래그 변경 |  |  |  |
| AC-6f4b5551 | cboGroup.SelectedIndexChanged | SCP0052_CAPA_Report.cs:1115 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.LineByOperationPlantId, false, division, pPlantID, pFactoryID,pGroupID) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-bcebc6fd | cboGroup.SelectedIndexChanged | SCP0052_CAPA_Report.cs:1116 |  | LIST_REBIND | clsCtrl.setListBox | (dtLineByOperationPlantId, clbLine, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-3cf0fe28 | cboGroup.SelectedIndexChanged | SCP0052_CAPA_Report.cs:1119 |  | FLAG | dtOperationByLine | Data.Common(Data.Type.OperationByLine, false, division, pPlantID, pFactoryID, pLineId,pGro… ⇒ biz:CommonData.CommonDataList [code=OperationByLine] | 화면 필드/플래그 변경 |  |  |  |
| AC-9ee5b1ff | cboGroup.SelectedIndexChanged | SCP0052_CAPA_Report.cs:1119 |  | COMBO_DATA | Data.Common | (Data.Type.OperationByLine, false, division, pPlantID, pFactoryID, pLineId,pGroupID) ⇒ biz:CommonData.CommonDataList [code=OperationByLine] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-bdb1cad3 | cboGroup.SelectedIndexChanged | SCP0052_CAPA_Report.cs:1120 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperationByLine, clbOperation, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-212dd4d0 | cboGroup.SelectedIndexChanged | SCP0052_CAPA_Report.cs:1122 |  | FLAG | dtVersionId | Data_SCP.Common(Data_SCP.Type.MDMVersionId, false, division, pGroupID) | 화면 필드/플래그 변경 |  |  |  |
| AC-5e482ee1 | cboGroup.SelectedIndexChanged | SCP0052_CAPA_Report.cs:1122 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.MDMVersionId, false, division, pGroupID) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e3d7cc32 | cboGroup.SelectedIndexChanged | SCP0052_CAPA_Report.cs:1123 |  | DATA_OP | dtVersionId.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-d0bd799f | cboGroup.SelectedIndexChanged | SCP0052_CAPA_Report.cs:1124 |  | DATA_OP | drCurrentRow["CODE"] | "Current" | 행/컬럼 값 대입 |  |  |  |
| AC-4e136bc9 | cboGroup.SelectedIndexChanged | SCP0052_CAPA_Report.cs:1125 |  | DATA_OP | drCurrentRow["NAME"] | "Current" | 행/컬럼 값 대입 |  |  |  |
| AC-4a02e9a1 | cboGroup.SelectedIndexChanged | SCP0052_CAPA_Report.cs:1126 |  | CALL_EXT | dtVersionId.Rows.InsertAt | (drCurrentRow, 0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2575296d | cboGroup.SelectedIndexChanged | SCP0052_CAPA_Report.cs:1127 |  | DATA_OP | dtVersionId.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-8db47508 | cboGroup.SelectedIndexChanged | SCP0052_CAPA_Report.cs:1128 |  | LIST_REBIND | clsCtrl.setListBox | (dtVersionId, clbVersionId, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0052_CAPA_Report.ClbLine_SelectedIndexChanged

진입점: clbLine.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5a140501 | clbLine.SelectedIndexChanged | SCP0052_CAPA_Report.cs:1188 |  | FLAG | dtOperationByLine | Data.Common(Data.Type.OperationByLine, false, pDivisionID, pPlantID, pFactoryID, pLineID, … ⇒ biz:CommonData.CommonDataList [code=OperationByLine] | 화면 필드/플래그 변경 |  |  |  |
| AC-bed163f9 | clbLine.SelectedIndexChanged | SCP0052_CAPA_Report.cs:1188 |  | COMBO_DATA | Data.Common | (Data.Type.OperationByLine, false, pDivisionID, pPlantID, pFactoryID, pLineID, pGroupID) ⇒ biz:CommonData.CommonDataList [code=OperationByLine] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ec111b48 | clbLine.SelectedIndexChanged | SCP0052_CAPA_Report.cs:1189 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperationByLine, clbOperation, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-e62eceae | clbLine.SelectedIndexChanged | SCP0052_CAPA_Report.cs:1188 |  | FLAG | dtOperationByLine | Data.Common(Data.Type.OperationByLine, false, division, pPlantID, pFactoryID, pLineID, pGr… ⇒ biz:CommonData.CommonDataList [code=OperationByLine] | 화면 필드/플래그 변경 |  |  |  |
| AC-b286568e | clbLine.SelectedIndexChanged | SCP0052_CAPA_Report.cs:1188 |  | COMBO_DATA | Data.Common | (Data.Type.OperationByLine, false, division, pPlantID, pFactoryID, pLineID, pGroupID) ⇒ biz:CommonData.CommonDataList [code=OperationByLine] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ea3696c0 | clbLine.SelectedIndexChanged | SCP0052_CAPA_Report.cs:1189 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperationByLine, clbOperation, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0052_CAPA_Report.ClbPlant_SelectedIndexChanged

진입점: clbPlant.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5e5556a8 | clbPlant.SelectedIndexChanged | SCP0052_CAPA_Report.cs:1151 |  | FLAG | dtBuildingByShopGroupId | Data_SCP.Common(Data_SCP.Type.BuildingByShopGroupId, false, pDivisionID, pPlantID, pGroupI… | 화면 필드/플래그 변경 |  |  |  |
| AC-84f83131 | clbPlant.SelectedIndexChanged | SCP0052_CAPA_Report.cs:1151 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.BuildingByShopGroupId, false, pDivisionID, pPlantID, pGroupID) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-28a6eff1 | clbPlant.SelectedIndexChanged | SCP0052_CAPA_Report.cs:1152 |  | LIST_REBIND | clsCtrl.setListBox | (dtBuildingByShopGroupId, clbBuilding, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-ae92508e | clbPlant.SelectedIndexChanged | SCP0052_CAPA_Report.cs:1155 |  | FLAG | dtLineByOperationPlantId | Data_SCP.Common(Data_SCP.Type.LineByOperationPlantId, false, pDivisionID, pPlantID, pFacto… | 화면 필드/플래그 변경 |  |  |  |
| AC-3fa12b8d | clbPlant.SelectedIndexChanged | SCP0052_CAPA_Report.cs:1155 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.LineByOperationPlantId, false, pDivisionID, pPlantID, pFactoryID, pGroupID) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-2f59c92a | clbPlant.SelectedIndexChanged | SCP0052_CAPA_Report.cs:1156 |  | LIST_REBIND | clsCtrl.setListBox | (dtLineByOperationPlantId, clbLine, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-fb068b61 | clbPlant.SelectedIndexChanged | SCP0052_CAPA_Report.cs:1160 |  | FLAG | dtOperationByLine | Data.Common(Data.Type.OperationByLine, false, pDivisionID, pPlantID, pFactoryID, pLineId, … ⇒ biz:CommonData.CommonDataList [code=OperationByLine] | 화면 필드/플래그 변경 |  |  |  |
| AC-e16e3565 | clbPlant.SelectedIndexChanged | SCP0052_CAPA_Report.cs:1160 |  | COMBO_DATA | Data.Common | (Data.Type.OperationByLine, false, pDivisionID, pPlantID, pFactoryID, pLineId, pGroupID) ⇒ biz:CommonData.CommonDataList [code=OperationByLine] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-3a9e68db | clbPlant.SelectedIndexChanged | SCP0052_CAPA_Report.cs:1161 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperationByLine, clbOperation, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-201c0bdf | clbPlant.SelectedIndexChanged | SCP0052_CAPA_Report.cs:1151 |  | FLAG | dtBuildingByShopGroupId | Data_SCP.Common(Data_SCP.Type.BuildingByShopGroupId, false, division, pPlantID, pGroupID) | 화면 필드/플래그 변경 |  |  |  |
| AC-a9feaf91 | clbPlant.SelectedIndexChanged | SCP0052_CAPA_Report.cs:1151 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.BuildingByShopGroupId, false, division, pPlantID, pGroupID) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-54aa19f5 | clbPlant.SelectedIndexChanged | SCP0052_CAPA_Report.cs:1152 |  | LIST_REBIND | clsCtrl.setListBox | (dtBuildingByShopGroupId, clbBuilding, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-88b3649d | clbPlant.SelectedIndexChanged | SCP0052_CAPA_Report.cs:1155 |  | FLAG | dtLineByOperationPlantId | Data_SCP.Common(Data_SCP.Type.LineByOperationPlantId, false, division, pPlantID, pFactoryI… | 화면 필드/플래그 변경 |  |  |  |
| AC-4dc56726 | clbPlant.SelectedIndexChanged | SCP0052_CAPA_Report.cs:1155 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.LineByOperationPlantId, false, division, pPlantID, pFactoryID, pGroupID) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-743147fc | clbPlant.SelectedIndexChanged | SCP0052_CAPA_Report.cs:1156 |  | LIST_REBIND | clsCtrl.setListBox | (dtLineByOperationPlantId, clbLine, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-b37e7411 | clbPlant.SelectedIndexChanged | SCP0052_CAPA_Report.cs:1160 |  | FLAG | dtOperationByLine | Data.Common(Data.Type.OperationByLine, false, division, pPlantID, pFactoryID, pLineId, pGr… ⇒ biz:CommonData.CommonDataList [code=OperationByLine] | 화면 필드/플래그 변경 |  |  |  |
| AC-65070521 | clbPlant.SelectedIndexChanged | SCP0052_CAPA_Report.cs:1160 |  | COMBO_DATA | Data.Common | (Data.Type.OperationByLine, false, division, pPlantID, pFactoryID, pLineId, pGroupID) ⇒ biz:CommonData.CommonDataList [code=OperationByLine] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-a9d7be9c | clbPlant.SelectedIndexChanged | SCP0052_CAPA_Report.cs:1161 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperationByLine, clbOperation, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0052_CAPA_Report.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-af8a2067 | this.Load | SCP0052_CAPA_Report.cs:291 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-729845e1 | this.Load | SCP0052_CAPA_Report.cs:292 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-3667a77e | this.Load | SCP0052_CAPA_Report.cs:294 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtTotalYield, SpdSheet.shtTotalYield, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-85d9452b | this.Load | SCP0052_CAPA_Report.cs:295 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-9d9bd952 | this.Load | SCP0052_CAPA_Report.cs:297 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtYieldMonitoring, SpdSheet.shtYieldMonitoring, 2, 1, 70) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-776aa36d | this.Load | SCP0052_CAPA_Report.cs:298 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-128a4f14 | this.Load | SCP0052_CAPA_Report.cs:300 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-42f781f5 | this.Load | SCP0052_CAPA_Report.cs:291 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-e54c494f | this.Load | SCP0052_CAPA_Report.cs:292 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-c43e76fb | this.Load | SCP0052_CAPA_Report.cs:294 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtTotalYield, SpdSheet.shtTotalYield, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-1289a7f2 | this.Load | SCP0052_CAPA_Report.cs:295 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-3c3d198f | this.Load | SCP0052_CAPA_Report.cs:297 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtYieldMonitoring, SpdSheet.shtYieldMonitoring, 2, 1, 70) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-6fb245ff | this.Load | SCP0052_CAPA_Report.cs:298 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-c778affe | this.Load | SCP0052_CAPA_Report.cs:300 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0052_CAPA_Report.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-077275cd | Dispose | SCP0052_CAPA_Report.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-92e9d54a | Dispose | SCP0052_CAPA_Report.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0052_CAPA_Report.drpPeriodMonth_ValueChanged

진입점: drpPeriodMonth.ValueChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ca758cfe | drpPeriodMonth.ValueChanged | SCP0052_CAPA_Report.cs:1485 | if (dtPeriodFrom > dtPeriodTo) | UI_PROP | drpPeriodMonth.MonthText1 | drpPeriodMonth.MonthText2 | 속성 MonthText1 설정 |  |  |  |
| AC-254e8a07 | drpPeriodMonth.ValueChanged | SCP0052_CAPA_Report.cs:1485 | if (dtPeriodFrom > dtPeriodTo) | UI_PROP | drpPeriodMonth.MonthText1 | drpPeriodMonth.MonthText2 | 속성 MonthText1 설정 |  |  |  |

## SCP0052_CAPA_Report.FindData_History

진입점: txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ if (siMain.ActiveSheet != null) ▸ if (siMain.ActiveSheetIndex == 0)] / txtMaterialId.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ if (siMain.ActiveSheet != null) ▸ if (siMain.ActiveSheetIndex == 0)] / txtNickName.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ if (siMain.ActiveSheet != null) ▸ if (siMain.ActiveSheetIndex == 0)] / FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.ActiveSheetIndex == 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8dd3d66a | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:423 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-775abfa3 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:426 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-77bf5e12 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:426 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d5351f24 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:436 | try ▸ if (dtPeriodFrom.AddYears(6) < dtPeriodTo) | MESSAGE | MessageHelper.GMessageBox | ("MSG00332" , new object[] { "6" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2514635b | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:437 | try ▸ if (dtPeriodFrom.AddYears(6) < dtPeriodTo) | UI_PROP | drpPeriodMonth.MonthText2 | dtPeriodFrom.AddYears(6).ToString("yyyy-MM") | 속성 MonthText2 설정 |  |  |  |
| AC-55fbb2bc | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:438 | try ▸ if (dtPeriodFrom.AddYears(6) < dtPeriodTo) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-da114408 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:445 | try ▸ if (pVersionId == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00283") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0019a6c9 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:446 | try ▸ if (pVersionId == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d02b0a8b | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:451 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-dc33bd50 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:455 | try | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMain) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6e2abf8c | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:476 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-dcf9f37f | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:477 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-28256af7 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:481 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0052_GET_CAPA_REPORT") ⇒ SCP.SCP0052_GET_CAPA_REPORT | 엔드포인트 요청 생성 |  |  |  |
| AC-c64d2f76 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:482 | try ▸ lambda | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-f28851d7 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:483 | try ▸ lambda | DATA_OP | request.Parameters["p_today_yyyymmdd"] | sToday | 행/컬럼 값 대입 |  |  |  |
| AC-64af22ad | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:484 | try ▸ lambda | DATA_OP | request.Parameters["p_from_yyyymm"] | sPeriodMonth1 | 행/컬럼 값 대입 |  |  |  |
| AC-3dde2346 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:485 | try ▸ lambda | DATA_OP | request.Parameters["p_to_yyyymm"] | sPeriodMonth2 | 행/컬럼 값 대입 |  |  |  |
| AC-347c72ce | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:486 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | pDivisionId | 행/컬럼 값 대입 |  |  |  |
| AC-c7a69b06 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:487 | try ▸ lambda | DATA_OP | request.Parameters["p_group"] | pGroup | 행/컬럼 값 대입 |  |  |  |
| AC-caadeaa7 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:488 | try ▸ lambda | DATA_OP | request.Parameters["p_plant_id"] | pPlantId.Equals("ALL") ? DBNull.Value : pPlantId | 행/컬럼 값 대입 |  |  |  |
| AC-2759ec41 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:489 | try ▸ lambda | DATA_OP | request.Parameters["p_factory_id"] | pFactoryId.Equals("ALL") ? DBNull.Value : pFactoryId | 행/컬럼 값 대입 |  |  |  |
| AC-8a5d3291 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:490 | try ▸ lambda | DATA_OP | request.Parameters["p_version_id"] | pVersionId | 행/컬럼 값 대입 |  |  |  |
| AC-ed616773 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:491 | try ▸ lambda | DATA_OP | request.Parameters["p_line_id"] | pLineId.Equals("ALL") ? DBNull.Value : pLineId | 행/컬럼 값 대입 |  |  |  |
| AC-c6ede4ec | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:492 | try ▸ lambda | DATA_OP | request.Parameters["p_operation_id"] | pOperationId.Equals("ALL") ? DBNull.Value : pOperationId | 행/컬럼 값 대입 |  |  |  |
| AC-c464e295 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:493 | try ▸ lambda | DATA_OP | request.Parameters["p_model_id"] | pModelId | 행/컬럼 값 대입 |  |  |  |
| AC-324fab82 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:494 | try ▸ lambda | DATA_OP | request.Parameters["p_item_id"] | pItemId | 행/컬럼 값 대입 |  |  |  |
| AC-e63e77da | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:495 | try ▸ lambda | DATA_OP | request.Parameters["p_nick_name"] | pNickName | 행/컬럼 값 대입 |  |  |  |
| AC-bf729b88 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:496 | try ▸ lambda | DATA_OP | request.Parameters["p_check_loss"] | pCheckLoss | 행/컬럼 값 대입 |  |  |  |
| AC-298721e1 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:497 | try ▸ lambda | DATA_OP | request.Parameters["p_check_line"] | pCheckLine | 행/컬럼 값 대입 |  |  |  |
| AC-8148819f | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:498 | try ▸ lambda | DATA_OP | request.Parameters["p_check_tact"] | pCheckTact | 행/컬럼 값 대입 |  |  |  |
| AC-574c5561 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:499 | try ▸ lambda | DATA_OP | request.Parameters["p_check_yield"] | pCheckYield | 행/컬럼 값 대입 |  |  |  |
| AC-e47f53ce | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:500 | try ▸ lambda | DATA_OP | request.Parameters["p_user_id"] | UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-d3575c5c | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:501 | try ▸ lambda | DATA_OP | request.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-ecbc05f3 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:503 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-6a14ff1d | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:505 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-08b00854 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:519 | try | UI_PROP | dv.Sort | sOrderBy | 속성 Sort 설정 |  |  |  |
| AC-f871082b | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:521 | try | DATA_OP | dsSort.Tables.Add | (dv.ToTable()) | 데이터 객체 조작/조회 |  |  |  |
| AC-2a1bf3bd | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:521 | try | DATA_OP | dv.ToTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-e75e41ee | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:523 | try | GRID_BIND | siMain.Query | (dsSort) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-795e8b1f | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:525 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-25e4146d | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:528 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-0f853068 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:533 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0bdfb318 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:544 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-13880cbe | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:545 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-dc75728d | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:549 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-9935af8a | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:423 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-f5accdef | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:426 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-7d2321a6 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:426 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-eca79dc5 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:436 | try ▸ if (dtPeriodFrom.AddYears(6) < dtPeriodTo) | MESSAGE | MessageHelper.GMessageBox | ("MSG00332" , new object[] { "6" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-06cd71b3 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:437 | try ▸ if (dtPeriodFrom.AddYears(6) < dtPeriodTo) | UI_PROP | drpPeriodMonth.MonthText2 | dtPeriodFrom.AddYears(6).ToString("yyyy-MM") | 속성 MonthText2 설정 |  |  |  |
| AC-425674ea | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:438 | try ▸ if (dtPeriodFrom.AddYears(6) < dtPeriodTo) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1ced1241 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:445 | try ▸ if (pVersionId == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00283") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ad2330bd | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:446 | try ▸ if (pVersionId == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-73e37d12 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:451 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-a25e0a6d | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:455 | try | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMain) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ca5deac8 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:476 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-1a34bd26 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:477 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-51c5b127 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:481 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0052_GET_CAPA_REPORT") ⇒ SCP.SCP0052_GET_CAPA_REPORT | 엔드포인트 요청 생성 |  |  |  |
| AC-f86a1f60 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:482 | try ▸ lambda | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-40d1252e | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:483 | try ▸ lambda | DATA_OP | request.Parameters["p_today_yyyymmdd"] | sToday | 행/컬럼 값 대입 |  |  |  |
| AC-f8311ee9 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:484 | try ▸ lambda | DATA_OP | request.Parameters["p_from_yyyymm"] | sPeriodMonth1 | 행/컬럼 값 대입 |  |  |  |
| AC-f92a8b2e | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:485 | try ▸ lambda | DATA_OP | request.Parameters["p_to_yyyymm"] | sPeriodMonth2 | 행/컬럼 값 대입 |  |  |  |
| AC-12c2b039 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:486 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | division | 행/컬럼 값 대입 |  |  |  |
| AC-16d24909 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:487 | try ▸ lambda | DATA_OP | request.Parameters["p_group"] | pGroup | 행/컬럼 값 대입 |  |  |  |
| AC-476ac318 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:488 | try ▸ lambda | DATA_OP | request.Parameters["p_plant_id"] | pPlantId.Equals("ALL") ? DBNull.Value : pPlantId | 행/컬럼 값 대입 |  |  |  |
| AC-7ea6d6ed | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:489 | try ▸ lambda | DATA_OP | request.Parameters["p_factory_id"] | pFactoryId.Equals("ALL") ? DBNull.Value : pFactoryId | 행/컬럼 값 대입 |  |  |  |
| AC-98ad5f86 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:490 | try ▸ lambda | DATA_OP | request.Parameters["p_version_id"] | pVersionId | 행/컬럼 값 대입 |  |  |  |
| AC-15bf7dfa | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:491 | try ▸ lambda | DATA_OP | request.Parameters["p_line_id"] | pLineId.Equals("ALL") ? DBNull.Value : pLineId | 행/컬럼 값 대입 |  |  |  |
| AC-36ccccba | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:492 | try ▸ lambda | DATA_OP | request.Parameters["p_operation_id"] | pOperationId.Equals("ALL") ? DBNull.Value : pOperationId | 행/컬럼 값 대입 |  |  |  |
| AC-b282091a | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:493 | try ▸ lambda | DATA_OP | request.Parameters["p_model_id"] | pModelId | 행/컬럼 값 대입 |  |  |  |
| AC-47899b60 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:494 | try ▸ lambda | DATA_OP | request.Parameters["p_item_id"] | pItemId | 행/컬럼 값 대입 |  |  |  |
| AC-83b09fe8 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:495 | try ▸ lambda | DATA_OP | request.Parameters["p_nick_name"] | pNickName | 행/컬럼 값 대입 |  |  |  |
| AC-c9f26b2c | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:496 | try ▸ lambda | DATA_OP | request.Parameters["p_check_loss"] | pCheckLoss | 행/컬럼 값 대입 |  |  |  |
| AC-fec45c60 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:497 | try ▸ lambda | DATA_OP | request.Parameters["p_check_line"] | pCheckLine | 행/컬럼 값 대입 |  |  |  |
| AC-a400d969 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:498 | try ▸ lambda | DATA_OP | request.Parameters["p_check_tact"] | pCheckTact | 행/컬럼 값 대입 |  |  |  |
| AC-47fc8752 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:499 | try ▸ lambda | DATA_OP | request.Parameters["p_check_yield"] | pCheckYield | 행/컬럼 값 대입 |  |  |  |
| AC-ceed9169 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:500 | try ▸ lambda | DATA_OP | request.Parameters["p_user_id"] | UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-c6ca3801 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:501 | try ▸ lambda | DATA_OP | request.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-e684235e | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:503 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-0e95c602 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:505 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-ec2669de | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:519 | try | UI_PROP | dv.Sort | sOrderBy | 속성 Sort 설정 |  |  |  |
| AC-24dd20b2 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:521 | try | DATA_OP | dsSort.Tables.Add | (dv.ToTable()) | 데이터 객체 조작/조회 |  |  |  |
| AC-b0898eee | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:521 | try | DATA_OP | dv.ToTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-fe2c7875 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:523 | try | GRID_BIND | siMain.Query | (dsSort) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-8e921271 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:525 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-a9cea0c7 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:528 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-dd005cfc | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:533 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-14ab7045 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:544 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-e3fa1d01 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:545 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-473ac89d | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:549 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0052_CAPA_Report.FindData_TotalYield

진입점: txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ if (siMain.ActiveSheet != null) ▸ else of (siMain.ActiveSheetIndex == 0) ▸ if (siMain.ActiveSheetIndex == 1)] / txtMaterialId.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ if (siMain.ActiveSheet != null) ▸ else of (siMain.ActiveSheetIndex == 0) ▸ if (siMain.ActiveSheetIndex == 1)] / txtNickName.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ if (siMain.ActiveSheet != null) ▸ else of (siMain.ActiveSheetIndex == 0) ▸ if (siMain.ActiveSheetIndex == 1)] / FindButton [if (siMain.ActiveSheet != null) …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a04ee17e | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:555 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-e9ae3bbb | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:558 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-ea58ad13 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:558 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ebde7e2c | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:568 | try ▸ if (dtPeriodFrom.AddYears(6) < dtPeriodTo) | MESSAGE | MessageHelper.GMessageBox | ("MSG00326", new object[] { "6" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a3ded740 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:569 | try ▸ if (dtPeriodFrom.AddYears(6) < dtPeriodTo) | UI_PROP | drpPeriodMonth.MonthText2 | dtPeriodFrom.AddYears(6).ToString("yyyy-MM") | 속성 MonthText2 설정 |  |  |  |
| AC-3b5de504 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:570 | try ▸ if (dtPeriodFrom.AddYears(6) < dtPeriodTo) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4165b403 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:575 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-34cce4db | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:579 | try | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtTotalYield) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-80d53f61 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:594 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-12a4d372 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:595 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-c03ceaba | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:599 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0052_GET_CAPA_REPORT_TOTAL_YIELD") ⇒ SCP.SCP0052_GET_CAPA_REPORT_TOTAL_YIELD | 엔드포인트 요청 생성 |  |  |  |
| AC-ab253fe1 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:600 | try ▸ lambda | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-b5990e72 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:601 | try ▸ lambda | DATA_OP | request.Parameters["p_today_yyyymmdd"] | sToday | 행/컬럼 값 대입 |  |  |  |
| AC-5e6a3737 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:602 | try ▸ lambda | DATA_OP | request.Parameters["p_from_yyyymm"] | sPeriodMonth1 | 행/컬럼 값 대입 |  |  |  |
| AC-40d45bff | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:603 | try ▸ lambda | DATA_OP | request.Parameters["p_to_yyyymm"] | sPeriodMonth2 | 행/컬럼 값 대입 |  |  |  |
| AC-4a0f9491 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:604 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | pDivisionId | 행/컬럼 값 대입 |  |  |  |
| AC-8baa7fe0 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:605 | try ▸ lambda | DATA_OP | request.Parameters["p_group"] | pGroup | 행/컬럼 값 대입 |  |  |  |
| AC-233a0729 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:606 | try ▸ lambda | DATA_OP | request.Parameters["p_plant_id"] | pPlantId.Equals("ALL") ? DBNull.Value : pPlantId | 행/컬럼 값 대입 |  |  |  |
| AC-983ae715 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:607 | try ▸ lambda | DATA_OP | request.Parameters["p_factory_id"] | pFactoryId.Equals("ALL") ? DBNull.Value : pFactoryId | 행/컬럼 값 대입 |  |  |  |
| AC-a6b11484 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:608 | try ▸ lambda | DATA_OP | request.Parameters["p_line_id"] | pLineId.Equals("ALL") ? DBNull.Value : pLineId | 행/컬럼 값 대입 |  |  |  |
| AC-fb4a87eb | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:609 | try ▸ lambda | DATA_OP | request.Parameters["p_model_id"] | pModelId | 행/컬럼 값 대입 |  |  |  |
| AC-bbbf2d37 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:610 | try ▸ lambda | DATA_OP | request.Parameters["p_item_id"] | pItemId | 행/컬럼 값 대입 |  |  |  |
| AC-b0f182d5 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:611 | try ▸ lambda | DATA_OP | request.Parameters["p_nick_name"] | pNickName | 행/컬럼 값 대입 |  |  |  |
| AC-880faf03 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:612 | try ▸ lambda | DATA_OP | request.Parameters["p_user_id"] | UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-ebe05004 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:613 | try ▸ lambda | DATA_OP | request.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-045c2de8 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:615 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-25ec6ff4 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:617 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-c8ad4e02 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:624 | try | GRID_BIND | siMain.Query | (ds.Tables[0]) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-ff9c0eb0 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:626 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-a35c8e90 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:629 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-b877c25f | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:634 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0afd4d86 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:644 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-f1438edc | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:645 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d41570f8 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:649 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-280a7ce1 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:555 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-3cd7a657 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:558 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-bf6690a5 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:558 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-74d7db27 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:568 | try ▸ if (dtPeriodFrom.AddYears(6) < dtPeriodTo) | MESSAGE | MessageHelper.GMessageBox | ("MSG00326", new object[] { "6" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d471ad9d | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:569 | try ▸ if (dtPeriodFrom.AddYears(6) < dtPeriodTo) | UI_PROP | drpPeriodMonth.MonthText2 | dtPeriodFrom.AddYears(6).ToString("yyyy-MM") | 속성 MonthText2 설정 |  |  |  |
| AC-cc127435 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:570 | try ▸ if (dtPeriodFrom.AddYears(6) < dtPeriodTo) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-495e81ca | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:575 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-f404633a | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:579 | try | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtTotalYield) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-700ee1cd | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:594 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-ad6dd4b9 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:595 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-0e34967b | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:599 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0052_GET_CAPA_REPORT_TOTAL_YIELD") ⇒ SCP.SCP0052_GET_CAPA_REPORT_TOTAL_YIELD | 엔드포인트 요청 생성 |  |  |  |
| AC-6ed2542a | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:600 | try ▸ lambda | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-9a52a8e7 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:601 | try ▸ lambda | DATA_OP | request.Parameters["p_today_yyyymmdd"] | sToday | 행/컬럼 값 대입 |  |  |  |
| AC-ec35f015 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:602 | try ▸ lambda | DATA_OP | request.Parameters["p_from_yyyymm"] | sPeriodMonth1 | 행/컬럼 값 대입 |  |  |  |
| AC-d7ca7422 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:603 | try ▸ lambda | DATA_OP | request.Parameters["p_to_yyyymm"] | sPeriodMonth2 | 행/컬럼 값 대입 |  |  |  |
| AC-69f28067 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:604 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | division | 행/컬럼 값 대입 |  |  |  |
| AC-316327b1 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:605 | try ▸ lambda | DATA_OP | request.Parameters["p_group"] | pGroup | 행/컬럼 값 대입 |  |  |  |
| AC-03915541 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:606 | try ▸ lambda | DATA_OP | request.Parameters["p_plant_id"] | pPlantId.Equals("ALL") ? DBNull.Value : pPlantId | 행/컬럼 값 대입 |  |  |  |
| AC-ddb441f8 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:607 | try ▸ lambda | DATA_OP | request.Parameters["p_factory_id"] | pFactoryId.Equals("ALL") ? DBNull.Value : pFactoryId | 행/컬럼 값 대입 |  |  |  |
| AC-b084f893 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:608 | try ▸ lambda | DATA_OP | request.Parameters["p_line_id"] | pLineId.Equals("ALL") ? DBNull.Value : pLineId | 행/컬럼 값 대입 |  |  |  |
| AC-61dcbfe5 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:609 | try ▸ lambda | DATA_OP | request.Parameters["p_model_id"] | pModelId | 행/컬럼 값 대입 |  |  |  |
| AC-7405ee31 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:610 | try ▸ lambda | DATA_OP | request.Parameters["p_item_id"] | pItemId | 행/컬럼 값 대입 |  |  |  |
| AC-00a1aaf6 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:611 | try ▸ lambda | DATA_OP | request.Parameters["p_nick_name"] | pNickName | 행/컬럼 값 대입 |  |  |  |
| AC-1caeed91 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:612 | try ▸ lambda | DATA_OP | request.Parameters["p_user_id"] | UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-f33678af | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:613 | try ▸ lambda | DATA_OP | request.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-a7157dc4 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:615 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-1ef00ffd | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:617 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-a10f6de6 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:624 | try | GRID_BIND | siMain.Query | (ds.Tables[0]) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-5e76eae3 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:626 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-1f54d57e | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:629 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-9f855741 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:634 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f3cc78e8 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:644 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-8ab478f2 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:645 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-fd012215 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:649 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0052_CAPA_Report.FindData_YieldMonitoring

진입점: txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ if (siMain.ActiveSheet != null) ▸ else of (siMain.ActiveSheetIndex == 0) ▸ else of (siMain.ActiveSheetIndex == 1)] / txtMaterialId.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ if (siMain.ActiveSheet != null) ▸ else of (siMain.ActiveSheetIndex == 0) ▸ else of (siMain.ActiveSheetIndex == 1)] / txtNickName.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ if (siMain.ActiveSheet != null) ▸ else of (siMain.ActiveSheetIndex == 0) ▸ else of (siMain.ActiveSheetIndex == 1)] / FindButton [if (siMain.Active…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a7db3f21 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:658 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-baee8278 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:661 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-12cae377 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:661 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-aa0cd506 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:671 | try ▸ if (dtPeriodFrom.AddYears(6) < dtPeriodTo) | MESSAGE | MessageHelper.GMessageBox | ("MSG00326", new object[] { "6" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f6b67643 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:672 | try ▸ if (dtPeriodFrom.AddYears(6) < dtPeriodTo) | UI_PROP | drpPeriodMonth.MonthText2 | dtPeriodFrom.AddYears(6).ToString("yyyy-MM") | 속성 MonthText2 설정 |  |  |  |
| AC-0dedca7e | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:673 | try ▸ if (dtPeriodFrom.AddYears(6) < dtPeriodTo) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0bad685c | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:678 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-b87bc723 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:682 | try | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtYieldMonitoring) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-85d07064 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:699 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-efa764dd | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:700 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f3450b0b | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:704 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0052_GET_CAPA_REPORT_YIELD_MONITORING") ⇒ SCP.SCP0052_GET_CAPA_REPORT_YIELD_MONITORING | 엔드포인트 요청 생성 |  |  |  |
| AC-8fe8121f | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:705 | try ▸ lambda | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-e74ca074 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:707 | try ▸ lambda | DATA_OP | request.Parameters["p_from_yyyymm"] | sPeriodMonth1 | 행/컬럼 값 대입 |  |  |  |
| AC-dc52477f | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:708 | try ▸ lambda | DATA_OP | request.Parameters["p_to_yyyymm"] | sPeriodMonth2 | 행/컬럼 값 대입 |  |  |  |
| AC-8fd8a7f8 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:709 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | pDivisionId | 행/컬럼 값 대입 |  |  |  |
| AC-97d6c812 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:710 | try ▸ lambda | DATA_OP | request.Parameters["p_group"] | pGroup | 행/컬럼 값 대입 |  |  |  |
| AC-5fe66888 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:711 | try ▸ lambda | DATA_OP | request.Parameters["p_plant_id"] | pPlantId.Equals("ALL") ? DBNull.Value : pPlantId | 행/컬럼 값 대입 |  |  |  |
| AC-95300042 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:712 | try ▸ lambda | DATA_OP | request.Parameters["p_factory_id"] | pFactoryId.Equals("ALL") ? DBNull.Value : pFactoryId | 행/컬럼 값 대입 |  |  |  |
| AC-c3c818d1 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:713 | try ▸ lambda | DATA_OP | request.Parameters["p_line_id"] | pLineId.Equals("ALL") ? DBNull.Value : pLineId | 행/컬럼 값 대입 |  |  |  |
| AC-39c193e3 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:714 | try ▸ lambda | DATA_OP | request.Parameters["p_model_id"] | pModelId | 행/컬럼 값 대입 |  |  |  |
| AC-f6b6cebd | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:715 | try ▸ lambda | DATA_OP | request.Parameters["p_item_id"] | pItemId | 행/컬럼 값 대입 |  |  |  |
| AC-a6eb4779 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:716 | try ▸ lambda | DATA_OP | request.Parameters["p_nick_name"] | pNickName | 행/컬럼 값 대입 |  |  |  |
| AC-5e4c5501 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:717 | try ▸ lambda | DATA_OP | request.Parameters["p_check_production"] | pCheckProduction | 행/컬럼 값 대입 |  |  |  |
| AC-2942cb5a | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:718 | try ▸ lambda | DATA_OP | request.Parameters["p_check_accuracy"] | pCheckAccuracy | 행/컬럼 값 대입 |  |  |  |
| AC-0057287f | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:719 | try ▸ lambda | DATA_OP | request.Parameters["p_user_id"] | UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-94d8ca37 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:720 | try ▸ lambda | DATA_OP | request.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-ad57bb91 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:722 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-0f8a3ab5 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:724 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-f8fc6c5f | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:731 | try | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-ec677da2 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:733 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-54519e30 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:736 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-796d5efa | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:741 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3acb096f | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:752 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-2ede10ae | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:753 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-651e9f6a | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:757 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-4aeea27b | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:658 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-845ed5fe | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:661 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-61c35632 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:661 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f8e750fd | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:671 | try ▸ if (dtPeriodFrom.AddYears(6) < dtPeriodTo) | MESSAGE | MessageHelper.GMessageBox | ("MSG00326", new object[] { "6" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-fa659124 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:672 | try ▸ if (dtPeriodFrom.AddYears(6) < dtPeriodTo) | UI_PROP | drpPeriodMonth.MonthText2 | dtPeriodFrom.AddYears(6).ToString("yyyy-MM") | 속성 MonthText2 설정 |  |  |  |
| AC-15b46eac | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:673 | try ▸ if (dtPeriodFrom.AddYears(6) < dtPeriodTo) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5365f405 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:678 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-a0098026 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:682 | try | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtYieldMonitoring) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-93639356 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:699 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-36dfadca | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:700 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-115defd6 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:704 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0052_GET_CAPA_REPORT_YIELD_MONITORING") ⇒ SCP.SCP0052_GET_CAPA_REPORT_YIELD_MONITORING | 엔드포인트 요청 생성 |  |  |  |
| AC-310e2eae | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:705 | try ▸ lambda | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-158135d9 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:707 | try ▸ lambda | DATA_OP | request.Parameters["p_from_yyyymm"] | sPeriodMonth1 | 행/컬럼 값 대입 |  |  |  |
| AC-a47fdf8a | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:708 | try ▸ lambda | DATA_OP | request.Parameters["p_to_yyyymm"] | sPeriodMonth2 | 행/컬럼 값 대입 |  |  |  |
| AC-728cf7db | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:709 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | division | 행/컬럼 값 대입 |  |  |  |
| AC-692d9716 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:710 | try ▸ lambda | DATA_OP | request.Parameters["p_group"] | pGroup | 행/컬럼 값 대입 |  |  |  |
| AC-9278d000 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:711 | try ▸ lambda | DATA_OP | request.Parameters["p_plant_id"] | pPlantId.Equals("ALL") ? DBNull.Value : pPlantId | 행/컬럼 값 대입 |  |  |  |
| AC-97c05d5e | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:712 | try ▸ lambda | DATA_OP | request.Parameters["p_factory_id"] | pFactoryId.Equals("ALL") ? DBNull.Value : pFactoryId | 행/컬럼 값 대입 |  |  |  |
| AC-ef5d5205 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:713 | try ▸ lambda | DATA_OP | request.Parameters["p_line_id"] | pLineId.Equals("ALL") ? DBNull.Value : pLineId | 행/컬럼 값 대입 |  |  |  |
| AC-9e116ce5 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:714 | try ▸ lambda | DATA_OP | request.Parameters["p_model_id"] | pModelId | 행/컬럼 값 대입 |  |  |  |
| AC-f0f77c2d | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:715 | try ▸ lambda | DATA_OP | request.Parameters["p_item_id"] | pItemId | 행/컬럼 값 대입 |  |  |  |
| AC-babc0d83 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:716 | try ▸ lambda | DATA_OP | request.Parameters["p_nick_name"] | pNickName | 행/컬럼 값 대입 |  |  |  |
| AC-582861e0 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:717 | try ▸ lambda | DATA_OP | request.Parameters["p_check_production"] | pCheckProduction | 행/컬럼 값 대입 |  |  |  |
| AC-0711af2e | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:718 | try ▸ lambda | DATA_OP | request.Parameters["p_check_accuracy"] | pCheckAccuracy | 행/컬럼 값 대입 |  |  |  |
| AC-cd178189 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:719 | try ▸ lambda | DATA_OP | request.Parameters["p_user_id"] | UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-3488e1f0 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:720 | try ▸ lambda | DATA_OP | request.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-f132dae4 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:722 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-dae052fd | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:724 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-fb9dd860 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:731 | try | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-cbbe13df | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:733 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-ff9618c2 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:736 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-036b6efe | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:741 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-445a896c | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:752 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-e26f96fe | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:753 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-90fbc166 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:757 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0052_CAPA_Report.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-01ca93f7 | this.Load | SCP0052_CAPA_Report.cs:140 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-777e6d98 | this.Load | SCP0052_CAPA_Report.cs:141 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0052_CAPA_Report.GetDayRange

진입점: this.Load / this.spdMain.ActiveSheetChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-05e5e44d | this.Load 외 1 | SCP0052_CAPA_Report.cs:887 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0052_GET_DAY_RANGE") ⇒ SCP.SCP0052_GET_DAY_RANGE | 엔드포인트 요청 생성 |  |  |  |
| AC-f897162c | this.Load 외 1 | SCP0052_CAPA_Report.cs:888 |  | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-390b92c7 | this.Load 외 1 | SCP0052_CAPA_Report.cs:889 |  | DATA_OP | request.Parameters["p_month"] | 13 | 행/컬럼 값 대입 |  |  |  |
| AC-ec476f30 | this.Load 외 1 | SCP0052_CAPA_Report.cs:891 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-fc5aa34b | this.Load 외 1 | SCP0052_CAPA_Report.cs:891 |  | RETURN | return client.ExecuteDataSet(request).DataSet.Tables[0]; |  | 처리 중단/반환 |  |  |  |
| AC-e3a074ce | this.Load 외 1 | SCP0052_CAPA_Report.cs:887 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0052_GET_DAY_RANGE") ⇒ SCP.SCP0052_GET_DAY_RANGE | 엔드포인트 요청 생성 |  |  |  |
| AC-9ee91e9a | this.Load 외 1 | SCP0052_CAPA_Report.cs:888 |  | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-83bcb14b | this.Load 외 1 | SCP0052_CAPA_Report.cs:889 |  | DATA_OP | request.Parameters["p_month"] | 13 | 행/컬럼 값 대입 |  |  |  |
| AC-886a26cd | this.Load 외 1 | SCP0052_CAPA_Report.cs:891 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-2f017177 | this.Load 외 1 | SCP0052_CAPA_Report.cs:891 |  | RETURN | return client.ExecuteDataSet(request).DataSet.Tables[0]; |  | 처리 중단/반환 |  |  |  |

## SCP0052_CAPA_Report.GetSpdTitle

진입점: this.Load / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)] / txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ if (siMain.ActiveSheet != null) ▸ if (siMain.ActiveSheetIndex == 0) ▸ try] / txtMaterialId.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ if (siMain.ActiveSheet != null) ▸ if (siMain.ActiveSheetIndex == 0) ▸ try] / txtNickName.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ if (siMain.ActiveSheet != null) ▸ if (siMain.ActiveSheetIndex == 0) ▸ try] / FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.ActiveSheetInd…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2cab4055 | this.Load 외 5 | SCP0052_CAPA_Report.cs:765 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0052_GET_SHEET_CALENDAR") ⇒ SCP.SCP0052_GET_SHEET_CALENDAR | 엔드포인트 요청 생성 |  |  |  |
| AC-3413c7b7 | this.Load 외 5 | SCP0052_CAPA_Report.cs:769 |  | DATA_OP | request.Parameters["p_today_yyyymmdd"] | sToday | 행/컬럼 값 대입 |  |  |  |
| AC-d7ca12a3 | this.Load 외 5 | SCP0052_CAPA_Report.cs:770 |  | DATA_OP | request.Parameters["p_from_yyyymm"] | sPeriodMonth[0] | 행/컬럼 값 대입 |  |  |  |
| AC-aad1c178 | this.Load 외 5 | SCP0052_CAPA_Report.cs:771 |  | DATA_OP | request.Parameters["p_to_yyyymm"] | sPeriodMonth[1] | 행/컬럼 값 대입 |  |  |  |
| AC-0875bf86 | this.Load 외 5 | SCP0052_CAPA_Report.cs:773 |  | FLAG | dsSpdTitle | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-5ff0a572 | this.Load 외 5 | SCP0052_CAPA_Report.cs:773 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-b2c180ff | this.Load 외 5 | SCP0052_CAPA_Report.cs:765 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0052_GET_SHEET_CALENDAR") ⇒ SCP.SCP0052_GET_SHEET_CALENDAR | 엔드포인트 요청 생성 |  |  |  |
| AC-6f339470 | this.Load 외 5 | SCP0052_CAPA_Report.cs:769 |  | DATA_OP | request.Parameters["p_today_yyyymmdd"] | sToday | 행/컬럼 값 대입 |  |  |  |
| AC-8901d1d8 | this.Load 외 5 | SCP0052_CAPA_Report.cs:770 |  | DATA_OP | request.Parameters["p_from_yyyymm"] | sPeriodMonth[0] | 행/컬럼 값 대입 |  |  |  |
| AC-955dedff | this.Load 외 5 | SCP0052_CAPA_Report.cs:771 |  | DATA_OP | request.Parameters["p_to_yyyymm"] | sPeriodMonth[1] | 행/컬럼 값 대입 |  |  |  |
| AC-2026dc5c | this.Load 외 5 | SCP0052_CAPA_Report.cs:773 |  | FLAG | dsSpdTitle | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-7b13a457 | this.Load 외 5 | SCP0052_CAPA_Report.cs:773 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SCP0052_CAPA_Report.GetSpdTitle2

진입점: this.Load [if (sheetName.Equals(SpdSheet.shtYieldMonitoring))] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (sheetName.Equals(SpdSheet.shtYieldMonitoring))] / txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ if (siMain.ActiveSheet != null) ▸ if (siMain.ActiveSheetIndex == 0) ▸ try ▸ if (sheetName.Equals(SpdSheet.shtYieldMonitoring))] / txtMaterialId.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ if (siMain.ActiveSheet != null) ▸ if (siMain.ActiveSheetIndex == 0) ▸ try ▸ if (sheetName.Equals(SpdSheet.shtYieldMonitoring))] / txtNickNa…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-95208601 | this.Load [if (sheetName.Equals(SpdSheet.shtYieldMonitoring)… 외 5 | SCP0052_CAPA_Report.cs:799 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0052_GET_SHEET_CALENDAR_YIELD_MONITORING") ⇒ SCP.SCP0052_GET_SHEET_CALENDAR_YIELD_MONITORING | 엔드포인트 요청 생성 |  |  |  |
| AC-af280d53 | this.Load [if (sheetName.Equals(SpdSheet.shtYieldMonitoring)… 외 5 | SCP0052_CAPA_Report.cs:804 |  | DATA_OP | request.Parameters["p_from_yyyymm"] | sPeriodMonth[0] | 행/컬럼 값 대입 |  |  |  |
| AC-6821727d | this.Load [if (sheetName.Equals(SpdSheet.shtYieldMonitoring)… 외 5 | SCP0052_CAPA_Report.cs:805 |  | DATA_OP | request.Parameters["p_to_yyyymm"] | sPeriodMonth[1] | 행/컬럼 값 대입 |  |  |  |
| AC-047b971c | this.Load [if (sheetName.Equals(SpdSheet.shtYieldMonitoring)… 외 5 | SCP0052_CAPA_Report.cs:806 |  | DATA_OP | request.Parameters["p_check_accuracy"] | pCheckAccuracy | 행/컬럼 값 대입 |  |  |  |
| AC-a9ef7aa3 | this.Load [if (sheetName.Equals(SpdSheet.shtYieldMonitoring)… 외 5 | SCP0052_CAPA_Report.cs:808 |  | FLAG | dsSpdTitle2 | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-bd4b5cea | this.Load [if (sheetName.Equals(SpdSheet.shtYieldMonitoring)… 외 5 | SCP0052_CAPA_Report.cs:808 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f96eafbc | this.Load [if (sheetName.Equals(SpdSheet.shtYieldMonitoring)… 외 5 | SCP0052_CAPA_Report.cs:799 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0052_GET_SHEET_CALENDAR_YIELD_MONITORING") ⇒ SCP.SCP0052_GET_SHEET_CALENDAR_YIELD_MONITORING | 엔드포인트 요청 생성 |  |  |  |
| AC-7542cf2c | this.Load [if (sheetName.Equals(SpdSheet.shtYieldMonitoring)… 외 5 | SCP0052_CAPA_Report.cs:804 |  | DATA_OP | request.Parameters["p_from_yyyymm"] | sPeriodMonth[0] | 행/컬럼 값 대입 |  |  |  |
| AC-cbc83b04 | this.Load [if (sheetName.Equals(SpdSheet.shtYieldMonitoring)… 외 5 | SCP0052_CAPA_Report.cs:805 |  | DATA_OP | request.Parameters["p_to_yyyymm"] | sPeriodMonth[1] | 행/컬럼 값 대입 |  |  |  |
| AC-2ef98289 | this.Load [if (sheetName.Equals(SpdSheet.shtYieldMonitoring)… 외 5 | SCP0052_CAPA_Report.cs:806 |  | DATA_OP | request.Parameters["p_check_accuracy"] | pCheckAccuracy | 행/컬럼 값 대입 |  |  |  |
| AC-eb618288 | this.Load [if (sheetName.Equals(SpdSheet.shtYieldMonitoring)… 외 5 | SCP0052_CAPA_Report.cs:808 |  | FLAG | dsSpdTitle2 | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-819745c3 | this.Load [if (sheetName.Equals(SpdSheet.shtYieldMonitoring)… 외 5 | SCP0052_CAPA_Report.cs:808 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SCP0052_CAPA_Report.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-04f56730 | this.Load | SCP0052_CAPA_Report.cs:157 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-def6d9a3 | this.Load | SCP0052_CAPA_Report.cs:160 | if (dtMyDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-8606e5f9 | this.Load | SCP0052_CAPA_Report.cs:163 |  | DATA_OP | dtMyDivision.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-3038bb80 | this.Load | SCP0052_CAPA_Report.cs:164 |  | DATA_OP | tmpDivision.Columns.Add | ("SORT_ORDER") | 데이터 객체 조작/조회 |  |  |  |
| AC-9c6bbc14 | this.Load | SCP0052_CAPA_Report.cs:165 |  | CALL_EXT | tmpDivision.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-5b59fabd | this.Load | SCP0052_CAPA_Report.cs:169 | foreach (DataRow dr in dtMyDivision.Rows) | DATA_OP | tmpDivision.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-30f7627d | this.Load | SCP0052_CAPA_Report.cs:170 | foreach (DataRow dr in dtMyDivision.Rows) | DATA_OP | dataRow["CODE"] | dr["CODE"] | 행/컬럼 값 대입 |  |  |  |
| AC-1fc3c915 | this.Load | SCP0052_CAPA_Report.cs:171 | foreach (DataRow dr in dtMyDivision.Rows) | DATA_OP | dataRow["NAME"] | dr["NAME"] | 행/컬럼 값 대입 |  |  |  |
| AC-7bb36e2f | this.Load | SCP0052_CAPA_Report.cs:173 | foreach (DataRow dr in dtMyDivision.Rows) | DATA_OP | dataRow["SORT_ORDER"] | HardCodeService.MatchCodeFp("SCP0049_CAPA", "DIVORDER1", dr["CODE"]) ? 1 : HardCodeService… | 행/컬럼 값 대입 |  |  |  |
| AC-edd26e6e | this.Load | SCP0052_CAPA_Report.cs:173 | foreach (DataRow dr in dtMyDivision.Rows) | CALL_EXT | HardCodeService.MatchCodeFp | ("SCP0049_CAPA", "DIVORDER1", dr["CODE"]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-26e19a7a | this.Load | SCP0052_CAPA_Report.cs:173 | foreach (DataRow dr in dtMyDivision.Rows) | CALL_EXT | HardCodeService.MatchCodeFp | ("SCP0049_CAPA", "DIVORDER2", dr["CODE"]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-269dafce | this.Load | SCP0052_CAPA_Report.cs:175 | foreach (DataRow dr in dtMyDivision.Rows) | CALL_EXT | tmpDivision.Rows.InsertAt | (dataRow, 0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5b6610df | this.Load | SCP0052_CAPA_Report.cs:178 |  | UI_PROP | tmpDivision.DefaultView.Sort | "SORT_ORDER Asc" | 속성 Sort 설정 |  |  |  |
| AC-895fcde8 | this.Load | SCP0052_CAPA_Report.cs:179 |  | DATA_OP | tmpDivision.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-4e1a00f3 | this.Load | SCP0052_CAPA_Report.cs:181 |  | DATA_OP | tmpDivision.DefaultView.ToTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-c7830c4a | this.Load | SCP0052_CAPA_Report.cs:183 |  | STATE_RESET | dtMyDivision.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-e2e2a68b | this.Load | SCP0052_CAPA_Report.cs:184 |  | FLAG | dtMyDivision | dtDivisionOrder.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-c2787317 | this.Load | SCP0052_CAPA_Report.cs:184 |  | DATA_OP | dtDivisionOrder.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-29c1fcc1 | this.Load | SCP0052_CAPA_Report.cs:187 |  | LIST_REBIND | clsCtrl.setListBox | (dtMyDivision, cboDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-fe6cf331 | this.Load | SCP0052_CAPA_Report.cs:188 |  | LIST_REBIND | clsCtrl.setListBox | (dtMyDivision, cboDivision1, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-7e3f0bf0 | this.Load | SCP0052_CAPA_Report.cs:190 |  | FLAG | dtShopGroup1 | Data_SCP.Common(Data_SCP.Type.ShopGroupId, false, "") | 화면 필드/플래그 변경 |  |  |  |
| AC-ed6be3e2 | this.Load | SCP0052_CAPA_Report.cs:190 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.ShopGroupId, false, "") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-37eb78c9 | this.Load | SCP0052_CAPA_Report.cs:191 |  | LIST_REBIND | clsCtrl.setListBox | (dtShopGroup1, cboGroup1, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-76c1923e | this.Load | SCP0052_CAPA_Report.cs:193 |  | FLAG | dtPlantByGroup1 | Data_SCP.Common(Data_SCP.Type.PlantByGroup, false, "", "") | 화면 필드/플래그 변경 |  |  |  |
| AC-00779a9b | this.Load | SCP0052_CAPA_Report.cs:193 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.PlantByGroup, false, "", "") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ffc0634a | this.Load | SCP0052_CAPA_Report.cs:194 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantByGroup1, clbPlant1, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-4dcd5d4d | this.Load | SCP0052_CAPA_Report.cs:196 |  | UI_PROP | layoutDivision.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-cb2d4768 | this.Load | SCP0052_CAPA_Report.cs:197 |  | UI_PROP | layoutGroup.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-02952e6a | this.Load | SCP0052_CAPA_Report.cs:198 |  | UI_PROP | layoutPlant.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-a524f913 | this.Load | SCP0052_CAPA_Report.cs:200 |  | UI_PROP | layoutDivision1.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-6fbd7260 | this.Load | SCP0052_CAPA_Report.cs:201 |  | UI_PROP | layoutGroup1.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-9e91ffed | this.Load | SCP0052_CAPA_Report.cs:202 |  | UI_PROP | layoutPlant1.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-57dac986 | this.Load | SCP0052_CAPA_Report.cs:204 |  | UI_PROP | layoutChkProduction.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-e3cb0759 | this.Load | SCP0052_CAPA_Report.cs:205 |  | UI_PROP | layoutChkAccuracy.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-81a68ac1 | this.Load | SCP0052_CAPA_Report.cs:208 |  | VALUE_SET | checkLoss.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-01fa452f | this.Load | SCP0052_CAPA_Report.cs:209 |  | VALUE_SET | checkLineAssign.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-fa81d421 | this.Load | SCP0052_CAPA_Report.cs:210 |  | VALUE_SET | checkTactTime.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-b076f0c3 | this.Load | SCP0052_CAPA_Report.cs:211 |  | VALUE_SET | checkYield.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-aef4b4d6 | this.Load | SCP0052_CAPA_Report.cs:212 |  | VALUE_SET | checkProduction.Checked | false | 컨트롤 값 설정 |  |  |  |
| AC-fdfc1f65 | this.Load | SCP0052_CAPA_Report.cs:213 |  | VALUE_SET | checkAccuracy.Checked | false | 컨트롤 값 설정 |  |  |  |
| AC-060e60a8 | this.Load | SCP0052_CAPA_Report.cs:234 | if (dt != null && dt.Rows.Count > 0) | UI_PROP | drpPeriodMonth.MonthText1 | dt.Rows[0]["FROM_VALUE"].ToString().Substring(0, 6) | 속성 MonthText1 설정 |  |  |  |
| AC-b5f38020 | this.Load | SCP0052_CAPA_Report.cs:235 | if (dt != null && dt.Rows.Count > 0) | UI_PROP | drpPeriodMonth.MonthText2 | dt.Rows[0]["TO_VALUE"].ToString().Substring(0, 6) | 속성 MonthText2 설정 |  |  |  |
| AC-4f5bd5f0 | this.Load | SCP0052_CAPA_Report.cs:237 | if (dt != null && dt.Rows.Count > 0) | UI_PROP | drpPeriodMonth.MonthMin1 | dt.Rows[0]["FROM_VALUE"].ToString().Substring(0, 6) | 속성 MonthMin1 설정 |  |  |  |
| AC-ab5a4eac | this.Load | SCP0052_CAPA_Report.cs:238 | if (dt != null && dt.Rows.Count > 0) | UI_PROP | drpPeriodMonth.MonthMax1 | dt.Rows[0]["FROM_VALUE"].ToString().Substring(0, 6) | 속성 MonthMax1 설정 |  |  |  |
| AC-02073ca3 | this.Load | SCP0052_CAPA_Report.cs:240 | if (dt != null && dt.Rows.Count > 0) | UI_PROP | drpPeriodMonth.MonthMin2 | dt.Rows[0]["FROM_VALUE"].ToString().Substring(0, 6) | 속성 MonthMin2 설정 |  |  |  |
| AC-a8dd86c7 | this.Load | SCP0052_CAPA_Report.cs:247 | if (dt != null && dt.Rows.Count > 0) | UI_PROP | drpPeriodMonth.MonthMax2 | dateMaxMonth.Substring(0, 6) | 속성 MonthMax2 설정 |  |  |  |
| AC-02c18997 | this.Load | SCP0052_CAPA_Report.cs:158 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-d1fd378f | this.Load | SCP0052_CAPA_Report.cs:161 | if (dtMyDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-2830dbcd | this.Load | SCP0052_CAPA_Report.cs:164 |  | DATA_OP | dtMyDivision.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-e5a3b66b | this.Load | SCP0052_CAPA_Report.cs:165 |  | DATA_OP | tmpDivision.Columns.Add | ("SORT_ORDER") | 데이터 객체 조작/조회 |  |  |  |
| AC-deba9147 | this.Load | SCP0052_CAPA_Report.cs:166 |  | CALL_EXT | tmpDivision.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-84e87b1a | this.Load | SCP0052_CAPA_Report.cs:170 | foreach (DataRow dr in dtMyDivision.Rows) | DATA_OP | tmpDivision.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-f6093408 | this.Load | SCP0052_CAPA_Report.cs:171 | foreach (DataRow dr in dtMyDivision.Rows) | DATA_OP | dataRow["CODE"] | dr["CODE"] | 행/컬럼 값 대입 |  |  |  |
| AC-0ed44409 | this.Load | SCP0052_CAPA_Report.cs:172 | foreach (DataRow dr in dtMyDivision.Rows) | DATA_OP | dataRow["NAME"] | dr["NAME"] | 행/컬럼 값 대입 |  |  |  |
| AC-2824c733 | this.Load | SCP0052_CAPA_Report.cs:173 | foreach (DataRow dr in dtMyDivision.Rows) | DATA_OP | dataRow["SORT_ORDER"] | dr["CODE"].ToString() == "81" ? 1 : dr["CODE"].ToString() == "40" ? 2 : 3 | 행/컬럼 값 대입 |  |  |  |
| AC-5d988b3f | this.Load | SCP0052_CAPA_Report.cs:175 | foreach (DataRow dr in dtMyDivision.Rows) | CALL_EXT | tmpDivision.Rows.InsertAt | (dataRow, 0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-8209b920 | this.Load | SCP0052_CAPA_Report.cs:178 |  | UI_PROP | tmpDivision.DefaultView.Sort | "SORT_ORDER Asc" | 속성 Sort 설정 |  |  |  |
| AC-7b4c9f45 | this.Load | SCP0052_CAPA_Report.cs:179 |  | DATA_OP | tmpDivision.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-b2cb6e43 | this.Load | SCP0052_CAPA_Report.cs:181 |  | DATA_OP | tmpDivision.DefaultView.ToTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-f3e0df51 | this.Load | SCP0052_CAPA_Report.cs:183 |  | STATE_RESET | dtMyDivision.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-31fa8272 | this.Load | SCP0052_CAPA_Report.cs:184 |  | FLAG | dtMyDivision | dtDivisionOrder.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-2da0fb7b | this.Load | SCP0052_CAPA_Report.cs:184 |  | DATA_OP | dtDivisionOrder.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-3177e520 | this.Load | SCP0052_CAPA_Report.cs:187 |  | LIST_REBIND | clsCtrl.setListBox | (dtMyDivision, cboDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-d1f4b194 | this.Load | SCP0052_CAPA_Report.cs:188 |  | LIST_REBIND | clsCtrl.setListBox | (dtMyDivision, cboDivision1, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-6de3510d | this.Load | SCP0052_CAPA_Report.cs:190 |  | FLAG | dtShopGroup1 | Data_SCP.Common(Data_SCP.Type.ShopGroupId, false, "") | 화면 필드/플래그 변경 |  |  |  |
| AC-5381d1c1 | this.Load | SCP0052_CAPA_Report.cs:190 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.ShopGroupId, false, "") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-044ef886 | this.Load | SCP0052_CAPA_Report.cs:191 |  | LIST_REBIND | clsCtrl.setListBox | (dtShopGroup1, cboGroup1, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-5e5e01e2 | this.Load | SCP0052_CAPA_Report.cs:193 |  | FLAG | dtPlantByGroup1 | Data_SCP.Common(Data_SCP.Type.PlantByGroup, false, "", "") | 화면 필드/플래그 변경 |  |  |  |
| AC-a5227c8c | this.Load | SCP0052_CAPA_Report.cs:193 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.PlantByGroup, false, "", "") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-cfce2e11 | this.Load | SCP0052_CAPA_Report.cs:194 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantByGroup1, clbPlant1, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-350cff19 | this.Load | SCP0052_CAPA_Report.cs:196 |  | UI_PROP | layoutDivision.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-e646a273 | this.Load | SCP0052_CAPA_Report.cs:197 |  | UI_PROP | layoutGroup.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-9dbc3dd3 | this.Load | SCP0052_CAPA_Report.cs:198 |  | UI_PROP | layoutPlant.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-ee97d288 | this.Load | SCP0052_CAPA_Report.cs:200 |  | UI_PROP | layoutDivision1.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-1679da7d | this.Load | SCP0052_CAPA_Report.cs:201 |  | UI_PROP | layoutGroup1.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-5410d3ce | this.Load | SCP0052_CAPA_Report.cs:202 |  | UI_PROP | layoutPlant1.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-1db78878 | this.Load | SCP0052_CAPA_Report.cs:204 |  | UI_PROP | layoutChkProduction.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-93a84ab3 | this.Load | SCP0052_CAPA_Report.cs:205 |  | UI_PROP | layoutChkAccuracy.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-c192bc15 | this.Load | SCP0052_CAPA_Report.cs:208 |  | VALUE_SET | checkLoss.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-557d423f | this.Load | SCP0052_CAPA_Report.cs:209 |  | VALUE_SET | checkLineAssign.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-1288d92a | this.Load | SCP0052_CAPA_Report.cs:210 |  | VALUE_SET | checkTactTime.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-36737d95 | this.Load | SCP0052_CAPA_Report.cs:211 |  | VALUE_SET | checkYield.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-8777764a | this.Load | SCP0052_CAPA_Report.cs:212 |  | VALUE_SET | checkProduction.Checked | false | 컨트롤 값 설정 |  |  |  |
| AC-389e905d | this.Load | SCP0052_CAPA_Report.cs:213 |  | VALUE_SET | checkAccuracy.Checked | false | 컨트롤 값 설정 |  |  |  |
| AC-bccf7693 | this.Load | SCP0052_CAPA_Report.cs:234 | if (dt != null && dt.Rows.Count > 0) | UI_PROP | drpPeriodMonth.MonthText1 | dt.Rows[0]["FROM_VALUE"].ToString().Substring(0, 6) | 속성 MonthText1 설정 |  |  |  |
| AC-cb124927 | this.Load | SCP0052_CAPA_Report.cs:235 | if (dt != null && dt.Rows.Count > 0) | UI_PROP | drpPeriodMonth.MonthText2 | dt.Rows[0]["TO_VALUE"].ToString().Substring(0, 6) | 속성 MonthText2 설정 |  |  |  |
| AC-36237455 | this.Load | SCP0052_CAPA_Report.cs:237 | if (dt != null && dt.Rows.Count > 0) | UI_PROP | drpPeriodMonth.MonthMin1 | dt.Rows[0]["FROM_VALUE"].ToString().Substring(0, 6) | 속성 MonthMin1 설정 |  |  |  |
| AC-2c5bf2d0 | this.Load | SCP0052_CAPA_Report.cs:238 | if (dt != null && dt.Rows.Count > 0) | UI_PROP | drpPeriodMonth.MonthMax1 | dt.Rows[0]["FROM_VALUE"].ToString().Substring(0, 6) | 속성 MonthMax1 설정 |  |  |  |
| AC-1d4650f7 | this.Load | SCP0052_CAPA_Report.cs:240 | if (dt != null && dt.Rows.Count > 0) | UI_PROP | drpPeriodMonth.MonthMin2 | dt.Rows[0]["FROM_VALUE"].ToString().Substring(0, 6) | 속성 MonthMin2 설정 |  |  |  |
| AC-a8a4ca17 | this.Load | SCP0052_CAPA_Report.cs:247 | if (dt != null && dt.Rows.Count > 0) | UI_PROP | drpPeriodMonth.MonthMax2 | dateMaxMonth.Substring(0, 6) | 속성 MonthMax2 설정 |  |  |  |

## SCP0052_CAPA_Report.InitSpread

진입점: this.Load / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f9cb7273 | this.Load 외 1 | SCP0052_CAPA_Report.cs:310 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-301e6900 | this.Load 외 1 | SCP0052_CAPA_Report.cs:311 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-1617000b | this.Load 외 1 | SCP0052_CAPA_Report.cs:310 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ad045e5f | this.Load 외 1 | SCP0052_CAPA_Report.cs:311 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0052_CAPA_Report.InitSpreadDateColumn

진입점: this.Load [else of (sheetName.Equals(SpdSheet.shtYieldMonitoring))] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (sheetName.Equals(SpdSheet.shtYieldMonitoring))] / txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ if (siMain.ActiveSheet != null) ▸ if (siMain.ActiveSheetIndex == 0) ▸ try ▸ else of (sheetName.Equals(SpdSheet.shtYieldMonitoring))] / txtMaterialId.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ if (siMain.ActiveSheet != null) ▸ if (siMain.ActiveSheetIndex == 0) ▸ try ▸ else of (sheetName.Equals(SpdSheet.shtYieldMonit…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3cf58d38 | this.Load [else of (sheetName.Equals(SpdSheet.shtYieldMonito… 외 5 | SCP0052_CAPA_Report.cs:788 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) | CALL_EXT | spdInfo.AddNumColumnEx | (sColumnLabelname, sColumnName, FPMerge.None, 70, true, true, 2) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a620eca0 | this.Load [else of (sheetName.Equals(SpdSheet.shtYieldMonito… 외 5 | SCP0052_CAPA_Report.cs:788 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) | CALL_EXT | spdInfo.AddNumColumnEx | (sColumnLabelname, sColumnName, FPMerge.None, 70, true, true, 2) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0052_CAPA_Report.InitSpreadDateColumn2

진입점: this.Load [if (sheetName.Equals(SpdSheet.shtYieldMonitoring))] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (sheetName.Equals(SpdSheet.shtYieldMonitoring))] / txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ if (siMain.ActiveSheet != null) ▸ if (siMain.ActiveSheetIndex == 0) ▸ try ▸ if (sheetName.Equals(SpdSheet.shtYieldMonitoring))] / txtMaterialId.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ if (siMain.ActiveSheet != null) ▸ if (siMain.ActiveSheetIndex == 0) ▸ try ▸ if (sheetName.Equals(SpdSheet.shtYieldMonitoring))] / txtNickNa…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6d5748d1 | this.Load [if (sheetName.Equals(SpdSheet.shtYieldMonitoring)… 외 5 | SCP0052_CAPA_Report.cs:820 |  | GRID_INIT | spdInfo.ColumnHeaderHeight | (1, 50) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8906907d | this.Load [if (sheetName.Equals(SpdSheet.shtYieldMonitoring)… 외 5 | SCP0052_CAPA_Report.cs:842 | if (pCheckAccuracy.Equals("N")) ▸ foreach (DataRow dr in dsSpdTitle2.Tables[0].Rows) | GRID_INIT | spdInfo.AddNumColumn | (gLabel, gCol, FPMerge.None, 80, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7271f452 | this.Load [if (sheetName.Equals(SpdSheet.shtYieldMonitoring)… 외 5 | SCP0052_CAPA_Report.cs:843 | if (pCheckAccuracy.Equals("N")) ▸ foreach (DataRow dr in dsSpdTitle2.Tables[0].Rows) | GRID_INIT | spdInfo.AddNumColumn | (yLabel, yCol, FPMerge.None, 80, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-cd9be0c7 | this.Load [if (sheetName.Equals(SpdSheet.shtYieldMonitoring)… 외 5 | SCP0052_CAPA_Report.cs:844 | if (pCheckAccuracy.Equals("N")) ▸ foreach (DataRow dr in dsSpdTitle2.Tables[0].Rows) | GRID_INIT | spdInfo.AddNumColumn | (rLabel, rCol, FPMerge.None, 70, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5b182be5 | this.Load [if (sheetName.Equals(SpdSheet.shtYieldMonitoring)… 외 5 | SCP0052_CAPA_Report.cs:845 | if (pCheckAccuracy.Equals("N")) ▸ foreach (DataRow dr in dsSpdTitle2.Tables[0].Rows) | CALL_EXT | spdInfo.AddNumColumnEx | (aLabel, aCol, FPMerge.None, 70, true, true, 2) | ⚠ 의미 확인 필요 |  |  |  |
| AC-60370bc2 | this.Load [if (sheetName.Equals(SpdSheet.shtYieldMonitoring)… 외 5 | SCP0052_CAPA_Report.cs:847 | if (pCheckAccuracy.Equals("N")) ▸ foreach (DataRow dr in dsSpdTitle2.Tables[0].Rows) | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iSmallStartCol, 1, iSmallSpanCnt, 20, sColumnLabelname, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-de923d88 | this.Load [if (sheetName.Equals(SpdSheet.shtYieldMonitoring)… 외 5 | SCP0052_CAPA_Report.cs:866 | else of (pCheckAccuracy.Equals("N")) ▸ foreach (DataRow dr in dsSpdTitle2.Tables[0].Rows) | CALL_EXT | spdInfo.AddNumColumnEx | (aLabel, aCol, FPMerge.None, 70, true, true, 2) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1c31c65b | this.Load [if (sheetName.Equals(SpdSheet.shtYieldMonitoring)… 외 5 | SCP0052_CAPA_Report.cs:868 | else of (pCheckAccuracy.Equals("N")) ▸ foreach (DataRow dr in dsSpdTitle2.Tables[0].Rows) | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iSmallStartCol, 1, iSmallSpanCnt, 20, sColumnLabelname, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8020d47b | this.Load [if (sheetName.Equals(SpdSheet.shtYieldMonitoring)… 외 5 | SCP0052_CAPA_Report.cs:876 |  | CALL_EXT | spdInfo.AddNumColumnEx | (DefColumnsTitle.ACCURACY, DefColumns.ACCURACY, FPMerge.None, 70, true, true, 2) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b7559db3 | this.Load [if (sheetName.Equals(SpdSheet.shtYieldMonitoring)… 외 5 | SCP0052_CAPA_Report.cs:877 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iSmallStartCol, 2, 1, 20, DefColumnsTitle.ACCURACY, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1c048def | this.Load [if (sheetName.Equals(SpdSheet.shtYieldMonitoring)… 외 5 | SCP0052_CAPA_Report.cs:820 |  | GRID_INIT | spdInfo.ColumnHeaderHeight | (1, 50) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-37ee101e | this.Load [if (sheetName.Equals(SpdSheet.shtYieldMonitoring)… 외 5 | SCP0052_CAPA_Report.cs:842 | if (pCheckAccuracy.Equals("N")) ▸ foreach (DataRow dr in dsSpdTitle2.Tables[0].Rows) | GRID_INIT | spdInfo.AddNumColumn | (gLabel, gCol, FPMerge.None, 80, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-86a2937c | this.Load [if (sheetName.Equals(SpdSheet.shtYieldMonitoring)… 외 5 | SCP0052_CAPA_Report.cs:843 | if (pCheckAccuracy.Equals("N")) ▸ foreach (DataRow dr in dsSpdTitle2.Tables[0].Rows) | GRID_INIT | spdInfo.AddNumColumn | (yLabel, yCol, FPMerge.None, 80, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5e94d538 | this.Load [if (sheetName.Equals(SpdSheet.shtYieldMonitoring)… 외 5 | SCP0052_CAPA_Report.cs:844 | if (pCheckAccuracy.Equals("N")) ▸ foreach (DataRow dr in dsSpdTitle2.Tables[0].Rows) | GRID_INIT | spdInfo.AddNumColumn | (rLabel, rCol, FPMerge.None, 70, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f3a0f87d | this.Load [if (sheetName.Equals(SpdSheet.shtYieldMonitoring)… 외 5 | SCP0052_CAPA_Report.cs:845 | if (pCheckAccuracy.Equals("N")) ▸ foreach (DataRow dr in dsSpdTitle2.Tables[0].Rows) | CALL_EXT | spdInfo.AddNumColumnEx | (aLabel, aCol, FPMerge.None, 70, true, true, 2) | ⚠ 의미 확인 필요 |  |  |  |
| AC-04284524 | this.Load [if (sheetName.Equals(SpdSheet.shtYieldMonitoring)… 외 5 | SCP0052_CAPA_Report.cs:847 | if (pCheckAccuracy.Equals("N")) ▸ foreach (DataRow dr in dsSpdTitle2.Tables[0].Rows) | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iSmallStartCol, 1, iSmallSpanCnt, 20, sColumnLabelname, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3343e3c7 | this.Load [if (sheetName.Equals(SpdSheet.shtYieldMonitoring)… 외 5 | SCP0052_CAPA_Report.cs:866 | else of (pCheckAccuracy.Equals("N")) ▸ foreach (DataRow dr in dsSpdTitle2.Tables[0].Rows) | CALL_EXT | spdInfo.AddNumColumnEx | (aLabel, aCol, FPMerge.None, 70, true, true, 2) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f32aaea3 | this.Load [if (sheetName.Equals(SpdSheet.shtYieldMonitoring)… 외 5 | SCP0052_CAPA_Report.cs:868 | else of (pCheckAccuracy.Equals("N")) ▸ foreach (DataRow dr in dsSpdTitle2.Tables[0].Rows) | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iSmallStartCol, 1, iSmallSpanCnt, 20, sColumnLabelname, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6a1a85ca | this.Load [if (sheetName.Equals(SpdSheet.shtYieldMonitoring)… 외 5 | SCP0052_CAPA_Report.cs:876 |  | CALL_EXT | spdInfo.AddNumColumnEx | (DefColumnsTitle.ACCURACY, DefColumns.ACCURACY, FPMerge.None, 70, true, true, 2) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3b384f0f | this.Load [if (sheetName.Equals(SpdSheet.shtYieldMonitoring)… 외 5 | SCP0052_CAPA_Report.cs:877 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iSmallStartCol, 2, 1, 20, DefColumnsTitle.ACCURACY, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0052_CAPA_Report.Re_Design

진입점: txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ if (siMain.ActiveSheet != null) ▸ if (siMain.ActiveSheetIndex == 0) ▸ try] / txtMaterialId.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ if (siMain.ActiveSheet != null) ▸ if (siMain.ActiveSheetIndex == 0) ▸ try] / txtNickName.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ if (siMain.ActiveSheet != null) ▸ if (siMain.ActiveSheetIndex == 0) ▸ try] / FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.ActiveSheetIndex == 0) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c3d23a6e | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:944 | if (siMain.ActiveSheet.RowCount > 0) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ for (col <= lastColIdx) ▸ for (row <= l… | CALL_EXT | dStdValue.CompareTo | (dOtherValue) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e3be6f12 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:970 | if (siMain.ActiveSheet.RowCount > 0) ▸ else of (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.ActiveSheet.SheetName == SpdS… | VALUE_SET | cells.Text | "Total" | 컨트롤 값 설정 |  |  |  |
| AC-fb9c662b | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:971 | if (siMain.ActiveSheet.RowCount > 0) ▸ else of (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.ActiveSheet.SheetName == SpdS… | UI_PROP | cells.ColumnSpan | 3 | 속성 ColumnSpan 설정 |  |  |  |
| AC-ca2f7057 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:972 | if (siMain.ActiveSheet.RowCount > 0) ▸ else of (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.ActiveSheet.SheetName == SpdS… | UI_PROP | cells.ForeColor | Color.Black | 속성 ForeColor 설정 |  |  |  |
| AC-706d7b65 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:973 | if (siMain.ActiveSheet.RowCount > 0) ▸ else of (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.ActiveSheet.SheetName == SpdS… | UI_PROP | cells.BackColor | Color.LightGray | 속성 BackColor 설정 |  |  |  |
| AC-a3956fe9 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:974 | if (siMain.ActiveSheet.RowCount > 0) ▸ else of (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.ActiveSheet.SheetName == SpdS… | UI_PROP | cells.HorizontalAlignment | CellHorizontalAlignment.Center | 속성 HorizontalAlignment 설정 |  |  |  |
| AC-7b9065a3 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:992 | if (siMain.ActiveSheet.RowCount > 0) ▸ else of (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (siMain.ActiveSheet.SheetName ==… | GRID_STYLE | siMain.SetBGColor | (row, siMain.GetColumnIndex(DefColumns.DIVISION_NAME), row, siMain.GetColumnIndex(DefColum… | 그리드 표시 설정 |  |  |  |
| AC-3e943b35 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:994 | if (siMain.ActiveSheet.RowCount > 0) ▸ else of (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (siMain.ActiveSheet.SheetName ==… | GRID_SET | siMain.SetValue | (row, siMain.GetColumnIndex(DefColumns.OPERATION_GROUP_ID), "") | 그리드 값 설정 |  |  |  |
| AC-66d54403 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:995 | if (siMain.ActiveSheet.RowCount > 0) ▸ else of (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (siMain.ActiveSheet.SheetName ==… | GRID_SET | siMain.SetValue | (row, siMain.GetColumnIndex(DefColumns.OPERATION_GROUP), "") | 그리드 값 설정 |  |  |  |
| AC-b6c2d815 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:996 | if (siMain.ActiveSheet.RowCount > 0) ▸ else of (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (siMain.ActiveSheet.SheetName ==… | GRID_SET | siMain.SetValue | (row, siMain.GetColumnIndex(DefColumns.SITE_ID), "") | 그리드 값 설정 |  |  |  |
| AC-1e82e5e0 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:997 | if (siMain.ActiveSheet.RowCount > 0) ▸ else of (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (siMain.ActiveSheet.SheetName ==… | GRID_SET | siMain.SetValue | (row, siMain.GetColumnIndex(DefColumns.SITE_NAME), "") | 그리드 값 설정 |  |  |  |
| AC-505ada40 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:998 | if (siMain.ActiveSheet.RowCount > 0) ▸ else of (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (siMain.ActiveSheet.SheetName ==… | GRID_SET | siMain.SetValue | (row, siMain.GetColumnIndex(DefColumns.PLANT_ID), "") | 그리드 값 설정 |  |  |  |
| AC-7b68798c | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:999 | if (siMain.ActiveSheet.RowCount > 0) ▸ else of (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (siMain.ActiveSheet.SheetName ==… | GRID_SET | siMain.SetValue | (row, siMain.GetColumnIndex(DefColumns.PLANT_NAME), "") | 그리드 값 설정 |  |  |  |
| AC-6272e7c0 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:1004 | if (siMain.ActiveSheet.RowCount > 0) ▸ else of (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (siMain.ActiveSheet.SheetName ==… | GRID_STYLE | siMain.SetBGColor | (row, siMain.GetColumnIndex(DefColumns.OPERATION_GROUP), row, siMain.GetColumnIndex(DefCol… | 그리드 표시 설정 |  |  |  |
| AC-b4d85844 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:1005 | if (siMain.ActiveSheet.RowCount > 0) ▸ else of (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (siMain.ActiveSheet.SheetName ==… | GRID_SET | siMain.SetValue | (row, siMain.GetColumnIndex(DefColumns.SITE_NAME), "") | 그리드 값 설정 |  |  |  |
| AC-dc0af9b3 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:1006 | if (siMain.ActiveSheet.RowCount > 0) ▸ else of (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (siMain.ActiveSheet.SheetName ==… | GRID_SET | siMain.SetValue | (row, siMain.GetColumnIndex(DefColumns.PLANT_ID), "") | 그리드 값 설정 |  |  |  |
| AC-68bd3c11 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:1007 | if (siMain.ActiveSheet.RowCount > 0) ▸ else of (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (siMain.ActiveSheet.SheetName ==… | GRID_SET | siMain.SetValue | (row, siMain.GetColumnIndex(DefColumns.PLANT_NAME), "") | 그리드 값 설정 |  |  |  |
| AC-5c3334e4 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:1012 | if (siMain.ActiveSheet.RowCount > 0) ▸ else of (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (siMain.ActiveSheet.SheetName ==… | GRID_STYLE | siMain.SetBGColor | (row, siMain.GetColumnIndex(DefColumns.SITE_NAME), row, siMain.GetColumnIndex(DefColumns.A… | 그리드 표시 설정 |  |  |  |
| AC-64a9b893 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:1013 | if (siMain.ActiveSheet.RowCount > 0) ▸ else of (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (siMain.ActiveSheet.SheetName ==… | GRID_SET | siMain.SetValue | (row, siMain.GetColumnIndex(DefColumns.SITE_NAME), "Sub-Total") | 그리드 값 설정 |  |  |  |
| AC-cc7028c8 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:1014 | if (siMain.ActiveSheet.RowCount > 0) ▸ else of (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (siMain.ActiveSheet.SheetName ==… | GRID_SET | siMain.SetValue | (row, siMain.GetColumnIndex(DefColumns.PLANT_ID), "") | 그리드 값 설정 |  |  |  |
| AC-9d2da4bb | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:1015 | if (siMain.ActiveSheet.RowCount > 0) ▸ else of (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (siMain.ActiveSheet.SheetName ==… | GRID_SET | siMain.SetValue | (row, siMain.GetColumnIndex(DefColumns.PLANT_NAME), "") | 그리드 값 설정 |  |  |  |
| AC-0e23cfd6 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:1020 | if (siMain.ActiveSheet.RowCount > 0) ▸ else of (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (siMain.ActiveSheet.SheetName ==… | GRID_STYLE | siMain.SetBGColor | (row, siMain.GetColumnIndex(DefColumns.PLANT_NAME), row, siMain.GetColumnIndex(DefColumns.… | 그리드 표시 설정 |  |  |  |
| AC-34fb1cce | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:1046 | if (siMain.ActiveSheet.RowCount > 0) ▸ else of (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (siMain.ActiveSheet.SheetName ==… | CALL_EXT | siMain.GetColumnText | (1, col) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d92ec0c9 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:1048 | if (siMain.ActiveSheet.RowCount > 0) ▸ else of (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (siMain.ActiveSheet.SheetName ==… | GRID_STYLE | siMain.SetBGColor | (row, col, row, col, Color.FromArgb(240, 255, 240)) | 그리드 표시 설정 |  |  |  |
| AC-a04fe0a9 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:1050 | if (siMain.ActiveSheet.RowCount > 0) ▸ else of (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (siMain.ActiveSheet.SheetName ==… | CALL_EXT | siMain.GetColumnText | (1, col) | ⚠ 의미 확인 필요 |  |  |  |
| AC-77b0cf3e | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:1052 | if (siMain.ActiveSheet.RowCount > 0) ▸ else of (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (siMain.ActiveSheet.SheetName ==… | GRID_STYLE | siMain.SetBGColor | (row, col, row, col, Color.FromArgb(255, 240, 240)) | 그리드 표시 설정 |  |  |  |
| AC-b2cc5de9 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:1054 | if (siMain.ActiveSheet.RowCount > 0) ▸ else of (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (siMain.ActiveSheet.SheetName ==… | CALL_EXT | siMain.GetColumnText | (1, col) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d13158e2 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:1056 | if (siMain.ActiveSheet.RowCount > 0) ▸ else of (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (siMain.ActiveSheet.SheetName ==… | GRID_STYLE | siMain.SetBGColor | (row, col, row, col, Color.FromArgb(255, 255, 240)) | 그리드 표시 설정 |  |  |  |
| AC-976c158f | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:944 | if (siMain.ActiveSheet.RowCount > 0) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ for (col <= lastColIdx) ▸ for (row <= l… | CALL_EXT | dStdValue.CompareTo | (dOtherValue) | ⚠ 의미 확인 필요 |  |  |  |
| AC-384a88bd | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:970 | if (siMain.ActiveSheet.RowCount > 0) ▸ else of (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.ActiveSheet.SheetName == SpdS… | VALUE_SET | cells.Text | "Total" | 컨트롤 값 설정 |  |  |  |
| AC-622f62d5 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:971 | if (siMain.ActiveSheet.RowCount > 0) ▸ else of (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.ActiveSheet.SheetName == SpdS… | UI_PROP | cells.ColumnSpan | 3 | 속성 ColumnSpan 설정 |  |  |  |
| AC-6b637efd | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:972 | if (siMain.ActiveSheet.RowCount > 0) ▸ else of (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.ActiveSheet.SheetName == SpdS… | UI_PROP | cells.ForeColor | Color.Black | 속성 ForeColor 설정 |  |  |  |
| AC-00a693b2 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:973 | if (siMain.ActiveSheet.RowCount > 0) ▸ else of (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.ActiveSheet.SheetName == SpdS… | UI_PROP | cells.BackColor | Color.LightGray | 속성 BackColor 설정 |  |  |  |
| AC-7d2bcf01 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:974 | if (siMain.ActiveSheet.RowCount > 0) ▸ else of (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.ActiveSheet.SheetName == SpdS… | UI_PROP | cells.HorizontalAlignment | CellHorizontalAlignment.Center | 속성 HorizontalAlignment 설정 |  |  |  |
| AC-23f7b177 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:992 | if (siMain.ActiveSheet.RowCount > 0) ▸ else of (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (siMain.ActiveSheet.SheetName ==… | GRID_STYLE | siMain.SetBGColor | (row, siMain.GetColumnIndex(DefColumns.DIVISION_NAME), row, siMain.GetColumnIndex(DefColum… | 그리드 표시 설정 |  |  |  |
| AC-37b745d3 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:994 | if (siMain.ActiveSheet.RowCount > 0) ▸ else of (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (siMain.ActiveSheet.SheetName ==… | GRID_SET | siMain.SetValue | (row, siMain.GetColumnIndex(DefColumns.OPERATION_GROUP_ID), "") | 그리드 값 설정 |  |  |  |
| AC-203eeca3 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:995 | if (siMain.ActiveSheet.RowCount > 0) ▸ else of (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (siMain.ActiveSheet.SheetName ==… | GRID_SET | siMain.SetValue | (row, siMain.GetColumnIndex(DefColumns.OPERATION_GROUP), "") | 그리드 값 설정 |  |  |  |
| AC-dc2ffdb6 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:996 | if (siMain.ActiveSheet.RowCount > 0) ▸ else of (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (siMain.ActiveSheet.SheetName ==… | GRID_SET | siMain.SetValue | (row, siMain.GetColumnIndex(DefColumns.SITE_ID), "") | 그리드 값 설정 |  |  |  |
| AC-6ce84465 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:997 | if (siMain.ActiveSheet.RowCount > 0) ▸ else of (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (siMain.ActiveSheet.SheetName ==… | GRID_SET | siMain.SetValue | (row, siMain.GetColumnIndex(DefColumns.SITE_NAME), "") | 그리드 값 설정 |  |  |  |
| AC-5419f950 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:998 | if (siMain.ActiveSheet.RowCount > 0) ▸ else of (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (siMain.ActiveSheet.SheetName ==… | GRID_SET | siMain.SetValue | (row, siMain.GetColumnIndex(DefColumns.PLANT_ID), "") | 그리드 값 설정 |  |  |  |
| AC-16221e0e | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:999 | if (siMain.ActiveSheet.RowCount > 0) ▸ else of (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (siMain.ActiveSheet.SheetName ==… | GRID_SET | siMain.SetValue | (row, siMain.GetColumnIndex(DefColumns.PLANT_NAME), "") | 그리드 값 설정 |  |  |  |
| AC-01b8d4fc | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:1004 | if (siMain.ActiveSheet.RowCount > 0) ▸ else of (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (siMain.ActiveSheet.SheetName ==… | GRID_STYLE | siMain.SetBGColor | (row, siMain.GetColumnIndex(DefColumns.OPERATION_GROUP), row, siMain.GetColumnIndex(DefCol… | 그리드 표시 설정 |  |  |  |
| AC-c9c5ea39 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:1005 | if (siMain.ActiveSheet.RowCount > 0) ▸ else of (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (siMain.ActiveSheet.SheetName ==… | GRID_SET | siMain.SetValue | (row, siMain.GetColumnIndex(DefColumns.SITE_NAME), "") | 그리드 값 설정 |  |  |  |
| AC-36f69625 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:1006 | if (siMain.ActiveSheet.RowCount > 0) ▸ else of (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (siMain.ActiveSheet.SheetName ==… | GRID_SET | siMain.SetValue | (row, siMain.GetColumnIndex(DefColumns.PLANT_ID), "") | 그리드 값 설정 |  |  |  |
| AC-a2a08ce3 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:1007 | if (siMain.ActiveSheet.RowCount > 0) ▸ else of (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (siMain.ActiveSheet.SheetName ==… | GRID_SET | siMain.SetValue | (row, siMain.GetColumnIndex(DefColumns.PLANT_NAME), "") | 그리드 값 설정 |  |  |  |
| AC-414c65b1 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:1012 | if (siMain.ActiveSheet.RowCount > 0) ▸ else of (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (siMain.ActiveSheet.SheetName ==… | GRID_STYLE | siMain.SetBGColor | (row, siMain.GetColumnIndex(DefColumns.SITE_NAME), row, siMain.GetColumnIndex(DefColumns.A… | 그리드 표시 설정 |  |  |  |
| AC-d7177338 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:1013 | if (siMain.ActiveSheet.RowCount > 0) ▸ else of (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (siMain.ActiveSheet.SheetName ==… | GRID_SET | siMain.SetValue | (row, siMain.GetColumnIndex(DefColumns.SITE_NAME), "Sub-Total") | 그리드 값 설정 |  |  |  |
| AC-9f6c84a3 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:1014 | if (siMain.ActiveSheet.RowCount > 0) ▸ else of (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (siMain.ActiveSheet.SheetName ==… | GRID_SET | siMain.SetValue | (row, siMain.GetColumnIndex(DefColumns.PLANT_ID), "") | 그리드 값 설정 |  |  |  |
| AC-fef9820b | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:1015 | if (siMain.ActiveSheet.RowCount > 0) ▸ else of (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (siMain.ActiveSheet.SheetName ==… | GRID_SET | siMain.SetValue | (row, siMain.GetColumnIndex(DefColumns.PLANT_NAME), "") | 그리드 값 설정 |  |  |  |
| AC-6d5365c7 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:1020 | if (siMain.ActiveSheet.RowCount > 0) ▸ else of (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (siMain.ActiveSheet.SheetName ==… | GRID_STYLE | siMain.SetBGColor | (row, siMain.GetColumnIndex(DefColumns.PLANT_NAME), row, siMain.GetColumnIndex(DefColumns.… | 그리드 표시 설정 |  |  |  |
| AC-2678b512 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:1046 | if (siMain.ActiveSheet.RowCount > 0) ▸ else of (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (siMain.ActiveSheet.SheetName ==… | CALL_EXT | siMain.GetColumnText | (1, col) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4494de27 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:1048 | if (siMain.ActiveSheet.RowCount > 0) ▸ else of (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (siMain.ActiveSheet.SheetName ==… | GRID_STYLE | siMain.SetBGColor | (row, col, row, col, Color.FromArgb(240, 255, 240)) | 그리드 표시 설정 |  |  |  |
| AC-bf8a0974 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:1050 | if (siMain.ActiveSheet.RowCount > 0) ▸ else of (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (siMain.ActiveSheet.SheetName ==… | CALL_EXT | siMain.GetColumnText | (1, col) | ⚠ 의미 확인 필요 |  |  |  |
| AC-8db585bf | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:1052 | if (siMain.ActiveSheet.RowCount > 0) ▸ else of (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (siMain.ActiveSheet.SheetName ==… | GRID_STYLE | siMain.SetBGColor | (row, col, row, col, Color.FromArgb(255, 240, 240)) | 그리드 표시 설정 |  |  |  |
| AC-674ca3a6 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:1054 | if (siMain.ActiveSheet.RowCount > 0) ▸ else of (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (siMain.ActiveSheet.SheetName ==… | CALL_EXT | siMain.GetColumnText | (1, col) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9e05e897 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:1056 | if (siMain.ActiveSheet.RowCount > 0) ▸ else of (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (siMain.ActiveSheet.SheetName ==… | GRID_STYLE | siMain.SetBGColor | (row, col, row, col, Color.FromArgb(255, 255, 240)) | 그리드 표시 설정 |  |  |  |

## SCP0052_CAPA_Report.Set_Color

진입점: txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ if (siMain.ActiveSheet != null) ▸ if (siMain.ActiveSheetIndex == 0) ▸ try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ for (col <= lastColIdx) ▸ for (row <= lastRowIdx) ▸ if (sRowRanking == "1" && isDiffValue)] / txtMaterialId.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ if (siMain.ActiveSheet != null) ▸ if (siMain.ActiveSheetIndex == 0) ▸ try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ for (…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-01d5870a | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:1069 |  | GRID_STYLE | siMain.SetBGColor | (iStartRow, iStartCol, iEndRow, iEndCol, Color.LightSalmon) | 그리드 표시 설정 |  |  |  |
| AC-791982f8 | txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 3 | SCP0052_CAPA_Report.cs:1069 |  | GRID_STYLE | siMain.SetBGColor | (iStartRow, iStartCol, iEndRow, iEndCol, Color.LightSalmon) | 그리드 표시 설정 |  |  |  |

## SCP0052_CAPA_Report.SetChangedControl

진입점: this.Load / cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-57f09be1 | this.Load 외 1 | SCP0052_CAPA_Report.cs:256 |  | FLAG | dtShopGroup | Data_SCP.Common(Data_SCP.Type.ShopGroupId, false, pDivisionID) | 화면 필드/플래그 변경 |  |  |  |
| AC-a0919967 | this.Load 외 1 | SCP0052_CAPA_Report.cs:256 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.ShopGroupId, false, pDivisionID) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-561fe24d | this.Load 외 1 | SCP0052_CAPA_Report.cs:257 |  | LIST_REBIND | clsCtrl.setListBox | (dtShopGroup, cboGroup, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-4764550d | this.Load 외 1 | SCP0052_CAPA_Report.cs:260 |  | FLAG | dtPlantByGroup | Data_SCP.Common(Data_SCP.Type.PlantByGroup, false, pDivisionID , pGroupId) | 화면 필드/플래그 변경 |  |  |  |
| AC-990fcf7f | this.Load 외 1 | SCP0052_CAPA_Report.cs:260 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.PlantByGroup, false, pDivisionID , pGroupId) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-dbdc1c4b | this.Load 외 1 | SCP0052_CAPA_Report.cs:261 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantByGroup, clbPlant, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-70c7c114 | this.Load 외 1 | SCP0052_CAPA_Report.cs:265 |  | FLAG | dtBuildingByShopGroupId | Data_SCP.Common(Data_SCP.Type.BuildingByShopGroupId, false, pDivisionID, pPlantId,pGroupId… | 화면 필드/플래그 변경 |  |  |  |
| AC-1f2e29fc | this.Load 외 1 | SCP0052_CAPA_Report.cs:265 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.BuildingByShopGroupId, false, pDivisionID, pPlantId,pGroupId) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-6bd73d1c | this.Load 외 1 | SCP0052_CAPA_Report.cs:266 |  | LIST_REBIND | clsCtrl.setListBox | (dtBuildingByShopGroupId, clbBuilding, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-ac9bed10 | this.Load 외 1 | SCP0052_CAPA_Report.cs:270 |  | FLAG | dtLineByOperationPlantId | Data_SCP.Common(Data_SCP.Type.LineByOperationPlantId, false, pDivisionID, pPlantId, pBuild… | 화면 필드/플래그 변경 |  |  |  |
| AC-1998304a | this.Load 외 1 | SCP0052_CAPA_Report.cs:270 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.LineByOperationPlantId, false, pDivisionID, pPlantId, pBuilding,pGroupId) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-16b10463 | this.Load 외 1 | SCP0052_CAPA_Report.cs:271 |  | LIST_REBIND | clsCtrl.setListBox | (dtLineByOperationPlantId, clbLine, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-a44e81f2 | this.Load 외 1 | SCP0052_CAPA_Report.cs:275 |  | FLAG | dtOperationByLine | Data.Common(Data.Type.OperationByLine, false, pDivisionID, pPlantId, pBuilding, pLineId, p… ⇒ biz:CommonData.CommonDataList [code=OperationByLine] | 화면 필드/플래그 변경 |  |  |  |
| AC-af419935 | this.Load 외 1 | SCP0052_CAPA_Report.cs:275 |  | COMBO_DATA | Data.Common | (Data.Type.OperationByLine, false, pDivisionID, pPlantId, pBuilding, pLineId, pGroupId) ⇒ biz:CommonData.CommonDataList [code=OperationByLine] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-9c1e7773 | this.Load 외 1 | SCP0052_CAPA_Report.cs:276 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperationByLine, clbOperation, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-b3b07551 | this.Load 외 1 | SCP0052_CAPA_Report.cs:278 |  | FLAG | dtVersionId | Data_SCP.Common(Data_SCP.Type.MDMVersionId, false, pDivisionID, pGroupId) | 화면 필드/플래그 변경 |  |  |  |
| AC-2555e11c | this.Load 외 1 | SCP0052_CAPA_Report.cs:278 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.MDMVersionId, false, pDivisionID, pGroupId) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ef9f0ef3 | this.Load 외 1 | SCP0052_CAPA_Report.cs:280 |  | DATA_OP | dtVersionId.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-7ce011f9 | this.Load 외 1 | SCP0052_CAPA_Report.cs:281 |  | DATA_OP | drCurrentRow["CODE"] | "Current" | 행/컬럼 값 대입 |  |  |  |
| AC-9bbdf196 | this.Load 외 1 | SCP0052_CAPA_Report.cs:282 |  | DATA_OP | drCurrentRow["NAME"] | "Current" | 행/컬럼 값 대입 |  |  |  |
| AC-34a4a863 | this.Load 외 1 | SCP0052_CAPA_Report.cs:283 |  | CALL_EXT | dtVersionId.Rows.InsertAt | (drCurrentRow, 0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-97c00f3f | this.Load 외 1 | SCP0052_CAPA_Report.cs:284 |  | DATA_OP | dtVersionId.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-586b8432 | this.Load 외 1 | SCP0052_CAPA_Report.cs:286 |  | LIST_REBIND | clsCtrl.setListBox | (dtVersionId, clbVersionId, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-099a0c37 | this.Load 외 1 | SCP0052_CAPA_Report.cs:256 |  | FLAG | dtShopGroup | Data_SCP.Common(Data_SCP.Type.ShopGroupId, false, division) | 화면 필드/플래그 변경 |  |  |  |
| AC-3685516b | this.Load 외 1 | SCP0052_CAPA_Report.cs:256 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.ShopGroupId, false, division) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-818768aa | this.Load 외 1 | SCP0052_CAPA_Report.cs:257 |  | LIST_REBIND | clsCtrl.setListBox | (dtShopGroup, cboGroup, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-4d4fc719 | this.Load 외 1 | SCP0052_CAPA_Report.cs:260 |  | FLAG | dtPlantByGroup | Data_SCP.Common(Data_SCP.Type.PlantByGroup, false, division , pGroupId) | 화면 필드/플래그 변경 |  |  |  |
| AC-ffefeba5 | this.Load 외 1 | SCP0052_CAPA_Report.cs:260 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.PlantByGroup, false, division , pGroupId) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ad9a0c5f | this.Load 외 1 | SCP0052_CAPA_Report.cs:261 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantByGroup, clbPlant, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-332f9315 | this.Load 외 1 | SCP0052_CAPA_Report.cs:265 |  | FLAG | dtBuildingByShopGroupId | Data_SCP.Common(Data_SCP.Type.BuildingByShopGroupId, false, division, pPlantId,pGroupId) | 화면 필드/플래그 변경 |  |  |  |
| AC-8595102c | this.Load 외 1 | SCP0052_CAPA_Report.cs:265 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.BuildingByShopGroupId, false, division, pPlantId,pGroupId) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-29a5f601 | this.Load 외 1 | SCP0052_CAPA_Report.cs:266 |  | LIST_REBIND | clsCtrl.setListBox | (dtBuildingByShopGroupId, clbBuilding, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-5de41acf | this.Load 외 1 | SCP0052_CAPA_Report.cs:270 |  | FLAG | dtLineByOperationPlantId | Data_SCP.Common(Data_SCP.Type.LineByOperationPlantId, false, division, pPlantId, pBuilding… | 화면 필드/플래그 변경 |  |  |  |
| AC-aaa1e0cf | this.Load 외 1 | SCP0052_CAPA_Report.cs:270 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.LineByOperationPlantId, false, division, pPlantId, pBuilding,pGroupId) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-fbed31cf | this.Load 외 1 | SCP0052_CAPA_Report.cs:271 |  | LIST_REBIND | clsCtrl.setListBox | (dtLineByOperationPlantId, clbLine, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-6598ab64 | this.Load 외 1 | SCP0052_CAPA_Report.cs:275 |  | FLAG | dtOperationByLine | Data.Common(Data.Type.OperationByLine, false, division, pPlantId, pBuilding, pLineId, pGro… ⇒ biz:CommonData.CommonDataList [code=OperationByLine] | 화면 필드/플래그 변경 |  |  |  |
| AC-2ed42a76 | this.Load 외 1 | SCP0052_CAPA_Report.cs:275 |  | COMBO_DATA | Data.Common | (Data.Type.OperationByLine, false, division, pPlantId, pBuilding, pLineId, pGroupId) ⇒ biz:CommonData.CommonDataList [code=OperationByLine] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-90d1ab6f | this.Load 외 1 | SCP0052_CAPA_Report.cs:276 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperationByLine, clbOperation, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-85bf866b | this.Load 외 1 | SCP0052_CAPA_Report.cs:278 |  | FLAG | dtVersionId | Data_SCP.Common(Data_SCP.Type.MDMVersionId, false, division, pGroupId) | 화면 필드/플래그 변경 |  |  |  |
| AC-a149aa23 | this.Load 외 1 | SCP0052_CAPA_Report.cs:278 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.MDMVersionId, false, division, pGroupId) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-9ce9f477 | this.Load 외 1 | SCP0052_CAPA_Report.cs:280 |  | DATA_OP | dtVersionId.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-d4cb9adb | this.Load 외 1 | SCP0052_CAPA_Report.cs:281 |  | DATA_OP | drCurrentRow["CODE"] | "Current" | 행/컬럼 값 대입 |  |  |  |
| AC-858d7105 | this.Load 외 1 | SCP0052_CAPA_Report.cs:282 |  | DATA_OP | drCurrentRow["NAME"] | "Current" | 행/컬럼 값 대입 |  |  |  |
| AC-4f17f365 | this.Load 외 1 | SCP0052_CAPA_Report.cs:283 |  | CALL_EXT | dtVersionId.Rows.InsertAt | (drCurrentRow, 0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7a8d58e3 | this.Load 외 1 | SCP0052_CAPA_Report.cs:284 |  | DATA_OP | dtVersionId.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-81fe4f3f | this.Load 외 1 | SCP0052_CAPA_Report.cs:286 |  | LIST_REBIND | clsCtrl.setListBox | (dtVersionId, clbVersionId, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0052_CAPA_Report.SetPeriod

진입점: this.spdMain.ActiveSheetChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a9fe7c0c | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1497 | if (dt != null && dt.Rows.Count > 0) | UI_PROP | drpPeriodMonth.MonthText1 | dt.Rows[0]["FROM_VALUE"].ToString().Substring(0, 6) | 속성 MonthText1 설정 |  |  |  |
| AC-44f3566e | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1498 | if (dt != null && dt.Rows.Count > 0) | UI_PROP | drpPeriodMonth.MonthText2 | dt.Rows[0]["TO_VALUE"].ToString().Substring(0, 6) | 속성 MonthText2 설정 |  |  |  |
| AC-8b571d38 | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1510 | if (dt != null && dt.Rows.Count > 0) ▸ if (siMain.ActiveSheetIndex == 2) | UI_PROP | drpPeriodMonth.MonthMin1 | dateMinMonth.Substring(0, 6) | 속성 MonthMin1 설정 |  |  |  |
| AC-aa4e3035 | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1511 | if (dt != null && dt.Rows.Count > 0) ▸ if (siMain.ActiveSheetIndex == 2) | UI_PROP | drpPeriodMonth.MonthMax1 | dateMaxMonth.Substring(0, 6) | 속성 MonthMax1 설정 |  |  |  |
| AC-9aaafa77 | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1513 | if (dt != null && dt.Rows.Count > 0) ▸ if (siMain.ActiveSheetIndex == 2) | UI_PROP | drpPeriodMonth.MonthMin2 | dateMinMonth.Substring(0, 6) | 속성 MonthMin2 설정 |  |  |  |
| AC-bd444abf | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1514 | if (dt != null && dt.Rows.Count > 0) ▸ if (siMain.ActiveSheetIndex == 2) | UI_PROP | drpPeriodMonth.MonthMax2 | dateMaxMonth.Substring(0, 6) | 속성 MonthMax2 설정 |  |  |  |
| AC-33e4f64d | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1516 | if (dt != null && dt.Rows.Count > 0) ▸ if (siMain.ActiveSheetIndex == 2) | UI_PROP | drpPeriodMonth.MonthText2 | drpPeriodMonth.MonthMax2 | 속성 MonthText2 설정 |  |  |  |
| AC-78fecbb4 | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1521 | if (dt != null && dt.Rows.Count > 0) ▸ else of (siMain.ActiveSheetIndex == 2) | UI_PROP | drpPeriodMonth.MonthMin1 | dt.Rows[0]["FROM_VALUE"].ToString().Substring(0, 6) | 속성 MonthMin1 설정 |  |  |  |
| AC-a83073ca | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1523 | if (dt != null && dt.Rows.Count > 0) ▸ else of (siMain.ActiveSheetIndex == 2) | UI_PROP | drpPeriodMonth.MonthMax1 | dt.Rows[0]["FROM_VALUE"].ToString().Substring(0, 6) | 속성 MonthMax1 설정 |  |  |  |
| AC-7c9dbeac | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1525 | if (dt != null && dt.Rows.Count > 0) ▸ else of (siMain.ActiveSheetIndex == 2) | UI_PROP | drpPeriodMonth.MonthMin2 | dt.Rows[0]["FROM_VALUE"].ToString().Substring(0, 6) | 속성 MonthMin2 설정 |  |  |  |
| AC-bfe08330 | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1531 | if (dt != null && dt.Rows.Count > 0) ▸ else of (siMain.ActiveSheetIndex == 2) | UI_PROP | drpPeriodMonth.MonthMax2 | dateMaxMonth.Substring(0, 6) | 속성 MonthMax2 설정 |  |  |  |
| AC-482adee9 | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1497 | if (dt != null && dt.Rows.Count > 0) | UI_PROP | drpPeriodMonth.MonthText1 | dt.Rows[0]["FROM_VALUE"].ToString().Substring(0, 6) | 속성 MonthText1 설정 |  |  |  |
| AC-da68d30e | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1498 | if (dt != null && dt.Rows.Count > 0) | UI_PROP | drpPeriodMonth.MonthText2 | dt.Rows[0]["TO_VALUE"].ToString().Substring(0, 6) | 속성 MonthText2 설정 |  |  |  |
| AC-df01aa67 | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1510 | if (dt != null && dt.Rows.Count > 0) ▸ if (siMain.ActiveSheetIndex == 2) | UI_PROP | drpPeriodMonth.MonthMin1 | dateMinMonth.Substring(0, 6) | 속성 MonthMin1 설정 |  |  |  |
| AC-853f63d2 | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1511 | if (dt != null && dt.Rows.Count > 0) ▸ if (siMain.ActiveSheetIndex == 2) | UI_PROP | drpPeriodMonth.MonthMax1 | dateMaxMonth.Substring(0, 6) | 속성 MonthMax1 설정 |  |  |  |
| AC-b2c4aaa5 | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1513 | if (dt != null && dt.Rows.Count > 0) ▸ if (siMain.ActiveSheetIndex == 2) | UI_PROP | drpPeriodMonth.MonthMin2 | dateMinMonth.Substring(0, 6) | 속성 MonthMin2 설정 |  |  |  |
| AC-57c9e3e4 | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1514 | if (dt != null && dt.Rows.Count > 0) ▸ if (siMain.ActiveSheetIndex == 2) | UI_PROP | drpPeriodMonth.MonthMax2 | dateMaxMonth.Substring(0, 6) | 속성 MonthMax2 설정 |  |  |  |
| AC-1a7f417c | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1516 | if (dt != null && dt.Rows.Count > 0) ▸ if (siMain.ActiveSheetIndex == 2) | UI_PROP | drpPeriodMonth.MonthText2 | drpPeriodMonth.MonthMax2 | 속성 MonthText2 설정 |  |  |  |
| AC-e1c5b70e | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1521 | if (dt != null && dt.Rows.Count > 0) ▸ else of (siMain.ActiveSheetIndex == 2) | UI_PROP | drpPeriodMonth.MonthMin1 | dt.Rows[0]["FROM_VALUE"].ToString().Substring(0, 6) | 속성 MonthMin1 설정 |  |  |  |
| AC-8bfb4c95 | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1523 | if (dt != null && dt.Rows.Count > 0) ▸ else of (siMain.ActiveSheetIndex == 2) | UI_PROP | drpPeriodMonth.MonthMax1 | dt.Rows[0]["FROM_VALUE"].ToString().Substring(0, 6) | 속성 MonthMax1 설정 |  |  |  |
| AC-bf36133d | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1525 | if (dt != null && dt.Rows.Count > 0) ▸ else of (siMain.ActiveSheetIndex == 2) | UI_PROP | drpPeriodMonth.MonthMin2 | dt.Rows[0]["FROM_VALUE"].ToString().Substring(0, 6) | 속성 MonthMin2 설정 |  |  |  |
| AC-38a916fc | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1531 | if (dt != null && dt.Rows.Count > 0) ▸ else of (siMain.ActiveSheetIndex == 2) | UI_PROP | drpPeriodMonth.MonthMax2 | dateMaxMonth.Substring(0, 6) | 속성 MonthMax2 설정 |  |  |  |

## SCP0052_CAPA_Report.SetSpreadInit

진입점: this.Load / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)] / txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ if (siMain.ActiveSheet != null) ▸ if (siMain.ActiveSheetIndex == 0) ▸ try] / txtMaterialId.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ if (siMain.ActiveSheet != null) ▸ if (siMain.ActiveSheetIndex == 0) ▸ try] / txtNickName.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ if (siMain.ActiveSheet != null) ▸ if (siMain.ActiveSheetIndex == 0) ▸ try] / FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.ActiveSheetInd…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-807ffd32 | this.Load 외 5 | SCP0052_CAPA_Report.cs:319 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c19ce22b | this.Load 외 5 | SCP0052_CAPA_Report.cs:320 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-2b8b44fe | this.Load 외 5 | SCP0052_CAPA_Report.cs:324 | else of (sheetName.Equals(SpdSheet.shtMain)) ▸ if (sheetName.Equals(SpdSheet.shtTotalYield)) | GRID_INIT | siObj.ChangeSheet | (1) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-940b47d1 | this.Load 외 5 | SCP0052_CAPA_Report.cs:325 | else of (sheetName.Equals(SpdSheet.shtMain)) ▸ if (sheetName.Equals(SpdSheet.shtTotalYield)) | GRID_INIT | siObj.InitSheet | (1) | 그리드 재구성/초기화 |  |  |  |
| AC-329944ae | this.Load 외 5 | SCP0052_CAPA_Report.cs:329 | else of (sheetName.Equals(SpdSheet.shtMain)) ▸ else of (sheetName.Equals(SpdSheet.shtTotalYield)) | GRID_INIT | siObj.ChangeSheet | (2) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-61486b5a | this.Load 외 5 | SCP0052_CAPA_Report.cs:330 | else of (sheetName.Equals(SpdSheet.shtMain)) ▸ else of (sheetName.Equals(SpdSheet.shtTotalYield)) | GRID_INIT | siObj.InitSheet | (2) | 그리드 재구성/초기화 |  |  |  |
| AC-7a54baca | this.Load 외 5 | SCP0052_CAPA_Report.cs:336 | if (sheetName.Equals(SpdSheet.shtYieldMonitoring)) | GRID_INIT | siObj.SetSheetHeaderColumn | (siObj, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-751ce1b6 | this.Load 외 5 | SCP0052_CAPA_Report.cs:339 | if (sheetName.Equals(SpdSheet.shtYieldMonitoring)) | UI_PROP | siObj.nIdxData | nIdxDataMain | 속성 nIdxData 설정 |  |  |  |
| AC-bc40c4be | this.Load 외 5 | SCP0052_CAPA_Report.cs:344 | else of (sheetName.Equals(SpdSheet.shtYieldMonitoring)) | GRID_INIT | siObj.SetSheetHeaderColumn | (siObj, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-13cb4b2e | this.Load 외 5 | SCP0052_CAPA_Report.cs:347 |  | GRID_INIT | siMain.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-a458d22f | this.Load 외 5 | SCP0052_CAPA_Report.cs:319 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2e50a603 | this.Load 외 5 | SCP0052_CAPA_Report.cs:320 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-f9a33b82 | this.Load 외 5 | SCP0052_CAPA_Report.cs:324 | else of (sheetName.Equals(SpdSheet.shtMain)) ▸ if (sheetName.Equals(SpdSheet.shtTotalYield)) | GRID_INIT | siObj.ChangeSheet | (1) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a72b4ce3 | this.Load 외 5 | SCP0052_CAPA_Report.cs:325 | else of (sheetName.Equals(SpdSheet.shtMain)) ▸ if (sheetName.Equals(SpdSheet.shtTotalYield)) | GRID_INIT | siObj.InitSheet | (1) | 그리드 재구성/초기화 |  |  |  |
| AC-d7746c45 | this.Load 외 5 | SCP0052_CAPA_Report.cs:329 | else of (sheetName.Equals(SpdSheet.shtMain)) ▸ else of (sheetName.Equals(SpdSheet.shtTotalYield)) | GRID_INIT | siObj.ChangeSheet | (2) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-238158f0 | this.Load 외 5 | SCP0052_CAPA_Report.cs:330 | else of (sheetName.Equals(SpdSheet.shtMain)) ▸ else of (sheetName.Equals(SpdSheet.shtTotalYield)) | GRID_INIT | siObj.InitSheet | (2) | 그리드 재구성/초기화 |  |  |  |
| AC-8e173e75 | this.Load 외 5 | SCP0052_CAPA_Report.cs:336 | if (sheetName.Equals(SpdSheet.shtYieldMonitoring)) | GRID_INIT | siObj.SetSheetHeaderColumn | (siObj, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-4093be73 | this.Load 외 5 | SCP0052_CAPA_Report.cs:339 | if (sheetName.Equals(SpdSheet.shtYieldMonitoring)) | UI_PROP | siObj.nIdxData | nIdxDataMain | 속성 nIdxData 설정 |  |  |  |
| AC-0429c708 | this.Load 외 5 | SCP0052_CAPA_Report.cs:344 | else of (sheetName.Equals(SpdSheet.shtYieldMonitoring)) | GRID_INIT | siObj.SetSheetHeaderColumn | (siObj, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-6560101e | this.Load 외 5 | SCP0052_CAPA_Report.cs:347 |  | GRID_INIT | siMain.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0052_CAPA_Report.SpdMain_ActiveSheetChanged

진입점: this.spdMain.ActiveSheetChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6f2e8f89 | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1196 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMain) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-95f516d0 | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1197 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-b250aae0 | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1199 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) | UI_PROP | layoutChkLoss.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-ba5d78a9 | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1200 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) | UI_PROP | layoutChkLineAssign.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-4ada14a5 | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1201 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) | UI_PROP | layoutChkTactTime.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-a5c9a7c7 | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1202 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) | UI_PROP | layoutChkYield.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-238e6b01 | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1203 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) | UI_PROP | layoutChkProduction.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-582ca510 | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1204 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) | UI_PROP | layoutChkAccuracy.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-dbac739e | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1206 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) | STATE | layoutOperation.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-12ff9a1a | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1207 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) | STATE | layoutVersionId.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-5e55845c | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1209 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) | STATE | layoutBuilding.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-8892d839 | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1210 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) | STATE | layoutLine.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-33e2444d | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1211 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) | STATE | layoutModel.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-34689833 | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1212 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) | STATE | layoutMaterial.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-de42c378 | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1213 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) | STATE | layoutNickName.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-9511c204 | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1215 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) | UI_PROP | layoutDivision.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-5386a5f0 | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1216 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) | UI_PROP | layoutDivision1.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-95a32709 | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1218 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) | UI_PROP | layoutGroup.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-450bb86e | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1219 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) | UI_PROP | layoutGroup1.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-e88a3af6 | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1221 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) | UI_PROP | layoutPlant.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-5884002d | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1222 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) | UI_PROP | layoutPlant1.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-913985aa | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1224 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) | UI_PROP | layoutBtnColumn.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-2510c4c4 | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1226 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) | UI_PROP | layoutBuilding.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-c1498c48 | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1227 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) | UI_PROP | layoutVersionId.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-410e2e0c | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1228 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) | UI_PROP | layoutLine.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-fe1629c2 | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1229 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) | UI_PROP | layoutOperation.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-0eeb137b | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1230 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) | UI_PROP | layoutModel.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-a94fcf20 | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1231 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) | UI_PROP | layoutMaterial.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-ca0895af | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1232 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) | UI_PROP | layoutNickName.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-1f396d7a | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1236 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (((FarPoint.Win.Spread.FpSpread)sender).Acti… | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtTotalYield) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-23fdab34 | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1237 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (((FarPoint.Win.Spread.FpSpread)sender).Acti… | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtTotalYield) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-e4705e20 | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1239 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (((FarPoint.Win.Spread.FpSpread)sender).Acti… | UI_PROP | layoutChkLoss.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-4118b792 | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1240 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (((FarPoint.Win.Spread.FpSpread)sender).Acti… | UI_PROP | layoutChkLineAssign.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-de3f8c35 | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1241 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (((FarPoint.Win.Spread.FpSpread)sender).Acti… | UI_PROP | layoutChkTactTime.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-4ae59808 | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1242 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (((FarPoint.Win.Spread.FpSpread)sender).Acti… | UI_PROP | layoutChkYield.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-01245580 | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1243 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (((FarPoint.Win.Spread.FpSpread)sender).Acti… | UI_PROP | layoutChkProduction.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-9f608aaf | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1244 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (((FarPoint.Win.Spread.FpSpread)sender).Acti… | UI_PROP | layoutChkAccuracy.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-573aa56f | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1246 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (((FarPoint.Win.Spread.FpSpread)sender).Acti… | STATE | layoutOperation.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-1c36e949 | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1247 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (((FarPoint.Win.Spread.FpSpread)sender).Acti… | STATE | layoutVersionId.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-d7532a9b | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1248 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (((FarPoint.Win.Spread.FpSpread)sender).Acti… | VALUE_CLEAR | clbVersionId.ControlValues | "" | 컨트롤 값 비움 |  |  |  |
| AC-25dd1b36 | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1249 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (((FarPoint.Win.Spread.FpSpread)sender).Acti… | VALUE_CLEAR | clbOperation.ControlValues | "" | 컨트롤 값 비움 |  |  |  |
| AC-8459f2e3 | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1251 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (((FarPoint.Win.Spread.FpSpread)sender).Acti… | STATE | layoutBuilding.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-9dc7996d | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1252 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (((FarPoint.Win.Spread.FpSpread)sender).Acti… | STATE | layoutLine.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-be2c4598 | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1253 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (((FarPoint.Win.Spread.FpSpread)sender).Acti… | STATE | layoutModel.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-a815fe83 | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1254 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (((FarPoint.Win.Spread.FpSpread)sender).Acti… | STATE | layoutMaterial.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-154721f6 | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1255 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (((FarPoint.Win.Spread.FpSpread)sender).Acti… | STATE | layoutNickName.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-388758e9 | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1257 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (((FarPoint.Win.Spread.FpSpread)sender).Acti… | UI_PROP | layoutDivision.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-d2546166 | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1258 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (((FarPoint.Win.Spread.FpSpread)sender).Acti… | UI_PROP | layoutDivision1.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-92d20208 | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1260 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (((FarPoint.Win.Spread.FpSpread)sender).Acti… | UI_PROP | layoutGroup.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-c74acdf7 | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1261 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (((FarPoint.Win.Spread.FpSpread)sender).Acti… | UI_PROP | layoutGroup1.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-1da92201 | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1263 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (((FarPoint.Win.Spread.FpSpread)sender).Acti… | UI_PROP | layoutPlant.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-7ff4c22d | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1264 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (((FarPoint.Win.Spread.FpSpread)sender).Acti… | UI_PROP | layoutPlant1.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-d875efb7 | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1266 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (((FarPoint.Win.Spread.FpSpread)sender).Acti… | UI_PROP | layoutBtnColumn.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-27c251af | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1268 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (((FarPoint.Win.Spread.FpSpread)sender).Acti… | UI_PROP | layoutBuilding.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-73d66998 | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1269 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (((FarPoint.Win.Spread.FpSpread)sender).Acti… | UI_PROP | layoutVersionId.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-ab3ff45f | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1270 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (((FarPoint.Win.Spread.FpSpread)sender).Acti… | UI_PROP | layoutLine.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-a0c6e09a | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1271 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (((FarPoint.Win.Spread.FpSpread)sender).Acti… | UI_PROP | layoutOperation.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-ab8dff29 | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1272 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (((FarPoint.Win.Spread.FpSpread)sender).Acti… | UI_PROP | layoutModel.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-0ba41e5f | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1273 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (((FarPoint.Win.Spread.FpSpread)sender).Acti… | UI_PROP | layoutMaterial.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-d5cdd687 | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1274 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (((FarPoint.Win.Spread.FpSpread)sender).Acti… | UI_PROP | layoutNickName.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-baabc75b | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1280 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (((FarPoint.Win.Spread.FpSpread)sender)… | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtYieldMonitoring) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0b0b8e1e | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1281 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (((FarPoint.Win.Spread.FpSpread)sender)… | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtYieldMonitoring) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-f5d7d116 | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1283 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (((FarPoint.Win.Spread.FpSpread)sender)… | UI_PROP | layoutChkLoss.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-b0ba2c92 | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1284 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (((FarPoint.Win.Spread.FpSpread)sender)… | UI_PROP | layoutChkLineAssign.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-b4e20c64 | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1285 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (((FarPoint.Win.Spread.FpSpread)sender)… | UI_PROP | layoutChkTactTime.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-121ffc1d | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1286 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (((FarPoint.Win.Spread.FpSpread)sender)… | UI_PROP | layoutChkYield.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-0886fa38 | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1287 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (((FarPoint.Win.Spread.FpSpread)sender)… | UI_PROP | layoutChkProduction.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-9ca26ae8 | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1288 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (((FarPoint.Win.Spread.FpSpread)sender)… | UI_PROP | layoutChkAccuracy.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-272832d8 | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1290 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (((FarPoint.Win.Spread.FpSpread)sender)… | STATE | layoutBuilding.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-a10a0c30 | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1291 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (((FarPoint.Win.Spread.FpSpread)sender)… | STATE | layoutVersionId.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-64cbd26a | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1292 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (((FarPoint.Win.Spread.FpSpread)sender)… | STATE | layoutLine.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-65d553ab | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1293 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (((FarPoint.Win.Spread.FpSpread)sender)… | STATE | layoutOperation.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-93b83a54 | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1294 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (((FarPoint.Win.Spread.FpSpread)sender)… | STATE | layoutModel.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-26cca597 | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1295 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (((FarPoint.Win.Spread.FpSpread)sender)… | STATE | layoutMaterial.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-4cc91ec6 | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1296 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (((FarPoint.Win.Spread.FpSpread)sender)… | STATE | layoutNickName.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-d7ac2489 | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1298 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (((FarPoint.Win.Spread.FpSpread)sender)… | UI_PROP | layoutDivision1.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-e7804bac | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1299 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (((FarPoint.Win.Spread.FpSpread)sender)… | UI_PROP | layoutGroup1.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-2efe8889 | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1300 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (((FarPoint.Win.Spread.FpSpread)sender)… | UI_PROP | layoutPlant1.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-6a3fb9b2 | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1302 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (((FarPoint.Win.Spread.FpSpread)sender)… | UI_PROP | layoutDivision.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-86e6274d | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1303 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (((FarPoint.Win.Spread.FpSpread)sender)… | UI_PROP | layoutGroup.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-16ae85c2 | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1304 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (((FarPoint.Win.Spread.FpSpread)sender)… | UI_PROP | layoutPlant.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-9f32d557 | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1306 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (((FarPoint.Win.Spread.FpSpread)sender)… | UI_PROP | layoutBtnColumn.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-d20ee2c3 | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1308 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (((FarPoint.Win.Spread.FpSpread)sender)… | UI_PROP | layoutBuilding.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-ecafffb8 | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1309 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (((FarPoint.Win.Spread.FpSpread)sender)… | UI_PROP | layoutVersionId.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-1339d873 | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1310 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (((FarPoint.Win.Spread.FpSpread)sender)… | UI_PROP | layoutLine.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-64e0daff | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1311 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (((FarPoint.Win.Spread.FpSpread)sender)… | UI_PROP | layoutOperation.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-c104a596 | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1312 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (((FarPoint.Win.Spread.FpSpread)sender)… | UI_PROP | layoutModel.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-675066eb | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1313 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (((FarPoint.Win.Spread.FpSpread)sender)… | UI_PROP | layoutMaterial.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-5c467eb0 | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1314 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (((FarPoint.Win.Spread.FpSpread)sender)… | UI_PROP | layoutNickName.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-486ae7c5 | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1196 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMain) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4cc6847d | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1197 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-f6620eeb | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1199 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) | UI_PROP | layoutChkLoss.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-6ba1f5d5 | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1200 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) | UI_PROP | layoutChkLineAssign.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-4309c1d0 | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1201 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) | UI_PROP | layoutChkTactTime.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-383b6de6 | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1202 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) | UI_PROP | layoutChkYield.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-ab2c2f4d | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1203 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) | UI_PROP | layoutChkProduction.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-fd1a3dcf | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1204 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) | UI_PROP | layoutChkAccuracy.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-8063cf4a | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1206 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) | STATE | layoutOperation.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-a8a0a668 | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1207 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) | STATE | layoutVersionId.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-3c120b5d | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1209 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) | STATE | layoutBuilding.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-e54c01f1 | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1210 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) | STATE | layoutLine.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-0ec8e67b | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1211 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) | STATE | layoutModel.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-e8565442 | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1212 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) | STATE | layoutMaterial.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-5c9754e9 | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1213 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) | STATE | layoutNickName.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-6dd8f3fe | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1215 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) | UI_PROP | layoutDivision.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-b57119aa | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1216 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) | UI_PROP | layoutDivision1.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-5af49588 | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1218 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) | UI_PROP | layoutGroup.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-27f3bc8b | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1219 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) | UI_PROP | layoutGroup1.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-2d58145c | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1221 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) | UI_PROP | layoutPlant.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-a5c40a4e | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1222 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) | UI_PROP | layoutPlant1.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-b4d8bc02 | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1224 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) | UI_PROP | layoutBtnColumn.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-3d62384f | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1226 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) | UI_PROP | layoutBuilding.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-4e9a78c5 | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1227 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) | UI_PROP | layoutVersionId.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-ef136bd1 | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1228 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) | UI_PROP | layoutLine.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-41532189 | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1229 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) | UI_PROP | layoutOperation.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-10a59a25 | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1230 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) | UI_PROP | layoutModel.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-4a68a552 | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1231 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) | UI_PROP | layoutMaterial.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-5ee9f685 | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1232 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) | UI_PROP | layoutNickName.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-800d4f0d | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1236 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (((FarPoint.Win.Spread.FpSpread)sender).Acti… | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtTotalYield) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6c093088 | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1237 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (((FarPoint.Win.Spread.FpSpread)sender).Acti… | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtTotalYield) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-710411d7 | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1239 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (((FarPoint.Win.Spread.FpSpread)sender).Acti… | UI_PROP | layoutChkLoss.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-113efda3 | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1240 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (((FarPoint.Win.Spread.FpSpread)sender).Acti… | UI_PROP | layoutChkLineAssign.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-77fc602c | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1241 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (((FarPoint.Win.Spread.FpSpread)sender).Acti… | UI_PROP | layoutChkTactTime.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-1d7acad2 | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1242 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (((FarPoint.Win.Spread.FpSpread)sender).Acti… | UI_PROP | layoutChkYield.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-41b0ab81 | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1243 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (((FarPoint.Win.Spread.FpSpread)sender).Acti… | UI_PROP | layoutChkProduction.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-0fd920a5 | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1244 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (((FarPoint.Win.Spread.FpSpread)sender).Acti… | UI_PROP | layoutChkAccuracy.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-3aa44471 | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1246 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (((FarPoint.Win.Spread.FpSpread)sender).Acti… | STATE | layoutOperation.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-9b269ba5 | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1247 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (((FarPoint.Win.Spread.FpSpread)sender).Acti… | STATE | layoutVersionId.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-a05c184a | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1248 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (((FarPoint.Win.Spread.FpSpread)sender).Acti… | VALUE_CLEAR | clbVersionId.ControlValues | "" | 컨트롤 값 비움 |  |  |  |
| AC-8a2afee5 | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1249 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (((FarPoint.Win.Spread.FpSpread)sender).Acti… | VALUE_CLEAR | clbOperation.ControlValues | "" | 컨트롤 값 비움 |  |  |  |
| AC-a24be8af | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1251 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (((FarPoint.Win.Spread.FpSpread)sender).Acti… | STATE | layoutBuilding.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-c2380fdc | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1252 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (((FarPoint.Win.Spread.FpSpread)sender).Acti… | STATE | layoutLine.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-6384acad | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1253 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (((FarPoint.Win.Spread.FpSpread)sender).Acti… | STATE | layoutModel.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-3be774ca | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1254 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (((FarPoint.Win.Spread.FpSpread)sender).Acti… | STATE | layoutMaterial.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-8b5d8c50 | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1255 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (((FarPoint.Win.Spread.FpSpread)sender).Acti… | STATE | layoutNickName.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-1949f250 | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1257 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (((FarPoint.Win.Spread.FpSpread)sender).Acti… | UI_PROP | layoutDivision.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-e771ee37 | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1258 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (((FarPoint.Win.Spread.FpSpread)sender).Acti… | UI_PROP | layoutDivision1.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-c96187e8 | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1260 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (((FarPoint.Win.Spread.FpSpread)sender).Acti… | UI_PROP | layoutGroup.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-4506d4a3 | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1261 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (((FarPoint.Win.Spread.FpSpread)sender).Acti… | UI_PROP | layoutGroup1.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-396e3588 | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1263 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (((FarPoint.Win.Spread.FpSpread)sender).Acti… | UI_PROP | layoutPlant.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-fc11ae78 | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1264 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (((FarPoint.Win.Spread.FpSpread)sender).Acti… | UI_PROP | layoutPlant1.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-82a9130a | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1266 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (((FarPoint.Win.Spread.FpSpread)sender).Acti… | UI_PROP | layoutBtnColumn.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-f4c8d0d8 | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1268 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (((FarPoint.Win.Spread.FpSpread)sender).Acti… | UI_PROP | layoutBuilding.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-f058806c | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1269 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (((FarPoint.Win.Spread.FpSpread)sender).Acti… | UI_PROP | layoutVersionId.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-c4b04c3f | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1270 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (((FarPoint.Win.Spread.FpSpread)sender).Acti… | UI_PROP | layoutLine.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-532e3f45 | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1271 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (((FarPoint.Win.Spread.FpSpread)sender).Acti… | UI_PROP | layoutOperation.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-e435e59c | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1272 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (((FarPoint.Win.Spread.FpSpread)sender).Acti… | UI_PROP | layoutModel.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-bdf78688 | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1273 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (((FarPoint.Win.Spread.FpSpread)sender).Acti… | UI_PROP | layoutMaterial.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-8455c5bc | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1274 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (((FarPoint.Win.Spread.FpSpread)sender).Acti… | UI_PROP | layoutNickName.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-f94f950c | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1280 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (((FarPoint.Win.Spread.FpSpread)sender)… | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtYieldMonitoring) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-77aa459f | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1281 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (((FarPoint.Win.Spread.FpSpread)sender)… | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtYieldMonitoring) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-8076b958 | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1283 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (((FarPoint.Win.Spread.FpSpread)sender)… | UI_PROP | layoutChkLoss.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-599e9a0d | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1284 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (((FarPoint.Win.Spread.FpSpread)sender)… | UI_PROP | layoutChkLineAssign.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-0372cde1 | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1285 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (((FarPoint.Win.Spread.FpSpread)sender)… | UI_PROP | layoutChkTactTime.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-ab47f5ad | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1286 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (((FarPoint.Win.Spread.FpSpread)sender)… | UI_PROP | layoutChkYield.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-9ca4daf4 | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1287 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (((FarPoint.Win.Spread.FpSpread)sender)… | UI_PROP | layoutChkProduction.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-34c58fa7 | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1288 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (((FarPoint.Win.Spread.FpSpread)sender)… | UI_PROP | layoutChkAccuracy.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-cc15b112 | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1290 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (((FarPoint.Win.Spread.FpSpread)sender)… | STATE | layoutBuilding.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-2424625a | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1291 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (((FarPoint.Win.Spread.FpSpread)sender)… | STATE | layoutVersionId.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-59df6146 | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1292 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (((FarPoint.Win.Spread.FpSpread)sender)… | STATE | layoutLine.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-2d93ed62 | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1293 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (((FarPoint.Win.Spread.FpSpread)sender)… | STATE | layoutOperation.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-5019a866 | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1294 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (((FarPoint.Win.Spread.FpSpread)sender)… | STATE | layoutModel.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-b17f2937 | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1295 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (((FarPoint.Win.Spread.FpSpread)sender)… | STATE | layoutMaterial.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-1f7607ae | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1296 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (((FarPoint.Win.Spread.FpSpread)sender)… | STATE | layoutNickName.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-47f5322a | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1298 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (((FarPoint.Win.Spread.FpSpread)sender)… | UI_PROP | layoutDivision1.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-dea14e4c | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1299 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (((FarPoint.Win.Spread.FpSpread)sender)… | UI_PROP | layoutGroup1.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-c759479f | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1300 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (((FarPoint.Win.Spread.FpSpread)sender)… | UI_PROP | layoutPlant1.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-64f5f9b6 | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1302 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (((FarPoint.Win.Spread.FpSpread)sender)… | UI_PROP | layoutDivision.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-c6995b8e | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1303 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (((FarPoint.Win.Spread.FpSpread)sender)… | UI_PROP | layoutGroup.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-491f2f64 | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1304 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (((FarPoint.Win.Spread.FpSpread)sender)… | UI_PROP | layoutPlant.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-7cfe414d | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1306 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (((FarPoint.Win.Spread.FpSpread)sender)… | UI_PROP | layoutBtnColumn.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-6c327ef2 | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1308 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (((FarPoint.Win.Spread.FpSpread)sender)… | UI_PROP | layoutBuilding.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-47be8a17 | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1309 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (((FarPoint.Win.Spread.FpSpread)sender)… | UI_PROP | layoutVersionId.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-0437ead3 | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1310 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (((FarPoint.Win.Spread.FpSpread)sender)… | UI_PROP | layoutLine.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-fd8a967d | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1311 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (((FarPoint.Win.Spread.FpSpread)sender)… | UI_PROP | layoutOperation.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-bbe7add9 | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1312 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (((FarPoint.Win.Spread.FpSpread)sender)… | UI_PROP | layoutModel.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-524bbb27 | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1313 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (((FarPoint.Win.Spread.FpSpread)sender)… | UI_PROP | layoutMaterial.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-63cc245c | this.spdMain.ActiveSheetChanged | SCP0052_CAPA_Report.cs:1314 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (((FarPoint.Win.Spread.FpSpread)sender)… | UI_PROP | layoutNickName.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |

## SCP0052_CAPA_Report.SpdMain_CellDoubleClick

진입점: spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-78173f32 | spdMain.CellDoubleClick | SCP0052_CAPA_Report.cs:1368 | if (siMain.ActiveSheetIndex == 2) | CALL_EXT | siMain.GetValue2 | (e.Row, e.Column) | ⚠ 의미 확인 필요 |  |  |  |
| AC-db90eb13 | spdMain.CellDoubleClick | SCP0052_CAPA_Report.cs:1368 | if (siMain.ActiveSheetIndex == 2) ▸ if (Convert.ToDouble(siMain.GetValue2(e.Row, e.Column)) == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8e2a5c28 | spdMain.CellDoubleClick | SCP0052_CAPA_Report.cs:1395 | if (siMain.ActiveSheetIndex == 2) | CALL_EXT | siMain.GetColumnText | (1, e.Column) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c3b8cad1 | spdMain.CellDoubleClick | SCP0052_CAPA_Report.cs:1401 | if (siMain.ActiveSheetIndex == 2) ▸ if ((gLabel != "" && colText == gLabel) \|\| (rLabel != "" && colText == rLabel) \|\| (yLabel != "" && c… | POPUP | new SCP0052_CAPAReportYieldMonitoringPopup | () | 팝업/폼 생성 |  |  |  |
| AC-ecd5c001 | spdMain.CellDoubleClick | SCP0052_CAPA_Report.cs:1403 | if (siMain.ActiveSheetIndex == 2) ▸ if ((gLabel != "" && colText == gLabel) \|\| (rLabel != "" && colText == rLabel) \|\| (yLabel != "" && c… | UI_PROP | popup.Width | 1180 | 속성 Width 설정 |  |  |  |
| AC-4407e2ed | spdMain.CellDoubleClick | SCP0052_CAPA_Report.cs:1404 | if (siMain.ActiveSheetIndex == 2) ▸ if ((gLabel != "" && colText == gLabel) \|\| (rLabel != "" && colText == rLabel) \|\| (yLabel != "" && c… | UI_PROP | popup.Height | 500 | 속성 Height 설정 |  |  |  |
| AC-a00be7b8 | spdMain.CellDoubleClick | SCP0052_CAPA_Report.cs:1405 | if (siMain.ActiveSheetIndex == 2) ▸ if ((gLabel != "" && colText == gLabel) \|\| (rLabel != "" && colText == rLabel) \|\| (yLabel != "" && c… | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-01d77ebd | spdMain.CellDoubleClick | SCP0052_CAPA_Report.cs:1423 | if (siMain.ActiveSheetIndex == 2) ▸ if ((gLabel != "" && colText == gLabel) \|\| (rLabel != "" && colText == rLabel) \|\| (yLabel != "" && c… | UI_PROP | popup.FROM_YYYYMM | drpPeriodMonth.MonthText1.Replace("-", "") | 속성 FROM_YYYYMM 설정 |  |  |  |
| AC-22ea28c6 | spdMain.CellDoubleClick | SCP0052_CAPA_Report.cs:1424 | if (siMain.ActiveSheetIndex == 2) ▸ if ((gLabel != "" && colText == gLabel) \|\| (rLabel != "" && colText == rLabel) \|\| (yLabel != "" && c… | UI_PROP | popup.TO_YYYYMM | drpPeriodMonth.MonthText2.Replace("-", "") | 속성 TO_YYYYMM 설정 |  |  |  |
| AC-f299a8d7 | spdMain.CellDoubleClick | SCP0052_CAPA_Report.cs:1425 | if (siMain.ActiveSheetIndex == 2) ▸ if ((gLabel != "" && colText == gLabel) \|\| (rLabel != "" && colText == rLabel) \|\| (yLabel != "" && c… | UI_PROP | popup.GROUP_ID | operation_group_id | 속성 GROUP_ID 설정 |  |  |  |
| AC-51e1b95a | spdMain.CellDoubleClick | SCP0052_CAPA_Report.cs:1426 | if (siMain.ActiveSheetIndex == 2) ▸ if ((gLabel != "" && colText == gLabel) \|\| (rLabel != "" && colText == rLabel) \|\| (yLabel != "" && c… | UI_PROP | popup.SIGNAL | signal | 속성 SIGNAL 설정 |  |  |  |
| AC-416eb0cb | spdMain.CellDoubleClick | SCP0052_CAPA_Report.cs:1427 | if (siMain.ActiveSheetIndex == 2) ▸ if ((gLabel != "" && colText == gLabel) \|\| (rLabel != "" && colText == rLabel) \|\| (yLabel != "" && c… | UI_PROP | popup.DIVISION_ID | division_id == "TOTAL" ? CString.GetCheckedListValue(dtMyDivision, cboDivision1.ControlVal… | 속성 DIVISION_ID 설정 |  |  |  |
| AC-75c70d61 | spdMain.CellDoubleClick | SCP0052_CAPA_Report.cs:1428 | if (siMain.ActiveSheetIndex == 2) ▸ if ((gLabel != "" && colText == gLabel) \|\| (rLabel != "" && colText == rLabel) \|\| (yLabel != "" && c… | UI_PROP | popup.SITE_ID | site_id | 속성 SITE_ID 설정 |  |  |  |
| AC-393f78f1 | spdMain.CellDoubleClick | SCP0052_CAPA_Report.cs:1429 | if (siMain.ActiveSheetIndex == 2) ▸ if ((gLabel != "" && colText == gLabel) \|\| (rLabel != "" && colText == rLabel) \|\| (yLabel != "" && c… | UI_PROP | popup.PLANT_ID | plant_id | 속성 PLANT_ID 설정 |  |  |  |
| AC-09917a45 | spdMain.CellDoubleClick | SCP0052_CAPA_Report.cs:1430 | if (siMain.ActiveSheetIndex == 2) ▸ if ((gLabel != "" && colText == gLabel) \|\| (rLabel != "" && colText == rLabel) \|\| (yLabel != "" && c… | UI_PROP | popup.CHECK_PRODUCTION | check_production | 속성 CHECK_PRODUCTION 설정 |  |  |  |
| AC-97d28007 | spdMain.CellDoubleClick | SCP0052_CAPA_Report.cs:1434 | if (siMain.ActiveSheetIndex == 2) ▸ if ((gLabel != "" && colText == gLabel) \|\| (rLabel != "" && colText == rLabel) \|\| (yLabel != "" && c… | UI_PROP | popup.GROUP_ID | group | 속성 GROUP_ID 설정 |  |  |  |
| AC-042ee9f0 | spdMain.CellDoubleClick | SCP0052_CAPA_Report.cs:1435 | if (siMain.ActiveSheetIndex == 2) ▸ if ((gLabel != "" && colText == gLabel) \|\| (rLabel != "" && colText == rLabel) \|\| (yLabel != "" && c… | UI_PROP | popup.PLANT_ID | CString.GetCheckedListValue(dtPlantByGroup1, clbPlant1.ControlValues) | 속성 PLANT_ID 설정 |  |  |  |
| AC-3e67cca0 | spdMain.CellDoubleClick | SCP0052_CAPA_Report.cs:1436 | if (siMain.ActiveSheetIndex == 2) ▸ if ((gLabel != "" && colText == gLabel) \|\| (rLabel != "" && colText == rLabel) \|\| (yLabel != "" && c… | UI_PROP | popup.SITE_ID | "" | 속성 SITE_ID 설정 |  |  |  |
| AC-3d27451d | spdMain.CellDoubleClick | SCP0052_CAPA_Report.cs:1440 | if (siMain.ActiveSheetIndex == 2) ▸ if ((gLabel != "" && colText == gLabel) \|\| (rLabel != "" && colText == rLabel) \|\| (yLabel != "" && c… | UI_PROP | popup.GROUP_ID | group | 속성 GROUP_ID 설정 |  |  |  |
| AC-82afa737 | spdMain.CellDoubleClick | SCP0052_CAPA_Report.cs:1441 | if (siMain.ActiveSheetIndex == 2) ▸ if ((gLabel != "" && colText == gLabel) \|\| (rLabel != "" && colText == rLabel) \|\| (yLabel != "" && c… | UI_PROP | popup.PLANT_ID | CString.GetCheckedListValue(dtPlantByGroup1, clbPlant1.ControlValues) | 속성 PLANT_ID 설정 |  |  |  |
| AC-00cca717 | spdMain.CellDoubleClick | SCP0052_CAPA_Report.cs:1442 | if (siMain.ActiveSheetIndex == 2) ▸ if ((gLabel != "" && colText == gLabel) \|\| (rLabel != "" && colText == rLabel) \|\| (yLabel != "" && c… | UI_PROP | popup.SITE_ID | "" | 속성 SITE_ID 설정 |  |  |  |
| AC-ef00d5c6 | spdMain.CellDoubleClick | SCP0052_CAPA_Report.cs:1446 | if (siMain.ActiveSheetIndex == 2) ▸ if ((gLabel != "" && colText == gLabel) \|\| (rLabel != "" && colText == rLabel) \|\| (yLabel != "" && c… | UI_PROP | popup.PLANT_ID | CString.GetCheckedListValue(dtPlantByGroup1, clbPlant1.ControlValues) | 속성 PLANT_ID 설정 |  |  |  |
| AC-d6f9147b | spdMain.CellDoubleClick | SCP0052_CAPA_Report.cs:1455 | if (siMain.ActiveSheetIndex == 2) ▸ if ((gLabel != "" && colText == gLabel) \|\| (rLabel != "" && colText == rLabel) \|\| (yLabel != "" && c… | UI_PROP | popup.FROM_YYYYMM | yyyymm | 속성 FROM_YYYYMM 설정 |  |  |  |
| AC-ecc16abd | spdMain.CellDoubleClick | SCP0052_CAPA_Report.cs:1456 | if (siMain.ActiveSheetIndex == 2) ▸ if ((gLabel != "" && colText == gLabel) \|\| (rLabel != "" && colText == rLabel) \|\| (yLabel != "" && c… | UI_PROP | popup.TO_YYYYMM | yyyymm | 속성 TO_YYYYMM 설정 |  |  |  |
| AC-51a3020a | spdMain.CellDoubleClick | SCP0052_CAPA_Report.cs:1460 | if (siMain.ActiveSheetIndex == 2) ▸ if ((gLabel != "" && colText == gLabel) \|\| (rLabel != "" && colText == rLabel) \|\| (yLabel != "" && c… | UI_PROP | popup.SIGNAL | popup.SIGNAL == "ACCURACY" ? "TOTAL" : popup.SIGNAL | 속성 SIGNAL 설정 |  |  |  |
| AC-ba01cbc4 | spdMain.CellDoubleClick | SCP0052_CAPA_Report.cs:1461 | if (siMain.ActiveSheetIndex == 2) ▸ if ((gLabel != "" && colText == gLabel) \|\| (rLabel != "" && colText == rLabel) \|\| (yLabel != "" && c… | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-228f6a53 | spdMain.CellDoubleClick | SCP0052_CAPA_Report.cs:1368 | if (siMain.ActiveSheetIndex == 2) | CALL_EXT | siMain.GetValue2 | (e.Row, e.Column) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5c78e291 | spdMain.CellDoubleClick | SCP0052_CAPA_Report.cs:1368 | if (siMain.ActiveSheetIndex == 2) ▸ if (Convert.ToDouble(siMain.GetValue2(e.Row, e.Column)) == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-cd624035 | spdMain.CellDoubleClick | SCP0052_CAPA_Report.cs:1395 | if (siMain.ActiveSheetIndex == 2) | CALL_EXT | siMain.GetColumnText | (1, e.Column) | ⚠ 의미 확인 필요 |  |  |  |
| AC-cac462af | spdMain.CellDoubleClick | SCP0052_CAPA_Report.cs:1401 | if (siMain.ActiveSheetIndex == 2) ▸ if ((gLabel != "" && colText == gLabel) \|\| (rLabel != "" && colText == rLabel) \|\| (yLabel != "" && c… | POPUP | new SCP0052_CAPAReportYieldMonitoringPopup | () | 팝업/폼 생성 |  |  |  |
| AC-45c6511e | spdMain.CellDoubleClick | SCP0052_CAPA_Report.cs:1403 | if (siMain.ActiveSheetIndex == 2) ▸ if ((gLabel != "" && colText == gLabel) \|\| (rLabel != "" && colText == rLabel) \|\| (yLabel != "" && c… | UI_PROP | popup.Width | 1180 | 속성 Width 설정 |  |  |  |
| AC-1ffee69f | spdMain.CellDoubleClick | SCP0052_CAPA_Report.cs:1404 | if (siMain.ActiveSheetIndex == 2) ▸ if ((gLabel != "" && colText == gLabel) \|\| (rLabel != "" && colText == rLabel) \|\| (yLabel != "" && c… | UI_PROP | popup.Height | 500 | 속성 Height 설정 |  |  |  |
| AC-089931e3 | spdMain.CellDoubleClick | SCP0052_CAPA_Report.cs:1405 | if (siMain.ActiveSheetIndex == 2) ▸ if ((gLabel != "" && colText == gLabel) \|\| (rLabel != "" && colText == rLabel) \|\| (yLabel != "" && c… | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-8b7a39a6 | spdMain.CellDoubleClick | SCP0052_CAPA_Report.cs:1423 | if (siMain.ActiveSheetIndex == 2) ▸ if ((gLabel != "" && colText == gLabel) \|\| (rLabel != "" && colText == rLabel) \|\| (yLabel != "" && c… | UI_PROP | popup.FROM_YYYYMM | drpPeriodMonth.MonthText1.Replace("-", "") | 속성 FROM_YYYYMM 설정 |  |  |  |
| AC-b42def1b | spdMain.CellDoubleClick | SCP0052_CAPA_Report.cs:1424 | if (siMain.ActiveSheetIndex == 2) ▸ if ((gLabel != "" && colText == gLabel) \|\| (rLabel != "" && colText == rLabel) \|\| (yLabel != "" && c… | UI_PROP | popup.TO_YYYYMM | drpPeriodMonth.MonthText2.Replace("-", "") | 속성 TO_YYYYMM 설정 |  |  |  |
| AC-0479756a | spdMain.CellDoubleClick | SCP0052_CAPA_Report.cs:1425 | if (siMain.ActiveSheetIndex == 2) ▸ if ((gLabel != "" && colText == gLabel) \|\| (rLabel != "" && colText == rLabel) \|\| (yLabel != "" && c… | UI_PROP | popup.GROUP_ID | operation_group_id | 속성 GROUP_ID 설정 |  |  |  |
| AC-6d853748 | spdMain.CellDoubleClick | SCP0052_CAPA_Report.cs:1426 | if (siMain.ActiveSheetIndex == 2) ▸ if ((gLabel != "" && colText == gLabel) \|\| (rLabel != "" && colText == rLabel) \|\| (yLabel != "" && c… | UI_PROP | popup.SIGNAL | signal | 속성 SIGNAL 설정 |  |  |  |
| AC-a73e78f6 | spdMain.CellDoubleClick | SCP0052_CAPA_Report.cs:1427 | if (siMain.ActiveSheetIndex == 2) ▸ if ((gLabel != "" && colText == gLabel) \|\| (rLabel != "" && colText == rLabel) \|\| (yLabel != "" && c… | UI_PROP | popup.DIVISION_ID | division_id == "TOTAL" ? CString.GetCheckedListValue(dtMyDivision, cboDivision1.ControlVal… | 속성 DIVISION_ID 설정 |  |  |  |
| AC-6aa55ecc | spdMain.CellDoubleClick | SCP0052_CAPA_Report.cs:1428 | if (siMain.ActiveSheetIndex == 2) ▸ if ((gLabel != "" && colText == gLabel) \|\| (rLabel != "" && colText == rLabel) \|\| (yLabel != "" && c… | UI_PROP | popup.SITE_ID | site_id | 속성 SITE_ID 설정 |  |  |  |
| AC-62593449 | spdMain.CellDoubleClick | SCP0052_CAPA_Report.cs:1429 | if (siMain.ActiveSheetIndex == 2) ▸ if ((gLabel != "" && colText == gLabel) \|\| (rLabel != "" && colText == rLabel) \|\| (yLabel != "" && c… | UI_PROP | popup.PLANT_ID | plant_id | 속성 PLANT_ID 설정 |  |  |  |
| AC-d0d82c9c | spdMain.CellDoubleClick | SCP0052_CAPA_Report.cs:1430 | if (siMain.ActiveSheetIndex == 2) ▸ if ((gLabel != "" && colText == gLabel) \|\| (rLabel != "" && colText == rLabel) \|\| (yLabel != "" && c… | UI_PROP | popup.CHECK_PRODUCTION | check_production | 속성 CHECK_PRODUCTION 설정 |  |  |  |
| AC-58fafdd5 | spdMain.CellDoubleClick | SCP0052_CAPA_Report.cs:1434 | if (siMain.ActiveSheetIndex == 2) ▸ if ((gLabel != "" && colText == gLabel) \|\| (rLabel != "" && colText == rLabel) \|\| (yLabel != "" && c… | UI_PROP | popup.GROUP_ID | group | 속성 GROUP_ID 설정 |  |  |  |
| AC-99dac293 | spdMain.CellDoubleClick | SCP0052_CAPA_Report.cs:1435 | if (siMain.ActiveSheetIndex == 2) ▸ if ((gLabel != "" && colText == gLabel) \|\| (rLabel != "" && colText == rLabel) \|\| (yLabel != "" && c… | UI_PROP | popup.PLANT_ID | CString.GetCheckedListValue(dtPlantByGroup1, clbPlant1.ControlValues) | 속성 PLANT_ID 설정 |  |  |  |
| AC-6deb2ca1 | spdMain.CellDoubleClick | SCP0052_CAPA_Report.cs:1436 | if (siMain.ActiveSheetIndex == 2) ▸ if ((gLabel != "" && colText == gLabel) \|\| (rLabel != "" && colText == rLabel) \|\| (yLabel != "" && c… | UI_PROP | popup.SITE_ID | "" | 속성 SITE_ID 설정 |  |  |  |
| AC-7c275688 | spdMain.CellDoubleClick | SCP0052_CAPA_Report.cs:1440 | if (siMain.ActiveSheetIndex == 2) ▸ if ((gLabel != "" && colText == gLabel) \|\| (rLabel != "" && colText == rLabel) \|\| (yLabel != "" && c… | UI_PROP | popup.GROUP_ID | group | 속성 GROUP_ID 설정 |  |  |  |
| AC-34e39fcc | spdMain.CellDoubleClick | SCP0052_CAPA_Report.cs:1441 | if (siMain.ActiveSheetIndex == 2) ▸ if ((gLabel != "" && colText == gLabel) \|\| (rLabel != "" && colText == rLabel) \|\| (yLabel != "" && c… | UI_PROP | popup.PLANT_ID | CString.GetCheckedListValue(dtPlantByGroup1, clbPlant1.ControlValues) | 속성 PLANT_ID 설정 |  |  |  |
| AC-e35b0790 | spdMain.CellDoubleClick | SCP0052_CAPA_Report.cs:1442 | if (siMain.ActiveSheetIndex == 2) ▸ if ((gLabel != "" && colText == gLabel) \|\| (rLabel != "" && colText == rLabel) \|\| (yLabel != "" && c… | UI_PROP | popup.SITE_ID | "" | 속성 SITE_ID 설정 |  |  |  |
| AC-c6da94ab | spdMain.CellDoubleClick | SCP0052_CAPA_Report.cs:1446 | if (siMain.ActiveSheetIndex == 2) ▸ if ((gLabel != "" && colText == gLabel) \|\| (rLabel != "" && colText == rLabel) \|\| (yLabel != "" && c… | UI_PROP | popup.PLANT_ID | CString.GetCheckedListValue(dtPlantByGroup1, clbPlant1.ControlValues) | 속성 PLANT_ID 설정 |  |  |  |
| AC-3471dbdc | spdMain.CellDoubleClick | SCP0052_CAPA_Report.cs:1455 | if (siMain.ActiveSheetIndex == 2) ▸ if ((gLabel != "" && colText == gLabel) \|\| (rLabel != "" && colText == rLabel) \|\| (yLabel != "" && c… | UI_PROP | popup.FROM_YYYYMM | yyyymm | 속성 FROM_YYYYMM 설정 |  |  |  |
| AC-8fb36047 | spdMain.CellDoubleClick | SCP0052_CAPA_Report.cs:1456 | if (siMain.ActiveSheetIndex == 2) ▸ if ((gLabel != "" && colText == gLabel) \|\| (rLabel != "" && colText == rLabel) \|\| (yLabel != "" && c… | UI_PROP | popup.TO_YYYYMM | yyyymm | 속성 TO_YYYYMM 설정 |  |  |  |
| AC-85789f07 | spdMain.CellDoubleClick | SCP0052_CAPA_Report.cs:1460 | if (siMain.ActiveSheetIndex == 2) ▸ if ((gLabel != "" && colText == gLabel) \|\| (rLabel != "" && colText == rLabel) \|\| (yLabel != "" && c… | UI_PROP | popup.SIGNAL | popup.SIGNAL == "ACCURACY" ? "TOTAL" : popup.SIGNAL | 속성 SIGNAL 설정 |  |  |  |
| AC-4f87c2d1 | spdMain.CellDoubleClick | SCP0052_CAPA_Report.cs:1461 | if (siMain.ActiveSheetIndex == 2) ▸ if ((gLabel != "" && colText == gLabel) \|\| (rLabel != "" && colText == rLabel) \|\| (yLabel != "" && c… | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## SCP0052_CAPAReportYieldMonitoringPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2539253a | this.Load | SCP0052_CAPAReportYieldMonitoringPopup.cs:100 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 2, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-ff02e03d | this.Load | SCP0052_CAPAReportYieldMonitoringPopup.cs:101 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-f14f5b40 | this.Load | SCP0052_CAPAReportYieldMonitoringPopup.cs:103 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b6ffb6ab | this.Load | SCP0052_CAPAReportYieldMonitoringPopup.cs:100 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 2, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-03a125e5 | this.Load | SCP0052_CAPAReportYieldMonitoringPopup.cs:101 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-0982823a | this.Load | SCP0052_CAPAReportYieldMonitoringPopup.cs:103 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0052_CAPAReportYieldMonitoringPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1bdc0f17 | this.Load | SCP0052_CAPAReportYieldMonitoringPopup.cs:94 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |
| AC-ab00125b | this.Load | SCP0052_CAPAReportYieldMonitoringPopup.cs:94 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## SCP0052_CAPAReportYieldMonitoringPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-76b642da | Dispose | SCP0052_CAPAReportYieldMonitoringPopup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-c2cafbe8 | Dispose | SCP0052_CAPAReportYieldMonitoringPopup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0052_CAPAReportYieldMonitoringPopup.FindData

진입점: this.Load / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3c9664b7 | this.Load 외 1 | SCP0052_CAPAReportYieldMonitoringPopup.cs:148 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-7a9c8b1b | this.Load 외 1 | SCP0052_CAPAReportYieldMonitoringPopup.cs:152 | lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0052_GET_CAPA_REPORT_YIELD_MONITORING_DETAIL") ⇒ SCP.SCP0052_GET_CAPA_REPORT_YIELD_MONITORING_DETAIL | 엔드포인트 요청 생성 |  |  |  |
| AC-e8393ca2 | this.Load 외 1 | SCP0052_CAPAReportYieldMonitoringPopup.cs:153 | lambda | DATA_OP | request.Parameters["p_from_yyyymm"] | FROM_YYYYMM | 행/컬럼 값 대입 |  |  |  |
| AC-df0bd154 | this.Load 외 1 | SCP0052_CAPAReportYieldMonitoringPopup.cs:154 | lambda | DATA_OP | request.Parameters["p_to_yyyymm"] | TO_YYYYMM | 행/컬럼 값 대입 |  |  |  |
| AC-d391aff1 | this.Load 외 1 | SCP0052_CAPAReportYieldMonitoringPopup.cs:155 | lambda | DATA_OP | request.Parameters["p_division_id"] | DIVISION_ID | 행/컬럼 값 대입 |  |  |  |
| AC-45244efe | this.Load 외 1 | SCP0052_CAPAReportYieldMonitoringPopup.cs:156 | lambda | DATA_OP | request.Parameters["p_group"] | GROUP_ID | 행/컬럼 값 대입 |  |  |  |
| AC-dc693f0e | this.Load 외 1 | SCP0052_CAPAReportYieldMonitoringPopup.cs:157 | lambda | DATA_OP | request.Parameters["p_plant_id"] | PLANT_ID.Equals("Sub-Total") ? "" : PLANT_ID | 행/컬럼 값 대입 |  |  |  |
| AC-6bb82d19 | this.Load 외 1 | SCP0052_CAPAReportYieldMonitoringPopup.cs:158 | lambda | DATA_OP | request.Parameters["p_site_id"] | SITE_ID.Equals("Sub-Total") ? "" : SITE_ID | 행/컬럼 값 대입 |  |  |  |
| AC-681f25fe | this.Load 외 1 | SCP0052_CAPAReportYieldMonitoringPopup.cs:159 | lambda | DATA_OP | request.Parameters["p_signal"] | SIGNAL | 행/컬럼 값 대입 |  |  |  |
| AC-24f80337 | this.Load 외 1 | SCP0052_CAPAReportYieldMonitoringPopup.cs:160 | lambda | DATA_OP | request.Parameters["p_check_production"] | CHECK_PRODUCTION | 행/컬럼 값 대입 |  |  |  |
| AC-66e1ad63 | this.Load 외 1 | SCP0052_CAPAReportYieldMonitoringPopup.cs:161 | lambda | DATA_OP | request.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-36ccf312 | this.Load 외 1 | SCP0052_CAPAReportYieldMonitoringPopup.cs:162 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-15bc1344 | this.Load 외 1 | SCP0052_CAPAReportYieldMonitoringPopup.cs:164 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-4f6a6f46 | this.Load 외 1 | SCP0052_CAPAReportYieldMonitoringPopup.cs:168 |  | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-6fa2c0b6 | this.Load 외 1 | SCP0052_CAPAReportYieldMonitoringPopup.cs:181 | for (i<ds.Tables[0].Rows.Count) ▸ if (row["SIGNAL"].Equals("GREEN")) | GRID_STYLE | siMain.SetBGColor | (i, siMain.GetColumnIndex(DefColumns.SIGNAL), i, siMain.GetColumnIndex(DefColumns.SIGNAL),… | 그리드 표시 설정 |  |  |  |
| AC-201c7f05 | this.Load 외 1 | SCP0052_CAPAReportYieldMonitoringPopup.cs:185 | for (i<ds.Tables[0].Rows.Count) ▸ else of (row["SIGNAL"].Equals("GREEN")) ▸ if (row["SIGNAL"].Equals("RED")) | GRID_STYLE | siMain.SetBGColor | (i, siMain.GetColumnIndex(DefColumns.SIGNAL), i, siMain.GetColumnIndex(DefColumns.SIGNAL),… | 그리드 표시 설정 |  |  |  |
| AC-509df7d1 | this.Load 외 1 | SCP0052_CAPAReportYieldMonitoringPopup.cs:189 | for (i<ds.Tables[0].Rows.Count) ▸ else of (row["SIGNAL"].Equals("GREEN")) ▸ else of (row["SIGNAL"].Equals("RED")) ▸ if (row["SIGNAL"].Equals… | GRID_STYLE | siMain.SetBGColor | (i, siMain.GetColumnIndex(DefColumns.SIGNAL), i, siMain.GetColumnIndex(DefColumns.SIGNAL),… | 그리드 표시 설정 |  |  |  |
| AC-f6070453 | this.Load 외 1 | SCP0052_CAPAReportYieldMonitoringPopup.cs:148 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-92497cb9 | this.Load 외 1 | SCP0052_CAPAReportYieldMonitoringPopup.cs:152 | lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0052_GET_CAPA_REPORT_YIELD_MONITORING_DETAIL") ⇒ SCP.SCP0052_GET_CAPA_REPORT_YIELD_MONITORING_DETAIL | 엔드포인트 요청 생성 |  |  |  |
| AC-e427b929 | this.Load 외 1 | SCP0052_CAPAReportYieldMonitoringPopup.cs:153 | lambda | DATA_OP | request.Parameters["p_from_yyyymm"] | FROM_YYYYMM | 행/컬럼 값 대입 |  |  |  |
| AC-5cbe90f3 | this.Load 외 1 | SCP0052_CAPAReportYieldMonitoringPopup.cs:154 | lambda | DATA_OP | request.Parameters["p_to_yyyymm"] | TO_YYYYMM | 행/컬럼 값 대입 |  |  |  |
| AC-b07fdf53 | this.Load 외 1 | SCP0052_CAPAReportYieldMonitoringPopup.cs:155 | lambda | DATA_OP | request.Parameters["p_division_id"] | DIVISION_ID | 행/컬럼 값 대입 |  |  |  |
| AC-2ecb78a5 | this.Load 외 1 | SCP0052_CAPAReportYieldMonitoringPopup.cs:156 | lambda | DATA_OP | request.Parameters["p_group"] | GROUP_ID | 행/컬럼 값 대입 |  |  |  |
| AC-c4f90e9d | this.Load 외 1 | SCP0052_CAPAReportYieldMonitoringPopup.cs:157 | lambda | DATA_OP | request.Parameters["p_plant_id"] | PLANT_ID.Equals("Sub-Total") ? "" : PLANT_ID | 행/컬럼 값 대입 |  |  |  |
| AC-e4ebfe04 | this.Load 외 1 | SCP0052_CAPAReportYieldMonitoringPopup.cs:158 | lambda | DATA_OP | request.Parameters["p_site_id"] | SITE_ID.Equals("Sub-Total") ? "" : SITE_ID | 행/컬럼 값 대입 |  |  |  |
| AC-33364a81 | this.Load 외 1 | SCP0052_CAPAReportYieldMonitoringPopup.cs:159 | lambda | DATA_OP | request.Parameters["p_signal"] | SIGNAL | 행/컬럼 값 대입 |  |  |  |
| AC-ca8f72b6 | this.Load 외 1 | SCP0052_CAPAReportYieldMonitoringPopup.cs:160 | lambda | DATA_OP | request.Parameters["p_check_production"] | CHECK_PRODUCTION | 행/컬럼 값 대입 |  |  |  |
| AC-a0637133 | this.Load 외 1 | SCP0052_CAPAReportYieldMonitoringPopup.cs:161 | lambda | DATA_OP | request.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-53ecd1d7 | this.Load 외 1 | SCP0052_CAPAReportYieldMonitoringPopup.cs:162 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-88c3c57b | this.Load 외 1 | SCP0052_CAPAReportYieldMonitoringPopup.cs:164 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-0d3ae202 | this.Load 외 1 | SCP0052_CAPAReportYieldMonitoringPopup.cs:168 |  | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-ee3bd7ee | this.Load 외 1 | SCP0052_CAPAReportYieldMonitoringPopup.cs:181 | for (i<ds.Tables[0].Rows.Count) ▸ if (row["SIGNAL"].Equals("GREEN")) | GRID_STYLE | siMain.SetBGColor | (i, siMain.GetColumnIndex(DefColumns.SIGNAL), i, siMain.GetColumnIndex(DefColumns.SIGNAL),… | 그리드 표시 설정 |  |  |  |
| AC-997b37a1 | this.Load 외 1 | SCP0052_CAPAReportYieldMonitoringPopup.cs:185 | for (i<ds.Tables[0].Rows.Count) ▸ else of (row["SIGNAL"].Equals("GREEN")) ▸ if (row["SIGNAL"].Equals("RED")) | GRID_STYLE | siMain.SetBGColor | (i, siMain.GetColumnIndex(DefColumns.SIGNAL), i, siMain.GetColumnIndex(DefColumns.SIGNAL),… | 그리드 표시 설정 |  |  |  |
| AC-ca5f890c | this.Load 외 1 | SCP0052_CAPAReportYieldMonitoringPopup.cs:189 | for (i<ds.Tables[0].Rows.Count) ▸ else of (row["SIGNAL"].Equals("GREEN")) ▸ else of (row["SIGNAL"].Equals("RED")) ▸ if (row["SIGNAL"].Equals… | GRID_STYLE | siMain.SetBGColor | (i, siMain.GetColumnIndex(DefColumns.SIGNAL), i, siMain.GetColumnIndex(DefColumns.SIGNAL),… | 그리드 표시 설정 |  |  |  |

## SCP0052_CAPAReportYieldMonitoringPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-63504437 | this.Load | SCP0052_CAPAReportYieldMonitoringPopup.cs:79 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-175fa13a | this.Load | SCP0052_CAPAReportYieldMonitoringPopup.cs:79 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0052_CAPAReportYieldMonitoringPopup.InitSpread

진입점: this.Load / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e96c3f7f | this.Load 외 1 | SCP0052_CAPAReportYieldMonitoringPopup.cs:110 |  | GRID_INIT | siMain.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-1a684208 | this.Load 외 1 | SCP0052_CAPAReportYieldMonitoringPopup.cs:112 |  | GRID_INIT | siMain.SetSheetHeaderColumn | (siMain, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-4fa1d113 | this.Load 외 1 | SCP0052_CAPAReportYieldMonitoringPopup.cs:110 |  | GRID_INIT | siMain.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-a7314fe0 | this.Load 외 1 | SCP0052_CAPAReportYieldMonitoringPopup.cs:112 |  | GRID_INIT | siMain.SetSheetHeaderColumn | (siMain, 2) | 그리드 재구성/초기화 |  |  |  |

