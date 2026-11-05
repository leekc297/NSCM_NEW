# SSP0022 — To-Be Fact Pack 요약

- page_key: `shipping/shipment-request-electrode` · feature: shipping · As-is Fact Pack 있음
- 파일 19 · 엔드포인트 호출 15 (미해결 1, 주석 속 0) · 이벤트 54 · 컴포넌트 사용 97 · 하드코딩 컬럼 3 · 메시지 47
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 사용 · 하드코딩 컬럼 정의 3건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/shipping/src/pages/shipment-request-electrode/components/ExcelUploadModal.module.scss | component | 47 |
| features/shipping/src/pages/shipment-request-electrode/components/ExcelUploadModal.tsx | component | 308 |
| features/shipping/src/pages/shipment-request-electrode/components/ShipmentRequestElectrodeDetailBar.tsx | component | 128 |
| features/shipping/src/pages/shipment-request-electrode/components/ShipmentRequestElectrodeDetailGrid.tsx | component | 97 |
| features/shipping/src/pages/shipment-request-electrode/components/ShipmentRequestElectrodeForm.module.scss | component | 29 |
| features/shipping/src/pages/shipment-request-electrode/components/ShipmentRequestElectrodeForm.tsx | component | 406 |
| features/shipping/src/pages/shipment-request-electrode/components/ShipmentRequestElectrodeMainGrid.tsx | component | 349 |
| features/shipping/src/pages/shipment-request-electrode/components/ShipmentRequestElectrodeStockGrid.tsx | component | 44 |
| features/shipping/src/pages/shipment-request-electrode/index.ts | index | 2 |
| features/shipping/src/pages/shipment-request-electrode/shipment-request-electrode.constants.ts | constants | 211 |
| features/shipping/src/pages/shipment-request-electrode/shipment-request-electrode.types.ts | types | 58 |
| features/shipping/src/pages/shipment-request-electrode/ShipmentRequestElectrode.module.scss | style | 25 |
| features/shipping/src/pages/shipment-request-electrode/ShipmentRequestElectrode.tsx | page | 678 |
| features/shipping/src/pages/shipment-request-electrode/useShipmentRequestElectrodeStore.ts | store | 394 |
| features/shipping/src/pages/shipment-request-electrode/utils/shipment-request-electrode.dynamicColumn.ts | util | 76 |
| features/shipping/src/pages/shipment-request-electrode/utils/shipment-request-electrode.editLock.ts | util | 33 |
| features/shipping/src/pages/shipment-request-electrode/utils/shipment-request-electrode.footerSum.ts | util | 78 |
| features/shipping/src/pages/shipment-request-electrode/utils/shipment-request-electrode.save.ts | util | 200 |
| features/shipping/src/pages/shipment-request-electrode/utils/shipment-request-electrode.spreadHeader.ts | util | 235 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| /SSP0022/{sheetName}/EXCEL/excel-upload | http | 1 | N | ExcelUploadModal.tsx:133 |
| (useTabComboQueries) | hook | 4 | Y | ShipmentRequestElectrodeForm.tsx:59 ShipmentRequestElectrodeForm.tsx:68 ShipmentRequestElectrodeForm.tsx:72 ShipmentRequestElectrodeForm.tsx:76 |
| SSP0022/main//call-proc | hook | 1 | Y | ShipmentRequestElectrode.tsx:134 |
| SSP0022/requestDetail//call-proc | hook | 1 | Y | ShipmentRequestElectrode.tsx:141 |
| SSP0022/stockDetail//call-proc | hook | 1 | Y | ShipmentRequestElectrode.tsx:151 |
| SSP0022/spreadTitle//call-proc | hook | 1 | Y | ShipmentRequestElectrode.tsx:163 |
| SSP0022/requestDetailExcel//call-proc | hook | 1 | Y | ShipmentRequestElectrode.tsx:213 |
| /SSP0022/main/EXCEL/call-proc | http | 1 | Y | ShipmentRequestElectrode.tsx:437 |
| /admin/menu/SSP0022/search-conditions | http | 1 | Y | useShipmentRequestElectrodeStore.ts:147 |
| /admin/menu/SSP0022/column | http | 1 | Y | useShipmentRequestElectrodeStore.ts:358 |
| /admin/menu/SSP0022/measure | http | 1 | Y | useShipmentRequestElectrodeStore.ts:374 |
| /SSP0022/main/SAVE/call-proc | http | 1 | Y | shipment-request-electrode.save.ts:189 |

## 3. procedures.d.ts 등재 시트
| sheet | request_keys | response_cursors | sp_hints |
|---|---|---|---|
| main | divisionId companyId plantId cellType planStartYyyymmdd fromYyyymmdd toYyyymmdd modelId itemId nickName sesUserId mnuId sheetName realFlag myModelChk partLeaderChk teamLeaderChk delegateChk nonChk | o_rc1 | PKG_SSP0022 PKG_DM0003 PKG_SSP0002 P_SSP0022_GET_SHIPMENT_PSI P_SSP0022_GET_REQUEST_DETAIL P_SSP0022_GET_STOCK_DETAIL P_SSP0022_GET_REQUEST_DETAIL_EXCEL_DOWN P_SSP0022_GET_SHEET_CALENDAR_3SPAN P_SSP0022_GET_ITEM_POPUP |
| requestDetail | divisionId companyId modelId itemId nickName fromYyyymmdd toYyyymmdd sesUserId mnuId | o_rc1 | PKG_SSP0022 PKG_DM0003 PKG_SSP0002 P_SSP0022_GET_SHIPMENT_PSI P_SSP0022_GET_REQUEST_DETAIL P_SSP0022_GET_STOCK_DETAIL P_SSP0022_GET_REQUEST_DETAIL_EXCEL_DOWN P_SSP0022_GET_SHEET_CALENDAR_3SPAN P_SSP0022_GET_ITEM_POPUP |
| stockDetail | divisionId companyId planStartYyyymmdd plantId cellType modelId itemId lotId sesUserId mnuId | o_rc1 | PKG_SSP0022 PKG_DM0003 PKG_SSP0002 P_SSP0022_GET_SHIPMENT_PSI P_SSP0022_GET_REQUEST_DETAIL P_SSP0022_GET_STOCK_DETAIL P_SSP0022_GET_REQUEST_DETAIL_EXCEL_DOWN P_SSP0022_GET_SHEET_CALENDAR_3SPAN P_SSP0022_GET_ITEM_POPUP |
| requestDetailExcel | divisionId companyId modelId itemId sesUserId mnuId | o_rc1 | PKG_SSP0022 PKG_DM0003 PKG_SSP0002 P_SSP0022_GET_SHIPMENT_PSI P_SSP0022_GET_REQUEST_DETAIL P_SSP0022_GET_STOCK_DETAIL P_SSP0022_GET_REQUEST_DETAIL_EXCEL_DOWN P_SSP0022_GET_SHEET_CALENDAR_3SPAN P_SSP0022_GET_ITEM_POPUP |
| spreadTitle | fromYyyymmdd toYyyymmdd | o_rc1 | PKG_SSP0022 PKG_DM0003 PKG_SSP0002 P_SSP0022_GET_SHIPMENT_PSI P_SSP0022_GET_REQUEST_DETAIL P_SSP0022_GET_STOCK_DETAIL P_SSP0022_GET_REQUEST_DETAIL_EXCEL_DOWN P_SSP0022_GET_SHEET_CALENDAR_3SPAN P_SSP0022_GET_ITEM_POPUP |
| bodItemPopup | divisionId modelId itemId sesUserId | o_rc1 | PKG_SSP0022 PKG_DM0003 PKG_SSP0002 P_SSP0022_GET_SHIPMENT_PSI P_SSP0022_GET_REQUEST_DETAIL P_SSP0022_GET_STOCK_DETAIL P_SSP0022_GET_REQUEST_DETAIL_EXCEL_DOWN P_SSP0022_GET_SHEET_CALENDAR_3SPAN P_SSP0022_GET_ITEM_POPUP |

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| FileUploader | onFileChange | <arrow> setAlert,t,setFiles,value.slice,resetResult | jsx | features/shipping/src/pages/shipment-request-electrode/components/ExcelUploadModal.tsx | 231 |
| Button | onClick | <arrow> handleValidate | jsx | features/shipping/src/pages/shipment-request-electrode/components/ExcelUploadModal.tsx | 255 |
| Button | onClick | <arrow> handleSave | jsx | features/shipping/src/pages/shipment-request-electrode/components/ExcelUploadModal.tsx | 263 |
| Button | onClick | handleClose | jsx | features/shipping/src/pages/shipment-request-electrode/components/ExcelUploadModal.tsx | 267 |
| PeriodRangePicker | onChange | <arrow> setSearchParams | jsx | features/shipping/src/pages/shipment-request-electrode/components/ShipmentRequestElectrodeDetailBar.tsx | 55 |
| InputField | onChange | <arrow> setSearchParams | jsx | features/shipping/src/pages/shipment-request-electrode/components/ShipmentRequestElectrodeDetailBar.tsx | 78 |
| Button | onClick | onItemSearch2 | jsx | features/shipping/src/pages/shipment-request-electrode/components/ShipmentRequestElectrodeDetailBar.tsx | 74 |
| InputField | onChange | <arrow> setSearchParams | jsx | features/shipping/src/pages/shipment-request-electrode/components/ShipmentRequestElectrodeDetailBar.tsx | 104 |
| Button | onClick | onModelSearch2 | jsx | features/shipping/src/pages/shipment-request-electrode/components/ShipmentRequestElectrodeDetailBar.tsx | 100 |
| InputField | onChange | <arrow> setSearchParams | jsx | features/shipping/src/pages/shipment-request-electrode/components/ShipmentRequestElectrodeDetailBar.tsx | 117 |
| Button | onClick | onDetailSearch | jsx | features/shipping/src/pages/shipment-request-electrode/components/ShipmentRequestElectrodeDetailBar.tsx | 122 |
| DataGrid | gotFocus | onFocus | jsx | features/shipping/src/pages/shipment-request-electrode/components/ShipmentRequestElectrodeDetailGrid.tsx | 91 |
| DataGrid | beginningEdit | handleBeginningEdit | jsx | features/shipping/src/pages/shipment-request-electrode/components/ShipmentRequestElectrodeDetailGrid.tsx | 93 |
| SearchArea | onSearch | onSearch | jsx | features/shipping/src/pages/shipment-request-electrode/components/ShipmentRequestElectrodeForm.tsx | 140 |
| CustomDropdown | onChange | <arrow> handleDivisionChange | jsx | features/shipping/src/pages/shipment-request-electrode/components/ShipmentRequestElectrodeForm.tsx | 160 |
| CustomDropdown | onChange | <arrow> handleCompanyChange | jsx | features/shipping/src/pages/shipment-request-electrode/components/ShipmentRequestElectrodeForm.tsx | 175 |
| CustomDropdown | onChange | <arrow> setSearchParams,option.split(',').filter,option.split | jsx | features/shipping/src/pages/shipment-request-electrode/components/ShipmentRequestElectrodeForm.tsx | 194 |
| CustomDropdown | onChange | <arrow> setSearchParams,option.split(',').filter,option.split | jsx | features/shipping/src/pages/shipment-request-electrode/components/ShipmentRequestElectrodeForm.tsx | 217 |
| CustomDropdown | onChange | <arrow> setSearchParams | jsx | features/shipping/src/pages/shipment-request-electrode/components/ShipmentRequestElectrodeForm.tsx | 233 |
| CustomDropdown | onChange | <arrow> handlePlanDateChange | jsx | features/shipping/src/pages/shipment-request-electrode/components/ShipmentRequestElectrodeForm.tsx | 253 |
| PeriodField | onChange | <arrow> setSearchParams | jsx | features/shipping/src/pages/shipment-request-electrode/components/ShipmentRequestElectrodeForm.tsx | 267 |
| InputField | onChange | <arrow> setSearchParams | jsx | features/shipping/src/pages/shipment-request-electrode/components/ShipmentRequestElectrodeForm.tsx | 291 |
| Button | onClick | onItemSearch | jsx | features/shipping/src/pages/shipment-request-electrode/components/ShipmentRequestElectrodeForm.tsx | 287 |
| InputField | onChange | <arrow> setSearchParams | jsx | features/shipping/src/pages/shipment-request-electrode/components/ShipmentRequestElectrodeForm.tsx | 319 |
| Button | onClick | onModelSearch | jsx | features/shipping/src/pages/shipment-request-electrode/components/ShipmentRequestElectrodeForm.tsx | 315 |
| input | onChange | <arrow> setBohMode | jsx | features/shipping/src/pages/shipment-request-electrode/components/ShipmentRequestElectrodeForm.tsx | 340 |
| Checkbox | onChange | <arrow> setSearchParams | jsx | features/shipping/src/pages/shipment-request-electrode/components/ShipmentRequestElectrodeForm.tsx | 372 |
| Checkbox | onChange | <arrow> setSearchParams | jsx | features/shipping/src/pages/shipment-request-electrode/components/ShipmentRequestElectrodeForm.tsx | 377 |
| Checkbox | onChange | <arrow> setSearchParams | jsx | features/shipping/src/pages/shipment-request-electrode/components/ShipmentRequestElectrodeForm.tsx | 382 |
| Checkbox | onChange | <arrow> setSearchParams | jsx | features/shipping/src/pages/shipment-request-electrode/components/ShipmentRequestElectrodeForm.tsx | 387 |
| Checkbox | onChange | <arrow> setSearchParams | jsx | features/shipping/src/pages/shipment-request-electrode/components/ShipmentRequestElectrodeForm.tsx | 392 |
| Checkbox | onChange | <arrow> setSearchParams | jsx | features/shipping/src/pages/shipment-request-electrode/components/ShipmentRequestElectrodeForm.tsx | 397 |
| g | updatedLayout | applyBohSumVisibility | addHandler | features/shipping/src/pages/shipment-request-electrode/components/ShipmentRequestElectrodeMainGrid.tsx | 84 |
| g | updatedLayout | applyHeaderHeight | addHandler | features/shipping/src/pages/shipment-request-electrode/components/ShipmentRequestElectrodeMainGrid.tsx | 185 |
| g | formatItem | fmt | addHandler | features/shipping/src/pages/shipment-request-electrode/components/ShipmentRequestElectrodeMainGrid.tsx | 224 |
| g | updatedLayout | applyDynVisibility | addHandler | features/shipping/src/pages/shipment-request-electrode/components/ShipmentRequestElectrodeMainGrid.tsx | 259 |
| g.hostElement | dblclick | dblclickHandler | addEventListener | features/shipping/src/pages/shipment-request-electrode/components/ShipmentRequestElectrodeMainGrid.tsx | 312 |
| DataGrid | gotFocus | onFocus | jsx | features/shipping/src/pages/shipment-request-electrode/components/ShipmentRequestElectrodeMainGrid.tsx | 344 |
| DataGrid | gotFocus | onFocus | jsx | features/shipping/src/pages/shipment-request-electrode/components/ShipmentRequestElectrodeStockGrid.tsx | 40 |
| ShipmentRequestElectrodeForm | onSearch | handleSearch | jsx | features/shipping/src/pages/shipment-request-electrode/ShipmentRequestElectrode.tsx | 504 |
| ShipmentRequestElectrodeForm | onItemSearch | <arrow> setOpenItem | jsx | features/shipping/src/pages/shipment-request-electrode/ShipmentRequestElectrode.tsx | 505 |
| ShipmentRequestElectrodeForm | onModelSearch | <arrow> setOpenModel | jsx | features/shipping/src/pages/shipment-request-electrode/ShipmentRequestElectrode.tsx | 506 |
| ShipmentRequestElectrodeMainGrid | onFocus | <arrow> setActiveGrid | jsx | features/shipping/src/pages/shipment-request-electrode/ShipmentRequestElectrode.tsx | 534 |
| ShipmentRequestElectrodeDetailBar | onDetailSearch | handleDetailSearch | jsx | features/shipping/src/pages/shipment-request-electrode/ShipmentRequestElectrode.tsx | 545 |
| ShipmentRequestElectrodeDetailBar | onItemSearch2 | <arrow> setOpenDetailItem | jsx | features/shipping/src/pages/shipment-request-electrode/ShipmentRequestElectrode.tsx | 546 |
| ShipmentRequestElectrodeDetailBar | onModelSearch2 | <arrow> setOpenDetailModel | jsx | features/shipping/src/pages/shipment-request-electrode/ShipmentRequestElectrode.tsx | 547 |
| TabWrapper | onTabClick | <arrow> setActiveDetailTab | jsx | features/shipping/src/pages/shipment-request-electrode/ShipmentRequestElectrode.tsx | 552 |
| ShipmentRequestElectrodeStockGrid | onFocus | <arrow> setActiveGrid | jsx | features/shipping/src/pages/shipment-request-electrode/ShipmentRequestElectrode.tsx | 562 |
| ShipmentRequestElectrodeDetailGrid | onFocus | <arrow> setActiveGrid | jsx | features/shipping/src/pages/shipment-request-electrode/ShipmentRequestElectrode.tsx | 573 |
| ShipmentRequestElectrodeDetailGrid | onItemCellDoubleClick | handleItemCellDoubleClick | jsx | features/shipping/src/pages/shipment-request-electrode/ShipmentRequestElectrode.tsx | 574 |
| MeasureSelectModal | onApply | <arrow> applyVisibleMeasures,setOpenMeasure | jsx | features/shipping/src/pages/shipment-request-electrode/ShipmentRequestElectrode.tsx | 651 |
| ExcelUploadModal | onSave | handleExcelUploadSave | jsx | features/shipping/src/pages/shipment-request-electrode/ShipmentRequestElectrode.tsx | 666 |
| ExcelUploadModal | onUploaded | <arrow> setActiveDetailTab,handleSearch | jsx | features/shipping/src/pages/shipment-request-electrode/ShipmentRequestElectrode.tsx | 667 |
| g | formatItem | fmt | addHandler | features/shipping/src/pages/shipment-request-electrode/utils/shipment-request-electrode.footerSum.ts | 67 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| FormItem | 16 |
| Grid | 10 |
| Button | 8 |
| CustomDropdown | 6 |
| Checkbox | 6 |
| InputField | 5 |
| DataGrid | 4 |
| FunctionSearchIcon | 4 |
| MaterialByDivisionModal | 4 |
| TextField | 3 |
| Stack | 3 |
| ControlConfirmIcon | 2 |
| Panel | 2 |
| TabItem | 2 |
| CustomDialog | 1 |
| ProgressIndicator | 1 |
| FileUploader | 1 |
| Label | 1 |
| PeriodRangePicker | 1 |
| SearchArea | 1 |
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
| MeasureSelectModal | 1 |
| ExcelUploadModal | 1 |

## 6. 하드코딩 Grid 컬럼
| context | binding | header | width | visible | isReadOnly | dataType | via | file | line |
|---|---|---|---|---|---|---|---|---|---|
| resultColumns | MESSAGE_TEXT | Check | 240 | true |  |  | meta-shape | features/shipping/src/pages/shipment-request-electrode/components/ExcelUploadModal.tsx | 84 |
| resultColumns | `ATTRIBUTE${i + 1}` | label | 110 | true |  |  | meta-map | features/shipping/src/pages/shipment-request-electrode/components/ExcelUploadModal.tsx | 93 |
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
| MSG00323 | 1 |
| MSG00324 | 1 |
| MSG00042 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: SSP0023(15), SSP0026(12), SSP0022(9), SSP0021(3), SSP0015(3), COM0013(2), DMF0082(1), SCP0025(1)
- SP/PKG: PKG_SSP0022(10), P_SSP0022_GET_STOCK_DETAIL(3), P_SSP0022_SAVE_SHIPMENT_REQUEST(3), PKG_DM0003(3), PKG_SSP0002(3), PR_CHECK_MNU_BTN_AUTH(2), P_SSP0022_GET_SHIPMENT_PSI(2), P_SSP0022_GET_REQUEST_DETAIL_EXCEL_DOWN(2), P_SSP0022_GET_SHEET_CALENDAR_3SPAN(2), P_SSP0022_GET_ITEM_POPUP(2), P_PLAN_START_YYYYMMDD(2), P_ITEM_ID(2), PR_GET_EXCEL_UPLOAD_RESULT(1), P_FROM(1), P_SSP0022_GET_REQUEST_DETAIL(1), P_SSP0022_GET_BOD_ITEM_VALID_CHECK(1), P_DM0003_GET_BUCKET_TYPE_CODE(1), P_SSP0002_GET_USER_INFO_LIST(1), P_SSP0022_SHIPMENT_REQUEST_EXCEL_UPLOAD(1), P_NON_CHK(1), P_ACTIVE_FLAG(1), P_DIVISION_ID(1), P_COMPANY_ID(1), P_SCM_SITE_ID(1), P_PLANT_ID(1), P_MODEL_ID(1), P_FROM_SITE(1), P_TO_SITE(1), P_ETA_DATE(1), P_BOD_ID(1), P_INCOTERMS(1), P_TRANSPORT_MODE(1), P_CREATED_BY(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
(없음)

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

