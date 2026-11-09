# SSP0024 — To-Be Fact Pack 요약

- page_key: `shipping/shipment-master-electrode` · feature: shipping · As-is Fact Pack 있음
- 파일 14 · 엔드포인트 호출 10 (미해결 1, 주석 속 0) · 이벤트 24 · 컴포넌트 사용 43 · 하드코딩 컬럼 11 · 메시지 21
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 11건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/shipping/src/pages/shipment-master-electrode/components/modals/ElectrodeItemByDivisionModal.module.scss | component | 26 |
| features/shipping/src/pages/shipment-master-electrode/components/modals/ElectrodeItemByDivisionModal.tsx | component | 291 |
| features/shipping/src/pages/shipment-master-electrode/components/ShipmentMasterElectrodeForm.tsx | component | 237 |
| features/shipping/src/pages/shipment-master-electrode/components/ShipmentMasterElectrodeGrid.tsx | component | 338 |
| features/shipping/src/pages/shipment-master-electrode/hooks/useShipmentMasterElectrodeValidation.ts | hook | 67 |
| features/shipping/src/pages/shipment-master-electrode/index.ts | index | 2 |
| features/shipping/src/pages/shipment-master-electrode/shipment-master-electrode.constants.ts | constants | 230 |
| features/shipping/src/pages/shipment-master-electrode/shipment-master-electrode.types.ts | types | 33 |
| features/shipping/src/pages/shipment-master-electrode/ShipmentMasterElectrode.module.scss | style | 6 |
| features/shipping/src/pages/shipment-master-electrode/ShipmentMasterElectrode.tsx | page | 483 |
| features/shipping/src/pages/shipment-master-electrode/useShipmentMasterElectrodeStore.ts | store | 184 |
| features/shipping/src/pages/shipment-master-electrode/utils/shipmentMasterElectrodeColumns.ts | util | 42 |
| features/shipping/src/pages/shipment-master-electrode/utils/shipmentMasterElectrodeEditLock.ts | util | 42 |
| features/shipping/src/pages/shipment-master-electrode/__asis-mapping__.md | mapping | 256 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueries) | hook | 2 | Y | ElectrodeItemByDivisionModal.tsx:85 ShipmentMasterElectrodeForm.tsx:51 |
| SSP0024/popup//call-proc | hook | 1 | Y | ElectrodeItemByDivisionModal.tsx:117 |
| (useTabLookupQueries) | hook | 1 | Y | ShipmentMasterElectrodeGrid.tsx:94 |
| {?{comboId:COMBO.CELL_PLANT_SITE,divisionId}} | http | 1 | N | ShipmentMasterElectrodeGrid.tsx:228 |
| /SSP0024/main/USER_CHECK/call-proc | http | 1 | Y | useShipmentMasterElectrodeValidation.ts:28 |
| SSP0024/main//call-proc | hook | 1 | Y | ShipmentMasterElectrode.tsx:106 |
| /SSP0024/main/SAVE/call-proc | http | 1 | Y | ShipmentMasterElectrode.tsx:314 |
| /admin/menu/SSP0024/column | http | 1 | Y | useShipmentMasterElectrodeStore.ts:129 |
| /admin/menu/SSP0024/search-conditions | http | 1 | Y | useShipmentMasterElectrodeStore.ts:159 |

## 3. procedures.d.ts 등재 시트
(없음)

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| SearchArea | onSearch | handleSearch | jsx | features/shipping/src/pages/shipment-master-electrode/components/modals/ElectrodeItemByDivisionModal.tsx | 200 |
| InputField | onChange | <arrow> setMaterialId | jsx | features/shipping/src/pages/shipment-master-electrode/components/modals/ElectrodeItemByDivisionModal.tsx | 239 |
| InputField | onKeyDown | <arrow> handleSearch | jsx | features/shipping/src/pages/shipment-master-electrode/components/modals/ElectrodeItemByDivisionModal.tsx | 240 |
| Button | onClick | handleSubmit | jsx | features/shipping/src/pages/shipment-master-electrode/components/modals/ElectrodeItemByDivisionModal.tsx | 276 |
| Button | onClick | modalClose | jsx | features/shipping/src/pages/shipment-master-electrode/components/modals/ElectrodeItemByDivisionModal.tsx | 283 |
| SearchArea | onSearch | onSearch | jsx | features/shipping/src/pages/shipment-master-electrode/components/ShipmentMasterElectrodeForm.tsx | 103 |
| CustomDropdown | onChange | <arrow> String,confirmIfDirtyKey(tabDirtyKey(tabId),'search').then,confirmIfDirtyKey,tabDirtyKey,setDivision | jsx | features/shipping/src/pages/shipment-master-electrode/components/ShipmentMasterElectrodeForm.tsx | 125 |
| CustomDropdown | onChange | <arrow> set,String(picked??'').split(',').filter,String(picked??'').split,String | jsx | features/shipping/src/pages/shipment-master-electrode/components/ShipmentMasterElectrodeForm.tsx | 152 |
| InputField | onChange | <arrow> set | jsx | features/shipping/src/pages/shipment-master-electrode/components/ShipmentMasterElectrodeForm.tsx | 191 |
| Button | onClick | onMaterialSearch | jsx | features/shipping/src/pages/shipment-master-electrode/components/ShipmentMasterElectrodeForm.tsx | 187 |
| InputField | onChange | <arrow> set | jsx | features/shipping/src/pages/shipment-master-electrode/components/ShipmentMasterElectrodeForm.tsx | 227 |
| Button | onClick | onModelSearch | jsx | features/shipping/src/pages/shipment-master-electrode/components/ShipmentMasterElectrodeForm.tsx | 222 |
| g | beginningEdit | beginningEditHandler | addHandler | features/shipping/src/pages/shipment-master-electrode/components/ShipmentMasterElectrodeGrid.tsx | 137 |
| g | pastingCell | pastingCellHandler | addHandler | features/shipping/src/pages/shipment-master-electrode/components/ShipmentMasterElectrodeGrid.tsx | 155 |
| g | formatItem | formatItemHandler | addHandler | features/shipping/src/pages/shipment-master-electrode/components/ShipmentMasterElectrodeGrid.tsx | 170 |
| g | cellEditEnded | applyDerivations | addHandler | features/shipping/src/pages/shipment-master-electrode/components/ShipmentMasterElectrodeGrid.tsx | 258 |
| g | pastedCell | pastedCellHandler | addHandler | features/shipping/src/pages/shipment-master-electrode/components/ShipmentMasterElectrodeGrid.tsx | 259 |
| g.hostElement? | keydown | keyDownHandler | addEventListener | features/shipping/src/pages/shipment-master-electrode/components/ShipmentMasterElectrodeGrid.tsx | 276 |
| DataGrid | gotFocus | onFocus | jsx | features/shipping/src/pages/shipment-master-electrode/components/ShipmentMasterElectrodeGrid.tsx | 334 |
| ShipmentMasterElectrodeForm | onSearch | handleSearch | jsx | features/shipping/src/pages/shipment-master-electrode/ShipmentMasterElectrode.tsx | 387 |
| ShipmentMasterElectrodeForm | onMaterialSearch | <arrow> setOpenMaterial | jsx | features/shipping/src/pages/shipment-master-electrode/ShipmentMasterElectrode.tsx | 388 |
| ShipmentMasterElectrodeForm | onModelSearch | <arrow> setOpenModel | jsx | features/shipping/src/pages/shipment-master-electrode/ShipmentMasterElectrode.tsx | 389 |
| ShipmentMasterElectrodeGrid | onMaterialCellDblClick | handleMaterialCellDblClick | jsx | features/shipping/src/pages/shipment-master-electrode/ShipmentMasterElectrode.tsx | 428 |
| ShipmentMasterElectrodeGrid | onFocus | <arrow>  | jsx | features/shipping/src/pages/shipment-master-electrode/ShipmentMasterElectrode.tsx | 429 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Grid | 7 |
| FormItem | 7 |
| CustomDropdown | 4 |
| Button | 4 |
| InputField | 3 |
| SearchArea | 2 |
| ProgressIndicator | 2 |
| DataGrid | 2 |
| FunctionSearchIcon | 2 |
| MaterialByDivisionModal | 2 |
| CustomDialog | 1 |
| ResultArea | 1 |
| ControlConfirmIcon | 1 |
| MainTitle | 1 |
| ShipmentMasterElectrodeForm | 1 |
| SubTitle | 1 |
| ShipmentMasterElectrodeGrid | 1 |
| ElectrodeItemByDivisionModal | 1 |

## 6. 하드코딩 Grid 컬럼
| context | binding | header | width | visible | isReadOnly | dataType | via | file | line |
|---|---|---|---|---|---|---|---|---|---|
| POPUP_COLUMNS | DIVISION_ID | Division | 60 | true |  |  | meta-shape | features/shipping/src/pages/shipment-master-electrode/components/modals/ElectrodeItemByDivisionModal.tsx | 48 |
| POPUP_COLUMNS | PLANT_SITE_CODE | Plant Site Code | 80 | true |  |  | meta-shape | features/shipping/src/pages/shipment-master-electrode/components/modals/ElectrodeItemByDivisionModal.tsx | 49 |
| POPUP_COLUMNS | PLANT_SITE_ID | Plant Site | 80 | true |  |  | meta-shape | features/shipping/src/pages/shipment-master-electrode/components/modals/ElectrodeItemByDivisionModal.tsx | 50 |
| POPUP_COLUMNS | MATERIAL_ID | Material | 100 | true |  |  | meta-shape | features/shipping/src/pages/shipment-master-electrode/components/modals/ElectrodeItemByDivisionModal.tsx | 51 |
| POPUP_COLUMNS | MODEL_ID | Model | 150 | true |  |  | meta-shape | features/shipping/src/pages/shipment-master-electrode/components/modals/ElectrodeItemByDivisionModal.tsx | 52 |
| POPUP_COLUMNS | CELL_TYPE | Cell Type | 80 | true |  |  | meta-shape | features/shipping/src/pages/shipment-master-electrode/components/modals/ElectrodeItemByDivisionModal.tsx | 53 |
| POPUP_COLUMNS | NICK_NAME | Nick Name | 150 | true |  |  | meta-shape | features/shipping/src/pages/shipment-master-electrode/components/modals/ElectrodeItemByDivisionModal.tsx | 54 |
| POPUP_COLUMNS | ELECTRODE_TYPE | Electrode Type | 80 | true |  |  | meta-shape | features/shipping/src/pages/shipment-master-electrode/components/modals/ElectrodeItemByDivisionModal.tsx | 55 |
| POPUP_COLUMNS | ITEM_UOM | UOM | 60 | true |  |  | meta-shape | features/shipping/src/pages/shipment-master-electrode/components/modals/ElectrodeItemByDivisionModal.tsx | 56 |
| POPUP_COLUMNS | UOM_CONVERT_IN_TACT_TIME | Pancake (m/cell) | 120 | true |  |  | meta-shape | features/shipping/src/pages/shipment-master-electrode/components/modals/ElectrodeItemByDivisionModal.tsx | 57 |
| col | c.key | c.header | c.width ?? 100 | true |  |  | meta-map | features/shipping/src/pages/shipment-master-electrode/utils/shipmentMasterElectrodeColumns.ts | 20 |

## 7. 메시지 코드
| code | count |
|---|---|
| LBL00001 | 1 |
| LBL00005 | 1 |
| LBL00021 | 1 |
| LBL00767 | 1 |
| LBL00669 | 1 |
| LBL00618 | 1 |
| LBL00112 | 1 |
| LBL00664 | 1 |
| LBL00674 | 1 |
| LBL00343 | 1 |
| LBL00666 | 1 |
| LBL00716 | 1 |
| LBL00627 | 1 |
| MSG00672 | 1 |
| MSG00003 | 1 |
| MSG00004 | 1 |
| MSG00060 | 1 |
| MSG00097 | 1 |
| MSG00429 | 1 |
| MSG01261 | 1 |
| MSG00667 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: SSP0024(10), SSP0002(3), SSP0014(2), SSP0017(2), COM0008(1), SSP0200(1), SSP0025(1), SCP0020(1), SSP0015(1), DMF0020(1), SCP0124(1), SCP0025(1), SCP0053(1)
- SP/PKG: PKG_SSP0024(6), PKG_SSP0002(4), P_SSP0024_GET_ITEM_BY_DIVISION_POPUP(3), P_SSP0024_GET_SHIP_MASTER(2), P_SSP0024_SAVE_SHIP_MASTER(2), PR_GET_LOOKUP_INFO_LIST(1), SSP0002_GET_USER_INFO_LIST(1), P_SSP0002_GET_USER_INFO_LIST(1), P_MATERIAL_ID(1), P_MODEL_ID(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| code | 제거하고 기존행은 조용히 no-op 한다(AS-IS DeleteButton cs:272 guard return·표준 동일 — 메시지 없음). | features/shipping/src/pages/shipment-master-electrode/ShipmentMasterElectrode.tsx | 207 |

## 10. __asis-mapping__.md 상태
- 구현: 78
- 제외: 3
- 해당없음: 1
| design_id | summary | reason | status |
|---|---|---|---|
| D00-1-008 | §1 emptySpaceItem1 / EmptySpaceItem | WinForms 절대좌표 여백(emptySpaceItem) — MUI Grid size=3 자동배치로 대체, 이식 대상 아님(design 01 §1.1) | 제외 |
| D00-1-009 | §1 layoutControlGroup1 / LayoutControlGroup | Form.Controls 에 Add 되지 않는 죽은 컨테이너(Designer.cs:76~92 vs :500~505) — design 01 §1.1 이 이식 금지로 명시 | 제외 |
| D00-1-011 | §1 usrLayoutControl1 / UsrLayoutControl | 위 layoutControlGroup1 과 같은 미부착 컨테이너(Designer.cs:76~92) — 이식 금지 | 제외 |
| D00-1-023 | §1 components / Container | WinForms IContainer(비시각 컴포넌트 컨테이너) — React 대응 개념 없음 | 해당없음 |

