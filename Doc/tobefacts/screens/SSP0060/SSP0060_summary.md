# SSP0060 — To-Be Fact Pack 요약

- page_key: `shipping/shipment-plan` · feature: shipping · As-is Fact Pack 있음
- 파일 28 · 엔드포인트 호출 26 (미해결 0, 주석 속 3) · 이벤트 93 · 컴포넌트 사용 108 · 하드코딩 컬럼 38 · 메시지 46
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 38건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/shipping/src/pages/shipment-plan/components/modals/ConfirmDetailModal.tsx | component | 85 |
| features/shipping/src/pages/shipment-plan/components/modals/MeasureSelectModal.module.scss | component | 29 |
| features/shipping/src/pages/shipment-plan/components/modals/MeasureSelectModal.tsx | component | 315 |
| features/shipping/src/pages/shipment-plan/components/modals/OrderDetailModal.tsx | component | 172 |
| features/shipping/src/pages/shipment-plan/components/modals/RequestorModal.tsx | component | 121 |
| features/shipping/src/pages/shipment-plan/components/modals/ShipmentRequestModal.tsx | component | 179 |
| features/shipping/src/pages/shipment-plan/components/ShipmentPlanDetailBar.module.scss | component | 22 |
| features/shipping/src/pages/shipment-plan/components/ShipmentPlanDetailBar.tsx | component | 267 |
| features/shipping/src/pages/shipment-plan/components/ShipmentPlanDetailGrid.tsx | component | 651 |
| features/shipping/src/pages/shipment-plan/components/ShipmentPlanForm.tsx | component | 431 |
| features/shipping/src/pages/shipment-plan/components/ShipmentPlanMainGrid.tsx | component | 620 |
| features/shipping/src/pages/shipment-plan/index.ts | index | 2 |
| features/shipping/src/pages/shipment-plan/shipment-plan.constants.ts | constants | 276 |
| features/shipping/src/pages/shipment-plan/shipment-plan.types.ts | types | 46 |
| features/shipping/src/pages/shipment-plan/ShipmentPlan.module.scss | style | 38 |
| features/shipping/src/pages/shipment-plan/ShipmentPlan.tsx | page | 1010 |
| features/shipping/src/pages/shipment-plan/useShipmentPlanStore.ts | store | 465 |
| features/shipping/src/pages/shipment-plan/utils/shipment-plan.calc.test.ts | test | 170 |
| features/shipping/src/pages/shipment-plan/utils/shipment-plan.calc.ts | util | 337 |
| features/shipping/src/pages/shipment-plan/utils/shipment-plan.dblClickGuard.test.ts | test | 75 |
| features/shipping/src/pages/shipment-plan/utils/shipment-plan.dblClickGuard.ts | util | 49 |
| features/shipping/src/pages/shipment-plan/utils/shipment-plan.detailSheets.ts | util | 120 |
| features/shipping/src/pages/shipment-plan/utils/shipment-plan.editLock.test.ts | test | 82 |
| features/shipping/src/pages/shipment-plan/utils/shipment-plan.editLock.ts | util | 142 |
| features/shipping/src/pages/shipment-plan/utils/shipment-plan.lookups.ts | util | 112 |
| features/shipping/src/pages/shipment-plan/utils/shipment-plan.save.ts | util | 185 |
| features/shipping/src/pages/shipment-plan/utils/shipment-plan.transMode.ts | util | 93 |
| features/shipping/src/pages/shipment-plan/__asis-mapping__.md | mapping | 592 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| SSP0060/confirmDetail//call-proc | hook | 2 | Y | ConfirmDetailModal.tsx:55 ShipmentRequestModal.tsx:60 |
| /SSP0060/main/GET_ORDER_DETAIL/call-proc | http | 1 | Y | OrderDetailModal.tsx:113 |
| (useTabComboQueries) | hook | 4 | Y | RequestorModal.tsx:43 ShipmentPlanDetailBar.tsx:58 ShipmentPlanForm.tsx:126 ShipmentPlanForm.tsx:140 |
| /SSP0060/requestDraftingMain/SAVE/call-proc | http | 1 | Y | ShipmentRequestModal.tsx:76 |
| (useTabLookupQueries) | hook | 2 | Y | ShipmentPlanDetailBar.tsx:57 shipment-plan.lookups.ts:59 |
| SSP0060/division//call-proc | hook | 1 | Y | ShipmentPlanForm.tsx:104 |
| /SSP0060/main/USER_CHECK/call-proc | http | 1 | Y | ShipmentPlan.tsx:128 |
| SSP0060/main//call-proc | hook | 1 | Y | ShipmentPlan.tsx:197 |
| SSP0060/calendar//call-proc | hook | 1 | Y | ShipmentPlan.tsx:204 |
| SSP0060/planDetail//call-proc | hook | 1 | Y | ShipmentPlan.tsx:211 |
| SSP0060/stockDetail//call-proc | hook | 1 | Y | ShipmentPlan.tsx:218 |
| SSP0060/owmsDetail//call-proc | hook | 1 | Y | ShipmentPlan.tsx:225 |
| SSP0060/holdStock//call-proc | hook | 1 | Y | ShipmentPlan.tsx:232 |
| SSP0060/mesStock//call-proc | hook | 1 | Y | ShipmentPlan.tsx:239 |
| SSP0060/mesStockDetail//call-proc | hook | 1 | Y | ShipmentPlan.tsx:246 |
| SSP0060/shipmentResult//call-proc | hook | 1 | Y | ShipmentPlan.tsx:253 |
| /SSP0060/main/SAVE/call-proc | http | 1 | Y | ShipmentPlan.tsx:324 |
| /SSP0060/planDetail/SAVE/call-proc | http | 1 | Y | ShipmentPlan.tsx:348 |
| /admin/menu/SSP0060/column | http | 1 | Y | useShipmentPlanStore.ts:368 |
| /admin/menu/SSP0060/search-conditions | http | 1 | Y | useShipmentPlanStore.ts:393 |
| /admin/menu/SSP0060/measure | http | 1 | Y | useShipmentPlanStore.ts:442 |

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
| ColumnSelectDualList | onToggleLeft | toggle(setCheckedLeft) | jsx | features/shipping/src/pages/shipment-plan/components/modals/MeasureSelectModal.tsx | 262 |
| ColumnSelectDualList | onToggleRight | toggle(setCheckedRight) | jsx | features/shipping/src/pages/shipment-plan/components/modals/MeasureSelectModal.tsx | 263 |
| ColumnSelectDualList | onToggleAllLeft | <arrow> setCheckedLeft,baseRows.filter(r=>r.personalizable==='Y').map,baseRows.filter | jsx | features/shipping/src/pages/shipment-plan/components/modals/MeasureSelectModal.tsx | 264 |
| ColumnSelectDualList | onToggleAllRight | <arrow> setCheckedRight,userRows.filter(r=>r.personalizable==='Y').map,userRows.filter | jsx | features/shipping/src/pages/shipment-plan/components/modals/MeasureSelectModal.tsx | 271 |
| ColumnSelectDualList | onMoveRight | requireChecked(checkedLeft, moveToUser) | jsx | features/shipping/src/pages/shipment-plan/components/modals/MeasureSelectModal.tsx | 278 |
| ColumnSelectDualList | onMoveLeft | requireChecked(checkedRight, moveToBase) | jsx | features/shipping/src/pages/shipment-plan/components/modals/MeasureSelectModal.tsx | 279 |
| ColumnSelectDualList | onReorderRight | reorderRight | jsx | features/shipping/src/pages/shipment-plan/components/modals/MeasureSelectModal.tsx | 280 |
| ColumnSelectDualList | onRowDoubleClickLeft | moveOne(moveToUser) | jsx | features/shipping/src/pages/shipment-plan/components/modals/MeasureSelectModal.tsx | 281 |
| ColumnSelectDualList | onRowDoubleClickRight | moveOne(moveToBase) | jsx | features/shipping/src/pages/shipment-plan/components/modals/MeasureSelectModal.tsx | 282 |
| Button | onClick | handleDefault | jsx | features/shipping/src/pages/shipment-plan/components/modals/MeasureSelectModal.tsx | 291 |
| Button | onClick | handleOk | jsx | features/shipping/src/pages/shipment-plan/components/modals/MeasureSelectModal.tsx | 300 |
| Button | onClick | modalClose | jsx | features/shipping/src/pages/shipment-plan/components/modals/MeasureSelectModal.tsx | 307 |
| Button | onClick | onClose | jsx | features/shipping/src/pages/shipment-plan/components/modals/OrderDetailModal.tsx | 164 |
| InputField | onChange | <arrow> setKeyword | jsx | features/shipping/src/pages/shipment-plan/components/modals/RequestorModal.tsx | 93 |
| InputField | onKeyDown | <arrow> handleSearch | jsx | features/shipping/src/pages/shipment-plan/components/modals/RequestorModal.tsx | 94 |
| Button | onClick | handleSearch | jsx | features/shipping/src/pages/shipment-plan/components/modals/RequestorModal.tsx | 96 |
| Button | onClick | handleSelect | jsx | features/shipping/src/pages/shipment-plan/components/modals/RequestorModal.tsx | 109 |
| Button | onClick | modalClose | jsx | features/shipping/src/pages/shipment-plan/components/modals/RequestorModal.tsx | 112 |
| InputField | onChange | <arrow> setTitle | jsx | features/shipping/src/pages/shipment-plan/components/modals/ShipmentRequestModal.tsx | 156 |
| Button | onClick | handleRequest | jsx | features/shipping/src/pages/shipment-plan/components/modals/ShipmentRequestModal.tsx | 167 |
| Button | onClick | modalClose | jsx | features/shipping/src/pages/shipment-plan/components/modals/ShipmentRequestModal.tsx | 170 |
| PeriodField | onChange | <arrow> setPeriod2 | jsx | features/shipping/src/pages/shipment-plan/components/ShipmentPlanDetailBar.tsx | 95 |
| PeriodField | onChange | <arrow> set | jsx | features/shipping/src/pages/shipment-plan/components/ShipmentPlanDetailBar.tsx | 106 |
| InputField | onChange | <arrow> set | jsx | features/shipping/src/pages/shipment-plan/components/ShipmentPlanDetailBar.tsx | 133 |
| InputField | onKeyDown | <arrow> onDetailSearch | jsx | features/shipping/src/pages/shipment-plan/components/ShipmentPlanDetailBar.tsx | 134 |
| FunctionSearchIcon | onClick | onModelSearch | jsx | features/shipping/src/pages/shipment-plan/components/ShipmentPlanDetailBar.tsx | 128 |
| InputField | onChange | <arrow> set | jsx | features/shipping/src/pages/shipment-plan/components/ShipmentPlanDetailBar.tsx | 166 |
| InputField | onKeyDown | <arrow> onDetailSearch | jsx | features/shipping/src/pages/shipment-plan/components/ShipmentPlanDetailBar.tsx | 167 |
| FunctionSearchIcon | onClick | onRequestorSearch | jsx | features/shipping/src/pages/shipment-plan/components/ShipmentPlanDetailBar.tsx | 161 |
| CustomDropdown | onChange | <arrow> set,str(picked).split(',').filter,str(picked).split,str | jsx | features/shipping/src/pages/shipment-plan/components/ShipmentPlanDetailBar.tsx | 190 |
| CustomDropdown | onChange | <arrow> set,str(picked).split(',').filter,str(picked).split,str | jsx | features/shipping/src/pages/shipment-plan/components/ShipmentPlanDetailBar.tsx | 219 |
| InputField | onChange | <arrow> set | jsx | features/shipping/src/pages/shipment-plan/components/ShipmentPlanDetailBar.tsx | 243 |
| InputField | onKeyDown | <arrow> onDetailSearch | jsx | features/shipping/src/pages/shipment-plan/components/ShipmentPlanDetailBar.tsx | 244 |
| Button | onClick | onNew | jsx | features/shipping/src/pages/shipment-plan/components/ShipmentPlanDetailBar.tsx | 255 |
| Button | onClick | onDetailSearch | jsx | features/shipping/src/pages/shipment-plan/components/ShipmentPlanDetailBar.tsx | 260 |
| g | beginningEdit | beginningEditHandler | addHandler | features/shipping/src/pages/shipment-plan/components/ShipmentPlanDetailGrid.tsx | 172 |
| g | pastingCell | pastingCellHandler | addHandler | features/shipping/src/pages/shipment-plan/components/ShipmentPlanDetailGrid.tsx | 190 |
| g | formatItem | formatItemHandler | addHandler | features/shipping/src/pages/shipment-plan/components/ShipmentPlanDetailGrid.tsx | 219 |
| g | cellEditEnded | cellEditEndedHandler | addHandler | features/shipping/src/pages/shipment-plan/components/ShipmentPlanDetailGrid.tsx | 277 |
| g | pastedCell | cellEditEndedHandler | addHandler | features/shipping/src/pages/shipment-plan/components/ShipmentPlanDetailGrid.tsx | 279 |
| g.hostElement | dblclick | dblClickHandler | addEventListener | features/shipping/src/pages/shipment-plan/components/ShipmentPlanDetailGrid.tsx | 319 |
| g.hostElement | click | clickHandler | addEventListener | features/shipping/src/pages/shipment-plan/components/ShipmentPlanDetailGrid.tsx | 334 |
| g | beginningEdit | editGateHandler | addHandler | features/shipping/src/pages/shipment-plan/components/ShipmentPlanDetailGrid.tsx | 367 |
| g | pastingCell | editGateHandler | addHandler | features/shipping/src/pages/shipment-plan/components/ShipmentPlanDetailGrid.tsx | 368 |
| g | formatItem | formatItemHandler | addHandler | features/shipping/src/pages/shipment-plan/components/ShipmentPlanDetailGrid.tsx | 382 |
| g | formatItem | paintNegative | addHandler | features/shipping/src/pages/shipment-plan/components/ShipmentPlanDetailGrid.tsx | 428 |
| g | formatItem | fmt | addHandler | features/shipping/src/pages/shipment-plan/components/ShipmentPlanDetailGrid.tsx | 457 |
| g | updatedLayout | applyAggregates | addHandler | features/shipping/src/pages/shipment-plan/components/ShipmentPlanDetailGrid.tsx | 548 |
| g | updatedLayout | pinFooterToBottom | addHandler | features/shipping/src/pages/shipment-plan/components/ShipmentPlanDetailGrid.tsx | 549 |
| g | updatedLayout | applyHeaderHeight | addHandler | features/shipping/src/pages/shipment-plan/components/ShipmentPlanDetailGrid.tsx | 609 |
| DataGrid | gotFocus | <arrow> setActiveGrid | jsx | features/shipping/src/pages/shipment-plan/components/ShipmentPlanDetailGrid.tsx | 639 |
| SearchArea | onSearch | onSearch | jsx | features/shipping/src/pages/shipment-plan/components/ShipmentPlanForm.tsx | 217 |
| CustomDropdown | onChange | <arrow> str,confirmIfDirtyKey(tabDirtyKey(tabId),'search').then,confirmIfDirtyKey,tabDirtyKey,setDivision | jsx | features/shipping/src/pages/shipment-plan/components/ShipmentPlanForm.tsx | 234 |
| CustomDropdown | onChange | <arrow> str,confirmIfDirtyKey(tabDirtyKey(tabId),'search').then,confirmIfDirtyKey,tabDirtyKey,setCompany | jsx | features/shipping/src/pages/shipment-plan/components/ShipmentPlanForm.tsx | 258 |
| CustomDropdown | onChange | <arrow> set,str(picked).split(',').filter,str(picked).split,str | jsx | features/shipping/src/pages/shipment-plan/components/ShipmentPlanForm.tsx | 284 |
| CustomDropdown | onChange | <arrow> set,str | jsx | features/shipping/src/pages/shipment-plan/components/ShipmentPlanForm.tsx | 306 |
| CustomDropdown | onChange | <arrow> handlePlanDateChange,str | jsx | features/shipping/src/pages/shipment-plan/components/ShipmentPlanForm.tsx | 322 |
| PeriodField | onChange | <arrow> set | jsx | features/shipping/src/pages/shipment-plan/components/ShipmentPlanForm.tsx | 336 |
| InputField | onChange | <arrow> set | jsx | features/shipping/src/pages/shipment-plan/components/ShipmentPlanForm.tsx | 363 |
| InputField | onKeyDown | <arrow> onSearch | jsx | features/shipping/src/pages/shipment-plan/components/ShipmentPlanForm.tsx | 364 |
| FunctionSearchIcon | onClick | onItemSearch | jsx | features/shipping/src/pages/shipment-plan/components/ShipmentPlanForm.tsx | 358 |
| CustomDropdown | onChange | <arrow> set,str(picked).split(',').filter,str(picked).split,str | jsx | features/shipping/src/pages/shipment-plan/components/ShipmentPlanForm.tsx | 385 |
| Checkbox | onChange | <arrow> set | jsx | features/shipping/src/pages/shipment-plan/components/ShipmentPlanForm.tsx | 407 |
| Checkbox | onChange | <arrow> set | jsx | features/shipping/src/pages/shipment-plan/components/ShipmentPlanForm.tsx | 421 |
| g | updatedLayout | applyMerge | addHandler | features/shipping/src/pages/shipment-plan/components/ShipmentPlanMainGrid.tsx | 338 |
| g | updatedLayout | applyHeaderHeight | addHandler | features/shipping/src/pages/shipment-plan/components/ShipmentPlanMainGrid.tsx | 368 |
| g | beginningEdit | beginningEditHandler | addHandler | features/shipping/src/pages/shipment-plan/components/ShipmentPlanMainGrid.tsx | 382 |
| g | formatItem | formatItemHandler | addHandler | features/shipping/src/pages/shipment-plan/components/ShipmentPlanMainGrid.tsx | 462 |
| g | pastingCell | pastingCellHandler | addHandler | features/shipping/src/pages/shipment-plan/components/ShipmentPlanMainGrid.tsx | 477 |
| g | cellEditEnded | recalcCell | addHandler | features/shipping/src/pages/shipment-plan/components/ShipmentPlanMainGrid.tsx | 495 |
| g | pastedCell | recalcCell | addHandler | features/shipping/src/pages/shipment-plan/components/ShipmentPlanMainGrid.tsx | 496 |
| g.hostElement | keydown | deleteKeyHandler | addEventListener | features/shipping/src/pages/shipment-plan/components/ShipmentPlanMainGrid.tsx | 540 |
| g.hostElement | dblclick | dblClickHandler | addEventListener | features/shipping/src/pages/shipment-plan/components/ShipmentPlanMainGrid.tsx | 559 |
| g.hostElement | click | clickHandler | addEventListener | features/shipping/src/pages/shipment-plan/components/ShipmentPlanMainGrid.tsx | 573 |
| ShipmentPlanForm | onSearch | handleSearch | jsx | features/shipping/src/pages/shipment-plan/ShipmentPlan.tsx | 785 |
| ShipmentPlanForm | onItemSearch | <arrow> setOpenItemMain | jsx | features/shipping/src/pages/shipment-plan/ShipmentPlan.tsx | 786 |
| ShipmentPlanMainGrid | onDrilldown | handleMainDrilldown | jsx | features/shipping/src/pages/shipment-plan/ShipmentPlan.tsx | 817 |
| ShipmentPlanDetailBar | onDetailSearch | handleDetailSearch | jsx | features/shipping/src/pages/shipment-plan/ShipmentPlan.tsx | 823 |
| ShipmentPlanDetailBar | onNew | handleNew | jsx | features/shipping/src/pages/shipment-plan/ShipmentPlan.tsx | 824 |
| ShipmentPlanDetailBar | onModelSearch | <arrow> setOpenItemDetailBar | jsx | features/shipping/src/pages/shipment-plan/ShipmentPlan.tsx | 825 |
| ShipmentPlanDetailBar | onRequestorSearch | <arrow> setOpenRequestor | jsx | features/shipping/src/pages/shipment-plan/ShipmentPlan.tsx | 826 |
| ShipmentPlanDetailGrid | onItemCellSearch | <arrow> openCellPopup | jsx | features/shipping/src/pages/shipment-plan/ShipmentPlan.tsx | 854 |
| ShipmentPlanDetailGrid | onProjectCellSearch | <arrow> openCellPopup | jsx | features/shipping/src/pages/shipment-plan/ShipmentPlan.tsx | 855 |
| ShipmentPlanDetailGrid | onConfirmDetail | setConfirmDetailNo | jsx | features/shipping/src/pages/shipment-plan/ShipmentPlan.tsx | 856 |
| ShipmentPlanDetailGrid | onOrderDetail | setOrderDetailCtx | jsx | features/shipping/src/pages/shipment-plan/ShipmentPlan.tsx | 857 |
| ModelByDivisionPopup | onClose | <arrow> setOpenItemMain | jsx | features/shipping/src/pages/shipment-plan/ShipmentPlan.tsx | 882 |
| ModelByDivisionPopup | onSelect | <arrow> set,str | jsx | features/shipping/src/pages/shipment-plan/ShipmentPlan.tsx | 883 |
| ModelByDivisionPopup | onClose | <arrow> setOpenItemDetailBar | jsx | features/shipping/src/pages/shipment-plan/ShipmentPlan.tsx | 895 |
| ModelByDivisionPopup | onSelect | <arrow> set,str | jsx | features/shipping/src/pages/shipment-plan/ShipmentPlan.tsx | 896 |
| ModelByDivisionPopup | onClose | <arrow> setCellPopupKind | jsx | features/shipping/src/pages/shipment-plan/ShipmentPlan.tsx | 910 |
| ModelByDivisionPopup | onSelect | <arrow> str,planDetailGridRef.current?.collectionView?.refresh | jsx | features/shipping/src/pages/shipment-plan/ShipmentPlan.tsx | 911 |
| MeasureSelectModal | onApply | <arrow> applyVisibleMeasures,saveTitleSet({menuId:MENU_ID,sheetName:ADMIN_SHEET_NAME[SHEETS.MAIN]??'',columnType:TITLESET_MEASURE_TYPE,rows:codes.map((name,i)=>({name,sortOrderNo:i+1})),}).then,saveTitleSet,codes.map,setAlert,t | jsx | features/shipping/src/pages/shipment-plan/ShipmentPlan.tsx | 963 |
| OrderDetailModal | onClose | <arrow> setOrderDetailCtx | jsx | features/shipping/src/pages/shipment-plan/ShipmentPlan.tsx | 1005 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| FormItem | 15 |
| Grid | 15 |
| Button | 14 |
| CustomDropdown | 8 |
| Stack | 7 |
| DataGrid | 6 |
| InputField | 6 |
| CustomDialog | 5 |
| Box | 3 |
| PeriodField | 3 |
| FunctionSearchIcon | 3 |
| ModelByDivisionPopup | 3 |
| Checkbox | 2 |
| ColumnSelectDualList | 1 |
| ControlConfirmIcon | 1 |
| TabWrapper | 1 |
| TabItem | 1 |
| SearchArea | 1 |
| IcMeasureSelect | 1 |
| MainTitle | 1 |
| ShipmentPlanForm | 1 |
| SubTitle | 1 |
| ShipmentPlanMainGrid | 1 |
| ShipmentPlanDetailBar | 1 |
| ShipmentPlanDetailGrid | 1 |
| ProjectByDivisionModal | 1 |
| RequestorModal | 1 |
| MeasureSelectModal | 1 |
| ShipmentRequestModal | 1 |
| ConfirmDetailModal | 1 |
| OrderDetailModal | 1 |

## 6. 하드코딩 Grid 컬럼
| context | binding | header | width | visible | isReadOnly | dataType | via | file | line |
|---|---|---|---|---|---|---|---|---|---|
| POPUP_COLUMNS | DIVISION_ID | Div | 60 |  |  |  | meta-shape | features/shipping/src/pages/shipment-plan/components/modals/ConfirmDetailModal.tsx | 22 |
| POPUP_COLUMNS | ERP_SO_NO | SO No | 110 |  |  |  | meta-shape | features/shipping/src/pages/shipment-plan/components/modals/ConfirmDetailModal.tsx | 23 |
| POPUP_COLUMNS | PROJECT_CODE | Project Code | 110 |  |  |  | meta-shape | features/shipping/src/pages/shipment-plan/components/modals/ConfirmDetailModal.tsx | 24 |
| POPUP_COLUMNS | PROJECT_NAME | Project Name | 130 |  |  |  | meta-shape | features/shipping/src/pages/shipment-plan/components/modals/ConfirmDetailModal.tsx | 25 |
| POPUP_COLUMNS | FCST_TYPE | FCST Type | 80 |  |  |  | meta-shape | features/shipping/src/pages/shipment-plan/components/modals/ConfirmDetailModal.tsx | 26 |
| POPUP_COLUMNS | NICK_NAME | Nick Name | 110 |  |  |  | meta-shape | features/shipping/src/pages/shipment-plan/components/modals/ConfirmDetailModal.tsx | 27 |
| POPUP_COLUMNS | PRODUCT_LEVEL1 | Product Level1 | 100 |  |  |  | meta-shape | features/shipping/src/pages/shipment-plan/components/modals/ConfirmDetailModal.tsx | 28 |
| POPUP_COLUMNS | ITEM_ID | Model | 130 |  |  |  | meta-shape | features/shipping/src/pages/shipment-plan/components/modals/ConfirmDetailModal.tsx | 29 |
| POPUP_COLUMNS | FROM_SITE_DESCRIPTION | From Site | 120 |  |  |  | meta-shape | features/shipping/src/pages/shipment-plan/components/modals/ConfirmDetailModal.tsx | 30 |
| POPUP_COLUMNS | TO_SITE_DESCRIPTION | To Site | 120 |  |  |  | meta-shape | features/shipping/src/pages/shipment-plan/components/modals/ConfirmDetailModal.tsx | 31 |
| POPUP_COLUMNS | SOLDTO_DESCRIPTION | Sold To | 120 |  |  |  | meta-shape | features/shipping/src/pages/shipment-plan/components/modals/ConfirmDetailModal.tsx | 32 |
| POPUP_COLUMNS | SHIPTO_DESCRIPTION | Ship To | 120 |  |  |  | meta-shape | features/shipping/src/pages/shipment-plan/components/modals/ConfirmDetailModal.tsx | 33 |
| POPUP_COLUMNS | INCOTERMS | Incoterms | 80 |  |  |  | meta-shape | features/shipping/src/pages/shipment-plan/components/modals/ConfirmDetailModal.tsx | 34 |
| POPUP_COLUMNS | SHIPMENT_DATE | Shipment Date | 100 |  |  |  | meta-shape | features/shipping/src/pages/shipment-plan/components/modals/ConfirmDetailModal.tsx | 35 |
| POPUP_COLUMNS | SHIPMENT_CONFIRM_QTY | Shipment Qty | 100 |  |  |  | meta-shape | features/shipping/src/pages/shipment-plan/components/modals/ConfirmDetailModal.tsx | 36 |
| POPUP_COLUMNS | ETD | ETD | 100 |  |  |  | meta-shape | features/shipping/src/pages/shipment-plan/components/modals/ConfirmDetailModal.tsx | 37 |
| POPUP_COLUMNS | ETA | ETA | 100 |  |  |  | meta-shape | features/shipping/src/pages/shipment-plan/components/modals/ConfirmDetailModal.tsx | 38 |
| sourceRows | measure.colNm | measure.colLblNm \|\| measure.colNm |  | Y\|N |  |  | meta-map | features/shipping/src/pages/shipment-plan/components/modals/MeasureSelectModal.tsx | 96 |
| ORDER_DETAIL_COLUMNS | SO_NO | SO NO. | 120 | true |  |  | meta-shape | features/shipping/src/pages/shipment-plan/components/modals/OrderDetailModal.tsx | 50 |
| ORDER_DETAIL_COLUMNS | SO_ITEM_NO | SO Item No. | 100 | true |  |  | meta-shape | features/shipping/src/pages/shipment-plan/components/modals/OrderDetailModal.tsx | 51 |
| ORDER_DETAIL_COLUMNS | SO_ITEM_QTY | SO Item Qty | 110 | true |  |  | meta-shape | features/shipping/src/pages/shipment-plan/components/modals/OrderDetailModal.tsx | 59 |
| ORDER_DETAIL_COLUMNS | DO_NO | DO NO. | 120 | true |  |  | meta-shape | features/shipping/src/pages/shipment-plan/components/modals/OrderDetailModal.tsx | 67 |
| ORDER_DETAIL_COLUMNS | DO_ITEM_NO | DO Item No. | 100 | true |  |  | meta-shape | features/shipping/src/pages/shipment-plan/components/modals/OrderDetailModal.tsx | 68 |
| ORDER_DETAIL_COLUMNS | DO_ITEM_QTY | DO Item Qty. | 110 | true |  |  | meta-shape | features/shipping/src/pages/shipment-plan/components/modals/OrderDetailModal.tsx | 76 |
| ORDER_DETAIL_COLUMNS | CONFIRM_ID | Confirm ID | 130 | true |  |  | meta-shape | features/shipping/src/pages/shipment-plan/components/modals/OrderDetailModal.tsx | 84 |
| POPUP_COLUMNS | CODE | User ID | 140 |  |  |  | meta-shape | features/shipping/src/pages/shipment-plan/components/modals/RequestorModal.tsx | 29 |
| POPUP_COLUMNS | NAME | User Name | 200 |  |  |  | meta-shape | features/shipping/src/pages/shipment-plan/components/modals/RequestorModal.tsx | 30 |
| POPUP_COLUMNS | DIVISION_ID | Div | 60 |  |  |  | meta-shape | features/shipping/src/pages/shipment-plan/components/modals/ShipmentRequestModal.tsx | 31 |
| POPUP_COLUMNS | ERP_SO_NO | SO No | 110 |  |  |  | meta-shape | features/shipping/src/pages/shipment-plan/components/modals/ShipmentRequestModal.tsx | 32 |
| POPUP_COLUMNS | ITEM_ID | Model | 130 |  |  |  | meta-shape | features/shipping/src/pages/shipment-plan/components/modals/ShipmentRequestModal.tsx | 33 |
| POPUP_COLUMNS | NICK_NAME | Nick Name | 110 |  |  |  | meta-shape | features/shipping/src/pages/shipment-plan/components/modals/ShipmentRequestModal.tsx | 34 |
| POPUP_COLUMNS | FROM_SITE_DESCRIPTION | From Site | 120 |  |  |  | meta-shape | features/shipping/src/pages/shipment-plan/components/modals/ShipmentRequestModal.tsx | 35 |
| POPUP_COLUMNS | TO_SITE_DESCRIPTION | To Site | 120 |  |  |  | meta-shape | features/shipping/src/pages/shipment-plan/components/modals/ShipmentRequestModal.tsx | 36 |
| POPUP_COLUMNS | SHIPMENT_DATE | Shipment Date | 100 |  |  |  | meta-shape | features/shipping/src/pages/shipment-plan/components/modals/ShipmentRequestModal.tsx | 37 |
| POPUP_COLUMNS | SHIPMENT_CONFIRM_QTY | Shipment Qty | 100 |  |  |  | meta-shape | features/shipping/src/pages/shipment-plan/components/modals/ShipmentRequestModal.tsx | 38 |
| POPUP_COLUMNS | CHANGE_REASON_CODE | Change Reason | 110 |  |  |  | meta-shape | features/shipping/src/pages/shipment-plan/components/modals/ShipmentRequestModal.tsx | 39 |
| POPUP_COLUMNS | CHANGE_REASON_DETAIL | Reason Detail | 140 |  |  |  | meta-shape | features/shipping/src/pages/shipment-plan/components/modals/ShipmentRequestModal.tsx | 40 |
| dynamicColumns | m.binding | m.kind === 'D' ? m.leaf \|\| 'SUM' : 'SUM' | 80 | isDynVisible(m.kind, bucketType, chkSum) |  |  | object | features/shipping/src/pages/shipment-plan/components/ShipmentPlanMainGrid.tsx | 253 |

## 7. 메시지 코드
| code | count |
|---|---|
| LBL00713 | 2 |
| LBL00310 | 2 |
| LBL00764 | 1 |
| LBL00765 | 1 |
| MSG01401 | 1 |
| MSG00429 | 1 |
| MSG01291 | 1 |
| MSG01289 | 1 |
| MSG00013 | 1 |
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
| MSG00133 | 1 |
| MSG00002 | 1 |
| MSG00003 | 1 |
| LBL00001 | 1 |
| LBL00047 | 1 |
| LBL00022 | 1 |
| LBL00618 | 1 |
| LBL00013 | 1 |
| LBL00039 | 1 |
| LBL01108 | 1 |
| LBL01109 | 1 |
| LBL01115 | 1 |
| LBL01057 | 1 |
| LBL00710 | 1 |
| LBL00687 | 1 |
| LBL01028 | 1 |
| LBL00112 | 1 |
| LBL00783 | 1 |
| LBL00627 | 1 |
| LBL00716 | 1 |
| LBL01119 | 1 |
| LBL00620 | 1 |
| LBL01125 | 1 |
| LBL01144 | 1 |
| LBL01145 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: SSP0060(15), SSP0015(15), SSP0200(4), SSP0300(4), SSP0025(3), SSP0014(3), SCP0001(1), SSP0021(1), DMF0021(1), SCP0025(1), SCP0005(1)
- SP/PKG: PKG_SSP0060(8), PKG_SSP0002(7), P_DIVISION_ID(5), P_SSP0300_GET_ORDER_DETAIL(3), P_ITEM_ID(3), SSP0002_GET_USER_INFO_LIST(3), P_USER_ID(2), PKG_NSCM_UI_COM_MENU(2), PR_GET_SHEET_MEASURE_LIST(2), P_SSP0060_GET_SHIPMENT_PLAN(2), DM0003_GET_BUCKET_TYPE_CODE(2), P_SSP0002_GET_USER_INFO_LIST(2), P_SSP0060_GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING(1), P_CHANGE_REQUEST_NO(1), P_LANGUAGE(1), DMF0002_GET_TITLESET_POPUP(1), P_COLUMN_TYPE(1), P_ERP_SO_NO(1), P_CONFIRM_ID(1), PKG_SSP0300(1), P_TITLE(1), PR_SSP_ANL_(1), P_SSP0060_GET_SHIPMENT_PLAN_DETAIL(1), P_SSP0060_GET_SHIPMENT_DIVISION(1), PKG_COM0000(1), P_SCP0009_GET_SHEET_CALENDAR_3SPAN(1), P_SSP0200_USER_CHECK(1), SSP0060_SAVE_HOLD_STOCK_DATA(1), P_DBL_FLAG(1), SCP0009_GET_SHEET_CALENDAR_3SPAN(1), FN_GET_ANL_SHIP_FROZEN_DAY_CNT(1), PR_GET_LOOKUP_INFO_LIST(1), P_ACTIVE_FLAG(1), P_COMPANY_ID(1), P_FROM_SITE(1), P_TO_SITE(1), P_TRANSPORT_MODE(1), P_INCOTERMS(1), P_FCST_TYPE(1), P_PLAN_START_YYYYMMDD(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| code | 필수: early return 보다 먼저 기록한다(Main 그리드 clickHandler 와 동일 이유). | features/shipping/src/pages/shipment-plan/components/ShipmentPlanDetailGrid.tsx | 323 |
| code | 조기 return 뒤에 묻히는 실수를 막는다(oWMS 핸들러는 STOCK_STATUS 아니면 즉시 return 한다). | features/shipping/src/pages/shipment-plan/components/ShipmentPlanDetailGrid.tsx | 412 |
| code | o = footerRows.getTotalSize(); n = rows.getTotalSize() + o; s = _heightBrowser + i - o; | features/shipping/src/pages/shipment-plan/components/ShipmentPlanDetailGrid.tsx | 518 |
| code | private static Color m_InValidColor = Color.FromArgb(92, 209, 229); | features/shipping/src/pages/shipment-plan/components/ShipmentPlanMainGrid.tsx | 81 |
| code | string strTmp_ItemID = GetValue(i, ITEM_ID); | features/shipping/src/pages/shipment-plan/components/ShipmentPlanMainGrid.tsx | 409 |
| code | - 툴바 5버튼: Find/Save/Insert/Edit = 실동작, Delete = NO-OP `() => undefined` (00 §4d 확정 — 재판단 금지). | features/shipping/src/pages/shipment-plan/shipment-plan.constants.ts | 11 |
| code | 툴바: Find/Save/Insert/Edit=실동작, Delete=NO-OP `() => undefined` (00 §4d — 노출 유지, false 숨김 금지). | features/shipping/src/pages/shipment-plan/ShipmentPlan.tsx | 63 |
| code | `bool isOK = GetSSPUserCheck(); if (isOK == false) { GMessageBox("MSG00251", UserId); return; }` | features/shipping/src/pages/shipment-plan/ShipmentPlan.tsx | 117 |
| endpoint | ── mount — keep-alive 잔여 filters 무효화 + Main 컬럼 메타 1회 fetch (np §5-7) ── | features/shipping/src/pages/shipment-plan/ShipmentPlan.tsx | 366 |
| endpoint | ── Detail 탭 전환 시 해당 sheet 컬럼 메타 lazy fetch (헤더 생성) ── | features/shipping/src/pages/shipment-plan/ShipmentPlan.tsx | 375 |
| code | R2 — 경고 없이 조용히 return (AS-IS L2148) | features/shipping/src/pages/shipment-plan/ShipmentPlan.tsx | 710 |
| endpoint | 1) admin SCM_MST_SHEET_COLUMNS fetch (mount + Search — ui-dynamic-property-management §2.3). | features/shipping/src/pages/shipment-plan/useShipmentPlanStore.ts | 362 |
| code | 사용법: 클릭 핸들러에서 **early return 보다 먼저** track() 을 부른다(헤더·빈 영역 클릭도 null 로 | features/shipping/src/pages/shipment-plan/utils/shipment-plan.dblClickGuard.ts | 12 |
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

