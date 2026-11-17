# DMF0020_01 — To-Be Fact Pack 요약

- page_key: `demand/sales-future-price-01` · feature: demand · As-is Fact Pack 없음(화면ID 미대응)
- 파일 28 · 엔드포인트 호출 25 (미해결 0, 주석 속 5) · 이벤트 71 · 컴포넌트 사용 93 · 하드코딩 컬럼 39 · 메시지 102
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 사용 · 하드코딩 컬럼 정의 39건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/demand/src/pages/sales-future-price-01/components/modals/ExchangeRateModal.module.scss | component | 88 |
| features/demand/src/pages/sales-future-price-01/components/modals/ExchangeRateModal.tsx | component | 846 |
| features/demand/src/pages/sales-future-price-01/components/modals/exchangeRateModalStore.ts | store | 32 |
| features/demand/src/pages/sales-future-price-01/components/modals/PriceBatchInputModal.module.scss | component | 60 |
| features/demand/src/pages/sales-future-price-01/components/modals/PriceBatchInputModal.tsx | component | 1482 |
| features/demand/src/pages/sales-future-price-01/components/modals/priceBatchInputModalStore.ts | store | 33 |
| features/demand/src/pages/sales-future-price-01/components/modals/SalesPriceRangeModal.module.scss | component | 48 |
| features/demand/src/pages/sales-future-price-01/components/modals/SalesPriceRangeModal.tsx | component | 323 |
| features/demand/src/pages/sales-future-price-01/components/modals/SalesPriceVersionModal.module.scss | component | 40 |
| features/demand/src/pages/sales-future-price-01/components/modals/SalesPriceVersionModal.tsx | component | 323 |
| features/demand/src/pages/sales-future-price-01/components/modals/salesPriceVersionModalStore.ts | store | 48 |
| features/demand/src/pages/sales-future-price-01/components/SalesFuturePrice01Form.module.scss | component | 18 |
| features/demand/src/pages/sales-future-price-01/components/SalesFuturePrice01Form.tsx | component | 342 |
| features/demand/src/pages/sales-future-price-01/components/SalesFuturePrice01Grid.tsx | component | 1389 |
| features/demand/src/pages/sales-future-price-01/hooks/useSalesFuturePrice01Expression.ts | hook | 97 |
| features/demand/src/pages/sales-future-price-01/hooks/useSalesFuturePrice01Validation.ts | hook | 218 |
| features/demand/src/pages/sales-future-price-01/index.ts | index | 2 |
| features/demand/src/pages/sales-future-price-01/sales-future-price-01.constants.ts | constants | 459 |
| features/demand/src/pages/sales-future-price-01/sales-future-price-01.types.ts | types | 87 |
| features/demand/src/pages/sales-future-price-01/SalesFuturePrice01.module.scss | style | 148 |
| features/demand/src/pages/sales-future-price-01/SalesFuturePrice01.tsx | page | 1347 |
| features/demand/src/pages/sales-future-price-01/salesPriceExchange.ts | other | 107 |
| features/demand/src/pages/sales-future-price-01/useSalesFuturePrice01Store.ts | store | 475 |
| features/demand/src/pages/sales-future-price-01/utils/combo.util.ts | util | 91 |
| features/demand/src/pages/sales-future-price-01/utils/grid.util.ts | util | 124 |
| features/demand/src/pages/sales-future-price-01/utils/period.util.ts | util | 129 |
| features/demand/src/pages/sales-future-price-01/utils/salesPriceAutoMap.ts | util | 66 |
| features/demand/src/pages/sales-future-price-01/__asis-mapping__.md | mapping | 332 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueries) | hook | 8 | Y | ExchangeRateModal.tsx:126 PriceBatchInputModal.tsx:369 SalesPriceVersionModal.tsx:93 SalesFuturePrice01Form.tsx:69 SalesFuturePrice01Form.tsx:81 SalesFuturePrice01.tsx:154 |
| DMF0020_01/exchange//call-proc | hook | 3 | Y | ExchangeRateModal.tsx:170 PriceBatchInputModal.tsx:515 SalesFuturePrice01.tsx:246 |
| /DMF0020_01/exchange/SAVE/call-proc | http | 1 | Y | ExchangeRateModal.tsx:381 |
| DMF0020_01/priceBatch//call-proc | hook | 1 | Y | PriceBatchInputModal.tsx:494 |
| /DMF0020_01/main/SAVE/call-proc | http | 2 | Y | PriceBatchInputModal.tsx:869 SalesFuturePrice01.tsx:936 |
| /DMF0020_01/priceBatch/SAVE/call-proc | http | 1 | Y | SalesPriceRangeModal.tsx:203 |
| DMF0020_01/version//call-proc | hook | 1 | Y | SalesPriceVersionModal.tsx:141 |
| DMF0020_01/main//call-proc | hook | 1 | Y | SalesFuturePrice01.tsx:199 |
| /DMF0020_01/main/SPREAD_TITLE_DATE/call-proc | http | 1 | Y | SalesFuturePrice01.tsx:222 |
| /DMF0020_01/main/MDL_GR_PRICE/call-proc | http | 1 | Y | SalesFuturePrice01.tsx:370 |
| /admin/menu/DMF0020_01/column | http | 2 | Y | useSalesFuturePrice01Store.ts:266 useSalesFuturePrice01Store.ts:298 |
| /admin/menu/DMF0020_01/measure | http | 1 | Y | useSalesFuturePrice01Store.ts:327 |
| /admin/menu/DMF0020_01/search-conditions | http | 1 | Y | useSalesFuturePrice01Store.ts:360 |
| DMF0020_01/titleSet/SEARCH/call-proc | http | 1 | Y | useSalesFuturePrice01Store.ts:408 |

## 3. procedures.d.ts 등재 시트
(없음)

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| g | formatItem | formatHandler | addHandler | features/demand/src/pages/sales-future-price-01/components/modals/ExchangeRateModal.tsx | 515 |
| g | beginningEdit | beginningEditHandler | addHandler | features/demand/src/pages/sales-future-price-01/components/modals/ExchangeRateModal.tsx | 526 |
| g | pastingCell | pastingCellHandler | addHandler | features/demand/src/pages/sales-future-price-01/components/modals/ExchangeRateModal.tsx | 536 |
| g | cellEditEnded | cellEditEndedHandler | addHandler | features/demand/src/pages/sales-future-price-01/components/modals/ExchangeRateModal.tsx | 549 |
| g | pastedCell | cellEditEndedHandler | addHandler | features/demand/src/pages/sales-future-price-01/components/modals/ExchangeRateModal.tsx | 550 |
| g | updatedLayout | normalizeHeader | addHandler | features/demand/src/pages/sales-future-price-01/components/modals/ExchangeRateModal.tsx | 673 |
| SearchArea | onSearch | handleFind | jsx | features/demand/src/pages/sales-future-price-01/components/modals/ExchangeRateModal.tsx | 730 |
| CustomDropdown | onChange | <arrow> setDivisionId,String | jsx | features/demand/src/pages/sales-future-price-01/components/modals/ExchangeRateModal.tsx | 742 |
| DatePickerCalendar | onChange | <arrow> setPeriodFrom,date?.format | jsx | features/demand/src/pages/sales-future-price-01/components/modals/ExchangeRateModal.tsx | 761 |
| DatePickerCalendar | onChange | <arrow> setPeriodTo,date?.format | jsx | features/demand/src/pages/sales-future-price-01/components/modals/ExchangeRateModal.tsx | 775 |
| Button | onClick | <arrow> handleSave | jsx | features/demand/src/pages/sales-future-price-01/components/modals/ExchangeRateModal.tsx | 830 |
| Button | onClick | handleClose | jsx | features/demand/src/pages/sales-future-price-01/components/modals/ExchangeRateModal.tsx | 838 |
| g | formatItem | formatHandler | addHandler | features/demand/src/pages/sales-future-price-01/components/modals/PriceBatchInputModal.tsx | 981 |
| g | beginningEdit | beginningEditHandler | addHandler | features/demand/src/pages/sales-future-price-01/components/modals/PriceBatchInputModal.tsx | 999 |
| g | pastingCell | beginningEditHandler | addHandler | features/demand/src/pages/sales-future-price-01/components/modals/PriceBatchInputModal.tsx | 1000 |
| g | scrollPositionChanged | handleScrollInvalidate | addHandler | features/demand/src/pages/sales-future-price-01/components/modals/PriceBatchInputModal.tsx | 1004 |
| g | updatedLayout | reattachDataMaps | addHandler | features/demand/src/pages/sales-future-price-01/components/modals/PriceBatchInputModal.tsx | 1102 |
| g | updatedLayout | normalizeHeader | addHandler | features/demand/src/pages/sales-future-price-01/components/modals/PriceBatchInputModal.tsx | 1171 |
| SearchArea | onSearch | handleFind | jsx | features/demand/src/pages/sales-future-price-01/components/modals/PriceBatchInputModal.tsx | 1279 |
| CustomDropdown | onChange | <arrow> setDivisionId,String | jsx | features/demand/src/pages/sales-future-price-01/components/modals/PriceBatchInputModal.tsx | 1295 |
| SalesSiteField | onChange | setSalesSite | jsx | features/demand/src/pages/sales-future-price-01/components/modals/PriceBatchInputModal.tsx | 1308 |
| InputField | onChange | <arrow> setProjectCode | jsx | features/demand/src/pages/sales-future-price-01/components/modals/PriceBatchInputModal.tsx | 1323 |
| InputField | onDoubleClick | <arrow> setOpenProject | jsx | features/demand/src/pages/sales-future-price-01/components/modals/PriceBatchInputModal.tsx | 1324 |
| Button | onClick | <arrow> setOpenProject | jsx | features/demand/src/pages/sales-future-price-01/components/modals/PriceBatchInputModal.tsx | 1330 |
| InputField | onChange | <arrow> setItemId | jsx | features/demand/src/pages/sales-future-price-01/components/modals/PriceBatchInputModal.tsx | 1346 |
| InputField | onDoubleClick | <arrow> setOpenItem | jsx | features/demand/src/pages/sales-future-price-01/components/modals/PriceBatchInputModal.tsx | 1347 |
| Button | onClick | <arrow> setOpenItem | jsx | features/demand/src/pages/sales-future-price-01/components/modals/PriceBatchInputModal.tsx | 1353 |
| PeriodField | onChange | <arrow> setPeriodFrom,snapMonday,setPeriodTo | jsx | features/demand/src/pages/sales-future-price-01/components/modals/PriceBatchInputModal.tsx | 1365 |
| Button | onClick | handleExcel | jsx | features/demand/src/pages/sales-future-price-01/components/modals/PriceBatchInputModal.tsx | 1411 |
| Button | onClick | handleSave | jsx | features/demand/src/pages/sales-future-price-01/components/modals/PriceBatchInputModal.tsx | 1421 |
| Button | onClick | modalClose | jsx | features/demand/src/pages/sales-future-price-01/components/modals/PriceBatchInputModal.tsx | 1428 |
| g | formatItem | formatHandler | addHandler | features/demand/src/pages/sales-future-price-01/components/modals/SalesPriceRangeModal.tsx | 133 |
| Button | onClick | handleExcel | jsx | features/demand/src/pages/sales-future-price-01/components/modals/SalesPriceRangeModal.tsx | 296 |
| Button | onClick | handleSave | jsx | features/demand/src/pages/sales-future-price-01/components/modals/SalesPriceRangeModal.tsx | 307 |
| Button | onClick | modalClose | jsx | features/demand/src/pages/sales-future-price-01/components/modals/SalesPriceRangeModal.tsx | 315 |
| g.hostElement? | dblclick | onDbl | addEventListener | features/demand/src/pages/sales-future-price-01/components/modals/SalesPriceVersionModal.tsx | 198 |
| SearchArea | onSearch | handleFind | jsx | features/demand/src/pages/sales-future-price-01/components/modals/SalesPriceVersionModal.tsx | 230 |
| CustomDropdown | onChange | <arrow> setSearchParams,String | jsx | features/demand/src/pages/sales-future-price-01/components/modals/SalesPriceVersionModal.tsx | 243 |
| PeriodField | onChange | <arrow> setSearchParams | jsx | features/demand/src/pages/sales-future-price-01/components/modals/SalesPriceVersionModal.tsx | 252 |
| InputField | onChange | <arrow> setSearchParams | jsx | features/demand/src/pages/sales-future-price-01/components/modals/SalesPriceVersionModal.tsx | 263 |
| Button | onClick | handleApply | jsx | features/demand/src/pages/sales-future-price-01/components/modals/SalesPriceVersionModal.tsx | 308 |
| Button | onClick | modalClose | jsx | features/demand/src/pages/sales-future-price-01/components/modals/SalesPriceVersionModal.tsx | 315 |
| CustomDropdown | onChange | <arrow> onPick,String(picked??'').split(',').filter,String(picked??'').split,String | jsx | features/demand/src/pages/sales-future-price-01/components/SalesFuturePrice01Form.tsx | 169 |
| SearchArea | onSearch | onSearch | jsx | features/demand/src/pages/sales-future-price-01/components/SalesFuturePrice01Form.tsx | 186 |
| CustomDropdown | onChange | <arrow> confirmIfDirtyKey(tabDirtyKey(tabId),'search').then,confirmIfDirtyKey,tabDirtyKey,set,String | jsx | features/demand/src/pages/sales-future-price-01/components/SalesFuturePrice01Form.tsx | 200 |
| ProjectField | onChange | <arrow> set | jsx | features/demand/src/pages/sales-future-price-01/components/SalesFuturePrice01Form.tsx | 253 |
| PeriodField | onChange | <arrow> set | jsx | features/demand/src/pages/sales-future-price-01/components/SalesFuturePrice01Form.tsx | 266 |
| ItemField | onChange | <arrow> set | jsx | features/demand/src/pages/sales-future-price-01/components/SalesFuturePrice01Form.tsx | 285 |
| OwnerField | onChange | <arrow> set | jsx | features/demand/src/pages/sales-future-price-01/components/SalesFuturePrice01Form.tsx | 297 |
| BucketField | onChange | <arrow> validate.validateBucketChange,set | jsx | features/demand/src/pages/sales-future-price-01/components/SalesFuturePrice01Form.tsx | 309 |
| VersionField | onOpenPopup | onVersionOpen | jsx | features/demand/src/pages/sales-future-price-01/components/SalesFuturePrice01Form.tsx | 315 |
| SearchOverRangeField | onChange | <arrow> thisWeekMonday,end.setDate,start.getDate,set,yyyymmddOf | jsx | features/demand/src/pages/sales-future-price-01/components/SalesFuturePrice01Form.tsx | 321 |
| g | formatItem | formatHandler | addHandler | features/demand/src/pages/sales-future-price-01/components/SalesFuturePrice01Grid.tsx | 658 |
| g | beginningEdit | beginningEditHandler | addHandler | features/demand/src/pages/sales-future-price-01/components/SalesFuturePrice01Grid.tsx | 823 |
| g | pastingCell | pastingCellHandler | addHandler | features/demand/src/pages/sales-future-price-01/components/SalesFuturePrice01Grid.tsx | 863 |
| g | cellEditEnded | cellEditEndedHandler | addHandler | features/demand/src/pages/sales-future-price-01/components/SalesFuturePrice01Grid.tsx | 1030 |
| g | pastedCell | cellEditEndedHandler | addHandler | features/demand/src/pages/sales-future-price-01/components/SalesFuturePrice01Grid.tsx | 1031 |
| g.hostElement | click | clickAsDblHandler | addEventListener | features/demand/src/pages/sales-future-price-01/components/SalesFuturePrice01Grid.tsx | 1077 |
| g | scrollPositionChanged | handleScrollInvalidate | addHandler | features/demand/src/pages/sales-future-price-01/components/SalesFuturePrice01Grid.tsx | 1083 |
| g | updatedLayout | applyHeaderHeight | addHandler | features/demand/src/pages/sales-future-price-01/components/SalesFuturePrice01Grid.tsx | 1295 |
| f | filterApplied | onFilterApplied | addHandler | features/demand/src/pages/sales-future-price-01/components/SalesFuturePrice01Grid.tsx | 1321 |
| SalesFuturePrice01Form | onSearch | handleSearch | jsx | features/demand/src/pages/sales-future-price-01/SalesFuturePrice01.tsx | 1049 |
| SalesFuturePrice01Form | onVersionOpen | <arrow> setOpenVersion | jsx | features/demand/src/pages/sales-future-price-01/SalesFuturePrice01.tsx | 1050 |
| SalesFuturePrice01Grid | onPopupCellDblClick | handlePopupCellDblClick | jsx | features/demand/src/pages/sales-future-price-01/SalesFuturePrice01.tsx | 1114 |
| SalesFuturePrice01Grid | onInsertKeyEdited | handleInsertKeyEdited | jsx | features/demand/src/pages/sales-future-price-01/SalesFuturePrice01.tsx | 1115 |
| ExchangeRateModal | onSavedClose | <arrow> refetchExchange,refetch | jsx | features/demand/src/pages/sales-future-price-01/SalesFuturePrice01.tsx | 1129 |
| PriceBatchInputModal | onSaveResult | <arrow> refetch | jsx | features/demand/src/pages/sales-future-price-01/SalesFuturePrice01.tsx | 1147 |
| PriceBatchInputModal | onRangeOver | <arrow> setRangeRows,setOpenRange | jsx | features/demand/src/pages/sales-future-price-01/SalesFuturePrice01.tsx | 1149 |
| SalesPriceVersionModal | onApply | <arrow> setSearchCondition,normalizeVersionIds | jsx | features/demand/src/pages/sales-future-price-01/SalesFuturePrice01.tsx | 1159 |
| SalesPriceRangeModal | onSaved | <arrow> refetch | jsx | features/demand/src/pages/sales-future-price-01/SalesFuturePrice01.tsx | 1167 |
| ColumnLayoutModal | onSave | <arrow> clearGridOnSettingChange,applyColumnLayout,settings.map,settings.filter,saveTitleSet({menuId:MENU_ID,//⚠️팝업이조회에쓰는값과동일해야한다—상수한곳에서만가져온다.sheetName:TITLESET_SHEET,columnType:TITLESET_COLUMN_TYPE,rows:visible.map((s,i)=>({name:s.COLUMN_NAME,sortOrderNo:i+1,colWidth:s.COL_WIDTH,cellColor:s.CELL_COLOR,textColor:s.TEXT_COLOR,})),}).then,saveTitleSet | jsx | features/demand/src/pages/sales-future-price-01/SalesFuturePrice01.tsx | 1186 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Button | 12 |
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
| SalesFuturePrice01Form | 1 |
| SubTitle | 1 |
| IcExchangeRate | 1 |
| IcGridColumnSetup | 1 |
| SalesFuturePrice01Grid | 1 |
| ExchangeRateModal | 1 |
| PriceBatchInputModal | 1 |
| SalesPriceVersionModal | 1 |
| SalesPriceRangeModal | 1 |
| ColumnLayoutModal | 1 |

## 6. 하드코딩 Grid 컬럼
| context | binding | header | width | visible | isReadOnly | dataType | via | file | line |
|---|---|---|---|---|---|---|---|---|---|
| gridStaticColumns | c.key | c.header | c.width | true |  |  | meta-map | features/demand/src/pages/sales-future-price-01/components/modals/ExchangeRateModal.tsx | 429 |
| gridDynamicColumns | `M_${ym}` | ym.slice(4, 6) | 90 | true | !isEditMode |  | object | features/demand/src/pages/sales-future-price-01/components/modals/ExchangeRateModal.tsx | 450 |
| FALLBACK_FIXED | DIVISION_ID | Div* | 50 |  |  |  | meta-shape | features/demand/src/pages/sales-future-price-01/components/modals/PriceBatchInputModal.tsx | 109 |
| FALLBACK_FIXED | DEPT_ID | Team | 100 |  |  |  | meta-shape | features/demand/src/pages/sales-future-price-01/components/modals/PriceBatchInputModal.tsx | 110 |
| FALLBACK_FIXED | SCM_SITE_ID | Sales Site* | 140 |  |  |  | meta-shape | features/demand/src/pages/sales-future-price-01/components/modals/PriceBatchInputModal.tsx | 111 |
| FALLBACK_FIXED | PROJECT_CODE | Project Code* | 120 |  |  |  | meta-shape | features/demand/src/pages/sales-future-price-01/components/modals/PriceBatchInputModal.tsx | 112 |
| FALLBACK_FIXED | ITEM_ID | Model* | 150 |  |  |  | meta-shape | features/demand/src/pages/sales-future-price-01/components/modals/PriceBatchInputModal.tsx | 113 |
| FALLBACK_FIXED | INCOTERMS | Incoterms* | 80 |  |  |  | meta-shape | features/demand/src/pages/sales-future-price-01/components/modals/PriceBatchInputModal.tsx | 114 |
| FALLBACK_FIXED | FCST_TYPE | FCST Type* | 100 |  |  |  | meta-shape | features/demand/src/pages/sales-future-price-01/components/modals/PriceBatchInputModal.tsx | 115 |
| FALLBACK_FIXED | DOM_EXP | Customs Handbook | 110 |  |  |  | meta-shape | features/demand/src/pages/sales-future-price-01/components/modals/PriceBatchInputModal.tsx | 116 |
| FALLBACK_FIXED | CURRENCY | Currency* | 80 |  |  |  | meta-shape | features/demand/src/pages/sales-future-price-01/components/modals/PriceBatchInputModal.tsx | 117 |
| FALLBACK_FIXED | PLANT_SITE_ID | Plant Site* | 90 |  |  |  | meta-shape | features/demand/src/pages/sales-future-price-01/components/modals/PriceBatchInputModal.tsx | 118 |
| FALLBACK_FIXED | MEASURE | Measure* | 80 |  |  |  | meta-shape | features/demand/src/pages/sales-future-price-01/components/modals/PriceBatchInputModal.tsx | 119 |
| PRICE_ALL_COL | PRICE_ALL | Batch Price | 130 | true |  |  | meta-shape | features/demand/src/pages/sales-future-price-01/components/modals/PriceBatchInputModal.tsx | 135 |
| base | c.colNm | c.colLblNm \|\| c.colNm | c.colWth ?? 90 | true |  |  | meta-map | features/demand/src/pages/sales-future-price-01/components/modals/PriceBatchInputModal.tsx | 429 |
| dynamicColumns | b | mmdd | 80 | true |  |  | object | features/demand/src/pages/sales-future-price-01/components/modals/PriceBatchInputModal.tsx | 620 |
| RANGE_COLUMNS | DIVISION_ID | Div. | 60 |  |  |  | meta-shape | features/demand/src/pages/sales-future-price-01/components/modals/SalesPriceRangeModal.tsx | 74 |
| RANGE_COLUMNS | END_CUSTOMER | End Customer | 120 |  |  |  | meta-shape | features/demand/src/pages/sales-future-price-01/components/modals/SalesPriceRangeModal.tsx | 75 |
| RANGE_COLUMNS | PROJECT_CODE | Project Code | 110 |  |  |  | meta-shape | features/demand/src/pages/sales-future-price-01/components/modals/SalesPriceRangeModal.tsx | 76 |
| RANGE_COLUMNS | SCM_SITE_ID | Sales Site | 140 |  |  |  | meta-shape | features/demand/src/pages/sales-future-price-01/components/modals/SalesPriceRangeModal.tsx | 77 |
| RANGE_COLUMNS | ITEM_ID | Model | 150 |  |  |  | meta-shape | features/demand/src/pages/sales-future-price-01/components/modals/SalesPriceRangeModal.tsx | 78 |
| RANGE_COLUMNS | INCOTERMS | Incoterms | 80 |  |  |  | meta-shape | features/demand/src/pages/sales-future-price-01/components/modals/SalesPriceRangeModal.tsx | 79 |
| RANGE_COLUMNS | FCST_TYPE | FCST Type | 90 |  |  |  | meta-shape | features/demand/src/pages/sales-future-price-01/components/modals/SalesPriceRangeModal.tsx | 80 |
| RANGE_COLUMNS | DOM_EXP | Customs Handbook | 110 |  |  |  | meta-shape | features/demand/src/pages/sales-future-price-01/components/modals/SalesPriceRangeModal.tsx | 81 |
| RANGE_COLUMNS | CURRENCY | Currency | 80 |  |  |  | meta-shape | features/demand/src/pages/sales-future-price-01/components/modals/SalesPriceRangeModal.tsx | 82 |
| RANGE_COLUMNS | CH_YYYYMMDD | YYYYMMDD | 100 |  |  |  | meta-shape | features/demand/src/pages/sales-future-price-01/components/modals/SalesPriceRangeModal.tsx | 83 |
| RANGE_COLUMNS | CH_PRICE | Price | 110 |  |  |  | meta-shape | features/demand/src/pages/sales-future-price-01/components/modals/SalesPriceRangeModal.tsx | 84 |
| RANGE_COLUMNS | ST_YYYYMMDD | YYYYMMDD | 100 |  |  |  | meta-shape | features/demand/src/pages/sales-future-price-01/components/modals/SalesPriceRangeModal.tsx | 85 |
| RANGE_COLUMNS | ST_PRICE | Price | 110 |  |  |  | meta-shape | features/demand/src/pages/sales-future-price-01/components/modals/SalesPriceRangeModal.tsx | 86 |
| VERSION_COLUMNS | VERSION_NO | Version | 240 |  |  |  | meta-shape | features/demand/src/pages/sales-future-price-01/components/modals/SalesPriceVersionModal.tsx | 71 |
| VERSION_COLUMNS | VERSION_DESCRIPTION | Details | 300 |  |  |  | meta-shape | features/demand/src/pages/sales-future-price-01/components/modals/SalesPriceVersionModal.tsx | 72 |
| VERSION_COLUMNS | VERSION_TYPE | Type | 90 |  |  |  | meta-shape | features/demand/src/pages/sales-future-price-01/components/modals/SalesPriceVersionModal.tsx | 73 |
| VERSION_COLUMNS | MONTHLY_ROLLING_FCST | Monthly Rolling Forecast | 170 |  |  |  | meta-shape | features/demand/src/pages/sales-future-price-01/components/modals/SalesPriceVersionModal.tsx | 74 |
| VERSION_COLUMNS | CREATED_BY | Create By | 110 |  |  |  | meta-shape | features/demand/src/pages/sales-future-price-01/components/modals/SalesPriceVersionModal.tsx | 75 |
| VERSION_COLUMNS | CREATION_DATE | Create Date | 150 |  |  |  | meta-shape | features/demand/src/pages/sales-future-price-01/components/modals/SalesPriceVersionModal.tsx | 76 |
| mergedColumns | c.key | c.header | c.width ?? 100 | true |  |  | object | features/demand/src/pages/sales-future-price-01/components/SalesFuturePrice01Grid.tsx | 249 |
| mergedColumns | sc.colNm | label | sc.colWth ?? fb?.width ?? 100 | sc.visible !== false |  |  | object | features/demand/src/pages/sales-future-price-01/components/SalesFuturePrice01Grid.tsx | 267 |
| mainStaticColumns | c.binding | c.header | c.width | true |  |  | meta-map | features/demand/src/pages/sales-future-price-01/components/SalesFuturePrice01Grid.tsx | 404 |
| mainDynamicColumns | b | mmdd | 90 | true |  |  | object | features/demand/src/pages/sales-future-price-01/components/SalesFuturePrice01Grid.tsx | 476 |

## 7. 메시지 코드
| code | count |
|---|---|
| LBL00632 | 1 |
| MSG00618 | 10 |
| MSG00606 | 4 |
| LBL00310 | 1 |
| MSG00108 | 5 |
| LBL00661 | 3 |
| LBL00664 | 3 |
| LBL00001 | 4 |
| LBL00013 | 1 |
| LBL00111 | 3 |
| MSG00409 | 1 |
| MSG00330 | 1 |
| MSG00097 | 3 |
| MSG00004 | 2 |
| LBL00667 | 4 |
| LBL01274 | 4 |
| LBL00674 | 3 |
| LBL00617 | 1 |
| LBL00669 | 1 |
| LBL00627 | 3 |
| MSG00014 | 1 |
| MSG00284 | 1 |
| MSG00283 | 4 |
| MSG00255 | 2 |
| LBL00739 | 1 |
| LBL00608 | 1 |
| LBL00112 | 1 |
| LBL00044 | 1 |
| LBL00080 | 1 |
| LBL00085 | 1 |
| LBL00011 | 1 |
| LBL00005 | 1 |
| MSG00429 | 1 |
| MSG00043 | 2 |
| MSG00113 | 2 |
| MSG00448 | 2 |
| MSG00412 | 2 |
| MSG00227 | 2 |
| MSG00013 | 1 |
| MSG00001 | 1 |
| MSG00135 | 1 |
| MSG00137 | 2 |
| MSG00142 | 1 |
| MSG01161 | 1 |
| MSG00265 | 1 |
| MSG00408 | 1 |
| MSG00414 | 1 |
| MSG00447 | 1 |
| MSG01429 | 1 |
| MSG01091 | 1 |
| MSG01430 | 1 |
| LBL00666 | 1 |
| LBL00605 | 2 |

## 8. 주석 속 As-is 참조
- 화면ID: DMF0020_01(25), DMF0020(9), DMF0042(4), COM0008(4), DMF0082(3), DMF0083(3), SYS0004(3), DMF0003(3), DMF0049(2), DMF0006(2), DMF0043_01(1), DMF0004(1), DMF0040(1), DMF0053(1), DMF0005(1)
- SP/PKG: PKG_DMF0020_01(8), P_DMF0020_GET_FUTUREPRICE_INFO(6), PKG_DMF0020(6), DMF0020_GET_SCM_MST_FUTURE_PRICE(5), DMF0020_SAVE_SCM_MST_FUTURE_PRICE_ALL(5), P_DMF0020_GET_SCM_MST_FUTURE_PRICE_M(4), PR_GET_SHEET_COLUMN_LIST(3), P_USER_ID(3), P_DMF0020_01_GET_MDL_GR_PRICE(3), DMF0073_GET_VERSION_SALESPRICE(2), P_START_YYYYMMDD(2), P_END_YYYYMMDD(2), P_CREATED_BY(2), DMF0020_GET_SPREAD_TITLE_DATE(2), P_DMF0000_SAVE_EXCHANGE_POPUP_DATA(2), P_OVER_RANGE(2), P_DMF0020_GET_SPREAD_TITLE_DATE(2), PR_GET_SHEET_MEASURE_LIST(2), P_DMF0020_01_GET_FUTUREPRICE_INFO(1), P_DMF0020_01_SAVE_DM_MST_EXCHANGE_RATE_ALL(1), P_DMF0020_GET_SCM_MST_FUTURE_PRICE_POPUP_DATA(1), P_DMF0020_01_GET_SCM_MST_FUTURE_PRICE_SAVE_PRICE_POPUP(1), P_DMF0020_GET_SCM_MST_FUTURE_PRICE_SAVE_PRICE_POPUP(1), DMF0020_SAVE_SCM_MST_FUTURE_PRICE_POPUP(1), P_DIVISION_ID(1), P_VERSION_TYPE(1), P_DESCRIPTION(1), P_MENU_ID(1), P_DMF0020_01_GET_SCM_MST_FUTURE_PRICE(1), P_MNU_ID(1), P_USERINFO(1), DMF0002_GET_TITLESET_POPUP(1), PR_GET_DAY_RANGE(1), DMF0020_GET_EXCHANGE_POPUP_SPREAD_TITLE(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| code | DMF0073_VersionBySalesPricePopup popVersion = new DMF0073_VersionBySalesPricePopup(); | features/demand/src/pages/sales-future-price-01/components/modals/SalesPriceVersionModal.tsx | 23 |
| code | popVersion.Form_Load(true, "SP", sDivision, sStartDate, sEndDate); | features/demand/src/pages/sales-future-price-01/components/modals/SalesPriceVersionModal.tsx | 24 |
| code | popVersion.ShowDialog(); | features/demand/src/pages/sales-future-price-01/components/modals/SalesPriceVersionModal.tsx | 25 |
| code | AS-IS EditButton `if(!isCurVersion) return` 과 동일) + 편집가능(노란) 표시 안 함. 기본 true(호환). | features/demand/src/pages/sales-future-price-01/components/SalesFuturePrice01Grid.tsx | 65 |
| code | 과거 버전 조회 — 편집 진입 자체를 막는다(AS-IS EditButton `if(!isCurVersion) return`, 안내 없음). | features/demand/src/pages/sales-future-price-01/components/SalesFuturePrice01Grid.tsx | 719 |
| code | const object — enum 대체 (NSCM 단일 cursor 표준 'o_rc1' 다수 중복 허용) | features/demand/src/pages/sales-future-price-01/sales-future-price-01.constants.ts | 40 |
| jsx | To-Be: react FlexGrid <Col binding=BASIS_START_DATE2 header=MMDD> + 3단 group header | features/demand/src/pages/sales-future-price-01/sales-future-price-01.types.ts | 46 |
| endpoint | ⭐ master hook §2.3 — Column/Measure 동적 fetch (admin SYS0004 UI Category Setup 변경 즉시 반영) | features/demand/src/pages/sales-future-price-01/SalesFuturePrice01.tsx | 106 |
| endpoint | ⭐ master hook §2.3 + §5 — mount 시 1회 fetch (admin 메타 즉시 반영 baseline) | features/demand/src/pages/sales-future-price-01/SalesFuturePrice01.tsx | 263 |
| endpoint | ⭐ Batch 팝업 컬럼 선-fetch (open 깜박임 방지) | features/demand/src/pages/sales-future-price-01/SalesFuturePrice01.tsx | 269 |
| endpoint | ⭐ master hook §5 — Measure 동적 fetch (SCM_MST_SHEET_MEASURE 의 VALID_YN='Y' COLUMN_NAME 만) | features/demand/src/pages/sales-future-price-01/SalesFuturePrice01.tsx | 533 |
| code | ⭐ 저장된 컬럼 개인화(titleSet) 복원 — fetchStaticColumns 가 await 후 메타에 적용. | features/demand/src/pages/sales-future-price-01/useSalesFuturePrice01Store.ts | 80 |
| endpoint | ⭐ master hook §5 — Measure 동적 fetch (PIVOT 화면 의무) | features/demand/src/pages/sales-future-price-01/useSalesFuturePrice01Store.ts | 314 |
| code | siMain.SetBGColor2(iRow, iResultCol, iRow, iResultCol, Color.Pink); | features/demand/src/pages/sales-future-price-01/utils/grid.util.ts | 41 |

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

