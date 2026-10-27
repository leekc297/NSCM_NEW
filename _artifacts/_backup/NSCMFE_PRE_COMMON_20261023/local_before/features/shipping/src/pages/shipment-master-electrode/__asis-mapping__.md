# __asis-mapping__.md — design 번호 1:1 대사표 (asis-coverage-check §0.0/§0.1)

> 원천: `00_checklist.md` · 생성: asis_mapping_gate.py --init
> 상태 허용값: 미구현(초기) / 구현(구현 위치 필수) / 제외(사유 필수) / 해당없음(사유 필수 — 조회 전용 화면의 CRUD 행 등). 빈 칸 1개 = 게이트 실패.

## 이벤트·제약 (design 번호 1:1)

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| D00-1-001 | §1 Division / LayoutControlItem | components/ShipmentMasterElectrodeForm.tsx:88 FormItem label LBL00641 |  | 구현 |
| D00-1-002 | §1 PlanSite / LayoutControlItem | components/ShipmentMasterElectrodeForm.tsx:120 FormItem label LBL00005 |  | 구현 |
| D00-1-003 | §1 MaterialID / LayoutControlItem | components/ShipmentMasterElectrodeForm.tsx:148 FormItem label LBL00021 |  | 구현 |
| D00-1-004 | §1 layoutControlItem5 / LayoutControlItem | components/ShipmentMasterElectrodeForm.tsx:162 Material 돋보기 버튼(라벨 없는 레이아웃 아이템) |  | 구현 |
| D00-1-005 | §1 NickName / LayoutControlItem | components/ShipmentMasterElectrodeForm.tsx:178 FormItem label LBL00767 |  | 구현 |
| D00-1-006 | §1 ModelId / LayoutControlItem | components/ShipmentMasterElectrodeForm.tsx:196 FormItem label LBL00669 |  | 구현 |
| D00-1-007 | §1 layoutControlItem4 / LayoutControlItem | components/ShipmentMasterElectrodeForm.tsx:210 Model 돋보기 버튼(라벨 없는 레이아웃 아이템) |  | 구현 |
| D00-1-008 | §1 emptySpaceItem1 / EmptySpaceItem |  | WinForms 절대좌표 여백(emptySpaceItem) — MUI Grid size=3 자동배치로 대체, 이식 대상 아님(design 01 §1.1) | 제외 |
| D00-1-009 | §1 layoutControlGroup1 / LayoutControlGroup |  | Form.Controls 에 Add 되지 않는 죽은 컨테이너(Designer.cs:76~92 vs :500~505) — design 01 §1.1 이 이식 금지로 명시 | 제외 |
| D00-1-010 | §1 layoutControlGroup2 / LayoutControlGroup | components/ShipmentMasterElectrodeForm.tsx:78 SearchArea conditions 컨테이너 |  | 구현 |
| D00-1-011 | §1 usrLayoutControl1 / UsrLayoutControl |  | 위 layoutControlGroup1 과 같은 미부착 컨테이너(Designer.cs:76~92) — 이식 금지 | 제외 |
| D00-1-012 | §1 usrLayoutControl2 / UsrLayoutControl | components/ShipmentMasterElectrodeForm.tsx:78 SearchArea (권한 0건 시 :95/:127/:153/:183/:201 disabled) |  | 구현 |
| D00-1-013 | §1 cboDivision / UsrCombo | components/ShipmentMasterElectrodeForm.tsx:92 CustomDropdown(Division, 단일) |  | 구현 |
| D00-1-014 | §1 usrConditionPanel1 / UsrConditionPanel | components/ShipmentMasterElectrodeForm.tsx:80 SearchArea isHidden + ShipmentMasterElectrode.tsx:384 MainTitle openSearchArea 토글 |  | 구현 |
| D00-1-015 | §1 cboPlantSite / UsrCheckedList | components/ShipmentMasterElectrodeForm.tsx:123 CustomDropdown(multiple, Plant Site) |  | 구현 |
| D00-1-016 | §1 txtMaterialId / UsrMultiLineEditor | components/ShipmentMasterElectrodeForm.tsx:151 InputField materialId |  | 구현 |
| D00-1-017 | §1 btnMaterialId / UsrButton | components/ShipmentMasterElectrodeForm.tsx:162 FunctionSearchIcon onMaterialSearch |  | 구현 |
| D00-1-018 | §1 txtNickName / TextEdit | components/ShipmentMasterElectrodeForm.tsx:181 InputField nickName |  | 구현 |
| D00-1-019 | §1 txtModelId / UsrMultiLineEditor | components/ShipmentMasterElectrodeForm.tsx:199 InputField modelId |  | 구현 |
| D00-1-020 | §1 btnModelId / UsrButton | components/ShipmentMasterElectrodeForm.tsx:210 FunctionSearchIcon onModelSearch |  | 구현 |
| D00-1-021 | §1 spdMain / FpSpread | components/ShipmentMasterElectrodeGrid.tsx:186 DataGrid (spdMain) |  | 구현 |
| D00-1-022 | §1 spdMain_Sheet1 / SheetView | shipment-master-electrode.constants.ts:27 ADMIN_SHEET_NAME = 'Ship Master Elec' |  | 구현 |
| D00-1-023 | §1 components / Container |  | WinForms IContainer(비시각 컴포넌트 컨테이너) — React 대응 개념 없음 | 해당없음 |
| D00-2-001 | §2 cboDivision / SelectedIndexChanged | components/ShipmentMasterElectrodeForm.tsx:100~110 Division onChange (PlantSite 재조회 + Material/Model clear + clearFilters) |  | 구현 |
| D00-2-002 | §2 btnMaterialId / Click | ShipmentMasterElectrode.tsx:435 ItemByDivisionModal(조회조건 Material) + :229 handleMaterialSelected |  | 구현 |
| D00-2-003 | §2 btnModelId / Click | ShipmentMasterElectrode.tsx:448 ItemByDivisionModal(조회조건 Model) + :233 handleModelSelected |  | 구현 |
| D00-2-004 | §2 spdMain / CellClick | components/ShipmentMasterElectrodeGrid.tsx:159 handleDblClick + :194 DataGrid dblClick |  | 구현 |
| D00-2-005 | §2 spdMain / ComboSelChange | components/ShipmentMasterElectrodeGrid.tsx:110 applyDerivations + :142 cellEditEnded |  | 구현 |
| D00-2-006 | §2 spdMain / KeyPress | components/ShipmentMasterElectrodeGrid.tsx:87 beginningEditHandler + utils/shipmentMasterElectrodeEditLock.ts:41 isInlineEditable(MATERIAL_ID 인라인 편집 취소 = 키입력 차단) |  | 구현 |
| D00-2-007 | §2 spdMain / ClipboardPasted | components/ShipmentMasterElectrodeGrid.tsx:121 pastingCellHandler + :180 pastedCell -> applyDerivations |  | 구현 |
| D00-3-001 | §3 253 / () — Edit 모드 전체 잠금 토글 | utils/shipmentMasterElectrodeEditLock.ts:31 isCellEditable 의 isEditMode 게이트 + ShipmentMasterElectrode.tsx:94 isEditMode state |  | 구현 |
| D00-3-002 | §3 255 / DIVISION_ID..ITEM_UOM lock | utils/shipmentMasterElectrodeEditLock.ts:26 isCellEditable (EDIT_EDITABLE_COLUMNS = shipment-master-electrode.constants.ts:68 9칸 외 전부 잠금) |  | 구현 |
| D00-3-003 | §3 256 / POST_OPER_LT..UOM_CONVERT_IN_TACT_TIME lock | utils/shipmentMasterElectrodeEditLock.ts:26 isCellEditable (EDIT_EDITABLE_COLUMNS = shipment-master-electrode.constants.ts:68 9칸 외 전부 잠금) |  | 구현 |
| D00-3-004 | §3 257 / BUILDING_DESC lock | utils/shipmentMasterElectrodeEditLock.ts:26 isCellEditable (EDIT_EDITABLE_COLUMNS = shipment-master-electrode.constants.ts:68 9칸 외 전부 잠금) |  | 구현 |
| D00-3-005 | §3 258 / CREATED_BY..LAST_UPDATE_DATE lock | utils/shipmentMasterElectrodeEditLock.ts:26 isCellEditable (EDIT_EDITABLE_COLUMNS = shipment-master-electrode.constants.ts:68 9칸 외 전부 잠금) |  | 구현 |
| D00-3-006 | §3 274 / 행 삭제(siMain) | ShipmentMasterElectrode.tsx:210 handleDelete (CRUD_TYPE='I' 행만 제거) |  | 구현 |
| D00-3-007 | §3 333 / Query(ds) — 조회결과 바인딩 | ShipmentMasterElectrode.tsx:99 useTabProcQuery(SHEETS.MAIN) -> :107 rows -> components/ShipmentMasterElectrodeGrid.tsx:186 DataGrid itemsSource |  | 구현 |
| D00-3-008 | §3 334 / 0..MaxColumnIndex 전체 lock(조회직후) | utils/shipmentMasterElectrodeEditLock.ts:31 isCellEditable — isEditMode=false(조회 직후)면 전 컬럼 편집 불가 |  | 구현 |
| D00-3-009 | §3 370 / 신규행 삽입 | ShipmentMasterElectrode.tsx:171 handleInsert -> :206 GridAction.addRow |  | 구현 |
| D00-3-010 | §3 374 / DIVISION_ID ← dtMyDivisionIns | shipment-master-electrode.constants.ts:42 COMBO.CELL_DIVISION='SSP0024_MY_DIVISION_CODE'(AS-IS dtMyDivisionIns 등가 — CODE 를 NAME 에도 복사해 코드만 표시) + 05_register §10 |  | 구현 |
| D00-3-011 | §3 375 / PLANT_SITE_ID ← dtPlantSiteByFactoryForSpread | shipment-master-electrode.constants.ts:44 COMBO.CELL_PLANT_SITE + 05_register §7-1 메타 cellCboDataTp |  | 구현 |
| D00-3-012 | §3 376 / POST_OPER ← dtElectrodePostOperCode | shipment-master-electrode.constants.ts:45 COMBO.CELL_POST_OPER + 05_register §7-3 |  | 구현 |
| D00-3-013 | §3 377 / BUILDING ← dtBuilding | shipment-master-electrode.constants.ts:48 COMBO.CELL_BUILDING + 05_register §9(ALL 포함 전용 콤보) |  | 구현 |
| D00-3-014 | §3 383 / insCell ← defaultData(신규행 기본값) | ShipmentMasterElectrode.tsx:181~205 newRow 기본값(DIVISION_ID = 확정 division) |  | 구현 |
| D00-3-015 | §3 385 / 신규행 PLANT_SITE_CODE lock | shipment-master-electrode.constants.ts:82 INSERT_EDITABLE_COLUMNS 미포함 = 신규행에서도 잠금 |  | 구현 |
| D00-3-016 | §3 386 / 신규행 MODEL_ID..ITEM_UOM lock | shipment-master-electrode.constants.ts:82 INSERT_EDITABLE_COLUMNS 미포함(MODEL_ID..ITEM_UOM) |  | 구현 |
| D00-3-017 | §3 387 / 신규행 POST_OPER_LT..UOM_CONVERT_IN_TACT_TIME lock | shipment-master-electrode.constants.ts:82 INSERT_EDITABLE_COLUMNS 미포함(POST_OPER_LT, UOM_CONVERT_IN_TACT_TIME) |  | 구현 |
| D00-3-018 | §3 388 / 신규행 BUILDING_DESC lock | shipment-master-electrode.constants.ts:82 INSERT_EDITABLE_COLUMNS 미포함(BUILDING_DESC) |  | 구현 |
| D00-3-019 | §3 389 / 신규행 CREATED_BY..LAST_UPDATE_DATE lock | shipment-master-electrode.constants.ts:82 INSERT_EDITABLE_COLUMNS 미포함(CREATED_BY..LAST_UPDATE_DATE) |  | 구현 |
| D00-3-020 | §3 570 / 팝업→DIVISION_ID | ShipmentMasterElectrode.tsx:239 handleMaterialCellSelected + shipment-master-electrode.constants.ts:108 POPUP_FILL_MAP (DIVISION_ID) |  | 구현 |
| D00-3-021 | §3 571 / 팝업→PLANT_SITE_CODE | ShipmentMasterElectrode.tsx:239 handleMaterialCellSelected + shipment-master-electrode.constants.ts:108 POPUP_FILL_MAP (PLANT_SITE_CODE) |  | 구현 |
| D00-3-022 | §3 572 / 팝업→PLANT_SITE_ID(=PlantSiteCode) | ShipmentMasterElectrode.tsx:239 handleMaterialCellSelected + shipment-master-electrode.constants.ts:108 POPUP_FILL_MAP (PLANT_SITE_ID(=PlantSiteCode)) — PLANT_SITE_ID 는 shipment-master-electrode.constants.ts:112 에서 팝업 PLANT_SITE_CODE 를 받도록 교정(G6) |  | 구현 |
| D00-3-023 | §3 573 / 팝업→MATERIAL_ID | ShipmentMasterElectrode.tsx:239 handleMaterialCellSelected + shipment-master-electrode.constants.ts:108 POPUP_FILL_MAP (MATERIAL_ID) |  | 구현 |
| D00-3-024 | §3 574 / 팝업→MODEL_ID | ShipmentMasterElectrode.tsx:239 handleMaterialCellSelected + shipment-master-electrode.constants.ts:108 POPUP_FILL_MAP (MODEL_ID) |  | 구현 |
| D00-3-025 | §3 575 / 팝업→CELL_TYPE | ShipmentMasterElectrode.tsx:239 handleMaterialCellSelected + shipment-master-electrode.constants.ts:108 POPUP_FILL_MAP (CELL_TYPE) |  | 구현 |
| D00-3-026 | §3 576 / 팝업→NICK_NAME | ShipmentMasterElectrode.tsx:239 handleMaterialCellSelected + shipment-master-electrode.constants.ts:108 POPUP_FILL_MAP (NICK_NAME) |  | 구현 |
| D00-3-027 | §3 577 / 팝업→ELECTRODE_TYPE | ShipmentMasterElectrode.tsx:239 handleMaterialCellSelected + shipment-master-electrode.constants.ts:108 POPUP_FILL_MAP (ELECTRODE_TYPE) |  | 구현 |
| D00-3-028 | §3 578 / 팝업→ITEM_UOM | ShipmentMasterElectrode.tsx:239 handleMaterialCellSelected + shipment-master-electrode.constants.ts:108 POPUP_FILL_MAP (ITEM_UOM) |  | 구현 |
| D00-3-029 | §3 579 / 팝업→UOM_CONVERT_IN_TACT_TIME | ShipmentMasterElectrode.tsx:239 handleMaterialCellSelected + shipment-master-electrode.constants.ts:108 POPUP_FILL_MAP (UOM_CONVERT_IN_TACT_TIME) |  | 구현 |
| D00-3-030 | §3 605 / BUILDING_DESC ← BUILDING(파생, ComboSelChange) | components/ShipmentMasterElectrodeGrid.tsx:135~139 applyDerivations BUILDING -> BUILDING_DESC(콤보 표시값 FACTORY_NAME) |  | 구현 |
| D00-3-031 | §3 623 / POST_OPER_LT ← sOperLT(파생) | components/ShipmentMasterElectrodeGrid.tsx:131~134 applyDerivations POST_OPER -> POST_OPER_LT(lookup SEGMENT5) |  | 구현 |
| D00-3-032 | §3 630 / PlantSite 변경 시 PLANT_SITE_CODE="" 클리어 | components/ShipmentMasterElectrodeGrid.tsx:124 applyDerivations + shipment-master-electrode.constants.ts:122 DIVISION_CASCADE_CLEAR |  | 구현 |
| D00-3-033 | §3 631 / PLANT_SITE_ID="" 클리어 | components/ShipmentMasterElectrodeGrid.tsx:124 applyDerivations + shipment-master-electrode.constants.ts:122 DIVISION_CASCADE_CLEAR |  | 구현 |
| D00-3-034 | §3 632 / MATERIAL_ID="" 클리어 | components/ShipmentMasterElectrodeGrid.tsx:124 applyDerivations + shipment-master-electrode.constants.ts:122 DIVISION_CASCADE_CLEAR |  | 구현 |
| D00-3-035 | §3 633 / MODEL_ID="" 클리어 | components/ShipmentMasterElectrodeGrid.tsx:124 applyDerivations + shipment-master-electrode.constants.ts:122 DIVISION_CASCADE_CLEAR |  | 구현 |
| D00-3-036 | §3 634 / CELL_TYPE="" 클리어 | components/ShipmentMasterElectrodeGrid.tsx:124 applyDerivations + shipment-master-electrode.constants.ts:122 DIVISION_CASCADE_CLEAR |  | 구현 |
| D00-3-037 | §3 635 / NICK_NAME="" 클리어 | components/ShipmentMasterElectrodeGrid.tsx:124 applyDerivations + shipment-master-electrode.constants.ts:122 DIVISION_CASCADE_CLEAR |  | 구현 |
| D00-3-038 | §3 636 / ELECTRODE_TYPE="" 클리어 | components/ShipmentMasterElectrodeGrid.tsx:124 applyDerivations + shipment-master-electrode.constants.ts:122 DIVISION_CASCADE_CLEAR |  | 구현 |
| D00-3-039 | §3 640 / PLANT_SITE_CODE ← PLANT_SITE_ID | components/ShipmentMasterElectrodeGrid.tsx:129 applyDerivations PLANT_SITE_ID -> PLANT_SITE_CODE 동기 |  | 구현 |
| D00-3-040 | §3 681 / (Paste)PLANT_SITE_CODE="" 클리어 | components/ShipmentMasterElectrodeGrid.tsx:121 pastingCell 게이트(editLock 재지정 — 공용 defaultEditHandler 가 INPUT_TP_CD='S' 로 전건 취소하는 것을 되살림) -> :175 pastedCell -> applyDerivations(:147) + shipment-master-electrode.constants.ts:122 DIVISION_CASCADE_CLEAR |  | 구현 |
| D00-3-041 | §3 682 / (Paste)PLANT_SITE_ID="" 클리어 | components/ShipmentMasterElectrodeGrid.tsx:121 pastingCell 게이트(editLock 재지정 — 공용 defaultEditHandler 가 INPUT_TP_CD='S' 로 전건 취소하는 것을 되살림) -> :175 pastedCell -> applyDerivations(:147) + shipment-master-electrode.constants.ts:122 DIVISION_CASCADE_CLEAR |  | 구현 |
| D00-3-042 | §3 683 / (Paste)MATERIAL_ID="" 클리어 | components/ShipmentMasterElectrodeGrid.tsx:121 pastingCell 게이트(editLock 재지정 — 공용 defaultEditHandler 가 INPUT_TP_CD='S' 로 전건 취소하는 것을 되살림) -> :175 pastedCell -> applyDerivations(:147) + shipment-master-electrode.constants.ts:122 DIVISION_CASCADE_CLEAR |  | 구현 |
| D00-3-043 | §3 684 / (Paste)MODEL_ID="" 클리어 | components/ShipmentMasterElectrodeGrid.tsx:121 pastingCell 게이트(editLock 재지정 — 공용 defaultEditHandler 가 INPUT_TP_CD='S' 로 전건 취소하는 것을 되살림) -> :175 pastedCell -> applyDerivations(:147) + shipment-master-electrode.constants.ts:122 DIVISION_CASCADE_CLEAR |  | 구현 |
| D00-3-044 | §3 685 / (Paste)CELL_TYPE="" 클리어 | components/ShipmentMasterElectrodeGrid.tsx:121 pastingCell 게이트(editLock 재지정 — 공용 defaultEditHandler 가 INPUT_TP_CD='S' 로 전건 취소하는 것을 되살림) -> :175 pastedCell -> applyDerivations(:147) + shipment-master-electrode.constants.ts:122 DIVISION_CASCADE_CLEAR |  | 구현 |
| D00-3-045 | §3 686 / (Paste)NICK_NAME="" 클리어 | components/ShipmentMasterElectrodeGrid.tsx:121 pastingCell 게이트(editLock 재지정 — 공용 defaultEditHandler 가 INPUT_TP_CD='S' 로 전건 취소하는 것을 되살림) -> :175 pastedCell -> applyDerivations(:147) + shipment-master-electrode.constants.ts:122 DIVISION_CASCADE_CLEAR |  | 구현 |
| D00-3-046 | §3 687 / (Paste)ELECTRODE_TYPE="" 클리어 | components/ShipmentMasterElectrodeGrid.tsx:121 pastingCell 게이트(editLock 재지정 — 공용 defaultEditHandler 가 INPUT_TP_CD='S' 로 전건 취소하는 것을 되살림) -> :175 pastedCell -> applyDerivations(:147) + shipment-master-electrode.constants.ts:122 DIVISION_CASCADE_CLEAR |  | 구현 |
| D00-3-047 | §3 700 / PLANT_SITE_ID ← dtEmpty(초기화) | packages/shared/.../DataGrid.tsx:1231~1254 clearStaleComboCellsHandler(부모 DIVISION_ID 변경 시 후보 밖 하위 콤보 셀 비움) — 구조적 대체 |  | 구현 |
| D00-3-048 | §3 705 / PLANT_SITE_CODE="" 클리어 | components/ShipmentMasterElectrodeGrid.tsx:129 PLANT_SITE_CODE 동기 + 위 clearStaleComboCells |  | 구현 |
| D00-3-049 | §3 717 / PLANT_SITE_CODE ← rPlantSiteId | components/ShipmentMasterElectrodeGrid.tsx:129 applyDerivations 가 pastedCell 에서도 PLANT_SITE_CODE 를 PLANT_SITE_ID 로 동기 |  | 구현 |
| D00-3-050 | §3 718 / PLANT_SITE_ID ← rPlantSiteId | components/ShipmentMasterElectrodeGrid.tsx:186 DataGrid dataMap 컬럼 — 후보에 있는 값만 셀에 반영(wijmo setCellData coerce) + components/ShipmentMasterElectrodeGrid.tsx:129 동기 |  | 구현 |
| D00-3-051 | §3 722 / PLANT_SITE_ID ← dtEmpty | packages/shared/.../DataGrid.tsx:1231~1254 clearStaleComboCellsHandler — 후보 밖 값은 반영되지 않거나 비워짐(AS-IS dtEmpty 등가) |  | 구현 |
| D00-3-052 | §3 852 / (nRow,nCol) ← dtRstDataTable(동적 셀 콤보) | 05_register §7 ATTRIBUTE2/ATTRIBUTE10='D' 행파라미터 재조회(useRowParamCombos) + components/ShipmentMasterElectrodeGrid.tsx:63 comboParams |  | 구현 |
| D00-4a-001 | §4a SSP.SSP0024_GET_SHIP_MASTER / FindData(316) | ShipmentMasterElectrode.tsx:99 useTabProcQuery(SHEETS.MAIN, GET) — PKG_SSP0024 미배포로 런타임은 convert-sp 후속 |  | 구현 |
| D00-4a-002 | §4a SSP.SSP0024_SAVE_SHIP_MASTER / SaveData(467) | ShipmentMasterElectrode.tsx:319 apiClient.post('/SSP0024/main/SAVE/call-proc') — 배선 완료, 런타임은 convert-sp 후속 |  | 구현 |
| D00-4a-003 | §4a SSP.SSP0002_GET_USER_INFO_LIST / GetSSPUserCheck(883) | hooks/useShipmentMasterElectrodeValidation.ts:28 checkEditPermission (USER_CHECK/call-proc) — 배선 완료, 런타임은 convert-sp 후속 |  | 구현 |
| D00-4b-001 | §4b Data.Common / MyDivision / dtMyDivision | 조회조건: components/ShipmentMasterElectrodeForm.tsx:49 comboId=MyDivision · 그리드 신규행 셀: shipment-master-electrode.constants.ts:42 COMBO.CELL_DIVISION(05_register §10) |  | 구현 |
| D00-4b-002 | §4b Data.Common / PlantSiteByFactoryEEOperation / dtPlantSiteByFactoryForSpread | shipment-master-electrode.constants.ts:44 COMBO.CELL_PLANT_SITE=PlantSiteByFactoryEEOperation + 05_register §7-1(A2=DIVISION_ID:divisionId, A10=D) |  | 구현 |
| D00-4b-003 | §4b Data.Common / ElectrodePostOperCode / dtElectrodePostOperCode | shipment-master-electrode.constants.ts:45 COMBO.CELL_POST_OPER + 05_register §7-3(A2=DIVISION_ID:segment1) |  | 구현 |
| D00-4b-004 | §4b Data.Common / DomExpTypeCode / dtDomExpTypeCode | shipment-master-electrode.constants.ts:47 COMBO.CELL_DOM_EXP=DomExpTypeCode(정적 lookup) |  | 구현 |
| D00-4b-005 | §4b Data.Common / BuildingForShipMasterElec / dtBuilding | shipment-master-electrode.constants.ts:48 COMBO.CELL_BUILDING=SSP0024_BUILDING_BY_PLANTSITE_ALL + 05_register §9 (AS-IS BuildingForShipMasterElec + ALL 선두행 등가) |  | 구현 |
| D00-4b-006 | §4b Data.Common / ElectrodePackageType / dtElectrodePackageType | shipment-master-electrode.constants.ts:46 COMBO.CELL_PACKAGE_TYPE=ElectrodePackageType(정적 lookup) |  | 구현 |
| D00-4b-007 | §4b Data.Common / PlantSiteByFactoryEEOperation / dtPlantSiteByFactory | components/ShipmentMasterElectrodeForm.tsx:46 plantSiteFilter(comboId=PlantSiteByFactoryEEOperation, divisionId cascade) |  | 구현 |
| D00-4d-001 | §4d EditButton / Edit | ShipmentMasterElectrode.tsx:124~141 마운트 effect 의 checkEditPermission — 2026-09-23 사용자 결정으로 Edit 버튼을 제거하고 권한체크를 화면 진입 시점으로 옮겼다. 통과 못 하면 isEditMode=false 로 편집 자체를 차단(editLock:31) |  | 구현 |
| D00-4d-002 | §4d DeleteButton / Delete | ShipmentMasterElectrode.tsx:212 handleDelete gridRef null 가드 |  | 구현 |
| D00-4d-003 | §4d DeleteButton / Delete |  | 단일 그리드(spdMain) 화면이라 대상 시트 특정이 불필요 — gridRef 가 곧 spdMain | 해당없음 |
| D00-4d-004 | §4d DeleteButton / Delete | ShipmentMasterElectrode.tsx:214 handleDelete selectedItems[0] 없음 가드 |  | 구현 |
| D00-4d-005 | §4d SpdMain_CellClick / - | components/ShipmentMasterElectrodeGrid.tsx:166 handleDblClick GridUtils.getRow 결과 없음 가드 |  | 구현 |
| D00-4d-006 | §4d SpdMain_CellClick / - | utils/shipmentMasterElectrodeEditLock.ts:31 isCellEditable isEditMode 게이트 — beginningEdit(components/ShipmentMasterElectrodeGrid.tsx:91)·pastingCell(components/ShipmentMasterElectrodeGrid.tsx:121) 양쪽에 적용 |  | 구현 |
| D00-4d-007 | §4d SpdMain_CellClick / - | components/ShipmentMasterElectrodeGrid.tsx:97~104 beginningEdit DIVISION_ID 공백 가드(MSG00097) + :169 handleDblClick |  | 구현 |
| D00-4d-008 | §4d SpdMain_CellClick / - | components/ShipmentMasterElectrodeGrid.tsx:167 handleDblClick isInsertRow 가드 |  | 구현 |
| D00-4d-009 | §4d SpdMain_CellClick / - | components/ShipmentMasterElectrodeGrid.tsx:165 handleDblClick isMaterialPopupColumn 가드 |  | 구현 |
| D00-4d-010 | §4d SpdMain_CellClick / - | components/ShipmentMasterElectrodeGrid.tsx:175 handleDblClick PLANT_SITE_CODE 공백 가드(MSG00429) |  | 구현 |
| D00-4d-011 | §4d SpdMain_ComboSelChange / - | components/ShipmentMasterElectrodeGrid.tsx:110 applyDerivations 의 row 없음 가드 |  | 구현 |
| D00-4d-012 | §4d SpdMain_KeyPress / - | utils/shipmentMasterElectrodeEditLock.ts:37 isInlineEditable — 잠긴 셀은 beginningEdit 에서 취소 |  | 구현 |
| D00-4d-013 | §4d SpdMain_KeyPress / - | utils/shipmentMasterElectrodeEditLock.ts:19 isMaterialPopupColumn + :41 isInlineEditable(MATERIAL_ID 인라인 입력 차단) |  | 구현 |
| D00-4d-014 | §4d SpdMain_ClipboardPasted / - | components/ShipmentMasterElectrodeGrid.tsx:143 pastedCell -> applyDerivations(:110 row 가드) |  | 구현 |
| D00-4d-015 | §4d SpdMain_ClipboardPasted / - | components/ShipmentMasterElectrodeGrid.tsx:121 pastingCellHandler -> isCellEditable(isEditMode=false 면 전 셀 취소) |  | 구현 |
| D00-4e-001 | §4e MSG00251 / isOK == false | ShipmentMasterElectrode.tsx:132~140 거부(반환 0건)일 때만 MSG.EDIT_NO_PERMISSION(MSG01261) alert — available=false(PKG_SSP0002 미배포·호출실패)는 권한거부가 아니라 환경문제라 문구를 띄우지 않고 편집만 차단한다(false-success 방지) |  | 구현 |
| D00-4e-002 | §4e MSG00004 / Save 반환 Rows[0][0]=="S" | ShipmentMasterElectrode.tsx:331 setToast MSG.SAVE_SUCCESS(MSG00672) |  | 구현 |
| D00-4e-003 | §4e (없음) / Save 반환 Rows[0][0]=="N" | ShipmentMasterElectrode.tsx:324 res.status>=400 또는 data.code 비0 = 실패 분기(false-success 차단) |  | 구현 |
| D00-4e-004 | §4e MSG00006 / Save 반환 Rows[0][0]=="N" | ShipmentMasterElectrode.tsx:327 setAlert MSG.SAVE_FAIL + shipment-master-electrode.constants.ts:183 MSG00003(실측 확정) |  | 구현 |
| D00-4e-005 | §4e MSG00093 / IsNullOrEmpty(sDivisionId) && col!=DIVISION_ID | components/ShipmentMasterElectrodeGrid.tsx:101 beginningEdit MSG.REQUIRE_DIVISION(MSG00097) |  | 구현 |
| D00-4e-006 | §4e MSG00093 / IsNullOrEmpty(sPlantSiteCode) | components/ShipmentMasterElectrodeGrid.tsx:178 handleDblClick MSG.REQUIRED_FIELD(MSG00429, 0=Plant Site) |  | 구현 |
| D00-4e-007 | §4e MSG00060 / !isPass | ShipmentMasterElectrode.tsx:266 findDuplicateKey -> :269 MSG.DUP_KEY(MSG00060) |  | 구현 |
| D00-4f-001 | §4f ProgressForm / Show | ShipmentMasterElectrode.tsx:427 ProgressIndicator(open=isFetching) — 조회 중 로딩(AS-IS ProgressForm cs:291,298,349 등가) / 팝업은 components/modals/ItemByDivisionModal.tsx:196 ProgressIndicator |  | 구현 |
| D00-4f-002 | §4f SSP0024_ItembyDivisionPopup / ShowDialog | ShipmentMasterElectrode.tsx:474 ItemByDivisionModal(callFromCell, 행 division/plantSiteCode/materialId 선조회) + :254 handleMaterialCellDblClick |  | 구현 |
| D00-4f-003 | §4f SSP0024_ItembyDivisionPopup / ShowDialog | ShipmentMasterElectrode.tsx:435 ItemByDivisionModal(조회조건 Material) |  | 구현 |
| D00-4f-004 | §4f SSP0024_ItembyDivisionPopup / ShowDialog | ShipmentMasterElectrode.tsx:448 ItemByDivisionModal(조회조건 Model) |  | 구현 |

## CRUD·모달 매트릭스 (2026-08-07 축 — MAIN UI 와 모달의 CRUD 누락 0)

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| MODAL:ItemByDivisionModal | FE 실존 모달 (components/modals/ItemByDivisionModal.tsx) — 분석 md 근거 확인 필요(FE 단독이면 사유 기입) | components/modals/ItemByDivisionModal.tsx:60 SSP0024 전용 모달 — AS-IS 팝업 노출 10컬럼 동일(:47~58), 결과 1건 자동확정·닫기(:107~118, AS-IS popup cs:284~298), Division/Plant Site 읽기전용(AS-IS Enabled=false popup cs:190~191) |  | 구현 |
| MODAL:ShowDialog | AS-IS 팝업 (분석 md) — TO-BE 모달 구현 위치 기입 의무 | AS-IS SSP0024_ItembyDivisionPopup 3경로 전부 이 모달로 대응 — ShipmentMasterElectrode.tsx:435(Material) / :448(Model) / :461(MATERIAL 셀) |  | 구현 |

## UI 공통(통합테스트) 체크 축 (2026-08-12 — 전 화면 상시 6항목)

> 원천: `Doc/단위테스트_보완대상/통합테스트 사전점검_1st_20260806_공유용.xlsx` 구분='Common' 6행.
> 화면 분석 md 에 없는 전 UI 공통 요구 — --check 가 부재 행을 FAIL 처리한다.

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| COMMON:UC-01 | 필터링 상태에서 신규행 Insert 시 필터를 **유지한 채** 추가 행이 보이도록 (keepRowVisibleUnderFilter — 필터 clear 금지, 1st 행3 + 2026-08-14 공통 수정사항①) | ShipmentMasterElectrode.tsx:206 GridAction.addRow -> addRowSet(packages/foundation/src/utils/gridAction.ts:836 keepRowVisibleUnderFilter 내장) — 필터 유지한 채 신규행 노출 |  | 구현 |
| COMMON:UC-02 | 데이터 수정 중 다른 데이터 조회 시도 = '수정 중인 데이터가 있습니다. 새로 조회하시겠습니까?' confirm (MSG00703 — 1st 행4) | 공용 가드 위임 — SearchArea 조회 버튼(components/ShipmentMasterElectrodeForm.tsx:78)과 SubTitle F5(ShipmentMasterElectrode.tsx:397)가 confirmIfDirtyKey('search')로 감싸 confirm 처리(packages/shared/src/components/organisms/search-area/SearchArea.tsx:115 and sub-title/SubTitle.tsx:198). 화면이 중복 검사하면 팝업이 2연속으로 뜬다(mkt-fcst 선례) |  | 구현 |
| COMMON:UC-03 | 컬럼 추가/제외(Column/Measure 설정) 적용 시 기존 조회 데이터 Reset 후 재조회 유도 (hook #132 §2-2 — 1st 행5) | ShipmentMasterElectrode.tsx:132 handleSearch 의 fetchStaticColumns() + useShipmentMasterElectrodeStore.ts:104 fetchStaticColumns(mount 및 Search 마다 admin 컬럼메타 재적용 후 재조회) |  | 구현 |
| COMMON:UC-04 | CRUD 완료 알림 = Alert 아닌 하단 중앙 Toast 후 자동 소멸 (LGES WDG 표준·hook #132 §3 — 1st 행6) | ShipmentMasterElectrode.tsx:330 setToast(type='success') — CRUD 완료는 alert 아닌 하단 Toast |  | 구현 |
| COMMON:UC-05 | Excel Download 시 콤보 컬럼 데이터가 Code 아닌 Name 으로 출력 (gridAction dataMap 승계 — 1st 행7) | ShipmentMasterElectrode.tsx:397~404 SubTitle(excelFileName, grid ref) — 공용 엑셀 내보내기가 dataMap 표시값(Name)을 승계 |  | 구현 |
| COMMON:UC-06 | Key-in 조회조건 = 콤마 구분 다중 입력 시 전건 조회 (1st 행8) | useShipmentMasterElectrodeStore.ts:57 multi() — materialId/modelId 를 콤마·개행 다건으로 분해해 콤마 결합(GET SP IN 조건) |  | 구현 |
| COMMON:UC-07 | 필터가 걸린 상태에서 재조회해도 조회되고 **필터도 그대로 적용** (rebindFilterColumns — 2026-08-14 공통 수정사항②) | 공용 DataGrid 위임 — packages/shared/src/components/organisms/data-grid/DataGrid.tsx:1479 rebindFilterColumns(재조회 후 필터-컬럼 재연결) |  | 구현 |

## 1. 진입점(entryPoints 12) → TO-BE

| AS-IS | action | TO-BE |
|---|---|---|
| FindButton (cs:230) | Search | `handleSearch` → `setFilter()` → `useTabProcQuery`(GET SSP0024_GET_SHIP_MASTER) |
| InsertButton (cs:235) | Insert | `handleInsert` → Edit 모드 선행 가드(AS-IS `IsLock==false` cs:365) → `GridAction.addRow`(신규행 'I', 확정 division) |
| EditButton (cs:240) | Edit | **버튼 없음**(2026-09-23 사용자 결정 — 진입이 곧 편집 모드). AS-IS 가 Edit 클릭 시 하던 `GetSSPUserCheck`(SSP0002)는 마운트 effect 로 이동(`ShipmentMasterElectrode.tsx:124~141`), 실패 시 편집 차단 |
| DeleteButton (cs:262) | Delete | `handleDelete` (신규행 'I'만 제거) |
| SaveButton (cs:280) | Save | `handleSave` → Edit 모드 선행 가드(cs:397) → `findMissingRequired` → `saveWithValidation` → `doSave`(16파라미터 ^-delim) |
| BtnMaterialId_Click (cs:730) | 팝업 | `onMaterialSearch` → `<ItemByDivisionModal callFromCell=false>` → `handleMaterialSelected` |
| BtnModelId_Click (cs:750) | 팝업 | `onModelSearch` → `<ItemByDivisionModal callFromCell=false>` → `handleModelSelected` |
| ClbDivision_SelectedIndexChanged (cs:771) | cascade | Form `onChange` → `set({divisionId, scmSiteIds:[], materialId:'', modelId:''})` → PlantSite 재조회 |
| SpdMain_CellClick (cs:530) | 셀팝업 | Grid `handleDblClick`(MATERIAL_ID) → `onMaterialCellDblClick` → 셀팝업 |
| SpdMain_ComboSelChange (cs:596) | 파생 | Grid `applyDerivations`(cellEditEnded) |
| SpdMain_KeyPress (cs:646) | 키가드 | Grid `beginningEdit`(MATERIAL_ID 인라인 편집 취소 = 키입력 차단) |
| SpdMain_ClipboardPasted (cs:659) | 붙여넣기 | Grid `pastedCell` → `applyDerivations` |

## 2. validations(7) → TO-BE (convert-core §2.1 #11)

| # | msgId(AS-IS) | 조건 | TO-BE 코드 | TO-BE MSG(Hook #114 역조회) |
|---|---|---|---|---|
| 1 | MSG00251 | Edit isOK==false (cs:248) | 마운트 권한체크 res.ok=false → alert(`ShipmentMasterElectrode.tsx:132~140`) | **MSG01261** "This user does not have permission to the SSP Planner. User ID : {0}" (MSG00251 은 TO-BE 미존재 — gap-resolve iter-1 G1 실측) |
| 2 | MSG00004 | Save 반환 "S" (cs:501) | `doSave` 성공 분기 | 성공은 **MSG00672** "{0} data saved." (AS-IS MSG00004≠TO-BE, Hook #114) |
| 3 | (없음) | Save 반환 "N" 분기 (cs:513) | `doSave` false-success 분기 | — |
| 4 | MSG00006 | Save 반환 "N" (cs:517) | `doSave` 실패 alert | **MSG00003** "Failed to save." (MSG00006 은 TO-BE 미존재 — G2 실측) |
| 5 | MSG00093 | Division 공백 셀편집 차단 (cs:544) | Grid `handleDblClick` division 가드 | MSG00097 "Please select Division." |
| 6 | MSG00093 | PlantSite 공백 셀편집 차단 (cs:558) | Grid `handleDblClick` plantSiteCode 가드 | MSG00429 "{0} value is required." (0=Plant Site) |
| 7 | MSG00060 | CheckValidation 중복 (cs:807) | `doSave` `findDuplicateKey` | MSG00060 "Duplicate key exists." |

## 3. buttonGuards(15) → TO-BE

| # | method | 조건 | TO-BE |
|---|---|---|---|
| 1 | EditButton | isOK==false (cs:243) | 마운트 권한체크 실패 시 `isEditMode=false` → editLock 이 전 셀 편집 차단 |
| 2 | DeleteButton | fps!=null (cs:264) | `handleDelete` `gridRef.current` 가드 |
| 3 | DeleteButton | fps.Name=='spdMain' (cs:266) | 단일 그리드 — 대상 고정(암묵) |
| 4 | DeleteButton | ActiveRow==null (cs:269) | `handleDelete` `selectedItems[0]` 가드 |
| 5 | SpdMain_CellClick | Rows.Count<=0 (cs:532) | `handleDblClick` `getRow` 가드 |
| 6 | SpdMain_CellClick | IsLock==false (cs:535) | `beginningEdit` editLock(뷰 모드=전잠금, 신규행 포함 — G4) |
| 7 | SpdMain_CellClick | Division 공백 (cs:541) | `beginningEdit` division 가드(편집 가능 셀 전건, MSG00097) + `handleDblClick` — G7 |
| 8 | SpdMain_CellClick | FlagI 신규행 (cs:548) | `handleDblClick` `isInsertRow` 가드 |
| 9 | SpdMain_CellClick | col==MATERIAL_ID (cs:553) | `handleDblClick` `isMaterialPopupColumn` |
| 10 | SpdMain_CellClick | PlantSiteCode 공백 (cs:555) | `handleDblClick` plantSiteCode 가드(MSG00429) |
| 11 | SpdMain_ComboSelChange | Rows.Count<=0 (cs:598) | `applyDerivations` row 가드 |
| 12 | SpdMain_KeyPress | !ActiveCell.Locked (cs:648) | `beginningEdit` editLock |
| 13 | SpdMain_KeyPress | col==MATERIAL_ID (cs:650) | `beginningEdit` MATERIAL_ID 인라인 편집 취소(키입력 차단) |
| 14 | SpdMain_ClipboardPasted | Rows.Count<=0 (cs:661) | `pastedCell`→`applyDerivations` row 가드 |
| 15 | SpdMain_ClipboardPasted | IsLock==true (cs:664) | `beginningEdit` editLock(붙여넣기 대상 셀도 편집가능해야 통과) |

## 4. gridSignals(52) → TO-BE

### lock(12) — 조회직후 전잠금 / Edit·Insert 지정칸 (design 03 §3.1)
- Query 후 LockColumn(334) / SwitchLock(253) / LockColumn(255~258) / LockRange(385~389)
  → TO-BE: `utils/shipmentMasterElectrodeEditLock.ts` `isCellEditable`(모드×행상태) + Grid `beginningEdit`.
  뷰 모드(isEditMode=false)=전잠금 / Edit 모드=기존행 EDIT_EDITABLE 9칸 / 신규행=INSERT_EDITABLE.

### cellType(6) — 셀 콤보 세팅 (design 03 §3.3)
- SetCellTypeCombo DIVISION_ID←dtMyDivisionIns(374) → 신규행 전용 콤보 = admin 메타 attribute9=MyDivision(05_register.sql).
- PLANT_SITE_ID←dtPlantSiteByFactoryForSpread(375) / POST_OPER←dtElectrodePostOperCode(376) / BUILDING←dtBuilding(377)
  → admin 메타 cellCboDataTp(PlantByDivisionOperation/ElectrodePostOperCode/BuildingByPlantSite), 공용 DataGrid 자동 배선.
- PLANT_SITE_ID←dtEmpty(700) → 신규행 division 클리어 시 종속 클리어(DIVISION_CASCADE_CLEAR).
- SetCellCombo (nRow,nCol)←dtRstDataTable(852) → admin 메타 PARAM10='D' 행조합 재조회(useRowParamCombos).

### value(32) — 파생·클리어 (design 03 §3.2)
- 팝업→10칸 일괄(570~579) → `handleMaterialCellSelected`(POPUP_FILL_MAP).
- BUILDING_DESC←BUILDING(605) → `applyDerivations` BUILDING→BUILDING_DESC(콤보 NAME).
- POST_OPER_LT←SEGMENT5(623) → `applyDerivations` POST_OPER→POST_OPER_LT(lookup ELECTRODE_POST_OPER_CODE).
- DIVISION 변경 종속 클리어(630~636) → `applyDerivations` DIVISION_ID→DIVISION_CASCADE_CLEAR(7칸).
- PLANT_SITE_CODE←PLANT_SITE_ID(640) → `applyDerivations` PLANT_SITE_ID→PLANT_SITE_CODE 동기.
- Paste 종속 클리어(681~687) / PlantSite 재세팅(705~722) → `pastedCell`→`applyDerivations` 동일 경로.

### dataSource(1) / other(2)
- Query(ds)(333) → `useTabProcQuery`(GET) 결과 바인딩.
- Delete(274) → `handleDelete`(신규행 'I'만). Insert(370) → `handleInsert`.

## 5. 콤보(comboCalls 7) → TO-BE (design 02 §2 / 03 §1.1, convert-core §2.6)

| AS-IS code | boundControl | TO-BE |
|---|---|---|
| MyDivision (cs:37) | cboDivision | Form `useTabComboQueries({comboId:'MyDivision', mnuId})` (ATTRIBUTE3<>'EE' CMBO 내장) |
| PlantSiteByFactoryEEOperation (cs:191) | cboPlantSite | Form `useTabComboQueries({comboId:'PlantSiteByFactoryEEOperation', mnuId, divisionId})` cascade |
| PlantSiteByFactoryEEOperation "40,81,82,81_UC" (셀, cs:41) | 그리드 PLANT_SITE_ID | admin 메타 cellCboDataTp=PlantSiteByFactoryEEOperation + A2=DIVISION_ID:divisionId/A10=D (05_register §7-1) |
| ElectrodePostOperCode (셀, cs:49) | 그리드 POST_OPER | admin 메타 cellCboDataTp + A2=DIVISION_ID:segment1 |
| DomExpTypeCode (셀, cs:51) | 그리드 DOM_EXP_TYPE_CODE | admin 메타 cellCboDataTp(정적) |
| **BuildingForShipMasterElec** (셀, cs:52) + 'ALL' 선두행(cs:155~159, 843~850) | 그리드 BUILDING | admin 메타 cellCboDataTp=**SSP0024_BUILDING_BY_PLANTSITE_ALL**(BuildingByPlantSite + ALL, 05_register §9 — gap-resolve iter-1 G9) |
| ElectrodePackageType (셀, cs:55) | 그리드 PACKAGE_TYPE_CODE | admin 메타 cellCboDataTp(정적) |

## 6. 저장(SAVE 16파라미터) → TO-BE (design 03 §4.3)

`doSave` acc(^-delim): activeFlag(CRUD_TYPE), divisionId, plantSiteCode, materialId, electrodePostOperCode(POST_OPER),
pcRollLength, packageTypeCode, steelcratePerCut, boxPerCut, steelrackPerCut, domExpTypeCode,
**factoryId(= 행 BUILDING 값 = 셀콤보 CODE = FACTORY_ID)**, remarks + createId(세션 단일). 표시전용 10칸 미전송.

- AS-IS 는 CODE=FACTORY_NAME/NAME=FACTORY_ID 콤보라 `GetSelectedListName(dt, GetValue(BUILDING), "NAME")`
  = FACTORY_ID 를 보냈다(cs:433,446). TO-BE 콤보는 CODE=FACTORY_ID 라 셀 값이 곧 FACTORY_ID.
  실저장 컬럼 `SSP_MST_SHIP_MASTER_EE.FACTORY_ID` 실데이터도 E2/E3/E4/ALL(FACTORY_ID 형태) — gap-resolve iter-1 G3.

## 7. 미완/확인 필요 (정직 보고 — convert-core §4.3)

- **SP 실행체인 미배포**: PKG_SSP0024(GET/SAVE/팝업)·PKG_SSP0002(권한) all_objects 0건(2026-09-23 재실측도 0행) → 조회/저장/권한/팝업 런타임 미완. FE 배선 완비, 실행은 convert-sp 후속.
- **GET/팝업 SP 반환 계약(convert-sp 로 전달)**: GET 의 `BUILDING` 은 **FACTORY_ID**, `PLANT_SITE_CODE`·`PLANT_SITE_ID` 는 **SCM_SITE_ID** 를 반환해야 셀콤보 DataMap 과 저장 파라미터가 맞는다. 팝업(`P_SSP0024_GET_ITEM_BY_DIVISION_POPUP`)의 `PLANT_SITE_CODE` 도 SCM_SITE_ID(AS-IS 는 이 값을 그리드 두 칸에 똑같이 넣는다 cs:571~572).
- **셀콤보 PARAM2/9/10**: 05_register §7 적용 완료 — 2026-09-23 재조회로 PLANT_SITE_ID/POST_OPER/BUILDING/DIVISION_ID 4건 배선 확인.
- **@operationGroup 등가**: PLANT_SITE_ID 콤보를 `PlantSiteByFactoryEEOperation`(OPERATION_GROUP='E'+FACTORY_SN 조인 내장)로 교체해 의존 제거(iter-2 G2).
