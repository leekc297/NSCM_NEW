# SSP0019 — To-Be Fact Pack 요약

- page_key: `shipping/shipment-change-history` · feature: shipping · As-is Fact Pack 없음(화면ID 미대응)
- 파일 15 · 엔드포인트 호출 6 (미해결 0, 주석 속 3) · 이벤트 26 · 컴포넌트 사용 54 · 하드코딩 컬럼 4 · 메시지 19
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 4건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/shipping/src/pages/shipment-change-history/components/modals/ItemByDivisionModal.module.scss | component | 18 |
| features/shipping/src/pages/shipment-change-history/components/modals/ItemByDivisionModal.tsx | component | 196 |
| features/shipping/src/pages/shipment-change-history/components/modals/ShipmentPlanRequestModal.module.scss | component | 25 |
| features/shipping/src/pages/shipment-change-history/components/modals/ShipmentPlanRequestModal.tsx | component | 45 |
| features/shipping/src/pages/shipment-change-history/components/ShipmentChangeHistoryForm.module.scss | component | 18 |
| features/shipping/src/pages/shipment-change-history/components/ShipmentChangeHistoryForm.tsx | component | 370 |
| features/shipping/src/pages/shipment-change-history/components/ShipmentChangeHistoryGrid.tsx | component | 143 |
| features/shipping/src/pages/shipment-change-history/index.ts | index | 2 |
| features/shipping/src/pages/shipment-change-history/shipment-change-history.constants.ts | constants | 173 |
| features/shipping/src/pages/shipment-change-history/shipment-change-history.types.ts | types | 33 |
| features/shipping/src/pages/shipment-change-history/ShipmentChangeHistory.module.scss | style | 24 |
| features/shipping/src/pages/shipment-change-history/ShipmentChangeHistory.tsx | page | 219 |
| features/shipping/src/pages/shipment-change-history/useShipmentChangeHistoryStore.ts | store | 206 |
| features/shipping/src/pages/shipment-change-history/utils/shipmentChangeHistoryColumns.ts | util | 72 |
| features/shipping/src/pages/shipment-change-history/__asis-mapping__.md | mapping | 162 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| SSP0019/popup//call-proc | hook | 1 | Y | ItemByDivisionModal.tsx:67 |
| (useTabComboQueries) | hook | 1 | Y | ShipmentChangeHistoryForm.tsx:67 |
| (useTabLookupQueries) | hook | 1 | Y | ShipmentChangeHistoryGrid.tsx:58 |
| SSP0019/main//call-proc | hook | 1 | Y | ShipmentChangeHistory.tsx:56 |
| /admin/menu/SSP0019/search-conditions | http | 1 | Y | useShipmentChangeHistoryStore.ts:160 |
| /admin/menu/SSP0019/column | http | 1 | Y | useShipmentChangeHistoryStore.ts:184 |

## 3. procedures.d.ts 등재 시트
(없음)

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| SearchArea | onSearch | handleSearch | jsx | features/shipping/src/pages/shipment-change-history/components/modals/ItemByDivisionModal.tsx | 125 |
| InputField | onChange | <arrow> setItemId | jsx | features/shipping/src/pages/shipment-change-history/components/modals/ItemByDivisionModal.tsx | 145 |
| InputField | onKeyDown | <arrow> handleSearch | jsx | features/shipping/src/pages/shipment-change-history/components/modals/ItemByDivisionModal.tsx | 146 |
| Button | onClick | handleSubmit | jsx | features/shipping/src/pages/shipment-change-history/components/modals/ItemByDivisionModal.tsx | 181 |
| Button | onClick | modalClose | jsx | features/shipping/src/pages/shipment-change-history/components/modals/ItemByDivisionModal.tsx | 188 |
| SearchArea | onSearch | onSearch | jsx | features/shipping/src/pages/shipment-change-history/components/ShipmentChangeHistoryForm.tsx | 132 |
| CustomDropdown | onChange | <arrow> handleDivisionChange,pickedToCsv | jsx | features/shipping/src/pages/shipment-change-history/components/ShipmentChangeHistoryForm.tsx | 151 |
| CustomDropdown | onChange | <arrow> set,splitMulti | jsx | features/shipping/src/pages/shipment-change-history/components/ShipmentChangeHistoryForm.tsx | 172 |
| CustomDropdown | onChange | <arrow> set,splitMulti | jsx | features/shipping/src/pages/shipment-change-history/components/ShipmentChangeHistoryForm.tsx | 193 |
| CustomDropdown | onChange | <arrow> set,splitMulti | jsx | features/shipping/src/pages/shipment-change-history/components/ShipmentChangeHistoryForm.tsx | 214 |
| CustomDropdown | onChange | <arrow> set,splitMulti | jsx | features/shipping/src/pages/shipment-change-history/components/ShipmentChangeHistoryForm.tsx | 235 |
| DatePickerCalendar | onChange | <arrow> set,date?.format | jsx | features/shipping/src/pages/shipment-change-history/components/ShipmentChangeHistoryForm.tsx | 256 |
| DatePickerCalendar | onChange | <arrow> set,date?.format | jsx | features/shipping/src/pages/shipment-change-history/components/ShipmentChangeHistoryForm.tsx | 271 |
| InputField | onChange | <arrow> set | jsx | features/shipping/src/pages/shipment-change-history/components/ShipmentChangeHistoryForm.tsx | 297 |
| InputField | onKeyDown | <arrow> onSearch | jsx | features/shipping/src/pages/shipment-change-history/components/ShipmentChangeHistoryForm.tsx | 298 |
| Button | onClick | onOpenModelPopup | jsx | features/shipping/src/pages/shipment-change-history/components/ShipmentChangeHistoryForm.tsx | 306 |
| InputField | onChange | <arrow> set | jsx | features/shipping/src/pages/shipment-change-history/components/ShipmentChangeHistoryForm.tsx | 324 |
| InputField | onKeyDown | <arrow> onSearch | jsx | features/shipping/src/pages/shipment-change-history/components/ShipmentChangeHistoryForm.tsx | 325 |
| InputField | onChange | <arrow> set | jsx | features/shipping/src/pages/shipment-change-history/components/ShipmentChangeHistoryForm.tsx | 342 |
| InputField | onKeyDown | <arrow> onSearch | jsx | features/shipping/src/pages/shipment-change-history/components/ShipmentChangeHistoryForm.tsx | 343 |
| input | onChange | <arrow> set | jsx | features/shipping/src/pages/shipment-change-history/components/ShipmentChangeHistoryForm.tsx | 360 |
| g | formatItem | formatItemHandler | addHandler | features/shipping/src/pages/shipment-change-history/components/ShipmentChangeHistoryGrid.tsx | 100 |
| g.hostElement | click | clickHandler | addEventListener | features/shipping/src/pages/shipment-change-history/components/ShipmentChangeHistoryGrid.tsx | 114 |
| ShipmentChangeHistoryForm | onSearch | handleSearch | jsx | features/shipping/src/pages/shipment-change-history/ShipmentChangeHistory.tsx | 173 |
| ShipmentChangeHistoryForm | onOpenModelPopup | <arrow> setModelPopupOpen | jsx | features/shipping/src/pages/shipment-change-history/ShipmentChangeHistory.tsx | 174 |
| ShipmentChangeHistoryGrid | onRequestNoClick | setRequestNo | jsx | features/shipping/src/pages/shipment-change-history/ShipmentChangeHistory.tsx | 194 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Grid | 12 |
| FormItem | 12 |
| InputField | 5 |
| CustomDropdown | 5 |
| Button | 3 |
| CustomDialog | 2 |
| SearchArea | 2 |
| DataGrid | 2 |
| DatePickerCalendar | 2 |
| ProgressIndicator | 1 |
| ResultArea | 1 |
| ControlConfirmIcon | 1 |
| MainTitle | 1 |
| ShipmentChangeHistoryForm | 1 |
| SubTitle | 1 |
| ShipmentChangeHistoryGrid | 1 |
| ItemByDivisionModal | 1 |
| ShipmentPlanRequestModal | 1 |

## 6. 하드코딩 Grid 컬럼
| context | binding | header | width | visible | isReadOnly | dataType | via | file | line |
|---|---|---|---|---|---|---|---|---|---|
| POPUP_COLUMNS | ITEM_ID | Model | 160 | true |  |  | meta-shape | features/shipping/src/pages/shipment-change-history/components/modals/ItemByDivisionModal.tsx | 38 |
| POPUP_COLUMNS | NICK_NAME | Nick Name | 140 | true |  |  | meta-shape | features/shipping/src/pages/shipment-change-history/components/modals/ItemByDivisionModal.tsx | 39 |
| POPUP_COLUMNS | MODEL_ID | Item | 140 | true |  |  | meta-shape | features/shipping/src/pages/shipment-change-history/components/modals/ItemByDivisionModal.tsx | 40 |
| col | c.key | c.header | c.width | c.visible !== false |  |  | meta-map | features/shipping/src/pages/shipment-change-history/utils/shipmentChangeHistoryColumns.ts | 50 |

## 7. 메시지 코드
| code | count |
|---|---|
| MSG00667 | 1 |
| MSG00219 | 1 |
| LBL00001 | 1 |
| LBL00022 | 1 |
| LBL00023 | 1 |
| LBL00024 | 1 |
| LBL00025 | 1 |
| LBL01115 | 1 |
| LBL00669 | 1 |
| LBL01111 | 1 |
| LBL01063 | 1 |
| LBL01065 | 1 |
| LBL00112 | 1 |
| LBL00664 | 1 |
| LBL00343 | 1 |
| LBL00674 | 1 |
| LBL00716 | 1 |
| LBL00627 | 1 |
| LBL00744 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: SSP0019(7), SCM0002(6), SSP0012(2), SCP0033(1), SSP0005(1)
- SP/PKG: PKG_SSP0019(5), P_SSP0019_GET_SHIPMENT_CHANGE_HISTORY(2)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| endpoint | 셀콤보 dataMap 직접 fetch(design 03 §6-1) — lookupType 이 서로 달라 comboParams 단일값으로 못 실어 | features/shipping/src/pages/shipment-change-history/components/ShipmentChangeHistoryGrid.tsx | 55 |
| endpoint | 그리드 셀 콤보 lookupType 직접 fetch(useTabLookupQueries) — comboParams 단일값으로 못 푸는 2종(design 03 §6-1). | features/shipping/src/pages/shipment-change-history/shipment-change-history.constants.ts | 45 |
| endpoint | 진입 자동조회 금지 — keep-alive 잔여 filters 무효화(§5-7) + 컬럼메타 1회 fetch(admin 동적 속성관리). | features/shipping/src/pages/shipment-change-history/ShipmentChangeHistory.tsx | 84 |

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

