# DMF0053 — To-Be Fact Pack 요약

- page_key: `demand/cust-fcst-waterfall` · feature: demand · As-is Fact Pack 있음
- 파일 11 · 엔드포인트 호출 9 (미해결 0, 주석 속 0) · 이벤트 20 · 컴포넌트 사용 33 · 하드코딩 컬럼 3 · 메시지 21
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 사용 · 하드코딩 컬럼 정의 3건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/demand/src/pages/cust-fcst-waterfall/components/CustFcstWaterfallForm.tsx | component | 379 |
| features/demand/src/pages/cust-fcst-waterfall/components/CustFcstWaterfallGrid.tsx | component | 552 |
| features/demand/src/pages/cust-fcst-waterfall/cust-fcst-waterfall.constants.test.ts | test | 48 |
| features/demand/src/pages/cust-fcst-waterfall/cust-fcst-waterfall.constants.ts | constants | 94 |
| features/demand/src/pages/cust-fcst-waterfall/cust-fcst-waterfall.types.ts | types | 46 |
| features/demand/src/pages/cust-fcst-waterfall/CustFcstWaterfall.tsx | page | 304 |
| features/demand/src/pages/cust-fcst-waterfall/index.ts | index | 2 |
| features/demand/src/pages/cust-fcst-waterfall/useCustFcstWaterfallStore.ts | store | 282 |
| features/demand/src/pages/cust-fcst-waterfall/utils/cust-fcst-waterfall.api.ts | api | 49 |
| features/demand/src/pages/cust-fcst-waterfall/utils/cust-fcst-waterfall.searchCombos.ts | util | 68 |
| features/demand/src/pages/cust-fcst-waterfall/__asis-mapping__.md | mapping | 182 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueries) | hook | 3 | Y | CustFcstWaterfallForm.tsx:65 CustFcstWaterfallForm.tsx:76 CustFcstWaterfall.tsx:93 |
| DMF0053/custFcstWaterfall//call-proc | hook | 1 | Y | CustFcstWaterfall.tsx:64 |
| DMF0053/spreadTitle//call-proc | hook | 1 | Y | CustFcstWaterfall.tsx:71 |
| /admin/menu/DMF0053/search-conditions | http | 1 | Y | useCustFcstWaterfallStore.ts:143 |
| /admin/menu/DMF0053/column | http | 1 | Y | useCustFcstWaterfallStore.ts:221 |
| /admin/menu/DMF0053/measure | http | 1 | Y | useCustFcstWaterfallStore.ts:239 |
| /DMF0053/titleSet/SAVE/call-proc | http | 1 | Y | cust-fcst-waterfall.api.ts:38 |

## 3. procedures.d.ts 등재 시트
| sheet | request_keys | response_cursors | sp_hints |
|---|---|---|---|
| custFcstWaterfall | divisionId deptId endCustomer scmSiteId projectCode itemId itemType fromYyyymmdd toYyyymmdd sesUserId plantSiteId bizType owner bucket userDeptId groupId versionNo fromCreatedate toCreatedate userId mnuId | o_rc1 | PKG_DMF0082 P_DMF0082_GET_MAIN_DATA DMF0082_GET_SPREAD_TITLE PKG_DMF0053 P_DMF0053_GET_CUST_FCST_WATERFALL P_DMF0053_GET_SPREAD_TITLE |
| spreadTitle | startYyyymmdd endYyyymmdd sesUserId divisionId bucket userId mnuId | o_rc1 | PKG_DMF0082 P_DMF0082_GET_MAIN_DATA DMF0082_GET_SPREAD_TITLE PKG_DMF0053 P_DMF0053_GET_CUST_FCST_WATERFALL P_DMF0053_GET_SPREAD_TITLE |

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| CustomDropdown | onChange | <arrow> onPick,String(picked??'').split(',').filter,String(picked??'').split,String | jsx | features/demand/src/pages/cust-fcst-waterfall/components/CustFcstWaterfallForm.tsx | 148 |
| SearchArea | onSearch | onSubmit | jsx | features/demand/src/pages/cust-fcst-waterfall/components/CustFcstWaterfallForm.tsx | 181 |
| CustomDropdown | onChange | <arrow> String,setSearchParams,onDivisionChange | jsx | features/demand/src/pages/cust-fcst-waterfall/components/CustFcstWaterfallForm.tsx | 196 |
| PeriodField | onChange | <arrow> setSearchParams | jsx | features/demand/src/pages/cust-fcst-waterfall/components/CustFcstWaterfallForm.tsx | 245 |
| PeriodField | onChange | <arrow> setSearchParams | jsx | features/demand/src/pages/cust-fcst-waterfall/components/CustFcstWaterfallForm.tsx | 253 |
| CustomDropdown | onChange | <arrow> setSearchParams,onBucketChange | jsx | features/demand/src/pages/cust-fcst-waterfall/components/CustFcstWaterfallForm.tsx | 265 |
| ProjectField | onChange | <arrow> setSearchParams | jsx | features/demand/src/pages/cust-fcst-waterfall/components/CustFcstWaterfallForm.tsx | 283 |
| ItemField | onChange | <arrow> setSearchParams | jsx | features/demand/src/pages/cust-fcst-waterfall/components/CustFcstWaterfallForm.tsx | 294 |
| CustomDropdown | onChange | <arrow> setSearchParams,String(options??'').split(',').filter,String(options??'').split,String | jsx | features/demand/src/pages/cust-fcst-waterfall/components/CustFcstWaterfallForm.tsx | 322 |
| OwnerField | onChange | <arrow> setSearchParams | jsx | features/demand/src/pages/cust-fcst-waterfall/components/CustFcstWaterfallForm.tsx | 337 |
| CustomDropdown | onChange | <arrow> setSearchParams | jsx | features/demand/src/pages/cust-fcst-waterfall/components/CustFcstWaterfallForm.tsx | 354 |
| Checkbox | onChange | <arrow> setSearchParams | jsx | features/demand/src/pages/cust-fcst-waterfall/components/CustFcstWaterfallForm.tsx | 369 |
| g | updatedLayout | applyHeaderHeight | addHandler | features/demand/src/pages/cust-fcst-waterfall/components/CustFcstWaterfallGrid.tsx | 370 |
| g.hostElement? | dblclick | onDblClick | addEventListener | features/demand/src/pages/cust-fcst-waterfall/components/CustFcstWaterfallGrid.tsx | 496 |
| g | formatItem | formatHandler | addHandler | features/demand/src/pages/cust-fcst-waterfall/components/CustFcstWaterfallGrid.tsx | 526 |
| CustFcstWaterfallForm | onSubmit | handleSubmit | jsx | features/demand/src/pages/cust-fcst-waterfall/CustFcstWaterfall.tsx | 223 |
| CustFcstWaterfallForm | onDivisionChange | handleDivisionChange | jsx | features/demand/src/pages/cust-fcst-waterfall/CustFcstWaterfall.tsx | 224 |
| CustFcstWaterfallForm | onBucketChange | handleBucketChange | jsx | features/demand/src/pages/cust-fcst-waterfall/CustFcstWaterfall.tsx | 225 |
| ColumnLayoutModal | onSave | <arrow> applyColumnLayout,settings.map,settings.filter,saveTitleSet,visible.map,clearData | jsx | features/demand/src/pages/cust-fcst-waterfall/CustFcstWaterfall.tsx | 258 |
| MeasureSelectModal | onApply | <arrow> staticMeasures.map,saveTitleSet,selected.map,clearData | jsx | features/demand/src/pages/cust-fcst-waterfall/CustFcstWaterfall.tsx | 291 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Grid | 6 |
| FormItem | 6 |
| CustomDropdown | 5 |
| PeriodField | 2 |
| SearchArea | 1 |
| ProjectField | 1 |
| ItemField | 1 |
| OwnerField | 1 |
| Checkbox | 1 |
| DataGrid | 1 |
| IcGridColumnSetup | 1 |
| IcMeasureSelect | 1 |
| MainTitle | 1 |
| CustFcstWaterfallForm | 1 |
| SubTitle | 1 |
| CustFcstWaterfallGrid | 1 |
| ColumnLayoutModal | 1 |
| MeasureSelectModal | 1 |

## 6. 하드코딩 Grid 컬럼
| context | binding | header | width | visible | isReadOnly | dataType | via | file | line |
|---|---|---|---|---|---|---|---|---|---|
| dynColMetas | String(r.COLUMN_NAME) |  | widthOf(r.COLUMN_WIDTH) |  |  |  | object | features/demand/src/pages/cust-fcst-waterfall/components/CustFcstWaterfallGrid.tsx | 132 |
| dynColMetas | b |  | widthOf('') |  |  |  | object | features/demand/src/pages/cust-fcst-waterfall/components/CustFcstWaterfallGrid.tsx | 149 |
| dynamicColumns | m.binding | isOnlyWeekly ? 'SUM' : dailyVisible ? m.kind === 'D' ? m.lea | m.width | dynVisible(m.binding) | true |  | object | features/demand/src/pages/cust-fcst-waterfall/components/CustFcstWaterfallGrid.tsx | 216 |

## 7. 메시지 코드
| code | count |
|---|---|
| LBL00112 | 1 |
| LBL00001 | 1 |
| LBL00502 | 1 |
| LBL00080 | 1 |
| LBL00506 | 1 |
| LBL00085 | 1 |
| LBL00302 | 1 |
| LBL00710 | 1 |
| LBL00005 | 1 |
| LBL00068 | 1 |
| LBL00687 | 1 |
| MSG00097 | 1 |
| MSG00108 | 1 |
| MSG00164 | 1 |
| MSG00013 | 1 |
| LBL00605 | 2 |
| LBL00310 | 2 |
| LBL00764 | 1 |
| LBL00765 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: DMF0040(15), DMF0053(9), DMF0035(2), DMF0048(2), DMF0021(1)
- SP/PKG: P_DMF0053_GET_SPREAD_TITLE(5), PKG_DMF0053(4), P_DMF0053_GET_CUST_FCST_WATERFALL(2), DMF0003_GET_REPORT_BUCKET_TYPE_CODE(1), PR_GET_DAY_RANGE(1), P_USER_DEPT_ID(1), P_GROUP_ID(1), P_USER_ID(1), P_MENU_ID(1), SCM0002_SET_TITLESET_POPUP(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
(없음)

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

