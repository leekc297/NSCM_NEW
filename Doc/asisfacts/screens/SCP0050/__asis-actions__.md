# AS-IS 액션 대조표 — SCP0050

> 원천: `Doc/asisfacts/screens/SCP0050/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 855행 · 메서드 64 · 종류 DATA_OP 159 · UI_PROP 123 · GRID_SET 104 · FLAG 72 · POPUP 57 · GRID_INIT 50 · RETURN 48 · LIST_REBIND 44 · UI_MISC 38 · GRID_LOCK 36 · COMBO_DATA 32 · ENDPOINT 24 · CALL_EXT 18 · GRID_COMBO 18 · MESSAGE 11 · VALIDATE 6 · GRID_BIND 5 · VALUE_SET 3 · STATE_RESET 2 · FOCUS 1 · EXCEL 1 · CALL_BASE 1 · STATE 1 · THROW 1 · ⚠ 의미 확인 필요 19


## SCP0050_CAPA_PIC.btnExcelImport_Click

진입점: this.btnExcelImport.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-019ca27e | this.btnExcelImport.Click | SCP0050_CAPA_PIC.cs:1147 |  | POPUP | new SCP0050_ExcelPopup | () | 팝업/폼 생성 |  |  |  |
| AC-a6a23669 | this.btnExcelImport.Click | SCP0050_CAPA_PIC.cs:1149 |  | GRID_SET | poup.KeyColumns["SITE_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-2ed3e9f4 | this.btnExcelImport.Click | SCP0050_CAPA_PIC.cs:1150 |  | GRID_SET | poup.KeyColumns["PLANT_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-3b6e0d63 | this.btnExcelImport.Click | SCP0050_CAPA_PIC.cs:1151 |  | GRID_SET | poup.KeyColumns["FACTORY_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-6e0d9e15 | this.btnExcelImport.Click | SCP0050_CAPA_PIC.cs:1152 |  | GRID_SET | poup.KeyColumns["LINE_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-465d11f0 | this.btnExcelImport.Click | SCP0050_CAPA_PIC.cs:1153 |  | GRID_SET | poup.KeyColumns["OPERATION_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-84b0fb46 | this.btnExcelImport.Click | SCP0050_CAPA_PIC.cs:1154 |  | GRID_SET | poup.KeyColumns["ELECTRODE_TYPE"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-2ddf1656 | this.btnExcelImport.Click | SCP0050_CAPA_PIC.cs:1155 |  | GRID_SET | poup.KeyColumns["Level1"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-de10cf5d | this.btnExcelImport.Click | SCP0050_CAPA_PIC.cs:1156 |  | GRID_SET | poup.KeyColumns["Level2"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-fd80633b | this.btnExcelImport.Click | SCP0050_CAPA_PIC.cs:1158 |  | GRID_SET | poup.KeyColumns["USER_ID_1"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-dfbd22cc | this.btnExcelImport.Click | SCP0050_CAPA_PIC.cs:1159 |  | GRID_SET | poup.KeyColumns["USER_ID_2"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-3938d963 | this.btnExcelImport.Click | SCP0050_CAPA_PIC.cs:1160 |  | GRID_SET | poup.KeyColumns["USER_ID_3"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-e5c12cd6 | this.btnExcelImport.Click | SCP0050_CAPA_PIC.cs:1161 |  | GRID_SET | poup.KeyColumns["USER_ID_4"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-8e2d2232 | this.btnExcelImport.Click | SCP0050_CAPA_PIC.cs:1162 |  | GRID_SET | poup.KeyColumns["USER_ID_5"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-b4731f06 | this.btnExcelImport.Click | SCP0050_CAPA_PIC.cs:1163 |  | GRID_SET | poup.KeyColumns["USER_ID_6"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-6a2391f9 | this.btnExcelImport.Click | SCP0050_CAPA_PIC.cs:1164 |  | GRID_SET | poup.KeyColumns["USER_ID_7"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-1240eb28 | this.btnExcelImport.Click | SCP0050_CAPA_PIC.cs:1165 |  | GRID_SET | poup.KeyColumns["USER_ID_8"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-eb8badcb | this.btnExcelImport.Click | SCP0050_CAPA_PIC.cs:1166 |  | GRID_SET | poup.KeyColumns["USER_ID_9"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-935ba647 | this.btnExcelImport.Click | SCP0050_CAPA_PIC.cs:1167 |  | GRID_SET | poup.KeyColumns["USER_ID_10"] | false | 그리드 속성/값 설정 |  |  |  |
| AC-9fe827ef | this.btnExcelImport.Click | SCP0050_CAPA_PIC.cs:1169 |  | DATA_OP | poup.ColumnTitle["SITE_ID"] | "Site" | 행/컬럼 값 대입 |  |  |  |
| AC-7631920b | this.btnExcelImport.Click | SCP0050_CAPA_PIC.cs:1170 |  | DATA_OP | poup.ColumnTitle["PLANT_ID"] | "Plant" | 행/컬럼 값 대입 |  |  |  |
| AC-13f7d63e | this.btnExcelImport.Click | SCP0050_CAPA_PIC.cs:1171 |  | DATA_OP | poup.ColumnTitle["FACTORY_ID"] | "Building" | 행/컬럼 값 대입 |  |  |  |
| AC-b82265c0 | this.btnExcelImport.Click | SCP0050_CAPA_PIC.cs:1172 |  | DATA_OP | poup.ColumnTitle["LINE_ID"] | "Line" | 행/컬럼 값 대입 |  |  |  |
| AC-53b06e8b | this.btnExcelImport.Click | SCP0050_CAPA_PIC.cs:1173 |  | DATA_OP | poup.ColumnTitle["OPERATION_ID"] | "Operation" | 행/컬럼 값 대입 |  |  |  |
| AC-2ea84899 | this.btnExcelImport.Click | SCP0050_CAPA_PIC.cs:1174 |  | DATA_OP | poup.ColumnTitle["Level1"] | "Level1" | 행/컬럼 값 대입 |  |  |  |
| AC-642f2335 | this.btnExcelImport.Click | SCP0050_CAPA_PIC.cs:1175 |  | DATA_OP | poup.ColumnTitle["Level2"] | "Level2" | 행/컬럼 값 대입 |  |  |  |
| AC-ae4e634c | this.btnExcelImport.Click | SCP0050_CAPA_PIC.cs:1177 |  | DATA_OP | poup.ColumnTitle["USER_ID_1"] | "PIC Persion" | 행/컬럼 값 대입 |  |  |  |
| AC-00c37618 | this.btnExcelImport.Click | SCP0050_CAPA_PIC.cs:1178 |  | DATA_OP | poup.ColumnTitle["USER_ID_2"] | "User2" | 행/컬럼 값 대입 |  |  |  |
| AC-a977ce27 | this.btnExcelImport.Click | SCP0050_CAPA_PIC.cs:1179 |  | DATA_OP | poup.ColumnTitle["USER_ID_3"] | "User3" | 행/컬럼 값 대입 |  |  |  |
| AC-90b8c558 | this.btnExcelImport.Click | SCP0050_CAPA_PIC.cs:1180 |  | DATA_OP | poup.ColumnTitle["USER_ID_4"] | "User4" | 행/컬럼 값 대입 |  |  |  |
| AC-aec45237 | this.btnExcelImport.Click | SCP0050_CAPA_PIC.cs:1181 |  | DATA_OP | poup.ColumnTitle["USER_ID_5"] | "User5" | 행/컬럼 값 대입 |  |  |  |
| AC-41ebd2db | this.btnExcelImport.Click | SCP0050_CAPA_PIC.cs:1182 |  | DATA_OP | poup.ColumnTitle["USER_ID_6"] | "User6" | 행/컬럼 값 대입 |  |  |  |
| AC-b2fe9ad3 | this.btnExcelImport.Click | SCP0050_CAPA_PIC.cs:1183 |  | DATA_OP | poup.ColumnTitle["USER_ID_7"] | "User7" | 행/컬럼 값 대입 |  |  |  |
| AC-0d83406a | this.btnExcelImport.Click | SCP0050_CAPA_PIC.cs:1184 |  | DATA_OP | poup.ColumnTitle["USER_ID_8"] | "User8" | 행/컬럼 값 대입 |  |  |  |
| AC-4e27f42f | this.btnExcelImport.Click | SCP0050_CAPA_PIC.cs:1185 |  | DATA_OP | poup.ColumnTitle["USER_ID_9"] | "User9" | 행/컬럼 값 대입 |  |  |  |
| AC-48b3d92a | this.btnExcelImport.Click | SCP0050_CAPA_PIC.cs:1186 |  | DATA_OP | poup.ColumnTitle["USER_ID_10"] | "User10" | 행/컬럼 값 대입 |  |  |  |
| AC-179765eb | this.btnExcelImport.Click | SCP0050_CAPA_PIC.cs:1188 |  | POPUP | poup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## SCP0050_CAPA_PIC.ClbBuilding_SelectedIndexChanged

진입점: clbBuilding.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5b997356 | clbBuilding.SelectedIndexChanged | SCP0050_CAPA_PIC.cs:822 |  | FLAG | dtLineByOperationPlantId | Data_SCP.Common(Data_SCP.Type.LineByOperationPlantId, false, pDivisionID, pPlantID, pFacto… | 화면 필드/플래그 변경 |  |  |  |
| AC-f9212809 | clbBuilding.SelectedIndexChanged | SCP0050_CAPA_PIC.cs:822 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.LineByOperationPlantId, false, pDivisionID, pPlantID, pFactoryID, pGroupID) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-be09b73f | clbBuilding.SelectedIndexChanged | SCP0050_CAPA_PIC.cs:823 |  | LIST_REBIND | clsCtrl.setListBox | (dtLineByOperationPlantId, clbLine, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-c0247d6d | clbBuilding.SelectedIndexChanged | SCP0050_CAPA_PIC.cs:827 |  | FLAG | dtOperationByLine | Data.Common(Data.Type.OperationByLine, false, pDivisionID, pPlantID, pFactoryID, pLineId, … ⇒ biz:CommonData.CommonDataList [code=OperationByLine] | 화면 필드/플래그 변경 |  |  |  |
| AC-dc781e05 | clbBuilding.SelectedIndexChanged | SCP0050_CAPA_PIC.cs:827 |  | COMBO_DATA | Data.Common | (Data.Type.OperationByLine, false, pDivisionID, pPlantID, pFactoryID, pLineId, pGroupID) ⇒ biz:CommonData.CommonDataList [code=OperationByLine] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-08c4415c | clbBuilding.SelectedIndexChanged | SCP0050_CAPA_PIC.cs:828 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperationByLine, clbOperation, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-2a15ce76 | clbBuilding.SelectedIndexChanged | SCP0050_CAPA_PIC.cs:812 |  | FLAG | dtLineByOperationPlantId | Data_SCP.Common(Data_SCP.Type.LineByOperationPlantId, false, division, pPlantID, pFactoryI… | 화면 필드/플래그 변경 |  |  |  |
| AC-3c7d9220 | clbBuilding.SelectedIndexChanged | SCP0050_CAPA_PIC.cs:812 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.LineByOperationPlantId, false, division, pPlantID, pFactoryID, pGroupID) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-812c3ee6 | clbBuilding.SelectedIndexChanged | SCP0050_CAPA_PIC.cs:813 |  | LIST_REBIND | clsCtrl.setListBox | (dtLineByOperationPlantId, clbLine, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-ed5fdcc4 | clbBuilding.SelectedIndexChanged | SCP0050_CAPA_PIC.cs:817 |  | FLAG | dtOperationByLine | Data.Common(Data.Type.OperationByLine, false, division, pPlantID, pFactoryID, pLineId, pGr… ⇒ biz:CommonData.CommonDataList [code=OperationByLine] | 화면 필드/플래그 변경 |  |  |  |
| AC-9f9b9dfb | clbBuilding.SelectedIndexChanged | SCP0050_CAPA_PIC.cs:817 |  | COMBO_DATA | Data.Common | (Data.Type.OperationByLine, false, division, pPlantID, pFactoryID, pLineId, pGroupID) ⇒ biz:CommonData.CommonDataList [code=OperationByLine] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-936b732e | clbBuilding.SelectedIndexChanged | SCP0050_CAPA_PIC.cs:818 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperationByLine, clbOperation, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0050_CAPA_PIC.ClbCategoryId_SelectedIndexChanged

진입점: cboCategoryId.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fc5020fe | cboCategoryId.SelectedIndexChanged | SCP0050_CAPA_PIC.cs:847 |  | FLAG | dtMDMKeyId | Data_SCP.Common(Data_SCP.Type.MDMKeyIdByCategory, false, pCatgegoryId, "", "", "", "") | 화면 필드/플래그 변경 |  |  |  |
| AC-0000c009 | cboCategoryId.SelectedIndexChanged | SCP0050_CAPA_PIC.cs:847 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.MDMKeyIdByCategory, false, pCatgegoryId, "", "", "", "") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-f10daa86 | cboCategoryId.SelectedIndexChanged | SCP0050_CAPA_PIC.cs:848 |  | LIST_REBIND | clsCtrl.setListBox | (dtMDMKeyId, cboKeyId, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-99414e14 | cboCategoryId.SelectedIndexChanged | SCP0050_CAPA_PIC.cs:837 |  | FLAG | dtMDMKeyId | Data_SCP.Common(Data_SCP.Type.MDMKeyIdByCategory, false, pCatgegoryId, "", "", "", "") | 화면 필드/플래그 변경 |  |  |  |
| AC-1182641f | cboCategoryId.SelectedIndexChanged | SCP0050_CAPA_PIC.cs:837 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.MDMKeyIdByCategory, false, pCatgegoryId, "", "", "", "") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-f12eb330 | cboCategoryId.SelectedIndexChanged | SCP0050_CAPA_PIC.cs:838 |  | LIST_REBIND | clsCtrl.setListBox | (dtMDMKeyId, cboKeyId, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0050_CAPA_PIC.ClbGroup_SelectedIndexChanged

진입점: clbGroup.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2c2024ce | clbGroup.SelectedIndexChanged | SCP0050_CAPA_PIC.cs:780 |  | FLAG | dtPlantByGroup | Data_SCP.Common(Data_SCP.Type.PlantByGroup, false, pDivisionID, pGroupID) | 화면 필드/플래그 변경 |  |  |  |
| AC-c41dd75c | clbGroup.SelectedIndexChanged | SCP0050_CAPA_PIC.cs:780 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.PlantByGroup, false, pDivisionID, pGroupID) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e99735a1 | clbGroup.SelectedIndexChanged | SCP0050_CAPA_PIC.cs:781 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantByGroup, clbPlant, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-97f74194 | clbGroup.SelectedIndexChanged | SCP0050_CAPA_PIC.cs:784 |  | FLAG | dtBuildingByShopGroupId | Data_SCP.Common(Data_SCP.Type.BuildingByShopGroupId, false, pDivisionID, pPlantID, pGroupI… | 화면 필드/플래그 변경 |  |  |  |
| AC-e760c71a | clbGroup.SelectedIndexChanged | SCP0050_CAPA_PIC.cs:784 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.BuildingByShopGroupId, false, pDivisionID, pPlantID, pGroupID) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d39892cb | clbGroup.SelectedIndexChanged | SCP0050_CAPA_PIC.cs:785 |  | LIST_REBIND | clsCtrl.setListBox | (dtBuildingByShopGroupId, clbBuilding, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-b460cf13 | clbGroup.SelectedIndexChanged | SCP0050_CAPA_PIC.cs:788 |  | FLAG | dtLineByOperationPlantId | Data_SCP.Common(Data_SCP.Type.LineByOperationPlantId, false, pDivisionID, pPlantID, pFacto… | 화면 필드/플래그 변경 |  |  |  |
| AC-289989a1 | clbGroup.SelectedIndexChanged | SCP0050_CAPA_PIC.cs:788 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.LineByOperationPlantId, false, pDivisionID, pPlantID, pFactoryID, pGroupID) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ef4dc21e | clbGroup.SelectedIndexChanged | SCP0050_CAPA_PIC.cs:789 |  | LIST_REBIND | clsCtrl.setListBox | (dtLineByOperationPlantId, clbLine, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-a1f26e0a | clbGroup.SelectedIndexChanged | SCP0050_CAPA_PIC.cs:792 |  | FLAG | dtOperationByLine | Data.Common(Data.Type.OperationByLine, false, pDivisionID, pPlantID, pFactoryID, pLineId, … ⇒ biz:CommonData.CommonDataList [code=OperationByLine] | 화면 필드/플래그 변경 |  |  |  |
| AC-f568fbe6 | clbGroup.SelectedIndexChanged | SCP0050_CAPA_PIC.cs:792 |  | COMBO_DATA | Data.Common | (Data.Type.OperationByLine, false, pDivisionID, pPlantID, pFactoryID, pLineId, pGroupID) ⇒ biz:CommonData.CommonDataList [code=OperationByLine] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-13621a3f | clbGroup.SelectedIndexChanged | SCP0050_CAPA_PIC.cs:793 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperationByLine, clbOperation, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-c10a009d | clbGroup.SelectedIndexChanged | SCP0050_CAPA_PIC.cs:770 |  | FLAG | dtPlantByGroup | Data_SCP.Common(Data_SCP.Type.PlantByGroup, false, division, pGroupID) | 화면 필드/플래그 변경 |  |  |  |
| AC-7737fa63 | clbGroup.SelectedIndexChanged | SCP0050_CAPA_PIC.cs:770 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.PlantByGroup, false, division, pGroupID) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-f78b8981 | clbGroup.SelectedIndexChanged | SCP0050_CAPA_PIC.cs:771 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantByGroup, clbPlant, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-36b9359f | clbGroup.SelectedIndexChanged | SCP0050_CAPA_PIC.cs:774 |  | FLAG | dtBuildingByShopGroupId | Data_SCP.Common(Data_SCP.Type.BuildingByShopGroupId, false, division, pPlantID, pGroupID) | 화면 필드/플래그 변경 |  |  |  |
| AC-8c48d66a | clbGroup.SelectedIndexChanged | SCP0050_CAPA_PIC.cs:774 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.BuildingByShopGroupId, false, division, pPlantID, pGroupID) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-85b2430f | clbGroup.SelectedIndexChanged | SCP0050_CAPA_PIC.cs:775 |  | LIST_REBIND | clsCtrl.setListBox | (dtBuildingByShopGroupId, clbBuilding, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-6b279228 | clbGroup.SelectedIndexChanged | SCP0050_CAPA_PIC.cs:778 |  | FLAG | dtLineByOperationPlantId | Data_SCP.Common(Data_SCP.Type.LineByOperationPlantId, false, division, pPlantID, pFactoryI… | 화면 필드/플래그 변경 |  |  |  |
| AC-716c593b | clbGroup.SelectedIndexChanged | SCP0050_CAPA_PIC.cs:778 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.LineByOperationPlantId, false, division, pPlantID, pFactoryID, pGroupID) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-9723708e | clbGroup.SelectedIndexChanged | SCP0050_CAPA_PIC.cs:779 |  | LIST_REBIND | clsCtrl.setListBox | (dtLineByOperationPlantId, clbLine, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-57c0ca27 | clbGroup.SelectedIndexChanged | SCP0050_CAPA_PIC.cs:782 |  | FLAG | dtOperationByLine | Data.Common(Data.Type.OperationByLine, false, division, pPlantID, pFactoryID, pLineId, pGr… ⇒ biz:CommonData.CommonDataList [code=OperationByLine] | 화면 필드/플래그 변경 |  |  |  |
| AC-13bc2fdb | clbGroup.SelectedIndexChanged | SCP0050_CAPA_PIC.cs:782 |  | COMBO_DATA | Data.Common | (Data.Type.OperationByLine, false, division, pPlantID, pFactoryID, pLineId, pGroupID) ⇒ biz:CommonData.CommonDataList [code=OperationByLine] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-7bd0b2ec | clbGroup.SelectedIndexChanged | SCP0050_CAPA_PIC.cs:783 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperationByLine, clbOperation, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0050_CAPA_PIC.ClbLine_SelectedIndexChanged

진입점: clbLine.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2ea302ab | clbLine.SelectedIndexChanged | SCP0050_CAPA_PIC.cs:839 |  | FLAG | dtOperationByLine | Data.Common(Data.Type.OperationByLine, false, pDivisionID, pPlantID, pFactoryID, pLineID, … ⇒ biz:CommonData.CommonDataList [code=OperationByLine] | 화면 필드/플래그 변경 |  |  |  |
| AC-ab9a9c12 | clbLine.SelectedIndexChanged | SCP0050_CAPA_PIC.cs:839 |  | COMBO_DATA | Data.Common | (Data.Type.OperationByLine, false, pDivisionID, pPlantID, pFactoryID, pLineID, pGroupID) ⇒ biz:CommonData.CommonDataList [code=OperationByLine] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-008d594b | clbLine.SelectedIndexChanged | SCP0050_CAPA_PIC.cs:840 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperationByLine, clbOperation, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-1677ca94 | clbLine.SelectedIndexChanged | SCP0050_CAPA_PIC.cs:829 |  | FLAG | dtOperationByLine | Data.Common(Data.Type.OperationByLine, false, division, pPlantID, pFactoryID, pLineID, pGr… ⇒ biz:CommonData.CommonDataList [code=OperationByLine] | 화면 필드/플래그 변경 |  |  |  |
| AC-ebfbde74 | clbLine.SelectedIndexChanged | SCP0050_CAPA_PIC.cs:829 |  | COMBO_DATA | Data.Common | (Data.Type.OperationByLine, false, division, pPlantID, pFactoryID, pLineID, pGroupID) ⇒ biz:CommonData.CommonDataList [code=OperationByLine] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-de601168 | clbLine.SelectedIndexChanged | SCP0050_CAPA_PIC.cs:830 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperationByLine, clbOperation, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0050_CAPA_PIC.ClbPlant_SelectedIndexChanged

진입점: clbPlant.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-354514d4 | clbPlant.SelectedIndexChanged | SCP0050_CAPA_PIC.cs:802 |  | FLAG | dtBuildingByShopGroupId | Data_SCP.Common(Data_SCP.Type.BuildingByShopGroupId, false, pDivisionID, pPlantID, pGroupI… | 화면 필드/플래그 변경 |  |  |  |
| AC-dca1bdd6 | clbPlant.SelectedIndexChanged | SCP0050_CAPA_PIC.cs:802 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.BuildingByShopGroupId, false, pDivisionID, pPlantID, pGroupID) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-3e55cba3 | clbPlant.SelectedIndexChanged | SCP0050_CAPA_PIC.cs:803 |  | LIST_REBIND | clsCtrl.setListBox | (dtBuildingByShopGroupId, clbBuilding, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-6902c700 | clbPlant.SelectedIndexChanged | SCP0050_CAPA_PIC.cs:806 |  | FLAG | dtLineByOperationPlantId | Data_SCP.Common(Data_SCP.Type.LineByOperationPlantId, false, pDivisionID, pPlantID, pFacto… | 화면 필드/플래그 변경 |  |  |  |
| AC-ecc25121 | clbPlant.SelectedIndexChanged | SCP0050_CAPA_PIC.cs:806 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.LineByOperationPlantId, false, pDivisionID, pPlantID, pFactoryID, pGroupID) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-40bf6dac | clbPlant.SelectedIndexChanged | SCP0050_CAPA_PIC.cs:807 |  | LIST_REBIND | clsCtrl.setListBox | (dtLineByOperationPlantId, clbLine, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-a9a56e58 | clbPlant.SelectedIndexChanged | SCP0050_CAPA_PIC.cs:811 |  | FLAG | dtOperationByLine | Data.Common(Data.Type.OperationByLine, false, pDivisionID, pPlantID, pFactoryID, pLineId, … ⇒ biz:CommonData.CommonDataList [code=OperationByLine] | 화면 필드/플래그 변경 |  |  |  |
| AC-bc159715 | clbPlant.SelectedIndexChanged | SCP0050_CAPA_PIC.cs:811 |  | COMBO_DATA | Data.Common | (Data.Type.OperationByLine, false, pDivisionID, pPlantID, pFactoryID, pLineId, pGroupID) ⇒ biz:CommonData.CommonDataList [code=OperationByLine] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c6bd1ca7 | clbPlant.SelectedIndexChanged | SCP0050_CAPA_PIC.cs:812 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperationByLine, clbOperation, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-a7e15593 | clbPlant.SelectedIndexChanged | SCP0050_CAPA_PIC.cs:792 |  | FLAG | dtBuildingByShopGroupId | Data_SCP.Common(Data_SCP.Type.BuildingByShopGroupId, false, division, pPlantID, pGroupID) | 화면 필드/플래그 변경 |  |  |  |
| AC-f48e62c3 | clbPlant.SelectedIndexChanged | SCP0050_CAPA_PIC.cs:792 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.BuildingByShopGroupId, false, division, pPlantID, pGroupID) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-3aa72c00 | clbPlant.SelectedIndexChanged | SCP0050_CAPA_PIC.cs:793 |  | LIST_REBIND | clsCtrl.setListBox | (dtBuildingByShopGroupId, clbBuilding, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-c7dd9a46 | clbPlant.SelectedIndexChanged | SCP0050_CAPA_PIC.cs:796 |  | FLAG | dtLineByOperationPlantId | Data_SCP.Common(Data_SCP.Type.LineByOperationPlantId, false, division, pPlantID, pFactoryI… | 화면 필드/플래그 변경 |  |  |  |
| AC-ef7d5787 | clbPlant.SelectedIndexChanged | SCP0050_CAPA_PIC.cs:796 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.LineByOperationPlantId, false, division, pPlantID, pFactoryID, pGroupID) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-f829327a | clbPlant.SelectedIndexChanged | SCP0050_CAPA_PIC.cs:797 |  | LIST_REBIND | clsCtrl.setListBox | (dtLineByOperationPlantId, clbLine, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-65478a8b | clbPlant.SelectedIndexChanged | SCP0050_CAPA_PIC.cs:801 |  | FLAG | dtOperationByLine | Data.Common(Data.Type.OperationByLine, false, division, pPlantID, pFactoryID, pLineId, pGr… ⇒ biz:CommonData.CommonDataList [code=OperationByLine] | 화면 필드/플래그 변경 |  |  |  |
| AC-ee400386 | clbPlant.SelectedIndexChanged | SCP0050_CAPA_PIC.cs:801 |  | COMBO_DATA | Data.Common | (Data.Type.OperationByLine, false, division, pPlantID, pFactoryID, pLineId, pGroupID) ⇒ biz:CommonData.CommonDataList [code=OperationByLine] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-003cf01b | clbPlant.SelectedIndexChanged | SCP0050_CAPA_PIC.cs:802 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperationByLine, clbOperation, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0050_CAPA_PIC.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-77f2fbcb | this.Load | SCP0050_CAPA_PIC.cs:255 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-6989d48c | this.Load | SCP0050_CAPA_PIC.cs:256 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-6f040e90 | this.Load | SCP0050_CAPA_PIC.cs:258 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6ca82d77 | this.Load | SCP0050_CAPA_PIC.cs:245 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-e255c8c2 | this.Load | SCP0050_CAPA_PIC.cs:246 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-99f6b21d | this.Load | SCP0050_CAPA_PIC.cs:248 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0050_CAPA_PIC.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b979b4bb | this.Load | SCP0050_CAPA_PIC.cs:152 |  | UI_PROP | siMain.ImagePopUp | imageList1.Images[0] | 속성 ImagePopUp 설정 |  |  |  |
| AC-f49f5ca6 | this.Load | SCP0050_CAPA_PIC.cs:153 |  | FLAG | cellTypeImage | new TextCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-eedf3283 | this.Load | SCP0050_CAPA_PIC.cs:154 |  | UI_PROP | cellTypeImage.BackgroundImage | new FarPoint.Win.Picture(siMain.ImagePopUp) | 속성 BackgroundImage 설정 |  |  |  |
| AC-3db506e1 | this.Load | SCP0050_CAPA_PIC.cs:155 |  | UI_PROP | cellTypeImage.BackgroundImage.AlignHorz | FarPoint.Win.HorizontalAlignment.Right | 속성 AlignHorz 설정 |  |  |  |
| AC-035fa540 | this.Load | SCP0050_CAPA_PIC.cs:152 |  | UI_PROP | siMain.ImagePopUp | imageList1.Images[0] | 속성 ImagePopUp 설정 |  |  |  |
| AC-7b039f96 | this.Load | SCP0050_CAPA_PIC.cs:153 |  | FLAG | cellTypeImage | new TextCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-9c081df4 | this.Load | SCP0050_CAPA_PIC.cs:154 |  | UI_PROP | cellTypeImage.BackgroundImage | new FarPoint.Win.Picture(siMain.ImagePopUp) | 속성 BackgroundImage 설정 |  |  |  |
| AC-83f4633d | this.Load | SCP0050_CAPA_PIC.cs:155 |  | UI_PROP | cellTypeImage.BackgroundImage.AlignHorz | FarPoint.Win.HorizontalAlignment.Right | 속성 AlignHorz 설정 |  |  |  |

## SCP0050_CAPA_PIC.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7de4eb4d | DeleteButton | SCP0050_CAPA_PIC.cs:345 | if (spdMain != null) ▸ if (spdMain.ActiveSheetIndex == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-852b69ad | DeleteButton | SCP0050_CAPA_PIC.cs:350 | if (spdMain != null) ▸ else of (spdMain.ActiveSheetIndex == 0) ▸ if (siMain.ActiveSheet.ActiveRow == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2ff59707 | DeleteButton | SCP0050_CAPA_PIC.cs:356 | if (spdMain != null) ▸ else of (spdMain.ActiveSheetIndex == 0) ▸ if (action == CAppSetting.FlagI) | DATA_OP | siMain.Delete | () | 데이터 객체 조작/조회 |  |  |  |
| AC-7662b9f4 | DeleteButton | SCP0050_CAPA_PIC.cs:335 | if (spdMain != null) ▸ if (spdMain.ActiveSheetIndex == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-eb028e6a | DeleteButton | SCP0050_CAPA_PIC.cs:340 | if (spdMain != null) ▸ else of (spdMain.ActiveSheetIndex == 0) ▸ if (siMain.ActiveSheet.ActiveRow == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-540f5490 | DeleteButton | SCP0050_CAPA_PIC.cs:346 | if (spdMain != null) ▸ else of (spdMain.ActiveSheetIndex == 0) ▸ if (action == CAppSetting.FlagI) | DATA_OP | siMain.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## SCP0050_CAPA_PIC.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5625bdc6 | Dispose | SCP0050_CAPA_PIC.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-ad59976e | Dispose | SCP0050_CAPA_PIC.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0050_CAPA_PIC.EditButton

진입점: EditButton / SaveButton [try ▸ if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "S")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-59c9c114 | EditButton 외 1 | SCP0050_CAPA_PIC.cs:320 | if (spdMain != null) | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-177cbdcf | EditButton 외 1 | SCP0050_CAPA_PIC.cs:322 | if (spdMain != null) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-408d3075 | EditButton 외 1 | SCP0050_CAPA_PIC.cs:323 | if (spdMain != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.SITE_ID), siMain.GetColumnIndex(DefColumns.DEPARTMENT), … | 그리드 편집 잠금/해제 |  |  |  |
| AC-1358edf5 | EditButton 외 1 | SCP0050_CAPA_PIC.cs:324 | if (spdMain != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.USER_NAME_1), siMain.GetColumnIndex(DefColumns.USER_NAME… | 그리드 편집 잠금/해제 |  |  |  |
| AC-afddc6ed | EditButton 외 1 | SCP0050_CAPA_PIC.cs:325 | if (spdMain != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.USER_NAME_2), siMain.GetColumnIndex(DefColumns.USER_NAME… | 그리드 편집 잠금/해제 |  |  |  |
| AC-533a647e | EditButton 외 1 | SCP0050_CAPA_PIC.cs:326 | if (spdMain != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.USER_NAME_3), siMain.GetColumnIndex(DefColumns.USER_NAME… | 그리드 편집 잠금/해제 |  |  |  |
| AC-d5f0f12a | EditButton 외 1 | SCP0050_CAPA_PIC.cs:327 | if (spdMain != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.USER_NAME_4), siMain.GetColumnIndex(DefColumns.USER_NAME… | 그리드 편집 잠금/해제 |  |  |  |
| AC-fc474f0e | EditButton 외 1 | SCP0050_CAPA_PIC.cs:328 | if (spdMain != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.USER_NAME_5), siMain.GetColumnIndex(DefColumns.USER_NAME… | 그리드 편집 잠금/해제 |  |  |  |
| AC-d79382d6 | EditButton 외 1 | SCP0050_CAPA_PIC.cs:329 | if (spdMain != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.USER_NAME_6), siMain.GetColumnIndex(DefColumns.USER_NAME… | 그리드 편집 잠금/해제 |  |  |  |
| AC-1ae92e95 | EditButton 외 1 | SCP0050_CAPA_PIC.cs:330 | if (spdMain != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.USER_NAME_7), siMain.GetColumnIndex(DefColumns.USER_NAME… | 그리드 편집 잠금/해제 |  |  |  |
| AC-316fb2d9 | EditButton 외 1 | SCP0050_CAPA_PIC.cs:331 | if (spdMain != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.USER_NAME_8), siMain.GetColumnIndex(DefColumns.USER_NAME… | 그리드 편집 잠금/해제 |  |  |  |
| AC-f81fcd44 | EditButton 외 1 | SCP0050_CAPA_PIC.cs:332 | if (spdMain != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.USER_NAME_9), siMain.GetColumnIndex(DefColumns.USER_NAME… | 그리드 편집 잠금/해제 |  |  |  |
| AC-d336d187 | EditButton 외 1 | SCP0050_CAPA_PIC.cs:333 | if (spdMain != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.USER_NAME_10), siMain.GetColumnIndex(DefColumns.USER_NAM… | 그리드 편집 잠금/해제 |  |  |  |
| AC-a67da8dd | EditButton 외 1 | SCP0050_CAPA_PIC.cs:310 | if (spdMain != null) | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-7821011a | EditButton 외 1 | SCP0050_CAPA_PIC.cs:312 | if (spdMain != null) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-86db964a | EditButton 외 1 | SCP0050_CAPA_PIC.cs:313 | if (spdMain != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.SITE_ID), siMain.GetColumnIndex(DefColumns.DEPARTMENT), … | 그리드 편집 잠금/해제 |  |  |  |
| AC-91e72e68 | EditButton 외 1 | SCP0050_CAPA_PIC.cs:314 | if (spdMain != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.USER_NAME_1), siMain.GetColumnIndex(DefColumns.USER_NAME… | 그리드 편집 잠금/해제 |  |  |  |
| AC-cfe3895e | EditButton 외 1 | SCP0050_CAPA_PIC.cs:315 | if (spdMain != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.USER_NAME_2), siMain.GetColumnIndex(DefColumns.USER_NAME… | 그리드 편집 잠금/해제 |  |  |  |
| AC-07e4ffc6 | EditButton 외 1 | SCP0050_CAPA_PIC.cs:316 | if (spdMain != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.USER_NAME_3), siMain.GetColumnIndex(DefColumns.USER_NAME… | 그리드 편집 잠금/해제 |  |  |  |
| AC-d5a29b0c | EditButton 외 1 | SCP0050_CAPA_PIC.cs:317 | if (spdMain != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.USER_NAME_4), siMain.GetColumnIndex(DefColumns.USER_NAME… | 그리드 편집 잠금/해제 |  |  |  |
| AC-249c10e8 | EditButton 외 1 | SCP0050_CAPA_PIC.cs:318 | if (spdMain != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.USER_NAME_5), siMain.GetColumnIndex(DefColumns.USER_NAME… | 그리드 편집 잠금/해제 |  |  |  |
| AC-8c180386 | EditButton 외 1 | SCP0050_CAPA_PIC.cs:319 | if (spdMain != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.USER_NAME_6), siMain.GetColumnIndex(DefColumns.USER_NAME… | 그리드 편집 잠금/해제 |  |  |  |
| AC-6f6f825d | EditButton 외 1 | SCP0050_CAPA_PIC.cs:320 | if (spdMain != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.USER_NAME_7), siMain.GetColumnIndex(DefColumns.USER_NAME… | 그리드 편집 잠금/해제 |  |  |  |
| AC-c6797d65 | EditButton 외 1 | SCP0050_CAPA_PIC.cs:321 | if (spdMain != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.USER_NAME_8), siMain.GetColumnIndex(DefColumns.USER_NAME… | 그리드 편집 잠금/해제 |  |  |  |
| AC-332db25c | EditButton 외 1 | SCP0050_CAPA_PIC.cs:322 | if (spdMain != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.USER_NAME_9), siMain.GetColumnIndex(DefColumns.USER_NAME… | 그리드 편집 잠금/해제 |  |  |  |
| AC-9a59a045 | EditButton 외 1 | SCP0050_CAPA_PIC.cs:323 | if (spdMain != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.USER_NAME_10), siMain.GetColumnIndex(DefColumns.USER_NAM… | 그리드 편집 잠금/해제 |  |  |  |

## SCP0050_CAPA_PIC.FindData_Main

진입점: txtManager.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter)] / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a9e82ead | txtManager.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 1 | SCP0050_CAPA_PIC.cs:376 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-e662e628 | txtManager.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 1 | SCP0050_CAPA_PIC.cs:379 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-010cd7f2 | txtManager.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 1 | SCP0050_CAPA_PIC.cs:379 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-dfed6c70 | txtManager.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 1 | SCP0050_CAPA_PIC.cs:383 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-e48dc679 | txtManager.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 1 | SCP0050_CAPA_PIC.cs:401 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-db000080 | txtManager.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 1 | SCP0050_CAPA_PIC.cs:403 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-3df7c674 | txtManager.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 1 | SCP0050_CAPA_PIC.cs:407 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0050_GET_CAPA_PIC") ⇒ SCP.SCP0050_GET_CAPA_PIC | 엔드포인트 요청 생성 |  |  |  |
| AC-03967fcd | txtManager.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 1 | SCP0050_CAPA_PIC.cs:408 | try ▸ lambda | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-4b9d8dec | txtManager.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 1 | SCP0050_CAPA_PIC.cs:409 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | pDivisionId | 행/컬럼 값 대입 |  |  |  |
| AC-83b8eca6 | txtManager.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 1 | SCP0050_CAPA_PIC.cs:410 | try ▸ lambda | DATA_OP | request.Parameters["p_plant_id"] | pPlantId | 행/컬럼 값 대입 |  |  |  |
| AC-6ed10380 | txtManager.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 1 | SCP0050_CAPA_PIC.cs:411 | try ▸ lambda | DATA_OP | request.Parameters["p_group_id"] | pGroupId.Equals("ALL") ? DBNull.Value : pGroupId | 행/컬럼 값 대입 |  |  |  |
| AC-a892d24a | txtManager.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 1 | SCP0050_CAPA_PIC.cs:412 | try ▸ lambda | DATA_OP | request.Parameters["p_factory_id"] | pFactoryId.Equals("ALL") ? DBNull.Value : pFactoryId | 행/컬럼 값 대입 |  |  |  |
| AC-7013458d | txtManager.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 1 | SCP0050_CAPA_PIC.cs:413 | try ▸ lambda | DATA_OP | request.Parameters["p_line_id"] | pLineId.Equals("ALL") ? DBNull.Value : pLineId | 행/컬럼 값 대입 |  |  |  |
| AC-655cf192 | txtManager.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 1 | SCP0050_CAPA_PIC.cs:414 | try ▸ lambda | DATA_OP | request.Parameters["p_operation_id"] | pOperationId.Equals("ALL") ? DBNull.Value : pOperationId | 행/컬럼 값 대입 |  |  |  |
| AC-805f4cd0 | txtManager.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 1 | SCP0050_CAPA_PIC.cs:415 | try ▸ lambda | DATA_OP | request.Parameters["p_category_id"] | pCategoryId.Equals("ALL") ? DBNull.Value : pCategoryId | 행/컬럼 값 대입 |  |  |  |
| AC-c35b7b0c | txtManager.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 1 | SCP0050_CAPA_PIC.cs:416 | try ▸ lambda | DATA_OP | request.Parameters["p_key_id"] | pKeyId.Equals("ALL") ? DBNull.Value : pKeyId | 행/컬럼 값 대입 |  |  |  |
| AC-5842ab8c | txtManager.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 1 | SCP0050_CAPA_PIC.cs:417 | try ▸ lambda | DATA_OP | request.Parameters["p_loss_code"] | pKeyId.Equals("ALL") ? DBNull.Value : pKeyId | 행/컬럼 값 대입 |  |  |  |
| AC-b963b81b | txtManager.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 1 | SCP0050_CAPA_PIC.cs:418 | try ▸ lambda | DATA_OP | request.Parameters["p_manager_name"] | pManagerName | 행/컬럼 값 대입 |  |  |  |
| AC-dcbbcc3d | txtManager.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 1 | SCP0050_CAPA_PIC.cs:419 | try ▸ lambda | DATA_OP | request.Parameters["p_language"] | "KO" | 행/컬럼 값 대입 |  |  |  |
| AC-b22dd49e | txtManager.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 1 | SCP0050_CAPA_PIC.cs:420 | try ▸ lambda | DATA_OP | request.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-b5c23be0 | txtManager.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 1 | SCP0050_CAPA_PIC.cs:422 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-64acd8bb | txtManager.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 1 | SCP0050_CAPA_PIC.cs:424 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-7937c4ed | txtManager.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 1 | SCP0050_CAPA_PIC.cs:431 | try | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-536250d0 | txtManager.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 1 | SCP0050_CAPA_PIC.cs:432 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-cabb9b78 | txtManager.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 1 | SCP0050_CAPA_PIC.cs:435 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-e482ff17 | txtManager.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 1 | SCP0050_CAPA_PIC.cs:438 | try | GRID_INIT | siMain.VisibleAlternatingRow | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-6b253856 | txtManager.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 1 | SCP0050_CAPA_PIC.cs:440 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d92a16ca | txtManager.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 1 | SCP0050_CAPA_PIC.cs:450 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-fada82f4 | txtManager.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 1 | SCP0050_CAPA_PIC.cs:366 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-0df291d4 | txtManager.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 1 | SCP0050_CAPA_PIC.cs:369 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-3fe468f6 | txtManager.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 1 | SCP0050_CAPA_PIC.cs:369 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f0b49aa8 | txtManager.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 1 | SCP0050_CAPA_PIC.cs:373 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-c5a25fb3 | txtManager.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 1 | SCP0050_CAPA_PIC.cs:391 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-9fadd233 | txtManager.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 1 | SCP0050_CAPA_PIC.cs:393 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-2a224f68 | txtManager.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 1 | SCP0050_CAPA_PIC.cs:397 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0050_GET_CAPA_PIC") ⇒ SCP.SCP0050_GET_CAPA_PIC | 엔드포인트 요청 생성 |  |  |  |
| AC-d4d7ad0b | txtManager.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 1 | SCP0050_CAPA_PIC.cs:398 | try ▸ lambda | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-c60da6c1 | txtManager.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 1 | SCP0050_CAPA_PIC.cs:399 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | division | 행/컬럼 값 대입 |  |  |  |
| AC-734295b1 | txtManager.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 1 | SCP0050_CAPA_PIC.cs:400 | try ▸ lambda | DATA_OP | request.Parameters["p_plant_id"] | pPlantId | 행/컬럼 값 대입 |  |  |  |
| AC-9ae976e7 | txtManager.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 1 | SCP0050_CAPA_PIC.cs:401 | try ▸ lambda | DATA_OP | request.Parameters["p_group_id"] | pGroupId.Equals("ALL") ? DBNull.Value : pGroupId | 행/컬럼 값 대입 |  |  |  |
| AC-5fa04346 | txtManager.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 1 | SCP0050_CAPA_PIC.cs:402 | try ▸ lambda | DATA_OP | request.Parameters["p_factory_id"] | pFactoryId.Equals("ALL") ? DBNull.Value : pFactoryId | 행/컬럼 값 대입 |  |  |  |
| AC-aec3f09a | txtManager.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 1 | SCP0050_CAPA_PIC.cs:403 | try ▸ lambda | DATA_OP | request.Parameters["p_line_id"] | pLineId.Equals("ALL") ? DBNull.Value : pLineId | 행/컬럼 값 대입 |  |  |  |
| AC-26226d10 | txtManager.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 1 | SCP0050_CAPA_PIC.cs:404 | try ▸ lambda | DATA_OP | request.Parameters["p_operation_id"] | pOperationId.Equals("ALL") ? DBNull.Value : pOperationId | 행/컬럼 값 대입 |  |  |  |
| AC-94ac2cba | txtManager.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 1 | SCP0050_CAPA_PIC.cs:405 | try ▸ lambda | DATA_OP | request.Parameters["p_category_id"] | pCategoryId.Equals("ALL") ? DBNull.Value : pCategoryId | 행/컬럼 값 대입 |  |  |  |
| AC-fda3c235 | txtManager.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 1 | SCP0050_CAPA_PIC.cs:406 | try ▸ lambda | DATA_OP | request.Parameters["p_key_id"] | pKeyId.Equals("ALL") ? DBNull.Value : pKeyId | 행/컬럼 값 대입 |  |  |  |
| AC-a91b7241 | txtManager.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 1 | SCP0050_CAPA_PIC.cs:407 | try ▸ lambda | DATA_OP | request.Parameters["p_loss_code"] | pKeyId.Equals("ALL") ? DBNull.Value : pKeyId | 행/컬럼 값 대입 |  |  |  |
| AC-5eec0370 | txtManager.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 1 | SCP0050_CAPA_PIC.cs:408 | try ▸ lambda | DATA_OP | request.Parameters["p_manager_name"] | pManagerName | 행/컬럼 값 대입 |  |  |  |
| AC-4a34bdfb | txtManager.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 1 | SCP0050_CAPA_PIC.cs:409 | try ▸ lambda | DATA_OP | request.Parameters["p_language"] | "KO" | 행/컬럼 값 대입 |  |  |  |
| AC-cb35716f | txtManager.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 1 | SCP0050_CAPA_PIC.cs:410 | try ▸ lambda | DATA_OP | request.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-6e2281f3 | txtManager.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 1 | SCP0050_CAPA_PIC.cs:412 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-dd76ec2f | txtManager.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 1 | SCP0050_CAPA_PIC.cs:414 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-59bc90ce | txtManager.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 1 | SCP0050_CAPA_PIC.cs:421 | try | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-93acc899 | txtManager.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 1 | SCP0050_CAPA_PIC.cs:422 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-cf70a4e7 | txtManager.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 1 | SCP0050_CAPA_PIC.cs:425 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-8f96fcf1 | txtManager.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 1 | SCP0050_CAPA_PIC.cs:428 | try | GRID_INIT | siMain.VisibleAlternatingRow | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-71928b0b | txtManager.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 1 | SCP0050_CAPA_PIC.cs:430 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-eeaed394 | txtManager.KeyDown [if (e.KeyCode == System.Windows.Forms.Ke… 외 1 | SCP0050_CAPA_PIC.cs:440 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0050_CAPA_PIC.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1910c8b4 | this.Load | SCP0050_CAPA_PIC.cs:139 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-ee3a69c1 | this.Load | SCP0050_CAPA_PIC.cs:139 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0050_CAPA_PIC.GetUserIDChk

진입점: SaveButton [try ▸ if (iCount > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-124d1b43 | SaveButton [try ▸ if (iCount > 0)] | SCP0050_CAPA_PIC.cs:657 | try | ENDPOINT | new FoxDataRequest | ("SCP.SCP0050_GET_USER_ID_CHECK") ⇒ SCP.SCP0050_GET_USER_ID_CHECK | 엔드포인트 요청 생성 |  |  |  |
| AC-f9bf0b00 | SaveButton [try ▸ if (iCount > 0)] | SCP0050_CAPA_PIC.cs:658 | try | DATA_OP | request.Parameters["p_user_id"] | sUserID | 행/컬럼 값 대입 |  |  |  |
| AC-2aa399f3 | SaveButton [try ▸ if (iCount > 0)] | SCP0050_CAPA_PIC.cs:660 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-24df7bc3 | SaveButton [try ▸ if (iCount > 0)] | SCP0050_CAPA_PIC.cs:674 | try ▸ if (ds.Tables[0].Rows.Count > 0) ▸ foreach (string user in strUSer) | DATA_OP | ds.Tables[0].Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-d04f5744 | SaveButton [try ▸ if (iCount > 0)] | SCP0050_CAPA_PIC.cs:697 | try ▸ if (iCnt > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00251", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b8355344 | SaveButton [try ▸ if (iCount > 0)] | SCP0050_CAPA_PIC.cs:701 | catch ((Exception ex)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-53df2e03 | SaveButton [try ▸ if (iCount > 0)] | SCP0050_CAPA_PIC.cs:703 |  | RETURN | return bReturn; |  | 처리 중단/반환 |  |  |  |
| AC-e120553f | SaveButton [try ▸ if (iCount > 0)] | SCP0050_CAPA_PIC.cs:647 | try | ENDPOINT | new FoxDataRequest | ("SCP.SCP0050_GET_USER_ID_CHECK") ⇒ SCP.SCP0050_GET_USER_ID_CHECK | 엔드포인트 요청 생성 |  |  |  |
| AC-5c0e24e0 | SaveButton [try ▸ if (iCount > 0)] | SCP0050_CAPA_PIC.cs:648 | try | DATA_OP | request.Parameters["p_user_id"] | sUserID | 행/컬럼 값 대입 |  |  |  |
| AC-6267fa4e | SaveButton [try ▸ if (iCount > 0)] | SCP0050_CAPA_PIC.cs:650 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-cf2d7d3d | SaveButton [try ▸ if (iCount > 0)] | SCP0050_CAPA_PIC.cs:664 | try ▸ if (ds.Tables[0].Rows.Count > 0) ▸ foreach (string user in strUSer) | DATA_OP | ds.Tables[0].Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-4b6c5cf0 | SaveButton [try ▸ if (iCount > 0)] | SCP0050_CAPA_PIC.cs:687 | try ▸ if (iCnt > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00251", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-de5ebc0d | SaveButton [try ▸ if (iCount > 0)] | SCP0050_CAPA_PIC.cs:691 | catch ((Exception ex)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-90574320 | SaveButton [try ▸ if (iCount > 0)] | SCP0050_CAPA_PIC.cs:693 |  | RETURN | return bReturn; |  | 처리 중단/반환 |  |  |  |

## SCP0050_CAPA_PIC.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c3b7ca95 | this.Load | SCP0050_CAPA_PIC.cs:160 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-e9dd2982 | this.Load | SCP0050_CAPA_PIC.cs:163 | if (dtMyDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-f791efb8 | this.Load | SCP0050_CAPA_PIC.cs:165 |  | CALL_EXT | UserService.HasExtraRole | (UserInfoContext.Current.UserId) | ⚠ 의미 확인 필요 |  |  |  |
| AC-63692212 | this.Load | SCP0050_CAPA_PIC.cs:167 | if (UserService.HasExtraRole(UserInfoContext.Current.UserId)) | UI_PROP | lcExportExcel.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-eb2625bf | this.Load | SCP0050_CAPA_PIC.cs:171 | else of (UserService.HasExtraRole(UserInfoContext.Current.UserId)) | UI_PROP | lcExportExcel.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-b53ce9c5 | this.Load | SCP0050_CAPA_PIC.cs:175 |  | DATA_OP | dtMyDivision.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-8a1191e0 | this.Load | SCP0050_CAPA_PIC.cs:176 |  | DATA_OP | tmpDivision.Columns.Add | ("SORT_ORDER") | 데이터 객체 조작/조회 |  |  |  |
| AC-85ac90be | this.Load | SCP0050_CAPA_PIC.cs:177 |  | CALL_EXT | tmpDivision.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-66cfdc04 | this.Load | SCP0050_CAPA_PIC.cs:181 | foreach (DataRow dr in dtMyDivision.Rows) | DATA_OP | tmpDivision.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-efde4c1c | this.Load | SCP0050_CAPA_PIC.cs:182 | foreach (DataRow dr in dtMyDivision.Rows) | DATA_OP | dataRow["CODE"] | dr["CODE"] | 행/컬럼 값 대입 |  |  |  |
| AC-9d15fe8c | this.Load | SCP0050_CAPA_PIC.cs:183 | foreach (DataRow dr in dtMyDivision.Rows) | DATA_OP | dataRow["NAME"] | dr["NAME"] | 행/컬럼 값 대입 |  |  |  |
| AC-e71ed79e | this.Load | SCP0050_CAPA_PIC.cs:185 | foreach (DataRow dr in dtMyDivision.Rows) | DATA_OP | dataRow["SORT_ORDER"] | HardCodeService.MatchCodeFp("SCP0049_CAPA", "DIVORDER1", dr["CODE"]) ? 1 : HardCodeService… | 행/컬럼 값 대입 |  |  |  |
| AC-4dfc5e0d | this.Load | SCP0050_CAPA_PIC.cs:185 | foreach (DataRow dr in dtMyDivision.Rows) | CALL_EXT | HardCodeService.MatchCodeFp | ("SCP0049_CAPA", "DIVORDER1", dr["CODE"]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-0d98707d | this.Load | SCP0050_CAPA_PIC.cs:185 | foreach (DataRow dr in dtMyDivision.Rows) | CALL_EXT | HardCodeService.MatchCodeFp | ("SCP0049_CAPA", "DIVORDER2", dr["CODE"]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ceb4ddac | this.Load | SCP0050_CAPA_PIC.cs:187 | foreach (DataRow dr in dtMyDivision.Rows) | CALL_EXT | tmpDivision.Rows.InsertAt | (dataRow, 0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9e514711 | this.Load | SCP0050_CAPA_PIC.cs:190 |  | UI_PROP | tmpDivision.DefaultView.Sort | "SORT_ORDER Asc" | 속성 Sort 설정 |  |  |  |
| AC-b0cbdef8 | this.Load | SCP0050_CAPA_PIC.cs:191 |  | DATA_OP | tmpDivision.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-82f1d5ee | this.Load | SCP0050_CAPA_PIC.cs:193 |  | DATA_OP | tmpDivision.DefaultView.ToTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-291de92c | this.Load | SCP0050_CAPA_PIC.cs:195 |  | STATE_RESET | dtMyDivision.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-7f6ca791 | this.Load | SCP0050_CAPA_PIC.cs:196 |  | FLAG | dtMyDivision | dtDivisionOrder.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-6cbc24e8 | this.Load | SCP0050_CAPA_PIC.cs:196 |  | DATA_OP | dtDivisionOrder.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-d7c7b0d7 | this.Load | SCP0050_CAPA_PIC.cs:199 |  | LIST_REBIND | clsCtrl.setListBox | (dtMyDivision, cboDivision, false,"CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-4e815530 | this.Load | SCP0050_CAPA_PIC.cs:160 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-e58dcc47 | this.Load | SCP0050_CAPA_PIC.cs:163 | if (dtMyDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-209126f0 | this.Load | SCP0050_CAPA_PIC.cs:166 |  | DATA_OP | dtMyDivision.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-4b8d2b96 | this.Load | SCP0050_CAPA_PIC.cs:167 |  | DATA_OP | tmpDivision.Columns.Add | ("SORT_ORDER") | 데이터 객체 조작/조회 |  |  |  |
| AC-56c5962e | this.Load | SCP0050_CAPA_PIC.cs:168 |  | CALL_EXT | tmpDivision.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-cd20e32e | this.Load | SCP0050_CAPA_PIC.cs:172 | foreach (DataRow dr in dtMyDivision.Rows) | DATA_OP | tmpDivision.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-1f49b5a0 | this.Load | SCP0050_CAPA_PIC.cs:173 | foreach (DataRow dr in dtMyDivision.Rows) | DATA_OP | dataRow["CODE"] | dr["CODE"] | 행/컬럼 값 대입 |  |  |  |
| AC-e41b1751 | this.Load | SCP0050_CAPA_PIC.cs:174 | foreach (DataRow dr in dtMyDivision.Rows) | DATA_OP | dataRow["NAME"] | dr["NAME"] | 행/컬럼 값 대입 |  |  |  |
| AC-0886089e | this.Load | SCP0050_CAPA_PIC.cs:175 | foreach (DataRow dr in dtMyDivision.Rows) | DATA_OP | dataRow["SORT_ORDER"] | dr["CODE"].ToString() == "81" ? 1 : dr["CODE"].ToString() == "40" ? 2 : 3 | 행/컬럼 값 대입 |  |  |  |
| AC-3815f83c | this.Load | SCP0050_CAPA_PIC.cs:177 | foreach (DataRow dr in dtMyDivision.Rows) | CALL_EXT | tmpDivision.Rows.InsertAt | (dataRow, 0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d7196a92 | this.Load | SCP0050_CAPA_PIC.cs:180 |  | UI_PROP | tmpDivision.DefaultView.Sort | "SORT_ORDER Asc" | 속성 Sort 설정 |  |  |  |
| AC-847e9c49 | this.Load | SCP0050_CAPA_PIC.cs:181 |  | DATA_OP | tmpDivision.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-ef065eb0 | this.Load | SCP0050_CAPA_PIC.cs:183 |  | DATA_OP | tmpDivision.DefaultView.ToTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-f879251b | this.Load | SCP0050_CAPA_PIC.cs:185 |  | STATE_RESET | dtMyDivision.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-0546ca0e | this.Load | SCP0050_CAPA_PIC.cs:186 |  | FLAG | dtMyDivision | dtDivisionOrder.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-6b209a47 | this.Load | SCP0050_CAPA_PIC.cs:186 |  | DATA_OP | dtDivisionOrder.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-67a7a002 | this.Load | SCP0050_CAPA_PIC.cs:189 |  | LIST_REBIND | clsCtrl.setListBox | (dtMyDivision, cboDivision, false,"CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0050_CAPA_PIC.InitSpread

진입점: this.Load / txtManager.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ try] / FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cca00f1b | this.Load 외 2 | SCP0050_CAPA_PIC.cs:265 |  | GRID_INIT | spdInfo.InitSheet | (SpdSheet.shtMain) | 그리드 재구성/초기화 |  |  |  |
| AC-52b7a9f7 | this.Load 외 2 | SCP0050_CAPA_PIC.cs:266 |  | LIST_REBIND | SpreadInfo.SetComBoParam | ("SiteFP", dtSiteFP) | 목록 컨트롤 재구성 |  |  |  |
| AC-c05e7711 | this.Load 외 2 | SCP0050_CAPA_PIC.cs:267 |  | LIST_REBIND | SpreadInfo.SetComBoParam | ("MDMCategoryId", dtMDMCategoryId) | 목록 컨트롤 재구성 |  |  |  |
| AC-af256d80 | this.Load 외 2 | SCP0050_CAPA_PIC.cs:268 |  | LIST_REBIND | SpreadInfo.SetComBoParam | ("MDMKeyId", dtMDMKeyId) | 목록 컨트롤 재구성 |  |  |  |
| AC-83d3cc20 | this.Load 외 2 | SCP0050_CAPA_PIC.cs:269 |  | GRID_INIT | spdInfo.SetSheetHeaderColumn | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-ad3ab0fa | this.Load 외 2 | SCP0050_CAPA_PIC.cs:271 |  | GRID_SET | spdInfo.ActiveSheet.Columns[DefColumns.USER_ID_1].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-26f6110d | this.Load 외 2 | SCP0050_CAPA_PIC.cs:272 |  | GRID_SET | spdInfo.ActiveSheet.Columns[DefColumns.USER_ID_2].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-edebf5a8 | this.Load 외 2 | SCP0050_CAPA_PIC.cs:273 |  | GRID_SET | spdInfo.ActiveSheet.Columns[DefColumns.USER_ID_3].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-4c2a5005 | this.Load 외 2 | SCP0050_CAPA_PIC.cs:274 |  | GRID_SET | spdInfo.ActiveSheet.Columns[DefColumns.USER_ID_4].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-956423f5 | this.Load 외 2 | SCP0050_CAPA_PIC.cs:275 |  | GRID_SET | spdInfo.ActiveSheet.Columns[DefColumns.USER_ID_5].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-1fb4cf2d | this.Load 외 2 | SCP0050_CAPA_PIC.cs:276 |  | GRID_SET | spdInfo.ActiveSheet.Columns[DefColumns.USER_ID_6].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-8b5b4169 | this.Load 외 2 | SCP0050_CAPA_PIC.cs:277 |  | GRID_SET | spdInfo.ActiveSheet.Columns[DefColumns.USER_ID_7].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-62b270bc | this.Load 외 2 | SCP0050_CAPA_PIC.cs:278 |  | GRID_SET | spdInfo.ActiveSheet.Columns[DefColumns.USER_ID_8].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-09ee6f1b | this.Load 외 2 | SCP0050_CAPA_PIC.cs:279 |  | GRID_SET | spdInfo.ActiveSheet.Columns[DefColumns.USER_ID_9].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-05e480fc | this.Load 외 2 | SCP0050_CAPA_PIC.cs:280 |  | GRID_SET | spdInfo.ActiveSheet.Columns[DefColumns.USER_ID_10].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-1cec98b5 | this.Load 외 2 | SCP0050_CAPA_PIC.cs:255 |  | GRID_INIT | spdInfo.InitSheet | (SpdSheet.shtMain) | 그리드 재구성/초기화 |  |  |  |
| AC-3e1a2fa6 | this.Load 외 2 | SCP0050_CAPA_PIC.cs:256 |  | LIST_REBIND | SpreadInfo.SetComBoParam | ("SiteFP", dtSiteFP) | 목록 컨트롤 재구성 |  |  |  |
| AC-2d185b52 | this.Load 외 2 | SCP0050_CAPA_PIC.cs:257 |  | LIST_REBIND | SpreadInfo.SetComBoParam | ("MDMCategoryId", dtMDMCategoryId) | 목록 컨트롤 재구성 |  |  |  |
| AC-c3b5948b | this.Load 외 2 | SCP0050_CAPA_PIC.cs:258 |  | LIST_REBIND | SpreadInfo.SetComBoParam | ("MDMKeyId", dtMDMKeyId) | 목록 컨트롤 재구성 |  |  |  |
| AC-df0dba81 | this.Load 외 2 | SCP0050_CAPA_PIC.cs:259 |  | GRID_INIT | spdInfo.SetSheetHeaderColumn | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-92466d04 | this.Load 외 2 | SCP0050_CAPA_PIC.cs:261 |  | GRID_SET | spdInfo.ActiveSheet.Columns[DefColumns.USER_ID_1].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-d97deeef | this.Load 외 2 | SCP0050_CAPA_PIC.cs:262 |  | GRID_SET | spdInfo.ActiveSheet.Columns[DefColumns.USER_ID_2].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-d8cedec7 | this.Load 외 2 | SCP0050_CAPA_PIC.cs:263 |  | GRID_SET | spdInfo.ActiveSheet.Columns[DefColumns.USER_ID_3].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-a6c29401 | this.Load 외 2 | SCP0050_CAPA_PIC.cs:264 |  | GRID_SET | spdInfo.ActiveSheet.Columns[DefColumns.USER_ID_4].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-3d543ded | this.Load 외 2 | SCP0050_CAPA_PIC.cs:265 |  | GRID_SET | spdInfo.ActiveSheet.Columns[DefColumns.USER_ID_5].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-c37edf30 | this.Load 외 2 | SCP0050_CAPA_PIC.cs:266 |  | GRID_SET | spdInfo.ActiveSheet.Columns[DefColumns.USER_ID_6].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-66aee934 | this.Load 외 2 | SCP0050_CAPA_PIC.cs:267 |  | GRID_SET | spdInfo.ActiveSheet.Columns[DefColumns.USER_ID_7].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-d463916c | this.Load 외 2 | SCP0050_CAPA_PIC.cs:268 |  | GRID_SET | spdInfo.ActiveSheet.Columns[DefColumns.USER_ID_8].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-28b10f4b | this.Load 외 2 | SCP0050_CAPA_PIC.cs:269 |  | GRID_SET | spdInfo.ActiveSheet.Columns[DefColumns.USER_ID_9].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-6bd9d4d4 | this.Load 외 2 | SCP0050_CAPA_PIC.cs:270 |  | GRID_SET | spdInfo.ActiveSheet.Columns[DefColumns.USER_ID_10].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |

## SCP0050_CAPA_PIC.InsertRow

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cc3d0060 | (진입점 미연결) | SCP0050_CAPA_PIC.cs:628 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-2680c2f3 | (진입점 미연결) | SCP0050_CAPA_PIC.cs:631 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.SITE_ID), dtSiteFP) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-787385e9 | (진입점 미연결) | SCP0050_CAPA_PIC.cs:632 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.PLANT_ID), dtPlantByDivisionForIn… | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-d0e69498 | (진입점 미연결) | SCP0050_CAPA_PIC.cs:634 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.FACTORY_NAME), dtBuildingByShopGr… | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-c6cf34e6 | (진입점 미연결) | SCP0050_CAPA_PIC.cs:635 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.LINE_NAME), dtLineByOperationPlan… | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-4eb77218 | (진입점 미연결) | SCP0050_CAPA_PIC.cs:636 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.OPERATION_NAME), dtOperationByLin… | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-a66009ff | (진입점 미연결) | SCP0050_CAPA_PIC.cs:637 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.CATEGORY_ID), dtMDMCategoryId) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-0fb1d63f | (진입점 미연결) | SCP0050_CAPA_PIC.cs:638 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.KEY_ID), dtMDMKeyId) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-7d0fe8e7 | (진입점 미연결) | SCP0050_CAPA_PIC.cs:639 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ELECTRODE_TYPE), dtElectrodeType) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-90ea046e | (진입점 미연결) | SCP0050_CAPA_PIC.cs:641 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.FACTORY_ID), siMain.GetColumnIndex(DefColumns.F… | 그리드 편집 잠금/해제 |  |  |  |
| AC-2ac37f83 | (진입점 미연결) | SCP0050_CAPA_PIC.cs:642 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.LINE_ID), siMain.GetColumnIndex(DefColumns.LINE… | 그리드 편집 잠금/해제 |  |  |  |
| AC-6fc2c6b2 | (진입점 미연결) | SCP0050_CAPA_PIC.cs:643 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.OPERATION_ID), siMain.GetColumnIndex(DefColumns… | 그리드 편집 잠금/해제 |  |  |  |
| AC-c58df5d9 | (진입점 미연결) | SCP0050_CAPA_PIC.cs:644 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.DEPARTMENT), siMain.GetColumnIndex(DefColumns.D… | 그리드 편집 잠금/해제 |  |  |  |
| AC-6d887949 | (진입점 미연결) | SCP0050_CAPA_PIC.cs:618 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-f7cf50c1 | (진입점 미연결) | SCP0050_CAPA_PIC.cs:621 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.SITE_ID), dtSiteFP) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-bc69eee7 | (진입점 미연결) | SCP0050_CAPA_PIC.cs:622 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.PLANT_ID), dtPlantByDivisionForIn… | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-9aaad349 | (진입점 미연결) | SCP0050_CAPA_PIC.cs:624 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.FACTORY_NAME), dtBuildingByShopGr… | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-23baa6d4 | (진입점 미연결) | SCP0050_CAPA_PIC.cs:625 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.LINE_NAME), dtLineByOperationPlan… | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-46218afa | (진입점 미연결) | SCP0050_CAPA_PIC.cs:626 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.OPERATION_NAME), dtOperationByLin… | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-f762791d | (진입점 미연결) | SCP0050_CAPA_PIC.cs:627 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.CATEGORY_ID), dtMDMCategoryId) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-cb7b7694 | (진입점 미연결) | SCP0050_CAPA_PIC.cs:628 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.KEY_ID), dtMDMKeyId) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-aba860fe | (진입점 미연결) | SCP0050_CAPA_PIC.cs:629 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ELECTRODE_TYPE), dtElectrodeType) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-47d429bf | (진입점 미연결) | SCP0050_CAPA_PIC.cs:631 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.FACTORY_ID), siMain.GetColumnIndex(DefColumns.F… | 그리드 편집 잠금/해제 |  |  |  |
| AC-2f86b868 | (진입점 미연결) | SCP0050_CAPA_PIC.cs:632 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.LINE_ID), siMain.GetColumnIndex(DefColumns.LINE… | 그리드 편집 잠금/해제 |  |  |  |
| AC-c7d1c39e | (진입점 미연결) | SCP0050_CAPA_PIC.cs:633 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.OPERATION_ID), siMain.GetColumnIndex(DefColumns… | 그리드 편집 잠금/해제 |  |  |  |
| AC-8d5f0fea | (진입점 미연결) | SCP0050_CAPA_PIC.cs:634 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.DEPARTMENT), siMain.GetColumnIndex(DefColumns.D… | 그리드 편집 잠금/해제 |  |  |  |

## SCP0050_CAPA_PIC.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-419fbeb1 | SaveButton | SCP0050_CAPA_PIC.cs:365 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c14a7367 | SaveButton | SCP0050_CAPA_PIC.cs:355 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0050_CAPA_PIC.SaveData_Main

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-857c440e | SaveButton | SCP0050_CAPA_PIC.cs:456 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-64496254 | SaveButton | SCP0050_CAPA_PIC.cs:460 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-08badb0e | SaveButton | SCP0050_CAPA_PIC.cs:462 | try | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-74b1253e | SaveButton | SCP0050_CAPA_PIC.cs:462 | try ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bcde7bca | SaveButton | SCP0050_CAPA_PIC.cs:499 | try ▸ for (i <= siMain.ActiveSheet.RowCount - 1) | DATA_OP | arrayChangeRow.Add | (i) | 데이터 객체 조작/조회 |  |  |  |
| AC-90086336 | SaveButton | SCP0050_CAPA_PIC.cs:529 | try ▸ if (iCount > 0) ▸ if (!GetUserIDChk(p_user_id_1)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ea7f3d93 | SaveButton | SCP0050_CAPA_PIC.cs:532 | try ▸ if (iCount > 0) ▸ if (p_user_id_2.Replace("^", "") != null && p_user_id_2.Replace("^", "") != "") ▸ if (!GetUserIDChk(p_user_id_2)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d769afb9 | SaveButton | SCP0050_CAPA_PIC.cs:536 | try ▸ if (iCount > 0) ▸ if (p_user_id_3.Replace("^", "") != null && p_user_id_3.Replace("^", "") != "") ▸ if (!GetUserIDChk(p_user_id_3)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3c0d5b70 | SaveButton | SCP0050_CAPA_PIC.cs:540 | try ▸ if (iCount > 0) ▸ if (p_user_id_4.Replace("^", "") != null && p_user_id_4.Replace("^", "") != "") ▸ if (!GetUserIDChk(p_user_id_4)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-62ac4eaf | SaveButton | SCP0050_CAPA_PIC.cs:544 | try ▸ if (iCount > 0) ▸ if (p_user_id_5.Replace("^", "") != null && p_user_id_5.Replace("^", "") != "") ▸ if (!GetUserIDChk(p_user_id_5)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-11ebc853 | SaveButton | SCP0050_CAPA_PIC.cs:548 | try ▸ if (iCount > 0) ▸ if (p_user_id_6.Replace("^", "") != null && p_user_id_6.Replace("^", "") != "") ▸ if (!GetUserIDChk(p_user_id_6)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d75ee981 | SaveButton | SCP0050_CAPA_PIC.cs:552 | try ▸ if (iCount > 0) ▸ if (p_user_id_7.Replace("^", "") != null && p_user_id_7.Replace("^", "") != "") ▸ if (!GetUserIDChk(p_user_id_7)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8f166943 | SaveButton | SCP0050_CAPA_PIC.cs:556 | try ▸ if (iCount > 0) ▸ if (p_user_id_8.Replace("^", "") != null && p_user_id_8.Replace("^", "") != "") ▸ if (!GetUserIDChk(p_user_id_8)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-88847a26 | SaveButton | SCP0050_CAPA_PIC.cs:560 | try ▸ if (iCount > 0) ▸ if (p_user_id_9.Replace("^", "") != null && p_user_id_9.Replace("^", "") != "") ▸ if (!GetUserIDChk(p_user_id_9)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-91c08e5b | SaveButton | SCP0050_CAPA_PIC.cs:564 | try ▸ if (iCount > 0) ▸ if (p_user_id_10.Replace("^", "") != null && p_user_id_10.Replace("^", "") != "") ▸ if (!GetUserIDChk(p_user_id_10)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5e2ed0a0 | SaveButton | SCP0050_CAPA_PIC.cs:568 | try ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("SCP.SCP0050_SAVE_CAPA_PIC") ⇒ SCP.SCP0050_SAVE_CAPA_PIC | 엔드포인트 요청 생성 |  |  |  |
| AC-00d3f98d | SaveButton | SCP0050_CAPA_PIC.cs:572 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-d2acf125 | SaveButton | SCP0050_CAPA_PIC.cs:573 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_company_id"] | p_company_id | 행/컬럼 값 대입 |  |  |  |
| AC-45443bf7 | SaveButton | SCP0050_CAPA_PIC.cs:574 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-fce1a371 | SaveButton | SCP0050_CAPA_PIC.cs:575 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_site_id"] | p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-adf0a4e2 | SaveButton | SCP0050_CAPA_PIC.cs:576 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_plant_id"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-e6f40394 | SaveButton | SCP0050_CAPA_PIC.cs:577 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_factory_id"] | p_factory_id | 행/컬럼 값 대입 |  |  |  |
| AC-b2277218 | SaveButton | SCP0050_CAPA_PIC.cs:578 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_operation_id"] | p_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-9724ac24 | SaveButton | SCP0050_CAPA_PIC.cs:579 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_line_id"] | p_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-71e2b686 | SaveButton | SCP0050_CAPA_PIC.cs:580 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_electrode_type"] | p_electrode_type | 행/컬럼 값 대입 |  |  |  |
| AC-3c66df74 | SaveButton | SCP0050_CAPA_PIC.cs:581 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_loss_code"] | p_loss_code | 행/컬럼 값 대입 |  |  |  |
| AC-c935ddd5 | SaveButton | SCP0050_CAPA_PIC.cs:582 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_user_id_1"] | p_user_id_1 | 행/컬럼 값 대입 |  |  |  |
| AC-c40d76a3 | SaveButton | SCP0050_CAPA_PIC.cs:583 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_user_id_2"] | p_user_id_2 | 행/컬럼 값 대입 |  |  |  |
| AC-613ad0bf | SaveButton | SCP0050_CAPA_PIC.cs:584 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_user_id_3"] | p_user_id_3 | 행/컬럼 값 대입 |  |  |  |
| AC-bf79ff3a | SaveButton | SCP0050_CAPA_PIC.cs:585 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_user_id_4"] | p_user_id_4 | 행/컬럼 값 대입 |  |  |  |
| AC-a7c3247a | SaveButton | SCP0050_CAPA_PIC.cs:586 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_user_id_5"] | p_user_id_5 | 행/컬럼 값 대입 |  |  |  |
| AC-25b08f87 | SaveButton | SCP0050_CAPA_PIC.cs:587 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_user_id_6"] | p_user_id_6 | 행/컬럼 값 대입 |  |  |  |
| AC-962bdddb | SaveButton | SCP0050_CAPA_PIC.cs:588 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_user_id_7"] | p_user_id_7 | 행/컬럼 값 대입 |  |  |  |
| AC-61f5f523 | SaveButton | SCP0050_CAPA_PIC.cs:589 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_user_id_8"] | p_user_id_8 | 행/컬럼 값 대입 |  |  |  |
| AC-c9b3fd68 | SaveButton | SCP0050_CAPA_PIC.cs:590 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_user_id_9"] | p_user_id_9 | 행/컬럼 값 대입 |  |  |  |
| AC-50112577 | SaveButton | SCP0050_CAPA_PIC.cs:591 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_user_id_10"] | p_user_id_10 | 행/컬럼 값 대입 |  |  |  |
| AC-87771d5a | SaveButton | SCP0050_CAPA_PIC.cs:592 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_update_id"] | p_update_id | 행/컬럼 값 대입 |  |  |  |
| AC-23844374 | SaveButton | SCP0050_CAPA_PIC.cs:594 | try ▸ if (iCount > 0) | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-6c19b3b6 | SaveButton | SCP0050_CAPA_PIC.cs:599 | try ▸ if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "S") | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-4fd18385 | SaveButton | SCP0050_CAPA_PIC.cs:601 | try ▸ if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { ds.Tables[0].Rows[0][1].ToString() }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c1eec93a | SaveButton | SCP0050_CAPA_PIC.cs:607 | try ▸ if (iCount > 0) ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "S") | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-d5ac3a74 | SaveButton | SCP0050_CAPA_PIC.cs:609 | try ▸ if (iCount > 0) ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00284", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0b4c1bd1 | SaveButton | SCP0050_CAPA_PIC.cs:617 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-dc7ab86d | SaveButton | SCP0050_CAPA_PIC.cs:446 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-9fe67d15 | SaveButton | SCP0050_CAPA_PIC.cs:450 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-bd599589 | SaveButton | SCP0050_CAPA_PIC.cs:452 | try | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-b6c1c59e | SaveButton | SCP0050_CAPA_PIC.cs:452 | try ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6b1d18bf | SaveButton | SCP0050_CAPA_PIC.cs:489 | try ▸ for (i <= siMain.ActiveSheet.RowCount - 1) | DATA_OP | arrayChangeRow.Add | (i) | 데이터 객체 조작/조회 |  |  |  |
| AC-2e6fc6e1 | SaveButton | SCP0050_CAPA_PIC.cs:519 | try ▸ if (iCount > 0) ▸ if (!GetUserIDChk(p_user_id_1)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-07bb63b4 | SaveButton | SCP0050_CAPA_PIC.cs:522 | try ▸ if (iCount > 0) ▸ if (p_user_id_2.Replace("^", "") != null && p_user_id_2.Replace("^", "") != "") ▸ if (!GetUserIDChk(p_user_id_2)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-40d6a3c5 | SaveButton | SCP0050_CAPA_PIC.cs:526 | try ▸ if (iCount > 0) ▸ if (p_user_id_3.Replace("^", "") != null && p_user_id_3.Replace("^", "") != "") ▸ if (!GetUserIDChk(p_user_id_3)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0145bce1 | SaveButton | SCP0050_CAPA_PIC.cs:530 | try ▸ if (iCount > 0) ▸ if (p_user_id_4.Replace("^", "") != null && p_user_id_4.Replace("^", "") != "") ▸ if (!GetUserIDChk(p_user_id_4)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b35c3cd9 | SaveButton | SCP0050_CAPA_PIC.cs:534 | try ▸ if (iCount > 0) ▸ if (p_user_id_5.Replace("^", "") != null && p_user_id_5.Replace("^", "") != "") ▸ if (!GetUserIDChk(p_user_id_5)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-50e22c58 | SaveButton | SCP0050_CAPA_PIC.cs:538 | try ▸ if (iCount > 0) ▸ if (p_user_id_6.Replace("^", "") != null && p_user_id_6.Replace("^", "") != "") ▸ if (!GetUserIDChk(p_user_id_6)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-772686f0 | SaveButton | SCP0050_CAPA_PIC.cs:542 | try ▸ if (iCount > 0) ▸ if (p_user_id_7.Replace("^", "") != null && p_user_id_7.Replace("^", "") != "") ▸ if (!GetUserIDChk(p_user_id_7)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1898ad8c | SaveButton | SCP0050_CAPA_PIC.cs:546 | try ▸ if (iCount > 0) ▸ if (p_user_id_8.Replace("^", "") != null && p_user_id_8.Replace("^", "") != "") ▸ if (!GetUserIDChk(p_user_id_8)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7679bb8d | SaveButton | SCP0050_CAPA_PIC.cs:550 | try ▸ if (iCount > 0) ▸ if (p_user_id_9.Replace("^", "") != null && p_user_id_9.Replace("^", "") != "") ▸ if (!GetUserIDChk(p_user_id_9)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5d2035e1 | SaveButton | SCP0050_CAPA_PIC.cs:554 | try ▸ if (iCount > 0) ▸ if (p_user_id_10.Replace("^", "") != null && p_user_id_10.Replace("^", "") != "") ▸ if (!GetUserIDChk(p_user_id_10)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-baacaf3a | SaveButton | SCP0050_CAPA_PIC.cs:558 | try ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("SCP.SCP0050_SAVE_CAPA_PIC") ⇒ SCP.SCP0050_SAVE_CAPA_PIC | 엔드포인트 요청 생성 |  |  |  |
| AC-c8c9109d | SaveButton | SCP0050_CAPA_PIC.cs:562 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-8cbefdf8 | SaveButton | SCP0050_CAPA_PIC.cs:563 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_company_id"] | p_company_id | 행/컬럼 값 대입 |  |  |  |
| AC-125b1895 | SaveButton | SCP0050_CAPA_PIC.cs:564 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-ba1e349a | SaveButton | SCP0050_CAPA_PIC.cs:565 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_site_id"] | p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-16aab9b5 | SaveButton | SCP0050_CAPA_PIC.cs:566 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_plant_id"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-c38e4ed8 | SaveButton | SCP0050_CAPA_PIC.cs:567 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_factory_id"] | p_factory_id | 행/컬럼 값 대입 |  |  |  |
| AC-d4880eff | SaveButton | SCP0050_CAPA_PIC.cs:568 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_operation_id"] | p_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-74a10e0b | SaveButton | SCP0050_CAPA_PIC.cs:569 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_line_id"] | p_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-8c317044 | SaveButton | SCP0050_CAPA_PIC.cs:570 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_electrode_type"] | p_electrode_type | 행/컬럼 값 대입 |  |  |  |
| AC-f287712b | SaveButton | SCP0050_CAPA_PIC.cs:571 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_loss_code"] | p_loss_code | 행/컬럼 값 대입 |  |  |  |
| AC-02f9ae42 | SaveButton | SCP0050_CAPA_PIC.cs:572 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_user_id_1"] | p_user_id_1 | 행/컬럼 값 대입 |  |  |  |
| AC-cf73b5b0 | SaveButton | SCP0050_CAPA_PIC.cs:573 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_user_id_2"] | p_user_id_2 | 행/컬럼 값 대입 |  |  |  |
| AC-9d5638af | SaveButton | SCP0050_CAPA_PIC.cs:574 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_user_id_3"] | p_user_id_3 | 행/컬럼 값 대입 |  |  |  |
| AC-95854445 | SaveButton | SCP0050_CAPA_PIC.cs:575 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_user_id_4"] | p_user_id_4 | 행/컬럼 값 대입 |  |  |  |
| AC-0d1a542b | SaveButton | SCP0050_CAPA_PIC.cs:576 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_user_id_5"] | p_user_id_5 | 행/컬럼 값 대입 |  |  |  |
| AC-8256eb1d | SaveButton | SCP0050_CAPA_PIC.cs:577 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_user_id_6"] | p_user_id_6 | 행/컬럼 값 대입 |  |  |  |
| AC-5ea06217 | SaveButton | SCP0050_CAPA_PIC.cs:578 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_user_id_7"] | p_user_id_7 | 행/컬럼 값 대입 |  |  |  |
| AC-1a2ba023 | SaveButton | SCP0050_CAPA_PIC.cs:579 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_user_id_8"] | p_user_id_8 | 행/컬럼 값 대입 |  |  |  |
| AC-b65f9f83 | SaveButton | SCP0050_CAPA_PIC.cs:580 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_user_id_9"] | p_user_id_9 | 행/컬럼 값 대입 |  |  |  |
| AC-9ae9a2bb | SaveButton | SCP0050_CAPA_PIC.cs:581 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_user_id_10"] | p_user_id_10 | 행/컬럼 값 대입 |  |  |  |
| AC-ff55a4ea | SaveButton | SCP0050_CAPA_PIC.cs:582 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_update_id"] | p_update_id | 행/컬럼 값 대입 |  |  |  |
| AC-2410a7f2 | SaveButton | SCP0050_CAPA_PIC.cs:584 | try ▸ if (iCount > 0) | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-6d94e5c3 | SaveButton | SCP0050_CAPA_PIC.cs:589 | try ▸ if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "S") | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-b2f80a1f | SaveButton | SCP0050_CAPA_PIC.cs:591 | try ▸ if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { ds.Tables[0].Rows[0][1].ToString() }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-04b85ac7 | SaveButton | SCP0050_CAPA_PIC.cs:597 | try ▸ if (iCount > 0) ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "S") | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-69dd0071 | SaveButton | SCP0050_CAPA_PIC.cs:599 | try ▸ if (iCount > 0) ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00284", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b704de19 | SaveButton | SCP0050_CAPA_PIC.cs:607 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0050_CAPA_PIC.Set_RefreshAfterSave

진입점: SaveButton [try ▸ if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "S")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c09d2ae2 | SaveButton [try ▸ if (iCount > 0) ▸ if (ds.Tables[0].Rows[0]… | SCP0050_CAPA_PIC.cs:710 | foreach (int k in arrayChangeRow) | CALL_EXT | CUIControl.SetActionFlag | (spdMain, k, "N") | ⚠ 의미 확인 필요 |  |  |  |
| AC-6b2e626c | SaveButton [try ▸ if (iCount > 0) ▸ if (ds.Tables[0].Rows[0]… | SCP0050_CAPA_PIC.cs:757 | foreach (int k in arrayChangeRow) ▸ for (i < 10) | UI_PROP | range1.ForeColor | Color.Black | 속성 ForeColor 설정 |  |  |  |
| AC-bb018817 | SaveButton [try ▸ if (iCount > 0) ▸ if (ds.Tables[0].Rows[0]… | SCP0050_CAPA_PIC.cs:700 | foreach (int k in arrayChangeRow) | CALL_EXT | CUIControl.SetActionFlag | (spdMain, k, "N") | ⚠ 의미 확인 필요 |  |  |  |
| AC-229d341e | SaveButton [try ▸ if (iCount > 0) ▸ if (ds.Tables[0].Rows[0]… | SCP0050_CAPA_PIC.cs:747 | foreach (int k in arrayChangeRow) ▸ for (i < 10) | UI_PROP | range1.ForeColor | Color.Black | 속성 ForeColor 설정 |  |  |  |

## SCP0050_CAPA_PIC.SetChangedControl

진입점: this.Load / cboDivision.SelectedIndexChanged [if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d5789612 | this.Load 외 1 | SCP0050_CAPA_PIC.cs:208 |  | FLAG | dtShopGroup | Data_SCP.Common(Data_SCP.Type.ShopGroupId, false, pDivisionID) | 화면 필드/플래그 변경 |  |  |  |
| AC-acabfe4c | this.Load 외 1 | SCP0050_CAPA_PIC.cs:208 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.ShopGroupId, false, pDivisionID) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-42e49481 | this.Load 외 1 | SCP0050_CAPA_PIC.cs:209 |  | LIST_REBIND | clsCtrl.setListBox | (dtShopGroup, clbGroup, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-0cc33afa | this.Load 외 1 | SCP0050_CAPA_PIC.cs:212 |  | FLAG | dtPlantByGroup | Data_SCP.Common(Data_SCP.Type.PlantByGroup, false, pDivisionID, pGroupId) | 화면 필드/플래그 변경 |  |  |  |
| AC-d3756823 | this.Load 외 1 | SCP0050_CAPA_PIC.cs:212 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.PlantByGroup, false, pDivisionID, pGroupId) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-48f654f9 | this.Load 외 1 | SCP0050_CAPA_PIC.cs:213 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantByGroup, clbPlant, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-39367e35 | this.Load 외 1 | SCP0050_CAPA_PIC.cs:216 |  | FLAG | dtBuildingByShopGroupId | Data_SCP.Common(Data_SCP.Type.BuildingByShopGroupId, false, pDivisionID, pPlantId, pGroupI… | 화면 필드/플래그 변경 |  |  |  |
| AC-f64daf58 | this.Load 외 1 | SCP0050_CAPA_PIC.cs:216 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.BuildingByShopGroupId, false, pDivisionID, pPlantId, pGroupId) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-989a1ab1 | this.Load 외 1 | SCP0050_CAPA_PIC.cs:217 |  | LIST_REBIND | clsCtrl.setListBox | (dtBuildingByShopGroupId, clbBuilding, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-58ac309b | this.Load 외 1 | SCP0050_CAPA_PIC.cs:220 |  | FLAG | dtLineByOperationPlantId | Data_SCP.Common(Data_SCP.Type.LineByOperationPlantId, false, pDivisionID, pPlantId, pBuild… | 화면 필드/플래그 변경 |  |  |  |
| AC-186dab6c | this.Load 외 1 | SCP0050_CAPA_PIC.cs:220 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.LineByOperationPlantId, false, pDivisionID, pPlantId, pBuilding,pGroupId) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-b064247d | this.Load 외 1 | SCP0050_CAPA_PIC.cs:221 |  | LIST_REBIND | clsCtrl.setListBox | (dtLineByOperationPlantId, clbLine, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-1e39588a | this.Load 외 1 | SCP0050_CAPA_PIC.cs:224 |  | FLAG | dtOperationByLine | Data.Common(Data.Type.OperationByLine, false, pDivisionID, pPlantId, pBuilding, pLineId, p… ⇒ biz:CommonData.CommonDataList [code=OperationByLine] | 화면 필드/플래그 변경 |  |  |  |
| AC-3d302f06 | this.Load 외 1 | SCP0050_CAPA_PIC.cs:224 |  | COMBO_DATA | Data.Common | (Data.Type.OperationByLine, false, pDivisionID, pPlantId, pBuilding, pLineId, pGroupId) ⇒ biz:CommonData.CommonDataList [code=OperationByLine] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d7ecf9c4 | this.Load 외 1 | SCP0050_CAPA_PIC.cs:225 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperationByLine, clbOperation, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-d9330658 | this.Load 외 1 | SCP0050_CAPA_PIC.cs:227 |  | LIST_REBIND | clsCtrl.setListBox | (dtMDMCategoryId, cboCategoryId, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-9e0b664e | this.Load 외 1 | SCP0050_CAPA_PIC.cs:228 |  | LIST_REBIND | clsCtrl.setListBox | (dtMDMKeyId, cboKeyId, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-7ef8716d | this.Load 외 1 | SCP0050_CAPA_PIC.cs:231 |  | FLAG | dtPlantByDivisionForIns | new DataTable() | 화면 필드/플래그 변경 |  |  |  |
| AC-3a28641c | this.Load 외 1 | SCP0050_CAPA_PIC.cs:232 |  | DATA_OP | dtPlantByDivisionForIns.Columns.Add | ("CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-15bf0071 | this.Load 외 1 | SCP0050_CAPA_PIC.cs:233 |  | DATA_OP | dtPlantByDivisionForIns.Columns.Add | ("NAME") | 데이터 객체 조작/조회 |  |  |  |
| AC-d975e77d | this.Load 외 1 | SCP0050_CAPA_PIC.cs:235 |  | DATA_OP | dtPlantByGroup.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-25543a71 | this.Load 외 1 | SCP0050_CAPA_PIC.cs:240 | if (null != dtPlantByDivisionArr) ▸ foreach (DataRow dr in dtPlantByDivisionArr) | DATA_OP | dtPlantByDivisionForIns.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-b17c2a6d | this.Load 외 1 | SCP0050_CAPA_PIC.cs:241 | if (null != dtPlantByDivisionArr) ▸ foreach (DataRow dr in dtPlantByDivisionArr) | DATA_OP | drRow["CODE"] | dr["CODE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a019cd08 | this.Load 외 1 | SCP0050_CAPA_PIC.cs:242 | if (null != dtPlantByDivisionArr) ▸ foreach (DataRow dr in dtPlantByDivisionArr) | DATA_OP | drRow["NAME"] | dr["CODE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-f74bbae1 | this.Load 외 1 | SCP0050_CAPA_PIC.cs:244 | if (null != dtPlantByDivisionArr) ▸ foreach (DataRow dr in dtPlantByDivisionArr) | DATA_OP | dtPlantByDivisionForIns.Rows.Add | (drRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-2cbe7011 | this.Load 외 1 | SCP0050_CAPA_PIC.cs:248 |  | FLAG | dtOperationByLineForIns | dtOperationByLine.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-4e8d430a | this.Load 외 1 | SCP0050_CAPA_PIC.cs:248 |  | DATA_OP | dtOperationByLine.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-f90374b5 | this.Load 외 1 | SCP0050_CAPA_PIC.cs:249 |  | FLAG | dtMDMCategoryIdForIns | dtMDMCategoryId.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-5ed4d50d | this.Load 외 1 | SCP0050_CAPA_PIC.cs:249 |  | DATA_OP | dtMDMCategoryId.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-5e8a2c75 | this.Load 외 1 | SCP0050_CAPA_PIC.cs:250 |  | FLAG | dtMDMKeyIdForIns | dtMDMKeyId.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-d2df0ec8 | this.Load 외 1 | SCP0050_CAPA_PIC.cs:250 |  | DATA_OP | dtMDMKeyId.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-64d46d2c | this.Load 외 1 | SCP0050_CAPA_PIC.cs:198 |  | FLAG | dtShopGroup | Data_SCP.Common(Data_SCP.Type.ShopGroupId, false, division) | 화면 필드/플래그 변경 |  |  |  |
| AC-2246652d | this.Load 외 1 | SCP0050_CAPA_PIC.cs:198 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.ShopGroupId, false, division) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-1468ea2d | this.Load 외 1 | SCP0050_CAPA_PIC.cs:199 |  | LIST_REBIND | clsCtrl.setListBox | (dtShopGroup, clbGroup, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-024eaf5d | this.Load 외 1 | SCP0050_CAPA_PIC.cs:202 |  | FLAG | dtPlantByGroup | Data_SCP.Common(Data_SCP.Type.PlantByGroup, false, division, pGroupId) | 화면 필드/플래그 변경 |  |  |  |
| AC-30411f6c | this.Load 외 1 | SCP0050_CAPA_PIC.cs:202 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.PlantByGroup, false, division, pGroupId) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-47dd08ff | this.Load 외 1 | SCP0050_CAPA_PIC.cs:203 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantByGroup, clbPlant, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-c479f498 | this.Load 외 1 | SCP0050_CAPA_PIC.cs:206 |  | FLAG | dtBuildingByShopGroupId | Data_SCP.Common(Data_SCP.Type.BuildingByShopGroupId, false, division, pPlantId, pGroupId) | 화면 필드/플래그 변경 |  |  |  |
| AC-c30f8779 | this.Load 외 1 | SCP0050_CAPA_PIC.cs:206 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.BuildingByShopGroupId, false, division, pPlantId, pGroupId) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-a4eff0d2 | this.Load 외 1 | SCP0050_CAPA_PIC.cs:207 |  | LIST_REBIND | clsCtrl.setListBox | (dtBuildingByShopGroupId, clbBuilding, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-90d304e0 | this.Load 외 1 | SCP0050_CAPA_PIC.cs:210 |  | FLAG | dtLineByOperationPlantId | Data_SCP.Common(Data_SCP.Type.LineByOperationPlantId, false, division, pPlantId, pBuilding… | 화면 필드/플래그 변경 |  |  |  |
| AC-a09f425b | this.Load 외 1 | SCP0050_CAPA_PIC.cs:210 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.LineByOperationPlantId, false, division, pPlantId, pBuilding,pGroupId) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-14fa9a89 | this.Load 외 1 | SCP0050_CAPA_PIC.cs:211 |  | LIST_REBIND | clsCtrl.setListBox | (dtLineByOperationPlantId, clbLine, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-57c6d3f2 | this.Load 외 1 | SCP0050_CAPA_PIC.cs:214 |  | FLAG | dtOperationByLine | Data.Common(Data.Type.OperationByLine, false, division, pPlantId, pBuilding, pLineId, pGro… ⇒ biz:CommonData.CommonDataList [code=OperationByLine] | 화면 필드/플래그 변경 |  |  |  |
| AC-3a6aaef8 | this.Load 외 1 | SCP0050_CAPA_PIC.cs:214 |  | COMBO_DATA | Data.Common | (Data.Type.OperationByLine, false, division, pPlantId, pBuilding, pLineId, pGroupId) ⇒ biz:CommonData.CommonDataList [code=OperationByLine] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-90911fef | this.Load 외 1 | SCP0050_CAPA_PIC.cs:215 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperationByLine, clbOperation, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-65f58f2a | this.Load 외 1 | SCP0050_CAPA_PIC.cs:217 |  | LIST_REBIND | clsCtrl.setListBox | (dtMDMCategoryId, cboCategoryId, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-21c0a8e6 | this.Load 외 1 | SCP0050_CAPA_PIC.cs:218 |  | LIST_REBIND | clsCtrl.setListBox | (dtMDMKeyId, cboKeyId, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-f9aa753c | this.Load 외 1 | SCP0050_CAPA_PIC.cs:221 |  | FLAG | dtPlantByDivisionForIns | new DataTable() | 화면 필드/플래그 변경 |  |  |  |
| AC-7d6c6a89 | this.Load 외 1 | SCP0050_CAPA_PIC.cs:222 |  | DATA_OP | dtPlantByDivisionForIns.Columns.Add | ("CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-7863eee7 | this.Load 외 1 | SCP0050_CAPA_PIC.cs:223 |  | DATA_OP | dtPlantByDivisionForIns.Columns.Add | ("NAME") | 데이터 객체 조작/조회 |  |  |  |
| AC-ac997f58 | this.Load 외 1 | SCP0050_CAPA_PIC.cs:225 |  | DATA_OP | dtPlantByGroup.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-2c11e151 | this.Load 외 1 | SCP0050_CAPA_PIC.cs:230 | if (null != dtPlantByDivisionArr) ▸ foreach (DataRow dr in dtPlantByDivisionArr) | DATA_OP | dtPlantByDivisionForIns.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-6a12e3f6 | this.Load 외 1 | SCP0050_CAPA_PIC.cs:231 | if (null != dtPlantByDivisionArr) ▸ foreach (DataRow dr in dtPlantByDivisionArr) | DATA_OP | drRow["CODE"] | dr["CODE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-0714ab19 | this.Load 외 1 | SCP0050_CAPA_PIC.cs:232 | if (null != dtPlantByDivisionArr) ▸ foreach (DataRow dr in dtPlantByDivisionArr) | DATA_OP | drRow["NAME"] | dr["CODE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-013b6953 | this.Load 외 1 | SCP0050_CAPA_PIC.cs:234 | if (null != dtPlantByDivisionArr) ▸ foreach (DataRow dr in dtPlantByDivisionArr) | DATA_OP | dtPlantByDivisionForIns.Rows.Add | (drRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-7d8eabb7 | this.Load 외 1 | SCP0050_CAPA_PIC.cs:238 |  | FLAG | dtOperationByLineForIns | dtOperationByLine.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-42069785 | this.Load 외 1 | SCP0050_CAPA_PIC.cs:238 |  | DATA_OP | dtOperationByLine.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-b339b67d | this.Load 외 1 | SCP0050_CAPA_PIC.cs:239 |  | FLAG | dtMDMCategoryIdForIns | dtMDMCategoryId.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-b9b9ff95 | this.Load 외 1 | SCP0050_CAPA_PIC.cs:239 |  | DATA_OP | dtMDMCategoryId.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-9d91a361 | this.Load 외 1 | SCP0050_CAPA_PIC.cs:240 |  | FLAG | dtMDMKeyIdForIns | dtMDMKeyId.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-008904ee | this.Load 외 1 | SCP0050_CAPA_PIC.cs:240 |  | DATA_OP | dtMDMKeyId.Copy | () | 데이터 객체 조작/조회 |  |  |  |

## SCP0050_CAPA_PIC.SpdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-29fb527e | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:858 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_1)) | POPUP | new SCP0050_CAPAPICUserInfoPopup | () | 팝업/폼 생성 |  |  |  |
| AC-ab75c9ab | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:860 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_1)) | UI_PROP | popup.Width | 500 | 속성 Width 설정 |  |  |  |
| AC-db36a694 | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:861 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_1)) | UI_PROP | popup.Height | 400 | 속성 Height 설정 |  |  |  |
| AC-16348841 | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:862 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_1)) | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-3c0fc38d | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:864 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_1)) | UI_PROP | popup.Language | UserInfoContext.Current[UserInfoProperites.Language].ToString() | 속성 Language 설정 |  |  |  |
| AC-776a4cba | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:866 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_1)) | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-e2b54442 | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:872 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_1)) ▸ if (popup.S… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.USER_ID_1), item.USER_ID) | 그리드 값 설정 |  |  |  |
| AC-0013eb28 | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:880 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_2)) | POPUP | new SCP0050_CAPAPICUserInfoPopup | () | 팝업/폼 생성 |  |  |  |
| AC-29e1c33c | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:882 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_2)) | UI_PROP | popup.Width | 500 | 속성 Width 설정 |  |  |  |
| AC-1774e8d9 | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:883 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_2)) | UI_PROP | popup.Height | 400 | 속성 Height 설정 |  |  |  |
| AC-560f2116 | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:884 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_2)) | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-86b8b90b | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:886 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_2)) | UI_PROP | popup.Language | UserInfoContext.Current[UserInfoProperites.Language].ToString() | 속성 Language 설정 |  |  |  |
| AC-85a711e2 | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:888 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_2)) | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-7b9d658c | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:894 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_2)) ▸ if (popup.S… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.USER_ID_2), item.USER_ID) | 그리드 값 설정 |  |  |  |
| AC-bbbcea79 | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:902 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_3)) | POPUP | new SCP0050_CAPAPICUserInfoPopup | () | 팝업/폼 생성 |  |  |  |
| AC-11aabe95 | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:904 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_3)) | UI_PROP | popup.Width | 500 | 속성 Width 설정 |  |  |  |
| AC-baf22222 | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:905 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_3)) | UI_PROP | popup.Height | 400 | 속성 Height 설정 |  |  |  |
| AC-2347635a | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:906 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_3)) | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-c40b335a | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:908 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_3)) | UI_PROP | popup.Language | UserInfoContext.Current[UserInfoProperites.Language].ToString() | 속성 Language 설정 |  |  |  |
| AC-502a4986 | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:910 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_3)) | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-37a947b5 | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:916 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_3)) ▸ if (popup.S… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.USER_ID_3), item.USER_ID) | 그리드 값 설정 |  |  |  |
| AC-e19351e0 | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:923 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_4)) | POPUP | new SCP0050_CAPAPICUserInfoPopup | () | 팝업/폼 생성 |  |  |  |
| AC-aca7c903 | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:925 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_4)) | UI_PROP | popup.Width | 500 | 속성 Width 설정 |  |  |  |
| AC-901e70d0 | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:926 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_4)) | UI_PROP | popup.Height | 400 | 속성 Height 설정 |  |  |  |
| AC-803e3b48 | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:927 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_4)) | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-3cebf9de | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:929 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_4)) | UI_PROP | popup.Language | UserInfoContext.Current[UserInfoProperites.Language].ToString() | 속성 Language 설정 |  |  |  |
| AC-12e10f4c | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:931 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_4)) | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-9d52d376 | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:937 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_4)) ▸ if (popup.S… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.USER_ID_4), item.USER_ID) | 그리드 값 설정 |  |  |  |
| AC-6af3650d | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:944 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_5)) | POPUP | new SCP0050_CAPAPICUserInfoPopup | () | 팝업/폼 생성 |  |  |  |
| AC-1d60e68d | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:946 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_5)) | UI_PROP | popup.Width | 500 | 속성 Width 설정 |  |  |  |
| AC-1c3398d7 | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:947 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_5)) | UI_PROP | popup.Height | 400 | 속성 Height 설정 |  |  |  |
| AC-f112de6f | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:948 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_5)) | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-7124552b | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:950 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_5)) | UI_PROP | popup.Language | UserInfoContext.Current[UserInfoProperites.Language].ToString() | 속성 Language 설정 |  |  |  |
| AC-03d68ec9 | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:952 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_5)) | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-fb90f532 | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:958 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_5)) ▸ if (popup.S… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.USER_ID_5), item.USER_ID) | 그리드 값 설정 |  |  |  |
| AC-e1b41f52 | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:965 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_6)) | POPUP | new SCP0050_CAPAPICUserInfoPopup | () | 팝업/폼 생성 |  |  |  |
| AC-9a875d83 | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:967 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_6)) | UI_PROP | popup.Width | 500 | 속성 Width 설정 |  |  |  |
| AC-d7cbd737 | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:968 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_6)) | UI_PROP | popup.Height | 400 | 속성 Height 설정 |  |  |  |
| AC-a0466571 | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:969 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_6)) | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-23194c51 | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:971 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_6)) | UI_PROP | popup.Language | UserInfoContext.Current[UserInfoProperites.Language].ToString() | 속성 Language 설정 |  |  |  |
| AC-6afab83b | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:973 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_6)) | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-e1683248 | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:979 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_6)) ▸ if (popup.S… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.USER_ID_6), item.USER_ID) | 그리드 값 설정 |  |  |  |
| AC-cf91d092 | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:986 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_7)) | POPUP | new SCP0050_CAPAPICUserInfoPopup | () | 팝업/폼 생성 |  |  |  |
| AC-40218215 | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:988 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_7)) | UI_PROP | popup.Width | 500 | 속성 Width 설정 |  |  |  |
| AC-eab37864 | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:989 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_7)) | UI_PROP | popup.Height | 400 | 속성 Height 설정 |  |  |  |
| AC-47a63565 | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:990 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_7)) | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-080686ea | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:992 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_7)) | UI_PROP | popup.Language | UserInfoContext.Current[UserInfoProperites.Language].ToString() | 속성 Language 설정 |  |  |  |
| AC-ad05fd10 | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:994 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_7)) | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-2c3eaff4 | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:1000 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_7)) ▸ if (popup.S… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.USER_ID_7), item.USER_ID) | 그리드 값 설정 |  |  |  |
| AC-288f996c | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:1007 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_8)) | POPUP | new SCP0050_CAPAPICUserInfoPopup | () | 팝업/폼 생성 |  |  |  |
| AC-de0dbd63 | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:1009 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_8)) | UI_PROP | popup.Width | 500 | 속성 Width 설정 |  |  |  |
| AC-232cbae3 | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:1010 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_8)) | UI_PROP | popup.Height | 400 | 속성 Height 설정 |  |  |  |
| AC-e248e36b | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:1011 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_8)) | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-a5ac6f7a | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:1013 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_8)) | UI_PROP | popup.Language | UserInfoContext.Current[UserInfoProperites.Language].ToString() | 속성 Language 설정 |  |  |  |
| AC-9c76ade7 | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:1015 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_8)) | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-f97cf707 | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:1021 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_8)) ▸ if (popup.S… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.USER_ID_8), item.USER_ID) | 그리드 값 설정 |  |  |  |
| AC-320a1135 | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:1028 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_9)) | POPUP | new SCP0050_CAPAPICUserInfoPopup | () | 팝업/폼 생성 |  |  |  |
| AC-536b97a9 | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:1030 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_9)) | UI_PROP | popup.Width | 500 | 속성 Width 설정 |  |  |  |
| AC-826601be | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:1031 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_9)) | UI_PROP | popup.Height | 400 | 속성 Height 설정 |  |  |  |
| AC-eceae6ed | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:1032 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_9)) | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-f884fecc | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:1034 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_9)) | UI_PROP | popup.Language | UserInfoContext.Current[UserInfoProperites.Language].ToString() | 속성 Language 설정 |  |  |  |
| AC-b724da9b | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:1036 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_9)) | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-00096462 | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:1042 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_9)) ▸ if (popup.S… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.USER_ID_9), item.USER_ID) | 그리드 값 설정 |  |  |  |
| AC-c573dc06 | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:1049 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_10)) | POPUP | new SCP0050_CAPAPICUserInfoPopup | () | 팝업/폼 생성 |  |  |  |
| AC-df48a924 | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:1051 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_10)) | UI_PROP | popup.Width | 500 | 속성 Width 설정 |  |  |  |
| AC-7b0ac132 | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:1052 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_10)) | UI_PROP | popup.Height | 400 | 속성 Height 설정 |  |  |  |
| AC-c06d3725 | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:1053 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_10)) | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-9deda113 | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:1055 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_10)) | UI_PROP | popup.Language | UserInfoContext.Current[UserInfoProperites.Language].ToString() | 속성 Language 설정 |  |  |  |
| AC-cac1e19e | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:1057 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_10)) | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-28c43881 | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:1063 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_10)) ▸ if (popup.… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.USER_ID_10), item.USER_ID) | 그리드 값 설정 |  |  |  |
| AC-57c0e60f | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:848 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_1)) | POPUP | new SCP0050_CAPAPICUserInfoPopup | () | 팝업/폼 생성 |  |  |  |
| AC-0ab6cdf4 | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:850 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_1)) | UI_PROP | popup.Width | 500 | 속성 Width 설정 |  |  |  |
| AC-16d956da | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:851 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_1)) | UI_PROP | popup.Height | 400 | 속성 Height 설정 |  |  |  |
| AC-f73f6284 | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:852 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_1)) | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-aecddf7b | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:854 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_1)) | UI_PROP | popup.Language | UserInfoContext.Current[UserInfoProperites.Language].ToString() | 속성 Language 설정 |  |  |  |
| AC-d8d235cc | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:856 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_1)) | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-ecc799dd | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:862 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_1)) ▸ if (popup.S… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.USER_ID_1), item.USER_ID) | 그리드 값 설정 |  |  |  |
| AC-9cdbe134 | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:870 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_2)) | POPUP | new SCP0050_CAPAPICUserInfoPopup | () | 팝업/폼 생성 |  |  |  |
| AC-8ab4ddc3 | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:872 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_2)) | UI_PROP | popup.Width | 500 | 속성 Width 설정 |  |  |  |
| AC-5bcac829 | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:873 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_2)) | UI_PROP | popup.Height | 400 | 속성 Height 설정 |  |  |  |
| AC-283a7f27 | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:874 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_2)) | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-208ff924 | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:876 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_2)) | UI_PROP | popup.Language | UserInfoContext.Current[UserInfoProperites.Language].ToString() | 속성 Language 설정 |  |  |  |
| AC-60444940 | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:878 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_2)) | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-5ea96c94 | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:884 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_2)) ▸ if (popup.S… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.USER_ID_2), item.USER_ID) | 그리드 값 설정 |  |  |  |
| AC-8a0c2fe2 | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:892 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_3)) | POPUP | new SCP0050_CAPAPICUserInfoPopup | () | 팝업/폼 생성 |  |  |  |
| AC-337ba4c1 | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:894 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_3)) | UI_PROP | popup.Width | 500 | 속성 Width 설정 |  |  |  |
| AC-68c1a781 | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:895 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_3)) | UI_PROP | popup.Height | 400 | 속성 Height 설정 |  |  |  |
| AC-f4b626b7 | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:896 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_3)) | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-7267ccff | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:898 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_3)) | UI_PROP | popup.Language | UserInfoContext.Current[UserInfoProperites.Language].ToString() | 속성 Language 설정 |  |  |  |
| AC-e01ec9c7 | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:900 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_3)) | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-e1547a9b | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:906 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_3)) ▸ if (popup.S… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.USER_ID_3), item.USER_ID) | 그리드 값 설정 |  |  |  |
| AC-7911b01d | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:913 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_4)) | POPUP | new SCP0050_CAPAPICUserInfoPopup | () | 팝업/폼 생성 |  |  |  |
| AC-ddb99e33 | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:915 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_4)) | UI_PROP | popup.Width | 500 | 속성 Width 설정 |  |  |  |
| AC-2f54b91f | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:916 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_4)) | UI_PROP | popup.Height | 400 | 속성 Height 설정 |  |  |  |
| AC-65272767 | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:917 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_4)) | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-2ad24e2a | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:919 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_4)) | UI_PROP | popup.Language | UserInfoContext.Current[UserInfoProperites.Language].ToString() | 속성 Language 설정 |  |  |  |
| AC-bf506b0c | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:921 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_4)) | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-c8b1ede9 | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:927 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_4)) ▸ if (popup.S… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.USER_ID_4), item.USER_ID) | 그리드 값 설정 |  |  |  |
| AC-d0356954 | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:934 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_5)) | POPUP | new SCP0050_CAPAPICUserInfoPopup | () | 팝업/폼 생성 |  |  |  |
| AC-0d9a2bb4 | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:936 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_5)) | UI_PROP | popup.Width | 500 | 속성 Width 설정 |  |  |  |
| AC-6625baf6 | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:937 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_5)) | UI_PROP | popup.Height | 400 | 속성 Height 설정 |  |  |  |
| AC-3db23fea | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:938 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_5)) | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-63d64766 | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:940 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_5)) | UI_PROP | popup.Language | UserInfoContext.Current[UserInfoProperites.Language].ToString() | 속성 Language 설정 |  |  |  |
| AC-1e40e49d | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:942 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_5)) | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-394ee638 | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:948 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_5)) ▸ if (popup.S… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.USER_ID_5), item.USER_ID) | 그리드 값 설정 |  |  |  |
| AC-45da07b1 | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:955 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_6)) | POPUP | new SCP0050_CAPAPICUserInfoPopup | () | 팝업/폼 생성 |  |  |  |
| AC-9154bc84 | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:957 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_6)) | UI_PROP | popup.Width | 500 | 속성 Width 설정 |  |  |  |
| AC-9718a838 | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:958 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_6)) | UI_PROP | popup.Height | 400 | 속성 Height 설정 |  |  |  |
| AC-b05c7279 | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:959 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_6)) | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-3e4d87ec | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:961 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_6)) | UI_PROP | popup.Language | UserInfoContext.Current[UserInfoProperites.Language].ToString() | 속성 Language 설정 |  |  |  |
| AC-1155de1f | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:963 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_6)) | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-b00b02af | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:969 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_6)) ▸ if (popup.S… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.USER_ID_6), item.USER_ID) | 그리드 값 설정 |  |  |  |
| AC-9a7e4126 | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:976 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_7)) | POPUP | new SCP0050_CAPAPICUserInfoPopup | () | 팝업/폼 생성 |  |  |  |
| AC-f459e134 | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:978 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_7)) | UI_PROP | popup.Width | 500 | 속성 Width 설정 |  |  |  |
| AC-9106a226 | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:979 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_7)) | UI_PROP | popup.Height | 400 | 속성 Height 설정 |  |  |  |
| AC-ea184f66 | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:980 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_7)) | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-8a5a17f1 | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:982 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_7)) | UI_PROP | popup.Language | UserInfoContext.Current[UserInfoProperites.Language].ToString() | 속성 Language 설정 |  |  |  |
| AC-20a41717 | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:984 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_7)) | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-f23d4ce3 | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:990 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_7)) ▸ if (popup.S… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.USER_ID_7), item.USER_ID) | 그리드 값 설정 |  |  |  |
| AC-534bbe12 | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:997 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_8)) | POPUP | new SCP0050_CAPAPICUserInfoPopup | () | 팝업/폼 생성 |  |  |  |
| AC-53630f7d | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:999 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_8)) | UI_PROP | popup.Width | 500 | 속성 Width 설정 |  |  |  |
| AC-88bbd6c0 | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:1000 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_8)) | UI_PROP | popup.Height | 400 | 속성 Height 설정 |  |  |  |
| AC-18563624 | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:1001 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_8)) | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-c8d25ae8 | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:1003 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_8)) | UI_PROP | popup.Language | UserInfoContext.Current[UserInfoProperites.Language].ToString() | 속성 Language 설정 |  |  |  |
| AC-a04f0095 | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:1005 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_8)) | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-0a29580d | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:1011 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_8)) ▸ if (popup.S… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.USER_ID_8), item.USER_ID) | 그리드 값 설정 |  |  |  |
| AC-0f6af9ce | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:1018 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_9)) | POPUP | new SCP0050_CAPAPICUserInfoPopup | () | 팝업/폼 생성 |  |  |  |
| AC-df85c9f2 | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:1020 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_9)) | UI_PROP | popup.Width | 500 | 속성 Width 설정 |  |  |  |
| AC-4f892552 | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:1021 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_9)) | UI_PROP | popup.Height | 400 | 속성 Height 설정 |  |  |  |
| AC-542b56ec | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:1022 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_9)) | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-ad9f8d3e | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:1024 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_9)) | UI_PROP | popup.Language | UserInfoContext.Current[UserInfoProperites.Language].ToString() | 속성 Language 설정 |  |  |  |
| AC-a3810379 | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:1026 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_9)) | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-1a34fd6a | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:1032 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_9)) ▸ if (popup.S… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.USER_ID_9), item.USER_ID) | 그리드 값 설정 |  |  |  |
| AC-4b2448a5 | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:1039 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_10)) | POPUP | new SCP0050_CAPAPICUserInfoPopup | () | 팝업/폼 생성 |  |  |  |
| AC-b0d01304 | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:1041 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_10)) | UI_PROP | popup.Width | 500 | 속성 Width 설정 |  |  |  |
| AC-2118c778 | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:1042 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_10)) | UI_PROP | popup.Height | 400 | 속성 Height 설정 |  |  |  |
| AC-46054068 | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:1043 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_10)) | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-34580ae1 | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:1045 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_10)) | UI_PROP | popup.Language | UserInfoContext.Current[UserInfoProperites.Language].ToString() | 속성 Language 설정 |  |  |  |
| AC-43ca313e | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:1047 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_10)) | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-768f30f4 | this.spdMain.CellDoubleClick | SCP0050_CAPA_PIC.cs:1053 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID_10)) ▸ if (popup.… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.USER_ID_10), item.USER_ID) | 그리드 값 설정 |  |  |  |

## SCP0050_CAPA_PIC.SpdMain_ComboSelChange

진입점: this.spdMain.ComboSelChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e4d82587 | this.spdMain.ComboSelChange | SCP0050_CAPA_PIC.cs:1074 | if (siMain.Sheet().Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-01874c4d | this.spdMain.ComboSelChange | SCP0050_CAPA_PIC.cs:1087 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.Fl… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.FACTORY_ID), "") | 그리드 값 설정 |  |  |  |
| AC-817bc7d0 | this.spdMain.ComboSelChange | SCP0050_CAPA_PIC.cs:1088 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.Fl… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.FACTORY_NAME), "") | 그리드 값 설정 |  |  |  |
| AC-6a75b5d7 | this.spdMain.ComboSelChange | SCP0050_CAPA_PIC.cs:1089 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.Fl… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.LINE_ID), "") | 그리드 값 설정 |  |  |  |
| AC-50cf4787 | this.spdMain.ComboSelChange | SCP0050_CAPA_PIC.cs:1090 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.Fl… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.LINE_NAME), "") | 그리드 값 설정 |  |  |  |
| AC-f8c0d889 | this.spdMain.ComboSelChange | SCP0050_CAPA_PIC.cs:1091 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.Fl… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.ELECTRODE_TYPE), "") | 그리드 값 설정 |  |  |  |
| AC-488c14fd | this.spdMain.ComboSelChange | SCP0050_CAPA_PIC.cs:1092 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.Fl… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.OPERATION_ID), "") | 그리드 값 설정 |  |  |  |
| AC-a1140b3a | this.spdMain.ComboSelChange | SCP0050_CAPA_PIC.cs:1093 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.Fl… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.OPERATION_NAME), "") | 그리드 값 설정 |  |  |  |
| AC-8b8ef480 | this.spdMain.ComboSelChange | SCP0050_CAPA_PIC.cs:1100 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.Fl… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.FACTORY_ID), siMain.GetValue(e.Row, siMain.GetCol… | 그리드 값 설정 |  |  |  |
| AC-b9490098 | this.spdMain.ComboSelChange | SCP0050_CAPA_PIC.cs:1104 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.Fl… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.LINE_ID), siMain.GetValue(e.Row, siMain.GetColumn… | 그리드 값 설정 |  |  |  |
| AC-ce388b34 | this.spdMain.ComboSelChange | SCP0050_CAPA_PIC.cs:1108 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.Fl… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.OPERATION_ID), siMain.GetValue(e.Row, siMain.GetC… | 그리드 값 설정 |  |  |  |
| AC-2a14cd93 | this.spdMain.ComboSelChange | SCP0050_CAPA_PIC.cs:1114 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.Fl… | DATA_OP | dtMDMKeyIdForIns.Select().Where(c => c["CATEGORY_ID"].ToString() == sCategoryId).CopyToDat… | () | 데이터 객체 조작/조회 |  |  |  |
| AC-a2098185 | this.spdMain.ComboSelChange | SCP0050_CAPA_PIC.cs:1114 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.Fl… | DATA_OP | dtMDMKeyIdForIns.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-800094c4 | this.spdMain.ComboSelChange | SCP0050_CAPA_PIC.cs:1116 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.Fl… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.KEY_ID), dt) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-d1264a18 | this.spdMain.ComboSelChange | SCP0050_CAPA_PIC.cs:1122 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.Fl… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.LOSS_CODE), sKeyId) | 그리드 값 설정 |  |  |  |
| AC-bce24cd6 | this.spdMain.ComboSelChange | SCP0050_CAPA_PIC.cs:1064 | if (siMain.Sheet().Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0b363ad4 | this.spdMain.ComboSelChange | SCP0050_CAPA_PIC.cs:1077 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.Fl… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.FACTORY_ID), "") | 그리드 값 설정 |  |  |  |
| AC-ce3432f8 | this.spdMain.ComboSelChange | SCP0050_CAPA_PIC.cs:1078 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.Fl… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.FACTORY_NAME), "") | 그리드 값 설정 |  |  |  |
| AC-501e8a83 | this.spdMain.ComboSelChange | SCP0050_CAPA_PIC.cs:1079 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.Fl… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.LINE_ID), "") | 그리드 값 설정 |  |  |  |
| AC-c9cbc382 | this.spdMain.ComboSelChange | SCP0050_CAPA_PIC.cs:1080 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.Fl… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.LINE_NAME), "") | 그리드 값 설정 |  |  |  |
| AC-15ebcbf6 | this.spdMain.ComboSelChange | SCP0050_CAPA_PIC.cs:1081 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.Fl… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.ELECTRODE_TYPE), "") | 그리드 값 설정 |  |  |  |
| AC-3408fc56 | this.spdMain.ComboSelChange | SCP0050_CAPA_PIC.cs:1082 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.Fl… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.OPERATION_ID), "") | 그리드 값 설정 |  |  |  |
| AC-c5849cf4 | this.spdMain.ComboSelChange | SCP0050_CAPA_PIC.cs:1083 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.Fl… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.OPERATION_NAME), "") | 그리드 값 설정 |  |  |  |
| AC-3adf0914 | this.spdMain.ComboSelChange | SCP0050_CAPA_PIC.cs:1090 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.Fl… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.FACTORY_ID), siMain.GetValue(e.Row, siMain.GetCol… | 그리드 값 설정 |  |  |  |
| AC-05f44aff | this.spdMain.ComboSelChange | SCP0050_CAPA_PIC.cs:1094 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.Fl… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.LINE_ID), siMain.GetValue(e.Row, siMain.GetColumn… | 그리드 값 설정 |  |  |  |
| AC-d777144c | this.spdMain.ComboSelChange | SCP0050_CAPA_PIC.cs:1098 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.Fl… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.OPERATION_ID), siMain.GetValue(e.Row, siMain.GetC… | 그리드 값 설정 |  |  |  |
| AC-3a045ae3 | this.spdMain.ComboSelChange | SCP0050_CAPA_PIC.cs:1104 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.Fl… | DATA_OP | dtMDMKeyIdForIns.Select().Where(c => c["CATEGORY_ID"].ToString() == sCategoryId).CopyToDat… | () | 데이터 객체 조작/조회 |  |  |  |
| AC-1b4de236 | this.spdMain.ComboSelChange | SCP0050_CAPA_PIC.cs:1104 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.Fl… | DATA_OP | dtMDMKeyIdForIns.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-7578f105 | this.spdMain.ComboSelChange | SCP0050_CAPA_PIC.cs:1106 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.Fl… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.KEY_ID), dt) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-7c0a1c7b | this.spdMain.ComboSelChange | SCP0050_CAPA_PIC.cs:1112 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.Fl… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.LOSS_CODE), sKeyId) | 그리드 값 설정 |  |  |  |

## SCP0050_CAPAPICUserInfoPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6a2bebeb | this.Load | SCP0050_CAPAPICUserInfoPopup.cs:115 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-7d021cf7 | this.Load | SCP0050_CAPAPICUserInfoPopup.cs:116 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-1a3500a8 | this.Load | SCP0050_CAPAPICUserInfoPopup.cs:117 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7c279348 | this.Load | SCP0050_CAPAPICUserInfoPopup.cs:115 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-426573af | this.Load | SCP0050_CAPAPICUserInfoPopup.cs:116 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-d4074ad1 | this.Load | SCP0050_CAPAPICUserInfoPopup.cs:117 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0050_CAPAPICUserInfoPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-45cc5362 | this.Load | SCP0050_CAPAPICUserInfoPopup.cs:103 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |
| AC-57db17e5 | this.Load | SCP0050_CAPAPICUserInfoPopup.cs:108 |  | DATA_OP | list.Add | (ButtonListType.OK) | 데이터 객체 조작/조회 |  |  |  |
| AC-da1f345f | this.Load | SCP0050_CAPAPICUserInfoPopup.cs:110 |  | CALL_EXT | btnButtonList.Set_ButtonVisibleFalse | (list) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3fd119bb | this.Load | SCP0050_CAPAPICUserInfoPopup.cs:103 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |
| AC-6a80c539 | this.Load | SCP0050_CAPAPICUserInfoPopup.cs:108 |  | DATA_OP | list.Add | (ButtonListType.OK) | 데이터 객체 조작/조회 |  |  |  |
| AC-a831ccd5 | this.Load | SCP0050_CAPAPICUserInfoPopup.cs:110 |  | CALL_EXT | btnButtonList.Set_ButtonVisibleFalse | (list) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0050_CAPAPICUserInfoPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a0334e69 | Dispose | SCP0050_CAPAPICUserInfoPopup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-cc7e0964 | Dispose | SCP0050_CAPAPICUserInfoPopup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0050_CAPAPICUserInfoPopup.FindData

진입점: this.Load [if (!string.IsNullOrEmpty(strSearch))] / this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9f97ec2e | this.Load [if (!string.IsNullOrEmpty(strSearch))] 외 2 | SCP0050_CAPAPICUserInfoPopup.cs:153 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-917cbb38 | this.Load [if (!string.IsNullOrEmpty(strSearch))] 외 2 | SCP0050_CAPAPICUserInfoPopup.cs:157 | lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0050_GET_CAPA_PIC_USERINFO_POPUP") ⇒ SCP.SCP0050_GET_CAPA_PIC_USERINFO_POPUP | 엔드포인트 요청 생성 |  |  |  |
| AC-a32d4694 | this.Load [if (!string.IsNullOrEmpty(strSearch))] 외 2 | SCP0050_CAPAPICUserInfoPopup.cs:158 | lambda | DATA_OP | request.Parameters["Search"] | this.txtSearch.Text | 행/컬럼 값 대입 |  |  |  |
| AC-f2805481 | this.Load [if (!string.IsNullOrEmpty(strSearch))] 외 2 | SCP0050_CAPAPICUserInfoPopup.cs:159 | lambda | DATA_OP | request.Parameters["Language"] | Language | 행/컬럼 값 대입 |  |  |  |
| AC-cb4428c3 | this.Load [if (!string.IsNullOrEmpty(strSearch))] 외 2 | SCP0050_CAPAPICUserInfoPopup.cs:160 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-2c40f411 | this.Load [if (!string.IsNullOrEmpty(strSearch))] 외 2 | SCP0050_CAPAPICUserInfoPopup.cs:162 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-b59543ab | this.Load [if (!string.IsNullOrEmpty(strSearch))] 외 2 | SCP0050_CAPAPICUserInfoPopup.cs:166 |  | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-fe6d313e | this.Load [if (!string.IsNullOrEmpty(strSearch))] 외 2 | SCP0050_CAPAPICUserInfoPopup.cs:167 |  | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-20c47050 | this.Load [if (!string.IsNullOrEmpty(strSearch))] 외 2 | SCP0050_CAPAPICUserInfoPopup.cs:170 |  | GRID_INIT | siMain.VisibleAlternatingRow | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-b0c717bd | this.Load [if (!string.IsNullOrEmpty(strSearch))] 외 2 | SCP0050_CAPAPICUserInfoPopup.cs:153 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-1d9f43f3 | this.Load [if (!string.IsNullOrEmpty(strSearch))] 외 2 | SCP0050_CAPAPICUserInfoPopup.cs:157 | lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0050_GET_CAPA_PIC_USERINFO_POPUP") ⇒ SCP.SCP0050_GET_CAPA_PIC_USERINFO_POPUP | 엔드포인트 요청 생성 |  |  |  |
| AC-0245e1f1 | this.Load [if (!string.IsNullOrEmpty(strSearch))] 외 2 | SCP0050_CAPAPICUserInfoPopup.cs:158 | lambda | DATA_OP | request.Parameters["Search"] | this.txtSearch.Text | 행/컬럼 값 대입 |  |  |  |
| AC-50fd4e5c | this.Load [if (!string.IsNullOrEmpty(strSearch))] 외 2 | SCP0050_CAPAPICUserInfoPopup.cs:159 | lambda | DATA_OP | request.Parameters["Language"] | Language | 행/컬럼 값 대입 |  |  |  |
| AC-2a748a75 | this.Load [if (!string.IsNullOrEmpty(strSearch))] 외 2 | SCP0050_CAPAPICUserInfoPopup.cs:160 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-1dcbc4cd | this.Load [if (!string.IsNullOrEmpty(strSearch))] 외 2 | SCP0050_CAPAPICUserInfoPopup.cs:162 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-1c38da33 | this.Load [if (!string.IsNullOrEmpty(strSearch))] 외 2 | SCP0050_CAPAPICUserInfoPopup.cs:166 |  | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-8f70d5cb | this.Load [if (!string.IsNullOrEmpty(strSearch))] 외 2 | SCP0050_CAPAPICUserInfoPopup.cs:167 |  | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-5e00a738 | this.Load [if (!string.IsNullOrEmpty(strSearch))] 외 2 | SCP0050_CAPAPICUserInfoPopup.cs:170 |  | GRID_INIT | siMain.VisibleAlternatingRow | () | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0050_CAPAPICUserInfoPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-693846f2 | this.Load | SCP0050_CAPAPICUserInfoPopup.cs:82 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-66c90427 | this.Load | SCP0050_CAPAPICUserInfoPopup.cs:88 | if (!string.IsNullOrEmpty(strSearch)) | VALUE_SET | this.txtSearch.Text | strSearch | 컨트롤 값 설정 |  |  |  |
| AC-394d3bda | this.Load | SCP0050_CAPAPICUserInfoPopup.cs:82 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-54948b0c | this.Load | SCP0050_CAPAPICUserInfoPopup.cs:88 | if (!string.IsNullOrEmpty(strSearch)) | VALUE_SET | this.txtSearch.Text | strSearch | 컨트롤 값 설정 |  |  |  |

## SCP0050_CAPAPICUserInfoPopup.InitSpread

진입점: this.Load / this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2ea425a8 | this.Load 외 2 | SCP0050_CAPAPICUserInfoPopup.cs:124 |  | GRID_INIT | siMain.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-a63e7938 | this.Load 외 2 | SCP0050_CAPAPICUserInfoPopup.cs:126 |  | GRID_INIT | siMain.AddTextColumn | ("UserID", DefColumns.USER_ID, FPMerge.None, 80, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-33b15a96 | this.Load 외 2 | SCP0050_CAPAPICUserInfoPopup.cs:127 |  | GRID_INIT | siMain.AddTextColumn | ("UserName", DefColumns.USER_NAME, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b42347e2 | this.Load 외 2 | SCP0050_CAPAPICUserInfoPopup.cs:128 |  | GRID_INIT | siMain.AddTextColumn | ("EnglishName", DefColumns.USER_NAME_EN, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-facbf1c8 | this.Load 외 2 | SCP0050_CAPAPICUserInfoPopup.cs:129 |  | GRID_INIT | siMain.AddTextColumn | ("Dept_ID", DefColumns.DEPT_ID, FPMerge.None, 100, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9e69af01 | this.Load 외 2 | SCP0050_CAPAPICUserInfoPopup.cs:130 |  | GRID_INIT | siMain.AddTextColumn | ("Dept_Name", DefColumns.DEPT_NAME, FPMerge.None, 240, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4fb6da48 | this.Load 외 2 | SCP0050_CAPAPICUserInfoPopup.cs:131 |  | GRID_INIT | siMain.Freeze | (0, siMain.GetColumnIndex(DefColumns.USER_ID)) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-0efbd8b2 | this.Load 외 2 | SCP0050_CAPAPICUserInfoPopup.cs:124 |  | GRID_INIT | siMain.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-26e8a7a0 | this.Load 외 2 | SCP0050_CAPAPICUserInfoPopup.cs:126 |  | GRID_INIT | siMain.AddTextColumn | ("UserID", DefColumns.USER_ID, FPMerge.None, 80, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0d06cbc8 | this.Load 외 2 | SCP0050_CAPAPICUserInfoPopup.cs:127 |  | GRID_INIT | siMain.AddTextColumn | ("UserName", DefColumns.USER_NAME, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a984bfe2 | this.Load 외 2 | SCP0050_CAPAPICUserInfoPopup.cs:128 |  | GRID_INIT | siMain.AddTextColumn | ("EnglishName", DefColumns.USER_NAME_EN, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4a9e9dd0 | this.Load 외 2 | SCP0050_CAPAPICUserInfoPopup.cs:129 |  | GRID_INIT | siMain.AddTextColumn | ("Dept_ID", DefColumns.DEPT_ID, FPMerge.None, 100, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-68a089e6 | this.Load 외 2 | SCP0050_CAPAPICUserInfoPopup.cs:130 |  | GRID_INIT | siMain.AddTextColumn | ("Dept_Name", DefColumns.DEPT_NAME, FPMerge.None, 240, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3fcc76b0 | this.Load 외 2 | SCP0050_CAPAPICUserInfoPopup.cs:131 |  | GRID_INIT | siMain.Freeze | (0, siMain.GetColumnIndex(DefColumns.USER_ID)) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0050_CAPAPICUserInfoPopup.OkButtonClick

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.OK:]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-90506ae0 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | SCP0050_CAPAPICUserInfoPopup.cs:223 | for (i <= siMain.GetMaxRowIndex()) ▸ if (chk.Equals("True")) | DATA_OP | lstUserInfo.Add | (new SelectedUserInfo() { USER_ID = siMain.GetText(i, siMain.GetColumnIndex(DefColumns.USE… | 데이터 객체 조작/조회 |  |  |  |
| AC-d427258c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | SCP0050_CAPAPICUserInfoPopup.cs:238 |  | FLAG | SelectedUserInfoList | lstUserInfo | 화면 필드/플래그 변경 |  |  |  |
| AC-0d3147da | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | SCP0050_CAPAPICUserInfoPopup.cs:241 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-6d9c4a6c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | SCP0050_CAPAPICUserInfoPopup.cs:223 | for (i <= siMain.GetMaxRowIndex()) ▸ if (chk.Equals("True")) | DATA_OP | lstUserInfo.Add | (new SelectedUserInfo() { USER_ID = siMain.GetText(i, siMain.GetColumnIndex(DefColumns.USE… | 데이터 객체 조작/조회 |  |  |  |
| AC-eba079ab | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | SCP0050_CAPAPICUserInfoPopup.cs:238 |  | FLAG | SelectedUserInfoList | lstUserInfo | 화면 필드/플래그 변경 |  |  |  |
| AC-85601ce7 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | SCP0050_CAPAPICUserInfoPopup.cs:241 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## SCP0050_CAPAPICUserInfoPopup.SpdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1f74706d | this.spdMain.CellClick | SCP0050_CAPAPICUserInfoPopup.cs:200 | if (siMain.ActiveSheet.RowCount >= 1 && e.ColumnHeader) ▸ if (siMain.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].CellType != null && siM… | GRID_SET | siMain.ActiveSheet.SetValue | (iRow, e.Column, false) | 그리드 값 설정 |  |  |  |
| AC-f9b9afaf | this.spdMain.CellClick | SCP0050_CAPAPICUserInfoPopup.cs:201 | if (siMain.ActiveSheet.RowCount >= 1 && e.ColumnHeader) ▸ if (siMain.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].CellType != null && siM… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].Value | false | 그리드 속성/값 설정 |  |  |  |
| AC-2f0f84d2 | this.spdMain.CellClick | SCP0050_CAPAPICUserInfoPopup.cs:205 | if (siMain.ActiveSheet.RowCount >= 1 && e.ColumnHeader) ▸ if (siMain.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].CellType != null && siM… | GRID_SET | siMain.ActiveSheet.SetValue | (iRow, e.Column, true) | 그리드 값 설정 |  |  |  |
| AC-8e6aef07 | this.spdMain.CellClick | SCP0050_CAPAPICUserInfoPopup.cs:206 | if (siMain.ActiveSheet.RowCount >= 1 && e.ColumnHeader) ▸ if (siMain.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].CellType != null && siM… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].Value | true | 그리드 속성/값 설정 |  |  |  |
| AC-43cd84b1 | this.spdMain.CellClick | SCP0050_CAPAPICUserInfoPopup.cs:200 | if (siMain.ActiveSheet.RowCount >= 1 && e.ColumnHeader) ▸ if (siMain.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].CellType != null && siM… | GRID_SET | siMain.ActiveSheet.SetValue | (iRow, e.Column, false) | 그리드 값 설정 |  |  |  |
| AC-225e42bf | this.spdMain.CellClick | SCP0050_CAPAPICUserInfoPopup.cs:201 | if (siMain.ActiveSheet.RowCount >= 1 && e.ColumnHeader) ▸ if (siMain.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].CellType != null && siM… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].Value | false | 그리드 속성/값 설정 |  |  |  |
| AC-3f710b19 | this.spdMain.CellClick | SCP0050_CAPAPICUserInfoPopup.cs:205 | if (siMain.ActiveSheet.RowCount >= 1 && e.ColumnHeader) ▸ if (siMain.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].CellType != null && siM… | GRID_SET | siMain.ActiveSheet.SetValue | (iRow, e.Column, true) | 그리드 값 설정 |  |  |  |
| AC-0f5e87a7 | this.spdMain.CellClick | SCP0050_CAPAPICUserInfoPopup.cs:206 | if (siMain.ActiveSheet.RowCount >= 1 && e.ColumnHeader) ▸ if (siMain.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].CellType != null && siM… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].Value | true | 그리드 속성/값 설정 |  |  |  |

## SCP0050_CAPAPICUserInfoPopup.SpdMain_CellDoubleClick

진입점: spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9951caa6 | spdMain.CellDoubleClick | SCP0050_CAPAPICUserInfoPopup.cs:248 |  | DATA_OP | lstUserInfo.Add | (new SelectedUserInfo() { USER_ID = siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns… | 데이터 객체 조작/조회 |  |  |  |
| AC-1176bb6e | spdMain.CellDoubleClick | SCP0050_CAPAPICUserInfoPopup.cs:262 |  | FLAG | SelectedUserInfoList | lstUserInfo | 화면 필드/플래그 변경 |  |  |  |
| AC-d5ed36e0 | spdMain.CellDoubleClick | SCP0050_CAPAPICUserInfoPopup.cs:265 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-2ddb1794 | spdMain.CellDoubleClick | SCP0050_CAPAPICUserInfoPopup.cs:248 |  | DATA_OP | lstUserInfo.Add | (new SelectedUserInfo() { USER_ID = siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns… | 데이터 객체 조작/조회 |  |  |  |
| AC-57a8fe09 | spdMain.CellDoubleClick | SCP0050_CAPAPICUserInfoPopup.cs:262 |  | FLAG | SelectedUserInfoList | lstUserInfo | 화면 필드/플래그 변경 |  |  |  |
| AC-ab1fcb04 | spdMain.CellDoubleClick | SCP0050_CAPAPICUserInfoPopup.cs:265 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## SCP0050_ColumnSet_Popup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-218e2385 | .ctor | SCP0050_ColumnSet_Popup.cs:80 |  | FLAG | _sProgramID | sProgramID | 화면 필드/플래그 변경 |  |  |  |
| AC-42ff2ac4 | .ctor | SCP0050_ColumnSet_Popup.cs:81 |  | FLAG | _sSheetName | sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-a77d039a | .ctor | SCP0050_ColumnSet_Popup.cs:82 |  | FLAG | _sColumnSetType | isColumn ? "C" : "M" | 화면 필드/플래그 변경 |  |  |  |
| AC-c1a4e65d | .ctor | SCP0050_ColumnSet_Popup.cs:83 |  | FLAG | _sDivisionId | sDivisionId | 화면 필드/플래그 변경 |  |  |  |

## SCP0050_ColumnSet_Popup.ColumnSetForm_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-caae1ca4 | this.Load | SCP0050_ColumnSet_Popup.cs:120 |  | UI_MISC | this.InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-aa84e881 | this.Load | SCP0050_ColumnSet_Popup.cs:128 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## SCP0050_ColumnSet_Popup.ColumnSetForm_SizeChanged

진입점: this.SizeChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f284bc25 | this.SizeChanged | SCP0050_ColumnSet_Popup.cs:591 |  | UI_PROP | pnlCenterButton.Top | (pnlCenter.Height - pnlCenterButton.Height) / 2 | 속성 Top 설정 |  |  |  |

## SCP0050_ColumnSet_Popup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-38bf7f2d | Dispose | SCP0050_ColumnSet_Popup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0050_ColumnSet_Popup.InitClass

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-486953ab | this.Load | SCP0050_ColumnSet_Popup.cs:133 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |

## SCP0050_ColumnSet_Popup.InitControl

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-24bbee2c | this.Load | SCP0050_ColumnSet_Popup.cs:137 |  | UI_PROP | pnlBottom.Dock | DockStyle.Bottom | 속성 Dock 설정 |  |  |  |
| AC-db452899 | this.Load | SCP0050_ColumnSet_Popup.cs:139 |  | UI_PROP | pnlCenter.Dock | DockStyle.Left | 속성 Dock 설정 |  |  |  |
| AC-38672c45 | this.Load | SCP0050_ColumnSet_Popup.cs:141 |  | UI_PROP | spdBase.Dock | DockStyle.Fill | 속성 Dock 설정 |  |  |  |
| AC-17c681b1 | this.Load | SCP0050_ColumnSet_Popup.cs:142 |  | UI_PROP | spdUser.Dock | DockStyle.Fill | 속성 Dock 설정 |  |  |  |
| AC-ef6ca45b | this.Load | SCP0050_ColumnSet_Popup.cs:143 |  | UI_PROP | splMain.Dock | DockStyle.Fill | 속성 Dock 설정 |  |  |  |
| AC-0e3fab33 | this.Load | SCP0050_ColumnSet_Popup.cs:145 |  | VALUE_SET | this.Text | _sColumnSetType == "C" ? "Column Setting" : "Measure Setting" | 컨트롤 값 설정 |  |  |  |
| AC-e0d9706c | this.Load | SCP0050_ColumnSet_Popup.cs:146 |  | UI_PROP | this.Size | new Size(440, 400) | 속성 Size 설정 |  |  |  |
| AC-e52623b2 | this.Load | SCP0050_ColumnSet_Popup.cs:149 |  | UI_PROP | this.Size | new Size(_sColumnSetType == "C" ? 600 : 600, 400) | 속성 Size 설정 |  |  |  |
| AC-386fa528 | this.Load | SCP0050_ColumnSet_Popup.cs:152 |  | UI_PROP | splMain.SplitterDistance | this.Width / iSplitter - ((pnlCenter.Width + splMain.SplitterWidth)) | 속성 SplitterDistance 설정 |  |  |  |
| AC-1eb5965e | this.Load | SCP0050_ColumnSet_Popup.cs:153 |  | UI_PROP | splMain.SplitterDistance | this.Width / iSplitter - ((pnlCenter.Width + splMain.SplitterWidth) / 2) | 속성 SplitterDistance 설정 |  |  |  |

## SCP0050_ColumnSet_Popup.InitSheet

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f1480d76 | this.Load | SCP0050_ColumnSet_Popup.cs:180 |  | GRID_INIT | this.AddSheet | (spdBase, "Base", "Base", 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-234371df | this.Load | SCP0050_ColumnSet_Popup.cs:182 |  | GRID_INIT | clsCtrl.InitSheet | (si, 0) | 그리드 재구성/초기화 |  |  |  |
| AC-c73775f1 | this.Load | SCP0050_ColumnSet_Popup.cs:183 |  | UI_PROP | si.IsRowMove | false | 속성 IsRowMove 설정 |  |  |  |
| AC-97c76bfa | this.Load | SCP0050_ColumnSet_Popup.cs:188 |  | GRID_INIT | si.AddTextColumn | (columnTitle, "COLUMN_LABEL_NAME", FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b61c671f | this.Load | SCP0050_ColumnSet_Popup.cs:189 |  | GRID_INIT | si.AddTextColumn | ("Matching Column", "MATCHING", FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d2b9770c | this.Load | SCP0050_ColumnSet_Popup.cs:190 |  | GRID_INIT | si.AddNumColumn | ("Matching Column Order", "MATCHING", FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-407c960d | this.Load | SCP0050_ColumnSet_Popup.cs:198 |  | GRID_SET | spdBase.Sheets[0].Columns[0, spdBase.Sheets[0].ColumnCount - 1].Locked | true | 그리드 속성/값 설정 |  |  |  |
| AC-6419747e | this.Load | SCP0050_ColumnSet_Popup.cs:201 |  | GRID_INIT | this.AddSheet | (spdUser, "User", "User", 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-a9e1c3b1 | this.Load | SCP0050_ColumnSet_Popup.cs:203 |  | GRID_INIT | clsCtrl.InitSheet | (si, 0) | 그리드 재구성/초기화 |  |  |  |
| AC-77f274dc | this.Load | SCP0050_ColumnSet_Popup.cs:204 |  | UI_PROP | si.IsRowMove | true | 속성 IsRowMove 설정 |  |  |  |
| AC-e1511bd3 | this.Load | SCP0050_ColumnSet_Popup.cs:209 |  | GRID_INIT | si.AddTextColumn | (columnTitle, "COLUMN_LABEL_NAME", FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-02ef7839 | this.Load | SCP0050_ColumnSet_Popup.cs:210 |  | GRID_INIT | si.AddNumColumn | ("Matching Column Order", "MATCHING", FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d2208981 | this.Load | SCP0050_ColumnSet_Popup.cs:220 |  | GRID_SET | spdUser.Sheets[0].Columns[0, spdUser.Sheets[0].ColumnCount - 1].Locked | true | 그리드 속성/값 설정 |  |  |  |

## SCP0050_ColumnSet_Popup.ResetWidth

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bf6f77a0 | this.Load | SCP0050_ColumnSet_Popup.cs:242 |  | UI_PROP | this.Width | += iWidth | 속성 Width 설정 |  |  |  |
| AC-7eb72692 | this.Load | SCP0050_ColumnSet_Popup.cs:243 |  | UI_PROP | splMain.SplitterDistance | this.Width / 2 - iWidth2 | 속성 SplitterDistance 설정 |  |  |  |

## SCP0050_ColumnSet_Popup.SaveColumnSet

진입점: this.usrButtonList1.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.OK:]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-48a6501e | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… | SCP0050_ColumnSet_Popup.cs:502 | if (editCount < orgCount) | MESSAGE | MessageBox.Show | ("Not enough column in excel file") | 메시지 표시 |  |  |  |
| AC-49d0828a | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… | SCP0050_ColumnSet_Popup.cs:503 | if (editCount < orgCount) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8c4bb0d8 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… | SCP0050_ColumnSet_Popup.cs:521 | for (i< ColumnsNeeded.Data.Count) | DATA_OP | MatchingResult[key] | svColumn.Cells[i, 2].Value | 행/컬럼 값 대입 |  |  |  |
| AC-314fc2dd | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… | SCP0050_ColumnSet_Popup.cs:553 | catch () | MESSAGE | MessageHelper.GMessageBox | ("MSG00006", new object[] { _sColumnSetType == "C" ? "Column" : "Measure" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SCP0050_ColumnSet_Popup.SetColumnSet

진입점: this.usrButtonList1.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Default:] / this.spdBase.CellDoubleClick / this.spdUser.CellDoubleClick / this.btnRight.Click / this.btnLeft.Click / this.Load / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-15cd524e | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | SCP0050_ColumnSet_Popup.cs:285 |  | GRID_SET | spdBase.Sheets[0].RowCount | ColumnsNeeded.Count | 그리드 속성/값 설정 |  |  |  |
| AC-afd02591 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | SCP0050_ColumnSet_Popup.cs:287 |  | GRID_SET | spdUser.Sheets[0].RowCount | MatchingColumn.Count | 그리드 속성/값 설정 |  |  |  |
| AC-cf835d1c | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | SCP0050_ColumnSet_Popup.cs:314 | foreach (KeyValuePair<string, object> a in ColumnsNeeded.Data) ▸ if (val is bool) ▸ if (bval) | GRID_SET | svSource.Cells[m, 0].Text | key + "*" | 그리드 속성/값 설정 |  |  |  |
| AC-ea07c52b | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | SCP0050_ColumnSet_Popup.cs:320 | foreach (KeyValuePair<string, object> a in ColumnsNeeded.Data) ▸ if (val is bool) ▸ else of (bval) | GRID_SET | svSource.Cells[m, 0].Text | key | 그리드 속성/값 설정 |  |  |  |
| AC-1f8bbacd | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | SCP0050_ColumnSet_Popup.cs:349 | foreach (KeyValuePair<string, object> a in MatchingColumn.Data) | GRID_SET | svExcel.Cells[m, 0].Text | key | 그리드 속성/값 설정 |  |  |  |
| AC-48a5256c | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | SCP0050_ColumnSet_Popup.cs:350 | foreach (KeyValuePair<string, object> a in MatchingColumn.Data) | GRID_SET | svExcel.Cells[m, 1].Value | m | 그리드 속성/값 설정 |  |  |  |
| AC-a0543cf5 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | SCP0050_ColumnSet_Popup.cs:353 | foreach (KeyValuePair<string, object> a in MatchingColumn.Data) ▸ if (source_col_len > m) | GRID_SET | svSource.Cells[m, 1].Text | key | 그리드 속성/값 설정 |  |  |  |
| AC-1523b433 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | SCP0050_ColumnSet_Popup.cs:354 | foreach (KeyValuePair<string, object> a in MatchingColumn.Data) ▸ if (source_col_len > m) | GRID_SET | svSource.Cells[m, 2].Value | m | 그리드 속성/값 설정 |  |  |  |
| AC-9d886883 | this.usrButtonList1.UsrButtonList_Click_Detected [switch (bu… 외 6 | SCP0050_ColumnSet_Popup.cs:361 | if (spdUser.Sheets[0].RowCount > 0) | GRID_SET | spdUser.Sheets[0].ActiveRowIndex | spdUser.Sheets[0].RowCount - 1 | 그리드 속성/값 설정 |  |  |  |

## SCP0050_ColumnSet_Popup.spdUser_ButtonClicked

진입점: this.spdUser.ButtonClicked

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b4b1533d | this.spdUser.ButtonClicked | SCP0050_ColumnSet_Popup.cs:581 | if (e.Column != sv.Columns["SUB_TOTAL_FLAG"].Index) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c9d428dc | this.spdUser.ButtonClicked | SCP0050_ColumnSet_Popup.cs:585 | for (i < sv.RowCount) | GRID_SET | sv.Cells[i, e.Column].Value | "false" | 그리드 속성/값 설정 |  |  |  |

## SCP0050_ColumnSet_Popup.spdUser_RowDragMoveCompleted

진입점: this.spdUser.RowDragMoveCompleted

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3feb22be | this.spdUser.RowDragMoveCompleted | SCP0050_ColumnSet_Popup.cs:639 | if (sv == svExcelCol) ▸ for (i< elen) ▸ if (i < slen) | GRID_SET | svSourceCol.Cells[i, 1].Text | svExcelCol.Cells[i, 0].Text | 그리드 속성/값 설정 |  |  |  |
| AC-bf60dc64 | this.spdUser.RowDragMoveCompleted | SCP0050_ColumnSet_Popup.cs:640 | if (sv == svExcelCol) ▸ for (i< elen) ▸ if (i < slen) | GRID_SET | svSourceCol.Cells[i, 2].Value | svExcelCol.Cells[i, 1].Value | 그리드 속성/값 설정 |  |  |  |

## SCP0050_ColumnSet_Popup.usrButtonList1_UsrButtonList_Click_Detected

진입점: this.usrButtonList1.UsrButtonList_Click_Detected

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-df201d51 | this.usrButtonList1.UsrButtonList_Click_Detected | SCP0050_ColumnSet_Popup.cs:606 | switch (buttonItem.UserType) case ButtonListType.Cancel: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## SCP0050_ExcelPopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1e896331 | .ctor | SCP0050_ExcelPopup.cs:129 |  | FLAG | this.bCtlEnable | true | 화면 필드/플래그 변경 |  |  |  |
| AC-caf3b0ee | .ctor | SCP0050_ExcelPopup.cs:132 |  | FLAG | Filter | new FilterDataSet() | 화면 필드/플래그 변경 |  |  |  |
| AC-81fe48f2 | .ctor | SCP0050_ExcelPopup.cs:133 |  | FLAG | HeaderLineCount | 1 | 화면 필드/플래그 변경 |  |  |  |
| AC-4ae6e02b | .ctor | SCP0050_ExcelPopup.cs:134 |  | FLAG | IgnoreColumnsNotInTitle | true | 화면 필드/플래그 변경 |  |  |  |
| AC-a4d0afdf | .ctor | SCP0050_ExcelPopup.cs:135 |  | FLAG | AutoCHK | false | 화면 필드/플래그 변경 |  |  |  |

## SCP0050_ExcelPopup.btnCheckAll_Click

진입점: this.btnCheckAll.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-22365b3e | this.btnCheckAll.Click | SCP0050_ExcelPopup.cs:851 | for (i<length) | GRID_SET | siMain.ActiveSheet.Cells[i, 0].Value | true | 그리드 속성/값 설정 |  |  |  |

## SCP0050_ExcelPopup.btnClose_Click

진입점: this.btnClose.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bb3aa6f1 | this.btnClose.Click | SCP0050_ExcelPopup.cs:843 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## SCP0050_ExcelPopup.btnDownload_Click

진입점: this.btnDownload.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1c082870 | this.btnDownload.Click | SCP0050_ExcelPopup.cs:820 |  | FOCUS | spdMain.Focus | () | 포커스 이동 |  |  |  |
| AC-304c362b | this.btnDownload.Click | SCP0050_ExcelPopup.cs:821 |  | EXCEL | ExportExcel | (0, true) | 엑셀 내보내기/올리기 |  |  |  |

## SCP0050_ExcelPopup.btnSave_Click

진입점: this.btnSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0812b977 | this.btnSave.Click | SCP0050_ExcelPopup.cs:831 |  | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-b6674df1 | this.btnSave.Click | SCP0050_ExcelPopup.cs:835 |  | MESSAGE | MessageBox.Show | ("Success Save") | 메시지 표시 |  |  |  |
| AC-42c36fe8 | this.btnSave.Click | SCP0050_ExcelPopup.cs:836 |  | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-62281afb | this.btnSave.Click | SCP0050_ExcelPopup.cs:838 |  | UI_MISC | Close | () | 창 닫기/해제 |  |  |  |

## SCP0050_ExcelPopup.btnUncheckAll_Click

진입점: this.btnUncheckAll.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7c02ee77 | this.btnUncheckAll.Click | SCP0050_ExcelPopup.cs:860 | for (i < length) | GRID_SET | siMain.ActiveSheet.Cells[i, 0].Value | false | 그리드 속성/값 설정 |  |  |  |

## SCP0050_ExcelPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0058560c | this.Load | SCP0050_ExcelPopup.cs:170 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-cfefcfa4 | this.Load | SCP0050_ExcelPopup.cs:171 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-f97190b9 | this.Load | SCP0050_ExcelPopup.cs:172 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-bd033cf8 | this.Load | SCP0050_ExcelPopup.cs:175 |  | GRID_INIT | siMain.AddCheckColumn | ("", "SELECT", FPMerge.None, 50, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-06f1c101 | this.Load | SCP0050_ExcelPopup.cs:179 | foreach (KeyValuePair<string, object> kvp in KeyColumns.Data) | GRID_INIT | siMain.AddTextColumn | (key, key, FPMerge.None, 50, true) | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0050_ExcelPopup.DefaultLineCheck

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-41b916a5 | (진입점 미연결) | SCP0050_ExcelPopup.cs:774 |  | CALL_EXT | ExcelService.CommonDefaultLineCheck | (row, KeyColumnList, ColumnType, ColumnLength, Filter, AcceptOnlyPositve) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1c831ee0 | (진입점 미연결) | SCP0050_ExcelPopup.cs:774 |  | RETURN | return ExcelService.CommonDefaultLineCheck(row, KeyColumnList, ColumnType, Colum… |  | 처리 중단/반환 |  |  |  |

## SCP0050_ExcelPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-da2132df | this.Load | SCP0050_ExcelPopup.cs:165 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## SCP0050_ExcelPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-199588fd | Dispose | SCP0050_ExcelPopup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0050_ExcelPopup.ExcelLineCheck

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-89f26e9c | (진입점 미연결) | SCP0050_ExcelPopup.cs:336 | if (this.DoLineCheck != null) | CALL_BASE | DoLineCheck | (row, this) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0050_ExcelPopup.FindButton

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-24da94b4 | FindButton | SCP0050_ExcelPopup.cs:218 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-ed002981 | FindButton | SCP0050_ExcelPopup.cs:219 |  | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-8fa1f7be | FindButton | SCP0050_ExcelPopup.cs:221 |  | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0050_ExcelPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6ca4300d | this.Load | SCP0050_ExcelPopup.cs:143 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-a035b945 | this.Load | SCP0050_ExcelPopup.cs:145 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0050_ExcelPopup.GetExcelFileName

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9c4d9008 | (진입점 미연결) | SCP0050_ExcelPopup.cs:310 | try | POPUP | new OpenFileDialog | () | 팝업/폼 생성 |  |  |  |
| AC-6c4390f8 | (진입점 미연결) | SCP0050_ExcelPopup.cs:311 | try | UI_PROP | openFile.Filter | "Excel files (*.xls;*.xlsx)\|*.xls;*.xlsx\|xls files (*.xls)\|*.xls\|xlsx files (*.xlsx)\|… | 속성 Filter 설정 |  |  |  |
| AC-9ae0e52f | (진입점 미연결) | SCP0050_ExcelPopup.cs:312 | try | UI_PROP | openFile.FilterIndex | 1 | 속성 FilterIndex 설정 |  |  |  |
| AC-04f48df9 | (진입점 미연결) | SCP0050_ExcelPopup.cs:313 | try | UI_PROP | openFile.RestoreDirectory | true | 속성 RestoreDirectory 설정 |  |  |  |
| AC-53aed319 | (진입점 미연결) | SCP0050_ExcelPopup.cs:314 | try | UI_PROP | openFile.InitialDirectory | @"C:\My Documents\" | 속성 InitialDirectory 설정 |  |  |  |
| AC-048b0520 | (진입점 미연결) | SCP0050_ExcelPopup.cs:315 | try | UI_PROP | openFile.FileName | FileName | 속성 FileName 설정 |  |  |  |
| AC-0c2d0990 | (진입점 미연결) | SCP0050_ExcelPopup.cs:316 | try | POPUP | openFile.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-926d4c2b | (진입점 미연결) | SCP0050_ExcelPopup.cs:318 | try | FLAG | this.FileName | openFile.FileName | 화면 필드/플래그 변경 |  |  |  |
| AC-1eaa09bb | (진입점 미연결) | SCP0050_ExcelPopup.cs:319 | try | RETURN | return this.FileName; |  | 처리 중단/반환 |  |  |  |
| AC-e751eabe | (진입점 미연결) | SCP0050_ExcelPopup.cs:323 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, ex.Source, MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-0cbcfb1d | (진입점 미연결) | SCP0050_ExcelPopup.cs:324 | catch ((Exception ex)) | RETURN | return string.Empty; |  | 처리 중단/반환 |  |  |  |

## SCP0050_ExcelPopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b0dcebb6 | this.Load | SCP0050_ExcelPopup.cs:188 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d4f4c7a9 | this.Load | SCP0050_ExcelPopup.cs:189 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0050_ExcelPopup.InitSpread_Merge

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ac795b35 | (진입점 미연결) | SCP0050_ExcelPopup.cs:209 |  | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0050_ExcelPopup.OpenAndLoadExcelData

진입점: this.btnUpload.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fa38db85 | this.btnUpload.Click | SCP0050_ExcelPopup.cs:345 |  | FLAG | FileName | ExcelService.GetExcelFileName(FileName) | 화면 필드/플래그 변경 |  |  |  |
| AC-2dd95343 | this.btnUpload.Click | SCP0050_ExcelPopup.cs:345 |  | CALL_EXT | ExcelService.GetExcelFileName | (FileName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-476d38d6 | this.btnUpload.Click | SCP0050_ExcelPopup.cs:347 |  | FLAG | hasError | false | 화면 필드/플래그 변경 |  |  |  |
| AC-35bb780a | this.btnUpload.Click | SCP0050_ExcelPopup.cs:348 |  | FLAG | IsExcelChanged | true | 화면 필드/플래그 변경 |  |  |  |
| AC-5753eda3 | this.btnUpload.Click | SCP0050_ExcelPopup.cs:349 |  | CALL_EXT | System.IO.File.Exists | (FileName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4400487e | this.btnUpload.Click | SCP0050_ExcelPopup.cs:423 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (prg != null) | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-311f2ade | this.btnUpload.Click | SCP0050_ExcelPopup.cs:425 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ else of (prg != null) | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-c1998aff | this.btnUpload.Click | SCP0050_ExcelPopup.cs:428 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try | STATE | xlApp.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-3a3a1a61 | this.btnUpload.Click | SCP0050_ExcelPopup.cs:429 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try | UI_PROP | xlApp.DisplayAlerts | false | 속성 DisplayAlerts 설정 |  |  |  |
| AC-949dfa02 | this.btnUpload.Click | SCP0050_ExcelPopup.cs:431 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try | CALL_EXT | xlApp.Workbooks.Open | (FileName, Missing.Value, Missing.Value, Missing.Value, Missing.Value, Missing.Value , Mis… | ⚠ 의미 확인 필요 |  |  |  |
| AC-963f196e | this.btnUpload.Click | SCP0050_ExcelPopup.cs:451 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try | CALL_EXT | xlRange.get_Value | (Type.Missing) | ⚠ 의미 확인 필요 |  |  |  |
| AC-88bafc6f | this.btnUpload.Click | SCP0050_ExcelPopup.cs:457 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try | POPUP | new SCP0050_ColumnSet_Popup | ("", "", false, "") | 팝업/폼 생성 |  |  |  |
| AC-4776e4fb | this.btnUpload.Click | SCP0050_ExcelPopup.cs:458 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try | UI_PROP | colset.ColumnsNeeded | KeyColumns | 속성 ColumnsNeeded 설정 |  |  |  |
| AC-b4d75fe3 | this.btnUpload.Click | SCP0050_ExcelPopup.cs:470 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ for (j < iCCnt) ▸ if (!string.IsNullOrWhiteSpac… | DATA_OP | colset.MatchingColumn[excelcolname] | j | 행/컬럼 값 대입 |  |  |  |
| AC-3173ccb0 | this.btnUpload.Click | SCP0050_ExcelPopup.cs:476 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try | POPUP | colset.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-d77e3104 | this.btnUpload.Click | SCP0050_ExcelPopup.cs:486 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (result == DialogResult.OK) ▸ if (main != nu… | DATA_OP | main.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-9d20a170 | this.btnUpload.Click | SCP0050_ExcelPopup.cs:491 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (result == DialogResult.OK) ▸ else of (main … | DATA_OP | dt.Columns.SafeAdd | ("Select", typeof(bool)) | 데이터 객체 조작/조회 |  |  |  |
| AC-1a3a5f12 | this.btnUpload.Click | SCP0050_ExcelPopup.cs:496 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (result == DialogResult.OK) ▸ else of (main … | DATA_OP | dt.Columns.SafeAdd | (key, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-ff20fa8b | this.btnUpload.Click | SCP0050_ExcelPopup.cs:499 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (result == DialogResult.OK) ▸ else of (main … | DATA_OP | excelSource.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-fae2a89e | this.btnUpload.Click | SCP0050_ExcelPopup.cs:510 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (result == DialogResult.OK) ▸ foreach (DataC… | UI_PROP | coldef.DataType | typeof(string) | 속성 DataType 설정 |  |  |  |
| AC-1ded2420 | this.btnUpload.Click | SCP0050_ExcelPopup.cs:529 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (result == DialogResult.OK) ▸ foreach (KeyVa… | DATA_OP | dtExcel.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-201a3f4b | this.btnUpload.Click | SCP0050_ExcelPopup.cs:530 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (result == DialogResult.OK) ▸ foreach (KeyVa… | DATA_OP | dtExcel.Rows.Add | (row) | 데이터 객체 조작/조회 |  |  |  |
| AC-2683d89e | this.btnUpload.Click | SCP0050_ExcelPopup.cs:538 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (result == DialogResult.OK) ▸ foreach (KeyVa… | DATA_OP | row[datacolindex + 1] | excel_value | 행/컬럼 값 대입 |  |  |  |
| AC-17f21479 | this.btnUpload.Click | SCP0050_ExcelPopup.cs:548 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (result == DialogResult.OK) ▸ if (excelSourc… | DATA_OP | r["SELECT"] | true | 행/컬럼 값 대입 |  |  |  |
| AC-68d1530f | this.btnUpload.Click | SCP0050_ExcelPopup.cs:551 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (result == DialogResult.OK) | GRID_BIND | siMain.Query | (excelSource, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-7922c8b5 | this.btnUpload.Click | SCP0050_ExcelPopup.cs:733 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (prg != null) | UI_MISC | prg.Hide | () | 창 닫기/해제 |  |  |  |
| AC-72a8f65c | this.btnUpload.Click | SCP0050_ExcelPopup.cs:735 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ else of (prg != null) | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-666561e7 | this.btnUpload.Click | SCP0050_ExcelPopup.cs:736 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try | RETURN | return hasError; |  | 처리 중단/반환 |  |  |  |
| AC-80112c6d | this.btnUpload.Click | SCP0050_ExcelPopup.cs:740 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, ex.Source, MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-2039f212 | this.btnUpload.Click | SCP0050_ExcelPopup.cs:746 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ finally | CALL_EXT | xlApp.Quit | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-fde8fa4d | this.btnUpload.Click | SCP0050_ExcelPopup.cs:750 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ finally ▸ if (prg != null) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-932051ab | this.btnUpload.Click | SCP0050_ExcelPopup.cs:752 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ finally ▸ else of (prg != null) | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-62858838 | this.btnUpload.Click | SCP0050_ExcelPopup.cs:758 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | RETURN | return hasError; |  | 처리 중단/반환 |  |  |  |
| AC-238896d3 | this.btnUpload.Click | SCP0050_ExcelPopup.cs:766 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## SCP0050_ExcelPopup.SaveToDB

진입점: this.btnSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-59a0803b | this.btnSave.Click | SCP0050_ExcelPopup.cs:275 | try | DATA_OP | Filter["USER_ID"] | "chkim.68" | 행/컬럼 값 대입 |  |  |  |
| AC-a0196f20 | this.btnSave.Click | SCP0050_ExcelPopup.cs:278 | try ▸ if (dsSrc != null) | DATA_OP | dsSrc.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-018e57f6 | this.btnSave.Click | SCP0050_ExcelPopup.cs:279 | try ▸ if (dsSrc != null) | DATA_OP | dsSrc.Tables[0].Select | ("SELECT='TRUE'") | 데이터 객체 조작/조회 |  |  |  |
| AC-43a75544 | this.btnSave.Click | SCP0050_ExcelPopup.cs:282 | try ▸ if (dsSrc != null) ▸ if (selected != null && selected.Length > 0) | DATA_OP | selected.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-2dbc90e1 | this.btnSave.Click | SCP0050_ExcelPopup.cs:285 | try ▸ if (dsSrc != null) ▸ if (selected != null && selected.Length > 0) ▸ foreach (DataRow row in sTable.Rows) | CALL_EXT | row.SetAdded | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-9ef3214c | this.btnSave.Click | SCP0050_ExcelPopup.cs:287 | try ▸ if (dsSrc != null) ▸ if (selected != null && selected.Length > 0) | UI_PROP | sTable.TableName | "save" | 속성 TableName 설정 |  |  |  |
| AC-f53ea8dd | this.btnSave.Click | SCP0050_ExcelPopup.cs:288 | try ▸ if (dsSrc != null) ▸ if (selected != null && selected.Length > 0) | ENDPOINT | DataService.FP_ExecuteNonQuery | ("CAPA_PIC", "delete_tmp_capa_pic", Filter.Dictionary, "Capa") ⇒ biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=delete_tmp_capa_pic] \| FP\C… | 엔드포인트 호출 |  |  |  |
| AC-7b63fb6c | this.btnSave.Click | SCP0050_ExcelPopup.cs:289 | try ▸ if (dsSrc != null) ▸ if (selected != null && selected.Length > 0) | ENDPOINT | DataService.FP_PseudoBatch2 | ("CAPA_PIC", "upload_pic", sTable, 0, "Capa") ⇒ biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=upload_pic] \| FP\Capa\CAPA_PIC#… | 엔드포인트 호출 |  |  |  |
| AC-bd31307d | this.btnSave.Click | SCP0050_ExcelPopup.cs:290 | try ▸ if (dsSrc != null) ▸ if (selected != null && selected.Length > 0) | ENDPOINT | DataService.FP_ExecuteQuery | ("CAPA_PIC", "fill_capa_pic", Filter.Dictionary, "Capa") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=fill_capa_pic] \| FP\Capa\CAPA_… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-2852e03b | this.btnSave.Click | SCP0050_ExcelPopup.cs:291 | try ▸ if (dsSrc != null) ▸ if (selected != null && selected.Length > 0) | ENDPOINT | DataService.FP_ExecuteQuery | ("CAPA_PIC", "merge_capa_pic", Filter.Dictionary, "Capa") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=merge_capa_pic] \| FP\Capa\CAPA… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-893e3a93 | this.btnSave.Click | SCP0050_ExcelPopup.cs:298 | catch ((Exception saveErr)) | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-6eee1363 | this.btnSave.Click | SCP0050_ExcelPopup.cs:299 | catch ((Exception saveErr)) | THROW | throw saveErr; |  | 예외 발생 |  |  |  |

## SCP0050_ExcelPopup.SetSpreadInit

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6de02da2 | this.Load | SCP0050_ExcelPopup.cs:201 |  | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d88290ce | this.Load | SCP0050_ExcelPopup.cs:202 |  | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |

