# SSP0060 — To-Be Fact Pack 요약

- page_key: `shipping/shipment-plan` · feature: shipping · As-is Fact Pack 있음
- 파일 26 · 엔드포인트 호출 53 (미해결 13, 주석 속 3) · 이벤트 80 · 컴포넌트 사용 101 · 하드코딩 컬럼 4 · 메시지 70
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 4건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/shipping/src/pages/shipment-plan/components/modals/RequestorModal.tsx | component | 121 |
| features/shipping/src/pages/shipment-plan/components/modals/ShipmentRequestModal.tsx | component | 559 |
| features/shipping/src/pages/shipment-plan/components/ShipmentPlanDetailBar.module.scss | component | 22 |
| features/shipping/src/pages/shipment-plan/components/ShipmentPlanDetailBar.tsx | component | 274 |
| features/shipping/src/pages/shipment-plan/components/ShipmentPlanDetailGrid.module.scss | component | 21 |
| features/shipping/src/pages/shipment-plan/components/ShipmentPlanDetailGrid.tsx | component | 752 |
| features/shipping/src/pages/shipment-plan/components/ShipmentPlanForm.tsx | component | 415 |
| features/shipping/src/pages/shipment-plan/components/ShipmentPlanMainGrid.tsx | component | 896 |
| features/shipping/src/pages/shipment-plan/index.ts | index | 2 |
| features/shipping/src/pages/shipment-plan/shipment-plan.constants.ts | constants | 411 |
| features/shipping/src/pages/shipment-plan/shipment-plan.types.ts | types | 48 |
| features/shipping/src/pages/shipment-plan/ShipmentPlan.module.scss | style | 75 |
| features/shipping/src/pages/shipment-plan/ShipmentPlan.tsx | page | 1346 |
| features/shipping/src/pages/shipment-plan/useShipmentPlanStore.ts | store | 485 |
| features/shipping/src/pages/shipment-plan/utils/shipment-plan.calc.test.ts | test | 170 |
| features/shipping/src/pages/shipment-plan/utils/shipment-plan.calc.ts | util | 337 |
| features/shipping/src/pages/shipment-plan/utils/shipment-plan.dblClickGuard.test.ts | test | 75 |
| features/shipping/src/pages/shipment-plan/utils/shipment-plan.dblClickGuard.ts | util | 49 |
| features/shipping/src/pages/shipment-plan/utils/shipment-plan.detailSheets.ts | util | 121 |
| features/shipping/src/pages/shipment-plan/utils/shipment-plan.editLock.test.ts | test | 82 |
| features/shipping/src/pages/shipment-plan/utils/shipment-plan.editLock.ts | util | 163 |
| features/shipping/src/pages/shipment-plan/utils/shipment-plan.erpChain.ts | util | 831 |
| features/shipping/src/pages/shipment-plan/utils/shipment-plan.lookups.ts | util | 204 |
| features/shipping/src/pages/shipment-plan/utils/shipment-plan.save.ts | util | 499 |
| features/shipping/src/pages/shipment-plan/utils/shipment-plan.transMode.ts | util | 93 |
| features/shipping/src/pages/shipment-plan/__asis-mapping__.md | mapping | 634 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueries) | hook | 5 | Y | RequestorModal.tsx:43 ShipmentPlanDetailBar.tsx:58 ShipmentPlanForm.tsx:129 ShipmentPlanForm.tsx:143 shipment-plan.lookups.ts:177 |
| SSP0060/confirmDetail//call-proc | hook | 1 | Y | ShipmentRequestModal.tsx:93 |
| /SSP0060/planDetail/SAVE/call-proc | http,propagated | 6 | Y | ShipmentRequestModal.tsx:277 ShipmentPlan.tsx:444 |
| {?url} | http | 2 | N | ShipmentRequestModal.tsx:342 ShipmentPlan.tsx:472 |
| {?params} | http | 2 | N | ShipmentRequestModal.tsx:343 ShipmentPlan.tsx:473 |
| (useTabLookupQueries) | hook | 3 | Y | ShipmentPlanDetailBar.tsx:57 ShipmentPlan.tsx:313 shipment-plan.lookups.ts:82 |
| SSP0060/division//call-proc | hook | 1 | Y | ShipmentPlanForm.tsx:107 |
| /SSP0060/main/USER_CHECK/call-proc | http,propagated | 3 | Y | ShipmentPlan.tsx:165 |
| SSP0060/main//call-proc | hook | 1 | Y | ShipmentPlan.tsx:235 |
| SSP0060/calendar//call-proc | hook | 1 | Y | ShipmentPlan.tsx:242 |
| SSP0060/planDetail//call-proc | hook | 1 | Y | ShipmentPlan.tsx:249 |
| SSP0060/stockDetail//call-proc | hook | 1 | Y | ShipmentPlan.tsx:259 |
| SSP0060/owmsDetail//call-proc | hook | 1 | Y | ShipmentPlan.tsx:266 |
| SSP0060/holdStock//call-proc | hook | 1 | Y | ShipmentPlan.tsx:273 |
| SSP0060/mesStock//call-proc | hook | 1 | Y | ShipmentPlan.tsx:280 |
| SSP0060/mesStockDetail//call-proc | hook | 1 | Y | ShipmentPlan.tsx:287 |
| SSP0060/shipmentResult//call-proc | hook | 1 | Y | ShipmentPlan.tsx:294 |
| /SSP0060/main/SAVE/call-proc | http,propagated | 3 | Y | ShipmentPlan.tsx:422 |
| /admin/menu/SSP0060/column | http,propagated | 3 | Y | useShipmentPlanStore.ts:388 |
| /admin/menu/SSP0060/search-conditions | http | 1 | Y | useShipmentPlanStore.ts:413 |
| /admin/menu/SSP0060/measure | http,propagated | 3 | Y | useShipmentPlanStore.ts:462 |
| SSP0060/{?deps}/GET_SHIPMENT_STATUS/call-proc | callProc | 1 | N | shipment-plan.erpChain.ts:175 |
| SSP0060/{?deps}/GET_ERP_SO_NO_CNT/call-proc | callProc | 1 | N | shipment-plan.erpChain.ts:231 |
| SSP0060/{?deps}/{?btn}/call-proc | callProc | 1 | N | shipment-plan.erpChain.ts:258 |
| SSP0060/{?deps}/DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM/call-proc | callProc | 1 | N | shipment-plan.erpChain.ts:365 |
| SSP0060/{?deps}/ERP_ERROR_CONFIRM/call-proc | callProc | 1 | N | shipment-plan.erpChain.ts:508 |
| SSP0060/{?deps}/IF_CHECK/call-proc | callProc | 1 | N | shipment-plan.erpChain.ts:607 |
| SSP0060/{?deps}/SAVE_SHIPMENT_REQUEST_DRAFTING/call-proc | callProc | 1 | N | shipment-plan.erpChain.ts:679 |
| SSP0060/{?deps}/SHIP_CONFIRM_CHG_BATCH_NEW_C/call-proc | callProc | 2 | N | shipment-plan.erpChain.ts:808 shipment-plan.erpChain.ts:815 |
| /common/web-service/erpIf/call | propagated | 2 | Y | shipment-plan.erpChain.ts:336 |

## 3. procedures.d.ts 등재 시트
| sheet | request_keys | response_cursors | sp_hints |
|---|---|---|---|
| division | param1 param2 | o_rc1 o_rc2 | P_SSP0060_GET_SHIPMENT_DIVISION PKG_SSP0060 PKG_COM0000 P_SCP0009_GET_SHEET_CALENDAR_3SPAN SSP0060_SAVE_HOLD_STOCK_DATA |
| calendar | startYyyymmdd endYyyymmdd | o_rc1 | PKG_COM0000 P_SCP0009_GET_SHEET_CALENDAR_3SPAN PKG_SSP0060 SSP0060_SAVE_HOLD_STOCK_DATA |
| main | divisionId companyId fromSite planStartYyyymmdd fromYyyymmdd toYyyymmdd itemId productLevel1 userId programId sheetName realFlag | o_rc1 o_rc2 | PKG_SSP0060 PKG_COM0000 P_SCP0009_GET_SHEET_CALENDAR_3SPAN SSP0060_SAVE_HOLD_STOCK_DATA |
| planDetail | divisionId companyId fromSite itemId productLevel1 requestor toSite transportMode incoterms fcstType planStartYyyymmdd fromYyyymmdd toYyyymmdd dblFlag realFlag language programId sheetName debugMode | o_rc1 | P_CHANGE_REQUEST_NO P_CONFIRM_ID P_NEW_ P_REMARKS3 P_CHECK_NEED_YN P_EDIT_MAIN P_TOP_FLAG PKG_SSP0060 PKG_COM0000 P_SCP0009_GET_SHEET_CALENDAR_3SPAN SSP0060_SAVE_HOLD_STOCK_DATA |
| stockDetail | divisionId companyId fromSite itemId productLevel1 planStartYyyymmdd dblFlag language programId sheetName debugMode | o_rc1 | PKG_SSP0060 PKG_COM0000 P_SCP0009_GET_SHEET_CALENDAR_3SPAN SSP0060_SAVE_HOLD_STOCK_DATA |
| owmsDetail | divisionId companyId fromSite itemId productLevel1 planStartYyyymmdd dblFlag language programId sheetName debugMode | o_rc1 | PKG_SSP0060 PKG_COM0000 P_SCP0009_GET_SHEET_CALENDAR_3SPAN SSP0060_SAVE_HOLD_STOCK_DATA |
| holdStock | divisionId fromSite itemId productLevel1 planStartYyyymmdd planType seq language searchYn userId | o_rc1 | PKG_SSP0060 PKG_COM0000 P_SCP0009_GET_SHEET_CALENDAR_3SPAN SSP0060_SAVE_HOLD_STOCK_DATA |
| mesStock | divisionId companyId fromSite itemId productLevel1 planStartYyyymmdd dblFlag language programId sheetName debugMode | o_rc1 | PKG_SSP0060 PKG_COM0000 P_SCP0009_GET_SHEET_CALENDAR_3SPAN SSP0060_SAVE_HOLD_STOCK_DATA |
| mesStockDetail | divisionId companyId fromSite itemId productLevel1 boxId planStartYyyymmdd dblFlag language programId sheetName debugMode | o_rc1 | PKG_SSP0060 PKG_COM0000 P_SCP0009_GET_SHEET_CALENDAR_3SPAN SSP0060_SAVE_HOLD_STOCK_DATA |
| shipmentResult | divisionId fromSite itemId productLevel1 fromYyyymmdd toYyyymmdd type userId companyId myModelChk partLeaderChk teamLeaderChk delegateeChk nonChk realFlag planStartYyyymmdd | o_rc1 | PKG_SSP0060 PKG_COM0000 P_SCP0009_GET_SHEET_CALENDAR_3SPAN SSP0060_SAVE_HOLD_STOCK_DATA |
| confirmDetail | changeRequestNo userId language | o_rc1 o_rc2 | PKG_SSP0060 PKG_COM0000 P_SCP0009_GET_SHEET_CALENDAR_3SPAN SSP0060_SAVE_HOLD_STOCK_DATA |
| requestDraftingMain | activeFlag divisionId changeReqNo confirmId shipmentQty shipmentDate newYyyymmdd newQty userId changeReasonCode changeReasonDetail title programId | o_rc1 o_rc2 | PKG_SSP0060 PKG_COM0000 P_SCP0009_GET_SHEET_CALENDAR_3SPAN SSP0060_SAVE_HOLD_STOCK_DATA |

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| InputField | onChange | <arrow> setKeyword | jsx | features/shipping/src/pages/shipment-plan/components/modals/RequestorModal.tsx | 93 |
| InputField | onKeyDown | <arrow> handleSearch | jsx | features/shipping/src/pages/shipment-plan/components/modals/RequestorModal.tsx | 94 |
| Button | onClick | handleSearch | jsx | features/shipping/src/pages/shipment-plan/components/modals/RequestorModal.tsx | 96 |
| Button | onClick | handleSelect | jsx | features/shipping/src/pages/shipment-plan/components/modals/RequestorModal.tsx | 109 |
| Button | onClick | modalClose | jsx | features/shipping/src/pages/shipment-plan/components/modals/RequestorModal.tsx | 112 |
| g | updatedLayout | applyLayout | addHandler | features/shipping/src/pages/shipment-plan/components/modals/ShipmentRequestModal.tsx | 256 |
| g | beginningEdit | beginningEditHandler | addHandler | features/shipping/src/pages/shipment-plan/components/modals/ShipmentRequestModal.tsx | 257 |
| g | formatItem | formatItemHandler | addHandler | features/shipping/src/pages/shipment-plan/components/modals/ShipmentRequestModal.tsx | 258 |
| Button | onClick | handleAutoSet | jsx | features/shipping/src/pages/shipment-plan/components/modals/ShipmentRequestModal.tsx | 505 |
| CustomDropdown | onChange | <arrow> setAutoReason,str | jsx | features/shipping/src/pages/shipment-plan/components/modals/ShipmentRequestModal.tsx | 524 |
| InputField | onChange | <arrow> setAutoDetail | jsx | features/shipping/src/pages/shipment-plan/components/modals/ShipmentRequestModal.tsx | 535 |
| Button | onClick | <arrow> handleSave | jsx | features/shipping/src/pages/shipment-plan/components/modals/ShipmentRequestModal.tsx | 542 |
| Button | onClick | modalClose | jsx | features/shipping/src/pages/shipment-plan/components/modals/ShipmentRequestModal.tsx | 546 |
| PeriodField | onChange | <arrow> setPeriod2 | jsx | features/shipping/src/pages/shipment-plan/components/ShipmentPlanDetailBar.tsx | 101 |
| PeriodField | onChange | <arrow> set | jsx | features/shipping/src/pages/shipment-plan/components/ShipmentPlanDetailBar.tsx | 112 |
| InputField | onChange | <arrow> set | jsx | features/shipping/src/pages/shipment-plan/components/ShipmentPlanDetailBar.tsx | 138 |
| Button | onClick | onModelSearch | jsx | features/shipping/src/pages/shipment-plan/components/ShipmentPlanDetailBar.tsx | 134 |
| InputField | onChange | <arrow> set | jsx | features/shipping/src/pages/shipment-plan/components/ShipmentPlanDetailBar.tsx | 169 |
| Button | onClick | onRequestorSearch | jsx | features/shipping/src/pages/shipment-plan/components/ShipmentPlanDetailBar.tsx | 165 |
| CustomDropdown | onChange | <arrow> set,str(picked).split(',').filter,str(picked).split,str | jsx | features/shipping/src/pages/shipment-plan/components/ShipmentPlanDetailBar.tsx | 196 |
| CustomDropdown | onChange | <arrow> set,str(picked).split(',').filter,str(picked).split,str | jsx | features/shipping/src/pages/shipment-plan/components/ShipmentPlanDetailBar.tsx | 226 |
| InputField | onChange | <arrow> set | jsx | features/shipping/src/pages/shipment-plan/components/ShipmentPlanDetailBar.tsx | 250 |
| Button | onClick | onNew | jsx | features/shipping/src/pages/shipment-plan/components/ShipmentPlanDetailBar.tsx | 261 |
| Button | onClick | onDetailSearch | jsx | features/shipping/src/pages/shipment-plan/components/ShipmentPlanDetailBar.tsx | 267 |
| g | beginningEdit | beginningEditHandler | addHandler | features/shipping/src/pages/shipment-plan/components/ShipmentPlanDetailGrid.tsx | 189 |
| g | pastingCell | pastingCellHandler | addHandler | features/shipping/src/pages/shipment-plan/components/ShipmentPlanDetailGrid.tsx | 207 |
| g | formatItem | formatItemHandler | addHandler | features/shipping/src/pages/shipment-plan/components/ShipmentPlanDetailGrid.tsx | 257 |
| g | cellEditEnded | cellEditEndedHandler | addHandler | features/shipping/src/pages/shipment-plan/components/ShipmentPlanDetailGrid.tsx | 315 |
| g | pastedCell | cellEditEndedHandler | addHandler | features/shipping/src/pages/shipment-plan/components/ShipmentPlanDetailGrid.tsx | 317 |
| g.hostElement | dblclick | dblClickHandler | addEventListener | features/shipping/src/pages/shipment-plan/components/ShipmentPlanDetailGrid.tsx | 357 |
| g.hostElement | click | clickHandler | addEventListener | features/shipping/src/pages/shipment-plan/components/ShipmentPlanDetailGrid.tsx | 372 |
| g | beginningEdit | editGateHandler | addHandler | features/shipping/src/pages/shipment-plan/components/ShipmentPlanDetailGrid.tsx | 405 |
| g | pastingCell | editGateHandler | addHandler | features/shipping/src/pages/shipment-plan/components/ShipmentPlanDetailGrid.tsx | 406 |
| g | formatItem | formatItemHandler | addHandler | features/shipping/src/pages/shipment-plan/components/ShipmentPlanDetailGrid.tsx | 420 |
| g | updatedLayout | apply | addHandler | features/shipping/src/pages/shipment-plan/components/ShipmentPlanDetailGrid.tsx | 454 |
| g | formatItem | paintNegative | addHandler | features/shipping/src/pages/shipment-plan/components/ShipmentPlanDetailGrid.tsx | 496 |
| g.hostElement? | click | onDetailClick | addEventListener | features/shipping/src/pages/shipment-plan/components/ShipmentPlanDetailGrid.tsx | 521 |
| g | updatedLayout | apply | addHandler | features/shipping/src/pages/shipment-plan/components/ShipmentPlanDetailGrid.tsx | 547 |
| g | updatedLayout | applyAggregates | addHandler | features/shipping/src/pages/shipment-plan/components/ShipmentPlanDetailGrid.tsx | 635 |
| g | updatedLayout | pinFooterToBottom | addHandler | features/shipping/src/pages/shipment-plan/components/ShipmentPlanDetailGrid.tsx | 636 |
| g | updatedLayout | applyHeaderHeight | addHandler | features/shipping/src/pages/shipment-plan/components/ShipmentPlanDetailGrid.tsx | 696 |
| DataGrid | gotFocus | <arrow> setActiveGrid | jsx | features/shipping/src/pages/shipment-plan/components/ShipmentPlanDetailGrid.tsx | 740 |
| SearchArea | onSearch | onSearch | jsx | features/shipping/src/pages/shipment-plan/components/ShipmentPlanForm.tsx | 220 |
| CustomDropdown | onChange | <arrow> str,confirmIfDirtyKey(tabDirtyKey(tabId),'search').then,confirmIfDirtyKey,tabDirtyKey,setDivision | jsx | features/shipping/src/pages/shipment-plan/components/ShipmentPlanForm.tsx | 238 |
| CustomDropdown | onChange | <arrow> str,confirmIfDirtyKey(tabDirtyKey(tabId),'search').then,confirmIfDirtyKey,tabDirtyKey,setCompany | jsx | features/shipping/src/pages/shipment-plan/components/ShipmentPlanForm.tsx | 262 |
| CustomDropdown | onChange | <arrow> set,str(picked).split(',').filter,str(picked).split,str | jsx | features/shipping/src/pages/shipment-plan/components/ShipmentPlanForm.tsx | 288 |
| CustomDropdown | onChange | <arrow> set,str | jsx | features/shipping/src/pages/shipment-plan/components/ShipmentPlanForm.tsx | 310 |
| CustomDropdown | onChange | <arrow> handlePlanDateChange,str | jsx | features/shipping/src/pages/shipment-plan/components/ShipmentPlanForm.tsx | 327 |
| PeriodField | onChange | <arrow> set | jsx | features/shipping/src/pages/shipment-plan/components/ShipmentPlanForm.tsx | 341 |
| InputField | onChange | <arrow> set | jsx | features/shipping/src/pages/shipment-plan/components/ShipmentPlanForm.tsx | 373 |
| Button | onClick | onItemSearch | jsx | features/shipping/src/pages/shipment-plan/components/ShipmentPlanForm.tsx | 363 |
| CustomDropdown | onChange | <arrow> set,str(picked).split(',').filter,str(picked).split,str | jsx | features/shipping/src/pages/shipment-plan/components/ShipmentPlanForm.tsx | 394 |
| g | updatedLayout | applyMerge | addHandler | features/shipping/src/pages/shipment-plan/components/ShipmentPlanMainGrid.tsx | 546 |
| g | updatedLayout | applyHeaderHeight | addHandler | features/shipping/src/pages/shipment-plan/components/ShipmentPlanMainGrid.tsx | 576 |
| g | beginningEdit | beginningEditHandler | addHandler | features/shipping/src/pages/shipment-plan/components/ShipmentPlanMainGrid.tsx | 590 |
| g | formatItem | formatItemHandler | addHandler | features/shipping/src/pages/shipment-plan/components/ShipmentPlanMainGrid.tsx | 691 |
| g | pastingCell | pastingCellHandler | addHandler | features/shipping/src/pages/shipment-plan/components/ShipmentPlanMainGrid.tsx | 706 |
| g | cellEditEnded | recalcCell | addHandler | features/shipping/src/pages/shipment-plan/components/ShipmentPlanMainGrid.tsx | 745 |
| g | pastedCell | recalcCell | addHandler | features/shipping/src/pages/shipment-plan/components/ShipmentPlanMainGrid.tsx | 746 |
| g.hostElement | keydown | deleteKeyHandler | addEventListener | features/shipping/src/pages/shipment-plan/components/ShipmentPlanMainGrid.tsx | 808 |
| g.hostElement | dblclick | dblClickHandler | addEventListener | features/shipping/src/pages/shipment-plan/components/ShipmentPlanMainGrid.tsx | 827 |
| g.hostElement | click | clickHandler | addEventListener | features/shipping/src/pages/shipment-plan/components/ShipmentPlanMainGrid.tsx | 841 |
| ShipmentPlanForm | onSearch | handleSearch | jsx | features/shipping/src/pages/shipment-plan/ShipmentPlan.tsx | 1087 |
| ShipmentPlanForm | onItemSearch | <arrow> setOpenItemMain | jsx | features/shipping/src/pages/shipment-plan/ShipmentPlan.tsx | 1088 |
| Checkbox | onChange | <arrow> set | jsx | features/shipping/src/pages/shipment-plan/ShipmentPlan.tsx | 1114 |
| Checkbox | onChange | <arrow> set | jsx | features/shipping/src/pages/shipment-plan/ShipmentPlan.tsx | 1119 |
| ShipmentPlanMainGrid | onDrilldown | handleMainDrilldown | jsx | features/shipping/src/pages/shipment-plan/ShipmentPlan.tsx | 1148 |
| ShipmentPlanDetailBar | onDetailSearch | handleDetailSearch | jsx | features/shipping/src/pages/shipment-plan/ShipmentPlan.tsx | 1158 |
| ShipmentPlanDetailBar | onNew | handleNew | jsx | features/shipping/src/pages/shipment-plan/ShipmentPlan.tsx | 1159 |
| ShipmentPlanDetailBar | onModelSearch | <arrow> setOpenItemDetailBar | jsx | features/shipping/src/pages/shipment-plan/ShipmentPlan.tsx | 1160 |
| ShipmentPlanDetailBar | onRequestorSearch | <arrow> setOpenRequestor | jsx | features/shipping/src/pages/shipment-plan/ShipmentPlan.tsx | 1161 |
| ShipmentPlanDetailGrid | onItemCellSearch | <arrow> openCellPopup | jsx | features/shipping/src/pages/shipment-plan/ShipmentPlan.tsx | 1173 |
| ShipmentPlanDetailGrid | onProjectCellSearch | <arrow> openCellPopup | jsx | features/shipping/src/pages/shipment-plan/ShipmentPlan.tsx | 1174 |
| ShipmentPlanDetailGrid | onConfirmDetail | setConfirmDetailNo | jsx | features/shipping/src/pages/shipment-plan/ShipmentPlan.tsx | 1175 |
| ShipmentPlanDetailGrid | onOrderDetail | setOrderDetailCtx | jsx | features/shipping/src/pages/shipment-plan/ShipmentPlan.tsx | 1176 |
| ModelByDivisionPopup | onClose | <arrow> setCellPopupKind | jsx | features/shipping/src/pages/shipment-plan/ShipmentPlan.tsx | 1229 |
| ModelByDivisionPopup | onSelect | <arrow> str,planDetailGridRef.current?.collectionView?.refresh | jsx | features/shipping/src/pages/shipment-plan/ShipmentPlan.tsx | 1230 |
| MeasureSelectModal | onApply | <arrow> applyVisibleMeasures,saveTitleSet({menuId:MENU_ID,sheetName:ADMIN_SHEET_NAME[SHEETS.MAIN]??'',columnType:TITLESET_MEASURE_TYPE,rows:(codes??[]).map((name,i)=>({name,sortOrderNo:i+1})),}).then,saveTitleSet,(codes??[]).map,setAlert,t | jsx | features/shipping/src/pages/shipment-plan/ShipmentPlan.tsx | 1295 |
| ConfirmDetailModal | onClose | <arrow> setConfirmDetailNo | jsx | features/shipping/src/pages/shipment-plan/ShipmentPlan.tsx | 1328 |
| OrderDetailModal | onClose | <arrow> setOrderDetailCtx | jsx | features/shipping/src/pages/shipment-plan/ShipmentPlan.tsx | 1338 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| FormItem | 14 |
| Grid | 13 |
| Button | 11 |
| CustomDropdown | 9 |
| Stack | 7 |
| InputField | 6 |
| DataGrid | 4 |
| Box | 3 |
| PeriodField | 3 |
| FunctionSearchIcon | 3 |
| CustomDialog | 2 |
| Checkbox | 2 |
| Panel | 2 |
| MaterialByDivisionModal | 2 |
| ProgressIndicator | 1 |
| TabWrapper | 1 |
| TabItem | 1 |
| SearchArea | 1 |
| IcMeasureSelect | 1 |
| MainTitle | 1 |
| ShipmentPlanForm | 1 |
| SubTitle | 1 |
| PanelGroup | 1 |
| ShipmentPlanMainGrid | 1 |
| PanelSeparator | 1 |
| ShipmentPlanDetailBar | 1 |
| ShipmentPlanDetailGrid | 1 |
| ModelByDivisionPopup | 1 |
| ProjectByDivisionModal | 1 |
| SsoUserModal | 1 |
| MeasureSelectModal | 1 |
| ShipmentRequestModal | 1 |
| ConfirmDetailModal | 1 |
| OrderDetailModal | 1 |

## 6. 하드코딩 Grid 컬럼
| context | binding | header | width | visible | isReadOnly | dataType | via | file | line |
|---|---|---|---|---|---|---|---|---|---|
| POPUP_COLUMNS | CODE | User ID | 140 |  |  |  | meta-shape | features/shipping/src/pages/shipment-plan/components/modals/RequestorModal.tsx | 29 |
| POPUP_COLUMNS | NAME | User Name | 200 |  |  |  | meta-shape | features/shipping/src/pages/shipment-plan/components/modals/RequestorModal.tsx | 30 |
| leaf | DIVISION_ID:DIVISION_ID,END_CUSTOMER:END_CUSTOMER | header | width |  |  |  | object | features/shipping/src/pages/shipment-plan/components/modals/ShipmentRequestModal.tsx | 152 |
| dynamicColumns | m.binding | m.kind === 'D' ? m.leaf \|\| 'SUM' : 'SUM' | 80 | isDynVisible(m.kind, bucketType, chkSum) |  |  | object | features/shipping/src/pages/shipment-plan/components/ShipmentPlanMainGrid.tsx | 422 |

## 7. 메시지 코드
| code | count |
|---|---|
| LBL01115 | 2 |
| LBL00025 | 1 |
| LBL01111 | 1 |
| LBL00869 | 1 |
| LBL01141 | 1 |
| LBL00669 | 1 |
| LBL00022 | 2 |
| LBL00023 | 2 |
| LBL00024 | 1 |
| LBL01060 | 2 |
| LBL01104 | 2 |
| MSG01401 | 1 |
| MSG00429 | 1 |
| MSG01206 | 1 |
| MSG01291 | 1 |
| MSG01289 | 1 |
| MSG00013 | 1 |
| MSG01126 | 1 |
| MSG01244 | 1 |
| MSG00284 | 1 |
| MSG01261 | 1 |
| MSG01185 | 1 |
| MSG01274 | 1 |
| MSG00225 | 1 |
| MSG00666 | 1 |
| MSG01295 | 1 |
| MSG01315 | 1 |
| MSG01201 | 1 |
| MSG00004 | 1 |
| MSG00002 | 1 |
| MSG00003 | 1 |
| MSG01321 | 1 |
| LBL00001 | 1 |
| LBL00047 | 1 |
| LBL00618 | 1 |
| LBL00013 | 1 |
| LBL00039 | 1 |
| LBL01108 | 1 |
| LBL01109 | 1 |
| LBL01057 | 1 |
| LBL00710 | 1 |
| LBL00687 | 1 |
| LBL00310 | 1 |
| LBL01028 | 1 |
| LBL00112 | 1 |
| LBL00664 | 1 |
| LBL00783 | 1 |
| LBL00627 | 1 |
| LBL00716 | 1 |
| LBL01119 | 1 |
| LBL00620 | 1 |
| LBL01125 | 1 |
| LBL01144 | 1 |
| LBL01145 | 1 |
| MSG01208 | 1 |
| MSG01215 | 1 |
| MSG01125 | 1 |
| MSG01258 | 1 |
| MSG01259 | 1 |
| MSG01202 | 1 |
| MSG01257 | 1 |
| MSG01081 | 1 |
| MSG01395 | 1 |
| MSG01275 | 1 |
| MSG00704 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: SSP0015(24), SSP0060(15), SSP0021(10), SSP0014(6), SSP0005(4), SSP0300(4), SSP0023(4), SSP0200(4), SSP0025(3), SCP0013(2), SSP0033(2), SSP0026(2), SCP0001(1), DMF0082(1), DMF0021(1), SSP0022(1), SSP0202(1), DMF0004(1), COM0013(1), SCM0002(1), SCP0025(1), SCP0005(1)
- SP/PKG: PKG_SSP0060(10), PKG_SSP0002(7), PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH(4), P_ITEM_ID(3), SSP0002_GET_USER_INFO_LIST(3), PKG_SSP0003(3), P_DIVISION_ID(3), SSP0003_GET_SSP_PLAN_PROCESSING_CHECK(2), P_SSP0300_GET_ORDER_DETAIL(2), DM0003_GET_BUCKET_TYPE_CODE(2), P_SSP0002_GET_USER_INFO_LIST(2), P_SCM0002_GET_ITEM_BY_DIVISION_POPUP(2), P_USER_ID(2), P_SSP0060_SAVE_SHIPMENT_REQUEST_CONFIRM(2), P_SSP0060_GET_SHIPMENT_PLAN_DETAIL(1), P_SSP0060_GET_SHIPMENT_DIVISION(1), PKG_COM0000(1), P_SCP0009_GET_SHEET_CALENDAR_3SPAN(1), P_SSP0200_USER_CHECK(1), P_SCM_SSP_CHECK_CONFIRM_CHANGETIME_DE(1), P_SSP0060_SCM_SSP_CHK_CONFIRM_CHGTIME_DE(1), P_SSP0060_GET_SHIPMENT_PSI_COMMENTS(1), SSP0060_SAVE_HOLD_STOCK_DATA(1), PKG_SCM0002(1), P_REQUESTOR(1), DMF0002_GET_TITLESET_POPUP(1), P_DBL_FLAG(1), SCP0009_GET_SHEET_CALENDAR_3SPAN(1), P_SSP0060_GET_SHIPMENT_PLAN(1), PKG_NSCM_UI_COM_MENU(1), PR_GET_SHEET_MEASURE_LIST(1), P_SSP0003_SAVE_REQ_IF_CHECK(1), PR_GET_LOOKUP_INFO_LIST(1), P_ACTIVE_FLAG(1), P_COMPANY_ID(1), P_FROM_SITE(1), P_TO_SITE(1), P_TRANSPORT_MODE(1), P_INCOTERMS(1), P_FCST_TYPE(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| code | 필수: early return 보다 먼저 기록한다(Main 그리드 clickHandler 와 동일 이유). | features/shipping/src/pages/shipment-plan/components/ShipmentPlanDetailGrid.tsx | 361 |
| code | 조기 return 뒤에 묻히는 실수를 막는다(oWMS 핸들러는 STOCK_STATUS 아니면 즉시 return 한다). | features/shipping/src/pages/shipment-plan/components/ShipmentPlanDetailGrid.tsx | 480 |
| code | o = footerRows.getTotalSize(); n = rows.getTotalSize() + o; s = _heightBrowser + i - o; | features/shipping/src/pages/shipment-plan/components/ShipmentPlanDetailGrid.tsx | 605 |
| code | private static Color m_InValidColor = Color.FromArgb(92, 209, 229); | features/shipping/src/pages/shipment-plan/components/ShipmentPlanMainGrid.tsx | 154 |
| code | string strTmp_ItemID = GetValue(i, ITEM_ID); | features/shipping/src/pages/shipment-plan/components/ShipmentPlanMainGrid.tsx | 617 |
| code | - 툴바 5버튼: Find/Save/Insert/Edit = 실동작, Delete = NO-OP `() => undefined` (00 §4d 확정 — 재판단 금지). | features/shipping/src/pages/shipment-plan/shipment-plan.constants.ts | 11 |
| code | 툴바: Find/Save/Insert/Edit=실동작, Delete=NO-OP `() => undefined` (00 §4d — 노출 유지, false 숨김 금지). | features/shipping/src/pages/shipment-plan/ShipmentPlan.tsx | 87 |
| code | `bool isOK = GetSSPUserCheck(); if (isOK == false) { GMessageBox("MSG00251", UserId); return; }` | features/shipping/src/pages/shipment-plan/ShipmentPlan.tsx | 154 |
| endpoint | ── mount — keep-alive 잔여 filters 무효화 + Main 컬럼 메타 1회 fetch (np §5-7) ── | features/shipping/src/pages/shipment-plan/ShipmentPlan.tsx | 533 |
| endpoint | ── Detail 탭 전환 시 해당 sheet 컬럼 메타 lazy fetch (헤더 생성) ── | features/shipping/src/pages/shipment-plan/ShipmentPlan.tsx | 544 |
| code | R2 — 경고 없이 조용히 return (AS-IS L2148) | features/shipping/src/pages/shipment-plan/ShipmentPlan.tsx | 942 |
| endpoint | 1) admin SCM_MST_SHEET_COLUMNS fetch (mount + Search — ui-dynamic-property-management §2.3). | features/shipping/src/pages/shipment-plan/useShipmentPlanStore.ts | 382 |
| code | 사용법: 클릭 핸들러에서 **early return 보다 먼저** track() 을 부른다(헤더·빈 영역 클릭도 null 로 | features/shipping/src/pages/shipment-plan/utils/shipment-plan.dblClickGuard.ts | 12 |
| code | 더블클릭 시 handleMainDrilldown 의 `if (!sheet) return` 으로 무반응. | features/shipping/src/pages/shipment-plan/utils/shipment-plan.detailSheets.ts | 107 |
| code | lookup 행 배열의 참조 안정화 — useTabLookupQueries 는 useQueries 결과를 `.map(d => d.data)` 로 돌려줘 **매 렌더 새 배열**이다(참조 불안정). 그대로 useMemo deps 에 쓰면 파생 DataMap/맵이 매 렌더 재생성되고, 그 인스턴스를 그리드 col.dataMap 에 재대입하는 effect 가 매 렌더 돌아 편집 중 드롭다운이 닫히고 커밋이 증발한다 (2026-10- | features/shipping/src/pages/shipment-plan/utils/shipment-plan.lookups.ts | 37 |
| code | TransMode 셀콤보 route 파생키 (갭항목 I04). AS-IS SpdDetail_CellClick(GSCM.SSP.Plan.UIL/SSP0060_ShipmentPlan.cs L1974~1997)은 TRANSPORT_MODE 셀을 누르면 그 행의 route 로 콤보를 **행 단위 재조회**한다: string sDivision = GetValue(DIVISION_ID); string sFromSite = GetValue | features/shipping/src/pages/shipment-plan/utils/shipment-plan.transMode.ts | 1 |

## 10. __asis-mapping__.md 상태
- 구현: 95
- 해당없음: 13
- 제외: 9
| design_id | summary | reason | status |
|---|---|---|---|
| D00-1-020 | components (Container) | [WINFORMS] 디자이너 컨테이너 | 해당없음 |
| D00-1-029 | imageList1 | [WINFORMS] 아이콘 리소스 | 해당없음 |
| D00-1-063 | usrButton1 | Designer 선언만, 이벤트/속성 배선 0건(01 §5-5 실측 — dead 컨트롤) | 제외 |
| D00-2-019 | SpdDetail_ClipboardPasted | 공용 DataGrid 붙여넣기 + beginningEdit 잠금이 등가. 행별 가드 세부(빈셀 차단 #16)는 04 확인필요 | 해당없음 |
| D00-2-023 | SpdDetail_TopChange | [WINFORMS] 스크롤 병합 재적용 — 공용 CustomMergeManager 자동 | 해당없음 |
| D00-2-026 | SpdMain_ClipboardPasted | 공용 DataGrid 붙여넣기 + beginningEdit 잠금 판정 공통 적용 | 해당없음 |
| D00-2-027 | spdMain_KeyDown | [WINFORMS] FarPoint InputMap 커스텀 — Wijmo 기본 키맵 등가 | 해당없음 |
| D00-2-028 | spdMain_KeyUp | [WINFORMS] 동상 | 해당없음 |
| D00-2-029 | SpdMain_TopChange | [WINFORMS] SmartColMerge 재적용 — 공용 병합 매니저 자동 | 해당없음 |
| D00-3-012 | ERP_SO_NO 액티브셀 이동·리셋 | AS-IS 편집취소 UX 배관 — beginningEdit cancel 로 등가 | 해당없음 |
| D00-3-017 | TRANSPORT_MODE 콤보 세팅 | [META-GAP] 갭#2 — 셀콤보 메타 미배선(빈 리스트 재현) | 제외 |
| D00-3-018 | 헤더 체크박스 전체선택 토글 | 대상 컬럼(CHECK_NEED_YN 추정) 메타 미배선 — 04 확인필요 | 제외 |
| D00-3-021 | SmartColMerge 재적용 | 공용 DataGrid 병합 매니저가 자동 재적용 — 화면 코드 불요 | 해당없음 |
| D00-3-024 | 저장 실패 셀 InvalidColor | Main 저장 음수는 저장 전 차단(MSG00225)이라 실패색 경로 미발생 — 셀 단위 표기는 04 확인필요 | 제외 |
| D00-3-025 | GetViewRowFromModelRow | Wijmo collectionView 인덱스 공용 처리 | 해당없음 |
| D00-3-027 | spreadInfo 헤더 시트 잠금 | 헤더 정보 시트는 TO-BE 미존재(dynamicColumns 로 대체) | 해당없음 |
| D00-3-030 | 조회 후 액티브셀 지정 | UX 배관 — Wijmo 기본 포커스 | 해당없음 |
| D00-3-032 | StickyNote 셀 메모 유지 | AS-IS EDIT_YN 노트 표시 — TO-BE wide 커서에 EDIT_YN 부재(실측), 04 확인필요 | 제외 |
| D00-3-035 | END_CUSTOMER 콤보·자동채움 | [META-GAP] 갭#3(SQL+컬럼 미등록) — SetEndCustomer 는 메타 정비 후 | 제외 |
| D00-4-004 | SSP0060_SAVE_HOLD_STOCK_DATA | SP 미존재(TO-BE/AS-IS 실측) — convert-sp 후속. API/BTN 메타는 선등록 | 제외 |
| D00-4-027 | SSP0002_GET_NERP_CODE | [PKG-SSP0002] — Company ERP 재필터 보류(goal 백로그, Form 주석) | 제외 |
| D00-4-029 | SCM_SSP_CHECK_CONFIRM_CHANGETIME | [SP-CHAIN] 동시편집 검증 — Confirm 저장 SP 내부 처리 여부 convert-sp 확인 | 제외 |

