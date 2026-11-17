# SSP0024 Web 컴포넌트 매핑 (React + Wijmo)

> 라벨은 props.csv의 LayoutControlItem.Text 원문을 그대로 옮겼습니다. 아래 React/Wijmo 컴포넌트는 매핑 **후보**이며, TO-BE 공용 컴포넌트 이름은 이 Fact Pack에 없어 일반 명칭으로 적었습니다.

## 1. 메인 화면 `SSP0024_ShipmentMasterElectrode` 컨트롤 매핑
| AS-IS 컨트롤 | 유형 | LayoutItem(라벨 원문) | 크기(컨트롤 / 아이템) | 기능 사실 | TO-BE 후보 |
|---|---|---|---|---|---|
| cboPlantSite | UsrCheckedList | PlanSite → `"Plant Site"` | 138×21 / 199×29 | 데이터: PlantSiteByFactoryEEOperation(SetChangedControl:191) | 다중선택 콤보(Wijmo MultiSelect) |
| cboDivision | UsrCombo | Division → `"Div"` | 110×20 / 135×29 | SelectedIndexChanged → ClbDivision_SelectedIndexChanged → Plant Site 재조회, Material/Model 비움 | 단일 선택 콤보(Wijmo ComboBox) |
| txtMaterialId | UsrMultiLineEditor | MaterialID → `"Material"` | 121×21 / 185×29 | BtnMaterialId_Click에서 값 설정 | 멀티라인 입력 |
| btnMaterialId | UsrButton | layoutControlItem5 → `"layoutControlItem4"`(표시 여부 확인 필요) | 39×25 / 43×29 | Click → BtnMaterialId_Click | 돋보기 버튼(팝업 호출 여부 확인 필요) |
| txtNickName | TextEdit | NickName → `"Nick Name"` | 134×20 / 198×29 | - | 텍스트 입력 |
| txtModelId | UsrMultiLineEditor | ModelId → `"Model"` | 115×21 / 179×29 | BtnModelId_Click에서 값 설정 | 멀티라인 입력 |
| btnModelId | UsrButton | layoutControlItem4 (Text 없음) | 28×25 / 32×29 | Click → BtnModelId_Click | 돋보기 버튼 |
| emptySpaceItem1 | EmptySpaceItem | - | 102×29 | - | 여백 |
| usrConditionPanel1 | UsrConditionPanel | - | 1093×41, Dock=Top, PanelType=HidePanel | 조회조건 영역 | 조회조건 패널(접기 가능) |
| spdMain / spdMain_Sheet1 | FpSpread / SheetView | - | 1093×533, Dock=Fill | 시트 `Ship Master Elec` | Wijmo FlexGrid |
| (공통 버튼) | FindButton / SaveButton / EditButton | - | - | flow.csv 진입점 | 공통 툴바 버튼(메뉴 버튼 메타 기준 — 확인 필요) |

## 2. 팝업 `SSP0024_ItembyDivisionPopup` 컨트롤 매핑
| AS-IS 컨트롤 | 유형 | LayoutItem(라벨 원문) | 크기(컨트롤 / 아이템) | 기능 사실 | TO-BE 후보 |
|---|---|---|---|---|---|
| clbPlantSiteId | UsrCheckedList | lblPlantSite → `"Plant Site"` | 147×21 / 216×30 | InitControls:191 Enabled=false. 데이터: PlantSiteByDivision | 다중선택 콤보(비활성) |
| clbDivisionId | UsrCheckedList | lblDivision → `"Division"` | 141×21 / 189×30 | InitControls:190 Enabled=false. SelectedIndexChanged → Plant Site 재조회. 데이터: SCM0001_GET_DIVISION | 다중선택 콤보(비활성) |
| txtMaterialId | UsrMultiLineEditor | lbMaterialID → `"Material"` | 150×21 / 208×30 | InitControls:188 초기값 = sMaterial | 멀티라인 입력 |
| btnButtonList | UsrButtonList | layoutControlItem1 (Text 없음) | 175×26 / 179×30 | UsrButtonList_Click_Detected → FindData | 팝업 내 버튼 그룹 |
| emptySpaceItem1 | EmptySpaceItem | - | 173×30 | - | 여백 |
| usrConditionPanel1 | UsrConditionPanel | - | 985×50, Dock=Top, HidePanel | - | 조회조건 패널 |
| spdMain / spdMain_Sheet1 | FpSpread / SheetView | - | 985×524, Dock=Fill | 시트 `Project`, CellDoubleClick | Wijmo FlexGrid(더블클릭 선택) |
| 폼 | - | Text `"Item by DivisionPopup"` | - | - | 모달 팝업 |

## 3. 화면 배치
- props.csv에는 SplitContainer(Orientation·SplitterDistance)가 **없습니다**. 두 화면 모두 Dock 구성(위쪽 조건 패널 Dock=Top, 아래쪽 그리드 Dock=Fill)인 **상/하 2단**입니다.

| 화면 | 상단(조건 패널) | 하단(그리드) | 상:하 비율(높이 기준 계산) |
|---|---|---|---|
| 메인 | usrConditionPanel1 1093×41 | spdMain 1093×533 | 41 : 533 ≈ 7.1% : 92.9% |
| 팝업 | usrConditionPanel1 985×50 | spdMain 985×524 | 50 : 524 ≈ 8.7% : 91.3% |

- 메인 조건 영역은 한 줄입니다. layoutControlGroup2는 1093×49이고, 아이템 높이는 모두 29입니다. 아이템 배치 순서(좌표)는 Fact Pack에 없어 **확인 필요**입니다. 컨트롤 선언 순서는 btnModelId, cboPlantSite, cboDivision, txtMaterialId, btnMaterialId, txtNickName, txtModelId입니다.
- usrLayoutControl1(657×184, Dock=Fill)은 두 화면 모두 Designer에 있습니다. 화면에서의 역할은 **확인 필요**입니다.

## 4. 시트별 Grid 컬럼

### 4-1. `Ship Master Elec` (메인 · META+코드연결 · 메타 SCM_MST_SHEET_COLUMNS 25행)
생성: InitSpread:221 `SetSheetHeaderColumn`. 메타 소비 컬럼은 COLUMN_NAME, COLUMN_LABEL_NAME, COLUMN_WIDTH, HORIZONTAL_ALIGN_CODE, CELL_CONTROL_OBJECT_TYPE_CODE, CELL_COMBO_DATA_TYPE, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, UPPERCASE_APPLY_FLAG, VISIBLE_FLAG, VALID_YN, ATTRIBUTE1~5입니다. 컬럼별 폭·정렬·셀 타입 값은 Fact Pack에 없어 **확인 필요**입니다.

| # | 컬럼 | 라벨(메타 원문) | 메타 판정 | 코드 셀 콤보 |
|---:|---|---|---|---|
| 1 | DIVISION_ID | `Div*` | 기본 | InsertRow:374 dtMyDivisionIns |
| 2 | PLANT_SITE_ID | `Plant Site*` | 기본 | InsertRow:375 dtPlantSiteByFactoryForSpread / Paste:700 dtEmpty |
| 3 | PLANT_SITE_CODE | `Plant Site Code` | 기본 | - |
| 4 | MATERIAL_ID | `Material*` | 기본 | - |
| 5 | MODEL_ID | `Model` | 기본 | - |
| 6 | NICK_NAME | `Nick Name` | 기본 | - |
| 7 | CELL_TYPE | `Cell Type` | 기본 | - |
| 8 | ELECTRODE_TYPE | `Electrode Type` | 기본 | - |
| 9 | ITEM_UOM | `UOM` | 기본 | - |
| 10 | UOM_CONVERT_IN_TACT_TIME | `Pancake (m/cell)` | 기본 | - |
| 11 | PC_ROLL_LENGTH | `Pancake Roll Length` | 기본 | - |
| 12 | DOM_EXP_TYPE_CODE | `DOM/EXP.*` | 기본 | 확인 필요(dtDomExpTypeCode 연결 여부) |
| 13 | PACKAGE_TYPE_CODE | `Package Type*` | 기본 | 확인 필요(dtElectrodePackageType 연결 여부) |
| 14 | POST_OPER | `Post Oper.*` | 기본 | InsertRow:376 dtElectrodePostOperCode |
| 15 | POST_OPER_LT | `Post Oper.LT(Day)` | 기본 | ComboSelChange:621에서 POST_OPER_LT 읽음 |
| 16 | BUILDING | `Building*` | 기본 | InsertRow:377 dtBuilding |
| 17 | BUILDING_DESC | `Building Desc.` | 기본 | - |
| 18 | BOX_PER_CUT | `Box/Cut*` | 기본 | - |
| 19 | STEELCRATE_PER_CUT | `Steelcrate/Cut*` | 기본 | - |
| 20 | STEELRACK_PER_CUT | `Steelrack/Cut*` | 기본 | - |
| 21 | REMARKS | `Remarks` | 기본 | - |
| 22 | CREATED_BY | `Created By` | 기본 | - |
| 23 | CREATION_DATE | `Creation Date` | 기본 | - |
| 24 | LAST_UPDATED_BY | `Last Updated By` | 기본 | - |
| 25 | LAST_UPDATE_DATE | `Last Update Date` | 기본 | - |

> 위 표의 컬럼 순서는 grid_effective.csv 행 순서(알파벳순)를 그대로 따른 것이 아니라 업무 그룹별로 다시 묶은 것입니다. 실제 표시 순서(메타 정렬 컬럼)는 Fact Pack에 없어 **확인 필요**입니다.

### 4-2. `Project` (팝업 · 코드 하드코딩 전용, 메타 없음)
| # | 컬럼 | 헤더 원문 | 폭 | 표시 | 정렬 |
|---:|---|---|---:|---|---|
| 1 | DIVISION_ID | `division` (DefColumnsLabel.DivisionName) | 60 | true | Center/Center |
| 2 | DIVISION_NAME | `division` (DefColumnsLabel.DivisionName) | 80 | **false** | - |
| 3 | PLANT_SITE_CODE | `Plant Site Code` | 80 | true | (지정 없음) |
| 4 | PLANT_SITE_ID | `Plant Site` | 80 | true | Center/Center |
| 5 | MATERIAL_ID | `Material` | 100 | true | Center/Center |
| 6 | MODEL_ID | `Model` | 150 | true | Center/Center |
| 7 | CELL_TYPE | `Cell Type` | 80 | true | Center/Center |
| 8 | NICK_NAME | `Nick Name` | 150 | true | Center/Center |
| 9 | ELECTRODE_TYPE | `Electrode Type` | 80 | true | Center/Center |
| 10 | ITEM_UOM | `UOM` | 60 | true | Center/Center |
| 11 | UOM_CONVERT_IN_TACT_TIME | `Pancake (m/cell)` | 120 | true | (지정 없음) |

모든 컬럼이 AddTextColumn이며 병합(FPMerge)은 None입니다.

### 4-3. Division별 표시 차이 (grid_effective 기준)
| 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| `Ship Master Elec` | 25 | 25 | 25 | 25 | 25 | 25 | 25 | 25 | 25 | 25 | 25 | 25 | 25 | 25 |
| `Project` | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 |
→ division에 따른 컬럼 표시 차이는 없습니다. (`Project`의 DIVISION_NAME bVisible=false는 division과 관계없는 코드 속성입니다.)

## 5. 시트 연결 규칙
| 시트 | 연결 규칙 | 의미 |
|---|---|---|
| `Ship Master Elec` | META+코드연결 | 코드가 AddSheet(`Ship Master Elec`)로 만든 시트에 메타(SCM_MST_SHEET_COLUMNS, PROGRAM_ID=SSP0024)를 SetSheetHeaderColumn으로 적용합니다. 셀 콤보는 코드(InsertRow·SetCellCombo·ClipboardPasted)가 덧붙입니다. |
| `Project` | 코드 하드코딩 전용(메타 없음) | 팝업에서 AddSheet(`Project`) 후 AddTextColumn 11개로 구성합니다. |
| 두 시트 공통 | ColumnHeader 스타일 OVERRIDE | Designer에서 ColumnHeaderDefaultEnhanced 기반으로 정렬 General, NoteIndicatorColor Red를 지정합니다. |
