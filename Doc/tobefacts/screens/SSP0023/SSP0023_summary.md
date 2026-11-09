# SSP0023 — To-Be Fact Pack 요약

- page_key: `shipping/shipment-plan-electrode` · feature: shipping · As-is Fact Pack 있음
- 파일 21 · 엔드포인트 호출 26 (미해결 4, 주석 속 4) · 이벤트 62 · 컴포넌트 사용 103 · 하드코딩 컬럼 10 · 메시지 80
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 10건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/shipping/src/pages/shipment-plan-electrode/components/modals/ExcelUploadModal.module.scss | component | 47 |
| features/shipping/src/pages/shipment-plan-electrode/components/modals/ExcelUploadModal.tsx | component | 357 |
| features/shipping/src/pages/shipment-plan-electrode/components/modals/OrderDetailModal.tsx | component | 171 |
| features/shipping/src/pages/shipment-plan-electrode/components/ShipmentPlanElectrodeDetailBar.tsx | component | 249 |
| features/shipping/src/pages/shipment-plan-electrode/components/ShipmentPlanElectrodeDetailGrid.tsx | component | 366 |
| features/shipping/src/pages/shipment-plan-electrode/components/ShipmentPlanElectrodeForm.module.scss | component | 29 |
| features/shipping/src/pages/shipment-plan-electrode/components/ShipmentPlanElectrodeForm.tsx | component | 450 |
| features/shipping/src/pages/shipment-plan-electrode/components/ShipmentPlanElectrodeMainGrid.tsx | component | 693 |
| features/shipping/src/pages/shipment-plan-electrode/index.ts | index | 2 |
| features/shipping/src/pages/shipment-plan-electrode/shipment-plan-electrode.constants.ts | constants | 478 |
| features/shipping/src/pages/shipment-plan-electrode/shipment-plan-electrode.excelForm.ts | other | 39 |
| features/shipping/src/pages/shipment-plan-electrode/shipment-plan-electrode.types.ts | types | 77 |
| features/shipping/src/pages/shipment-plan-electrode/ShipmentPlanElectrode.module.scss | style | 103 |
| features/shipping/src/pages/shipment-plan-electrode/ShipmentPlanElectrode.tsx | page | 1013 |
| features/shipping/src/pages/shipment-plan-electrode/useShipmentPlanElectrodeStore.ts | store | 524 |
| features/shipping/src/pages/shipment-plan-electrode/utils/shipment-plan-electrode.dblClickGuard.ts | util | 49 |
| features/shipping/src/pages/shipment-plan-electrode/utils/shipment-plan-electrode.editLock.ts | util | 134 |
| features/shipping/src/pages/shipment-plan-electrode/utils/shipment-plan-electrode.erpChain.ts | util | 483 |
| features/shipping/src/pages/shipment-plan-electrode/utils/shipment-plan-electrode.merge.ts | util | 71 |
| features/shipping/src/pages/shipment-plan-electrode/utils/shipment-plan-electrode.save.ts | util | 483 |
| features/shipping/src/pages/shipment-plan-electrode/__asis-mapping__.md | mapping | 302 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| /SSP0023/{ADMIN_SHEET_NAME[SHEETS.MAIN]}/UPLOAD/excel-upload | http | 1 | N | ExcelUploadModal.tsx:159 |
| /SSP0023/main/GET_ORDER_DETAIL/call-proc | http,propagated | 2 | Y | OrderDetailModal.tsx:112 |
| (useTabLookupQueries) | hook | 2 | Y | ShipmentPlanElectrodeDetailBar.tsx:60 ShipmentPlanElectrode.tsx:206 |
| (useTabComboQueries) | hook | 1 | Y | ShipmentPlanElectrodeForm.tsx:73 |
| SSP0023/main//call-proc | hook | 1 | Y | ShipmentPlanElectrode.tsx:145 |
| SSP0023/calendar//call-proc | hook | 1 | Y | ShipmentPlanElectrode.tsx:152 |
| SSP0023/planDetail//call-proc | hook | 1 | Y | ShipmentPlanElectrode.tsx:159 |
| SSP0023/stockDetail//call-proc | hook | 1 | Y | ShipmentPlanElectrode.tsx:169 |
| SSP0023/shipmentResult//call-proc | hook | 1 | Y | ShipmentPlanElectrode.tsx:176 |
| /SSP0023/main/SAVE_SHIPMENT_PLAN_SIMU/call-proc | http,propagated | 2 | Y | ShipmentPlanElectrode.tsx:378 |
| /SSP0023/planDetail/SAVE/call-proc | http,propagated | 2 | Y | ShipmentPlanElectrode.tsx:503 |
| {?url} | http | 1 | N | ShipmentPlanElectrode.tsx:550 |
| {?params} | http | 1 | N | ShipmentPlanElectrode.tsx:551 |
| /SSP0023/main/GET_SHIPMENT_PLAN_DETAIL_EXCEL/call-proc | http,propagated | 2 | Y | ShipmentPlanElectrode.tsx:647 |
| /SSP0023/{ADMIN_SHEET_NAME[SHEETS.MAIN]}/UPLOAD_SAVE/call-proc | http | 1 | N | ShipmentPlanElectrode.tsx:697 |
| /admin/menu/SSP0023/column | http,propagated | 2 | Y | useShipmentPlanElectrodeStore.ts:442 |
| /admin/menu/SSP0023/measure | http,propagated | 2 | Y | useShipmentPlanElectrodeStore.ts:469 |
| /admin/menu/SSP0023/search-conditions | http | 1 | Y | useShipmentPlanElectrodeStore.ts:501 |
| /common/web-service/erpIf/call | propagated | 1 | Y | shipment-plan-electrode.erpChain.ts:135 |

## 3. procedures.d.ts 등재 시트
(없음)

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| FileUploader | onFileChange | <arrow> setAlert,t,setFiles,value.slice,resetResult | jsx | features/shipping/src/pages/shipment-plan-electrode/components/modals/ExcelUploadModal.tsx | 287 |
| Button | onClick | <arrow> handleSave | jsx | features/shipping/src/pages/shipment-plan-electrode/components/modals/ExcelUploadModal.tsx | 312 |
| Button | onClick | <arrow> handleClose | jsx | features/shipping/src/pages/shipment-plan-electrode/components/modals/ExcelUploadModal.tsx | 316 |
| Button | onClick | onClose | jsx | features/shipping/src/pages/shipment-plan-electrode/components/modals/OrderDetailModal.tsx | 163 |
| PeriodField | onChange | onShipChange | jsx | features/shipping/src/pages/shipment-plan-electrode/components/ShipmentPlanElectrodeDetailBar.tsx | 85 |
| InputField | onChange | <arrow> set | jsx | features/shipping/src/pages/shipment-plan-electrode/components/ShipmentPlanElectrodeDetailBar.tsx | 113 |
| Button | onClick | onItemSearch2 | jsx | features/shipping/src/pages/shipment-plan-electrode/components/ShipmentPlanElectrodeDetailBar.tsx | 109 |
| InputField | onChange | <arrow> set | jsx | features/shipping/src/pages/shipment-plan-electrode/components/ShipmentPlanElectrodeDetailBar.tsx | 155 |
| Button | onClick | onModelSearch2 | jsx | features/shipping/src/pages/shipment-plan-electrode/components/ShipmentPlanElectrodeDetailBar.tsx | 150 |
| InputField | onChange | <arrow> set | jsx | features/shipping/src/pages/shipment-plan-electrode/components/ShipmentPlanElectrodeDetailBar.tsx | 185 |
| Button | onClick | onRequestorSearch | jsx | features/shipping/src/pages/shipment-plan-electrode/components/ShipmentPlanElectrodeDetailBar.tsx | 181 |
| InputField | onChange | <arrow> set | jsx | features/shipping/src/pages/shipment-plan-electrode/components/ShipmentPlanElectrodeDetailBar.tsx | 203 |
| CustomDropdown | onChange | <arrow> set,str(picked).split(',').filter,str(picked).split,str | jsx | features/shipping/src/pages/shipment-plan-electrode/components/ShipmentPlanElectrodeDetailBar.tsx | 227 |
| Button | onClick | onDetailSearch | jsx | features/shipping/src/pages/shipment-plan-electrode/components/ShipmentPlanElectrodeDetailBar.tsx | 242 |
| g | beginningEdit | beginningEditHandler | addHandler | features/shipping/src/pages/shipment-plan-electrode/components/ShipmentPlanElectrodeDetailGrid.tsx | 111 |
| g | pastingCell | pastingCellHandler | addHandler | features/shipping/src/pages/shipment-plan-electrode/components/ShipmentPlanElectrodeDetailGrid.tsx | 122 |
| g | formatItem | formatItemHandler | addHandler | features/shipping/src/pages/shipment-plan-electrode/components/ShipmentPlanElectrodeDetailGrid.tsx | 137 |
| g | cellEditEnded | cellEditEndedHandler | addHandler | features/shipping/src/pages/shipment-plan-electrode/components/ShipmentPlanElectrodeDetailGrid.tsx | 198 |
| g | pastedCell | cellEditEndedHandler | addHandler | features/shipping/src/pages/shipment-plan-electrode/components/ShipmentPlanElectrodeDetailGrid.tsx | 199 |
| g.hostElement | dblclick | dblClickHandler | addEventListener | features/shipping/src/pages/shipment-plan-electrode/components/ShipmentPlanElectrodeDetailGrid.tsx | 225 |
| g.hostElement | click | clickHandler | addEventListener | features/shipping/src/pages/shipment-plan-electrode/components/ShipmentPlanElectrodeDetailGrid.tsx | 234 |
| g | formatItem | negativeHandler | addHandler | features/shipping/src/pages/shipment-plan-electrode/components/ShipmentPlanElectrodeDetailGrid.tsx | 309 |
| DataGrid | gotFocus | <arrow> setActiveGrid | jsx | features/shipping/src/pages/shipment-plan-electrode/components/ShipmentPlanElectrodeDetailGrid.tsx | 359 |
| SearchArea | onSearch | onSearch | jsx | features/shipping/src/pages/shipment-plan-electrode/components/ShipmentPlanElectrodeForm.tsx | 140 |
| CustomDropdown | onChange | <arrow> str,confirmIfDirtyKey(tabDirtyKey(tabId),'search').then,confirmIfDirtyKey,tabDirtyKey,setDivision | jsx | features/shipping/src/pages/shipment-plan-electrode/components/ShipmentPlanElectrodeForm.tsx | 157 |
| CustomDropdown | onChange | <arrow> setCompany,str | jsx | features/shipping/src/pages/shipment-plan-electrode/components/ShipmentPlanElectrodeForm.tsx | 186 |
| CustomDropdown | onChange | <arrow> set,str(picked).split(',').filter,str(picked).split,str | jsx | features/shipping/src/pages/shipment-plan-electrode/components/ShipmentPlanElectrodeForm.tsx | 208 |
| CustomDropdown | onChange | <arrow> set,str | jsx | features/shipping/src/pages/shipment-plan-electrode/components/ShipmentPlanElectrodeForm.tsx | 226 |
| CustomDropdown | onChange | <arrow> handlePlanDateChange,str | jsx | features/shipping/src/pages/shipment-plan-electrode/components/ShipmentPlanElectrodeForm.tsx | 243 |
| PeriodField | onChange | <arrow> set | jsx | features/shipping/src/pages/shipment-plan-electrode/components/ShipmentPlanElectrodeForm.tsx | 261 |
| InputField | onChange | <arrow> set | jsx | features/shipping/src/pages/shipment-plan-electrode/components/ShipmentPlanElectrodeForm.tsx | 286 |
| Button | onClick | onItemSearch | jsx | features/shipping/src/pages/shipment-plan-electrode/components/ShipmentPlanElectrodeForm.tsx | 282 |
| InputField | onChange | <arrow> set | jsx | features/shipping/src/pages/shipment-plan-electrode/components/ShipmentPlanElectrodeForm.tsx | 325 |
| Button | onClick | onModelSearch | jsx | features/shipping/src/pages/shipment-plan-electrode/components/ShipmentPlanElectrodeForm.tsx | 320 |
| input | onChange | <arrow> setBohRadio | jsx | features/shipping/src/pages/shipment-plan-electrode/components/ShipmentPlanElectrodeForm.tsx | 348 |
| Checkbox | onChange | <arrow> setChkSum | jsx | features/shipping/src/pages/shipment-plan-electrode/components/ShipmentPlanElectrodeForm.tsx | 416 |
| Checkbox | onChange | <arrow> setChkPastPeriod | jsx | features/shipping/src/pages/shipment-plan-electrode/components/ShipmentPlanElectrodeForm.tsx | 421 |
| Checkbox | onChange | <arrow> set | jsx | features/shipping/src/pages/shipment-plan-electrode/components/ShipmentPlanElectrodeForm.tsx | 426 |
| Checkbox | onChange | <arrow> set | jsx | features/shipping/src/pages/shipment-plan-electrode/components/ShipmentPlanElectrodeForm.tsx | 431 |
| Checkbox | onChange | <arrow> set | jsx | features/shipping/src/pages/shipment-plan-electrode/components/ShipmentPlanElectrodeForm.tsx | 436 |
| Checkbox | onChange | <arrow> set | jsx | features/shipping/src/pages/shipment-plan-electrode/components/ShipmentPlanElectrodeForm.tsx | 441 |
| g | updatedLayout | applyMerge | addHandler | features/shipping/src/pages/shipment-plan-electrode/components/ShipmentPlanElectrodeMainGrid.tsx | 340 |
| g | updatedLayout | applyHeaderHeight | addHandler | features/shipping/src/pages/shipment-plan-electrode/components/ShipmentPlanElectrodeMainGrid.tsx | 369 |
| g | beginningEdit | beginningEditHandler | addHandler | features/shipping/src/pages/shipment-plan-electrode/components/ShipmentPlanElectrodeMainGrid.tsx | 392 |
| g | formatItem | formatItemHandler | addHandler | features/shipping/src/pages/shipment-plan-electrode/components/ShipmentPlanElectrodeMainGrid.tsx | 548 |
| g | pastingCell | pastingCellHandler | addHandler | features/shipping/src/pages/shipment-plan-electrode/components/ShipmentPlanElectrodeMainGrid.tsx | 567 |
| g | cellEditEnded | onEdited | addHandler | features/shipping/src/pages/shipment-plan-electrode/components/ShipmentPlanElectrodeMainGrid.tsx | 572 |
| g | pastedCell | onEdited | addHandler | features/shipping/src/pages/shipment-plan-electrode/components/ShipmentPlanElectrodeMainGrid.tsx | 573 |
| g.hostElement | dblclick | dblClickHandler | addEventListener | features/shipping/src/pages/shipment-plan-electrode/components/ShipmentPlanElectrodeMainGrid.tsx | 633 |
| g.hostElement | click | clickHandler | addEventListener | features/shipping/src/pages/shipment-plan-electrode/components/ShipmentPlanElectrodeMainGrid.tsx | 643 |
| ShipmentPlanElectrodeForm | onSearch | handleSearch | jsx | features/shipping/src/pages/shipment-plan-electrode/ShipmentPlanElectrode.tsx | 791 |
| ShipmentPlanElectrodeForm | onItemSearch | <arrow> setOpenItem | jsx | features/shipping/src/pages/shipment-plan-electrode/ShipmentPlanElectrode.tsx | 792 |
| ShipmentPlanElectrodeForm | onModelSearch | <arrow> setOpenModel | jsx | features/shipping/src/pages/shipment-plan-electrode/ShipmentPlanElectrode.tsx | 793 |
| ShipmentPlanElectrodeMainGrid | onConfirmDrilldown | handleConfirmDrilldown | jsx | features/shipping/src/pages/shipment-plan-electrode/ShipmentPlanElectrode.tsx | 831 |
| ShipmentPlanElectrodeDetailBar | onDetailSearch | handleDetailSearch | jsx | features/shipping/src/pages/shipment-plan-electrode/ShipmentPlanElectrode.tsx | 841 |
| ShipmentPlanElectrodeDetailBar | onItemSearch2 | <arrow> setOpenDetailItem | jsx | features/shipping/src/pages/shipment-plan-electrode/ShipmentPlanElectrode.tsx | 842 |
| ShipmentPlanElectrodeDetailBar | onModelSearch2 | <arrow> setOpenDetailModel | jsx | features/shipping/src/pages/shipment-plan-electrode/ShipmentPlanElectrode.tsx | 843 |
| ShipmentPlanElectrodeDetailBar | onRequestorSearch | <arrow> setOpenRequestor | jsx | features/shipping/src/pages/shipment-plan-electrode/ShipmentPlanElectrode.tsx | 844 |
| ShipmentPlanElectrodeDetailGrid | onOrderDetail | setOrderDetailCtx | jsx | features/shipping/src/pages/shipment-plan-electrode/ShipmentPlanElectrode.tsx | 863 |
| MeasureSelectModal | onApply | <arrow> applyVisibleMeasures,saveTitleSet({menuId:MENU_ID,sheetName:ADMIN_SHEET_NAME[SHEETS.MAIN]??'',columnType:TITLESET_MEASURE_TYPE,rows:(codes??[]).map((name,i)=>({name,sortOrderNo:i+1})),}).then,saveTitleSet,(codes??[]).map,setAlert,t | jsx | features/shipping/src/pages/shipment-plan-electrode/ShipmentPlanElectrode.tsx | 974 |
| ExcelUploadModal | onSave | handleExcelUploadSave | jsx | features/shipping/src/pages/shipment-plan-electrode/ShipmentPlanElectrode.tsx | 1001 |
| OrderDetailModal | onClose | <arrow> setOrderDetailCtx | jsx | features/shipping/src/pages/shipment-plan-electrode/ShipmentPlanElectrode.tsx | 1008 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| FormItem | 17 |
| Button | 9 |
| Grid | 9 |
| InputField | 6 |
| CustomDropdown | 6 |
| Checkbox | 6 |
| FunctionSearchIcon | 5 |
| DataGrid | 4 |
| MaterialByDivisionModal | 4 |
| TextField | 3 |
| Box | 3 |
| Stack | 3 |
| CustomDialog | 2 |
| PeriodField | 2 |
| Panel | 2 |
| ProgressIndicator | 1 |
| FileUploader | 1 |
| ControlConfirmIcon | 1 |
| Label | 1 |
| TabWrapper | 1 |
| TabItem | 1 |
| SearchArea | 1 |
| IcMeasureSelect | 1 |
| FileExceldownloadIcon | 1 |
| FileExceluploadIcon | 1 |
| MainTitle | 1 |
| ShipmentPlanElectrodeForm | 1 |
| SubTitle | 1 |
| PanelGroup | 1 |
| ShipmentPlanElectrodeMainGrid | 1 |
| PanelSeparator | 1 |
| ShipmentPlanElectrodeDetailBar | 1 |
| ShipmentPlanElectrodeDetailGrid | 1 |
| SsoUserModal | 1 |
| MeasureSelectModal | 1 |
| ExcelUploadModal | 1 |
| OrderDetailModal | 1 |

## 6. 하드코딩 Grid 컬럼
| context | binding | header | width | visible | isReadOnly | dataType | via | file | line |
|---|---|---|---|---|---|---|---|---|---|
| RESULT_COLUMNS | MESSAGE_TEXT | Check | 240 | true |  |  | meta-shape | features/shipping/src/pages/shipment-plan-electrode/components/modals/ExcelUploadModal.tsx | 80 |
| RESULT_COLUMNS | `ATTRIBUTE${i + 1}` | label | 110 | true |  |  | meta-map | features/shipping/src/pages/shipment-plan-electrode/components/modals/ExcelUploadModal.tsx | 89 |
| ORDER_DETAIL_COLUMNS | SO_NO | PO NO. | 120 | true |  |  | meta-shape | features/shipping/src/pages/shipment-plan-electrode/components/modals/OrderDetailModal.tsx | 51 |
| ORDER_DETAIL_COLUMNS | SO_ITEM_NO | PO Item No. | 100 | true |  |  | meta-shape | features/shipping/src/pages/shipment-plan-electrode/components/modals/OrderDetailModal.tsx | 52 |
| ORDER_DETAIL_COLUMNS | SO_ITEM_QTY | PO Item Qty | 110 | true |  |  | meta-shape | features/shipping/src/pages/shipment-plan-electrode/components/modals/OrderDetailModal.tsx | 60 |
| ORDER_DETAIL_COLUMNS | DO_NO | DO NO. | 120 | true |  |  | meta-shape | features/shipping/src/pages/shipment-plan-electrode/components/modals/OrderDetailModal.tsx | 68 |
| ORDER_DETAIL_COLUMNS | DO_ITEM_NO | DO Item No. | 100 | true |  |  | meta-shape | features/shipping/src/pages/shipment-plan-electrode/components/modals/OrderDetailModal.tsx | 69 |
| ORDER_DETAIL_COLUMNS | DO_ITEM_QTY | DO Item Qty. | 110 | true |  |  | meta-shape | features/shipping/src/pages/shipment-plan-electrode/components/modals/OrderDetailModal.tsx | 77 |
| ORDER_DETAIL_COLUMNS | CONFIRM_ID | Confirm ID | 130 | true |  |  | meta-shape | features/shipping/src/pages/shipment-plan-electrode/components/modals/OrderDetailModal.tsx | 85 |
| dynamicColumns | m.binding | m.bucket === 'D' ? m.leaf \|\| 'SUM' : 'SUM' | 80 | isDynColVisible( m.binding, m.span, bucketType, chkSumRef.cu |  |  | object | features/shipping/src/pages/shipment-plan-electrode/components/ShipmentPlanElectrodeMainGrid.tsx | 215 |

## 7. 메시지 코드
| code | count |
|---|---|
| MSG00684 | 1 |
| MSG01475 | 1 |
| MSG00618 | 5 |
| MSG00657 | 1 |
| MSG00152 | 1 |
| MSG00659 | 1 |
| MSG00002 | 2 |
| MSG01401 | 1 |
| MSG01321 | 1 |
| MSG00429 | 1 |
| MSG01291 | 1 |
| MSG01289 | 1 |
| MSG00013 | 1 |
| MSG01244 | 1 |
| MSG00284 | 1 |
| MSG01185 | 1 |
| MSG00225 | 1 |
| MSG01295 | 1 |
| MSG01201 | 1 |
| MSG00133 | 1 |
| MSG00004 | 1 |
| MSG00703 | 1 |
| MSG01206 | 1 |
| MSG01081 | 1 |
| MSG01290 | 1 |
| MSG01322 | 1 |
| MSG00003 | 1 |
| MSG01258 | 1 |
| MSG01259 | 1 |
| MSG01202 | 1 |
| MSG01257 | 1 |
| MSG01395 | 1 |
| MSG01125 | 1 |
| MSG01275 | 1 |
| MSG01208 | 1 |
| MSG01215 | 1 |
| LBL00001 | 1 |
| LBL00047 | 1 |
| LBL00022 | 1 |
| LBL00039 | 1 |
| LBL00710 | 1 |
| LBL00021 | 1 |
| LBL00618 | 1 |
| LBL00767 | 1 |
| LBL00013 | 1 |
| LBL01093 | 1 |
| LBL01101 | 1 |
| LBL01124 | 1 |
| LBL01070 | 1 |
| LBL01109 | 1 |
| LBL01108 | 1 |
| LBL00112 | 1 |
| LBL00664 | 1 |
| LBL00783 | 1 |
| LBL01028 | 1 |
| LBL00627 | 1 |
| LBL00716 | 1 |
| LBL00310 | 1 |
| LBL01119 | 1 |
| LBL00762 | 1 |
| LBL00346 | 1 |
| LBL00759 | 1 |
| LBL00754 | 1 |
| LBL00755 | 1 |
| LBL00756 | 1 |
| LBL00757 | 1 |
| LBL00107 | 1 |
| LBL01115 | 1 |
| LBL00687 | 1 |
| LBL01126 | 1 |
| LBL01059 | 1 |
| LBL01099 | 1 |
| LBL01090 | 1 |
| LBL01127 | 1 |
| MSG00265 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: SSP0023(19), SSP0060(17), SSP0015(13), SSP0300(6), SCP0005(5), SSP0200(4), SSP0021(4), SCP0048(3), DMF0074(1), COM0013(1), SCP0025(1), SCP0132(1)
- SP/PKG: PKG_SSP0023(14), P_SHIP_PLAN_SIMU_ETD(7), P_SSP0023_SAVE_SHIPMENT_REQUEST_CONFIRM(4), P_SSP0023_SHIPMENT_PLAN_EXCEL_UPLOAD(3), P_ITEM_ID(3), P_NICK_NAME(3), P_SSP0300_GET_ORDER_DETAIL(2), P_DIVISION_ID(2), P_SHIP_CONFIRM_ETD(2), PKG_SSP0003(2), P_SSP0003_SAVE_REQ_IF_CHECK(2), SSP0023_GET_SHIPMENT_PLAN_DETAIL_EXCEL(2), P_SSP0023_GET_SHIPMENT_PLAN(2), P_MODEL_ID(2), PR_GET_EXCEL_UPLOAD_RESULT(1), P_ERP_SO_NO(1), P_CONFIRM_ID(1), P_SSP0023_GET_SHEET_CALENDAR_3SPAN(1), P_SSP0023_GET_STATUS(1), P_SSP0023_GET_SO_CNT(1), P_SSP0023_SAVE_DRAFTING(1), P_SSP0003_GET_IF_CHECK(1), SSP0023_SAVE_SHIPMENT_REQUEST_DRAFTING(1), PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH(1), P_MY_MODEL_CHK(1), P_PART_LEADER_CHK(1), P_TEAM_LEADER_CHK(1), P_DELEGATEE_CHK(1), P_LOT_ID(1), P_REQUESTOR(1), SSP0023_SAVE_SHIPMENT_PLAN_SIMU(1), P_SSP0023_SAVE_SIMU(1), P_SSP0023_GET_PLAN_DETAIL_EXCEL(1), P_SSP0023_GET_SHIPMENT_PLAN_DETAIL_EXCEL(1), P_PROGRAM_ID(1), P_SHEET_NAME(1), P_CREATED_BY(1), P_DBL_FLAG(1), P_NON_CHK(1), PR_GET_SHEET_MEASURE_LIST(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| code | const saved = await onSave(); | features/shipping/src/pages/shipment-plan-electrode/components/modals/ExcelUploadModal.tsx | 199 |
| code | }); | features/shipping/src/pages/shipment-plan-electrode/components/modals/ExcelUploadModal.tsx | 204 |
| code | }); | features/shipping/src/pages/shipment-plan-electrode/components/modals/ExcelUploadModal.tsx | 211 |
| code | onUploaded(); | features/shipping/src/pages/shipment-plan-electrode/components/modals/ExcelUploadModal.tsx | 212 |
| code | handleClose(); | features/shipping/src/pages/shipment-plan-electrode/components/modals/ExcelUploadModal.tsx | 213 |
| jsx | <FunctionSearchIcon appearance='lined' onClick={onModelSearch2} /> | features/shipping/src/pages/shipment-plan-electrode/components/ShipmentPlanElectrodeDetailBar.tsx | 143 |
| code | 클릭 — 더블클릭 가드 기록 전용. early return 보다 먼저 track() 한다(헤더·빈영역도 null 기록해야 | features/shipping/src/pages/shipment-plan-electrode/components/ShipmentPlanElectrodeDetailGrid.tsx | 227 |
| jsx | <FunctionSearchIcon appearance='lined' onClick={onModelSearch} /> | features/shipping/src/pages/shipment-plan-electrode/components/ShipmentPlanElectrodeForm.tsx | 313 |
| jsx | <Grid size={6}> | features/shipping/src/pages/shipment-plan-electrode/components/ShipmentPlanElectrodeForm.tsx | 363 |
| code | onChange={checked => setChkSum(checked)} | features/shipping/src/pages/shipment-plan-electrode/components/ShipmentPlanElectrodeForm.tsx | 379 |
| code | onChange={checked => setChkPastPeriod(checked)} | features/shipping/src/pages/shipment-plan-electrode/components/ShipmentPlanElectrodeForm.tsx | 384 |
| code | 코드가 없다. 정본 paintNegativeText). 필수: 색 분기 return 앞에서 전 셀에 1회 적용해야 재활용 잔상이 | features/shipping/src/pages/shipment-plan-electrode/components/ShipmentPlanElectrodeMainGrid.tsx | 412 |
| code | 더블클릭 가드 기록은 early return 보다 먼저 한다(헤더·빈 영역 클릭도 null 로 남겨야 오인이 없다). | features/shipping/src/pages/shipment-plan-electrode/components/ShipmentPlanElectrodeMainGrid.tsx | 636 |
| code | - 툴바: Find/Insert/Save = 실동작, Delete = NO-OP `() => undefined`(03 §3.5 — 노출 유지·행삭제 불가), Edit = SwitchLock 미이식(edit default ON). | features/shipping/src/pages/shipment-plan-electrode/shipment-plan-electrode.constants.ts | 12 |
| code | (AS-IS MSG00292) Simulation 저장 시 최신 Plan 아님 경고 — AS-IS 는 경고만 띄우고 저장은 계속 진행(cs:5949~5955, return 없음). | features/shipping/src/pages/shipment-plan-electrode/shipment-plan-electrode.constants.ts | 320 |
| code | 툴바: Find/Save/Insert = 실동작, Delete = NO-OP `() => undefined`(03 §3.5 — 노출 유지, false 숨김 금지), | features/shipping/src/pages/shipment-plan-electrode/ShipmentPlanElectrode.tsx | 64 |
| endpoint | useTabProcQuery(→apiClient.callProc)는 response.result 를 키 정규화 없이 그대로 반환하므로 | features/shipping/src/pages/shipment-plan-electrode/ShipmentPlanElectrode.tsx | 185 |
| endpoint | ── mount — keep-alive 잔여 filters 무효화 + 컬럼/measure 메타 1회 fetch (np §5-7) ── | features/shipping/src/pages/shipment-plan-electrode/ShipmentPlanElectrode.tsx | 224 |
| code | MSG00292 경고 후 저장을 진행하나(cs:5949~5955 return 없음), TO-BE 는 과거 Plan 편집을 editLock 으로 | features/shipping/src/pages/shipment-plan-electrode/ShipmentPlanElectrode.tsx | 308 |
| code | void (async () => { | features/shipping/src/pages/shipment-plan-electrode/ShipmentPlanElectrode.tsx | 349 |
| code | for (const row of payload) { | features/shipping/src/pages/shipment-plan-electrode/ShipmentPlanElectrode.tsx | 351 |
| endpoint | const res = await apiClient.post( | features/shipping/src/pages/shipment-plan-electrode/ShipmentPlanElectrode.tsx | 352 |
| code | ); | features/shipping/src/pages/shipment-plan-electrode/ShipmentPlanElectrode.tsx | 355 |
| code | }); | features/shipping/src/pages/shipment-plan-electrode/ShipmentPlanElectrode.tsx | 361 |
| code | mainEditTrackerRef.current?.clearChanges(); | features/shipping/src/pages/shipment-plan-electrode/ShipmentPlanElectrode.tsx | 365 |
| code | setToast({ type: 'success', message: t(MSG.SAVED, '__Saved successfully.') }); | features/shipping/src/pages/shipment-plan-electrode/ShipmentPlanElectrode.tsx | 366 |
| code | if (filters[SHEETS.MAIN]) void refetchMain(); | features/shipping/src/pages/shipment-plan-electrode/ShipmentPlanElectrode.tsx | 367 |
| code | })(); | features/shipping/src/pages/shipment-plan-electrode/ShipmentPlanElectrode.tsx | 371 |
| code | setSelectedValue={(items, _itemName, _itemClassName, nickName) => { | features/shipping/src/pages/shipment-plan-electrode/ShipmentPlanElectrode.tsx | 894 |
| code | if (items) setSearchCondition({ modelId: items, nickName: nickName ?? '' }); | features/shipping/src/pages/shipment-plan-electrode/ShipmentPlanElectrode.tsx | 895 |
| code | setSelectedValue={(items, _itemName, _itemClassName, nickName) => { | features/shipping/src/pages/shipment-plan-electrode/ShipmentPlanElectrode.tsx | 931 |
| code | if (items) setSearchCondition({ detailModelId: items, detailNickName: nickName ?? '' }); | features/shipping/src/pages/shipment-plan-electrode/ShipmentPlanElectrode.tsx | 932 |
| code | onUploaded={() => { | features/shipping/src/pages/shipment-plan-electrode/ShipmentPlanElectrode.tsx | 998 |
| code | if (filters[SHEETS.MAIN]) void refetchMain(); | features/shipping/src/pages/shipment-plan-electrode/ShipmentPlanElectrode.tsx | 999 |
| endpoint | admin SCM_MST_SHEET_COLUMNS fetch (mount + Search — ui-dynamic-property-management §2.3). | features/shipping/src/pages/shipment-plan-electrode/useShipmentPlanElectrodeStore.ts | 436 |
| code | 사용법: 클릭 핸들러에서 **early return 보다 먼저** track() 을 부른다(헤더·빈 영역 클릭도 null 로 | features/shipping/src/pages/shipment-plan-electrode/utils/shipment-plan-electrode.dblClickGuard.ts | 12 |
| code | if (!tag \|\| tag.span !== ctx.activeSpan \|\| tag.bucket !== 'D') return; | features/shipping/src/pages/shipment-plan-electrode/utils/shipment-plan-electrode.save.ts | 58 |
| code | 값 추출기는 (row)=>string. activeFlag/userId/checkNeedYn 는 아래 collectDetailSaveRows 에서 별도 처리. | features/shipping/src/pages/shipment-plan-electrode/utils/shipment-plan-electrode.save.ts | 117 |

## 10. __asis-mapping__.md 상태
- 구현: 51
- 제외: 34
- 해당없음: 32
| design_id | summary | reason | status |
|---|---|---|---|
| D00-1-002 | §1 Requestor / LayoutControlItem | Requestor 라벨 아이템 — UserInfoPopup(txtRequestor) 미이식으로 필드 미노출(04 excluded, 2026-09-27) | 제외 |
| D00-1-003 | §1 btnExcelUpload / UsrButton | Excel Upload UI 미이식 — AS-IS 엑셀 업로드 affordance(R15b)는 iter-1 범위 외(04 excluded 계열, upload SP 배선 후속). hotkeyConfig.upload=false, SHEETS.EXCEL 조회 배선만 | 제외 |
| D00-1-004 | §1 btnItemId / UsrButton | SCM0002_ItembyDivisionPopup 미이식 — Item 검색 팝업/버튼 미배치(04 excluded, §6) | 제외 |
| D00-1-005 | §1 btnItemId2 / UsrButton | SCM0002_ItembyDivisionPopup 미이식 — Item 검색 팝업/버튼 미배치(04 excluded, §6) | 제외 |
| D00-1-007 | §1 btnRequestor / UsrButton | UserInfoPopup(btnRequestor) 공통 사용자검색 팝업 미이식(04 excluded, §6) | 제외 |
| D00-1-012 | §1 chkDelegateeModel / UsrCheckBox | 검색 SP 파라미터 체크박스 — iter-1 UI 미배치(범위 외, 04 §6 My Model auto-check(R09) 그룹 보류) | 제외 |
| D00-1-013 | §1 chkMyModel / UsrCheckBox | 검색 SP 파라미터 체크박스 — iter-1 UI 미배치(범위 외, 04 §6 R09 auto-check 보류) | 제외 |
| D00-1-014 | §1 chkPartLeader / UsrCheckBox | 검색 SP 파라미터 체크박스 — iter-1 UI 미배치(범위 외, 02 §1 검색 파라미터 그룹) | 제외 |
| D00-1-017 | §1 chkTeamLeader / UsrCheckBox | 검색 SP 파라미터 체크박스 — iter-1 UI 미배치(범위 외, 02 §1 검색 파라미터 그룹) | 제외 |
| D00-1-022 | §1 components / Container | Designer IContainer(WinForms 컴포넌트 컨테이너) — React 대응 없음 | 해당없음 |
| D00-1-026 | §1 emptySpaceItem1 / EmptySpaceItem | Designer 여백 스페이서 — React 대응 없음 | 해당없음 |
| D00-1-027 | §1 emptySpaceItem3 / EmptySpaceItem | Designer 여백 스페이서 — React 대응 없음 | 해당없음 |
| D00-1-028 | §1 emptySpaceItem4 / EmptySpaceItem | Designer 여백 스페이서 — React 대응 없음 | 해당없음 |
| D00-1-029 | §1 emptySpaceItem5 / EmptySpaceItem | Designer 여백 스페이서 — React 대응 없음 | 해당없음 |
| D00-1-030 | §1 formDown / UsrButton | Excel Download 폼 버튼 UI 미이식 — AS-IS 엑셀양식 다운로드(R15a·SP22 GET_..._EXCEL 은 배포됨)이나 iter-1 범위 외(04 excluded 계열, 다운로드 UI 후속) | 제외 |
| D00-1-031 | §1 imageList1 / ImageList | Designer ImageList(WinForms 아이콘 리소스) — React 대응 없음 | 해당없음 |
| D00-1-032 | §1 layoutControlGroup2 / LayoutControlGroup | Designer 레이아웃 그룹 컨테이너 — React 는 SearchArea/Grid 레이아웃으로 흡수 | 해당없음 |
| D00-1-033 | §1 layoutControlGroup3 / LayoutControlGroup | Designer 레이아웃 그룹 컨테이너 — React 는 DetailBar 레이아웃으로 흡수 | 해당없음 |
| D00-1-034 | §1 layoutControlItem1 / LayoutControlItem | Designer 레이아웃 아이템 래퍼 — 실 컨트롤은 별도 채번, 래퍼 자체 대응 없음 | 해당없음 |
| D00-1-035 | §1 layoutControlItem10 / LayoutControlItem | Designer 레이아웃 아이템 래퍼 — 실 컨트롤은 별도 채번, 래퍼 자체 대응 없음 | 해당없음 |
| D00-1-036 | §1 layoutControlItem12 / LayoutControlItem | Designer 레이아웃 아이템 래퍼 — 실 컨트롤은 별도 채번, 래퍼 자체 대응 없음 | 해당없음 |
| D00-1-037 | §1 layoutControlItem15 / LayoutControlItem | Designer 레이아웃 아이템 래퍼 — 실 컨트롤은 별도 채번, 래퍼 자체 대응 없음 | 해당없음 |
| D00-1-038 | §1 layoutControlItem16 / LayoutControlItem | Designer 레이아웃 아이템 래퍼 — 실 컨트롤은 별도 채번, 래퍼 자체 대응 없음 | 해당없음 |
| D00-1-039 | §1 layoutControlItem18 / LayoutControlItem | Designer 레이아웃 아이템 래퍼 — 실 컨트롤은 별도 채번, 래퍼 자체 대응 없음 | 해당없음 |
| D00-1-040 | §1 layoutControlItem19 / LayoutControlItem | Designer 레이아웃 아이템 래퍼 — 실 컨트롤은 별도 채번, 래퍼 자체 대응 없음 | 해당없음 |
| D00-1-041 | §1 layoutControlItem2 / LayoutControlItem | Designer 레이아웃 아이템 래퍼 — 실 컨트롤은 별도 채번, 래퍼 자체 대응 없음 | 해당없음 |
| D00-1-042 | §1 layoutControlItem21 / LayoutControlItem | Designer 레이아웃 아이템 래퍼 — 실 컨트롤은 별도 채번, 래퍼 자체 대응 없음 | 해당없음 |
| D00-1-043 | §1 layoutControlItem22 / LayoutControlItem | Designer 레이아웃 아이템 래퍼 — 실 컨트롤은 별도 채번, 래퍼 자체 대응 없음 | 해당없음 |
| D00-1-044 | §1 layoutControlItem23 / LayoutControlItem | Designer 레이아웃 아이템 래퍼 — 실 컨트롤은 별도 채번, 래퍼 자체 대응 없음 | 해당없음 |
| D00-1-045 | §1 layoutControlItem3 / LayoutControlItem | Designer 레이아웃 아이템 래퍼 — 실 컨트롤은 별도 채번, 래퍼 자체 대응 없음 | 해당없음 |
| D00-1-046 | §1 layoutControlItem4 / LayoutControlItem | Designer 레이아웃 아이템 래퍼 — 실 컨트롤은 별도 채번, 래퍼 자체 대응 없음 | 해당없음 |
| D00-1-047 | §1 layoutControlItem5 / LayoutControlItem | Designer 레이아웃 아이템 래퍼 — 실 컨트롤은 별도 채번, 래퍼 자체 대응 없음 | 해당없음 |
| D00-1-048 | §1 layoutControlItem6 / LayoutControlItem | Designer 레이아웃 아이템 래퍼 — 실 컨트롤은 별도 채번, 래퍼 자체 대응 없음 | 해당없음 |
| D00-1-049 | §1 layoutControlItem7 / LayoutControlItem | Designer 레이아웃 아이템 래퍼 — 실 컨트롤은 별도 채번, 래퍼 자체 대응 없음 | 해당없음 |
| D00-1-050 | §1 layoutControlItem8 / LayoutControlItem | Designer 레이아웃 아이템 래퍼 — 실 컨트롤은 별도 채번, 래퍼 자체 대응 없음 | 해당없음 |
| D00-1-051 | §1 layoutLotId / LayoutControlItem | Lot ID 상세 텍스트필터 라벨 — 초기 Never(숨김)·spdDetail 활성시트 조건부 상세필터(02 §275), iter-1 UI 미배치(범위 외) | 제외 |
| D00-1-052 | §1 layoutMaterialBtn / LayoutControlItem | Item(Material) 팝업 버튼 래퍼 — ItembyDivisionPopup 미이식(04 excluded, §6) | 제외 |
| D00-1-053 | §1 layoutMaterialDetail / LayoutControlItem | Material 상세 텍스트필터 라벨 — spdDetail 활성시트 조건부 상세필터(02 §377), iter-1 UI 미배치(범위 외) | 제외 |
| D00-1-054 | §1 layoutModelDetail / LayoutControlItem | Model 상세 텍스트필터 라벨 — spdDetail 활성시트 조건부 상세필터(02 §377), iter-1 UI 미배치(범위 외) | 제외 |
| D00-1-055 | §1 layoutNickNameDetail / LayoutControlItem | Nick Name 상세 텍스트필터 라벨 — spdDetail 활성시트 조건부 상세필터(02 §377), iter-1 UI 미배치(범위 외) | 제외 |
| D00-1-056 | §1 layoutRequestorBtn / LayoutControlItem | Requestor 팝업 버튼 래퍼 — UserInfoPopup 미이식(04 excluded, §6) | 제외 |
| D00-1-062 | §1 lblCombo1 / LayoutControlItem | Designer 정적 라벨(콤보 헤더) — 실 콤보 FormItem label 로 흡수, 별도 대응 없음 | 해당없음 |
| D00-1-063 | §1 lblItemId / LayoutControlItem | Item ID 라벨 — Item 텍스트 필터/팝업 미노출(04 excluded, §6) | 제외 |
| D00-1-072 | §1 spdSub / FpSpread | siSub 엑셀 다운로드 버퍼 그리드 — AS-IS 엑셀 폼(R15a/b) UI 미이식, iter-1 범위 외(SHEETS.EXCEL 조회 배선만) | 제외 |
| D00-1-073 | §1 spdSub_Sheet1 / SheetView | siSub 엑셀 버퍼 시트 — AS-IS 엑셀 폼 UI 미이식, iter-1 범위 외(SHEETS.EXCEL 조회 배선만) | 제외 |
| D00-1-075 | §1 textNickName / UsrMultiLineEditor | Nick Name 상세 텍스트필터 에디터 — spdDetail 조건부 상세필터(02 §72), iter-1 UI 미배치(범위 외) | 제외 |
| D00-1-076 | §1 txtItem2 / LayoutControlItem | Item 텍스트 필터 라벨 — Item 검색필터/팝업 미노출(04 excluded, §6) | 제외 |
| D00-1-077 | §1 txtItem3 / LayoutControlItem | Item 텍스트 필터 라벨 — Item 검색필터/팝업 미노출(04 excluded, §6) | 제외 |
| D00-1-078 | §1 txtItemId / UsrMultiLineEditor | Item ID 텍스트 검색필터 — Item 필터/팝업 미노출(04 excluded, §6) | 제외 |
| D00-1-079 | §1 txtItemId2 / UsrMultiLineEditor | Item ID 텍스트 검색필터 — Item 필터/팝업 미노출(04 excluded, §6) | 제외 |
| D00-1-080 | §1 txtLotID / UsrMultiLineEditor | Lot ID 상세 텍스트필터 에디터 — 초기 Never(숨김)·spdDetail 활성시트 조건부(02 §275), iter-1 UI 미배치(범위 외) | 제외 |
| D00-1-081 | §1 txtModel2 / UsrMultiLineEditor | Model 상세 텍스트필터 에디터 — spdDetail 조건부 상세필터(02 §377), iter-1 UI 미배치(범위 외) | 제외 |
| D00-1-082 | §1 txtModelId / UsrMultiLineEditor | Model 상세 텍스트필터 에디터 — spdDetail 조건부 상세필터(02 §377), iter-1 UI 미배치(범위 외) | 제외 |
| D00-1-083 | §1 txtNickName2 / UsrMultiLineEditor | Nick Name 상세 텍스트필터 에디터 — spdDetail 조건부 상세필터(02 §72), iter-1 UI 미배치(범위 외) | 제외 |
| D00-1-084 | §1 txtRequestor / UsrTextBox | Requestor 텍스트박스 — UserInfoPopup 결과 채움용, 팝업 미이식으로 미노출(04 excluded, §6) | 제외 |
| D00-1-085 | §1 usrButton1 / UsrButton | Designer 미사용/dead 버튼 — 이벤트 인벤토리(§2)에 핸들러 없음, 대응 없음 | 해당없음 |
| D00-1-087 | §1 usrLabel1 / UsrLabel | Designer 정적 라벨 — 실 라벨은 FormItem 으로 흡수, 별도 대응 없음 | 해당없음 |
| D00-1-088 | §1 usrLayoutControl2 / UsrLayoutControl | Designer 레이아웃 컨트롤 컨테이너 — SearchArea/Form 레이아웃으로 흡수 | 해당없음 |
| D00-2-001 | §2 btnExcelUpload / Click | Excel Upload Click 핸들러 — AS-IS 엑셀 업로드 UI(R15b) 미이식, iter-1 범위 외(D00-1-003 짝) | 제외 |
| D00-2-002 | §2 btnItemId / Click | ItembyDivisionPopup 미이식 — Item 팝업 열기 핸들러 없음(04 excluded, §6) | 제외 |
| D00-2-003 | §2 btnItemId2 / Click | ItembyDivisionPopup 미이식 — Item 팝업 열기 핸들러 없음(04 excluded, §6) | 제외 |
| D00-2-005 | §2 btnRequestor / Click | UserInfoPopup 미이식 — Requestor 팝업 열기 핸들러 없음(04 excluded, §6) | 제외 |
| D00-2-014 | §2 dsdm / Changed | AS-IS DataSet DataMember 바인딩 이벤트 — React SSOT(React Query) 로 대체, 대응 이벤트 없음 | 해당없음 |
| D00-2-015 | §2 formDown / Click | Excel Download Click 핸들러 — AS-IS 엑셀양식 다운로드 UI(R15a) 미이식, iter-1 범위 외(D00-1-030 짝) | 제외 |
| D00-2-020 | §2 spdDetail / CellDoubleClick | Detail 그리드 셀 더블클릭 드릴다운 — AS-IS 는 Main→Detail 방향(setDetailFilter dblFlag='Y', store 55-61); Detail 셀 자체 더블클릭 파생 없음 | 해당없음 |
| D00-2-028 | §2 spdMain / TopChange | AS-IS FpSpread 스크롤 TopChange(가상 스크롤 상단행 동기) — Wijmo DataGrid 가상화 내장, 화면 재현 불요 | 해당없음 |

