# DMF0020 — To-Be Fact Pack 요약

- page_key: `master/sales-future-price` · feature: master · As-is Fact Pack 있음
- 파일 35 · 엔드포인트 호출 23 (미해결 0, 주석 속 5) · 이벤트 64 · 컴포넌트 사용 92 · 하드코딩 컬럼 39 · 메시지 96
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 사용 · 하드코딩 컬럼 정의 39건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/master/src/pages/sales-future-price/components/modals/ExchangeRateModal.module.scss | component | 88 |
| features/master/src/pages/sales-future-price/components/modals/ExchangeRateModal.tsx | component | 521 |
| features/master/src/pages/sales-future-price/components/modals/exchangeRateModalStore.ts | store | 32 |
| features/master/src/pages/sales-future-price/components/modals/priceBatchCombos.ts | component | 51 |
| features/master/src/pages/sales-future-price/components/modals/PriceBatchInputModal.module.scss | component | 60 |
| features/master/src/pages/sales-future-price/components/modals/PriceBatchInputModal.tsx | component | 1445 |
| features/master/src/pages/sales-future-price/components/modals/priceBatchInputModalStore.ts | store | 33 |
| features/master/src/pages/sales-future-price/components/modals/SalesPriceRangeModal.module.scss | component | 48 |
| features/master/src/pages/sales-future-price/components/modals/SalesPriceRangeModal.tsx | component | 312 |
| features/master/src/pages/sales-future-price/components/modals/SalesPriceVersionModal.module.scss | component | 40 |
| features/master/src/pages/sales-future-price/components/modals/SalesPriceVersionModal.tsx | component | 322 |
| features/master/src/pages/sales-future-price/components/modals/salesPriceVersionModalStore.ts | store | 48 |
| features/master/src/pages/sales-future-price/components/SalesFuturePriceForm.module.scss | component | 18 |
| features/master/src/pages/sales-future-price/components/SalesFuturePriceForm.tsx | component | 341 |
| features/master/src/pages/sales-future-price/components/SalesFuturePriceGrid.tsx | component | 1272 |
| features/master/src/pages/sales-future-price/hooks/useSalesFuturePriceExpression.ts | hook | 97 |
| features/master/src/pages/sales-future-price/hooks/useSalesFuturePriceValidation.ts | hook | 206 |
| features/master/src/pages/sales-future-price/index.ts | index | 2 |
| features/master/src/pages/sales-future-price/sales-future-price.constants.ts | constants | 432 |
| features/master/src/pages/sales-future-price/sales-future-price.types.ts | types | 82 |
| features/master/src/pages/sales-future-price/SalesFuturePrice.module.scss | style | 148 |
| features/master/src/pages/sales-future-price/SalesFuturePrice.tsx | page | 1146 |
| features/master/src/pages/sales-future-price/salesPriceExchange.ts | other | 107 |
| features/master/src/pages/sales-future-price/useSalesFuturePriceStore.ts | store | 464 |
| features/master/src/pages/sales-future-price/utils/cellBackground.ts | util | 25 |
| features/master/src/pages/sales-future-price/utils/editableDivision.ts | util | 8 |
| features/master/src/pages/sales-future-price/utils/futurePriceDate.ts | util | 62 |
| features/master/src/pages/sales-future-price/utils/futurePriceGroup.ts | util | 20 |
| features/master/src/pages/sales-future-price/utils/overRange.ts | util | 53 |
| features/master/src/pages/sales-future-price/utils/periodAxis.ts | util | 63 |
| features/master/src/pages/sales-future-price/utils/priceBatchCombos.ts | util | 51 |
| features/master/src/pages/sales-future-price/utils/salesPriceAutoMap.test.ts | test | 88 |
| features/master/src/pages/sales-future-price/utils/salesPriceAutoMap.ts | util | 66 |
| features/master/src/pages/sales-future-price/utils/searchCombos.ts | util | 36 |
| features/master/src/pages/sales-future-price/__asis-mapping__.md | mapping | 307 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueries) | hook | 8 | Y | ExchangeRateModal.tsx:76 PriceBatchInputModal.tsx:344 SalesPriceVersionModal.tsx:93 SalesFuturePriceForm.tsx:68 SalesFuturePriceForm.tsx:80 SalesFuturePrice.tsx:148 |
| DMF0020/exchange//call-proc | hook | 3 | Y | ExchangeRateModal.tsx:120 PriceBatchInputModal.tsx:490 SalesFuturePrice.tsx:240 |
| DMF0020/priceBatch//call-proc | hook | 1 | Y | PriceBatchInputModal.tsx:469 |
| /DMF0020/main/SAVE/call-proc | http | 2 | Y | PriceBatchInputModal.tsx:838 SalesFuturePrice.tsx:773 |
| /DMF0020/priceBatch/SAVE/call-proc | http | 1 | Y | SalesPriceRangeModal.tsx:196 |
| DMF0020/version//call-proc | hook | 1 | Y | SalesPriceVersionModal.tsx:141 |
| DMF0020/main//call-proc | hook | 1 | Y | SalesFuturePrice.tsx:193 |
| /DMF0020/main/SPREAD_TITLE_DATE/call-proc | http | 1 | Y | SalesFuturePrice.tsx:216 |
| /admin/menu/DMF0020/column | http | 2 | Y | useSalesFuturePriceStore.ts:265 useSalesFuturePriceStore.ts:297 |
| /admin/menu/DMF0020/measure | http | 1 | Y | useSalesFuturePriceStore.ts:320 |
| /admin/menu/DMF0020/search-conditions | http | 1 | Y | useSalesFuturePriceStore.ts:349 |
| DMF0020/titleSet/SEARCH/call-proc | http | 1 | Y | useSalesFuturePriceStore.ts:397 |

## 3. procedures.d.ts 등재 시트
| sheet | request_keys | response_cursors | sp_hints |
|---|---|---|---|
| main | startYyyymmdd endYyyymmdd | o_rc1 | PKG_DMF0008 DMF0000_GET_COMMON_SPREAD_TITLE DMF0000_GET_UPDATE_HISTORY PKG_DMF0020 P_DMF0020_GET_FUTUREPRICE_INFO P_DMF0000_SAVE_EXCHANGE_POPUP_DATA |
| pivot | startYyyymmdd endYyyymmdd | o_rc1 | PKG_DMF0008 DMF0000_GET_COMMON_SPREAD_TITLE DMF0000_GET_UPDATE_HISTORY PKG_DMF0020 P_DMF0020_GET_FUTUREPRICE_INFO P_DMF0000_SAVE_EXCHANGE_POPUP_DATA |
| exchange | startYyyymmdd endYyyymmdd | o_rc1 | PKG_DMF0008 DMF0000_GET_COMMON_SPREAD_TITLE DMF0000_GET_UPDATE_HISTORY PKG_DMF0020 P_DMF0020_GET_FUTUREPRICE_INFO P_DMF0000_SAVE_EXCHANGE_POPUP_DATA |
| priceBatch | divisionId fromYyyymmdd toYyyymmdd createdBy | o_rc1 | PKG_DMF0008 DMF0000_GET_COMMON_SPREAD_TITLE DMF0000_GET_UPDATE_HISTORY PKG_DMF0020 P_DMF0020_GET_FUTUREPRICE_INFO P_DMF0000_SAVE_EXCHANGE_POPUP_DATA |
| version | startYyyymmdd endYyyymmdd createdBy divisionId versionType description | o_rc1 | PKG_DMF0008 DMF0000_GET_COMMON_SPREAD_TITLE DMF0000_GET_UPDATE_HISTORY PKG_DMF0020 P_DMF0020_GET_FUTUREPRICE_INFO P_DMF0000_SAVE_EXCHANGE_POPUP_DATA |
| titleSet | programId sheetName columnType divisionId | o_rc1 | PKG_DMF0008 DMF0000_GET_COMMON_SPREAD_TITLE DMF0000_GET_UPDATE_HISTORY PKG_DMF0020 P_DMF0020_GET_FUTUREPRICE_INFO P_DMF0000_SAVE_EXCHANGE_POPUP_DATA |
| owner | divisionId | o_rc1 | PKG_DMF0008 DMF0000_GET_COMMON_SPREAD_TITLE DMF0000_GET_UPDATE_HISTORY PKG_DMF0020 P_DMF0020_GET_FUTUREPRICE_INFO P_DMF0000_SAVE_EXCHANGE_POPUP_DATA |
| spreadTitle | startYyyymmdd endYyyymmdd | o_rc1 | PKG_DMF0008 DMF0000_GET_COMMON_SPREAD_TITLE DMF0000_GET_UPDATE_HISTORY PKG_DMF0020 P_DMF0020_GET_FUTUREPRICE_INFO P_DMF0000_SAVE_EXCHANGE_POPUP_DATA |
| spreadTitleDate | startYyyymmdd endYyyymmdd | o_rc1 | PKG_DMF0008 DMF0000_GET_COMMON_SPREAD_TITLE DMF0000_GET_UPDATE_HISTORY PKG_DMF0020 P_DMF0020_GET_FUTUREPRICE_INFO P_DMF0000_SAVE_EXCHANGE_POPUP_DATA |
| measureCount |  | o_rc1 | PKG_DMF0008 DMF0000_GET_COMMON_SPREAD_TITLE DMF0000_GET_UPDATE_HISTORY PKG_DMF0020 P_DMF0020_GET_FUTUREPRICE_INFO P_DMF0000_SAVE_EXCHANGE_POPUP_DATA |

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| g | formatItem | formatHandler | addHandler | features/master/src/pages/sales-future-price/components/modals/ExchangeRateModal.tsx | 252 |
| g | updatedLayout | normalizeHeader | addHandler | features/master/src/pages/sales-future-price/components/modals/ExchangeRateModal.tsx | 359 |
| SearchArea | onSearch | handleFind | jsx | features/master/src/pages/sales-future-price/components/modals/ExchangeRateModal.tsx | 416 |
| CustomDropdown | onChange | <arrow> setDivisionId,String | jsx | features/master/src/pages/sales-future-price/components/modals/ExchangeRateModal.tsx | 428 |
| DatePickerCalendar | onChange | <arrow> setPeriodFrom,date?.format | jsx | features/master/src/pages/sales-future-price/components/modals/ExchangeRateModal.tsx | 447 |
| DatePickerCalendar | onChange | <arrow> setPeriodTo,date?.format | jsx | features/master/src/pages/sales-future-price/components/modals/ExchangeRateModal.tsx | 461 |
| Button | onClick | modalClose | jsx | features/master/src/pages/sales-future-price/components/modals/ExchangeRateModal.tsx | 513 |
| g | formatItem | formatHandler | addHandler | features/master/src/pages/sales-future-price/components/modals/PriceBatchInputModal.tsx | 949 |
| g | beginningEdit | beginningEditHandler | addHandler | features/master/src/pages/sales-future-price/components/modals/PriceBatchInputModal.tsx | 962 |
| g | pastingCell | beginningEditHandler | addHandler | features/master/src/pages/sales-future-price/components/modals/PriceBatchInputModal.tsx | 963 |
| g | scrollPositionChanged | handleScrollInvalidate | addHandler | features/master/src/pages/sales-future-price/components/modals/PriceBatchInputModal.tsx | 967 |
| g | updatedLayout | reattachDataMaps | addHandler | features/master/src/pages/sales-future-price/components/modals/PriceBatchInputModal.tsx | 1065 |
| g | updatedLayout | normalizeHeader | addHandler | features/master/src/pages/sales-future-price/components/modals/PriceBatchInputModal.tsx | 1134 |
| SearchArea | onSearch | handleFind | jsx | features/master/src/pages/sales-future-price/components/modals/PriceBatchInputModal.tsx | 1242 |
| CustomDropdown | onChange | <arrow> setDivisionId,String | jsx | features/master/src/pages/sales-future-price/components/modals/PriceBatchInputModal.tsx | 1258 |
| SalesSiteField | onChange | setSalesSite | jsx | features/master/src/pages/sales-future-price/components/modals/PriceBatchInputModal.tsx | 1271 |
| InputField | onChange | <arrow> setProjectCode | jsx | features/master/src/pages/sales-future-price/components/modals/PriceBatchInputModal.tsx | 1286 |
| InputField | onDoubleClick | <arrow> setOpenProject | jsx | features/master/src/pages/sales-future-price/components/modals/PriceBatchInputModal.tsx | 1287 |
| Button | onClick | <arrow> setOpenProject | jsx | features/master/src/pages/sales-future-price/components/modals/PriceBatchInputModal.tsx | 1293 |
| InputField | onChange | <arrow> setItemId | jsx | features/master/src/pages/sales-future-price/components/modals/PriceBatchInputModal.tsx | 1309 |
| InputField | onDoubleClick | <arrow> setOpenItem | jsx | features/master/src/pages/sales-future-price/components/modals/PriceBatchInputModal.tsx | 1310 |
| Button | onClick | <arrow> setOpenItem | jsx | features/master/src/pages/sales-future-price/components/modals/PriceBatchInputModal.tsx | 1316 |
| PeriodField | onChange | <arrow> setPeriodFrom,snapMonday,setPeriodTo | jsx | features/master/src/pages/sales-future-price/components/modals/PriceBatchInputModal.tsx | 1328 |
| Button | onClick | handleExcel | jsx | features/master/src/pages/sales-future-price/components/modals/PriceBatchInputModal.tsx | 1374 |
| Button | onClick | handleSave | jsx | features/master/src/pages/sales-future-price/components/modals/PriceBatchInputModal.tsx | 1384 |
| Button | onClick | modalClose | jsx | features/master/src/pages/sales-future-price/components/modals/PriceBatchInputModal.tsx | 1391 |
| g | formatItem | formatHandler | addHandler | features/master/src/pages/sales-future-price/components/modals/SalesPriceRangeModal.tsx | 128 |
| Button | onClick | handleExcel | jsx | features/master/src/pages/sales-future-price/components/modals/SalesPriceRangeModal.tsx | 287 |
| Button | onClick | handleSave | jsx | features/master/src/pages/sales-future-price/components/modals/SalesPriceRangeModal.tsx | 297 |
| Button | onClick | modalClose | jsx | features/master/src/pages/sales-future-price/components/modals/SalesPriceRangeModal.tsx | 304 |
| g.hostElement? | dblclick | onDbl | addEventListener | features/master/src/pages/sales-future-price/components/modals/SalesPriceVersionModal.tsx | 197 |
| SearchArea | onSearch | handleFind | jsx | features/master/src/pages/sales-future-price/components/modals/SalesPriceVersionModal.tsx | 229 |
| CustomDropdown | onChange | <arrow> setSearchParams,String | jsx | features/master/src/pages/sales-future-price/components/modals/SalesPriceVersionModal.tsx | 242 |
| PeriodField | onChange | <arrow> setSearchParams | jsx | features/master/src/pages/sales-future-price/components/modals/SalesPriceVersionModal.tsx | 251 |
| InputField | onChange | <arrow> setSearchParams | jsx | features/master/src/pages/sales-future-price/components/modals/SalesPriceVersionModal.tsx | 262 |
| Button | onClick | handleApply | jsx | features/master/src/pages/sales-future-price/components/modals/SalesPriceVersionModal.tsx | 307 |
| Button | onClick | modalClose | jsx | features/master/src/pages/sales-future-price/components/modals/SalesPriceVersionModal.tsx | 314 |
| CustomDropdown | onChange | <arrow> onPick,String(picked??'').split(',').filter,String(picked??'').split,String | jsx | features/master/src/pages/sales-future-price/components/SalesFuturePriceForm.tsx | 168 |
| SearchArea | onSearch | onSearch | jsx | features/master/src/pages/sales-future-price/components/SalesFuturePriceForm.tsx | 185 |
| CustomDropdown | onChange | <arrow> confirmIfDirtyKey(tabDirtyKey(tabId),'search').then,confirmIfDirtyKey,tabDirtyKey,set,String | jsx | features/master/src/pages/sales-future-price/components/SalesFuturePriceForm.tsx | 199 |
| ProjectField | onChange | <arrow> set | jsx | features/master/src/pages/sales-future-price/components/SalesFuturePriceForm.tsx | 252 |
| PeriodField | onChange | <arrow> set | jsx | features/master/src/pages/sales-future-price/components/SalesFuturePriceForm.tsx | 265 |
| ItemField | onChange | <arrow> set | jsx | features/master/src/pages/sales-future-price/components/SalesFuturePriceForm.tsx | 284 |
| OwnerField | onChange | <arrow> set | jsx | features/master/src/pages/sales-future-price/components/SalesFuturePriceForm.tsx | 296 |
| BucketField | onChange | <arrow> validate.validateBucketChange,set | jsx | features/master/src/pages/sales-future-price/components/SalesFuturePriceForm.tsx | 308 |
| VersionField | onOpenPopup | onVersionOpen | jsx | features/master/src/pages/sales-future-price/components/SalesFuturePriceForm.tsx | 314 |
| SearchOverRangeField | onChange | <arrow> thisWeekMonday,end.setDate,start.getDate,set,yyyymmddOf | jsx | features/master/src/pages/sales-future-price/components/SalesFuturePriceForm.tsx | 320 |
| g | formatItem | formatHandler | addHandler | features/master/src/pages/sales-future-price/components/SalesFuturePriceGrid.tsx | 594 |
| g | beginningEdit | beginningEditHandler | addHandler | features/master/src/pages/sales-future-price/components/SalesFuturePriceGrid.tsx | 721 |
| g | pastingCell | pastingCellHandler | addHandler | features/master/src/pages/sales-future-price/components/SalesFuturePriceGrid.tsx | 746 |
| g | cellEditEnded | cellEditEndedHandler | addHandler | features/master/src/pages/sales-future-price/components/SalesFuturePriceGrid.tsx | 923 |
| g | pastedCell | cellEditEndedHandler | addHandler | features/master/src/pages/sales-future-price/components/SalesFuturePriceGrid.tsx | 924 |
| g.hostElement | click | clickAsDblHandler | addEventListener | features/master/src/pages/sales-future-price/components/SalesFuturePriceGrid.tsx | 968 |
| g | scrollPositionChanged | handleScrollInvalidate | addHandler | features/master/src/pages/sales-future-price/components/SalesFuturePriceGrid.tsx | 974 |
| g | updatedLayout | applyHeaderHeight | addHandler | features/master/src/pages/sales-future-price/components/SalesFuturePriceGrid.tsx | 1174 |
| f | filterApplied | onFilterApplied | addHandler | features/master/src/pages/sales-future-price/components/SalesFuturePriceGrid.tsx | 1206 |
| SalesFuturePriceForm | onSearch | handleSearch | jsx | features/master/src/pages/sales-future-price/SalesFuturePrice.tsx | 878 |
| SalesFuturePriceForm | onVersionOpen | <arrow> setOpenVersion | jsx | features/master/src/pages/sales-future-price/SalesFuturePrice.tsx | 879 |
| SalesFuturePriceGrid | onPopupCellDblClick | handlePopupCellDblClick | jsx | features/master/src/pages/sales-future-price/SalesFuturePrice.tsx | 942 |
| PriceBatchInputModal | onSaveResult | <arrow> refetch | jsx | features/master/src/pages/sales-future-price/SalesFuturePrice.tsx | 963 |
| PriceBatchInputModal | onRangeOver | <arrow> setRangeRows,setOpenRange | jsx | features/master/src/pages/sales-future-price/SalesFuturePrice.tsx | 965 |
| SalesPriceVersionModal | onApply | <arrow> setSearchCondition,normalizeVersionIds | jsx | features/master/src/pages/sales-future-price/SalesFuturePrice.tsx | 975 |
| SalesPriceRangeModal | onSaved | <arrow> refetch | jsx | features/master/src/pages/sales-future-price/SalesFuturePrice.tsx | 983 |
| ColumnLayoutModal | onSave | <arrow> clearGridOnSettingChange,applyColumnLayout,settings.map,settings.filter,saveTitleSet({menuId:MENU_ID,//⚠️팝업이조회에쓰는값과동일해야한다—상수한곳에서만가져온다.sheetName:TITLESET_SHEET,columnType:TITLESET_COLUMN_TYPE,rows:visible.map((s,i)=>({name:s.COLUMN_NAME,sortOrderNo:i+1,colWidth:s.COL_WIDTH,cellColor:s.CELL_COLOR,textColor:s.TEXT_COLOR,})),}).then,saveTitleSet | jsx | features/master/src/pages/sales-future-price/SalesFuturePrice.tsx | 1002 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Button | 11 |
| Grid | 9 |
| FormItem | 9 |
| CustomDropdown | 5 |
| DataGrid | 5 |
| CustomDialog | 4 |
| SearchArea | 4 |
| ProgressIndicator | 4 |
| ResultArea | 4 |
| InputField | 3 |
| PeriodField | 3 |
| ControlConfirmIcon | 3 |
| DatePickerCalendar | 2 |
| FunctionSearchIcon | 2 |
| FileExceldownloadIcon | 2 |
| ProjectByDivisionModal | 2 |
| ItemByDivisionModal | 2 |
| SalesSiteField | 1 |
| ProjectField | 1 |
| ItemField | 1 |
| OwnerField | 1 |
| BucketField | 1 |
| VersionField | 1 |
| SearchOverRangeField | 1 |
| MainTitle | 1 |
| SalesFuturePriceForm | 1 |
| SubTitle | 1 |
| IcExchangeRate | 1 |
| IcGridColumnSetup | 1 |
| SalesFuturePriceGrid | 1 |
| ExchangeRateModal | 1 |
| PriceBatchInputModal | 1 |
| SalesPriceVersionModal | 1 |
| SalesPriceRangeModal | 1 |
| ColumnLayoutModal | 1 |

## 6. 하드코딩 Grid 컬럼
| context | binding | header | width | visible | isReadOnly | dataType | via | file | line |
|---|---|---|---|---|---|---|---|---|---|
| gridStaticColumns | c.key | c.header | c.width | true |  |  | meta-map | features/master/src/pages/sales-future-price/components/modals/ExchangeRateModal.tsx | 190 |
| gridDynamicColumns | `M_${ym}` | ym.slice(4, 6) | 90 | true | true |  | object | features/master/src/pages/sales-future-price/components/modals/ExchangeRateModal.tsx | 211 |
| FALLBACK_FIXED | DIVISION_ID | Div* | 50 |  |  |  | meta-shape | features/master/src/pages/sales-future-price/components/modals/PriceBatchInputModal.tsx | 109 |
| FALLBACK_FIXED | DEPT_ID | Team | 100 |  |  |  | meta-shape | features/master/src/pages/sales-future-price/components/modals/PriceBatchInputModal.tsx | 110 |
| FALLBACK_FIXED | SCM_SITE_ID | Sales Site* | 140 |  |  |  | meta-shape | features/master/src/pages/sales-future-price/components/modals/PriceBatchInputModal.tsx | 111 |
| FALLBACK_FIXED | PROJECT_CODE | Project Code* | 120 |  |  |  | meta-shape | features/master/src/pages/sales-future-price/components/modals/PriceBatchInputModal.tsx | 112 |
| FALLBACK_FIXED | ITEM_ID | Model* | 150 |  |  |  | meta-shape | features/master/src/pages/sales-future-price/components/modals/PriceBatchInputModal.tsx | 113 |
| FALLBACK_FIXED | INCOTERMS | Incoterms* | 80 |  |  |  | meta-shape | features/master/src/pages/sales-future-price/components/modals/PriceBatchInputModal.tsx | 114 |
| FALLBACK_FIXED | FCST_TYPE | FCST Type* | 100 |  |  |  | meta-shape | features/master/src/pages/sales-future-price/components/modals/PriceBatchInputModal.tsx | 115 |
| FALLBACK_FIXED | DOM_EXP | Customs Handbook | 110 |  |  |  | meta-shape | features/master/src/pages/sales-future-price/components/modals/PriceBatchInputModal.tsx | 116 |
| FALLBACK_FIXED | CURRENCY | Currency* | 80 |  |  |  | meta-shape | features/master/src/pages/sales-future-price/components/modals/PriceBatchInputModal.tsx | 117 |
| FALLBACK_FIXED | PLANT_SITE_ID | Plant Site* | 90 |  |  |  | meta-shape | features/master/src/pages/sales-future-price/components/modals/PriceBatchInputModal.tsx | 118 |
| FALLBACK_FIXED | MEASURE | Measure* | 80 |  |  |  | meta-shape | features/master/src/pages/sales-future-price/components/modals/PriceBatchInputModal.tsx | 119 |
| PRICE_ALL_COL | PRICE_ALL | Batch Price | 130 | true |  |  | meta-shape | features/master/src/pages/sales-future-price/components/modals/PriceBatchInputModal.tsx | 135 |
| base | c.colNm | c.colLblNm \|\| c.colNm | c.colWth ?? 90 | true |  |  | meta-map | features/master/src/pages/sales-future-price/components/modals/PriceBatchInputModal.tsx | 404 |
| dynamicColumns | b | mmdd | 80 | true |  |  | object | features/master/src/pages/sales-future-price/components/modals/PriceBatchInputModal.tsx | 591 |
| RANGE_COLUMNS | DIVISION_ID | Div. | 60 |  |  |  | meta-shape | features/master/src/pages/sales-future-price/components/modals/SalesPriceRangeModal.tsx | 73 |
| RANGE_COLUMNS | END_CUSTOMER | End Customer | 120 |  |  |  | meta-shape | features/master/src/pages/sales-future-price/components/modals/SalesPriceRangeModal.tsx | 74 |
| RANGE_COLUMNS | PROJECT_CODE | Project Code | 110 |  |  |  | meta-shape | features/master/src/pages/sales-future-price/components/modals/SalesPriceRangeModal.tsx | 75 |
| RANGE_COLUMNS | SCM_SITE_ID | Sales Site | 140 |  |  |  | meta-shape | features/master/src/pages/sales-future-price/components/modals/SalesPriceRangeModal.tsx | 76 |
| RANGE_COLUMNS | ITEM_ID | Model | 150 |  |  |  | meta-shape | features/master/src/pages/sales-future-price/components/modals/SalesPriceRangeModal.tsx | 77 |
| RANGE_COLUMNS | INCOTERMS | Incoterms | 80 |  |  |  | meta-shape | features/master/src/pages/sales-future-price/components/modals/SalesPriceRangeModal.tsx | 78 |
| RANGE_COLUMNS | FCST_TYPE | FCST Type | 90 |  |  |  | meta-shape | features/master/src/pages/sales-future-price/components/modals/SalesPriceRangeModal.tsx | 79 |
| RANGE_COLUMNS | DOM_EXP | Customs Handbook | 110 |  |  |  | meta-shape | features/master/src/pages/sales-future-price/components/modals/SalesPriceRangeModal.tsx | 80 |
| RANGE_COLUMNS | CURRENCY | Currency | 80 |  |  |  | meta-shape | features/master/src/pages/sales-future-price/components/modals/SalesPriceRangeModal.tsx | 81 |
| RANGE_COLUMNS | CH_YYYYMMDD | YYYYMMDD | 100 |  |  |  | meta-shape | features/master/src/pages/sales-future-price/components/modals/SalesPriceRangeModal.tsx | 82 |
| RANGE_COLUMNS | CH_PRICE | Price | 110 |  |  |  | meta-shape | features/master/src/pages/sales-future-price/components/modals/SalesPriceRangeModal.tsx | 83 |
| RANGE_COLUMNS | ST_YYYYMMDD | YYYYMMDD | 100 |  |  |  | meta-shape | features/master/src/pages/sales-future-price/components/modals/SalesPriceRangeModal.tsx | 84 |
| RANGE_COLUMNS | ST_PRICE | Price | 110 |  |  |  | meta-shape | features/master/src/pages/sales-future-price/components/modals/SalesPriceRangeModal.tsx | 85 |
| VERSION_COLUMNS | VERSION_NO | Version | 240 |  |  |  | meta-shape | features/master/src/pages/sales-future-price/components/modals/SalesPriceVersionModal.tsx | 71 |
| VERSION_COLUMNS | VERSION_DESCRIPTION | Details | 300 |  |  |  | meta-shape | features/master/src/pages/sales-future-price/components/modals/SalesPriceVersionModal.tsx | 72 |
| VERSION_COLUMNS | VERSION_TYPE | Type | 90 |  |  |  | meta-shape | features/master/src/pages/sales-future-price/components/modals/SalesPriceVersionModal.tsx | 73 |
| VERSION_COLUMNS | MONTHLY_ROLLING_FCST | Monthly Rolling Forecast | 170 |  |  |  | meta-shape | features/master/src/pages/sales-future-price/components/modals/SalesPriceVersionModal.tsx | 74 |
| VERSION_COLUMNS | CREATED_BY | Create By | 110 |  |  |  | meta-shape | features/master/src/pages/sales-future-price/components/modals/SalesPriceVersionModal.tsx | 75 |
| VERSION_COLUMNS | CREATION_DATE | Create Date | 150 |  |  |  | meta-shape | features/master/src/pages/sales-future-price/components/modals/SalesPriceVersionModal.tsx | 76 |
| mergedColumns | c.key | c.header | c.width ?? 100 | true |  |  | object | features/master/src/pages/sales-future-price/components/SalesFuturePriceGrid.tsx | 208 |
| mergedColumns | sc.colNm | sc.colLblNm \|\| fb?.header \|\| sc.colNm | sc.colWth ?? fb?.width ?? 100 | sc.visible !== false |  |  | object | features/master/src/pages/sales-future-price/components/SalesFuturePriceGrid.tsx | 225 |
| mainStaticColumns | c.binding | c.header | c.width | true |  |  | meta-map | features/master/src/pages/sales-future-price/components/SalesFuturePriceGrid.tsx | 357 |
| mainDynamicColumns | b | mmdd | 90 | true |  |  | object | features/master/src/pages/sales-future-price/components/SalesFuturePriceGrid.tsx | 429 |

## 7. 메시지 코드
| code | count |
|---|---|
| LBL00632 | 1 |
| MSG00108 | 5 |
| LBL00661 | 3 |
| LBL00664 | 3 |
| LBL00001 | 4 |
| LBL00013 | 1 |
| MSG00409 | 1 |
| MSG00330 | 1 |
| MSG00097 | 3 |
| MSG00004 | 2 |
| LBL00667 | 4 |
| MSG00618 | 8 |
| MSG00606 | 3 |
| LBL00662 | 4 |
| LBL00674 | 3 |
| LBL00617 | 1 |
| LBL00669 | 1 |
| LBL00111 | 2 |
| LBL00627 | 3 |
| MSG00113 | 5 |
| MSG00284 | 1 |
| MSG00255 | 2 |
| LBL00739 | 1 |
| LBL00608 | 1 |
| LBL00112 | 1 |
| LBL00044 | 1 |
| LBL00080 | 1 |
| LBL00085 | 1 |
| LBL00011 | 1 |
| LBL00005 | 1 |
| MSG00283 | 2 |
| MSG00429 | 1 |
| MSG00043 | 2 |
| MSG00448 | 2 |
| MSG00412 | 2 |
| MSG00227 | 2 |
| MSG00002 | 1 |
| MSG00001 | 1 |
| MSG00135 | 1 |
| MSG00137 | 2 |
| MSG00142 | 1 |
| MSG00143 | 1 |
| MSG00265 | 1 |
| MSG00408 | 1 |
| MSG00414 | 1 |
| MSG00447 | 1 |
| MSG01429 | 1 |
| MSG01430 | 1 |
| LBL00666 | 1 |
| LBL00605 | 2 |

## 8. 주석 속 As-is 참조
- 화면ID: DMF0020(8), DMF0042(6), DMF0082(3), SYS0004(3), COM0008(3), DMF0003(3), DMF0006(2), DMF0043_01(1), DMF0049(1), DMF0004(1), DMF0040(1), DMF0053(1)
- SP/PKG: P_DMF0020_GET_FUTUREPRICE_INFO(6), PKG_DMF0020(6), DMF0020_SAVE_SCM_MST_FUTURE_PRICE_ALL(5), DMF0020_GET_SCM_MST_FUTURE_PRICE(4), P_DMF0020_GET_SCM_MST_FUTURE_PRICE_M(4), PR_GET_SHEET_COLUMN_LIST(3), DMF0073_GET_VERSION_SALESPRICE(2), P_START_YYYYMMDD(2), P_END_YYYYMMDD(2), P_CREATED_BY(2), P_USER_ID(2), DMF0020_GET_SPREAD_TITLE_DATE(2), P_DMF0000_SAVE_EXCHANGE_POPUP_DATA(2), P_OVER_RANGE(2), P_DMF0020_GET_SPREAD_TITLE_DATE(2), P_DMF0020_GET_SCM_MST_FUTURE_PRICE_POPUP_DATA(1), P_DMF0020_GET_SCM_MST_FUTURE_PRICE_SAVE_PRICE_POPUP(1), DMF0020_SAVE_SCM_MST_FUTURE_PRICE_POPUP(1), P_DIVISION_ID(1), P_VERSION_TYPE(1), P_DESCRIPTION(1), P_MENU_ID(1), P_MNU_ID(1), PR_GET_SHEET_MEASURE_LIST(1), P_USERINFO(1), DMF0002_GET_TITLESET_POPUP(1), PR_GET_DAY_RANGE(1), DMF0020_GET_EXCHANGE_POPUP_SPREAD_TITLE(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| code | DMF0073_VersionBySalesPricePopup popVersion = new DMF0073_VersionBySalesPricePopup(); | features/master/src/pages/sales-future-price/components/modals/SalesPriceVersionModal.tsx | 23 |
| code | popVersion.Form_Load(true, "SP", sDivision, sStartDate, sEndDate); | features/master/src/pages/sales-future-price/components/modals/SalesPriceVersionModal.tsx | 24 |
| code | popVersion.ShowDialog(); | features/master/src/pages/sales-future-price/components/modals/SalesPriceVersionModal.tsx | 25 |
| code | AS-IS EditButton `if(!isCurVersion) return` 과 동일) + 편집가능(노란) 표시 안 함. 기본 true(호환). | features/master/src/pages/sales-future-price/components/SalesFuturePriceGrid.tsx | 61 |
| code | 과거 버전 조회 — 편집 진입 자체를 막는다(AS-IS EditButton `if(!isCurVersion) return`, 안내 없음). | features/master/src/pages/sales-future-price/components/SalesFuturePriceGrid.tsx | 632 |
| code | const object — enum 대체 (NSCM 단일 cursor 표준 'o_rc1' 다수 중복 허용) | features/master/src/pages/sales-future-price/sales-future-price.constants.ts | 22 |
| jsx | To-Be: react FlexGrid <Col binding=BASIS_START_DATE2 header=MMDD> + 3단 group header | features/master/src/pages/sales-future-price/sales-future-price.types.ts | 41 |
| endpoint | ⭐ master hook §2.3 — Column/Measure 동적 fetch (admin SYS0004 UI Category Setup 변경 즉시 반영) | features/master/src/pages/sales-future-price/SalesFuturePrice.tsx | 100 |
| endpoint | ⭐ master hook §2.3 + §5 — mount 시 1회 fetch (admin 메타 즉시 반영 baseline) | features/master/src/pages/sales-future-price/SalesFuturePrice.tsx | 257 |
| endpoint | ⭐ Batch 팝업 컬럼 선-fetch (open 깜박임 방지) | features/master/src/pages/sales-future-price/SalesFuturePrice.tsx | 263 |
| endpoint | ⭐ master hook §5 — Measure 동적 fetch (SCM_MST_SHEET_MEASURE 의 VALID_YN='Y' COLUMN_NAME 만) | features/master/src/pages/sales-future-price/SalesFuturePrice.tsx | 384 |
| code | ⭐ 저장된 컬럼 개인화(titleSet) 복원 — fetchStaticColumns 가 await 후 메타에 적용. | features/master/src/pages/sales-future-price/useSalesFuturePriceStore.ts | 79 |
| endpoint | ⭐ master hook §5 — Measure 동적 fetch (PIVOT 화면 의무) | features/master/src/pages/sales-future-price/useSalesFuturePriceStore.ts | 313 |
| code | siMain.SetBGColor2(iRow, iResultCol, iRow, iResultCol, Color.Pink); | features/master/src/pages/sales-future-price/utils/overRange.ts | 5 |

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

