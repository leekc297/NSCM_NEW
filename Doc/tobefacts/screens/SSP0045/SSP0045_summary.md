# SSP0045 — To-Be Fact Pack 요약

- page_key: `shipping/shipment-request-semi` · feature: shipping · As-is Fact Pack 있음
- 파일 16 · 엔드포인트 호출 11 (미해결 0, 주석 속 2) · 이벤트 30 · 컴포넌트 사용 46 · 하드코딩 컬럼 1 · 메시지 24
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 1건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/shipping/src/pages/shipment-request-semi/components/modals/BodItemRouteModal.module.scss | component | 18 |
| features/shipping/src/pages/shipment-request-semi/components/modals/BodItemRouteModal.tsx | component | 261 |
| features/shipping/src/pages/shipment-request-semi/components/ShipmentRequestSemiForm.tsx | component | 352 |
| features/shipping/src/pages/shipment-request-semi/components/ShipmentRequestSemiGrid.module.scss | component | 70 |
| features/shipping/src/pages/shipment-request-semi/components/ShipmentRequestSemiGrid.tsx | component | 538 |
| features/shipping/src/pages/shipment-request-semi/hooks/useShipmentRequestSemiSave.ts | hook | 183 |
| features/shipping/src/pages/shipment-request-semi/hooks/useShipmentRequestSemiValidation.ts | hook | 71 |
| features/shipping/src/pages/shipment-request-semi/index.ts | index | 2 |
| features/shipping/src/pages/shipment-request-semi/shipment-request-semi.constants.ts | constants | 246 |
| features/shipping/src/pages/shipment-request-semi/shipment-request-semi.types.ts | types | 82 |
| features/shipping/src/pages/shipment-request-semi/ShipmentRequestSemi.tsx | page | 396 |
| features/shipping/src/pages/shipment-request-semi/useShipmentRequestSemiStore.ts | store | 266 |
| features/shipping/src/pages/shipment-request-semi/utils/shipmentRequestSemi.columns.ts | util | 279 |
| features/shipping/src/pages/shipment-request-semi/utils/shipmentRequestSemi.editLock.ts | util | 111 |
| features/shipping/src/pages/shipment-request-semi/utils/shipmentRequestSemi.save.ts | util | 219 |
| features/shipping/src/pages/shipment-request-semi/__asis-mapping__.md | mapping | 320 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| SSP0045/bodPopup//call-proc | hook | 1 | Y | BodItemRouteModal.tsx:80 |
| (useTabComboQueries) | hook | 4 | Y | ShipmentRequestSemiForm.tsx:71 ShipmentRequestSemiForm.tsx:79 ShipmentRequestSemiForm.tsx:99 ShipmentRequestSemiGrid.tsx:200 |
| /SSP0045/main/SAVE/call-proc | http | 1 | Y | useShipmentRequestSemiSave.ts:86 |
| SSP0045/main//call-proc | hook | 1 | Y | ShipmentRequestSemi.tsx:108 |
| SSP0045/calendar//call-proc | hook | 1 | Y | ShipmentRequestSemi.tsx:117 |
| /admin/menu/SSP0045/column | http | 2 | Y | useShipmentRequestSemiStore.ts:191 useShipmentRequestSemiStore.ts:211 |
| /admin/menu/SSP0045/search-conditions | http | 1 | Y | useShipmentRequestSemiStore.ts:238 |

## 3. procedures.d.ts 등재 시트
(없음)

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| SearchArea | onSearch | handleSearch | jsx | features/shipping/src/pages/shipment-request-semi/components/modals/BodItemRouteModal.tsx | 175 |
| InputField | onChange | <arrow> setItemId | jsx | features/shipping/src/pages/shipment-request-semi/components/modals/BodItemRouteModal.tsx | 204 |
| InputField | onKeyDown | <arrow> handleSearch | jsx | features/shipping/src/pages/shipment-request-semi/components/modals/BodItemRouteModal.tsx | 205 |
| Button | onClick | handleSubmit | jsx | features/shipping/src/pages/shipment-request-semi/components/modals/BodItemRouteModal.tsx | 246 |
| Button | onClick | modalClose | jsx | features/shipping/src/pages/shipment-request-semi/components/modals/BodItemRouteModal.tsx | 253 |
| SearchArea | onSearch | onSearch | jsx | features/shipping/src/pages/shipment-request-semi/components/ShipmentRequestSemiForm.tsx | 180 |
| CustomDropdown | onChange | <arrow> String,confirmIfDirtyKey(tabDirtyKey(tabId),'search').then,confirmIfDirtyKey,tabDirtyKey,setDivision | jsx | features/shipping/src/pages/shipment-request-semi/components/ShipmentRequestSemiForm.tsx | 199 |
| CustomDropdown | onChange | <arrow> setOperationGroup,String | jsx | features/shipping/src/pages/shipment-request-semi/components/ShipmentRequestSemiForm.tsx | 222 |
| InputField | onChange | <arrow> set | jsx | features/shipping/src/pages/shipment-request-semi/components/ShipmentRequestSemiForm.tsx | 252 |
| Button | onClick | onModelSearch | jsx | features/shipping/src/pages/shipment-request-semi/components/ShipmentRequestSemiForm.tsx | 248 |
| CustomDropdown | onChange | <arrow> set,String(picked??'').split(',').filter,String(picked??'').split,String | jsx | features/shipping/src/pages/shipment-request-semi/components/ShipmentRequestSemiForm.tsx | 273 |
| CustomDropdown | onChange | <arrow> set,String | jsx | features/shipping/src/pages/shipment-request-semi/components/ShipmentRequestSemiForm.tsx | 300 |
| PeriodField | onChange | <arrow> set | jsx | features/shipping/src/pages/shipment-request-semi/components/ShipmentRequestSemiForm.tsx | 320 |
| Checkbox | onChange | <arrow> set | jsx | features/shipping/src/pages/shipment-request-semi/components/ShipmentRequestSemiForm.tsx | 341 |
| g | formatItem | formatItemHandler | addHandler | features/shipping/src/pages/shipment-request-semi/components/ShipmentRequestSemiGrid.tsx | 329 |
| g | beginningEdit | beginningEditHandler | addHandler | features/shipping/src/pages/shipment-request-semi/components/ShipmentRequestSemiGrid.tsx | 345 |
| g | pastingCell | beginningEditHandler | addHandler | features/shipping/src/pages/shipment-request-semi/components/ShipmentRequestSemiGrid.tsx | 347 |
| g | cellEditEnding | clampQtyOnCommit | addHandler | features/shipping/src/pages/shipment-request-semi/components/ShipmentRequestSemiGrid.tsx | 364 |
| g | cellEditEnded | cellEditEndedHandler | addHandler | features/shipping/src/pages/shipment-request-semi/components/ShipmentRequestSemiGrid.tsx | 377 |
| g.hostElement | click | clickHandler | addEventListener | features/shipping/src/pages/shipment-request-semi/components/ShipmentRequestSemiGrid.tsx | 399 |
| g.hostElement | dblclick | dblClickHandler | addEventListener | features/shipping/src/pages/shipment-request-semi/components/ShipmentRequestSemiGrid.tsx | 416 |
| g | updatedLayout | applyDrillVisibility | addHandler | features/shipping/src/pages/shipment-request-semi/components/ShipmentRequestSemiGrid.tsx | 465 |
| g | updatedLayout | applyHeaderHeight | addHandler | features/shipping/src/pages/shipment-request-semi/components/ShipmentRequestSemiGrid.tsx | 504 |
| DataGrid | gotFocus | onFocus | jsx | features/shipping/src/pages/shipment-request-semi/components/ShipmentRequestSemiGrid.tsx | 534 |
| ShipmentRequestSemiForm | onSearch | handleSearch | jsx | features/shipping/src/pages/shipment-request-semi/ShipmentRequestSemi.tsx | 321 |
| ShipmentRequestSemiForm | onModelSearch | <arrow> setModelPopupOpen | jsx | features/shipping/src/pages/shipment-request-semi/ShipmentRequestSemi.tsx | 322 |
| ShipmentRequestSemiGrid | onBodCellClick | setBodPopupRow | jsx | features/shipping/src/pages/shipment-request-semi/ShipmentRequestSemi.tsx | 348 |
| ShipmentRequestSemiGrid | onModelRequired | <arrow> setAlert,t(MSG.SELECT_FIRST,'_First,select{0}.').replace,t | jsx | features/shipping/src/pages/shipment-request-semi/ShipmentRequestSemi.tsx | 349 |
| ShipmentRequestSemiGrid | onModelChanged | handleModelChanged | jsx | features/shipping/src/pages/shipment-request-semi/ShipmentRequestSemi.tsx | 358 |
| ShipmentRequestSemiGrid | onFocus | <arrow>  | jsx | features/shipping/src/pages/shipment-request-semi/ShipmentRequestSemi.tsx | 359 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Grid | 9 |
| FormItem | 9 |
| InputField | 4 |
| CustomDropdown | 4 |
| Button | 3 |
| SearchArea | 2 |
| DataGrid | 2 |
| CustomDialog | 1 |
| ProgressIndicator | 1 |
| ResultArea | 1 |
| ControlConfirmIcon | 1 |
| FunctionSearchIcon | 1 |
| PeriodField | 1 |
| Checkbox | 1 |
| MainTitle | 1 |
| ShipmentRequestSemiForm | 1 |
| SubTitle | 1 |
| ShipmentRequestSemiGrid | 1 |
| MaterialByDivisionModal | 1 |
| BodItemRouteModal | 1 |

## 6. 하드코딩 Grid 컬럼
| context | binding | header | width | visible | isReadOnly | dataType | via | file | line |
|---|---|---|---|---|---|---|---|---|---|
| leafOf | c.binding | c.kind === 'D' ? c.leaf \|\| c.binding.slice(2) : 'SUM' | 70 | isVisible(c.binding) |  |  | object | features/shipping/src/pages/shipment-request-semi/utils/shipmentRequestSemi.columns.ts | 204 |

## 7. 메시지 코드
| code | count |
|---|---|
| LBL00001 | 1 |
| LBL00027 | 1 |
| LBL00618 | 1 |
| LBL00022 | 1 |
| LBL00710 | 1 |
| LBL00013 | 1 |
| LBL00687 | 1 |
| LBL00112 | 1 |
| LBL00664 | 1 |
| LBL00674 | 1 |
| LBL00716 | 1 |
| LBL00627 | 1 |
| MSG00429 | 1 |
| MSG00665 | 1 |
| MSG00108 | 1 |
| MSG01187 | 1 |
| MSG00667 | 1 |
| MSG00672 | 1 |
| MSG00676 | 1 |
| MSG01075 | 1 |
| MSG00699 | 1 |
| MSG01126 | 1 |
| MSG00428 | 1 |
| MSG00014 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: SSP0045(10), SSP0024(2), SSP0200(2), SSP0060(2), SCP0033(1), SSP0025(1), COM0013(1), SCP0020(1), SSP0005(1), SSP0202(1), SCP0123(1), SCP0025(1)
- SP/PKG: PKG_SSP0045(5), SCM0001_GET_SCP_DAY_PERIOD(3), FN_MULTY_TIME(2), P_SSP0045_GET_SHIPMENT_REQUEST(1), P_SSP0045_SAVE_SHIPMENT_REQUEST(1), SCP0009_GET_SHEET_CALENDAR_3SPAN(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| endpoint | 파라미터 인용은 apiClient.getCombo(quoteComboParams)가 일괄 처리하므로 raw 로 전달한다(SRCH-04). | features/shipping/src/pages/shipment-request-semi/components/ShipmentRequestSemiForm.tsx | 97 |
| code | insert: () => undefined, // AS-IS InsertButton NO-OP 노출(cs:530-533) | features/shipping/src/pages/shipment-request-semi/ShipmentRequestSemi.tsx | 293 |
| endpoint | admin SCM_MST_SHEET_COLUMNS 동적 fetch (SHEET_NAME='Shipment Request' 18행). 하드코딩 금지(hook #54/#66). | features/shipping/src/pages/shipment-request-semi/useShipmentRequestSemiStore.ts | 27 |
| jsx | 3단 헤더(월 > 주 > 일) 그룹 컬럼 생성 (design 03 §2.4 / R02). · 1단 = 월 라벨(LARGE_CLASS_LABEL_NAME) · 2단 = 주 라벨(SMALL_CLASS_LABEL_NAME). 월 SUM(M_)은 자기 'SUM' 그룹으로 분리. · 3단(leaf) = 일자 라벨. SUM 컬럼(M_/W_)의 leaf 라벨은 'SUM'. `<FlexGridColumnGroup>` 단일 child 는 Re | features/shipping/src/pages/shipment-request-semi/utils/shipmentRequestSemi.columns.ts | 186 |

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

