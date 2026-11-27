# SSP0022 — To-Be Fact Pack 요약

- page_key: `shipping/shipment-request-electrode` · feature: shipping · As-is Fact Pack 있음
- 파일 22 · 엔드포인트 호출 19 (미해결 1, 주석 속 0) · 이벤트 74 · 컴포넌트 사용 127 · 하드코딩 컬럼 5 · 메시지 53
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 사용 · 하드코딩 컬럼 정의 5건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/shipping/src/pages/shipment-request-electrode/components/ExcelUploadModal.module.scss | component | 52 |
| features/shipping/src/pages/shipment-request-electrode/components/ExcelUploadModal.tsx | component | 343 |
| features/shipping/src/pages/shipment-request-electrode/components/modals/BodItemModal.tsx | component | 289 |
| features/shipping/src/pages/shipment-request-electrode/components/modals/ShipmentRequestInsertModal.module.scss | component | 23 |
| features/shipping/src/pages/shipment-request-electrode/components/modals/ShipmentRequestInsertModal.tsx | component | 490 |
| features/shipping/src/pages/shipment-request-electrode/components/ShipmentRequestElectrodeDetailBar.tsx | component | 178 |
| features/shipping/src/pages/shipment-request-electrode/components/ShipmentRequestElectrodeDetailGrid.tsx | component | 173 |
| features/shipping/src/pages/shipment-request-electrode/components/ShipmentRequestElectrodeForm.module.scss | component | 29 |
| features/shipping/src/pages/shipment-request-electrode/components/ShipmentRequestElectrodeForm.tsx | component | 450 |
| features/shipping/src/pages/shipment-request-electrode/components/ShipmentRequestElectrodeMainGrid.tsx | component | 520 |
| features/shipping/src/pages/shipment-request-electrode/components/ShipmentRequestElectrodeStockGrid.tsx | component | 44 |
| features/shipping/src/pages/shipment-request-electrode/index.ts | index | 2 |
| features/shipping/src/pages/shipment-request-electrode/shipment-request-electrode.constants.ts | constants | 255 |
| features/shipping/src/pages/shipment-request-electrode/shipment-request-electrode.types.ts | types | 87 |
| features/shipping/src/pages/shipment-request-electrode/ShipmentRequestElectrode.module.scss | style | 25 |
| features/shipping/src/pages/shipment-request-electrode/ShipmentRequestElectrode.tsx | page | 937 |
| features/shipping/src/pages/shipment-request-electrode/useShipmentRequestElectrodeStore.ts | store | 394 |
| features/shipping/src/pages/shipment-request-electrode/utils/shipment-request-electrode.dynamicColumn.ts | util | 76 |
| features/shipping/src/pages/shipment-request-electrode/utils/shipment-request-electrode.editLock.ts | util | 121 |
| features/shipping/src/pages/shipment-request-electrode/utils/shipment-request-electrode.footerSum.ts | util | 80 |
| features/shipping/src/pages/shipment-request-electrode/utils/shipment-request-electrode.save.ts | util | 332 |
| features/shipping/src/pages/shipment-request-electrode/utils/shipment-request-electrode.spreadHeader.ts | util | 235 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| /SSP0022/{sheetName}/EXCEL/excel-upload | http | 1 | N | ExcelUploadModal.tsx:142 |
| SSP0022/bodItemPopup//call-proc | hook | 1 | Y | BodItemModal.tsx:115 |
| (useTabLookupQueries) | hook | 1 | Y | ShipmentRequestInsertModal.tsx:130 |
| SSP0022/bodItemPopup/SEARCH/call-proc | callProc | 1 | Y | ShipmentRequestInsertModal.tsx:186 |
| (useTabComboQueries) | hook | 4 | Y | ShipmentRequestElectrodeForm.tsx:70 ShipmentRequestElectrodeForm.tsx:94 ShipmentRequestElectrodeForm.tsx:98 ShipmentRequestElectrodeForm.tsx:102 |
| /SSP0022/main/USER_CHECK/call-proc | http | 1 | Y | ShipmentRequestElectrode.tsx:92 |
| SSP0022/main//call-proc | hook | 1 | Y | ShipmentRequestElectrode.tsx:189 |
| SSP0022/requestDetail//call-proc | hook | 1 | Y | ShipmentRequestElectrode.tsx:196 |
| SSP0022/stockDetail//call-proc | hook | 1 | Y | ShipmentRequestElectrode.tsx:206 |
| SSP0022/spreadTitle//call-proc | hook | 1 | Y | ShipmentRequestElectrode.tsx:218 |
| SSP0022/requestDetailExcel//call-proc | hook | 1 | Y | ShipmentRequestElectrode.tsx:268 |
| /SSP0022/main/EXCEL/call-proc | http | 1 | Y | ShipmentRequestElectrode.tsx:614 |
| /admin/menu/SSP0022/search-conditions | http | 1 | Y | useShipmentRequestElectrodeStore.ts:154 |
| /admin/menu/SSP0022/column | http | 1 | Y | useShipmentRequestElectrodeStore.ts:358 |
| /admin/menu/SSP0022/measure | http | 1 | Y | useShipmentRequestElectrodeStore.ts:374 |
| /SSP0022/main/SAVE/call-proc | http | 1 | Y | shipment-request-electrode.save.ts:197 |

## 3. procedures.d.ts 등재 시트
| sheet | request_keys | response_cursors | sp_hints |
|---|---|---|---|
| main | divisionId companyId plantId cellType planStartYyyymmdd fromYyyymmdd toYyyymmdd modelId itemId nickName sesUserId mnuId sheetName realFlag myModelChk partLeaderChk teamLeaderChk delegateChk nonChk | o_rc1 | PKG_SSP0022 PKG_DM0003 PKG_SSP0002 P_SSP0022_GET_SHIPMENT_PSI P_SSP0022_GET_REQUEST_DETAIL P_SSP0022_GET_STOCK_DETAIL P_SSP0022_GET_REQUEST_DETAIL_EXCEL_DOWN P_SSP0022_GET_SHEET_CALENDAR_3SPAN P_SSP0022_GET_ITEM_POPUP |
| requestDetail | divisionId companyId planStartYyyymmdd plantId cellType fromYyyymmdd toYyyymmdd lotId modelId itemId nickName requestorId sesUserId mnuId sheetName realFlag myModelChk partLeaderChk teamLeaderChk delegateChk nonChk | o_rc1 | PKG_SSP0022 PKG_DM0003 PKG_SSP0002 P_SSP0022_GET_SHIPMENT_PSI P_SSP0022_GET_REQUEST_DETAIL P_SSP0022_GET_STOCK_DETAIL P_SSP0022_GET_REQUEST_DETAIL_EXCEL_DOWN P_SSP0022_GET_SHEET_CALENDAR_3SPAN P_SSP0022_GET_ITEM_POPUP |
| stockDetail | divisionId companyId planStartYyyymmdd plantId cellType modelId itemId lotId sesUserId mnuId | o_rc1 | PKG_SSP0022 PKG_DM0003 PKG_SSP0002 P_SSP0022_GET_SHIPMENT_PSI P_SSP0022_GET_REQUEST_DETAIL P_SSP0022_GET_STOCK_DETAIL P_SSP0022_GET_REQUEST_DETAIL_EXCEL_DOWN P_SSP0022_GET_SHEET_CALENDAR_3SPAN P_SSP0022_GET_ITEM_POPUP |
| requestDetailExcel | divisionId companyId modelId itemId sesUserId mnuId | o_rc1 | PKG_SSP0022 PKG_DM0003 PKG_SSP0002 P_SSP0022_GET_SHIPMENT_PSI P_SSP0022_GET_REQUEST_DETAIL P_SSP0022_GET_STOCK_DETAIL P_SSP0022_GET_REQUEST_DETAIL_EXCEL_DOWN P_SSP0022_GET_SHEET_CALENDAR_3SPAN P_SSP0022_GET_ITEM_POPUP |
| spreadTitle | fromYyyymmdd toYyyymmdd | o_rc1 | PKG_SSP0022 PKG_DM0003 PKG_SSP0002 P_SSP0022_GET_SHIPMENT_PSI P_SSP0022_GET_REQUEST_DETAIL P_SSP0022_GET_STOCK_DETAIL P_SSP0022_GET_REQUEST_DETAIL_EXCEL_DOWN P_SSP0022_GET_SHEET_CALENDAR_3SPAN P_SSP0022_GET_ITEM_POPUP |
| bodItemPopup | divisionId fromSiteId toSiteId itemId bodId incoterms transportMode planStartYyyymmdd | o_rc1 | P_SSP0022_GET_ITEM_POPUP PKG_SSP0022 PKG_DM0003 PKG_SSP0002 P_SSP0022_GET_SHIPMENT_PSI P_SSP0022_GET_REQUEST_DETAIL P_SSP0022_GET_STOCK_DETAIL P_SSP0022_GET_REQUEST_DETAIL_EXCEL_DOWN P_SSP0022_GET_SHEET_CALENDAR_3SPAN |

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| FileUploader | onFileChange | <arrow> setAlert,t,setFiles,value.slice,resetResult | jsx | features/shipping/src/pages/shipment-request-electrode/components/ExcelUploadModal.tsx | 260 |
| Button | onClick | <arrow> handleValidate | jsx | features/shipping/src/pages/shipment-request-electrode/components/ExcelUploadModal.tsx | 284 |
| Button | onClick | <arrow> handleSave | jsx | features/shipping/src/pages/shipment-request-electrode/components/ExcelUploadModal.tsx | 292 |
| Button | onClick | handleClose | jsx | features/shipping/src/pages/shipment-request-electrode/components/ExcelUploadModal.tsx | 296 |
| SearchArea | onSearch | handleSearch | jsx | features/shipping/src/pages/shipment-request-electrode/components/modals/BodItemModal.tsx | 189 |
| InputField | onChange | <arrow> setItemId | jsx | features/shipping/src/pages/shipment-request-electrode/components/modals/BodItemModal.tsx | 230 |
| InputField | onKeyDown | <arrow> handleSearch | jsx | features/shipping/src/pages/shipment-request-electrode/components/modals/BodItemModal.tsx | 231 |
| Button | onClick | modalClose | jsx | features/shipping/src/pages/shipment-request-electrode/components/modals/BodItemModal.tsx | 274 |
| Button | onClick | handleOk | jsx | features/shipping/src/pages/shipment-request-electrode/components/modals/BodItemModal.tsx | 281 |
| g | cellEditEnded | onEdit | addHandler | features/shipping/src/pages/shipment-request-electrode/components/modals/ShipmentRequestInsertModal.tsx | 301 |
| Button | onClick | <arrow> handleSave | jsx | features/shipping/src/pages/shipment-request-electrode/components/modals/ShipmentRequestInsertModal.tsx | 461 |
| Button | onClick | modalClose | jsx | features/shipping/src/pages/shipment-request-electrode/components/modals/ShipmentRequestInsertModal.tsx | 468 |
| PeriodRangePicker | onChange | <arrow> setSearchParams | jsx | features/shipping/src/pages/shipment-request-electrode/components/ShipmentRequestElectrodeDetailBar.tsx | 62 |
| InputField | onChange | <arrow> setSearchParams | jsx | features/shipping/src/pages/shipment-request-electrode/components/ShipmentRequestElectrodeDetailBar.tsx | 91 |
| Button | onClick | onItemSearch2 | jsx | features/shipping/src/pages/shipment-request-electrode/components/ShipmentRequestElectrodeDetailBar.tsx | 81 |
| InputField | onChange | <arrow> setSearchParams | jsx | features/shipping/src/pages/shipment-request-electrode/components/ShipmentRequestElectrodeDetailBar.tsx | 123 |
| Button | onClick | onModelSearch2 | jsx | features/shipping/src/pages/shipment-request-electrode/components/ShipmentRequestElectrodeDetailBar.tsx | 113 |
| InputField | onChange | <arrow> setSearchParams | jsx | features/shipping/src/pages/shipment-request-electrode/components/ShipmentRequestElectrodeDetailBar.tsx | 150 |
| Button | onClick | onRequestorSearch | jsx | features/shipping/src/pages/shipment-request-electrode/components/ShipmentRequestElectrodeDetailBar.tsx | 146 |
| InputField | onChange | <arrow> setSearchParams | jsx | features/shipping/src/pages/shipment-request-electrode/components/ShipmentRequestElectrodeDetailBar.tsx | 166 |
| Button | onClick | onDetailSearch | jsx | features/shipping/src/pages/shipment-request-electrode/components/ShipmentRequestElectrodeDetailBar.tsx | 172 |
| g | beginningEdit | beginningEdit | addHandler | features/shipping/src/pages/shipment-request-electrode/components/ShipmentRequestElectrodeDetailGrid.tsx | 123 |
| g | pastingCell | beginningEdit | addHandler | features/shipping/src/pages/shipment-request-electrode/components/ShipmentRequestElectrodeDetailGrid.tsx | 124 |
| g | formatItem | paint | addHandler | features/shipping/src/pages/shipment-request-electrode/components/ShipmentRequestElectrodeDetailGrid.tsx | 125 |
| DataGrid | gotFocus | onFocus | jsx | features/shipping/src/pages/shipment-request-electrode/components/ShipmentRequestElectrodeDetailGrid.tsx | 168 |
| SearchArea | onSearch | onSearch | jsx | features/shipping/src/pages/shipment-request-electrode/components/ShipmentRequestElectrodeForm.tsx | 179 |
| CustomDropdown | onChange | <arrow> handleDivisionChange | jsx | features/shipping/src/pages/shipment-request-electrode/components/ShipmentRequestElectrodeForm.tsx | 192 |
| CustomDropdown | onChange | <arrow> handleCompanyChange | jsx | features/shipping/src/pages/shipment-request-electrode/components/ShipmentRequestElectrodeForm.tsx | 207 |
| CustomDropdown | onChange | <arrow> setSearchParams,option.split(',').filter,option.split | jsx | features/shipping/src/pages/shipment-request-electrode/components/ShipmentRequestElectrodeForm.tsx | 226 |
| CustomDropdown | onChange | <arrow> setSearchParams,option.split(',').filter,option.split | jsx | features/shipping/src/pages/shipment-request-electrode/components/ShipmentRequestElectrodeForm.tsx | 249 |
| CustomDropdown | onChange | <arrow> setSearchParams | jsx | features/shipping/src/pages/shipment-request-electrode/components/ShipmentRequestElectrodeForm.tsx | 265 |
| CustomDropdown | onChange | <arrow> handlePlanDateChange | jsx | features/shipping/src/pages/shipment-request-electrode/components/ShipmentRequestElectrodeForm.tsx | 285 |
| PeriodField | onChange | <arrow> setSearchParams | jsx | features/shipping/src/pages/shipment-request-electrode/components/ShipmentRequestElectrodeForm.tsx | 299 |
| InputField | onChange | <arrow> setSearchParams | jsx | features/shipping/src/pages/shipment-request-electrode/components/ShipmentRequestElectrodeForm.tsx | 330 |
| Button | onClick | onItemSearch | jsx | features/shipping/src/pages/shipment-request-electrode/components/ShipmentRequestElectrodeForm.tsx | 320 |
| InputField | onChange | <arrow> setSearchParams | jsx | features/shipping/src/pages/shipment-request-electrode/components/ShipmentRequestElectrodeForm.tsx | 366 |
| Button | onClick | onModelSearch | jsx | features/shipping/src/pages/shipment-request-electrode/components/ShipmentRequestElectrodeForm.tsx | 356 |
| input | onChange | <arrow> setBohMode | jsx | features/shipping/src/pages/shipment-request-electrode/components/ShipmentRequestElectrodeForm.tsx | 387 |
| Checkbox | onChange | <arrow> setSearchParams | jsx | features/shipping/src/pages/shipment-request-electrode/components/ShipmentRequestElectrodeForm.tsx | 421 |
| Checkbox | onChange | <arrow> setSearchParams | jsx | features/shipping/src/pages/shipment-request-electrode/components/ShipmentRequestElectrodeForm.tsx | 426 |
| Checkbox | onChange | <arrow> setSearchParams | jsx | features/shipping/src/pages/shipment-request-electrode/components/ShipmentRequestElectrodeForm.tsx | 431 |
| Checkbox | onChange | <arrow> setSearchParams | jsx | features/shipping/src/pages/shipment-request-electrode/components/ShipmentRequestElectrodeForm.tsx | 436 |
| Checkbox | onChange | <arrow> setSearchParams | jsx | features/shipping/src/pages/shipment-request-electrode/components/ShipmentRequestElectrodeForm.tsx | 441 |
| g | updatedLayout | applyBohSumVisibility | addHandler | features/shipping/src/pages/shipment-request-electrode/components/ShipmentRequestElectrodeMainGrid.tsx | 123 |
| g | updatedLayout | applyHeaderHeight | addHandler | features/shipping/src/pages/shipment-request-electrode/components/ShipmentRequestElectrodeMainGrid.tsx | 232 |
| g | formatItem | fmt | addHandler | features/shipping/src/pages/shipment-request-electrode/components/ShipmentRequestElectrodeMainGrid.tsx | 271 |
| g | formatItem | markTrigger | addHandler | features/shipping/src/pages/shipment-request-electrode/components/ShipmentRequestElectrodeMainGrid.tsx | 296 |
| g | beginningEdit | beginningEdit | addHandler | features/shipping/src/pages/shipment-request-electrode/components/ShipmentRequestElectrodeMainGrid.tsx | 335 |
| g | pastingCell | beginningEdit | addHandler | features/shipping/src/pages/shipment-request-electrode/components/ShipmentRequestElectrodeMainGrid.tsx | 337 |
| g | formatItem | paint | addHandler | features/shipping/src/pages/shipment-request-electrode/components/ShipmentRequestElectrodeMainGrid.tsx | 381 |
| g | updatedLayout | applyDynVisibility | addHandler | features/shipping/src/pages/shipment-request-electrode/components/ShipmentRequestElectrodeMainGrid.tsx | 425 |
| g.hostElement | dblclick | dblclickHandler | addEventListener | features/shipping/src/pages/shipment-request-electrode/components/ShipmentRequestElectrodeMainGrid.tsx | 478 |
| DataGrid | gotFocus | onFocus | jsx | features/shipping/src/pages/shipment-request-electrode/components/ShipmentRequestElectrodeMainGrid.tsx | 515 |
| DataGrid | gotFocus | onFocus | jsx | features/shipping/src/pages/shipment-request-electrode/components/ShipmentRequestElectrodeStockGrid.tsx | 40 |
| ShipmentRequestElectrodeForm | onSearch | handleSearch | jsx | features/shipping/src/pages/shipment-request-electrode/ShipmentRequestElectrode.tsx | 698 |
| ShipmentRequestElectrodeForm | onItemSearch | <arrow> setOpenItem | jsx | features/shipping/src/pages/shipment-request-electrode/ShipmentRequestElectrode.tsx | 699 |
| ShipmentRequestElectrodeForm | onModelSearch | <arrow> setOpenModel | jsx | features/shipping/src/pages/shipment-request-electrode/ShipmentRequestElectrode.tsx | 700 |
| Checkbox | onChange | <arrow> setSearchParams | jsx | features/shipping/src/pages/shipment-request-electrode/ShipmentRequestElectrode.tsx | 721 |
| ShipmentRequestElectrodeMainGrid | onFocus | <arrow> setActiveGrid | jsx | features/shipping/src/pages/shipment-request-electrode/ShipmentRequestElectrode.tsx | 743 |
| ShipmentRequestElectrodeMainGrid | onCellDoubleClick | handleMainCellDoubleClick | jsx | features/shipping/src/pages/shipment-request-electrode/ShipmentRequestElectrode.tsx | 744 |
| ShipmentRequestElectrodeDetailBar | onDetailSearch | handleDetailSearch | jsx | features/shipping/src/pages/shipment-request-electrode/ShipmentRequestElectrode.tsx | 756 |
| ShipmentRequestElectrodeDetailBar | onItemSearch2 | <arrow> setOpenDetailItem | jsx | features/shipping/src/pages/shipment-request-electrode/ShipmentRequestElectrode.tsx | 757 |
| ShipmentRequestElectrodeDetailBar | onModelSearch2 | <arrow> setOpenDetailModel | jsx | features/shipping/src/pages/shipment-request-electrode/ShipmentRequestElectrode.tsx | 758 |
| ShipmentRequestElectrodeDetailBar | onRequestorSearch | <arrow> setOpenRequestor | jsx | features/shipping/src/pages/shipment-request-electrode/ShipmentRequestElectrode.tsx | 759 |
| TabWrapper | onTabClick | <arrow> setActiveDetailTab | jsx | features/shipping/src/pages/shipment-request-electrode/ShipmentRequestElectrode.tsx | 764 |
| ShipmentRequestElectrodeStockGrid | onFocus | <arrow> setActiveGrid | jsx | features/shipping/src/pages/shipment-request-electrode/ShipmentRequestElectrode.tsx | 774 |
| ShipmentRequestElectrodeDetailGrid | onFocus | <arrow> setActiveGrid | jsx | features/shipping/src/pages/shipment-request-electrode/ShipmentRequestElectrode.tsx | 786 |
| ShipmentRequestElectrodeDetailGrid | onItemCellDoubleClick | handleItemCellDoubleClick | jsx | features/shipping/src/pages/shipment-request-electrode/ShipmentRequestElectrode.tsx | 787 |
| MeasureSelectModal | onApply | <arrow> applyVisibleMeasures,setOpenMeasure | jsx | features/shipping/src/pages/shipment-request-electrode/ShipmentRequestElectrode.tsx | 877 |
| ExcelUploadModal | onSave | handleExcelUploadSave | jsx | features/shipping/src/pages/shipment-request-electrode/ShipmentRequestElectrode.tsx | 892 |
| ExcelUploadModal | onUploaded | <arrow> setActiveDetailTab,setFilters,refetchMain,setDetailFilters,refetchRequestDetail | jsx | features/shipping/src/pages/shipment-request-electrode/ShipmentRequestElectrode.tsx | 893 |
| ShipmentRequestInsertModal | onSaved | <arrow> setOpenRequestInsert,setFilters,refetchMain | jsx | features/shipping/src/pages/shipment-request-electrode/ShipmentRequestElectrode.tsx | 915 |
| BodItemModal | onSelect | handleBodItemSelected | jsx | features/shipping/src/pages/shipment-request-electrode/ShipmentRequestElectrode.tsx | 932 |
| g | formatItem | fmt | addHandler | features/shipping/src/pages/shipment-request-electrode/utils/shipment-request-electrode.footerSum.ts | 69 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| FormItem | 21 |
| Grid | 14 |
| Button | 13 |
| CustomDropdown | 9 |
| InputField | 7 |
| DataGrid | 6 |
| Checkbox | 6 |
| FunctionSearchIcon | 5 |
| MaterialByDivisionModal | 4 |
| CustomDialog | 3 |
| TextField | 3 |
| Stack | 3 |
| ProgressIndicator | 2 |
| ControlConfirmIcon | 2 |
| SearchArea | 2 |
| Panel | 2 |
| TabItem | 2 |
| FileUploader | 1 |
| Label | 1 |
| ResultArea | 1 |
| PeriodRangePicker | 1 |
| PeriodField | 1 |
| IcMeasureSelect | 1 |
| FileExceldownloadIcon | 1 |
| FileExceluploadIcon | 1 |
| MainTitle | 1 |
| ShipmentRequestElectrodeForm | 1 |
| SubTitle | 1 |
| PanelGroup | 1 |
| ShipmentRequestElectrodeMainGrid | 1 |
| PanelSeparator | 1 |
| ShipmentRequestElectrodeDetailBar | 1 |
| TabWrapper | 1 |
| ShipmentRequestElectrodeStockGrid | 1 |
| ShipmentRequestElectrodeDetailGrid | 1 |
| SsoUserModal | 1 |
| MeasureSelectModal | 1 |
| ExcelUploadModal | 1 |
| ShipmentRequestInsertModal | 1 |
| BodItemModal | 1 |

## 6. 하드코딩 Grid 컬럼
| context | binding | header | width | visible | isReadOnly | dataType | via | file | line |
|---|---|---|---|---|---|---|---|---|---|
| resultColumns | MESSAGE_TEXT | Check | 240 | true |  |  | meta-shape | features/shipping/src/pages/shipment-request-electrode/components/ExcelUploadModal.tsx | 93 |
| resultColumns | `ATTRIBUTE${i + 1}` | label | 110 | true |  |  | meta-map | features/shipping/src/pages/shipment-request-electrode/components/ExcelUploadModal.tsx | 102 |
| column | colNm | colLblNm | colWth | true |  |  | meta-map | features/shipping/src/pages/shipment-request-electrode/components/modals/BodItemModal.tsx | 58 |
| col | colNm | colLblNm | width | true |  |  | meta-map | features/shipping/src/pages/shipment-request-electrode/components/modals/ShipmentRequestInsertModal.tsx | 76 |
| buildDynamicColumns | m.binding | m.kind === 'D' ? m.leaf \|\| 'SUM' : 'SUM' | 90 | true |  |  | object | features/shipping/src/pages/shipment-request-electrode/utils/shipment-request-electrode.spreadHeader.ts | 117 |

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
| MSG01104 | 1 |
| MSG00429 | 1 |
| LBL00641 | 1 |
| LBL00047 | 1 |
| LBL00022 | 1 |
| LBL00710 | 1 |
| LBL00039 | 1 |
| LBL00013 | 1 |
| LBL00046 | 1 |
| LBL00021 | 1 |
| LBL00618 | 1 |
| LBL00767 | 1 |
| LBL01090 | 1 |
| LBL01108 | 1 |
| LBL01116 | 1 |
| LBL00112 | 1 |
| LBL00664 | 1 |
| LBL00310 | 1 |
| LBL00762 | 1 |
| LBL00346 | 1 |
| LBL01127 | 1 |
| LBL01126 | 1 |
| LBL01059 | 1 |
| LBL01099 | 1 |
| LBL00687 | 1 |
| LBL01093 | 1 |
| LBL01101 | 1 |
| LBL01124 | 1 |
| LBL01070 | 1 |
| MSG01126 | 1 |
| MSG00611 | 1 |
| MSG00665 | 1 |
| MSG00108 | 1 |
| MSG01187 | 1 |
| MSG01320 | 1 |
| MSG01321 | 1 |
| MSG01075 | 1 |
| MSG01206 | 1 |
| MSG01261 | 1 |
| MSG01314 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: SSP0023(23), SSP0022(17), SSP0026(17), SSP0021(7), SSP0015(6), SSP0024(3), COM0013(3), SSP0025(2), SCP0013(2), SSP0060(2), SSP0045(1), DM0003(1), SSP0002(1), SSP0003(1), DMF0082(1), SCP0025(1)
- SP/PKG: PKG_SSP0022(12), P_SSP0022_SAVE_SHIPMENT_REQUEST(8), PKG_SSP0002(5), P_PLAN_START_YYYYMMDD(3), P_REQUESTOR_ID(3), P_ITEM_ID(3), P_SSP0200_USER_CHECK(3), PR_CHECK_MNU_BTN_AUTH(2), SSP0022_GET_ITEM_POPUP(2), P_INCOTERMS(2), P_TRANSPORT_MODE(2), P_REAL_FLAG(2), P_NON_CHK(2), P_SSP0022_GET_SHIPMENT_PSI(2), P_SSP0022_GET_STOCK_DETAIL(2), P_SSP0022_GET_REQUEST_DETAIL_EXCEL_DOWN(2), P_SSP0022_GET_SHEET_CALENDAR_3SPAN(2), P_SSP0022_GET_ITEM_POPUP(2), PKG_DM0003(2), P_SSP0002_GET_USER_INFO_LIST(2), SSP0002_GET_USER_INFO_LIST(2), PR_GET_EXCEL_UPLOAD_RESULT(1), P_FROM(1), P_MY_MODEL_CHK(1), P_SSP0022_GET_REQUEST_DETAIL(1), P_SSP0022_GET_BOD_ITEM_VALID_CHECK(1), DM0003_GET_BUCKET_TYPE_CODE(1), P_SSP0022_SHIPMENT_REQUEST_EXCEL_UPLOAD(1), P_ACTIVE_FLAG(1), P_DIVISION_ID(1), P_COMPANY_ID(1), P_SCM_SITE_ID(1), P_PLANT_ID(1), P_MODEL_ID(1), P_FROM_SITE(1), P_TO_SITE(1), P_ETA_DATE(1), P_BOD_ID(1), P_CREATED_BY(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
(없음)

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

