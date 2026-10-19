# SSP0022 — To-Be Fact Pack 요약

- page_key: `shipping/shipment-request-electrode` · feature: shipping · As-is Fact Pack 있음
- 파일 11 · 엔드포인트 호출 10 (미해결 0, 주석 속 0) · 이벤트 19 · 컴포넌트 사용 43 · 하드코딩 컬럼 1 · 메시지 13
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 1건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/shipping/src/pages/shipment-request-electrode/components/ShipmentRequestElectrodeDetailGrid.tsx | component | 89 |
| features/shipping/src/pages/shipment-request-electrode/components/ShipmentRequestElectrodeForm.tsx | component | 242 |
| features/shipping/src/pages/shipment-request-electrode/components/ShipmentRequestElectrodeMainGrid.tsx | component | 113 |
| features/shipping/src/pages/shipment-request-electrode/components/ShipmentRequestElectrodeStockGrid.tsx | component | 34 |
| features/shipping/src/pages/shipment-request-electrode/index.ts | index | 2 |
| features/shipping/src/pages/shipment-request-electrode/shipment-request-electrode.constants.ts | constants | 148 |
| features/shipping/src/pages/shipment-request-electrode/shipment-request-electrode.types.ts | types | 58 |
| features/shipping/src/pages/shipment-request-electrode/ShipmentRequestElectrode.tsx | page | 237 |
| features/shipping/src/pages/shipment-request-electrode/useShipmentRequestElectrodeStore.ts | store | 313 |
| features/shipping/src/pages/shipment-request-electrode/utils/shipment-request-electrode.dynamicColumn.ts | util | 72 |
| features/shipping/src/pages/shipment-request-electrode/utils/shipment-request-electrode.editLock.ts | util | 33 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueries) | hook | 4 | Y | ShipmentRequestElectrodeForm.tsx:39 ShipmentRequestElectrodeForm.tsx:48 ShipmentRequestElectrodeForm.tsx:52 ShipmentRequestElectrodeForm.tsx:56 |
| SSP0022/main//call-proc | hook | 1 | Y | ShipmentRequestElectrode.tsx:86 |
| SSP0022/requestDetail//call-proc | hook | 1 | Y | ShipmentRequestElectrode.tsx:93 |
| SSP0022/stockDetail//call-proc | hook | 1 | Y | ShipmentRequestElectrode.tsx:103 |
| /admin/menu/SSP0022/search-conditions | http | 1 | Y | useShipmentRequestElectrodeStore.ts:138 |
| /admin/menu/SSP0022/column | http | 1 | Y | useShipmentRequestElectrodeStore.ts:282 |
| /admin/menu/SSP0022/measure | http | 1 | Y | useShipmentRequestElectrodeStore.ts:298 |

## 3. procedures.d.ts 등재 시트
| sheet | request_keys | response_cursors | sp_hints |
|---|---|---|---|
| main | divisionId companyId plantId cellType planStartYyyymmdd fromYyyymmdd toYyyymmdd modelId itemId nickName sesUserId mnuId sheetName realFlag myModelChk partLeaderChk teamLeaderChk delegateChk nonChk | o_rc1 | PKG_SSP0022 PKG_DM0003 PKG_SSP0002 P_SSP0022_GET_SHIPMENT_PSI P_SSP0022_GET_REQUEST_DETAIL P_SSP0022_GET_STOCK_DETAIL P_SSP0022_GET_REQUEST_DETAIL_EXCEL_DOWN P_SSP0022_GET_SHEET_CALENDAR_3SPAN P_SSP0022_GET_ITEM_POPUP |
| requestDetail | divisionId companyId modelId itemId nickName fromYyyymmdd toYyyymmdd sesUserId mnuId | o_rc1 | PKG_SSP0022 PKG_DM0003 PKG_SSP0002 P_SSP0022_GET_SHIPMENT_PSI P_SSP0022_GET_REQUEST_DETAIL P_SSP0022_GET_STOCK_DETAIL P_SSP0022_GET_REQUEST_DETAIL_EXCEL_DOWN P_SSP0022_GET_SHEET_CALENDAR_3SPAN P_SSP0022_GET_ITEM_POPUP |
| stockDetail | divisionId companyId modelId itemId lotId sesUserId mnuId | o_rc1 | PKG_SSP0022 PKG_DM0003 PKG_SSP0002 P_SSP0022_GET_SHIPMENT_PSI P_SSP0022_GET_REQUEST_DETAIL P_SSP0022_GET_STOCK_DETAIL P_SSP0022_GET_REQUEST_DETAIL_EXCEL_DOWN P_SSP0022_GET_SHEET_CALENDAR_3SPAN P_SSP0022_GET_ITEM_POPUP |
| requestDetailExcel | divisionId companyId modelId itemId sesUserId mnuId | o_rc1 | PKG_SSP0022 PKG_DM0003 PKG_SSP0002 P_SSP0022_GET_SHIPMENT_PSI P_SSP0022_GET_REQUEST_DETAIL P_SSP0022_GET_STOCK_DETAIL P_SSP0022_GET_REQUEST_DETAIL_EXCEL_DOWN P_SSP0022_GET_SHEET_CALENDAR_3SPAN P_SSP0022_GET_ITEM_POPUP |
| spreadTitle | fromYyyymmdd toYyyymmdd | o_rc1 | PKG_SSP0022 PKG_DM0003 PKG_SSP0002 P_SSP0022_GET_SHIPMENT_PSI P_SSP0022_GET_REQUEST_DETAIL P_SSP0022_GET_STOCK_DETAIL P_SSP0022_GET_REQUEST_DETAIL_EXCEL_DOWN P_SSP0022_GET_SHEET_CALENDAR_3SPAN P_SSP0022_GET_ITEM_POPUP |
| bodItemPopup | divisionId modelId itemId sesUserId | o_rc1 | PKG_SSP0022 PKG_DM0003 PKG_SSP0002 P_SSP0022_GET_SHIPMENT_PSI P_SSP0022_GET_REQUEST_DETAIL P_SSP0022_GET_STOCK_DETAIL P_SSP0022_GET_REQUEST_DETAIL_EXCEL_DOWN P_SSP0022_GET_SHEET_CALENDAR_3SPAN P_SSP0022_GET_ITEM_POPUP |

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| DataGrid | gotFocus | onFocus | jsx | features/shipping/src/pages/shipment-request-electrode/components/ShipmentRequestElectrodeDetailGrid.tsx | 83 |
| DataGrid | beginningEdit | handleBeginningEdit | jsx | features/shipping/src/pages/shipment-request-electrode/components/ShipmentRequestElectrodeDetailGrid.tsx | 85 |
| SearchArea | onSearch | onSearch | jsx | features/shipping/src/pages/shipment-request-electrode/components/ShipmentRequestElectrodeForm.tsx | 85 |
| CustomDropdown | onChange | <arrow> handleDivisionChange | jsx | features/shipping/src/pages/shipment-request-electrode/components/ShipmentRequestElectrodeForm.tsx | 101 |
| CustomDropdown | onChange | <arrow> handleCompanyChange | jsx | features/shipping/src/pages/shipment-request-electrode/components/ShipmentRequestElectrodeForm.tsx | 116 |
| CustomDropdown | onChange | <arrow> setSearchParams,option.split(',').filter,option.split | jsx | features/shipping/src/pages/shipment-request-electrode/components/ShipmentRequestElectrodeForm.tsx | 135 |
| CustomDropdown | onChange | <arrow> handlePlanDateChange | jsx | features/shipping/src/pages/shipment-request-electrode/components/ShipmentRequestElectrodeForm.tsx | 157 |
| PeriodRangePicker | onChange | <arrow> setSearchParams | jsx | features/shipping/src/pages/shipment-request-electrode/components/ShipmentRequestElectrodeForm.tsx | 167 |
| CustomDropdown | onChange | <arrow> setSearchParams,option.split(',').filter,option.split | jsx | features/shipping/src/pages/shipment-request-electrode/components/ShipmentRequestElectrodeForm.tsx | 188 |
| InputField | onChange | <arrow> setSearchParams | jsx | features/shipping/src/pages/shipment-request-electrode/components/ShipmentRequestElectrodeForm.tsx | 204 |
| InputField | onChange | <arrow> setSearchParams | jsx | features/shipping/src/pages/shipment-request-electrode/components/ShipmentRequestElectrodeForm.tsx | 218 |
| InputField | onChange | <arrow> setSearchParams | jsx | features/shipping/src/pages/shipment-request-electrode/components/ShipmentRequestElectrodeForm.tsx | 232 |
| DataGrid | gotFocus | onFocus | jsx | features/shipping/src/pages/shipment-request-electrode/components/ShipmentRequestElectrodeMainGrid.tsx | 108 |
| DataGrid | gotFocus | onFocus | jsx | features/shipping/src/pages/shipment-request-electrode/components/ShipmentRequestElectrodeStockGrid.tsx | 31 |
| ShipmentRequestElectrodeForm | onSearch | handleSearch | jsx | features/shipping/src/pages/shipment-request-electrode/ShipmentRequestElectrode.tsx | 179 |
| ShipmentRequestElectrodeMainGrid | onFocus | <arrow> setActiveGrid | jsx | features/shipping/src/pages/shipment-request-electrode/ShipmentRequestElectrode.tsx | 202 |
| TabWrapper | onTabClick | <arrow> setActiveDetailTab | jsx | features/shipping/src/pages/shipment-request-electrode/ShipmentRequestElectrode.tsx | 209 |
| ShipmentRequestElectrodeDetailGrid | onFocus | <arrow> setActiveGrid | jsx | features/shipping/src/pages/shipment-request-electrode/ShipmentRequestElectrode.tsx | 219 |
| ShipmentRequestElectrodeStockGrid | onFocus | <arrow> setActiveGrid | jsx | features/shipping/src/pages/shipment-request-electrode/ShipmentRequestElectrode.tsx | 228 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Grid | 9 |
| FormItem | 8 |
| CustomDropdown | 5 |
| DataGrid | 3 |
| InputField | 3 |
| Panel | 2 |
| TabItem | 2 |
| SearchArea | 1 |
| PeriodRangePicker | 1 |
| MainTitle | 1 |
| ShipmentRequestElectrodeForm | 1 |
| SubTitle | 1 |
| PanelGroup | 1 |
| ShipmentRequestElectrodeMainGrid | 1 |
| PanelSeparator | 1 |
| TabWrapper | 1 |
| ShipmentRequestElectrodeDetailGrid | 1 |
| ShipmentRequestElectrodeStockGrid | 1 |

## 6. 하드코딩 Grid 컬럼
| context | binding | header | width | visible | isReadOnly | dataType | via | file | line |
|---|---|---|---|---|---|---|---|---|---|
| dynamicColumns | DIVISION_ID:DIVISION_ID,END_CUSTOMER:END_CUSTOMER | DIVISION_ID:DIVISION_ID,END_CUSTOMER:END_CUSTOMER | 90 | true |  |  | object | features/shipping/src/pages/shipment-request-electrode/components/ShipmentRequestElectrodeMainGrid.tsx | 78 |

## 7. 메시지 코드
| code | count |
|---|---|
| LBL00001 | 1 |
| LBL00047 | 1 |
| LBL00005 | 1 |
| LBL00039 | 1 |
| LBL00013 | 1 |
| LBL00046 | 1 |
| LBL00669 | 2 |
| LBL01142 | 1 |
| LBL00767 | 1 |
| LBL00112 | 1 |
| MSG00012 | 1 |
| LBL01090 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: SSP0022(3), SSP0021(2), DMF0082(1), SCP0025(1)
- SP/PKG: PKG_SSP0022(8), P_SSP0022_SAVE_SHIPMENT_REQUEST(3), PKG_DM0003(3), PKG_SSP0002(3), P_SSP0022_GET_SHIPMENT_PSI(2), P_SSP0022_GET_ITEM_POPUP(2), SSP0022_GET_SHEET_CALENDAR_3SPAN(1), P_SSP0022_GET_REQUEST_DETAIL(1), P_SSP0022_GET_STOCK_DETAIL(1), P_SSP0022_GET_REQUEST_DETAIL_EXCEL_DOWN(1), P_SSP0022_GET_SHEET_CALENDAR_3SPAN(1), P_SSP0022_GET_BOD_ITEM_VALID_CHECK(1), P_DM0003_GET_BUCKET_TYPE_CODE(1), P_SSP0002_GET_USER_INFO_LIST(1), P_NON_CHK(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
(없음)

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

