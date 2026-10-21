# SSP0025 — To-Be Fact Pack 요약

- page_key: `shipping/shipment-requestor-pic` · feature: shipping · As-is Fact Pack 없음(화면ID 미대응)
- 파일 14 · 엔드포인트 호출 7 (미해결 0, 주석 속 0) · 이벤트 28 · 컴포넌트 사용 44 · 하드코딩 컬럼 11 · 메시지 17
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 11건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/shipping/src/pages/shipment-requestor-pic/components/modals/ItemByDivisionModal.module.scss | component | 18 |
| features/shipping/src/pages/shipment-requestor-pic/components/modals/ItemByDivisionModal.tsx | component | 252 |
| features/shipping/src/pages/shipment-requestor-pic/components/ShipmentRequestorPicForm.tsx | component | 217 |
| features/shipping/src/pages/shipment-requestor-pic/components/ShipmentRequestorPicGrid.tsx | component | 195 |
| features/shipping/src/pages/shipment-requestor-pic/hooks/useShipmentRequestorPicValidation.ts | hook | 66 |
| features/shipping/src/pages/shipment-requestor-pic/index.ts | index | 2 |
| features/shipping/src/pages/shipment-requestor-pic/shipment-requestor-pic.constants.ts | constants | 192 |
| features/shipping/src/pages/shipment-requestor-pic/shipment-requestor-pic.types.ts | types | 30 |
| features/shipping/src/pages/shipment-requestor-pic/ShipmentRequestorPic.module.scss | style | 12 |
| features/shipping/src/pages/shipment-requestor-pic/ShipmentRequestorPic.tsx | page | 502 |
| features/shipping/src/pages/shipment-requestor-pic/useShipmentRequestorPicStore.ts | store | 192 |
| features/shipping/src/pages/shipment-requestor-pic/utils/shipmentRequestorPicColumns.ts | util | 51 |
| features/shipping/src/pages/shipment-requestor-pic/utils/shipmentRequestorPicEditLock.ts | util | 60 |
| features/shipping/src/pages/shipment-requestor-pic/__asis-mapping__.md | mapping | 100 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| SSP0025/popup//call-proc | hook | 1 | Y | ItemByDivisionModal.tsx:100 |
| (useTabComboQueries) | hook | 1 | Y | ShipmentRequestorPicForm.tsx:49 |
| /SSP0025/main/USER_CHECK/call-proc | http | 1 | Y | useShipmentRequestorPicValidation.ts:46 |
| SSP0025/main//call-proc | hook | 1 | Y | ShipmentRequestorPic.tsx:134 |
| /SSP0025/main/SAVE/call-proc | http | 1 | Y | ShipmentRequestorPic.tsx:371 |
| /admin/menu/SSP0025/column | http | 1 | Y | useShipmentRequestorPicStore.ts:135 |
| /admin/menu/SSP0025/search-conditions | http | 1 | Y | useShipmentRequestorPicStore.ts:159 |

## 3. procedures.d.ts 등재 시트
(없음)

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| SearchArea | onSearch | handleSearch | jsx | features/shipping/src/pages/shipment-requestor-pic/components/modals/ItemByDivisionModal.tsx | 166 |
| InputField | onChange | <arrow> setKeyword | jsx | features/shipping/src/pages/shipment-requestor-pic/components/modals/ItemByDivisionModal.tsx | 200 |
| InputField | onKeyDown | <arrow> handleSearch | jsx | features/shipping/src/pages/shipment-requestor-pic/components/modals/ItemByDivisionModal.tsx | 201 |
| Button | onClick | handleSubmit | jsx | features/shipping/src/pages/shipment-requestor-pic/components/modals/ItemByDivisionModal.tsx | 237 |
| Button | onClick | modalClose | jsx | features/shipping/src/pages/shipment-requestor-pic/components/modals/ItemByDivisionModal.tsx | 244 |
| SearchArea | onSearch | onSearch | jsx | features/shipping/src/pages/shipment-requestor-pic/components/ShipmentRequestorPicForm.tsx | 84 |
| CustomDropdown | onChange | <arrow> String,confirmIfDirtyKey(tabDirtyKey(tabId),'search').then,confirmIfDirtyKey,tabDirtyKey,setDivision | jsx | features/shipping/src/pages/shipment-requestor-pic/components/ShipmentRequestorPicForm.tsx | 100 |
| CustomDropdown | onChange | <arrow> set,String(picked??'').split(',').filter,String(picked??'').split,String | jsx | features/shipping/src/pages/shipment-requestor-pic/components/ShipmentRequestorPicForm.tsx | 126 |
| InputField | onChange | <arrow> set | jsx | features/shipping/src/pages/shipment-requestor-pic/components/ShipmentRequestorPicForm.tsx | 160 |
| InputField | onKeyDown | <arrow> onSearch | jsx | features/shipping/src/pages/shipment-requestor-pic/components/ShipmentRequestorPicForm.tsx | 161 |
| FunctionSearchIcon | onClick | onItemSearch | jsx | features/shipping/src/pages/shipment-requestor-pic/components/ShipmentRequestorPicForm.tsx | 155 |
| InputField | onChange | <arrow> set | jsx | features/shipping/src/pages/shipment-requestor-pic/components/ShipmentRequestorPicForm.tsx | 177 |
| InputField | onKeyDown | <arrow> onSearch | jsx | features/shipping/src/pages/shipment-requestor-pic/components/ShipmentRequestorPicForm.tsx | 178 |
| InputField | onChange | <arrow> set | jsx | features/shipping/src/pages/shipment-requestor-pic/components/ShipmentRequestorPicForm.tsx | 206 |
| InputField | onKeyDown | <arrow> onSearch | jsx | features/shipping/src/pages/shipment-requestor-pic/components/ShipmentRequestorPicForm.tsx | 207 |
| FunctionSearchIcon | onClick | onModelSearch | jsx | features/shipping/src/pages/shipment-requestor-pic/components/ShipmentRequestorPicForm.tsx | 201 |
| g | formatItem | formatItemHandler | addHandler | features/shipping/src/pages/shipment-requestor-pic/components/ShipmentRequestorPicGrid.tsx | 92 |
| g | beginningEdit | beginningEditHandler | addHandler | features/shipping/src/pages/shipment-requestor-pic/components/ShipmentRequestorPicGrid.tsx | 110 |
| g | cellEditEnded | cellEditEndedHandler | addHandler | features/shipping/src/pages/shipment-requestor-pic/components/ShipmentRequestorPicGrid.tsx | 136 |
| g.hostElement | dblclick | dblClickHandler | addEventListener | features/shipping/src/pages/shipment-requestor-pic/components/ShipmentRequestorPicGrid.tsx | 161 |
| DataGrid | gotFocus | onFocus | jsx | features/shipping/src/pages/shipment-requestor-pic/components/ShipmentRequestorPicGrid.tsx | 191 |
| ShipmentRequestorPicForm | onSearch | handleSearch | jsx | features/shipping/src/pages/shipment-requestor-pic/ShipmentRequestorPic.tsx | 443 |
| ShipmentRequestorPicForm | onItemSearch | handleItemSearch | jsx | features/shipping/src/pages/shipment-requestor-pic/ShipmentRequestorPic.tsx | 444 |
| ShipmentRequestorPicForm | onModelSearch | handleModelSearch | jsx | features/shipping/src/pages/shipment-requestor-pic/ShipmentRequestorPic.tsx | 445 |
| ShipmentRequestorPicGrid | onItemCellDblClick | handleItemCellDblClick | jsx | features/shipping/src/pages/shipment-requestor-pic/ShipmentRequestorPic.tsx | 468 |
| ShipmentRequestorPicGrid | onUserCellDblClick | handleUserCellDblClick | jsx | features/shipping/src/pages/shipment-requestor-pic/ShipmentRequestorPic.tsx | 469 |
| ShipmentRequestorPicGrid | onDivisionRequired | <arrow> setAlert,msg | jsx | features/shipping/src/pages/shipment-requestor-pic/ShipmentRequestorPic.tsx | 470 |
| ShipmentRequestorPicGrid | onFocus | <arrow>  | jsx | features/shipping/src/pages/shipment-requestor-pic/ShipmentRequestorPic.tsx | 476 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Grid | 8 |
| FormItem | 8 |
| InputField | 6 |
| Button | 4 |
| SearchArea | 2 |
| DataGrid | 2 |
| CustomDropdown | 2 |
| FunctionSearchIcon | 2 |
| CustomDialog | 1 |
| ProgressIndicator | 1 |
| ResultArea | 1 |
| ControlConfirmIcon | 1 |
| MainTitle | 1 |
| ShipmentRequestorPicForm | 1 |
| SubTitle | 1 |
| ShipmentRequestorPicGrid | 1 |
| SsoUserModal | 1 |
| ItemByDivisionModal | 1 |

## 6. 하드코딩 Grid 컬럼
| context | binding | header | width | visible | isReadOnly | dataType | via | file | line |
|---|---|---|---|---|---|---|---|---|---|
| POPUP_COLUMNS | DIVISION_ID | Division_code | 60 | true |  |  | meta-shape | features/shipping/src/pages/shipment-requestor-pic/components/modals/ItemByDivisionModal.tsx | 54 |
| POPUP_COLUMNS | FROM_SITE_CODE | From Site Code | 70 | true |  |  | meta-shape | features/shipping/src/pages/shipment-requestor-pic/components/modals/ItemByDivisionModal.tsx | 55 |
| POPUP_COLUMNS | FROM_SITE | From Site | 150 | true |  |  | meta-shape | features/shipping/src/pages/shipment-requestor-pic/components/modals/ItemByDivisionModal.tsx | 56 |
| POPUP_COLUMNS | ITEM_ID | Material | 100 | true |  |  | meta-shape | features/shipping/src/pages/shipment-requestor-pic/components/modals/ItemByDivisionModal.tsx | 57 |
| POPUP_COLUMNS | MODEL_ID | Model | 100 | true |  |  | meta-shape | features/shipping/src/pages/shipment-requestor-pic/components/modals/ItemByDivisionModal.tsx | 58 |
| POPUP_COLUMNS | CELL_TYPE | Cell Type | 80 | true |  |  | meta-shape | features/shipping/src/pages/shipment-requestor-pic/components/modals/ItemByDivisionModal.tsx | 59 |
| POPUP_COLUMNS | NICK_NAME | Nick Name | 100 | true |  |  | meta-shape | features/shipping/src/pages/shipment-requestor-pic/components/modals/ItemByDivisionModal.tsx | 60 |
| POPUP_COLUMNS | ELECTRODE_TYPE | Electrode Type | 80 | true |  |  | meta-shape | features/shipping/src/pages/shipment-requestor-pic/components/modals/ItemByDivisionModal.tsx | 61 |
| POPUP_COLUMNS | ITEM_UOM | UOM | 60 | true |  |  | meta-shape | features/shipping/src/pages/shipment-requestor-pic/components/modals/ItemByDivisionModal.tsx | 62 |
| POPUP_COLUMNS | UOM_CONVERT_IN_TACT_TIME | Pancake (m/cell) | 120 | true |  |  | meta-shape | features/shipping/src/pages/shipment-requestor-pic/components/modals/ItemByDivisionModal.tsx | 63 |
| col | c.key | c.header | c.width ?? 100 | true |  |  | meta-map | features/shipping/src/pages/shipment-requestor-pic/utils/shipmentRequestorPicColumns.ts | 23 |

## 7. 메시지 코드
| code | count |
|---|---|
| LBL00112 | 1 |
| LBL00664 | 1 |
| LBL00001 | 1 |
| LBL00005 | 1 |
| LBL00021 | 1 |
| LBL00767 | 1 |
| LBL00669 | 1 |
| LBL00674 | 1 |
| LBL00343 | 1 |
| LBL00716 | 1 |
| LBL00627 | 1 |
| MSG00672 | 1 |
| MSG00003 | 1 |
| MSG00004 | 1 |
| MSG00097 | 1 |
| MSG00429 | 1 |
| MSG01261 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: SSP0025(11), SSP0024(7), SSP0014(5), SCP0025(2), SSP0002(2), COM0008(1), DMF0020(1)
- SP/PKG: PKG_SSP0025(8), P_SSP0025_GET_ITEM_BY_DIVISION_POPUP(3), P_SSP0025_GET_USER_ID_CHECK(3), P_SSP0025_GET_SHIPMENT_REQUESTOR_PIC(2), PKG_SSP0002(2), P_USER_ID(1), P_SSP0025_SAVE_SHIPMENT_REQUESTOR_PIC(1), SSP0002_GET_USER_INFO_LIST(1), P_SSP0002_GET_USER_INFO_LIST(1), P_CREATE_ID(1), P_ITEM_ID(1), P_MODEL_ID(1), P_PLANT_SITE(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
(없음)

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

