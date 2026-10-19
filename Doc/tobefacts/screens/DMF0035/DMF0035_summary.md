# DMF0035 — To-Be Fact Pack 요약

- page_key: `report/demand-plan-waterfall` · feature: report · As-is Fact Pack 있음
- 파일 19 · 엔드포인트 호출 15 (미해결 2, 주석 속 0) · 이벤트 46 · 컴포넌트 사용 77 · 하드코딩 컬럼 10 · 메시지 34
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 사용 · 하드코딩 컬럼 정의 10건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/report/src/pages/demand-plan-waterfall/components/DemandPlanWaterfallForm.module.scss | component | 17 |
| features/report/src/pages/demand-plan-waterfall/components/DemandPlanWaterfallForm.tsx | component | 522 |
| features/report/src/pages/demand-plan-waterfall/components/DemandPlanWaterfallGrid.tsx | component | 423 |
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
| features/report/src/pages/demand-plan-waterfall/__asis-mapping__.md | mapping | 629 |

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
| versionWf | startYyyymmdd endYyyymmdd createdBy divisionId versionType versionNo | o_rc1 | PKG_DMF0035 P_DMF0035_SAVE_VERSION_MRF PKG_SCM0002 P_SCM0002_GET_VERSIONBYWATERFALLPOPUP P_DMF0035_GET_MKT_FCST_WATERFALL PKG_DMF0022 P_DMF0022_GET_DM_PLN_SALES_PLAN_WATERFALL PKG_DMF0051 P_DMF0051_GET_DM_PLN_BIZ_PLAN_WATERFALL DMF0073_GET_VERSION_SALESPRICE |

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
| InputField | onDoubleClick | <arrow> setOpenVersionModal | jsx | features/report/src/pages/demand-plan-waterfall/components/DemandPlanWaterfallForm.tsx | 257 |
| FunctionSearchIcon | onClick | <arrow> setOpenVersionModal | jsx | features/report/src/pages/demand-plan-waterfall/components/DemandPlanWaterfallForm.tsx | 251 |
| PeriodField | onChange | <arrow> setSearchParams | jsx | features/report/src/pages/demand-plan-waterfall/components/DemandPlanWaterfallForm.tsx | 266 |
| CustomDropdown | onChange | <arrow> setSearchParams,onBucketChange | jsx | features/report/src/pages/demand-plan-waterfall/components/DemandPlanWaterfallForm.tsx | 278 |
| CustomDropdown | onChange | <arrow> setSearchParams | jsx | features/report/src/pages/demand-plan-waterfall/components/DemandPlanWaterfallForm.tsx | 303 |
| CustomDropdown | onChange | <arrow> setSearchParams | jsx | features/report/src/pages/demand-plan-waterfall/components/DemandPlanWaterfallForm.tsx | 320 |
| CustomDropdown | onChange | <arrow> setSearchParams | jsx | features/report/src/pages/demand-plan-waterfall/components/DemandPlanWaterfallForm.tsx | 335 |
| CustomDropdown | onChange | <arrow> setSearchParams | jsx | features/report/src/pages/demand-plan-waterfall/components/DemandPlanWaterfallForm.tsx | 350 |
| CustomDropdown | onChange | <arrow> setSearchParams,String(options??'').split(',').filter,String(options??'').split,String | jsx | features/report/src/pages/demand-plan-waterfall/components/DemandPlanWaterfallForm.tsx | 379 |
| ProjectField | onChange | <arrow> setSearchParams | jsx | features/report/src/pages/demand-plan-waterfall/components/DemandPlanWaterfallForm.tsx | 395 |
| ItemField | onChange | <arrow> setSearchParams | jsx | features/report/src/pages/demand-plan-waterfall/components/DemandPlanWaterfallForm.tsx | 406 |
| CustomDropdown | onChange | <arrow> setSearchParams,String(options??'').split(',').filter,String(options??'').split,String | jsx | features/report/src/pages/demand-plan-waterfall/components/DemandPlanWaterfallForm.tsx | 428 |
| BizTypeField | onChange | <arrow> setSearchParams | jsx | features/report/src/pages/demand-plan-waterfall/components/DemandPlanWaterfallForm.tsx | 442 |
| PlantSiteField | onChange | <arrow> setSearchParams | jsx | features/report/src/pages/demand-plan-waterfall/components/DemandPlanWaterfallForm.tsx | 449 |
| OwnerField | onChange | <arrow> setSearchParams | jsx | features/report/src/pages/demand-plan-waterfall/components/DemandPlanWaterfallForm.tsx | 457 |
| Checkbox | onChange | <arrow> setSearchParams | jsx | features/report/src/pages/demand-plan-waterfall/components/DemandPlanWaterfallForm.tsx | 487 |
| WaterfallVersionModal | onApply | <arrow> setSearchParams | jsx | features/report/src/pages/demand-plan-waterfall/components/DemandPlanWaterfallForm.tsx | 511 |
| g | updatedLayout | applyDynVisibility | addHandler | features/report/src/pages/demand-plan-waterfall/components/DemandPlanWaterfallGrid.tsx | 223 |
| g | updatedLayout | applyHeaderHeight | addHandler | features/report/src/pages/demand-plan-waterfall/components/DemandPlanWaterfallGrid.tsx | 267 |
| g | scrollPositionChanged | onScroll | addHandler | features/report/src/pages/demand-plan-waterfall/components/DemandPlanWaterfallGrid.tsx | 298 |
| host | dblclick | onDblClick | addEventListener | features/report/src/pages/demand-plan-waterfall/components/DemandPlanWaterfallGrid.tsx | 325 |
| g | formatItem | handler | addHandler | features/report/src/pages/demand-plan-waterfall/components/DemandPlanWaterfallGrid.tsx | 370 |
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
| SearchArea | 2 |
| InputField | 2 |
| PeriodField | 2 |
| Stack | 2 |
| DataGrid | 2 |
| ResultArea | 2 |
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

