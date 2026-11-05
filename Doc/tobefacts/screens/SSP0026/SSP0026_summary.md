# SSP0026 — To-Be Fact Pack 요약

- page_key: `shipping/shipment-request-pack` · feature: shipping · As-is Fact Pack 있음
- 파일 19 · 엔드포인트 호출 23 (미해결 2, 주석 속 0) · 이벤트 56 · 컴포넌트 사용 87 · 하드코딩 컬럼 3 · 메시지 53
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 사용 · 하드코딩 컬럼 정의 3건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/shipping/src/pages/shipment-request-pack/components/ExcelUploadModal.module.scss | component | 47 |
| features/shipping/src/pages/shipment-request-pack/components/ExcelUploadModal.tsx | component | 306 |
| features/shipping/src/pages/shipment-request-pack/components/PopupInput.tsx | component | 33 |
| features/shipping/src/pages/shipment-request-pack/components/ShipmentRequestPackDetailGrid.tsx | component | 217 |
| features/shipping/src/pages/shipment-request-pack/components/ShipmentRequestPackDetailSearch.module.scss | component | 45 |
| features/shipping/src/pages/shipment-request-pack/components/ShipmentRequestPackDetailSearch.tsx | component | 144 |
| features/shipping/src/pages/shipment-request-pack/components/ShipmentRequestPackForm.tsx | component | 308 |
| features/shipping/src/pages/shipment-request-pack/components/ShipmentRequestPackMainGrid.tsx | component | 548 |
| features/shipping/src/pages/shipment-request-pack/index.ts | index | 2 |
| features/shipping/src/pages/shipment-request-pack/shipment-request-pack.constants.ts | constants | 170 |
| features/shipping/src/pages/shipment-request-pack/shipment-request-pack.types.ts | types | 56 |
| features/shipping/src/pages/shipment-request-pack/ShipmentRequestPack.module.scss | style | 37 |
| features/shipping/src/pages/shipment-request-pack/ShipmentRequestPack.tsx | page | 932 |
| features/shipping/src/pages/shipment-request-pack/useShipmentRequestPackStore.ts | store | 335 |
| features/shipping/src/pages/shipment-request-pack/utils/shipment-request-pack.autoSync.ts | util | 101 |
| features/shipping/src/pages/shipment-request-pack/utils/shipment-request-pack.dynamicColumn.ts | util | 30 |
| features/shipping/src/pages/shipment-request-pack/utils/shipment-request-pack.editLock.ts | util | 71 |
| features/shipping/src/pages/shipment-request-pack/utils/shipment-request-pack.save.ts | util | 329 |
| features/shipping/src/pages/shipment-request-pack/utils/shipment-request-pack.spreadHeader.ts | util | 227 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| /SSP0026/{sheetName}/UPLOAD/excel-upload | http | 1 | N | ExcelUploadModal.tsx:133 |
| (useTabComboQueries) | hook | 7 | Y | ShipmentRequestPackForm.tsx:50 ShipmentRequestPackForm.tsx:51 ShipmentRequestPackForm.tsx:54 ShipmentRequestPackForm.tsx:59 ShipmentRequestPackForm.tsx:68 ShipmentRequestPackForm.tsx:71 |
| (useTabLookupQueries) | hook | 1 | Y | ShipmentRequestPack.tsx:147 |
| SSP0026/pack//call-proc | hook | 1 | Y | ShipmentRequestPack.tsx:214 |
| SSP0026/cell//call-proc | hook | 1 | Y | ShipmentRequestPack.tsx:221 |
| SSP0026/requestDetail//call-proc | hook | 1 | Y | ShipmentRequestPack.tsx:228 |
| SSP0026/resultDetail//call-proc | hook | 1 | Y | ShipmentRequestPack.tsx:238 |
| SSP0026/spreadTitle//call-proc | hook | 1 | Y | ShipmentRequestPack.tsx:250 |
| SSP0026/requestDetailExcel//call-proc | hook | 1 | Y | ShipmentRequestPack.tsx:280 |
| SSP0026/bodItem/SEARCH/call-proc | callProc | 1 | Y | ShipmentRequestPack.tsx:403 |
| /SSP0026/{ADMIN_SHEET_NAME[SHEETS.REQUEST_DETAIL_EXCEL]}/UPLOAD_SAVE/call-proc | http | 1 | N | ShipmentRequestPack.tsx:444 |
| /SSP0026/pack/SAVE/call-proc | http | 1 | Y | ShipmentRequestPack.tsx:642 |
| /SSP0026/cell/SAVE/call-proc | http | 1 | Y | ShipmentRequestPack.tsx:668 |
| /SSP0026/requestDetail/SAVE/call-proc | http | 1 | Y | ShipmentRequestPack.tsx:731 |
| /admin/menu/SSP0026/column | http | 1 | Y | useShipmentRequestPackStore.ts:266 |
| /admin/menu/SSP0026/measure | http | 1 | Y | useShipmentRequestPackStore.ts:283 |
| /admin/menu/SSP0026/search-conditions | http | 1 | Y | useShipmentRequestPackStore.ts:312 |

## 3. procedures.d.ts 등재 시트
| sheet | request_keys | response_cursors | sp_hints |
|---|---|---|---|
| pack | divisionId teamIds endCustomerIds salesSiteIds plantSiteIds bucketType fromYyyymmdd toYyyymmdd projectCode modelId sesUserId mnuId | o_rc1 | PKG_SSP0026 P_SSP0026_GET_SHIPMENT_REQUEST_PACK P_SSP0026_GET_REQUEST_DETAIL_PACK P_SSP0026_GET_RESULT_DETAIL P_SSP0026_GET_REQUEST_DETAIL_PACK_EXCEL_DOWN P_SSP0026_GET_SPREAD_TITLE P_SSP0026_GET_BOD_ITEM P_SSP0026_GET_ITEM_BY_DIVISION_POPUP |
| cell | divisionId teamIds endCustomerIds salesSiteIds plantSiteIds bucketType fromYyyymmdd toYyyymmdd projectCode modelId sesUserId mnuId | o_rc1 | PKG_SSP0026 P_SSP0026_GET_SHIPMENT_REQUEST_PACK P_SSP0026_GET_REQUEST_DETAIL_PACK P_SSP0026_GET_RESULT_DETAIL P_SSP0026_GET_REQUEST_DETAIL_PACK_EXCEL_DOWN P_SSP0026_GET_SPREAD_TITLE P_SSP0026_GET_BOD_ITEM P_SSP0026_GET_ITEM_BY_DIVISION_POPUP |
| requestDetail | divisionId fromYyyymmdd toYyyymmdd modelId nickName lotId requestorName scmSiteId sesUserId mnuId | o_rc1 | PKG_SSP0026 P_SSP0026_GET_SHIPMENT_REQUEST_PACK P_SSP0026_GET_REQUEST_DETAIL_PACK P_SSP0026_GET_RESULT_DETAIL P_SSP0026_GET_REQUEST_DETAIL_PACK_EXCEL_DOWN P_SSP0026_GET_SPREAD_TITLE P_SSP0026_GET_BOD_ITEM P_SSP0026_GET_ITEM_BY_DIVISION_POPUP |
| resultDetail | divisionId fromYyyymmdd toYyyymmdd modelId nickName sesUserId mnuId | o_rc1 | PKG_SSP0026 P_SSP0026_GET_SHIPMENT_REQUEST_PACK P_SSP0026_GET_REQUEST_DETAIL_PACK P_SSP0026_GET_RESULT_DETAIL P_SSP0026_GET_REQUEST_DETAIL_PACK_EXCEL_DOWN P_SSP0026_GET_SPREAD_TITLE P_SSP0026_GET_BOD_ITEM P_SSP0026_GET_ITEM_BY_DIVISION_POPUP |
| requestDetailExcel | divisionId fromYyyymmdd toYyyymmdd plantSiteId scmSiteId lotId itemId nickName userId requestorId programId sheetName | o_rc1 | PKG_SSP0026 P_SSP0026_GET_SHIPMENT_REQUEST_PACK P_SSP0026_GET_REQUEST_DETAIL_PACK P_SSP0026_GET_RESULT_DETAIL P_SSP0026_GET_REQUEST_DETAIL_PACK_EXCEL_DOWN P_SSP0026_GET_SPREAD_TITLE P_SSP0026_GET_BOD_ITEM P_SSP0026_GET_ITEM_BY_DIVISION_POPUP |
| spreadTitle | fromYyyymmdd toYyyymmdd sesUserId sheetName divisionId | o_rc1 | PKG_SSP0026 P_SSP0026_GET_SHIPMENT_REQUEST_PACK P_SSP0026_GET_REQUEST_DETAIL_PACK P_SSP0026_GET_RESULT_DETAIL P_SSP0026_GET_REQUEST_DETAIL_PACK_EXCEL_DOWN P_SSP0026_GET_SPREAD_TITLE P_SSP0026_GET_BOD_ITEM P_SSP0026_GET_ITEM_BY_DIVISION_POPUP |
| bodItem | divisionId fromSiteId toSiteId itemId bodId | o_rc1 | PKG_SSP0026 P_SSP0026_GET_SHIPMENT_REQUEST_PACK P_SSP0026_GET_REQUEST_DETAIL_PACK P_SSP0026_GET_RESULT_DETAIL P_SSP0026_GET_REQUEST_DETAIL_PACK_EXCEL_DOWN P_SSP0026_GET_SPREAD_TITLE P_SSP0026_GET_BOD_ITEM P_SSP0026_GET_ITEM_BY_DIVISION_POPUP |
| itemByDivisionPopup | divisionId plantSiteOrSalesSite projectCode currentItemId | o_rc1 | PKG_SSP0026 P_SSP0026_GET_SHIPMENT_REQUEST_PACK P_SSP0026_GET_REQUEST_DETAIL_PACK P_SSP0026_GET_RESULT_DETAIL P_SSP0026_GET_REQUEST_DETAIL_PACK_EXCEL_DOWN P_SSP0026_GET_SPREAD_TITLE P_SSP0026_GET_BOD_ITEM P_SSP0026_GET_ITEM_BY_DIVISION_POPUP |

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| FileUploader | onFileChange | <arrow> setAlert,t,setFiles,value.slice,resetResult | jsx | features/shipping/src/pages/shipment-request-pack/components/ExcelUploadModal.tsx | 229 |
| Button | onClick | <arrow> handleValidate | jsx | features/shipping/src/pages/shipment-request-pack/components/ExcelUploadModal.tsx | 253 |
| Button | onClick | <arrow> handleSave | jsx | features/shipping/src/pages/shipment-request-pack/components/ExcelUploadModal.tsx | 261 |
| Button | onClick | handleClose | jsx | features/shipping/src/pages/shipment-request-pack/components/ExcelUploadModal.tsx | 265 |
| InputField | onChange | <arrow> onChange | jsx | features/shipping/src/pages/shipment-request-pack/components/PopupInput.tsx | 30 |
| Button | onClick | onOpen | jsx | features/shipping/src/pages/shipment-request-pack/components/PopupInput.tsx | 26 |
| g | formatItem | fmt | addHandler | features/shipping/src/pages/shipment-request-pack/components/ShipmentRequestPackDetailGrid.tsx | 105 |
| g | updatedLayout | applyDashFormat | addHandler | features/shipping/src/pages/shipment-request-pack/components/ShipmentRequestPackDetailGrid.tsx | 129 |
| g.hostElement | dblclick | handler | addEventListener | features/shipping/src/pages/shipment-request-pack/components/ShipmentRequestPackDetailGrid.tsx | 161 |
| g | cellEditEnded | handler | addHandler | features/shipping/src/pages/shipment-request-pack/components/ShipmentRequestPackDetailGrid.tsx | 177 |
| DataGrid | beginningEdit | isResultDetail ? undefined : handleBeginningEdit | jsx | features/shipping/src/pages/shipment-request-pack/components/ShipmentRequestPackDetailGrid.tsx | 212 |
| DataGrid | gotFocus | onFocus | jsx | features/shipping/src/pages/shipment-request-pack/components/ShipmentRequestPackDetailGrid.tsx | 213 |
| PeriodRangePicker | onChange | <arrow> setSearchParams | jsx | features/shipping/src/pages/shipment-request-pack/components/ShipmentRequestPackDetailSearch.tsx | 54 |
| PopupInput | onChange | <arrow> setSearchParams | jsx | features/shipping/src/pages/shipment-request-pack/components/ShipmentRequestPackDetailSearch.tsx | 66 |
| PopupInput | onOpen | <arrow> setOpenModel | jsx | features/shipping/src/pages/shipment-request-pack/components/ShipmentRequestPackDetailSearch.tsx | 67 |
| InputField | onChange | <arrow> setSearchParams | jsx | features/shipping/src/pages/shipment-request-pack/components/ShipmentRequestPackDetailSearch.tsx | 83 |
| PopupInput | onChange | <arrow> setSearchParams | jsx | features/shipping/src/pages/shipment-request-pack/components/ShipmentRequestPackDetailSearch.tsx | 96 |
| PopupInput | onOpen | <arrow> setOpenRequestor | jsx | features/shipping/src/pages/shipment-request-pack/components/ShipmentRequestPackDetailSearch.tsx | 97 |
| Button | onClick | onSearch | jsx | features/shipping/src/pages/shipment-request-pack/components/ShipmentRequestPackDetailSearch.tsx | 107 |
| SearchArea | onSearch | onSearch | jsx | features/shipping/src/pages/shipment-request-pack/components/ShipmentRequestPackForm.tsx | 95 |
| CustomDropdown | onChange | <arrow>  | jsx | features/shipping/src/pages/shipment-request-pack/components/ShipmentRequestPackForm.tsx | 115 |
| CustomDropdown | onChange | <arrow> handleTeamChange | jsx | features/shipping/src/pages/shipment-request-pack/components/ShipmentRequestPackForm.tsx | 131 |
| CustomDropdown | onChange | <arrow> handleEndCustomerChange | jsx | features/shipping/src/pages/shipment-request-pack/components/ShipmentRequestPackForm.tsx | 150 |
| PeriodRangePicker | onChange | <arrow> setSearchParams | jsx | features/shipping/src/pages/shipment-request-pack/components/ShipmentRequestPackForm.tsx | 160 |
| CustomDropdown | onChange | <arrow> setSearchParams,option.split(',').filter,option.split | jsx | features/shipping/src/pages/shipment-request-pack/components/ShipmentRequestPackForm.tsx | 177 |
| PopupInput | onChange | <arrow> setSearchParams | jsx | features/shipping/src/pages/shipment-request-pack/components/ShipmentRequestPackForm.tsx | 192 |
| PopupInput | onOpen | <arrow> setOpenProject | jsx | features/shipping/src/pages/shipment-request-pack/components/ShipmentRequestPackForm.tsx | 193 |
| PopupInput | onChange | <arrow> setSearchParams | jsx | features/shipping/src/pages/shipment-request-pack/components/ShipmentRequestPackForm.tsx | 206 |
| PopupInput | onOpen | <arrow> setOpenModel | jsx | features/shipping/src/pages/shipment-request-pack/components/ShipmentRequestPackForm.tsx | 207 |
| CustomDropdown | onChange | <arrow> setSearchParams,option.split(',').filter,option.split | jsx | features/shipping/src/pages/shipment-request-pack/components/ShipmentRequestPackForm.tsx | 233 |
| CustomDropdown | onChange | <arrow> setSearchParams | jsx | features/shipping/src/pages/shipment-request-pack/components/ShipmentRequestPackForm.tsx | 257 |
| g | beginningEdit | guard | addHandler | features/shipping/src/pages/shipment-request-pack/components/ShipmentRequestPackMainGrid.tsx | 174 |
| g | pastingCell | guard | addHandler | features/shipping/src/pages/shipment-request-pack/components/ShipmentRequestPackMainGrid.tsx | 175 |
| g | cellEditEnded | handler | addHandler | features/shipping/src/pages/shipment-request-pack/components/ShipmentRequestPackMainGrid.tsx | 240 |
| g | pastedCell | handler | addHandler | features/shipping/src/pages/shipment-request-pack/components/ShipmentRequestPackMainGrid.tsx | 241 |
| g | formatItem | fmt | addHandler | features/shipping/src/pages/shipment-request-pack/components/ShipmentRequestPackMainGrid.tsx | 318 |
| g | updatedLayout | applyHeaderHeight | addHandler | features/shipping/src/pages/shipment-request-pack/components/ShipmentRequestPackMainGrid.tsx | 393 |
| g | updatedLayout | applyDynVisibility | addHandler | features/shipping/src/pages/shipment-request-pack/components/ShipmentRequestPackMainGrid.tsx | 447 |
| g.hostElement | dblclick | dblclickHandler | addEventListener | features/shipping/src/pages/shipment-request-pack/components/ShipmentRequestPackMainGrid.tsx | 521 |
| DataGrid | gotFocus | onFocus | jsx | features/shipping/src/pages/shipment-request-pack/components/ShipmentRequestPackMainGrid.tsx | 543 |
| ShipmentRequestPackForm | onSearch | handleSearch | jsx | features/shipping/src/pages/shipment-request-pack/ShipmentRequestPack.tsx | 771 |
| TabWrapper | onTabClick | <arrow> setActiveMainSheet | jsx | features/shipping/src/pages/shipment-request-pack/ShipmentRequestPack.tsx | 786 |
| ShipmentRequestPackMainGrid | onDrillDetail | handleDrillDetail | jsx | features/shipping/src/pages/shipment-request-pack/ShipmentRequestPack.tsx | 801 |
| ShipmentRequestPackMainGrid | onFocus | <arrow> setActiveGrid | jsx | features/shipping/src/pages/shipment-request-pack/ShipmentRequestPack.tsx | 802 |
| ShipmentRequestPackMainGrid | onFocus | <arrow> setActiveGrid | jsx | features/shipping/src/pages/shipment-request-pack/ShipmentRequestPack.tsx | 822 |
| ShipmentRequestPackDetailSearch | onSearch | handleDetailSearch | jsx | features/shipping/src/pages/shipment-request-pack/ShipmentRequestPack.tsx | 838 |
| TabWrapper | onTabClick | <arrow> setActiveDetailSheet | jsx | features/shipping/src/pages/shipment-request-pack/ShipmentRequestPack.tsx | 841 |
| ShipmentRequestPackDetailGrid | onModelCellDblClick | handleModelCellDblClick | jsx | features/shipping/src/pages/shipment-request-pack/ShipmentRequestPack.tsx | 855 |
| ShipmentRequestPackDetailGrid | onBodCellChange | <arrow> refreshRowBod | jsx | features/shipping/src/pages/shipment-request-pack/ShipmentRequestPack.tsx | 856 |
| ShipmentRequestPackDetailGrid | onFocus | <arrow> setActiveGrid | jsx | features/shipping/src/pages/shipment-request-pack/ShipmentRequestPack.tsx | 857 |
| ShipmentRequestPackDetailGrid | onFocus | <arrow> setActiveGrid | jsx | features/shipping/src/pages/shipment-request-pack/ShipmentRequestPack.tsx | 868 |
| MeasureSelectModal | onApply | <arrow> applyVisibleMeasures,setOpenMeasure | jsx | features/shipping/src/pages/shipment-request-pack/ShipmentRequestPack.tsx | 884 |
| ExcelUploadModal | onSave | handleExcelUploadSave | jsx | features/shipping/src/pages/shipment-request-pack/ShipmentRequestPack.tsx | 898 |
| ExcelUploadModal | onUploaded | <arrow> setActiveDetailSheet,refetchPack,refetchCell,refetchRequestDetail | jsx | features/shipping/src/pages/shipment-request-pack/ShipmentRequestPack.tsx | 899 |
| ModelByDivisionPopup | onClose | <arrow> setModelCellRow | jsx | features/shipping/src/pages/shipment-request-pack/ShipmentRequestPack.tsx | 912 |
| ModelByDivisionPopup | onSelect | <arrow> gridRefRequest.current?.invalidate,refreshRowBod,setModelCellRow | jsx | features/shipping/src/pages/shipment-request-pack/ShipmentRequestPack.tsx | 913 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| FormItem | 15 |
| Grid | 9 |
| CustomDropdown | 6 |
| Button | 5 |
| PopupInput | 4 |
| TabItem | 4 |
| TextField | 3 |
| DataGrid | 3 |
| ControlConfirmIcon | 2 |
| InputField | 2 |
| Stack | 2 |
| PeriodRangePicker | 2 |
| MaterialByDivisionModal | 2 |
| Panel | 2 |
| TabWrapper | 2 |
| ShipmentRequestPackMainGrid | 2 |
| ShipmentRequestPackDetailGrid | 2 |
| CustomDialog | 1 |
| ProgressIndicator | 1 |
| FileUploader | 1 |
| Label | 1 |
| FunctionSearchIcon | 1 |
| SsoUserModal | 1 |
| SearchArea | 1 |
| ProjectByDivisionModal | 1 |
| IcMeasureSelect | 1 |
| FileExceldownloadIcon | 1 |
| FileExceluploadIcon | 1 |
| MainTitle | 1 |
| ShipmentRequestPackForm | 1 |
| SubTitle | 1 |
| PanelGroup | 1 |
| PanelSeparator | 1 |
| ShipmentRequestPackDetailSearch | 1 |
| MeasureSelectModal | 1 |
| ExcelUploadModal | 1 |
| ModelByDivisionPopup | 1 |

## 6. 하드코딩 Grid 컬럼
| context | binding | header | width | visible | isReadOnly | dataType | via | file | line |
|---|---|---|---|---|---|---|---|---|---|
| resultColumns | MESSAGE_TEXT | Check | 240 | true |  |  | meta-shape | features/shipping/src/pages/shipment-request-pack/components/ExcelUploadModal.tsx | 84 |
| resultColumns | `ATTRIBUTE${i + 1}` | label | 110 | true |  |  | meta-map | features/shipping/src/pages/shipment-request-pack/components/ExcelUploadModal.tsx | 93 |
| buildDynamicColumns | m.binding | m.kind === 'D' ? m.leaf \|\| 'SUM' : 'SUM' | 90 | true |  |  | object | features/shipping/src/pages/shipment-request-pack/utils/shipment-request-pack.spreadHeader.ts | 124 |

## 7. 메시지 코드
| code | count |
|---|---|
| MSG00113 | 1 |
| MSG00618 | 5 |
| MSG00152 | 1 |
| MSG00265 | 1 |
| LBL00759 | 1 |
| LBL00754 | 1 |
| LBL00755 | 1 |
| LBL00756 | 1 |
| LBL00757 | 1 |
| LBL00001 | 1 |
| LBL00710 | 1 |
| LBL00013 | 1 |
| LBL00044 | 1 |
| LBL00080 | 1 |
| LBL00011 | 1 |
| LBL00005 | 1 |
| LBL00012 | 1 |
| LBL00669 | 1 |
| LBL00618 | 1 |
| LBL01115 | 1 |
| LBL01090 | 1 |
| LBL00767 | 1 |
| LBL01108 | 1 |
| LBL00112 | 1 |
| LBL00664 | 1 |
| LBL00310 | 1 |
| LBL00762 | 1 |
| LBL00346 | 1 |
| MSG00665 | 1 |
| MSG00108 | 1 |
| MSG01187 | 1 |
| MSG01126 | 1 |
| LBL00022 | 1 |
| LBL00023 | 1 |
| MSG00003 | 1 |
| MSG00002 | 1 |
| MSG01296 | 1 |
| MSG01320 | 1 |
| MSG00042 | 1 |
| MSG00429 | 2 |
| MSG00043 | 2 |
| MSG00699 | 1 |
| MSG00004 | 3 |
| MSG01081 | 1 |
| MSG00001 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: DMF0045(17), SSP0026(11), SSP0015(5), SSP0023(3), SYS0001(1)
- SP/PKG: PKG_SSP0026(6), DM0003_GET_BUCKET_TYPE_CODE(2), P_SSP0026_GET_SHIPMENT_REQUEST_PACK(2), P_SSP0026_SAVE_SHIP_REQ_PACK(2), PR_GET_EXCEL_UPLOAD_RESULT(1), P_SSP0026_GET_REQUEST_DETAIL_PACK(1), P_SSP0026_GET_BOD_ITEM(1), PKG_NSCM_UI_COMM(1), PR_GET_PROC_INFO_LIST(1), P_SCM_SITE_ID(1), P_SSP0026_SAVE_SHIP_REQ_(1), P_SSP0026_SAVE_SHIP_REQ_CELL(1), P_SSP0026_SAVE_SHIP_REQ_DETAIL_PACK(1), P_SSP0026_GET_SPREAD_TITLE(1), SSP0026_GET_SPREAD_TITLE(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
(없음)

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

