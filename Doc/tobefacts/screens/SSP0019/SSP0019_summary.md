# SSP0019 — To-Be Fact Pack 요약

- page_key: `shipping/shipment-change-history` · feature: shipping · As-is Fact Pack 있음
- 파일 12 · 엔드포인트 호출 6 (미해결 0, 주석 속 3) · 이벤트 21 · 컴포넌트 사용 67 · 하드코딩 컬럼 21 · 메시지 17
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 21건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/shipping/src/pages/shipment-change-history/components/modals/ShipmentPlanRequestModal.tsx | component | 209 |
| features/shipping/src/pages/shipment-change-history/components/ShipmentChangeHistoryForm.module.scss | component | 89 |
| features/shipping/src/pages/shipment-change-history/components/ShipmentChangeHistoryForm.tsx | component | 403 |
| features/shipping/src/pages/shipment-change-history/components/ShipmentChangeHistoryGrid.tsx | component | 183 |
| features/shipping/src/pages/shipment-change-history/index.ts | index | 2 |
| features/shipping/src/pages/shipment-change-history/shipment-change-history.constants.ts | constants | 209 |
| features/shipping/src/pages/shipment-change-history/shipment-change-history.types.ts | types | 25 |
| features/shipping/src/pages/shipment-change-history/ShipmentChangeHistory.module.scss | style | 24 |
| features/shipping/src/pages/shipment-change-history/ShipmentChangeHistory.tsx | page | 277 |
| features/shipping/src/pages/shipment-change-history/useShipmentChangeHistoryStore.ts | store | 218 |
| features/shipping/src/pages/shipment-change-history/utils/shipmentChangeHistoryColumns.ts | util | 72 |
| features/shipping/src/pages/shipment-change-history/__asis-mapping__.md | mapping | 181 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| /SSP0019/main/GET_REQ_DRAFTING/call-proc | http | 1 | Y | ShipmentPlanRequestModal.tsx:139 |
| (useTabComboQueries) | hook | 1 | Y | ShipmentChangeHistoryForm.tsx:70 |
| (useTabLookupQueries) | hook | 1 | Y | ShipmentChangeHistoryGrid.tsx:71 |
| SSP0019/main//call-proc | hook | 1 | Y | ShipmentChangeHistory.tsx:77 |
| /admin/menu/SSP0019/search-conditions | http | 1 | Y | useShipmentChangeHistoryStore.ts:172 |
| /admin/menu/SSP0019/column | http | 1 | Y | useShipmentChangeHistoryStore.ts:196 |

## 3. procedures.d.ts 등재 시트
(없음)

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| DataGrid | initialized | <arrow> Math.round,applyLeafHeaderHeight,grid.updatedLayout.addHandler | jsx | features/shipping/src/pages/shipment-change-history/components/modals/ShipmentPlanRequestModal.tsx | 182 |
| grid | updatedLayout | applyLeafHeaderHeight | addHandler | features/shipping/src/pages/shipment-change-history/components/modals/ShipmentPlanRequestModal.tsx | 191 |
| Button | onClick | modalClose | jsx | features/shipping/src/pages/shipment-change-history/components/modals/ShipmentPlanRequestModal.tsx | 201 |
| SearchArea | onSearch | onSearch | jsx | features/shipping/src/pages/shipment-change-history/components/ShipmentChangeHistoryForm.tsx | 135 |
| CustomDropdown | onChange | <arrow> handleDivisionChange,pickedToCsv | jsx | features/shipping/src/pages/shipment-change-history/components/ShipmentChangeHistoryForm.tsx | 154 |
| CustomDropdown | onChange | <arrow> set,splitMulti | jsx | features/shipping/src/pages/shipment-change-history/components/ShipmentChangeHistoryForm.tsx | 175 |
| CustomDropdown | onChange | <arrow> set,splitMulti | jsx | features/shipping/src/pages/shipment-change-history/components/ShipmentChangeHistoryForm.tsx | 196 |
| CustomDropdown | onChange | <arrow> set,splitMulti | jsx | features/shipping/src/pages/shipment-change-history/components/ShipmentChangeHistoryForm.tsx | 217 |
| Checkbox | onChange | <arrow> set | jsx | features/shipping/src/pages/shipment-change-history/components/ShipmentChangeHistoryForm.tsx | 236 |
| DatePickerCalendar | onChange | <arrow> set,date?.format | jsx | features/shipping/src/pages/shipment-change-history/components/ShipmentChangeHistoryForm.tsx | 261 |
| DatePickerCalendar | onChange | <arrow> set,date?.format | jsx | features/shipping/src/pages/shipment-change-history/components/ShipmentChangeHistoryForm.tsx | 278 |
| InputField | onChange | <arrow> set | jsx | features/shipping/src/pages/shipment-change-history/components/ShipmentChangeHistoryForm.tsx | 321 |
| Button | onClick | onOpenModelPopup | jsx | features/shipping/src/pages/shipment-change-history/components/ShipmentChangeHistoryForm.tsx | 311 |
| InputField | onChange | <arrow> set | jsx | features/shipping/src/pages/shipment-change-history/components/ShipmentChangeHistoryForm.tsx | 344 |
| InputField | onChange | <arrow> set | jsx | features/shipping/src/pages/shipment-change-history/components/ShipmentChangeHistoryForm.tsx | 370 |
| CustomDropdown | onChange | <arrow> set,splitMulti | jsx | features/shipping/src/pages/shipment-change-history/components/ShipmentChangeHistoryForm.tsx | 393 |
| g | formatItem | formatItemHandler | addHandler | features/shipping/src/pages/shipment-change-history/components/ShipmentChangeHistoryGrid.tsx | 140 |
| g.hostElement | click | clickHandler | addEventListener | features/shipping/src/pages/shipment-change-history/components/ShipmentChangeHistoryGrid.tsx | 154 |
| ShipmentChangeHistoryForm | onSearch | handleSearch | jsx | features/shipping/src/pages/shipment-change-history/ShipmentChangeHistory.tsx | 216 |
| ShipmentChangeHistoryForm | onOpenModelPopup | <arrow> setModelPopupOpen | jsx | features/shipping/src/pages/shipment-change-history/ShipmentChangeHistory.tsx | 217 |
| ShipmentChangeHistoryGrid | onRequestNoClick | setRequestNo | jsx | features/shipping/src/pages/shipment-change-history/ShipmentChangeHistory.tsx | 237 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Grid | 10 |
| FormItem | 9 |
| FLabel | 8 |
| FValue | 8 |
| Box | 7 |
| CustomDropdown | 5 |
| InputField | 3 |
| DataGrid | 2 |
| Button | 2 |
| DatePickerCalendar | 2 |
| CustomDialog | 1 |
| RequestForm | 1 |
| SearchArea | 1 |
| Checkbox | 1 |
| FunctionSearchIcon | 1 |
| MainTitle | 1 |
| ShipmentChangeHistoryForm | 1 |
| SubTitle | 1 |
| ShipmentChangeHistoryGrid | 1 |
| MaterialByDivisionModal | 1 |
| ShipmentPlanRequestModal | 1 |

## 6. 하드코딩 Grid 컬럼
| context | binding | header | width | visible | isReadOnly | dataType | via | file | line |
|---|---|---|---|---|---|---|---|---|---|
| DRAFTING_COLUMNS | ERP_SO_NO | SO No | 100 | true |  |  | meta-shape | features/shipping/src/pages/shipment-change-history/components/modals/ShipmentPlanRequestModal.tsx | 46 |
| DRAFTING_COLUMNS | PROJECT_NAME | Project Name | 110 | true |  |  | meta-shape | features/shipping/src/pages/shipment-change-history/components/modals/ShipmentPlanRequestModal.tsx | 47 |
| DRAFTING_COLUMNS | FCST_TYPE | FCST Type | 90 | true |  |  | meta-shape | features/shipping/src/pages/shipment-change-history/components/modals/ShipmentPlanRequestModal.tsx | 48 |
| DRAFTING_COLUMNS | ITEM_ID | Model | 100 | true |  |  | meta-shape | features/shipping/src/pages/shipment-change-history/components/modals/ShipmentPlanRequestModal.tsx | 49 |
| DRAFTING_COLUMNS | FROM_SITE | From Site | 70 | true |  |  | meta-shape | features/shipping/src/pages/shipment-change-history/components/modals/ShipmentPlanRequestModal.tsx | 50 |
| DRAFTING_COLUMNS | TO_SITE | To Site | 100 | true |  |  | meta-shape | features/shipping/src/pages/shipment-change-history/components/modals/ShipmentPlanRequestModal.tsx | 51 |
| DRAFTING_COLUMNS | INCOTERMS | Incoterms | 70 | true |  |  | meta-shape | features/shipping/src/pages/shipment-change-history/components/modals/ShipmentPlanRequestModal.tsx | 52 |
| DRAFTING_COLUMNS | LT_DAY | L/T(Day) | 65 | true |  |  | meta-shape | features/shipping/src/pages/shipment-change-history/components/modals/ShipmentPlanRequestModal.tsx | 54 |
| DRAFTING_COLUMNS | ETD | ETD | 85 | true |  |  | meta-shape | features/shipping/src/pages/shipment-change-history/components/modals/ShipmentPlanRequestModal.tsx | 55 |
| DRAFTING_COLUMNS | ETA | ETA | 85 | true |  |  | meta-shape | features/shipping/src/pages/shipment-change-history/components/modals/ShipmentPlanRequestModal.tsx | 56 |
| DRAFTING_COLUMNS | TRANSPORT_MODE | Trans Mode | 70 | true |  |  | meta-shape | features/shipping/src/pages/shipment-change-history/components/modals/ShipmentPlanRequestModal.tsx | 57 |
| DRAFTING_COLUMNS | SHIPMENT_DATE | Shipment Date | 95 | true |  |  | meta-shape | features/shipping/src/pages/shipment-change-history/components/modals/ShipmentPlanRequestModal.tsx | 58 |
| DRAFTING_COLUMNS | SHIPMENT_CONFIRM_QTY | Qty | 75 | true |  |  | meta-shape | features/shipping/src/pages/shipment-change-history/components/modals/ShipmentPlanRequestModal.tsx | 59 |
| DRAFTING_COLUMNS | NEW_LT_DAY | L/T(Day) | 65 | true |  |  | meta-shape | features/shipping/src/pages/shipment-change-history/components/modals/ShipmentPlanRequestModal.tsx | 61 |
| DRAFTING_COLUMNS | NEW_ETD | ETD | 85 | true |  |  | meta-shape | features/shipping/src/pages/shipment-change-history/components/modals/ShipmentPlanRequestModal.tsx | 62 |
| DRAFTING_COLUMNS | NEW_ETA | ETA | 85 | true |  |  | meta-shape | features/shipping/src/pages/shipment-change-history/components/modals/ShipmentPlanRequestModal.tsx | 63 |
| DRAFTING_COLUMNS | NEW_TRANSPORT_MODE | Trans Mode | 70 | true |  |  | meta-shape | features/shipping/src/pages/shipment-change-history/components/modals/ShipmentPlanRequestModal.tsx | 64 |
| DRAFTING_COLUMNS | NEW_SHIPMENT_DATE | Shipment Date | 95 | true |  |  | meta-shape | features/shipping/src/pages/shipment-change-history/components/modals/ShipmentPlanRequestModal.tsx | 65 |
| DRAFTING_COLUMNS | NEW_SHIPMENT_CONFIRM_QTY | Qty | 75 | true |  |  | meta-shape | features/shipping/src/pages/shipment-change-history/components/modals/ShipmentPlanRequestModal.tsx | 66 |
| DRAFTING_COLUMNS | CONFIRM_ID | Confirm ID | 110 | true |  |  | meta-shape | features/shipping/src/pages/shipment-change-history/components/modals/ShipmentPlanRequestModal.tsx | 68 |
| col | c.key | c.header | c.width | c.visible !== false |  |  | meta-map | features/shipping/src/pages/shipment-change-history/utils/shipmentChangeHistoryColumns.ts | 50 |

## 7. 메시지 코드
| code | count |
|---|---|
| LBL01107 | 1 |
| LBL01106 | 1 |
| LBL00627 | 1 |
| MSG00667 | 1 |
| MSG00108 | 1 |
| MSG01187 | 1 |
| LBL00001 | 1 |
| LBL00022 | 1 |
| LBL00023 | 1 |
| LBL00024 | 1 |
| LBL01221 | 1 |
| LBL01115 | 1 |
| LBL00618 | 1 |
| LBL01111 | 1 |
| LBL01063 | 1 |
| LBL01065 | 1 |
| LBL00112 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: SSP0019(12), SCM0002(8), SSP0012(7), SSP0003(6), SSP0015(3), SCP0033(1), SSP0005(1), COM0013(1)
- SP/PKG: PKG_SSP0019(4), P_SSP0003_GET_REQ_DRAFTING(3), P_SSP0003_GET_DRAFTING(3), P_SSP0019_GET_SHIPMENT_CHANGE_HISTORY(3), PKG_SSP0003(2), SSP0003_GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING(2), P_SCM0002_GET_MATERIAL_BY_DIVISION(2), P_DIVISION_ID(2), P_CHANGE_REQUEST_NO(1), P_LANGUAGE(1), PKG_SCM0002(1), SCM0002_GET_ITEM_BY_DIVISION_POPUP(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| endpoint | 셀콤보 dataMap 직접 fetch(design 03 §6-1) — lookupType 이 서로 달라 comboParams 단일값으로 못 실어 | features/shipping/src/pages/shipment-change-history/components/ShipmentChangeHistoryGrid.tsx | 68 |
| endpoint | 그리드 셀 콤보 lookupType 직접 fetch(useTabLookupQueries) — comboParams 단일값으로 못 푸는 2종(design 03 §6-1). | features/shipping/src/pages/shipment-change-history/shipment-change-history.constants.ts | 42 |
| endpoint | 진입 자동조회 금지 — keep-alive 잔여 filters 무효화(§5-7) + 컬럼메타 1회 fetch(admin 동적 속성관리). | features/shipping/src/pages/shipment-change-history/ShipmentChangeHistory.tsx | 112 |

## 10. __asis-mapping__.md 상태
- 해당없음: 22
- 구현: 27
| design_id | summary | reason | status |
|---|---|---|---|
| D00-1-001 | §1 FromSite / LayoutControlItem | WinForms 레이아웃 프리미티브 — React JSX/SCSS 대체 | 해당없음 |
| D00-1-002 | §1 Incotemrs / LayoutControlItem | WinForms 레이아웃 프리미티브 — React JSX/SCSS 대체 | 해당없음 |
| D00-1-003 | §1 ShipmentDate / LayoutControlItem | WinForms 레이아웃 프리미티브 — React JSX/SCSS 대체 | 해당없음 |
| D00-1-004 | §1 ToSite / LayoutControlItem | WinForms 레이아웃 프리미티브 — React JSX/SCSS 대체 | 해당없음 |
| D00-1-005 | §1 TransportMode / LayoutControlItem | WinForms 레이아웃 프리미티브 — React JSX/SCSS 대체 | 해당없음 |
| D00-1-013 | §1 components / Container | WinForms 레이아웃 프리미티브 — React JSX/SCSS 대체 | 해당없음 |
| D00-1-015 | §1 emptySpaceItem4 / EmptySpaceItem | WinForms 레이아웃 프리미티브 — React JSX/SCSS 대체 | 해당없음 |
| D00-1-016 | §1 emptySpaceItem6 / EmptySpaceItem | WinForms 레이아웃 프리미티브 — React JSX/SCSS 대체 | 해당없음 |
| D00-1-017 | §1 emptySpaceItem7 / EmptySpaceItem | WinForms 레이아웃 프리미티브 — React JSX/SCSS 대체 | 해당없음 |
| D00-1-018 | §1 imageList1 / ImageList | WinForms 레이아웃 프리미티브 — React JSX/SCSS 대체 | 해당없음 |
| D00-1-019 | §1 layoutControlGroup1 / LayoutControlGroup | WinForms 레이아웃 프리미티브 — React JSX/SCSS 대체 | 해당없음 |
| D00-1-020 | §1 layoutControlItem1 / LayoutControlItem | WinForms 레이아웃 프리미티브 — React JSX/SCSS 대체 | 해당없음 |
| D00-1-021 | §1 layoutControlItem2 / LayoutControlItem | WinForms 레이아웃 프리미티브 — React JSX/SCSS 대체 | 해당없음 |
| D00-1-022 | §1 layoutControlItem3 / LayoutControlItem | WinForms 레이아웃 프리미티브 — React JSX/SCSS 대체 | 해당없음 |
| D00-1-023 | §1 lblItemId / LayoutControlItem | WinForms 레이아웃 프리미티브 — React JSX/SCSS 대체 | 해당없음 |
| D00-1-024 | §1 lblSONo / LayoutControlItem | WinForms 레이아웃 프리미티브 — React JSX/SCSS 대체 | 해당없음 |
| D00-1-025 | §1 lcDivision / LayoutControlItem | WinForms 레이아웃 프리미티브 — React JSX/SCSS 대체 | 해당없음 |
| D00-1-027 | §1 spdMain_Sheet1 / SheetView | WinForms 레이아웃 프리미티브 — React JSX/SCSS 대체 | 해당없음 |
| D00-1-028 | §1 splitter1 / Splitter | WinForms 레이아웃 프리미티브 — React JSX/SCSS 대체 | 해당없음 |
| D00-1-032 | §1 usrConditionPanel1 / UsrConditionPanel | WinForms 레이아웃 프리미티브 — React JSX/SCSS 대체 | 해당없음 |
| D00-1-033 | §1 usrLayoutControl1 / UsrLayoutControl | WinForms 레이아웃 프리미티브 — React JSX/SCSS 대체 | 해당없음 |
| D00-3-002 | §3 VisibleTab / (true) | WinForms 레이아웃 프리미티브 — React JSX/SCSS 대체 | 해당없음 |

