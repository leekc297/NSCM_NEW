# SSP0024 화면설계서 — Shipment Master Electrode

> 근거: AsisFacts Fact Pack(SSP0024)입니다. 라벨은 props.csv `Text` 원문을 그대로 옮겼습니다. Fact Pack에 없는 내용은 **확인 필요**로 적었습니다.
> §5 액션 명세의 엔드포인트 이름은 업무분석서 §5와 같습니다. §3 컨트롤명은 단위테스트 절차 열에서도 같은 이름을 씁니다.

## 1. 화면 개요
| 항목 | 내용 |
|---|---|
| 화면 ID | SSP0024 |
| 화면 명칭 | Shipment Master Electrode (메인 폼 Text `"SSP0024_ShipmentMasterElectrode"`) |
| 팝업 | `SSP0024_ItembyDivisionPopup` (Text `"Item by DivisionPopup"`) |
| 도메인/프로젝트 | SSP / `GSCM.SSP.Plan.UIL` |
| 메뉴 위치 | **확인 필요** (TB_FX_MenuItemInfo 1행, 내용 미제공) |
| Grid 구성 | HYBRID: META(프레임워크) + HARDCODED (+코드 표시/라벨 변경) |
| 시트 | `Ship Master Elec`(메인, META+코드연결), `Project`(팝업, 코드 하드코딩 전용) |

## 2. 화면 레이아웃

### 2-1. 분할 구조 근거
- props.csv에 **SplitContainer(Orientation·SplitterDistance)는 0건**입니다. 분할은 Dock 구성(`Dock=Top` 조건 패널 + `Dock=Fill` 그리드)으로만 이루어지며, 두 화면 모두 **상/하 2단**입니다.
- controls.csv parent 체인:
  - `this` → `usrConditionPanel1`(Dock=Top, UsrPanelType=HidePanel) → `usrLayoutControl2`(Dock=Fill) → 조회조건 컨트롤
  - `this` → `spdMain`(Dock=Fill) → `spdMain_Sheet1`
  - `usrLayoutControl1`(Dock=Fill, 657×184): parent가 비어 있습니다. 화면에서 맡는 역할은 **확인 필요**입니다.
- 비율은 Size 높이로 계산했습니다. 메인은 41 : 533(합 574), 팝업은 50 : 524(합 574)입니다.

### 2-2. 메인 `SSP0024_ShipmentMasterElectrode` 와이어프레임
```
this (Form)                                                        [폭 1093]
├─ usrConditionPanel1  Dock=Top  1093×41  HidePanel        ── 상단 7.1% (41/574)
│   └─ usrLayoutControl2  Dock=Fill  1093×41
│       └─ layoutControlGroup2 1093×49 (한 줄, 아이템 높이 29)
│          ┌──────────────┬──────────┬───────────────┬────┬──────────────┬──────────────┬───┬────────┐
│          │Plant Site    │Div       │Material       │[🔍]│Nick Name     │Model         │[🔍]│(empty) │
│          │cboPlantSite  │cboDivision│txtMaterialId │btnM│txtNickName   │txtModelId    │btnM│emptySp │
│          │PlanSite 199  │Division135│MaterialID 185 │ 43 │NickName 198  │ModelId 179   │ 32 │ 102    │
│          └──────────────┴──────────┴───────────────┴────┴──────────────┴──────────────┴───┴────────┘
│          ※ 아이템 좌표가 없어 가로 순서는 확인 필요(위 순서는 LayoutItem 선언 순서)
├─ [공통 툴바] FindButton / SaveButton / EditButton (프레임워크 버튼, 위치 확인 필요)
└─ spdMain  Dock=Fill  1093×533                            ── 하단 92.9% (533/574)
    └─ spdMain_Sheet1 → 시트 "Ship Master Elec" (25컬럼, 메타)
(usrLayoutControl1 657×184 Dock=Fill — parent 없음, 역할 확인 필요)
```

### 2-3. 팝업 `SSP0024_ItembyDivisionPopup` 와이어프레임
```
this (Form "Item by DivisionPopup")                                [폭 985]
├─ usrConditionPanel1  Dock=Top  985×50  HidePanel         ── 상단 8.7% (50/574)
│   └─ usrLayoutControl2  Dock=Fill  985×50
│       └─ layoutControlGroup2 985×50
│          ┌────────────────┬────────────────┬──────────────┬────────────────┬──────────┐
│          │Division        │Plant Site      │Material      │btnButtonList   │(empty)   │
│          │clbDivisionId   │clbPlantSiteId  │txtMaterialId │layoutCtrlItem1 │emptySp   │
│          │lblDivision 189 │lblPlantSite 216│lbMaterialID208│ 179            │ 173      │
│          │(Enabled=false) │(Enabled=false) │(=sMaterial)  │                │          │
│          └────────────────┴────────────────┴──────────────┴────────────────┴──────────┘
│          ※ 가로 순서 확인 필요
└─ spdMain  Dock=Fill  985×524                             ── 하단 91.3% (524/574)
    └─ spdMain_Sheet1 → 시트 "Project" (11컬럼 하드코딩, CellDoubleClick)
(usrLayoutControl1 657×184 Dock=Fill — parent 없음, 역할 확인 필요)
```

## 3. 컨트롤 명세
| # | 화면 | 컨트롤명 | 타입 | 라벨(props Text 원문) | 초기값 | 필수여부 | 연결 이벤트 | To-Be 컴포넌트(후보) |
|---:|---|---|---|---|---|---|---|---|
| C1 | 메인 | `usrLayoutControl1` | UsrLayoutControl | - | Dock=Fill, 657×184 | - | - | 역할 확인 필요(불필요 시 제외 검토) |
| C2 | 메인 | `usrConditionPanel1` | UsrConditionPanel | - | Dock=Top, HidePanel | - | - | 조회조건 패널(접기 가능) |
| C3 | 메인 | `usrLayoutControl2` | UsrLayoutControl | `"usrLayoutControl2"`(컨트롤 Text) | Dock=Fill | - | - | 조회조건 레이아웃 |
| C4 | 메인 | `cboPlantSite` | UsrCheckedList | `"Plant Site"` (PlanSite) | PlantSiteByFactoryEEOperation 목록 | 확인 필요 | (데이터) SetChangedControl | Wijmo MultiSelect |
| C5 | 메인 | `cboDivision` | UsrCombo | `"Div"` (Division) | 원천 데이터 확인 필요 | 확인 필요 | SelectedIndexChanged → `ClbDivision_SelectedIndexChanged` | Wijmo ComboBox |
| C6 | 메인 | `txtMaterialId` | UsrMultiLineEditor | `"Material"` (MaterialID) | Div 변경 시 `""` | 확인 필요 | (값 설정) `BtnMaterialId_Click` | 멀티라인 입력 |
| C7 | 메인 | `btnMaterialId` | UsrButton | `"layoutControlItem4"` (layoutControlItem5 Text, 표시 여부 확인 필요) | - | - | Click → `BtnMaterialId_Click` | 돋보기 버튼 |
| C8 | 메인 | `txtNickName` | TextEdit | `"Nick Name"` (NickName) | - | 확인 필요 | - | 텍스트 입력 |
| C9 | 메인 | `txtModelId` | UsrMultiLineEditor | `"Model"` (ModelId) | Div 변경 시 `""` | 확인 필요 | (값 설정) `BtnModelId_Click` | 멀티라인 입력 |
| C10 | 메인 | `btnModelId` | UsrButton | (layoutControlItem4, Text 없음) | - | - | Click → `BtnModelId_Click` | 돋보기 버튼 |
| C11 | 메인 | `spdMain` | FpSpread | - | Dock=Fill | - | CellClick → `SpdMain_CellClick`, ComboSelChange → `SpdMain_ComboSelChange`, ClipboardPasted → `SpdMain_ClipboardPasted`, KeyPress → `SpdMain_KeyPress` | Wijmo FlexGrid |
| C12 | 메인 | `spdMain_Sheet1` | SheetView | 시트 `Ship Master Elec` | - | - | - | FlexGrid 컬럼 정의(메타) |
| C13 | 팝업 | `usrLayoutControl1` | UsrLayoutControl | - | Dock=Fill, 657×184 | - | - | 역할 확인 필요 |
| C14 | 팝업 | `usrConditionPanel1` | UsrConditionPanel | - | Dock=Top, HidePanel | - | - | 조회조건 패널 |
| C15 | 팝업 | `usrLayoutControl2` | UsrLayoutControl | `"usrLayoutControl2"` | Dock=Fill | - | - | 조회조건 레이아웃 |
| C16 | 팝업 | `clbDivisionId` | UsrCheckedList | `"Division"` (lblDivision) | Enabled=false, `SCM.SCM0001_GET_DIVISION` 목록 | 확인 필요 | SelectedIndexChanged → `clbDivision_SelectedIndexChanged` | MultiSelect(비활성) |
| C17 | 팝업 | `clbPlantSiteId` | UsrCheckedList | `"Plant Site"` (lblPlantSite) | Enabled=false, PlantSiteByDivision 목록 | 확인 필요 | - | MultiSelect(비활성) |
| C18 | 팝업 | `txtMaterialId` | UsrMultiLineEditor | `"Material"` (lbMaterialID) | `sMaterial`(호출 측 전달값) | 확인 필요 | - | 멀티라인 입력 |
| C19 | 팝업 | `btnButtonList` | UsrButtonList | (layoutControlItem1, Text 없음) | - | - | UsrButtonList_Click_Detected → `btnButtonList_UsrButtonList_Click_Detected` | 팝업 버튼 그룹(조회) |
| C20 | 팝업 | `spdMain` | FpSpread | - | Dock=Fill | - | CellDoubleClick → `spdMain_CellDoubleClick` | Wijmo FlexGrid |
| C21 | 팝업 | `spdMain_Sheet1` | SheetView | 시트 `Project` | - | - | - | FlexGrid 컬럼 정의(하드코딩) |
| C22 | 메인·팝업 | 폼(this) | Form | 메인 `"SSP0024_ShipmentMasterElectrode"` / 팝업 `"Item by DivisionPopup"` | - | - | Load → `Form_Load` | 페이지 / 모달 |

## 4. 그리드 명세

### 4-1. 시트 `Ship Master Elec` (메인 · META+코드연결)
- 생성 순서: CreateSpread:206 AddSheet(`Ship Master Elec`, 1, 1, 30) → GetSheetInfo:207 → ChangeSheet:208 → InitSpread:221 `SetSheetHeaderColumn(siMain, 1)`. 메타는 SCM_MST_SHEET_COLUMNS(PROGRAM_ID=SSP0024) 25행입니다.
- 폭·정렬·셀 타입·고정·대문자·최대길이는 메타 값이 Fact Pack에 없어 **확인 필요**입니다. 아래 표는 grid_effective.csv 순서(알파벳순)이며, 실제 표시 순서도 **확인 필요**입니다.
- 편집 가능 여부: 메타 셀 타입(CELL_CONTROL_OBJECT_TYPE_CODE) 값이 미제공이어서 **확인 필요**입니다. 콤보 컬럼 4개는 코드 사실이 있습니다.

| # | 컬럼 | 헤더(메타 원문) | 타입 | 출처 | division별 표시(14개) | 편집 |
|---:|---|---|---|---|---|---|
| 1 | BOX_PER_CUT | `Box/Cut*` | 확인 필요 | META | 전 division 기본 | 확인 필요 |
| 2 | BUILDING | `Building*` | 콤보(InsertRow:377 `dtBuilding`) | META+코드 | 전 division 기본 | 콤보 선택 |
| 3 | BUILDING_DESC | `Building Desc.` | 확인 필요 | META | 전 division 기본 | 확인 필요 |
| 4 | CELL_TYPE | `Cell Type` | 확인 필요 | META | 전 division 기본 | 확인 필요 |
| 5 | CREATED_BY | `Created By` | 확인 필요 | META | 전 division 기본 | 확인 필요 |
| 6 | CREATION_DATE | `Creation Date` | 확인 필요 | META | 전 division 기본 | 확인 필요 |
| 7 | DIVISION_ID | `Div*` | 콤보(InsertRow:374 `dtMyDivisionIns`) | META+코드 | 전 division 기본 | 콤보 선택 |
| 8 | DOM_EXP_TYPE_CODE | `DOM/EXP.*` | 확인 필요(dtDomExpTypeCode 연결 여부) | META | 전 division 기본 | 확인 필요 |
| 9 | ELECTRODE_TYPE | `Electrode Type` | 확인 필요 | META | 전 division 기본 | 확인 필요 |
| 10 | ITEM_UOM | `UOM` | 확인 필요 | META | 전 division 기본 | 확인 필요 |
| 11 | LAST_UPDATE_DATE | `Last Update Date` | 확인 필요 | META | 전 division 기본 | 확인 필요 |
| 12 | LAST_UPDATED_BY | `Last Updated By` | 확인 필요 | META | 전 division 기본 | 확인 필요 |
| 13 | MATERIAL_ID | `Material*` | 확인 필요 | META | 전 division 기본 | 확인 필요 |
| 14 | MODEL_ID | `Model` | 확인 필요 | META | 전 division 기본 | 확인 필요 |
| 15 | NICK_NAME | `Nick Name` | 확인 필요 | META | 전 division 기본 | 확인 필요 |
| 16 | PACKAGE_TYPE_CODE | `Package Type*` | 확인 필요(dtElectrodePackageType 연결 여부) | META | 전 division 기본 | 확인 필요 |
| 17 | PC_ROLL_LENGTH | `Pancake Roll Length` | 확인 필요 | META | 전 division 기본 | 확인 필요 |
| 18 | PLANT_SITE_CODE | `Plant Site Code` | 확인 필요 | META | 전 division 기본 | 확인 필요 |
| 19 | PLANT_SITE_ID | `Plant Site*` | 콤보(InsertRow:375 `dtPlantSiteByFactoryForSpread` "40,81,82,81_UC" / Paste:700 `dtEmpty`) | META+코드 | 전 division 기본 | 콤보 선택 |
| 20 | POST_OPER | `Post Oper.*` | 콤보(InsertRow:376 `dtElectrodePostOperCode`) | META+코드 | 전 division 기본 | 콤보 선택 |
| 21 | POST_OPER_LT | `Post Oper.LT(Day)` | 확인 필요(ComboSelChange:621에서 POST_OPER_LT 참조) | META | 전 division 기본 | 확인 필요 |
| 22 | REMARKS | `Remarks` | 확인 필요 | META | 전 division 기본 | 확인 필요 |
| 23 | STEELCRATE_PER_CUT | `Steelcrate/Cut*` | 확인 필요 | META | 전 division 기본 | 확인 필요 |
| 24 | STEELRACK_PER_CUT | `Steelrack/Cut*` | 확인 필요 | META | 전 division 기본 | 확인 필요 |
| 25 | UOM_CONVERT_IN_TACT_TIME | `Pancake (m/cell)` | 확인 필요 | META | 전 division 기본 | 확인 필요 |

헤더 스타일(OVERRIDE, 메인 Designer 469~472): HorizontalAlignment=General, NoteIndicatorColor=Red, Parent=`"ColumnHeaderDefaultEnhanced"`, VerticalAlignment=General.

### 4-2. 시트 `Project` (팝업 · 코드 하드코딩 전용)
생성 순서: CreateSpread:202 AddSheet(`Project`, 1, 1, 30) → GetSheetInfo:203 → ChangeSheet:204 → InitSpread:214~224 AddTextColumn 11개. 병합은 모두 None입니다.

| # | 컬럼 | 헤더 원문 | 타입 | 출처 | 폭 | 표시 | 정렬 | division별 표시 | 편집 |
|---:|---|---|---|---|---:|---|---|---|---|
| 1 | DIVISION_ID | `division` | Text | HARDCODED | 60 | true | Center/Center | 14개 동일 | 확인 필요 |
| 2 | DIVISION_NAME | `division` | Text | HARDCODED | 80 | **false** | - | 14개 동일(숨김) | - |
| 3 | PLANT_SITE_CODE | `Plant Site Code` | Text | HARDCODED | 80 | true | 지정 없음 | 14개 동일 | 확인 필요 |
| 4 | PLANT_SITE_ID | `Plant Site` | Text | HARDCODED | 80 | true | Center/Center | 14개 동일 | 확인 필요 |
| 5 | MATERIAL_ID | `Material` | Text | HARDCODED | 100 | true | Center/Center | 14개 동일 | 확인 필요 |
| 6 | MODEL_ID | `Model` | Text | HARDCODED | 150 | true | Center/Center | 14개 동일 | 확인 필요 |
| 7 | CELL_TYPE | `Cell Type` | Text | HARDCODED | 80 | true | Center/Center | 14개 동일 | 확인 필요 |
| 8 | NICK_NAME | `Nick Name` | Text | HARDCODED | 150 | true | Center/Center | 14개 동일 | 확인 필요 |
| 9 | ELECTRODE_TYPE | `Electrode Type` | Text | HARDCODED | 80 | true | Center/Center | 14개 동일 | 확인 필요 |
| 10 | ITEM_UOM | `UOM` | Text | HARDCODED | 60 | true | Center/Center | 14개 동일 | 확인 필요 |
| 11 | UOM_CONVERT_IN_TACT_TIME | `Pancake (m/cell)` | Text | HARDCODED | 120 | true | 지정 없음 | 14개 동일 | 확인 필요 |

헤더 스타일(OVERRIDE, 팝업 Designer 373~376): 메인과 같습니다.
> grid_effective는 `Project`를 11컬럼으로 집계하지만, DIVISION_NAME이 `bVisible=false`이므로 실제로 보이는 컬럼은 10개로 보입니다(**확인 필요**).

## 5. 액션 명세
| # | 화면 | 버튼/이벤트 | 핸들러 | 처리 | 엔드포인트 | 결과 반영 |
|---:|---|---|---|---|---|---|
| A1 | 메인 | this.Load | `Form_Load` | InitControls > SetChangedControl | `biz:CommonData.CommonDataList` [code=PlantSiteByFactoryEEOperation] | `cboPlantSite` 목록 |
| A2 | 메인 | cboDivision.SelectedIndexChanged | `ClbDivision_SelectedIndexChanged` | SetChangedControl: Plant Site 재조회, `txtMaterialId`·`txtModelId` = "" | `biz:CommonData.CommonDataList` [code=PlantSiteByFactoryEEOperation] | `cboPlantSite` 재구성, 입력값 초기화 |
| A3 | 메인 | FindButton | (FindButton) | FindData | `SSP.SSP0024_GET_SHIP_MASTER` | `spdMain` 시트 `Ship Master Elec` |
| A4 | 메인 | SaveButton | (SaveButton) | SaveData → FindData | `SSP.SSP0024_SAVE_SHIP_MASTER` → `SSP.SSP0024_GET_SHIP_MASTER` | 저장 후 재조회 |
| A5 | 메인 | EditButton | (EditButton) | GetSSPUserCheck | `SSP.SSP0002_GET_USER_INFO_LIST` | 편집 가부(판정 확인 필요) |
| A6 | 메인 | 행 추가(버튼 확인 필요) | (InsertRow) | IsLock==false && 시트 `Ship Master Elec` → 셀 콤보 4종 설정 | (필드 데이터) `biz:CommonData.CommonDataList` [PlantSiteByFactoryEEOperation / ElectrodePostOperCode / BuildingForShipMasterElec], dtMyDivisionIns(출처 확인 필요) | DIVISION_ID·PLANT_SITE_ID·POST_OPER·BUILDING 콤보 |
| A7 | 메인 | spdMain.ComboSelChange | `SpdMain_ComboSelChange` | DIVISION_ID·CODE 기준 행에서 POST_OPER_LT를 읽음 | (호출 없음) | 반영 셀 확인 필요 |
| A8 | 메인 | spdMain.ClipboardPasted | `SpdMain_ClipboardPasted` | DIVISION_ID 열 값이 빈값이면 PLANT_SITE_ID 콤보 = dtEmpty | (호출 없음) | PLANT_SITE_ID 콤보 비움 |
| A9 | 메인 | spdMain.CellClick | `SpdMain_CellClick` | 확인 필요 | 확인 필요 | 확인 필요 |
| A10 | 메인 | spdMain.KeyPress | `SpdMain_KeyPress` | 확인 필요 | 확인 필요 | 확인 필요 |
| A11 | 메인 | btnMaterialId.Click | `BtnMaterialId_Click` | `txtMaterialId.Text = sMaterialId` | (직접 호출 없음, 팝업 연계 확인 필요) | `txtMaterialId` |
| A12 | 메인 | btnModelId.Click | `BtnModelId_Click` | `txtModelId.Text = sModelId` | (직접 호출 없음, 팝업 연계 확인 필요) | `txtModelId` |
| A13 | 팝업 | this.Load | `Form_Load` | InitControls(GetDivision, GetDivisionbyPlantSiteCode, txtMaterialId=sMaterial, clbDivisionId/clbPlantSiteId Enabled=false) → FindData | `SCM.SCM0001_GET_DIVISION`, `biz:CommonData.CommonDataList` [code=PlantSiteByDivision], `SSP.SSP0024_GET_ITEM_BY_DIVISION_POPUP` | `clbDivisionId`, `clbPlantSiteId`, 시트 `Project` |
| A14 | 팝업 | clbDivisionId.SelectedIndexChanged | `clbDivision_SelectedIndexChanged` | GetDivisionbyPlantSiteCode | `biz:CommonData.CommonDataList` [code=PlantSiteByDivision] | `clbPlantSiteId` |
| A15 | 팝업 | btnButtonList.UsrButtonList_Click_Detected | `btnButtonList_UsrButtonList_Click_Detected` | FindData | `SSP.SSP0024_GET_ITEM_BY_DIVISION_POPUP` | 시트 `Project` |
| A16 | 팝업 | FindButton | (FindButton) | FindData | `SSP.SSP0024_GET_ITEM_BY_DIVISION_POPUP` | 시트 `Project` |
| A17 | 팝업 | spdMain.CellDoubleClick | `spdMain_CellDoubleClick` | 확인 필요(선택값 반환 추정은 하지 않음) | 확인 필요 | 확인 필요 |

## 6. 검증·메시지
| # | 사실 | 근거 |
|---:|---|---|
| V1 | 셀 콤보 설정 전제: `siMain != null && siMain.IsLock(siMain.SheetName) == false`, `siMain.SheetName == "Ship Master Elec"` | grid_code.csv:374~377 |
| V2 | SetCellCombo 전제: `"" != pdivision` | grid_code.csv:852 |
| V3 | 붙여넣은 DIVISION_ID가 빈값이면 PLANT_SITE_ID 콤보를 비움 | grid_code.csv:700 |
| V4 | 그리드 라벨 `*` 표기 10개 컬럼(§4-1). 필수값 검증 로직과 메시지 문구는 **확인 필요** | grid_effective.csv |
| V5 | 조회 0건·SP 오류 시 메시지는 Fact Pack에 없음 → **확인 필요** | - |

## 7. 권한 (C/R/U/D) 사실
| 구분 | 사실 |
|---|---|
| R(조회) | FindButton → `SSP.SSP0024_GET_SHIP_MASTER` |
| C/U(생성·수정) | SaveButton → `SSP.SSP0024_SAVE_SHIP_MASTER`(MERGE SSP_MST_SHIP_MASTER_EE) |
| D(삭제) | Fact Pack에 사실 없음(**확인 필요**) |
| 편집 진입 | EditButton → `SSP.SSP0002_GET_USER_INFO_LIST`(TB_FX_USER·TB_FX_USERGROUPINFO·TB_FX_GROUPINFO·TB_FX_USERGROUPAUTHEXTENTION·SCM_MST_SSO_DEPT_INFO) — 판정 조건은 **확인 필요** |
| 메뉴 권한 메타 | TB_FX_GroupMenuAuth 12행(값 미제공) |
| 시트 잠금 | IsLock==true이면 행 추가 시 콤보를 설정하지 않음 |

## 8. To-Be 전환 메모 (Wijmo · Oracle)
| # | 항목 | AS-IS | To-Be 관점 |
|---:|---|---|---|
| M1 | 그리드 | FarPoint FpSpread + SetSheetHeaderColumn(메타) | Wijmo FlexGrid. 컬럼은 SCM_MST_SHEET_COLUMNS 메타(`Ship Master Elec` 25행)로 구성. `Project`는 하드코딩 11컬럼을 FE 컬럼 정의로 옮기거나 메타화 여부 결정 필요 |
| M2 | 셀 콤보 | 행 추가·붙여넣기 시 행 단위 SetCellTypeCombo | FlexGrid DataMap(행별 DataMap은 PLANT_SITE_ID가 DIVISION_ID에 따라 바뀌므로 행 단위 필터 필요 — 동작 확인 후 결정) |
| M3 | 조회조건 | UsrCheckedList / UsrCombo / UsrMultiLineEditor | MultiSelect / ComboBox / 멀티라인 입력 |
| M4 | 공통코드 | biz CommonData(UP_FX_GetCommonDataList 코드분기) | 공통코드 조회 API(Oracle 이관 대상 SP·패키지 이름은 **확인 필요**) |
| M5 | SP 이관 | MSSQL SP가 `STRING_SPLIT` 참조 | Oracle 19c에 `STRING_SPLIT`이 없으므로 대체 구현 필요(MSSQL 키워드 잔존 금지) |
| M6 | 저장 | MERGE + 이력 + 로그(PR_SCM_SYS_LOG_BATCH) | Oracle MERGE로 이관하고, 이력·로그 INSERT를 누락 없이 유지 |
| M7 | 레이아웃 | Dock Top/Fill(SplitContainer 없음) | 조회조건 영역 + 그리드 상/하 2단 |
| M8 | 팝업 | 별도 Form, Division/Plant Site 비활성 | 모달 팝업. 호출 측이 넘기는 값(sMaterial, division)은 **확인 필요** |

## 9. 미확정
| # | 항목 |
|---:|---|
| Q1 | 메뉴 위치, 공통 버튼(Find/Save/Edit/행 추가)의 노출 메타(TB_FX_GroupMenuAuth 12행) |
| Q2 | 조회조건 가로 배치 순서(LayoutItem 좌표 없음), btnMaterialId 라벨 `"layoutControlItem4"`의 표시 여부 |
| Q3 | `usrLayoutControl1`(parent 없음)의 역할 |
| Q4 | `Ship Master Elec` 컬럼 표시 순서·폭·정렬·셀 타입·편집 여부, DOM_EXP_TYPE_CODE / PACKAGE_TYPE_CODE 콤보 |
| Q5 | `SpdMain_CellClick`, `SpdMain_KeyPress`, `spdMain_CellDoubleClick` 동작, `SpdMain_ComboSelChange`의 POST_OPER_LT 반영 셀 |
| Q6 | `BtnMaterialId_Click` / `BtnModelId_Click`이 여는 팝업과 반환값, 팝업 호출 위치 |
| Q7 | `cboDivision`의 원천 데이터(MyDivision 여부), dtMyDivisionIns 출처 |
| Q8 | 필수값 검증·메시지 문구 |
