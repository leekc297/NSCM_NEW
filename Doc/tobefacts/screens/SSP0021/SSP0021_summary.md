# SSP0021 — To-Be Fact Pack 요약

- page_key: `shipping/shipment-plan-auto-ess` · feature: shipping · As-is Fact Pack 있음
- 파일 21 · 엔드포인트 호출 27 (미해결 2, 주석 속 2) · 이벤트 56 · 컴포넌트 사용 79 · 하드코딩 컬럼 3 · 메시지 44
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 3건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/shipping/src/pages/shipment-plan-auto-ess/components/modals/RequestorModal.tsx | component | 119 |
| features/shipping/src/pages/shipment-plan-auto-ess/components/ShipmentPlanAutoEssDetailBar.module.scss | component | 15 |
| features/shipping/src/pages/shipment-plan-auto-ess/components/ShipmentPlanAutoEssDetailBar.tsx | component | 217 |
| features/shipping/src/pages/shipment-plan-auto-ess/components/ShipmentPlanAutoEssDetailGrid.module.scss | component | 21 |
| features/shipping/src/pages/shipment-plan-auto-ess/components/ShipmentPlanAutoEssDetailGrid.tsx | component | 516 |
| features/shipping/src/pages/shipment-plan-auto-ess/components/ShipmentPlanAutoEssForm.tsx | component | 405 |
| features/shipping/src/pages/shipment-plan-auto-ess/components/ShipmentPlanAutoEssMainGrid.tsx | component | 424 |
| features/shipping/src/pages/shipment-plan-auto-ess/index.ts | index | 2 |
| features/shipping/src/pages/shipment-plan-auto-ess/shipment-plan-auto-ess.constants.ts | constants | 356 |
| features/shipping/src/pages/shipment-plan-auto-ess/shipment-plan-auto-ess.types.ts | types | 34 |
| features/shipping/src/pages/shipment-plan-auto-ess/ShipmentPlanAutoEss.module.scss | style | 60 |
| features/shipping/src/pages/shipment-plan-auto-ess/ShipmentPlanAutoEss.tsx | page | 988 |
| features/shipping/src/pages/shipment-plan-auto-ess/useShipmentPlanAutoEssStore.ts | store | 460 |
| features/shipping/src/pages/shipment-plan-auto-ess/utils/shipment-plan-auto-ess.calc.ts | util | 189 |
| features/shipping/src/pages/shipment-plan-auto-ess/utils/shipment-plan-auto-ess.dblClickGuard.ts | util | 54 |
| features/shipping/src/pages/shipment-plan-auto-ess/utils/shipment-plan-auto-ess.detailSheets.ts | util | 101 |
| features/shipping/src/pages/shipment-plan-auto-ess/utils/shipment-plan-auto-ess.editLock.test.ts | test | 71 |
| features/shipping/src/pages/shipment-plan-auto-ess/utils/shipment-plan-auto-ess.editLock.ts | util | 110 |
| features/shipping/src/pages/shipment-plan-auto-ess/utils/shipment-plan-auto-ess.erpChain.ts | util | 529 |
| features/shipping/src/pages/shipment-plan-auto-ess/utils/shipment-plan-auto-ess.save.ts | util | 244 |
| features/shipping/src/pages/shipment-plan-auto-ess/__asis-mapping__.md | mapping | 517 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueries) | hook | 4 | Y | RequestorModal.tsx:42 ShipmentPlanAutoEssDetailGrid.tsx:96 ShipmentPlanAutoEssDetailGrid.tsx:108 ShipmentPlanAutoEssForm.tsx:139 |
| (useTabLookupQueries) | hook | 2 | Y | ShipmentPlanAutoEssDetailBar.tsx:50 ShipmentPlanAutoEss.tsx:285 |
| SSP0021/division//call-proc | hook | 1 | Y | ShipmentPlanAutoEssForm.tsx:118 |
| /SSP0021/main/USER_CHECK/call-proc | http,propagated | 2 | Y | ShipmentPlanAutoEss.tsx:156 |
| SSP0021/main//call-proc | hook | 1 | Y | ShipmentPlanAutoEss.tsx:211 |
| SSP0021/calendar//call-proc | hook | 1 | Y | ShipmentPlanAutoEss.tsx:218 |
| SSP0021/planDetail//call-proc | hook | 1 | Y | ShipmentPlanAutoEss.tsx:225 |
| SSP0021/stockDetail//call-proc | hook | 1 | Y | ShipmentPlanAutoEss.tsx:235 |
| SSP0021/owmsDetail//call-proc | hook | 1 | Y | ShipmentPlanAutoEss.tsx:242 |
| SSP0021/holdStock//call-proc | hook | 1 | Y | ShipmentPlanAutoEss.tsx:249 |
| SSP0021/mesStock//call-proc | hook | 1 | Y | ShipmentPlanAutoEss.tsx:256 |
| SSP0021/mesStockDetail//call-proc | hook | 1 | Y | ShipmentPlanAutoEss.tsx:263 |
| SSP0021/shipmentResult//call-proc | hook | 1 | Y | ShipmentPlanAutoEss.tsx:270 |
| /SSP0021/planDetail/SAVE/call-proc | http,propagated | 2 | Y | ShipmentPlanAutoEss.tsx:386 |
| {?url} | http | 1 | N | ShipmentPlanAutoEss.tsx:565 |
| {?params} | http | 1 | N | ShipmentPlanAutoEss.tsx:566 |
| /admin/menu/SSP0021/column | http,propagated | 2 | Y | useShipmentPlanAutoEssStore.ts:386 |
| /admin/menu/SSP0021/measure | http,propagated | 2 | Y | useShipmentPlanAutoEssStore.ts:411 |
| /admin/menu/SSP0021/search-conditions | http | 1 | Y | useShipmentPlanAutoEssStore.ts:437 |

## 3. procedures.d.ts 등재 시트
| sheet | request_keys | response_cursors | sp_hints |
|---|---|---|---|
| division | param1 param2 | o_rc1 o_rc2 | P_SSP0021_GET_SHIPMENT_DIVISION PKG_SSP0021 PKG_COM0000 P_SCP0009_GET_SHEET_CALENDAR_3SPAN P_SSP0021_SAVE_SHIPMENT_REQUEST_CONFIRM |
| calendar | startYyyymmdd endYyyymmdd | o_rc1 | PKG_COM0000 P_SCP0009_GET_SHEET_CALENDAR_3SPAN PKG_SSP0021 P_SSP0021_GET_SHIPMENT_DIVISION P_SSP0021_SAVE_SHIPMENT_REQUEST_CONFIRM |
| main | divisionId companyId fromSite planStartYyyymmdd fromYyyymmdd toYyyymmdd itemId userId programId sheetName realFlag | o_rc1 o_rc2 | P_SSP0021_GET_SHIPMENT_PLAN PKG_SSP0021 P_SSP0021_GET_SHIPMENT_DIVISION PKG_COM0000 P_SCP0009_GET_SHEET_CALENDAR_3SPAN P_SSP0021_SAVE_SHIPMENT_REQUEST_CONFIRM |
| planDetail | divisionId companyId fromSite itemId requestor planStartYyyymmdd fromYyyymmdd toYyyymmdd dblFlag realFlag language programId sheetName debugMode | o_rc1 | PKG_SSP0021 P_SSP0021_GET_SHIPMENT_DIVISION PKG_COM0000 P_SCP0009_GET_SHEET_CALENDAR_3SPAN P_SSP0021_SAVE_SHIPMENT_REQUEST_CONFIRM |
| stockDetail | divisionId companyId fromSite itemId planStartYyyymmdd dblFlag language programId sheetName debugMode | o_rc1 | PKG_SSP0021 P_SSP0021_GET_SHIPMENT_DIVISION PKG_COM0000 P_SCP0009_GET_SHEET_CALENDAR_3SPAN P_SSP0021_SAVE_SHIPMENT_REQUEST_CONFIRM |
| owmsDetail | divisionId companyId fromSite itemId planStartYyyymmdd dblFlag language programId sheetName debugMode | o_rc1 | PKG_SSP0021 P_SSP0021_GET_SHIPMENT_DIVISION PKG_COM0000 P_SCP0009_GET_SHEET_CALENDAR_3SPAN P_SSP0021_SAVE_SHIPMENT_REQUEST_CONFIRM |
| holdStock | divisionId fromSite itemId planStartYyyymmdd planType seq language searchYn userId | o_rc1 | PKG_SSP0021 P_SSP0021_GET_SHIPMENT_DIVISION PKG_COM0000 P_SCP0009_GET_SHEET_CALENDAR_3SPAN P_SSP0021_SAVE_SHIPMENT_REQUEST_CONFIRM |
| mesStock | divisionId companyId fromSite itemId planStartYyyymmdd dblFlag language programId sheetName debugMode | o_rc1 | PKG_SSP0021 P_SSP0021_GET_SHIPMENT_DIVISION PKG_COM0000 P_SCP0009_GET_SHEET_CALENDAR_3SPAN P_SSP0021_SAVE_SHIPMENT_REQUEST_CONFIRM |
| mesStockDetail | divisionId companyId fromSite itemId boxId planStartYyyymmdd dblFlag language programId sheetName debugMode | o_rc1 | PKG_SSP0021 P_SSP0021_GET_SHIPMENT_DIVISION PKG_COM0000 P_SCP0009_GET_SHEET_CALENDAR_3SPAN P_SSP0021_SAVE_SHIPMENT_REQUEST_CONFIRM |
| shipmentResult | divisionId fromSite itemId fromYyyymmdd toYyyymmdd type userId companyId myModelChk partLeaderChk teamLeaderChk delegateeChk nonChk realFlag planStartYyyymmdd | o_rc1 | PKG_SSP0021 P_SSP0021_GET_SHIPMENT_DIVISION PKG_COM0000 P_SCP0009_GET_SHEET_CALENDAR_3SPAN P_SSP0021_SAVE_SHIPMENT_REQUEST_CONFIRM |

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| InputField | onChange | <arrow> setKeyword | jsx | features/shipping/src/pages/shipment-plan-auto-ess/components/modals/RequestorModal.tsx | 91 |
| InputField | onKeyDown | <arrow> handleSearch | jsx | features/shipping/src/pages/shipment-plan-auto-ess/components/modals/RequestorModal.tsx | 92 |
| Button | onClick | handleSearch | jsx | features/shipping/src/pages/shipment-plan-auto-ess/components/modals/RequestorModal.tsx | 94 |
| Button | onClick | handleSelect | jsx | features/shipping/src/pages/shipment-plan-auto-ess/components/modals/RequestorModal.tsx | 107 |
| Button | onClick | modalClose | jsx | features/shipping/src/pages/shipment-plan-auto-ess/components/modals/RequestorModal.tsx | 110 |
| PeriodField | onChange | <arrow> setPeriod2 | jsx | features/shipping/src/pages/shipment-plan-auto-ess/components/ShipmentPlanAutoEssDetailBar.tsx | 83 |
| PeriodField | onChange | <arrow> set | jsx | features/shipping/src/pages/shipment-plan-auto-ess/components/ShipmentPlanAutoEssDetailBar.tsx | 94 |
| InputField | onChange | <arrow> set | jsx | features/shipping/src/pages/shipment-plan-auto-ess/components/ShipmentPlanAutoEssDetailBar.tsx | 120 |
| Button | onClick | onModelSearch | jsx | features/shipping/src/pages/shipment-plan-auto-ess/components/ShipmentPlanAutoEssDetailBar.tsx | 116 |
| InputField | onChange | <arrow> set | jsx | features/shipping/src/pages/shipment-plan-auto-ess/components/ShipmentPlanAutoEssDetailBar.tsx | 149 |
| Button | onClick | onRequestorSearch | jsx | features/shipping/src/pages/shipment-plan-auto-ess/components/ShipmentPlanAutoEssDetailBar.tsx | 145 |
| CustomDropdown | onChange | <arrow> set,str(picked).split(',').filter,str(picked).split,str | jsx | features/shipping/src/pages/shipment-plan-auto-ess/components/ShipmentPlanAutoEssDetailBar.tsx | 175 |
| InputField | onChange | <arrow> set | jsx | features/shipping/src/pages/shipment-plan-auto-ess/components/ShipmentPlanAutoEssDetailBar.tsx | 199 |
| Button | onClick | onDetailSearch | jsx | features/shipping/src/pages/shipment-plan-auto-ess/components/ShipmentPlanAutoEssDetailBar.tsx | 210 |
| grid | updatedLayout | apply | addHandler | features/shipping/src/pages/shipment-plan-auto-ess/components/ShipmentPlanAutoEssDetailGrid.tsx | 146 |
| g | beginningEdit | beginningEditHandler | addHandler | features/shipping/src/pages/shipment-plan-auto-ess/components/ShipmentPlanAutoEssDetailGrid.tsx | 212 |
| g | pastingCell | pastingCellHandler | addHandler | features/shipping/src/pages/shipment-plan-auto-ess/components/ShipmentPlanAutoEssDetailGrid.tsx | 223 |
| g | formatItem | formatItemHandler | addHandler | features/shipping/src/pages/shipment-plan-auto-ess/components/ShipmentPlanAutoEssDetailGrid.tsx | 260 |
| g | cellEditEnded | cellEditEndedHandler | addHandler | features/shipping/src/pages/shipment-plan-auto-ess/components/ShipmentPlanAutoEssDetailGrid.tsx | 318 |
| g | pastedCell | cellEditEndedHandler | addHandler | features/shipping/src/pages/shipment-plan-auto-ess/components/ShipmentPlanAutoEssDetailGrid.tsx | 319 |
| g.hostElement | dblclick | dblClickHandler | addEventListener | features/shipping/src/pages/shipment-plan-auto-ess/components/ShipmentPlanAutoEssDetailGrid.tsx | 365 |
| g.hostElement | click | clickHandler | addEventListener | features/shipping/src/pages/shipment-plan-auto-ess/components/ShipmentPlanAutoEssDetailGrid.tsx | 375 |
| g | updatedLayout | applyAggregates | addHandler | features/shipping/src/pages/shipment-plan-auto-ess/components/ShipmentPlanAutoEssDetailGrid.tsx | 461 |
| g | updatedLayout | pinFooterToBottom | addHandler | features/shipping/src/pages/shipment-plan-auto-ess/components/ShipmentPlanAutoEssDetailGrid.tsx | 462 |
| DataGrid | gotFocus | <arrow> setActiveGrid | jsx | features/shipping/src/pages/shipment-plan-auto-ess/components/ShipmentPlanAutoEssDetailGrid.tsx | 509 |
| SearchArea | onSearch | onSearch | jsx | features/shipping/src/pages/shipment-plan-auto-ess/components/ShipmentPlanAutoEssForm.tsx | 233 |
| CustomDropdown | onChange | <arrow> str,confirmIfDirtyKey(tabDirtyKey(tabId),'search').then,confirmIfDirtyKey,tabDirtyKey,setDivision | jsx | features/shipping/src/pages/shipment-plan-auto-ess/components/ShipmentPlanAutoEssForm.tsx | 251 |
| CustomDropdown | onChange | <arrow> setCompany,str | jsx | features/shipping/src/pages/shipment-plan-auto-ess/components/ShipmentPlanAutoEssForm.tsx | 273 |
| CustomDropdown | onChange | <arrow> set,str(picked).split(',').filter,str(picked).split,str | jsx | features/shipping/src/pages/shipment-plan-auto-ess/components/ShipmentPlanAutoEssForm.tsx | 294 |
| CustomDropdown | onChange | <arrow> set,str | jsx | features/shipping/src/pages/shipment-plan-auto-ess/components/ShipmentPlanAutoEssForm.tsx | 316 |
| CustomDropdown | onChange | <arrow> handlePlanDateChange,str | jsx | features/shipping/src/pages/shipment-plan-auto-ess/components/ShipmentPlanAutoEssForm.tsx | 332 |
| PeriodField | onChange | <arrow> set | jsx | features/shipping/src/pages/shipment-plan-auto-ess/components/ShipmentPlanAutoEssForm.tsx | 352 |
| InputField | onChange | <arrow> set | jsx | features/shipping/src/pages/shipment-plan-auto-ess/components/ShipmentPlanAutoEssForm.tsx | 376 |
| Button | onClick | onItemSearch | jsx | features/shipping/src/pages/shipment-plan-auto-ess/components/ShipmentPlanAutoEssForm.tsx | 372 |
| Checkbox | onChange | <arrow> set | jsx | features/shipping/src/pages/shipment-plan-auto-ess/components/ShipmentPlanAutoEssForm.tsx | 395 |
| g | updatedLayout | applyMerge | addHandler | features/shipping/src/pages/shipment-plan-auto-ess/components/ShipmentPlanAutoEssMainGrid.tsx | 246 |
| g | updatedLayout | applyHeaderHeight | addHandler | features/shipping/src/pages/shipment-plan-auto-ess/components/ShipmentPlanAutoEssMainGrid.tsx | 269 |
| g | beginningEdit | beginningEditHandler | addHandler | features/shipping/src/pages/shipment-plan-auto-ess/components/ShipmentPlanAutoEssMainGrid.tsx | 284 |
| g | formatItem | formatItemHandler | addHandler | features/shipping/src/pages/shipment-plan-auto-ess/components/ShipmentPlanAutoEssMainGrid.tsx | 309 |
| g | pastingCell | pastingCellHandler | addHandler | features/shipping/src/pages/shipment-plan-auto-ess/components/ShipmentPlanAutoEssMainGrid.tsx | 321 |
| g.hostElement | keydown | deleteKeyHandler | addEventListener | features/shipping/src/pages/shipment-plan-auto-ess/components/ShipmentPlanAutoEssMainGrid.tsx | 351 |
| g.hostElement | dblclick | dblClickHandler | addEventListener | features/shipping/src/pages/shipment-plan-auto-ess/components/ShipmentPlanAutoEssMainGrid.tsx | 369 |
| g.hostElement | click | clickHandler | addEventListener | features/shipping/src/pages/shipment-plan-auto-ess/components/ShipmentPlanAutoEssMainGrid.tsx | 381 |
| ShipmentPlanAutoEssForm | onSearch | handleSearch | jsx | features/shipping/src/pages/shipment-plan-auto-ess/ShipmentPlanAutoEss.tsx | 768 |
| ShipmentPlanAutoEssForm | onItemSearch | <arrow> setOpenItemMain | jsx | features/shipping/src/pages/shipment-plan-auto-ess/ShipmentPlanAutoEss.tsx | 769 |
| ShipmentPlanAutoEssMainGrid | onDrilldown | handleMainDrilldown | jsx | features/shipping/src/pages/shipment-plan-auto-ess/ShipmentPlanAutoEss.tsx | 807 |
| ShipmentPlanAutoEssDetailBar | onDetailSearch | handleDetailSearch | jsx | features/shipping/src/pages/shipment-plan-auto-ess/ShipmentPlanAutoEss.tsx | 817 |
| ShipmentPlanAutoEssDetailBar | onModelSearch | <arrow> setOpenItemDetailBar | jsx | features/shipping/src/pages/shipment-plan-auto-ess/ShipmentPlanAutoEss.tsx | 818 |
| ShipmentPlanAutoEssDetailBar | onRequestorSearch | <arrow> setOpenRequestor | jsx | features/shipping/src/pages/shipment-plan-auto-ess/ShipmentPlanAutoEss.tsx | 819 |
| ShipmentPlanAutoEssDetailGrid | onOrderDetail | setOrderDetail | jsx | features/shipping/src/pages/shipment-plan-auto-ess/ShipmentPlanAutoEss.tsx | 822 |
| ShipmentPlanAutoEssDetailGrid | onConfirmDetail | setConfirmDetailNo | jsx | features/shipping/src/pages/shipment-plan-auto-ess/ShipmentPlanAutoEss.tsx | 823 |
| ShipmentPlanAutoEssDetailGrid | onItemCellSearch | <arrow> openCellPopup | jsx | features/shipping/src/pages/shipment-plan-auto-ess/ShipmentPlanAutoEss.tsx | 848 |
| ShipmentPlanAutoEssDetailGrid | onProjectCellSearch | <arrow> openCellPopup | jsx | features/shipping/src/pages/shipment-plan-auto-ess/ShipmentPlanAutoEss.tsx | 849 |
| OrderDetailModal | onClose | <arrow> setOrderDetail | jsx | features/shipping/src/pages/shipment-plan-auto-ess/ShipmentPlanAutoEss.tsx | 939 |
| ConfirmDetailModal | onClose | <arrow> setConfirmDetailNo | jsx | features/shipping/src/pages/shipment-plan-auto-ess/ShipmentPlanAutoEss.tsx | 949 |
| MeasureSelectModal | onApply | <arrow> applyVisibleMeasures,saveTitleSet({menuId:MENU_ID,sheetName:ADMIN_SHEET_NAME[SHEETS.MAIN]??'',columnType:TITLESET_MEASURE_TYPE,rows:(codes??[]).map((name,i)=>({name,sortOrderNo:i+1})),}).then,saveTitleSet,(codes??[]).map,setAlert,t | jsx | features/shipping/src/pages/shipment-plan-auto-ess/ShipmentPlanAutoEss.tsx | 966 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Grid | 12 |
| FormItem | 11 |
| Button | 7 |
| CustomDropdown | 6 |
| Stack | 5 |
| InputField | 5 |
| DataGrid | 3 |
| PeriodField | 3 |
| FunctionSearchIcon | 3 |
| Panel | 2 |
| MaterialByDivisionModal | 2 |
| CustomDialog | 1 |
| TabWrapper | 1 |
| TabItem | 1 |
| SearchArea | 1 |
| Checkbox | 1 |
| IcMeasureSelect | 1 |
| MainTitle | 1 |
| ShipmentPlanAutoEssForm | 1 |
| SubTitle | 1 |
| PanelGroup | 1 |
| ShipmentPlanAutoEssMainGrid | 1 |
| PanelSeparator | 1 |
| ShipmentPlanAutoEssDetailBar | 1 |
| ShipmentPlanAutoEssDetailGrid | 1 |
| ItemByDivisionModal | 1 |
| ProjectByDivisionModal | 1 |
| SsoUserModal | 1 |
| OrderDetailModal | 1 |
| ConfirmDetailModal | 1 |
| MeasureSelectModal | 1 |

## 6. 하드코딩 Grid 컬럼
| context | binding | header | width | visible | isReadOnly | dataType | via | file | line |
|---|---|---|---|---|---|---|---|---|---|
| POPUP_COLUMNS | CODE | User ID | 140 |  |  |  | meta-shape | features/shipping/src/pages/shipment-plan-auto-ess/components/modals/RequestorModal.tsx | 28 |
| POPUP_COLUMNS | NAME | User Name | 200 |  |  |  | meta-shape | features/shipping/src/pages/shipment-plan-auto-ess/components/modals/RequestorModal.tsx | 29 |
| dynamicColumns | m.binding | m.kind === 'D' ? m.leaf \|\| 'SUM' : 'SUM' | 80 | isDynVisible(m.kind, bucketType, chkSum) |  |  | object | features/shipping/src/pages/shipment-plan-auto-ess/components/ShipmentPlanAutoEssMainGrid.tsx | 176 |

## 7. 메시지 코드
| code | count |
|---|---|
| MSG01401 | 1 |
| MSG00429 | 1 |
| MSG01206 | 1 |
| MSG01291 | 1 |
| MSG01289 | 1 |
| MSG00013 | 1 |
| MSG00284 | 1 |
| MSG01201 | 1 |
| MSG00004 | 1 |
| MSG00703 | 1 |
| MSG00002 | 1 |
| MSG00003 | 1 |
| MSG01261 | 1 |
| MSG01125 | 1 |
| MSG01321 | 1 |
| MSG01258 | 1 |
| MSG01259 | 1 |
| MSG01202 | 1 |
| MSG01257 | 1 |
| MSG01395 | 1 |
| MSG01275 | 1 |
| MSG01208 | 1 |
| MSG01215 | 1 |
| LBL00001 | 1 |
| LBL00047 | 1 |
| LBL00022 | 1 |
| LBL00669 | 1 |
| LBL00618 | 1 |
| LBL00013 | 1 |
| LBL00039 | 1 |
| LBL01108 | 1 |
| LBL01109 | 1 |
| LBL01115 | 1 |
| LBL01057 | 1 |
| LBL00710 | 1 |
| LBL00687 | 1 |
| LBL00310 | 1 |
| LBL00112 | 1 |
| LBL00664 | 1 |
| LBL00627 | 1 |
| LBL00716 | 1 |
| LBL01119 | 1 |
| LBL01090 | 1 |
| MSG00704 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: SSP0060(49), SSP0021(20), SSP0015(18), SSP0005(5), SSP0300(3), SSP0023(3), SSP0200(2), SCP0001(1), SCM0002(1), SCP0009(1), SSP0014(1)
- SP/PKG: PKG_SSP0021(17), P_SSP0021_SAVE_SHIPMENT_REQUEST_CONFIRM(4), P_USER_ID(4), P_SSP0003_SAVE_REQ_IF_CHECK(3), P_ACTIVE_FLAG(3), P_SSP0021_GET_SHIPMENT_DIVISION(2), P_SSP0021_SAVE_SHIPMENT_REQUEST_DRAFTING(2), PKG_SSP0003(2), P_SSP0300_GET_ORDER_DETAIL(2), PKG_SSP0002(2), P_SSP0002_GET_USER_INFO_LIST(2), P_TITLE(2), P_FROM_YYYYMMDD(1), PKG_COM0000(1), P_SCP0009_GET_SHEET_CALENDAR_3SPAN(1), P_SSP0060_GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING(1), P_SSP0021_GET_SHIPMENT_STATUS(1), P_SSP0021_GET_ERP_SO_NO_CNT(1), PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH(1), P_SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM(1), P_SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM(1), P_SSP0200_USER_CHECK(1), P_ITEM_ID(1), SSP0002_GET_USER_INFO_LIST(1), SCP0009_GET_SHEET_CALENDAR_3SPAN(1), P_SSP0021_GET_SHIPMENT_PLAN(1), P_SSP0021_GET_SHIPMENT_PLAN_DETAIL(1), P_FROM(1), P_SSP0021_GET_HOLD_STOCK(1), P_SSP0021_GET_SHIPMENT_RESULT(1), P_SSP0021_GET_MES_STOCK_DETAIL(1), P_SSP0021_GET_STOCK_LOCATION_DETAIL(1), P_SHIPMENT_DATE(1), P_PROGRAM_ID(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| code | - 툴바 5버튼: Find/Save/Insert = 실동작, Delete = NO-OP `() => undefined`(design 01 §2 확정 — 재판단 금지), | features/shipping/src/pages/shipment-plan-auto-ess/shipment-plan-auto-ess.constants.ts | 15 |
| code | 툴바: Find/Save/Insert=실동작, Delete=NO-OP `() => undefined`(design 01 §2 — 노출 유지, false·키생략 금지), | features/shipping/src/pages/shipment-plan-auto-ess/ShipmentPlanAutoEss.tsx | 75 |
| code | `bool isOK = GetSSPUserCheck(); if (isOK == false) { GMessageBox("MSG00251", UserId); return; }` | features/shipping/src/pages/shipment-plan-auto-ess/ShipmentPlanAutoEss.tsx | 145 |
| code | 2023-10-04(jilee)에 들어간 무조건 return 이라 그 아래 `bEdit_Auth` 분기와 unlock 로직은 | features/shipping/src/pages/shipment-plan-auto-ess/ShipmentPlanAutoEss.tsx | 190 |
| code | 연쇄의 마지막 단계(④ CONFIRM)라 await 할 수 있게 mutateAsync 로 쓴다. 성공·실패 처리(onSuccess 재조회 B7, | features/shipping/src/pages/shipment-plan-auto-ess/ShipmentPlanAutoEss.tsx | 381 |
| endpoint | ── mount — keep-alive 잔여 filters 무효화 + 컬럼 메타 1회 fetch (np §5-7) ── | features/shipping/src/pages/shipment-plan-auto-ess/ShipmentPlanAutoEss.tsx | 430 |
| code | 원본 행 STATUS 게이트 (AS-IS L2209/L2284 — RowCount>0 + SHIPMENT_STATUS!='C' return). | features/shipping/src/pages/shipment-plan-auto-ess/ShipmentPlanAutoEss.tsx | 678 |
| endpoint | admin SCM_MST_SHEET_COLUMNS fetch (mount + Search — ui-dynamic-property-management). | features/shipping/src/pages/shipment-plan-auto-ess/useShipmentPlanAutoEssStore.ts | 380 |
| code | 사용법: 클릭 핸들러에서 **early return 보다 먼저** track() 을 부른다(헤더·빈 영역 클릭도 null 로 | features/shipping/src/pages/shipment-plan-auto-ess/utils/shipment-plan-auto-ess.dblClickGuard.ts | 12 |
| code | 더블클릭 시 handleMainDrilldown 의 `if (!sheet) return` 으로 무반응. | features/shipping/src/pages/shipment-plan-auto-ess/utils/shipment-plan-auto-ess.detailSheets.ts | 89 |

## 10. __asis-mapping__.md 상태
- 구현: 52
- 제외: 4
- 해당없음: 26
| design_id | summary | reason | status |
|---|---|---|---|
| D00-1-022 | §1 usrButton1 / UsrButton | dead/orphan(용도 불명, design 02 §7-5) — AS-IS 미배선 컨트롤이라 이식 대상 아님 | 제외 |
| D00-1-032 | §1 PlanDate / LayoutControlItem | DevExpress LayoutControlItem(라벨 배치 컨테이너) — MUI FormItem label 이 흡수, TO-BE 무등가 컨트롤 | 해당없음 |
| D00-1-033 | §1 Requestor / LayoutControlItem | 라벨 배치 컨테이너 — MUI FormItem label 흡수, TO-BE 무등가 | 해당없음 |
| D00-1-034 | §1 lblBucket / LayoutControlItem | 라벨 배치 컨테이너 — MUI FormItem label 흡수, TO-BE 무등가 | 해당없음 |
| D00-1-035 | §1 lblCombo1 / LayoutControlItem | 라벨 배치 컨테이너 — MUI FormItem label 흡수, TO-BE 무등가 | 해당없음 |
| D00-1-036 | §1 lblItemId / LayoutControlItem | 라벨 배치 컨테이너 — MUI FormItem label 흡수, TO-BE 무등가 | 해당없음 |
| D00-1-037 | §1 layoutControlItem1 / LayoutControlItem | 라벨 배치 컨테이너 — MUI FormItem label 흡수, TO-BE 무등가 | 해당없음 |
| D00-1-038 | §1 layoutControlItem2 / LayoutControlItem | 라벨 배치 컨테이너 — MUI FormItem label 흡수, TO-BE 무등가 | 해당없음 |
| D00-1-039 | §1 layoutControlItem3 / LayoutControlItem | 라벨 배치 컨테이너 — MUI FormItem label 흡수, TO-BE 무등가 | 해당없음 |
| D00-1-040 | §1 layoutControlItem4 / LayoutControlItem | 라벨 배치 컨테이너 — MUI FormItem label 흡수, TO-BE 무등가 | 해당없음 |
| D00-1-041 | §1 layoutControlItem5 / LayoutControlItem | 라벨 배치 컨테이너 — MUI FormItem label 흡수, TO-BE 무등가 | 해당없음 |
| D00-1-042 | §1 layoutControlItem6 / LayoutControlItem | 라벨 배치 컨테이너 — MUI FormItem label 흡수, TO-BE 무등가 | 해당없음 |
| D00-1-043 | §1 layoutControlItem7 / LayoutControlItem | 라벨 배치 컨테이너 — MUI FormItem label 흡수, TO-BE 무등가 | 해당없음 |
| D00-1-044 | §1 layoutControlItem8 / LayoutControlItem | 라벨 배치 컨테이너 — MUI FormItem label 흡수, TO-BE 무등가 | 해당없음 |
| D00-1-045 | §1 layoutControlItem9 / LayoutControlItem | 라벨 배치 컨테이너 — MUI FormItem label 흡수, TO-BE 무등가 | 해당없음 |
| D00-1-046 | §1 layoutControlItem10 / LayoutControlItem | 라벨 배치 컨테이너 — MUI FormItem label 흡수, TO-BE 무등가 | 해당없음 |
| D00-1-047 | §1 layoutControlItem11 / LayoutControlItem | 라벨 배치 컨테이너 — MUI FormItem label 흡수, TO-BE 무등가 | 해당없음 |
| D00-1-048 | §1 layoutControlItem12 / LayoutControlItem | 라벨 배치 컨테이너 — MUI FormItem label 흡수, TO-BE 무등가 | 해당없음 |
| D00-1-049 | §1 layoutControlItem13 / LayoutControlItem | 라벨 배치 컨테이너 — MUI FormItem label 흡수, TO-BE 무등가 | 해당없음 |
| D00-1-050 | §1 layoutControlItem14 / LayoutControlItem | 라벨 배치 컨테이너 — MUI FormItem label 흡수, TO-BE 무등가 | 해당없음 |
| D00-1-051 | §1 layoutControlItem17 / LayoutControlItem | 라벨 배치 컨테이너 — MUI FormItem label 흡수, TO-BE 무등가 | 해당없음 |
| D00-1-052 | §1 emptySpaceItem1 / EmptySpaceItem | DevExpress 여백 아이템 — TO-BE Grid 레이아웃 무등가(00 §1 근거) | 해당없음 |
| D00-1-053 | §1 emptySpaceItem2 / EmptySpaceItem | DevExpress 여백 아이템 — TO-BE 무등가 | 해당없음 |
| D00-1-054 | §1 emptySpaceItem3 / EmptySpaceItem | DevExpress 여백 아이템 — TO-BE 무등가 | 해당없음 |
| D00-1-055 | §1 emptySpaceItem5 / EmptySpaceItem | DevExpress 여백 아이템 — TO-BE 무등가 | 해당없음 |
| D00-1-056 | §1 components / Container | WinForms 디자이너 인프라 Container(static) — TO-BE 무등가 | 해당없음 |
| D00-1-057 | §1 imageList1 / ImageList | WinForms 아이콘 리소스 컨테이너(static) — TO-BE 는 SVG 아이콘 컴포넌트 직접 사용, 무등가 | 해당없음 |
| D00-2-015 | §2 spdDetail / CellClick | AS-IS CellClick 은 CHANGE_REQ_NO 셀 팝업(SCM0002_ShipmentPlanRequestPopup) 진입 트리거인데 TO-BE 팝업 부재로 미배선(04_react-gap.md 확인필요) — 나머지 활성그리드 전환은 `gotFocus`(DetailGrid.tsx)가 흡수 | 제외 |
| D00-2-021 | §2 spdDetail / TopChange | FpSpread 가상 스크롤 top 동기화 배관 — Wijmo FlexGrid 네이티브 스크롤이 등가 처리, 이식 대상 아님 | 제외 |
| D00-2-025 | §2 spdMain / TopChange | FpSpread 가상 스크롤 top 동기화 배관 — Wijmo FlexGrid 네이티브 스크롤이 등가 처리, 이식 대상 아님 | 제외 |

