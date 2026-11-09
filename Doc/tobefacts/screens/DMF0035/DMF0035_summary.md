# DMF0035 — To-Be Fact Pack 요약

- page_key: `report/demand-plan-waterfall` · feature: report · As-is Fact Pack 있음
- 파일 25 · 엔드포인트 호출 15 (미해결 2, 주석 속 0) · 이벤트 82 · 컴포넌트 사용 95 · 하드코딩 컬럼 10 · 메시지 34
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 사용 · 하드코딩 컬럼 정의 10건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/report/src/pages/demand-plan-waterfall/components/DemandPlanWaterfallForm.module.scss | component | 17 |
| features/report/src/pages/demand-plan-waterfall/components/DemandPlanWaterfallForm.tsx | component | 518 |
| features/report/src/pages/demand-plan-waterfall/components/DemandPlanWaterfallGrid.tsx | component | 423 |
| features/report/src/pages/demand-plan-waterfall/components/olap-field-rail/OlapFieldRail.module.scss | component | 652 |
| features/report/src/pages/demand-plan-waterfall/components/olap-field-rail/OlapFieldRail.tsx | component | 617 |
| features/report/src/pages/demand-plan-waterfall/components/olap-field-rail/olapFieldRail.utils.ts | component | 155 |
| features/report/src/pages/demand-plan-waterfall/components/olap-field-rail/RailIcons.tsx | component | 83 |
| features/report/src/pages/demand-plan-waterfall/components/OlapChartPane.module.scss | component | 29 |
| features/report/src/pages/demand-plan-waterfall/components/OlapChartPane.tsx | component | 77 |
| features/report/src/pages/demand-plan-waterfall/components/WaterfallVersionModal.module.scss | component | 37 |
| features/report/src/pages/demand-plan-waterfall/components/WaterfallVersionModal.tsx | component | 462 |
| features/report/src/pages/demand-plan-waterfall/demand-plan-waterfall.constants.test.ts | test | 61 |
| features/report/src/pages/demand-plan-waterfall/demand-plan-waterfall.constants.ts | constants | 249 |
| features/report/src/pages/demand-plan-waterfall/demand-plan-waterfall.types.ts | types | 39 |
| features/report/src/pages/demand-plan-waterfall/DemandPlanWaterfall.tsx | page | 521 |
| features/report/src/pages/demand-plan-waterfall/index.ts | index | 2 |
| features/report/src/pages/demand-plan-waterfall/useDemandPlanWaterfallStore.ts | store | 402 |
| features/report/src/pages/demand-plan-waterfall/utils/waterfall.columns.test.ts | test | 211 |
| features/report/src/pages/demand-plan-waterfall/utils/waterfall.columns.ts | util | 318 |
| features/report/src/pages/demand-plan-waterfall/utils/waterfall.drill.test.ts | test | 125 |
| features/report/src/pages/demand-plan-waterfall/utils/waterfall.drill.ts | util | 96 |
| features/report/src/pages/demand-plan-waterfall/utils/waterfall.headerColors.ts | util | 93 |
| features/report/src/pages/demand-plan-waterfall/utils/waterfall.merge.ts | util | 121 |
| features/report/src/pages/demand-plan-waterfall/utils/waterfall.periods.ts | util | 74 |
| features/report/src/pages/demand-plan-waterfall/__asis-mapping__.md | mapping | 603 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueries) | hook | 3 | Y | DemandPlanWaterfallForm.tsx:107 WaterfallVersionModal.tsx:134 DemandPlanWaterfall.tsx:76 |
| DMF0035/mktFcstSpreadTitle//call-proc | hook | 1 | Y | DemandPlanWaterfallGrid.tsx:93 |
| DMF0035/salesPlanSpreadTitle//call-proc | hook | 1 | Y | DemandPlanWaterfallGrid.tsx:100 |
| DMF0035/bizPlanSpreadTitle//call-proc | hook | 1 | Y | DemandPlanWaterfallGrid.tsx:107 |
| DMF0035/version//call-proc | hook | 1 | Y | WaterfallVersionModal.tsx:203 |
| DMF0035/versionWf//call-proc | hook | 1 | Y | WaterfallVersionModal.tsx:210 |
| /DMF0035/version/SAVE/call-proc | http | 1 | Y | WaterfallVersionModal.tsx:275 |
| DMF0035/mktFcstWaterfall//call-proc | hook | 1 | Y | DemandPlanWaterfall.tsx:120 |
| DMF0035/salesPlanWaterfall//call-proc | hook | 1 | Y | DemandPlanWaterfall.tsx:127 |
| DMF0035/bizPlanWaterfall//call-proc | hook | 1 | Y | DemandPlanWaterfall.tsx:134 |
| /admin/menu/DMF0035/search-conditions | http | 1 | Y | useDemandPlanWaterfallStore.ts:206 |
| /admin/menu/{programId??MENU_ID}/column | http | 1 | N | useDemandPlanWaterfallStore.ts:326 |
| /admin/menu/{programId}/measure | http | 1 | N | useDemandPlanWaterfallStore.ts:347 |

## 3. procedures.d.ts 등재 시트
| sheet | request_keys | response_cursors | sp_hints |
|---|---|---|---|
| mktFcstWaterfall | divisionId deptId endCustomer scmSiteId projectCode itemId itemType fromYyyymmdd toYyyymmdd sesUserId plantSiteId bizType owner versionNo bucket cellYn senderCode userDeptId groupId userId menuId | o_rc1 o_rc2 | PKG_DMF0035 P_DMF0035_GET_MKT_FCST_WATERFALL PKG_DMF0022 P_DMF0022_GET_DM_PLN_SALES_PLAN_WATERFALL PKG_DMF0051 P_DMF0051_GET_DM_PLN_BIZ_PLAN_WATERFALL DMF0073_GET_VERSION_SALESPRICE |
| salesPlanWaterfall | divisionId deptId endCustomer scmSiteId projectCode itemId itemType fromYyyymmdd nowYyyymmdd toYyyymmdd sesUserId plantSiteId bizType owner internalYn cellYn versionType bucket userDeptId groupId userId menuId | o_rc1 o_rc2 | PKG_DMF0035 P_DMF0035_GET_MKT_FCST_WATERFALL PKG_DMF0022 P_DMF0022_GET_DM_PLN_SALES_PLAN_WATERFALL PKG_DMF0051 P_DMF0051_GET_DM_PLN_BIZ_PLAN_WATERFALL DMF0073_GET_VERSION_SALESPRICE |
| bizPlanWaterfall | divisionId deptId endCustomer scmSiteId projectCode itemId itemType fromYyyymmdd nowYyyymmdd toYyyymmdd sesUserId plantSiteId bizType owner versionType cellYn qtyYn userId menuId | o_rc1 o_rc2 | PKG_DMF0035 P_DMF0035_GET_MKT_FCST_WATERFALL PKG_DMF0022 P_DMF0022_GET_DM_PLN_SALES_PLAN_WATERFALL PKG_DMF0051 P_DMF0051_GET_DM_PLN_BIZ_PLAN_WATERFALL DMF0073_GET_VERSION_SALESPRICE |
| mktFcstSpreadTitle | divisionId bucket fromYyyymmdd toYyyymmdd sesUserId userId | o_rc1 | PKG_DMF0035 P_DMF0035_GET_MKT_FCST_WATERFALL PKG_DMF0022 P_DMF0022_GET_DM_PLN_SALES_PLAN_WATERFALL PKG_DMF0051 P_DMF0051_GET_DM_PLN_BIZ_PLAN_WATERFALL DMF0073_GET_VERSION_SALESPRICE |
| salesPlanSpreadTitle | divisionId bucket fromYyyymmdd toYyyymmdd sesUserId userId | o_rc1 | PKG_DMF0035 P_DMF0035_GET_MKT_FCST_WATERFALL PKG_DMF0022 P_DMF0022_GET_DM_PLN_SALES_PLAN_WATERFALL PKG_DMF0051 P_DMF0051_GET_DM_PLN_BIZ_PLAN_WATERFALL DMF0073_GET_VERSION_SALESPRICE |
| bizPlanSpreadTitle | divisionId bucket fromYyyymmdd toYyyymmdd sesUserId userId | o_rc1 | PKG_DMF0035 P_DMF0035_GET_MKT_FCST_WATERFALL PKG_DMF0022 P_DMF0022_GET_DM_PLN_SALES_PLAN_WATERFALL PKG_DMF0051 P_DMF0051_GET_DM_PLN_BIZ_PLAN_WATERFALL DMF0073_GET_VERSION_SALESPRICE |
| version | startYyyymmdd endYyyymmdd createdBy divisionId versionType description | o_rc1 | PKG_DMF0035 P_DMF0035_GET_MKT_FCST_WATERFALL PKG_DMF0022 P_DMF0022_GET_DM_PLN_SALES_PLAN_WATERFALL PKG_DMF0051 P_DMF0051_GET_DM_PLN_BIZ_PLAN_WATERFALL DMF0073_GET_VERSION_SALESPRICE |
| versionWf | startYyyymmdd endYyyymmdd createdBy divisionId versionType versionNo | o_rc1 | PKG_SCM0002 P_SCM0002_GET_VERSIONBYWATERFALLPOPUP PKG_DMF0035 P_DMF0035_GET_MKT_FCST_WATERFALL PKG_DMF0022 P_DMF0022_GET_DM_PLN_SALES_PLAN_WATERFALL PKG_DMF0051 P_DMF0051_GET_DM_PLN_BIZ_PLAN_WATERFALL DMF0073_GET_VERSION_SALESPRICE |

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| SearchArea | onSearch | onSubmit | jsx | features/report/src/pages/demand-plan-waterfall/components/DemandPlanWaterfallForm.tsx | 130 |
| DivisionField | onChange | <arrow> setSearchParams,gubunResetParams,onDivisionChange,onGubunChange | jsx | features/report/src/pages/demand-plan-waterfall/components/DemandPlanWaterfallForm.tsx | 140 |
| CustomDropdown | onChange | <arrow> setSearchParams,gubunResetParams,onGubunChange | jsx | features/report/src/pages/demand-plan-waterfall/components/DemandPlanWaterfallForm.tsx | 184 |
| TeamField | onChange | <arrow> setSearchParams | jsx | features/report/src/pages/demand-plan-waterfall/components/DemandPlanWaterfallForm.tsx | 199 |
| EndCustomerField | onChange | <arrow> setSearchParams | jsx | features/report/src/pages/demand-plan-waterfall/components/DemandPlanWaterfallForm.tsx | 211 |
| SalesSiteField | onChange | <arrow> setSearchParams | jsx | features/report/src/pages/demand-plan-waterfall/components/DemandPlanWaterfallForm.tsx | 224 |
| InputField | onChange | <arrow> setSearchParams | jsx | features/report/src/pages/demand-plan-waterfall/components/DemandPlanWaterfallForm.tsx | 242 |
| InputField | onDoubleClick | <arrow> setOpenVersionModal | jsx | features/report/src/pages/demand-plan-waterfall/components/DemandPlanWaterfallForm.tsx | 253 |
| Button | onClick | <arrow> setOpenVersionModal | jsx | features/report/src/pages/demand-plan-waterfall/components/DemandPlanWaterfallForm.tsx | 249 |
| PeriodField | onChange | <arrow> setSearchParams | jsx | features/report/src/pages/demand-plan-waterfall/components/DemandPlanWaterfallForm.tsx | 262 |
| CustomDropdown | onChange | <arrow> setSearchParams,onBucketChange | jsx | features/report/src/pages/demand-plan-waterfall/components/DemandPlanWaterfallForm.tsx | 274 |
| CustomDropdown | onChange | <arrow> setSearchParams | jsx | features/report/src/pages/demand-plan-waterfall/components/DemandPlanWaterfallForm.tsx | 299 |
| CustomDropdown | onChange | <arrow> setSearchParams | jsx | features/report/src/pages/demand-plan-waterfall/components/DemandPlanWaterfallForm.tsx | 316 |
| CustomDropdown | onChange | <arrow> setSearchParams | jsx | features/report/src/pages/demand-plan-waterfall/components/DemandPlanWaterfallForm.tsx | 331 |
| CustomDropdown | onChange | <arrow> setSearchParams | jsx | features/report/src/pages/demand-plan-waterfall/components/DemandPlanWaterfallForm.tsx | 346 |
| CustomDropdown | onChange | <arrow> setSearchParams,String(options??'').split(',').filter,String(options??'').split,String | jsx | features/report/src/pages/demand-plan-waterfall/components/DemandPlanWaterfallForm.tsx | 375 |
| ProjectField | onChange | <arrow> setSearchParams | jsx | features/report/src/pages/demand-plan-waterfall/components/DemandPlanWaterfallForm.tsx | 391 |
| ItemField | onChange | <arrow> setSearchParams | jsx | features/report/src/pages/demand-plan-waterfall/components/DemandPlanWaterfallForm.tsx | 402 |
| CustomDropdown | onChange | <arrow> setSearchParams,String(options??'').split(',').filter,String(options??'').split,String | jsx | features/report/src/pages/demand-plan-waterfall/components/DemandPlanWaterfallForm.tsx | 424 |
| BizTypeField | onChange | <arrow> setSearchParams | jsx | features/report/src/pages/demand-plan-waterfall/components/DemandPlanWaterfallForm.tsx | 438 |
| PlantSiteField | onChange | <arrow> setSearchParams | jsx | features/report/src/pages/demand-plan-waterfall/components/DemandPlanWaterfallForm.tsx | 445 |
| OwnerField | onChange | <arrow> setSearchParams | jsx | features/report/src/pages/demand-plan-waterfall/components/DemandPlanWaterfallForm.tsx | 453 |
| Checkbox | onChange | <arrow> setSearchParams | jsx | features/report/src/pages/demand-plan-waterfall/components/DemandPlanWaterfallForm.tsx | 483 |
| WaterfallVersionModal | onApply | <arrow> setSearchParams | jsx | features/report/src/pages/demand-plan-waterfall/components/DemandPlanWaterfallForm.tsx | 507 |
| g | updatedLayout | applyDynVisibility | addHandler | features/report/src/pages/demand-plan-waterfall/components/DemandPlanWaterfallGrid.tsx | 223 |
| g | updatedLayout | applyHeaderHeight | addHandler | features/report/src/pages/demand-plan-waterfall/components/DemandPlanWaterfallGrid.tsx | 267 |
| g | scrollPositionChanged | onScroll | addHandler | features/report/src/pages/demand-plan-waterfall/components/DemandPlanWaterfallGrid.tsx | 298 |
| host | dblclick | onDblClick | addEventListener | features/report/src/pages/demand-plan-waterfall/components/DemandPlanWaterfallGrid.tsx | 325 |
| g | formatItem | handler | addHandler | features/report/src/pages/demand-plan-waterfall/components/DemandPlanWaterfallGrid.tsx | 370 |
| div | onMouseDown | <arrow> e.stopPropagation | jsx | features/report/src/pages/demand-plan-waterfall/components/olap-field-rail/OlapFieldRail.tsx | 101 |
| button | onClick | <arrow> editorRef.current?.clearEditor,editorRef.current?.updateFilter,onApplied,onClose | jsx | features/report/src/pages/demand-plan-waterfall/components/olap-field-rail/OlapFieldRail.tsx | 107 |
| button | onClick | onClose | jsx | features/report/src/pages/demand-plan-waterfall/components/olap-field-rail/OlapFieldRail.tsx | 117 |
| button | onClick | <arrow> editorRef.current?.updateFilter,onApplied,onClose | jsx | features/report/src/pages/demand-plan-waterfall/components/olap-field-rail/OlapFieldRail.tsx | 123 |
| engine | viewDefinitionChanged | refresh | addHandler | features/report/src/pages/demand-plan-waterfall/components/olap-field-rail/OlapFieldRail.tsx | 165 |
| engine | updatedView | refresh | addHandler | features/report/src/pages/demand-plan-waterfall/components/olap-field-rail/OlapFieldRail.tsx | 166 |
| window | pointermove | move | addEventListener | features/report/src/pages/demand-plan-waterfall/components/olap-field-rail/OlapFieldRail.tsx | 241 |
| window | pointerup | up | addEventListener | features/report/src/pages/demand-plan-waterfall/components/olap-field-rail/OlapFieldRail.tsx | 242 |
| window | mousedown | close | addEventListener | features/report/src/pages/demand-plan-waterfall/components/olap-field-rail/OlapFieldRail.tsx | 286 |
| window | mousedown | close | addEventListener | features/report/src/pages/demand-plan-waterfall/components/olap-field-rail/OlapFieldRail.tsx | 295 |
| button | onClick | <arrow> onToggleOpen | jsx | features/report/src/pages/demand-plan-waterfall/components/olap-field-rail/OlapFieldRail.tsx | 309 |
| div | onDragStart | <arrow> startDrag | jsx | features/report/src/pages/demand-plan-waterfall/components/olap-field-rail/OlapFieldRail.tsx | 323 |
| div | onDragEnd | endDrag | jsx | features/report/src/pages/demand-plan-waterfall/components/olap-field-rail/OlapFieldRail.tsx | 324 |
| div | onDragOver | onZoneDragOver(zone, index) | jsx | features/report/src/pages/demand-plan-waterfall/components/olap-field-rail/OlapFieldRail.tsx | 325 |
| div | onDrop | <arrow> e.preventDefault,e.stopPropagation,dropTo | jsx | features/report/src/pages/demand-plan-waterfall/components/olap-field-rail/OlapFieldRail.tsx | 326 |
| span | onMouseDown | <arrow> e.stopPropagation | jsx | features/report/src/pages/demand-plan-waterfall/components/olap-field-rail/OlapFieldRail.tsx | 339 |
| button | onClick | <arrow> setFilterKey | jsx | features/report/src/pages/demand-plan-waterfall/components/olap-field-rail/OlapFieldRail.tsx | 344 |
| FilterEditorPopover | onClose | <arrow> setFilterKey | jsx | features/report/src/pages/demand-plan-waterfall/components/olap-field-rail/OlapFieldRail.tsx | 353 |
| FilterEditorPopover | onApplied | afterEdit | jsx | features/report/src/pages/demand-plan-waterfall/components/olap-field-rail/OlapFieldRail.tsx | 354 |
| span | onMouseDown | <arrow> e.stopPropagation | jsx | features/report/src/pages/demand-plan-waterfall/components/olap-field-rail/OlapFieldRail.tsx | 360 |
| button | onClick | <arrow> setAggMenuKey | jsx | features/report/src/pages/demand-plan-waterfall/components/olap-field-rail/OlapFieldRail.tsx | 364 |
| button | onClick | <arrow> setAggregate,setAggMenuKey,afterEdit | jsx | features/report/src/pages/demand-plan-waterfall/components/olap-field-rail/OlapFieldRail.tsx | 375 |
| button | onClick | <arrow> unplaceField,afterEdit | jsx | features/report/src/pages/demand-plan-waterfall/components/olap-field-rail/OlapFieldRail.tsx | 393 |
| div | onDragOver | onZoneDragOver(zone, items.length) | jsx | features/report/src/pages/demand-plan-waterfall/components/olap-field-rail/OlapFieldRail.tsx | 416 |
| div | onDrop | <arrow> e.preventDefault,dropTo | jsx | features/report/src/pages/demand-plan-waterfall/components/olap-field-rail/OlapFieldRail.tsx | 417 |
| button | onClick | <arrow> onToggleOpen | jsx | features/report/src/pages/demand-plan-waterfall/components/olap-field-rail/OlapFieldRail.tsx | 445 |
| select | onChange | <arrow> onRowTotalsChange | jsx | features/report/src/pages/demand-plan-waterfall/components/olap-field-rail/OlapFieldRail.tsx | 460 |
| input | onChange | <arrow> setQuery | jsx | features/report/src/pages/demand-plan-waterfall/components/olap-field-rail/OlapFieldRail.tsx | 481 |
| div | onPointerDown | <arrow> startSplit | jsx | features/report/src/pages/demand-plan-waterfall/components/olap-field-rail/OlapFieldRail.tsx | 491 |
| div | onDragStart | <arrow> startDrag | jsx | features/report/src/pages/demand-plan-waterfall/components/olap-field-rail/OlapFieldRail.tsx | 516 |
| div | onDragEnd | endDrag | jsx | features/report/src/pages/demand-plan-waterfall/components/olap-field-rail/OlapFieldRail.tsx | 517 |
| button | onClick | <arrow> toggleField,afterEdit | jsx | features/report/src/pages/demand-plan-waterfall/components/olap-field-rail/OlapFieldRail.tsx | 524 |
| div | onPointerDown | <arrow> startSplit | jsx | features/report/src/pages/demand-plan-waterfall/components/olap-field-rail/OlapFieldRail.tsx | 552 |
| button | onClick | <arrow> handleDeferChange | jsx | features/report/src/pages/demand-plan-waterfall/components/olap-field-rail/OlapFieldRail.tsx | 571 |
| button | onClick | handleUpdate | jsx | features/report/src/pages/demand-plan-waterfall/components/olap-field-rail/OlapFieldRail.tsx | 582 |
| select | onChange | <arrow> onChartTypeChange,Number | jsx | features/report/src/pages/demand-plan-waterfall/components/OlapChartPane.tsx | 46 |
| g.hostElement? | dblclick | onDbl | addEventListener | features/report/src/pages/demand-plan-waterfall/components/WaterfallVersionModal.tsx | 317 |
| SearchArea | onSearch | handleFind | jsx | features/report/src/pages/demand-plan-waterfall/components/WaterfallVersionModal.tsx | 345 |
| CustomDropdown | onChange | <arrow> setDivisionId,String | jsx | features/report/src/pages/demand-plan-waterfall/components/WaterfallVersionModal.tsx | 357 |
| PeriodField | onChange | <arrow> setPeriodFrom,setPeriodTo | jsx | features/report/src/pages/demand-plan-waterfall/components/WaterfallVersionModal.tsx | 366 |
| Checkbox | onChange | <arrow> setChkDay | jsx | features/report/src/pages/demand-plan-waterfall/components/WaterfallVersionModal.tsx | 377 |
| Checkbox | onChange | <arrow> setChkWeek | jsx | features/report/src/pages/demand-plan-waterfall/components/WaterfallVersionModal.tsx | 382 |
| Checkbox | onChange | <arrow> setChkManual | jsx | features/report/src/pages/demand-plan-waterfall/components/WaterfallVersionModal.tsx | 387 |
| InputField | onChange | <arrow> setDescription | jsx | features/report/src/pages/demand-plan-waterfall/components/WaterfallVersionModal.tsx | 399 |
| Button | onClick | modalClose | jsx | features/report/src/pages/demand-plan-waterfall/components/WaterfallVersionModal.tsx | 432 |
| Button | onClick | <arrow> handleSave | jsx | features/report/src/pages/demand-plan-waterfall/components/WaterfallVersionModal.tsx | 443 |
| Button | onClick | handleApply | jsx | features/report/src/pages/demand-plan-waterfall/components/WaterfallVersionModal.tsx | 454 |
| DemandPlanWaterfallForm | onSubmit | handleSubmit | jsx | features/report/src/pages/demand-plan-waterfall/DemandPlanWaterfall.tsx | 450 |
| DemandPlanWaterfallForm | onDivisionChange | handleDivisionChange | jsx | features/report/src/pages/demand-plan-waterfall/DemandPlanWaterfall.tsx | 451 |
| DemandPlanWaterfallForm | onBucketChange | handleBucketChange | jsx | features/report/src/pages/demand-plan-waterfall/DemandPlanWaterfall.tsx | 452 |
| DemandPlanWaterfallForm | onGubunChange | handleGubunChange | jsx | features/report/src/pages/demand-plan-waterfall/DemandPlanWaterfall.tsx | 453 |
| ColumnLayoutModal | onSave | handleSaveColumnLayout | jsx | features/report/src/pages/demand-plan-waterfall/DemandPlanWaterfall.tsx | 498 |
| MeasureSelectModal | onApply | handleApplyMeasures | jsx | features/report/src/pages/demand-plan-waterfall/DemandPlanWaterfall.tsx | 516 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Grid | 13 |
| FormItem | 12 |
| CustomDropdown | 9 |
| Button | 4 |
| Checkbox | 4 |
| ResultArea | 3 |
| SearchArea | 2 |
| InputField | 2 |
| PeriodField | 2 |
| Stack | 2 |
| DataGrid | 2 |
| FilterIcon | 2 |
| GripVerticalIcon | 2 |
| ChevronDownIcon | 2 |
| CheckIcon | 2 |
| ControlConfirmIcon | 2 |
| DivisionField | 1 |
| TeamField | 1 |
| EndCustomerField | 1 |
| SalesSiteField | 1 |
| FunctionSearchIcon | 1 |
| ProjectField | 1 |
| ItemField | 1 |
| BizTypeField | 1 |
| PlantSiteField | 1 |
| OwnerField | 1 |
| WaterfallVersionModal | 1 |
| Columns3Icon | 1 |
| Rows3Icon | 1 |
| SigmaIcon | 1 |
| ChevronLeftIcon | 1 |
| FilterEditorPopover | 1 |
| XIcon | 1 |
| ChevronRightIcon | 1 |
| SearchIcon | 1 |
| PivotChart | 1 |
| CustomDialog | 1 |
| ProgressIndicator | 1 |
| IcGridColumnSetup | 1 |
| IcMeasureSelect | 1 |
| MainTitle | 1 |
| DemandPlanWaterfallForm | 1 |
| SubTitle | 1 |
| DemandPlanWaterfallGrid | 1 |
| ColumnLayoutModal | 1 |
| MeasureSelectModal | 1 |

## 6. 하드코딩 Grid 컬럼
| context | binding | header | width | visible | isReadOnly | dataType | via | file | line |
|---|---|---|---|---|---|---|---|---|---|
| VERSION_COLUMNS_BASE | VERSION_NO | Version | 240 |  |  |  | meta-shape | features/report/src/pages/demand-plan-waterfall/components/WaterfallVersionModal.tsx | 63 |
| VERSION_COLUMNS_BASE | VERSION_DESCRIPTION | Description | 300 |  |  |  | meta-shape | features/report/src/pages/demand-plan-waterfall/components/WaterfallVersionModal.tsx | 64 |
| VERSION_COLUMNS_BASE | VERSION_TYPE | Type | 90 |  |  |  | meta-shape | features/report/src/pages/demand-plan-waterfall/components/WaterfallVersionModal.tsx | 65 |
| VERSION_COLUMNS_BASE | CREATED_BY | Create By | 110 |  |  |  | meta-shape | features/report/src/pages/demand-plan-waterfall/components/WaterfallVersionModal.tsx | 66 |
| VERSION_COLUMNS_BASE | CREATION_DATE | Create Date | 150 |  |  |  | meta-shape | features/report/src/pages/demand-plan-waterfall/components/WaterfallVersionModal.tsx | 67 |
| MONTHLY_ROLLING_FCST_COLUMN | MONTHLY_ROLLING_FCST | Monthly Rolling Forecast | 170 | true |  |  | meta-shape | features/report/src/pages/demand-plan-waterfall/components/WaterfallVersionModal.tsx | 84 |
| metaColumns | NICK_NAME | Nick Name |  |  |  |  | meta-shape | features/report/src/pages/demand-plan-waterfall/utils/waterfall.columns.test.ts | 125 |
| base | name | str(row.COLUMN_LABEL_NAME) \|\| meta?.colLblNm \|\| name | width > 0 ? width : undefined | true |  |  | meta-map | features/report/src/pages/demand-plan-waterfall/utils/waterfall.columns.ts | 126 |
| buildStaticColumns | name | meta?.colLblNm \|\| name |  | true |  |  | meta-map | features/report/src/pages/demand-plan-waterfall/utils/waterfall.columns.ts | 149 |
| buildDynamicColumns | m.binding | rank === 2 ? m.leaf \|\| m.small \|\| 'SUM' : 'SUM' | 90 | baseVisibleOf(gubun, bucket, isSumChecked, m.kind) |  |  | object | features/report/src/pages/demand-plan-waterfall/utils/waterfall.columns.ts | 276 |

## 7. 메시지 코드
| code | count |
|---|---|
| LBL00112 | 1 |
| LBL00040 | 1 |
| LBL00606 | 1 |
| LBL00710 | 1 |
| LBL00090 | 1 |
| MSG00013 | 2 |
| MSG00133 | 1 |
| MSG00606 | 2 |
| MSG01288 | 2 |
| LBL00664 | 1 |
| LBL00001 | 1 |
| LBL00852 | 1 |
| LBL00853 | 1 |
| LBL00854 | 1 |
| LBL00608 | 1 |
| LBL00627 | 1 |
| LBL00111 | 1 |
| MSG00137 | 1 |
| MSG00097 | 1 |
| MSG00283 | 1 |
| MSG00108 | 1 |
| MSG00164 | 1 |
| MSG00618 | 2 |
| LBL00605 | 2 |
| LBL00310 | 2 |
| LBL00711 | 1 |
| LBL00764 | 1 |
| LBL00765 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: DMF0035(13), DMF0003(9), DMF0022(6), DMF0082(5), DMF0051(5), DMF0073(3), SCM0002(3), DMF0044(1), SYS0004(1)
- SP/PKG: PKG_DMF0035(6), DMF0073_GET_VERSION_SALESPRICE(4), PR_GET_DAY_RANGE(3), P_DMF0035_SAVE_VERSION_MRF(2), P_PROGRAM_ID(2), P_DIVISION_ID(1), P_VERSION_NO(1), P_MONTHLY_ROLLING_FCST(1), PKG_SCM0002(1), P_SCM0002_GET_VERSIONBYWATERFALLPOPUP(1), PKG_DMF0022(1), DMF0003_GET_REPORT_BUCKET_TYPE_CODE(1), SCM0002_SET_TITLESET_POPUP(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| code | GUBUN 콤보 — 통합 UI 고유 상수 (DMF0044 REPORT_TYPE as-const 선례). 초기값 MKT_FCST (사용자 확정). | features/report/src/pages/demand-plan-waterfall/components/DemandPlanWaterfallForm.tsx | 47 |

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

