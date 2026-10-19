# SSP0026 — To-Be Fact Pack 요약

- page_key: `shipping/shipment-request-pack` · feature: shipping · As-is Fact Pack 있음
- 파일 14 · 엔드포인트 호출 16 (미해결 0, 주석 속 0) · 이벤트 30 · 컴포넌트 사용 64 · 하드코딩 컬럼 1 · 메시지 27
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 1건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/shipping/src/pages/shipment-request-pack/components/ShipmentRequestPackDetailGrid.tsx | component | 76 |
| features/shipping/src/pages/shipment-request-pack/components/ShipmentRequestPackDetailSearch.tsx | component | 100 |
| features/shipping/src/pages/shipment-request-pack/components/ShipmentRequestPackForm.tsx | component | 253 |
| features/shipping/src/pages/shipment-request-pack/components/ShipmentRequestPackMainGrid.tsx | component | 180 |
| features/shipping/src/pages/shipment-request-pack/index.ts | index | 2 |
| features/shipping/src/pages/shipment-request-pack/shipment-request-pack.constants.ts | constants | 155 |
| features/shipping/src/pages/shipment-request-pack/shipment-request-pack.types.ts | types | 56 |
| features/shipping/src/pages/shipment-request-pack/ShipmentRequestPack.module.scss | style | 26 |
| features/shipping/src/pages/shipment-request-pack/ShipmentRequestPack.tsx | page | 469 |
| features/shipping/src/pages/shipment-request-pack/useShipmentRequestPackStore.ts | store | 286 |
| features/shipping/src/pages/shipment-request-pack/utils/shipment-request-pack.autoSync.ts | util | 101 |
| features/shipping/src/pages/shipment-request-pack/utils/shipment-request-pack.dynamicColumn.ts | util | 30 |
| features/shipping/src/pages/shipment-request-pack/utils/shipment-request-pack.editLock.ts | util | 46 |
| features/shipping/src/pages/shipment-request-pack/utils/shipment-request-pack.save.ts | util | 189 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueries) | hook | 6 | Y | ShipmentRequestPackForm.tsx:42 ShipmentRequestPackForm.tsx:43 ShipmentRequestPackForm.tsx:46 ShipmentRequestPackForm.tsx:51 ShipmentRequestPackForm.tsx:60 ShipmentRequestPackForm.tsx:63 |
| SSP0026/pack//call-proc | hook | 1 | Y | ShipmentRequestPack.tsx:122 |
| SSP0026/cell//call-proc | hook | 1 | Y | ShipmentRequestPack.tsx:129 |
| SSP0026/requestDetail//call-proc | hook | 1 | Y | ShipmentRequestPack.tsx:136 |
| SSP0026/resultDetail//call-proc | hook | 1 | Y | ShipmentRequestPack.tsx:146 |
| /SSP0026/pack/SAVE/call-proc | http | 1 | Y | ShipmentRequestPack.tsx:287 |
| /SSP0026/cell/SAVE/call-proc | http | 1 | Y | ShipmentRequestPack.tsx:312 |
| /SSP0026/requestDetail/SAVE/call-proc | http | 1 | Y | ShipmentRequestPack.tsx:337 |
| /admin/menu/SSP0026/column | http | 1 | Y | useShipmentRequestPackStore.ts:224 |
| /admin/menu/SSP0026/measure | http | 1 | Y | useShipmentRequestPackStore.ts:241 |
| /admin/menu/SSP0026/search-conditions | http | 1 | Y | useShipmentRequestPackStore.ts:263 |

## 3. procedures.d.ts 등재 시트
| sheet | request_keys | response_cursors | sp_hints |
|---|---|---|---|
| pack | divisionId teamIds endCustomerIds salesSiteIds plantSiteIds bucketType fromYyyymmdd toYyyymmdd projectCode modelId sesUserId mnuId | o_rc1 | PKG_SSP0026 P_SSP0026_GET_SHIPMENT_REQUEST_PACK P_SSP0026_GET_REQUEST_DETAIL_PACK P_SSP0026_GET_RESULT_DETAIL P_SSP0026_GET_REQUEST_DETAIL_PACK_EXCEL_DOWN P_SSP0026_GET_SPREAD_TITLE P_SSP0026_GET_BOD_ITEM P_SSP0026_GET_ITEM_BY_DIVISION_POPUP |
| cell | divisionId teamIds endCustomerIds salesSiteIds plantSiteIds bucketType fromYyyymmdd toYyyymmdd projectCode modelId sesUserId mnuId | o_rc1 | PKG_SSP0026 P_SSP0026_GET_SHIPMENT_REQUEST_PACK P_SSP0026_GET_REQUEST_DETAIL_PACK P_SSP0026_GET_RESULT_DETAIL P_SSP0026_GET_REQUEST_DETAIL_PACK_EXCEL_DOWN P_SSP0026_GET_SPREAD_TITLE P_SSP0026_GET_BOD_ITEM P_SSP0026_GET_ITEM_BY_DIVISION_POPUP |
| requestDetail | divisionId fromYyyymmdd toYyyymmdd modelId nickName lotId requestorName sesUserId mnuId | o_rc1 | PKG_SSP0026 P_SSP0026_GET_SHIPMENT_REQUEST_PACK P_SSP0026_GET_REQUEST_DETAIL_PACK P_SSP0026_GET_RESULT_DETAIL P_SSP0026_GET_REQUEST_DETAIL_PACK_EXCEL_DOWN P_SSP0026_GET_SPREAD_TITLE P_SSP0026_GET_BOD_ITEM P_SSP0026_GET_ITEM_BY_DIVISION_POPUP |
| resultDetail | divisionId fromYyyymmdd toYyyymmdd modelId nickName sesUserId mnuId | o_rc1 | PKG_SSP0026 P_SSP0026_GET_SHIPMENT_REQUEST_PACK P_SSP0026_GET_REQUEST_DETAIL_PACK P_SSP0026_GET_RESULT_DETAIL P_SSP0026_GET_REQUEST_DETAIL_PACK_EXCEL_DOWN P_SSP0026_GET_SPREAD_TITLE P_SSP0026_GET_BOD_ITEM P_SSP0026_GET_ITEM_BY_DIVISION_POPUP |
| requestDetailExcel | divisionId fromYyyymmdd toYyyymmdd modelId sesUserId mnuId | o_rc1 | PKG_SSP0026 P_SSP0026_GET_SHIPMENT_REQUEST_PACK P_SSP0026_GET_REQUEST_DETAIL_PACK P_SSP0026_GET_RESULT_DETAIL P_SSP0026_GET_REQUEST_DETAIL_PACK_EXCEL_DOWN P_SSP0026_GET_SPREAD_TITLE P_SSP0026_GET_BOD_ITEM P_SSP0026_GET_ITEM_BY_DIVISION_POPUP |
| spreadTitle | fromYyyymmdd toYyyymmdd sesUserId sheetName divisionId | o_rc1 | PKG_SSP0026 P_SSP0026_GET_SHIPMENT_REQUEST_PACK P_SSP0026_GET_REQUEST_DETAIL_PACK P_SSP0026_GET_RESULT_DETAIL P_SSP0026_GET_REQUEST_DETAIL_PACK_EXCEL_DOWN P_SSP0026_GET_SPREAD_TITLE P_SSP0026_GET_BOD_ITEM P_SSP0026_GET_ITEM_BY_DIVISION_POPUP |
| bodItem | divisionId modelId incoterms transportMode | o_rc1 | PKG_SSP0026 P_SSP0026_GET_SHIPMENT_REQUEST_PACK P_SSP0026_GET_REQUEST_DETAIL_PACK P_SSP0026_GET_RESULT_DETAIL P_SSP0026_GET_REQUEST_DETAIL_PACK_EXCEL_DOWN P_SSP0026_GET_SPREAD_TITLE P_SSP0026_GET_BOD_ITEM P_SSP0026_GET_ITEM_BY_DIVISION_POPUP |
| itemByDivisionPopup | divisionId plantSiteOrSalesSite projectCode currentItemId | o_rc1 | PKG_SSP0026 P_SSP0026_GET_SHIPMENT_REQUEST_PACK P_SSP0026_GET_REQUEST_DETAIL_PACK P_SSP0026_GET_RESULT_DETAIL P_SSP0026_GET_REQUEST_DETAIL_PACK_EXCEL_DOWN P_SSP0026_GET_SPREAD_TITLE P_SSP0026_GET_BOD_ITEM P_SSP0026_GET_ITEM_BY_DIVISION_POPUP |

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| DataGrid | beginningEdit | isResultDetail ? undefined : handleBeginningEdit | jsx | features/shipping/src/pages/shipment-request-pack/components/ShipmentRequestPackDetailGrid.tsx | 71 |
| DataGrid | gotFocus | onFocus | jsx | features/shipping/src/pages/shipment-request-pack/components/ShipmentRequestPackDetailGrid.tsx | 72 |
| PeriodRangePicker | onChange | <arrow> setSearchParams | jsx | features/shipping/src/pages/shipment-request-pack/components/ShipmentRequestPackDetailSearch.tsx | 35 |
| InputField | onChange | <arrow> setSearchParams | jsx | features/shipping/src/pages/shipment-request-pack/components/ShipmentRequestPackDetailSearch.tsx | 47 |
| InputField | onChange | <arrow> setSearchParams | jsx | features/shipping/src/pages/shipment-request-pack/components/ShipmentRequestPackDetailSearch.tsx | 60 |
| InputField | onChange | <arrow> setSearchParams | jsx | features/shipping/src/pages/shipment-request-pack/components/ShipmentRequestPackDetailSearch.tsx | 73 |
| InputField | onChange | <arrow> setSearchParams | jsx | features/shipping/src/pages/shipment-request-pack/components/ShipmentRequestPackDetailSearch.tsx | 87 |
| Button | onClick | onSearch | jsx | features/shipping/src/pages/shipment-request-pack/components/ShipmentRequestPackDetailSearch.tsx | 95 |
| SearchArea | onSearch | onSearch | jsx | features/shipping/src/pages/shipment-request-pack/components/ShipmentRequestPackForm.tsx | 86 |
| CustomDropdown | onChange | <arrow>  | jsx | features/shipping/src/pages/shipment-request-pack/components/ShipmentRequestPackForm.tsx | 102 |
| CustomDropdown | onChange | <arrow> setSearchParams | jsx | features/shipping/src/pages/shipment-request-pack/components/ShipmentRequestPackForm.tsx | 124 |
| PeriodRangePicker | onChange | <arrow> setSearchParams | jsx | features/shipping/src/pages/shipment-request-pack/components/ShipmentRequestPackForm.tsx | 136 |
| CustomDropdown | onChange | <arrow> handleTeamChange | jsx | features/shipping/src/pages/shipment-request-pack/components/ShipmentRequestPackForm.tsx | 150 |
| CustomDropdown | onChange | <arrow> handleEndCustomerChange | jsx | features/shipping/src/pages/shipment-request-pack/components/ShipmentRequestPackForm.tsx | 169 |
| CustomDropdown | onChange | <arrow> setSearchParams,option.split(',').filter,option.split | jsx | features/shipping/src/pages/shipment-request-pack/components/ShipmentRequestPackForm.tsx | 188 |
| CustomDropdown | onChange | <arrow> setSearchParams,option.split(',').filter,option.split | jsx | features/shipping/src/pages/shipment-request-pack/components/ShipmentRequestPackForm.tsx | 209 |
| InputField | onChange | <arrow> setSearchParams | jsx | features/shipping/src/pages/shipment-request-pack/components/ShipmentRequestPackForm.tsx | 229 |
| InputField | onChange | <arrow> setSearchParams | jsx | features/shipping/src/pages/shipment-request-pack/components/ShipmentRequestPackForm.tsx | 243 |
| g | cellEditEnded | handler | addHandler | features/shipping/src/pages/shipment-request-pack/components/ShipmentRequestPackMainGrid.tsx | 130 |
| g | pastedCell | handler | addHandler | features/shipping/src/pages/shipment-request-pack/components/ShipmentRequestPackMainGrid.tsx | 131 |
| DataGrid | beginningEdit | handleBeginningEdit | jsx | features/shipping/src/pages/shipment-request-pack/components/ShipmentRequestPackMainGrid.tsx | 174 |
| DataGrid | gotFocus | onFocus | jsx | features/shipping/src/pages/shipment-request-pack/components/ShipmentRequestPackMainGrid.tsx | 175 |
| ShipmentRequestPackForm | onSearch | handleSearch | jsx | features/shipping/src/pages/shipment-request-pack/ShipmentRequestPack.tsx | 379 |
| TabWrapper | onTabClick | <arrow> setActiveMainSheet | jsx | features/shipping/src/pages/shipment-request-pack/ShipmentRequestPack.tsx | 393 |
| ShipmentRequestPackMainGrid | onFocus | <arrow> setActiveGrid | jsx | features/shipping/src/pages/shipment-request-pack/ShipmentRequestPack.tsx | 404 |
| ShipmentRequestPackMainGrid | onFocus | <arrow> setActiveGrid | jsx | features/shipping/src/pages/shipment-request-pack/ShipmentRequestPack.tsx | 418 |
| ShipmentRequestPackDetailSearch | onSearch | handleDetailSearch | jsx | features/shipping/src/pages/shipment-request-pack/ShipmentRequestPack.tsx | 431 |
| TabWrapper | onTabClick | <arrow> setActiveDetailSheet | jsx | features/shipping/src/pages/shipment-request-pack/ShipmentRequestPack.tsx | 434 |
| ShipmentRequestPackDetailGrid | onFocus | <arrow> setActiveGrid | jsx | features/shipping/src/pages/shipment-request-pack/ShipmentRequestPack.tsx | 447 |
| ShipmentRequestPackDetailGrid | onFocus | <arrow> setActiveGrid | jsx | features/shipping/src/pages/shipment-request-pack/ShipmentRequestPack.tsx | 458 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Grid | 16 |
| FormItem | 12 |
| InputField | 6 |
| CustomDropdown | 6 |
| TabItem | 4 |
| DataGrid | 2 |
| PeriodRangePicker | 2 |
| Panel | 2 |
| TabWrapper | 2 |
| ShipmentRequestPackMainGrid | 2 |
| ShipmentRequestPackDetailGrid | 2 |
| Button | 1 |
| SearchArea | 1 |
| MainTitle | 1 |
| ShipmentRequestPackForm | 1 |
| SubTitle | 1 |
| PanelGroup | 1 |
| PanelSeparator | 1 |
| ShipmentRequestPackDetailSearch | 1 |

## 6. 하드코딩 Grid 컬럼
| context | binding | header | width | visible | isReadOnly | dataType | via | file | line |
|---|---|---|---|---|---|---|---|---|---|
| dynamicColumns | DIVISION_ID:DIVISION_ID,END_CUSTOMER:END_CUSTOMER | DIVISION_ID:DIVISION_ID,END_CUSTOMER:END_CUSTOMER | 90 | true |  |  | object | features/shipping/src/pages/shipment-request-pack/components/ShipmentRequestPackMainGrid.tsx | 155 |

## 7. 메시지 코드
| code | count |
|---|---|
| LBL00001 | 1 |
| LBL00710 | 1 |
| LBL00013 | 1 |
| LBL00044 | 1 |
| LBL00080 | 1 |
| LBL00011 | 1 |
| LBL00005 | 1 |
| LBL00617 | 1 |
| LBL00669 | 1 |
| LBL01115 | 1 |
| LBL01090 | 1 |
| LBL00767 | 1 |
| LBL01108 | 1 |
| LBL00112 | 1 |
| LBL00664 | 1 |
| MSG00003 | 1 |
| MSG00002 | 1 |
| MSG00293 | 1 |
| MSG00323 | 1 |
| MSG00042 | 1 |
| MSG00004 | 3 |
| MSG00012 | 4 |

## 8. 주석 속 As-is 참조
- 화면ID: SSP0026(4)
- SP/PKG: PKG_SSP0026(6), DM0003_GET_BUCKET_TYPE_CODE(2), P_SSP0026_GET_SHIPMENT_REQUEST_PACK(2), P_SSP0026_SAVE_SHIP_REQ_PACK(2), P_SSP0026_GET_REQUEST_DETAIL_PACK(1), PKG_NSCM_UI_COMM(1), PR_GET_PROC_INFO_LIST(1), P_SSP0026_SAVE_SHIP_REQ_(1), P_SSP0026_SAVE_SHIP_REQ_CELL(1), P_SSP0026_SAVE_SHIP_REQ_DETAIL_PACK(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
(없음)

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

