# DMF0083 — To-Be Fact Pack 요약

- page_key: `demand/sales-price-model-group` · feature: demand · As-is Fact Pack 없음(화면ID 미대응)
- 파일 17 · 엔드포인트 호출 13 (미해결 0, 주석 속 0) · 이벤트 38 · 컴포넌트 사용 44 · 하드코딩 컬럼 1 · 메시지 33
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 사용 · 하드코딩 컬럼 정의 1건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/demand/src/pages/sales-price-model-group/components/modals/PriceBatchInputModal.module.scss | component | 40 |
| features/demand/src/pages/sales-price-model-group/components/modals/PriceBatchInputModal.tsx | component | 440 |
| features/demand/src/pages/sales-price-model-group/components/modals/priceBatchInputModalStore.ts | store | 36 |
| features/demand/src/pages/sales-price-model-group/components/ModelGroupField.tsx | component | 99 |
| features/demand/src/pages/sales-price-model-group/components/SalesPriceModelGroupForm.tsx | component | 210 |
| features/demand/src/pages/sales-price-model-group/components/SalesPriceModelGroupGrid.module.scss | component | 13 |
| features/demand/src/pages/sales-price-model-group/components/SalesPriceModelGroupGrid.tsx | component | 465 |
| features/demand/src/pages/sales-price-model-group/components/SalesPriceModelGroupModals.tsx | component | 179 |
| features/demand/src/pages/sales-price-model-group/hooks/useSalesPriceModelGroupSave.ts | hook | 121 |
| features/demand/src/pages/sales-price-model-group/index.ts | index | 2 |
| features/demand/src/pages/sales-price-model-group/sales-price-model-group.constants.ts | constants | 136 |
| features/demand/src/pages/sales-price-model-group/sales-price-model-group.types.ts | types | 55 |
| features/demand/src/pages/sales-price-model-group/SalesPriceModelGroup.tsx | page | 343 |
| features/demand/src/pages/sales-price-model-group/useSalesPriceModelGroupStore.ts | store | 238 |
| features/demand/src/pages/sales-price-model-group/utils/sales-price-model-group.grid.ts | util | 201 |
| features/demand/src/pages/sales-price-model-group/utils/sales-price-model-group.save.ts | util | 399 |
| features/demand/src/pages/sales-price-model-group/utils/sales-price-model-group.util.ts | util | 238 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueries) | hook | 4 | Y | PriceBatchInputModal.tsx:121 SalesPriceModelGroupForm.tsx:51 SalesPriceModelGroup.tsx:81 SalesPriceModelGroup.tsx:138 |
| DMF0083/priceBatch//call-proc | hook | 1 | Y | PriceBatchInputModal.tsx:138 |
| DMF0083/priceBatch/EXCHANGE_RATE/call-proc | hook | 1 | Y | PriceBatchInputModal.tsx:153 |
| DMF0083/main//call-proc | hook | 1 | Y | SalesPriceModelGroup.tsx:89 |
| DMF0083/main/SPREAD_TITLE_DATE/call-proc | hook | 1 | Y | SalesPriceModelGroup.tsx:101 |
| DMF0083/main/EXCHANGE_RATE/call-proc | hook | 1 | Y | SalesPriceModelGroup.tsx:113 |
| /admin/menu/DMF0083/column | http | 1 | Y | useSalesPriceModelGroupStore.ts:75 |
| /admin/menu/DMF0083/measure | http | 1 | Y | useSalesPriceModelGroupStore.ts:177 |
| /admin/menu/DMF0083/search-conditions | http | 1 | Y | useSalesPriceModelGroupStore.ts:215 |
| /DMF0083/main/SAVE/call-proc | http | 1 | Y | sales-price-model-group.save.ts:387 |

## 3. procedures.d.ts 등재 시트
| sheet | request_keys | response_cursors | sp_hints |
|---|---|---|---|
| main | divisionId deptId endCustomer scmSiteId projectCode mdlGr fromYyyymmdd toYyyymmdd activeFlag incoterms fcstType currency yyyymmdd measure price prcRpsn | o_rc1 | PKG_DMF0083 P_DMF0083_GET_SCM_MST_FUTURE_PRICE_MDL_GR P_DMF0083_GET_SPREAD_TITLE_DATE P_DMF0083_GET_EXCHANGE_RATE P_DMF0083_SAVE_SCM_MST_FUTURE_PRICE_MDL_GR P_DMF0083_GET_SCM_MST_FUTURE_PRICE_MDL_GR_POPUP DMF0002_GET_TITLESET_POPUP |
| priceBatch | divisionId scmSiteId projectCode mdlGr fromYyyymmdd toYyyymmdd | o_rc1 | PKG_DMF0083 P_DMF0083_GET_SCM_MST_FUTURE_PRICE_MDL_GR P_DMF0083_GET_SPREAD_TITLE_DATE P_DMF0083_GET_EXCHANGE_RATE P_DMF0083_SAVE_SCM_MST_FUTURE_PRICE_MDL_GR P_DMF0083_GET_SCM_MST_FUTURE_PRICE_MDL_GR_POPUP DMF0002_GET_TITLESET_POPUP |
| titleSet | programId sheetName columnType divisionId | o_rc1 | PKG_DMF0083 P_DMF0083_GET_SCM_MST_FUTURE_PRICE_MDL_GR P_DMF0083_GET_SPREAD_TITLE_DATE P_DMF0083_GET_EXCHANGE_RATE P_DMF0083_SAVE_SCM_MST_FUTURE_PRICE_MDL_GR P_DMF0083_GET_SCM_MST_FUTURE_PRICE_MDL_GR_POPUP DMF0002_GET_TITLESET_POPUP |

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| g | formatItem | format | addHandler | features/demand/src/pages/sales-price-model-group/components/modals/PriceBatchInputModal.tsx | 231 |
| g | beginningEdit | guard | addHandler | features/demand/src/pages/sales-price-model-group/components/modals/PriceBatchInputModal.tsx | 232 |
| g | pastingCell | guard | addHandler | features/demand/src/pages/sales-price-model-group/components/modals/PriceBatchInputModal.tsx | 233 |
| g | cellEditEnded | ended | addHandler | features/demand/src/pages/sales-price-model-group/components/modals/PriceBatchInputModal.tsx | 234 |
| g | scrollPositionChanged | onScroll | addHandler | features/demand/src/pages/sales-price-model-group/components/modals/PriceBatchInputModal.tsx | 235 |
| SearchArea | onSearch | handleSearch | jsx | features/demand/src/pages/sales-price-model-group/components/modals/PriceBatchInputModal.tsx | 342 |
| SalesSiteField | onChange | setScmSiteIds | jsx | features/demand/src/pages/sales-price-model-group/components/modals/PriceBatchInputModal.tsx | 359 |
| ProjectField | onChange | setProjectCodes | jsx | features/demand/src/pages/sales-price-model-group/components/modals/PriceBatchInputModal.tsx | 367 |
| ModelGroupField | onChange | setMdlGrs | jsx | features/demand/src/pages/sales-price-model-group/components/modals/PriceBatchInputModal.tsx | 375 |
| PeriodField | onChange | <arrow> setFrom,setTo | jsx | features/demand/src/pages/sales-price-model-group/components/modals/PriceBatchInputModal.tsx | 386 |
| Button | onClick | <arrow> handleSave | jsx | features/demand/src/pages/sales-price-model-group/components/modals/PriceBatchInputModal.tsx | 425 |
| Button | onClick | modalClose | jsx | features/demand/src/pages/sales-price-model-group/components/modals/PriceBatchInputModal.tsx | 432 |
| InputField | onDoubleClick | <arrow> setOpen | jsx | features/demand/src/pages/sales-price-model-group/components/ModelGroupField.tsx | 52 |
| InputField | onChange | <arrow> onChange,event.target.value.split(',').map(v=>v.trim()).filter,event.target.value.split(',').map,event.target.value.split,v.trim | jsx | features/demand/src/pages/sales-price-model-group/components/ModelGroupField.tsx | 55 |
| Button | onClick | <arrow> setOpen | jsx | features/demand/src/pages/sales-price-model-group/components/ModelGroupField.tsx | 70 |
| CustomDropdown | onChange | <arrow> onPick,String(picked??'').split(',').filter,String(picked??'').split,String | jsx | features/demand/src/pages/sales-price-model-group/components/SalesPriceModelGroupForm.tsx | 102 |
| SearchArea | onSearch | onSearch | jsx | features/demand/src/pages/sales-price-model-group/components/SalesPriceModelGroupForm.tsx | 119 |
| CustomDropdown | onChange | <arrow> changeWithConfirm,String | jsx | features/demand/src/pages/sales-price-model-group/components/SalesPriceModelGroupForm.tsx | 132 |
| ProjectField | onChange | <arrow> setSearchParams | jsx | features/demand/src/pages/sales-price-model-group/components/SalesPriceModelGroupForm.tsx | 166 |
| PeriodField | onChange | <arrow> setSearchParams | jsx | features/demand/src/pages/sales-price-model-group/components/SalesPriceModelGroupForm.tsx | 178 |
| ModelGroupField | onChange | <arrow> setSearchParams | jsx | features/demand/src/pages/sales-price-model-group/components/SalesPriceModelGroupForm.tsx | 182 |
| BucketField | onChange | <arrow> useMessageStore.getState().setAlert,useMessageStore.getState,t,setSearchParams | jsx | features/demand/src/pages/sales-price-model-group/components/SalesPriceModelGroupForm.tsx | 193 |
| g | formatItem | formatHandler | addHandler | features/demand/src/pages/sales-price-model-group/components/SalesPriceModelGroupGrid.tsx | 415 |
| g | beginningEdit | beginningEdit | addHandler | features/demand/src/pages/sales-price-model-group/components/SalesPriceModelGroupGrid.tsx | 416 |
| g | pastingCell | pastingCell | addHandler | features/demand/src/pages/sales-price-model-group/components/SalesPriceModelGroupGrid.tsx | 417 |
| g | cellEditEnded | cellEditEnded | addHandler | features/demand/src/pages/sales-price-model-group/components/SalesPriceModelGroupGrid.tsx | 418 |
| g | pastedCell | cellEditEnded | addHandler | features/demand/src/pages/sales-price-model-group/components/SalesPriceModelGroupGrid.tsx | 419 |
| g | scrollPositionChanged | onScroll | addHandler | features/demand/src/pages/sales-price-model-group/components/SalesPriceModelGroupGrid.tsx | 420 |
| g.hostElement | click | clickHandler | addEventListener | features/demand/src/pages/sales-price-model-group/components/SalesPriceModelGroupGrid.tsx | 421 |
| ColumnLayoutModal | onSave | <arrow> settings.filter,saveTitleSet({menuId:MENU_ID,sheetName:SHEETS.MAIN,columnType:TITLESET_COLUMN_TYPE,rows:visible.map((s,i)=>({name:s.COLUMN_NAME,sortOrderNo:i+1,colWidth:s.COL_WIDTH,cellColor:s.CELL_COLOR,textColor:s.TEXT_COLOR,})),}).then,saveTitleSet,visible.map,useMessageStore.getState().setAlert,useMessageStore.getState | jsx | features/demand/src/pages/sales-price-model-group/components/SalesPriceModelGroupModals.tsx | 116 |
| PriceBatchInputModal | onSaved | onBatchSaved | jsx | features/demand/src/pages/sales-price-model-group/components/SalesPriceModelGroupModals.tsx | 174 |
| SalesPriceModelGroupForm | onSearch | handleSearch | jsx | features/demand/src/pages/sales-price-model-group/SalesPriceModelGroup.tsx | 268 |
| SalesPriceModelGroupGrid | onPopupCellDblClick | handlePopupCellDblClick | jsx | features/demand/src/pages/sales-price-model-group/SalesPriceModelGroup.tsx | 315 |
| SalesPriceModelGroupModals | onColumnSettingSaved | <arrow> clearGrid,queryClient.invalidateQueries,fetchGridLayout | jsx | features/demand/src/pages/sales-price-model-group/SalesPriceModelGroup.tsx | 330 |
| SalesPriceModelGroupModals | onBatchSaved | <arrow> refetch | jsx | features/demand/src/pages/sales-price-model-group/SalesPriceModelGroup.tsx | 335 |
| grid | updatedLayout | normalize | addHandler | features/demand/src/pages/sales-price-model-group/utils/sales-price-model-group.grid.ts | 104 |
| grid | loadedRows | reassert | addHandler | features/demand/src/pages/sales-price-model-group/utils/sales-price-model-group.grid.ts | 194 |
| grid | updatedLayout | reassert | addHandler | features/demand/src/pages/sales-price-model-group/utils/sales-price-model-group.grid.ts | 195 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Grid | 4 |
| FormItem | 4 |
| CustomDropdown | 3 |
| Button | 3 |
| SearchArea | 2 |
| ProjectField | 2 |
| ModelGroupField | 2 |
| PeriodField | 2 |
| ProgressIndicator | 2 |
| DataGrid | 2 |
| ItemByDivisionModal | 2 |
| CustomDialog | 1 |
| SalesSiteField | 1 |
| ResultArea | 1 |
| ControlConfirmIcon | 1 |
| InputField | 1 |
| FunctionSearchIcon | 1 |
| BucketField | 1 |
| ColumnLayoutModal | 1 |
| ProjectByDivisionModal | 1 |
| PriceBatchInputModal | 1 |
| MainTitle | 1 |
| SalesPriceModelGroupForm | 1 |
| SubTitle | 1 |
| IcGridColumnSetup | 1 |
| SalesPriceModelGroupGrid | 1 |
| SalesPriceModelGroupModals | 1 |

## 6. 하드코딩 Grid 컬럼
| context | binding | header | width | visible | isReadOnly | dataType | via | file | line |
|---|---|---|---|---|---|---|---|---|---|
| leafOf | DIVISION_ID:DIVISION_ID,END_CUSTOMER:END_CUSTOMER | header | width | true |  |  | object | features/demand/src/pages/sales-price-model-group/utils/sales-price-model-group.grid.ts | 34 |

## 7. 메시지 코드
| code | count |
|---|---|
| LBL01274 | 3 |
| LBL00664 | 1 |
| LBL00001 | 2 |
| LBL00111 | 1 |
| LBL00627 | 1 |
| LBL01092 | 1 |
| LBL00112 | 1 |
| LBL00044 | 1 |
| LBL00080 | 1 |
| LBL00011 | 1 |
| MSG00001 | 1 |
| MSG00004 | 1 |
| MSG00013 | 1 |
| MSG00097 | 1 |
| MSG00108 | 1 |
| MSG00137 | 1 |
| MSG00172 | 1 |
| MSG00227 | 1 |
| MSG00328 | 1 |
| MSG00330 | 1 |
| MSG00409 | 1 |
| MSG00428 | 1 |
| MSG00447 | 1 |
| MSG01429 | 1 |
| MSG00608 | 1 |
| MSG00606 | 1 |
| MSG00618 | 1 |
| MSG00719 | 1 |
| LBL00605 | 2 |

## 8. 주석 속 As-is 참조
- 화면ID: DMF0020(23), DMF0083(8), COM0008(4), COM0005(2), DMF0020_01(1)
- SP/PKG: PKG_DMF0083(12), P_FROM_YYYYMMDD(1), PR_GET_SHEET_MEASURE_LIST(1), P_DMF0083_SAVE_SCM_MST_FUTURE_PRICE_MDL_GR(1), P_OPEN_MDL_GR_CURSOR(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
(없음)

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

