# DMF0082 — To-Be Fact Pack 요약

- page_key: `demand/forecast-price` · feature: demand · As-is Fact Pack 없음(화면ID 미대응)
- 파일 43 · 엔드포인트 호출 37 (미해결 6, 주석 속 1) · 이벤트 77 · 컴포넌트 사용 116 · 하드코딩 컬럼 35 · 메시지 85
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 사용 · 하드코딩 컬럼 정의 35건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/demand/src/pages/forecast-price/components/ForecastPriceForm.module.scss | component | 17 |
| features/demand/src/pages/forecast-price/components/ForecastPriceForm.tsx | component | 441 |
| features/demand/src/pages/forecast-price/components/ForecastPriceGrid.tsx | component | 2080 |
| features/demand/src/pages/forecast-price/components/ForecastPriceGridUtils.test.ts | test | 217 |
| features/demand/src/pages/forecast-price/components/ForecastPriceGridUtils.ts | component | 597 |
| features/demand/src/pages/forecast-price/components/modals/ExchangeRateModal.module.scss | component | 41 |
| features/demand/src/pages/forecast-price/components/modals/ExchangeRateModal.tsx | component | 896 |
| features/demand/src/pages/forecast-price/components/modals/exchangeRateModalStore.ts | store | 32 |
| features/demand/src/pages/forecast-price/components/modals/ForecastTemplateModal.module.scss | component | 38 |
| features/demand/src/pages/forecast-price/components/modals/ForecastTemplateModal.tsx | component | 279 |
| features/demand/src/pages/forecast-price/components/modals/index.ts | index | 8 |
| features/demand/src/pages/forecast-price/components/modals/SavePricePeriodModal.module.scss | component | 124 |
| features/demand/src/pages/forecast-price/components/modals/SavePricePeriodModal.tsx | component | 1231 |
| features/demand/src/pages/forecast-price/components/modals/savePricePeriodModalStore.ts | store | 60 |
| features/demand/src/pages/forecast-price/components/modals/VersionSelectModal.module.scss | component | 45 |
| features/demand/src/pages/forecast-price/components/modals/VersionSelectModal.tsx | component | 350 |
| features/demand/src/pages/forecast-price/components/modals/versionSelectModalStore.ts | store | 43 |
| features/demand/src/pages/forecast-price/forecast-price.constants.ts | constants | 321 |
| features/demand/src/pages/forecast-price/forecast-price.types.ts | types | 99 |
| features/demand/src/pages/forecast-price/ForecastPrice.tsx | page | 1174 |
| features/demand/src/pages/forecast-price/index.ts | index | 2 |
| features/demand/src/pages/forecast-price/useForecastPriceStore.test.tsx | test | 171 |
| features/demand/src/pages/forecast-price/useForecastPriceStore.ts | store | 657 |
| features/demand/src/pages/forecast-price/utils/forecast-price.api.ts | api | 161 |
| features/demand/src/pages/forecast-price/utils/forecast-price.asFromSite.test.ts | test | 85 |
| features/demand/src/pages/forecast-price/utils/forecast-price.asFromSite.ts | util | 45 |
| features/demand/src/pages/forecast-price/utils/forecast-price.cellProdSites.ts | util | 56 |
| features/demand/src/pages/forecast-price/utils/forecast-price.combo.ts | util | 14 |
| features/demand/src/pages/forecast-price/utils/forecast-price.editLock.test.ts | test | 130 |
| features/demand/src/pages/forecast-price/utils/forecast-price.editLock.ts | util | 78 |
| features/demand/src/pages/forecast-price/utils/forecast-price.excelForm.test.ts | test | 142 |
| features/demand/src/pages/forecast-price/utils/forecast-price.excelForm.ts | util | 190 |
| features/demand/src/pages/forecast-price/utils/forecast-price.groupMeasure.test.ts | test | 125 |
| features/demand/src/pages/forecast-price/utils/forecast-price.groupMeasure.ts | util | 110 |
| features/demand/src/pages/forecast-price/utils/forecast-price.measureEdit.test.ts | test | 117 |
| features/demand/src/pages/forecast-price/utils/forecast-price.save.test.ts | test | 150 |
| features/demand/src/pages/forecast-price/utils/forecast-price.save.ts | util | 232 |
| features/demand/src/pages/forecast-price/utils/forecast-price.searchCombos.ts | util | 107 |
| features/demand/src/pages/forecast-price/utils/forecast-price.validate.test.ts | test | 235 |
| features/demand/src/pages/forecast-price/utils/forecast-price.validate.ts | util | 154 |
| features/demand/src/pages/forecast-price/utils/forecast-price.wsAuth.test.ts | test | 120 |
| features/demand/src/pages/forecast-price/utils/forecast-price.wsAuth.ts | util | 347 |
| features/demand/src/pages/forecast-price/__asis-mapping__.md | mapping | 529 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueries) | hook | 11 | Y | ForecastPriceForm.tsx:76 ForecastPriceForm.tsx:121 ForecastPriceGrid.tsx:286 ForecastPriceGrid.tsx:316 ForecastPriceGrid.tsx:345 ExchangeRateModal.tsx:147 |
| {?{comboId:'CELL_PROD_SITE_ID',divisionId:q(divisionId),itemId:q(itemId),}} | http | 1 | N | ForecastPriceGrid.tsx:432 |
| {?{comboId:'SalesBucket',divisionId:q(div),scmSiteId:q(site),incoterms:q(inco),}} | http | 1 | N | ForecastPriceGrid.tsx:573 |
| {?{comboId:'FcstPriceEditMeasure',divisionId:q(div),scmSiteId:`'${site.trim()!==''} | http | 1 | N | ForecastPriceGrid.tsx:605 |
| {?{comboId:'SiteByEndCustomer',divisionId:q(div),endCustomer:q(cust)}} | http | 1 | N | ForecastPriceGrid.tsx:643 |
| {?{comboId:'CELL_PROD_SITE_ID',divisionId:q(div),itemId:q(item)}} | http | 1 | N | ForecastPriceGrid.tsx:777 |
| DMF0082/futurePriceInfo//call-proc | hook | 1 | Y | ExchangeRateModal.tsx:184 |
| /DMF0082/futurePriceInfo/IF/call-proc | http | 1 | Y | ExchangeRateModal.tsx:205 |
| /DMF0082/futurePriceInfo/SAVE/call-proc | http | 1 | Y | ExchangeRateModal.tsx:719 |
| DMF0082/savePriceData//call-proc | hook | 1 | Y | SavePricePeriodModal.tsx:391 |
| DMF0082/savePriceTitle//call-proc | hook | 1 | Y | SavePricePeriodModal.tsx:415 |
| /DMF0082/FcstNPrice/SAVE/call-proc | http | 2 | Y | SavePricePeriodModal.tsx:650 ForecastPrice.tsx:743 |
| DMF0082/version//call-proc | hook | 1 | Y | VersionSelectModal.tsx:162 |
| {?{comboId:'SiteEndCustomerMapDMF0082',divisionId:q(div)}} | http | 1 | N | ForecastPrice.tsx:178 |
| DMF0082/FcstNPrice//call-proc | hook | 1 | Y | ForecastPrice.tsx:208 |
| DMF0082/spreadTitle//call-proc | hook | 1 | Y | ForecastPrice.tsx:216 |
| DMF0082/buttonAuth//call-proc | hook | 1 | Y | ForecastPrice.tsx:256 |
| /admin/menu/DMF0082/search-conditions | http | 1 | Y | useForecastPriceStore.ts:308 |
| /admin/menu/DMF0082/column | http | 3 | Y | useForecastPriceStore.ts:418 useForecastPriceStore.ts:553 useForecastPriceStore.ts:573 |
| DMF0082/titleSet/SEARCH/call-proc | http | 1 | Y | useForecastPriceStore.ts:460 |
| /admin/menu/DMF0082/measure | http | 1 | Y | useForecastPriceStore.ts:535 |
| /DMF0082/titleSet/SAVE/call-proc | http | 1 | Y | forecast-price.api.ts:38 |
| /DMF0082/FcstNPrice/FORM_DATA/call-proc | http | 1 | Y | forecast-price.api.ts:80 |
| /DMF0082/FcstNPrice/UPLOAD_SAVE/call-proc | http | 1 | Y | forecast-price.api.ts:132 |

## 3. procedures.d.ts 등재 시트
| sheet | request_keys | response_cursors | sp_hints |
|---|---|---|---|
| version | startYyyymmdd endYyyymmdd createdBy divisionId versionType description | o_rc1 | DMF0073_GET_VERSION_SALESPRICE PKG_DMF0082 P_DMF0082_GET_MAIN_DATA DMF0082_GET_SPREAD_TITLE |
| futurePriceInfo | startYyyymmdd endYyyymmdd | o_rc1 | PKG_DMF0082 P_DMF0082_GET_MAIN_DATA DMF0082_GET_SPREAD_TITLE |
| savePriceData | divisionId deptId endCustomer scmSiteId plantSiteId projectCode itemId customerProjectCode customerModel fromYyyymmdd toYyyymmdd biztype sesUserId userGroup owner overRange invalidExec | data | PKG_DMF0082 P_DMF0082_GET_MAIN_DATA DMF0082_GET_SPREAD_TITLE |
| savePriceTitle | startYyyymmdd endYyyymmdd sesUserId divisionId | data | PKG_DMF0082 P_DMF0082_GET_MAIN_DATA DMF0082_GET_SPREAD_TITLE |
| FcstNPrice | divisionId deptId endCustomer bizType fromYyyymmdd toYyyymmdd salesSite plantSiteId itemId versionType qtyYn sesUserId userGroup projectCode owner senderCode | fcstNPrice drop1 drop2 drop3 drop4 | PKG_DMF0082 P_DMF0082_GET_MAIN_DATA DMF0082_GET_SPREAD_TITLE |
| spreadTitle | startYyyymmdd endYyyymmdd sesUserId divisionId | o_rc | PKG_DMF0082 P_DMF0082_GET_MAIN_DATA DMF0082_GET_SPREAD_TITLE |
| buttonAuth | divisionId sesUserId userGroup | buttonAuth measureAuth | PKG_DMF0082 P_DMF0082_GET_BUTTON_AUTH P_DMF0082_GET_MAIN_DATA DMF0082_GET_SPREAD_TITLE |

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| CustomDropdown | onChange | <arrow> onPick,String(picked??'').split(',').filter,String(picked??'').split,String | jsx | features/demand/src/pages/forecast-price/components/ForecastPriceForm.tsx | 171 |
| SearchArea | onSearch | onSubmit | jsx | features/demand/src/pages/forecast-price/components/ForecastPriceForm.tsx | 198 |
| SearchArea | onResetCondition | <arrow> handleResetCondition | jsx | features/demand/src/pages/forecast-price/components/ForecastPriceForm.tsx | 199 |
| CustomDropdown | onChange | <arrow> confirmIfDirtyKey(tabDirtyKey(tabId),'search').then,confirmIfDirtyKey,tabDirtyKey,String,setSearchParams | jsx | features/demand/src/pages/forecast-price/components/ForecastPriceForm.tsx | 218 |
| CustomDropdown | onChange | <arrow> setSearchParams,String(selected??'').split(',').filter,String(selected??'').split,String | jsx | features/demand/src/pages/forecast-price/components/ForecastPriceForm.tsx | 326 |
| PeriodField | onChange | <arrow> setSearchParams | jsx | features/demand/src/pages/forecast-price/components/ForecastPriceForm.tsx | 341 |
| CustomDropdown | onChange | <arrow> onBucketChange,setSearchParams | jsx | features/demand/src/pages/forecast-price/components/ForecastPriceForm.tsx | 353 |
| ProjectField | onChange | <arrow> setSearchParams | jsx | features/demand/src/pages/forecast-price/components/ForecastPriceForm.tsx | 371 |
| ItemField | onChange | <arrow> setSearchParams | jsx | features/demand/src/pages/forecast-price/components/ForecastPriceForm.tsx | 389 |
| OwnerField | onChange | <arrow> setSearchParams | jsx | features/demand/src/pages/forecast-price/components/ForecastPriceForm.tsx | 406 |
| VersionField | onOpenPopup | onOpenVersionLookup | jsx | features/demand/src/pages/forecast-price/components/ForecastPriceForm.tsx | 418 |
| Checkbox | onChange | <arrow> setSearchParams | jsx | features/demand/src/pages/forecast-price/components/ForecastPriceForm.tsx | 426 |
| Checkbox | onChange | <arrow> setSearchParams | jsx | features/demand/src/pages/forecast-price/components/ForecastPriceForm.tsx | 431 |
| gridFilter | filterApplied | rememberFilter | addHandler | features/demand/src/pages/forecast-price/components/ForecastPriceGrid.tsx | 1133 |
| g | beginningEdit | beginCellEditHandler | addHandler | features/demand/src/pages/forecast-price/components/ForecastPriceGrid.tsx | 1918 |
| g | pastingCell | cellEditableHandler | addHandler | features/demand/src/pages/forecast-price/components/ForecastPriceGrid.tsx | 1919 |
| g | cellEditEnded | cellEditHandler | addHandler | features/demand/src/pages/forecast-price/components/ForecastPriceGrid.tsx | 1920 |
| g | pastedCell | cellEditHandler | addHandler | features/demand/src/pages/forecast-price/components/ForecastPriceGrid.tsx | 1921 |
| g | formatItem | formatHandler | addHandler | features/demand/src/pages/forecast-price/components/ForecastPriceGrid.tsx | 1922 |
| g | updatedView | reapplyCellProdSiteMap | addHandler | features/demand/src/pages/forecast-price/components/ForecastPriceGrid.tsx | 1923 |
| g.hostElement | keydown | enforceDecimalKey | addEventListener | features/demand/src/pages/forecast-price/components/ForecastPriceGrid.tsx | 1924 |
| g.hostElement | keydown | keydownHandler | addEventListener | features/demand/src/pages/forecast-price/components/ForecastPriceGrid.tsx | 1925 |
| g.hostElement | dblclick | dblclickHandler | addEventListener | features/demand/src/pages/forecast-price/components/ForecastPriceGrid.tsx | 1926 |
| g | updatedLayout | applyHeaderHeight | addHandler | features/demand/src/pages/forecast-price/components/ForecastPriceGrid.tsx | 1964 |
| g | updatedLayout | applyDynVisibility | addHandler | features/demand/src/pages/forecast-price/components/ForecastPriceGrid.tsx | 2029 |
| g | formatItem | formatHandler | addHandler | features/demand/src/pages/forecast-price/components/modals/ExchangeRateModal.tsx | 427 |
| g | cellEditEnded | cellEditEndedHandler | addHandler | features/demand/src/pages/forecast-price/components/modals/ExchangeRateModal.tsx | 456 |
| g | pastedCell | cellEditEndedHandler | addHandler | features/demand/src/pages/forecast-price/components/modals/ExchangeRateModal.tsx | 461 |
| g | updatedLayout | normalizeHeader | addHandler | features/demand/src/pages/forecast-price/components/modals/ExchangeRateModal.tsx | 584 |
| SearchArea | onSearch | handleFind | jsx | features/demand/src/pages/forecast-price/components/modals/ExchangeRateModal.tsx | 790 |
| CustomDropdown | onChange | <arrow> setDivisionId,String | jsx | features/demand/src/pages/forecast-price/components/modals/ExchangeRateModal.tsx | 802 |
| PeriodField | onChange | <arrow> setQueryPeriod | jsx | features/demand/src/pages/forecast-price/components/modals/ExchangeRateModal.tsx | 811 |
| Button | onClick | <arrow> handleBpsIf | jsx | features/demand/src/pages/forecast-price/components/modals/ExchangeRateModal.tsx | 860 |
| Button | onClick | handleInsert | jsx | features/demand/src/pages/forecast-price/components/modals/ExchangeRateModal.tsx | 870 |
| Button | onClick | <arrow> handleSave | jsx | features/demand/src/pages/forecast-price/components/modals/ExchangeRateModal.tsx | 880 |
| Button | onClick | modalClose | jsx | features/demand/src/pages/forecast-price/components/modals/ExchangeRateModal.tsx | 888 |
| SearchArea | onSearch | <arrow> handleFind | jsx | features/demand/src/pages/forecast-price/components/modals/ForecastTemplateModal.tsx | 224 |
| Button | onClick | handleExcel | jsx | features/demand/src/pages/forecast-price/components/modals/ForecastTemplateModal.tsx | 262 |
| Button | onClick | modalClose | jsx | features/demand/src/pages/forecast-price/components/modals/ForecastTemplateModal.tsx | 271 |
| g | formatItem | formatHandler | addHandler | features/demand/src/pages/forecast-price/components/modals/SavePricePeriodModal.tsx | 718 |
| g | beginningEdit | editGuard | addHandler | features/demand/src/pages/forecast-price/components/modals/SavePricePeriodModal.tsx | 727 |
| g | scrollPositionChanged | handleScrollInvalidate | addHandler | features/demand/src/pages/forecast-price/components/modals/SavePricePeriodModal.tsx | 731 |
| g | updatedLayout | reattachDataMaps | addHandler | features/demand/src/pages/forecast-price/components/modals/SavePricePeriodModal.tsx | 813 |
| g | updatedLayout | normalizeHeader | addHandler | features/demand/src/pages/forecast-price/components/modals/SavePricePeriodModal.tsx | 874 |
| SearchArea | onSearch | handleFind | jsx | features/demand/src/pages/forecast-price/components/modals/SavePricePeriodModal.tsx | 978 |
| CustomDropdown | onChange | <arrow> setSearchParams,String | jsx | features/demand/src/pages/forecast-price/components/modals/SavePricePeriodModal.tsx | 993 |
| CustomDropdown | onChange | <arrow> setSearchParams,String(selected??'').split(',').filter,String(selected??'').split,String | jsx | features/demand/src/pages/forecast-price/components/modals/SavePricePeriodModal.tsx | 1023 |
| SalesSiteField | onChange | <arrow> setSearchParams | jsx | features/demand/src/pages/forecast-price/components/modals/SavePricePeriodModal.tsx | 1051 |
| PeriodField | onChange | <arrow> setSearchParams,snapMonday | jsx | features/demand/src/pages/forecast-price/components/modals/SavePricePeriodModal.tsx | 1062 |
| InputField | onChange | <arrow> setSearchParams | jsx | features/demand/src/pages/forecast-price/components/modals/SavePricePeriodModal.tsx | 1084 |
| InputField | onDoubleClick | <arrow> setOpenProject | jsx | features/demand/src/pages/forecast-price/components/modals/SavePricePeriodModal.tsx | 1085 |
| Button | onClick | <arrow> setOpenProject | jsx | features/demand/src/pages/forecast-price/components/modals/SavePricePeriodModal.tsx | 1092 |
| InputField | onChange | <arrow> setSearchParams | jsx | features/demand/src/pages/forecast-price/components/modals/SavePricePeriodModal.tsx | 1108 |
| InputField | onDoubleClick | <arrow> setOpenItem | jsx | features/demand/src/pages/forecast-price/components/modals/SavePricePeriodModal.tsx | 1109 |
| Button | onClick | <arrow> setOpenItem | jsx | features/demand/src/pages/forecast-price/components/modals/SavePricePeriodModal.tsx | 1115 |
| Button | onClick | handleExcel | jsx | features/demand/src/pages/forecast-price/components/modals/SavePricePeriodModal.tsx | 1164 |
| Button | onClick | <arrow> handleSave | jsx | features/demand/src/pages/forecast-price/components/modals/SavePricePeriodModal.tsx | 1174 |
| Button | onClick | modalClose | jsx | features/demand/src/pages/forecast-price/components/modals/SavePricePeriodModal.tsx | 1181 |
| g.hostElement? | dblclick | onDbl | addEventListener | features/demand/src/pages/forecast-price/components/modals/VersionSelectModal.tsx | 212 |
| SearchArea | onSearch | handleFind | jsx | features/demand/src/pages/forecast-price/components/modals/VersionSelectModal.tsx | 240 |
| CustomDropdown | onChange | <arrow> setSearchParams,String | jsx | features/demand/src/pages/forecast-price/components/modals/VersionSelectModal.tsx | 253 |
| PeriodField | onChange | <arrow> setSearchParams | jsx | features/demand/src/pages/forecast-price/components/modals/VersionSelectModal.tsx | 262 |
| Checkbox | onChange | <arrow> setSearchParams | jsx | features/demand/src/pages/forecast-price/components/modals/VersionSelectModal.tsx | 272 |
| Checkbox | onChange | <arrow> setSearchParams | jsx | features/demand/src/pages/forecast-price/components/modals/VersionSelectModal.tsx | 277 |
| InputField | onChange | <arrow> setSearchParams | jsx | features/demand/src/pages/forecast-price/components/modals/VersionSelectModal.tsx | 290 |
| Button | onClick | handleApply | jsx | features/demand/src/pages/forecast-price/components/modals/VersionSelectModal.tsx | 335 |
| Button | onClick | modalClose | jsx | features/demand/src/pages/forecast-price/components/modals/VersionSelectModal.tsx | 342 |
| ForecastPriceForm | onSubmit | <arrow> handleSubmit | jsx | features/demand/src/pages/forecast-price/ForecastPrice.tsx | 909 |
| ForecastPriceForm | onOpenVersionLookup | <arrow> setVersionModalOpen | jsx | features/demand/src/pages/forecast-price/ForecastPrice.tsx | 912 |
| ForecastPriceForm | onBucketChange | handleBucketChange | jsx | features/demand/src/pages/forecast-price/ForecastPrice.tsx | 913 |
| ForecastPriceGrid | onPopupCellDblClick | <arrow> setPopupRow,setOpenItem,setOpenProject | jsx | features/demand/src/pages/forecast-price/ForecastPrice.tsx | 931 |
| VersionSelectModal | onApply | <arrow> setSearchParams | jsx | features/demand/src/pages/forecast-price/ForecastPrice.tsx | 1044 |
| MeasureSelectModal | onApply | <arrow> staticMeasures.map,saveTitleSet('M',selected.map((name,i)=>({name,sortOrderNo:i+1}))).then,saveTitleSet,selected.map,fetchStaticMeasures,invalidateAfterSave | jsx | features/demand/src/pages/forecast-price/ForecastPrice.tsx | 1057 |
| ColumnLayoutModal | onSave | <arrow> applyColumnLayout,settings.map,settings.filter,saveTitleSet('C',visible.map((s,i)=>({name:s.COLUMN_NAME,sortOrderNo:i+1,colWidth:s.COL_WIDTH,cellColor:s.CELL_COLOR,textColor:s.TEXT_COLOR,}))).then,saveTitleSet,visible.map | jsx | features/demand/src/pages/forecast-price/ForecastPrice.tsx | 1087 |
| SavePricePeriodModal | onSaveResult | <arrow> invalidateAfterSave | jsx | features/demand/src/pages/forecast-price/ForecastPrice.tsx | 1145 |
| FcstUploadModal | onSave | saveExcelUpload | jsx | features/demand/src/pages/forecast-price/ForecastPrice.tsx | 1168 |
| FcstUploadModal | onUploaded | <arrow> invalidateAfterSave | jsx | features/demand/src/pages/forecast-price/ForecastPrice.tsx | 1169 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Grid | 14 |
| Button | 13 |
| FormItem | 12 |
| CustomDropdown | 9 |
| SearchArea | 5 |
| DataGrid | 5 |
| ProgressIndicator | 5 |
| PeriodField | 4 |
| Checkbox | 4 |
| CustomDialog | 4 |
| ResultArea | 4 |
| FileExceldownloadIcon | 3 |
| InputField | 3 |
| Stack | 2 |
| FunctionSearchIcon | 2 |
| ControlConfirmIcon | 2 |
| ProjectByDivisionModal | 2 |
| ItemByDivisionModal | 2 |
| ProjectField | 1 |
| ItemField | 1 |
| OwnerField | 1 |
| VersionField | 1 |
| Tooltip | 1 |
| SalesSiteField | 1 |
| FileExceluploadIcon | 1 |
| IcExchangeRate | 1 |
| IcGridColumnSetup | 1 |
| IcMeasureSelect | 1 |
| MainTitle | 1 |
| ForecastPriceForm | 1 |
| SubTitle | 1 |
| ForecastPriceGrid | 1 |
| VersionSelectModal | 1 |
| MeasureSelectModal | 1 |
| ColumnLayoutModal | 1 |
| ExchangeRateModal | 1 |
| SavePricePeriodModal | 1 |
| ForecastTemplateModal | 1 |
| FcstUploadModal | 1 |

## 6. 하드코딩 Grid 컬럼
| context | binding | header | width | visible | isReadOnly | dataType | via | file | line |
|---|---|---|---|---|---|---|---|---|---|
| dynamicColumns | m.binding | hasDaily ? (m.kind === 'D' ? m.leaf \|\| 'SUM' : 'SUM') : subK | 90 | true |  |  | object | features/demand/src/pages/forecast-price/components/ForecastPriceGrid.tsx | 934 |
| gridStaticColumns | c.key | c.header | c.width | true |  |  | meta-map | features/demand/src/pages/forecast-price/components/modals/ExchangeRateModal.tsx | 317 |
| gridDynamicColumns | `M_${ym}` | ym.slice(4, 6) | 90 | true |  |  | object | features/demand/src/pages/forecast-price/components/modals/ExchangeRateModal.tsx | 354 |
| trailing | c.key | c.header | c.width | true |  |  | object | features/demand/src/pages/forecast-price/components/modals/ExchangeRateModal.tsx | 377 |
| FALLBACK_FIXED | DIVISION_ID | Division* | 50 |  |  |  | meta-shape | features/demand/src/pages/forecast-price/components/modals/SavePricePeriodModal.tsx | 81 |
| FALLBACK_FIXED | DEPT_ID | Team | 80 |  |  |  | meta-shape | features/demand/src/pages/forecast-price/components/modals/SavePricePeriodModal.tsx | 82 |
| FALLBACK_FIXED | END_CUSTOMER40 | End Customer* | 80 |  |  |  | meta-shape | features/demand/src/pages/forecast-price/components/modals/SavePricePeriodModal.tsx | 83 |
| FALLBACK_FIXED | SCM_SITE_ID | Sales Site* | 120 |  |  |  | meta-shape | features/demand/src/pages/forecast-price/components/modals/SavePricePeriodModal.tsx | 84 |
| FALLBACK_FIXED | PROJECT_CODE | Project Code* | 80 |  |  |  | meta-shape | features/demand/src/pages/forecast-price/components/modals/SavePricePeriodModal.tsx | 85 |
| FALLBACK_FIXED | ITEM_ID | Model* | 100 |  |  |  | meta-shape | features/demand/src/pages/forecast-price/components/modals/SavePricePeriodModal.tsx | 86 |
| FALLBACK_FIXED | ITEM_NAME | Model Name | 80 |  |  |  | meta-shape | features/demand/src/pages/forecast-price/components/modals/SavePricePeriodModal.tsx | 87 |
| FALLBACK_FIXED | INCOTERMS | Incoterms* | 80 |  |  |  | meta-shape | features/demand/src/pages/forecast-price/components/modals/SavePricePeriodModal.tsx | 88 |
| FALLBACK_FIXED | FCST_TYPE | FCST Type* | 80 |  |  |  | meta-shape | features/demand/src/pages/forecast-price/components/modals/SavePricePeriodModal.tsx | 89 |
| FALLBACK_FIXED | DOM_EXP | Customs Handbook* | 80 |  |  |  | meta-shape | features/demand/src/pages/forecast-price/components/modals/SavePricePeriodModal.tsx | 90 |
| FALLBACK_FIXED | CURRENCY | Currency* | 60 |  |  |  | meta-shape | features/demand/src/pages/forecast-price/components/modals/SavePricePeriodModal.tsx | 91 |
| FALLBACK_FIXED | PLANT_SITE_ID | Plant Site* | 80 |  |  |  | meta-shape | features/demand/src/pages/forecast-price/components/modals/SavePricePeriodModal.tsx | 92 |
| FALLBACK_FIXED | CELL_PROD_SITE_ID | Cell Prod Site* | 80 |  |  |  | meta-shape | features/demand/src/pages/forecast-price/components/modals/SavePricePeriodModal.tsx | 93 |
| FALLBACK_FIXED | MEASURE | Measure* | 80 |  |  |  | meta-shape | features/demand/src/pages/forecast-price/components/modals/SavePricePeriodModal.tsx | 94 |
| PRICE_ALL_COL | PRICE_ALL | 일괄입력 Price | 130 | true |  |  | meta-shape | features/demand/src/pages/forecast-price/components/modals/SavePricePeriodModal.tsx | 114 |
| base | c.colNm | c.colLblNm \|\| c.colNm | c.colWth ?? 80 | true |  |  | meta-map | features/demand/src/pages/forecast-price/components/modals/SavePricePeriodModal.tsx | 346 |
| dynamicColumns | DIVISION_ID:DIVISION_ID,END_CUSTOMER:END_CUSTOMER | leafLabel | 90 | true |  |  | object | features/demand/src/pages/forecast-price/components/modals/SavePricePeriodModal.tsx | 479 |
| VERSION_COLUMNS | VERSION_NO | Version | 240 |  |  |  | meta-shape | features/demand/src/pages/forecast-price/components/modals/VersionSelectModal.tsx | 65 |
| VERSION_COLUMNS | VERSION_DESCRIPTION | Description | 300 |  |  |  | meta-shape | features/demand/src/pages/forecast-price/components/modals/VersionSelectModal.tsx | 66 |
| VERSION_COLUMNS | VERSION_TYPE | Type | 90 |  |  |  | meta-shape | features/demand/src/pages/forecast-price/components/modals/VersionSelectModal.tsx | 67 |
| VERSION_COLUMNS | CREATED_BY | Create By | 110 |  |  |  | meta-shape | features/demand/src/pages/forecast-price/components/modals/VersionSelectModal.tsx | 68 |
| VERSION_COLUMNS | CREATION_DATE | Create Date | 150 |  |  |  | meta-shape | features/demand/src/pages/forecast-price/components/modals/VersionSelectModal.tsx | 69 |
| buildGroupKeyOf | column?.binding ?? '' |  |  | column?.visible !== false |  |  | object | features/demand/src/pages/forecast-price/ForecastPrice.tsx | 474 |
| meta | DIVISION_ID | Div | 50 |  |  |  | meta-shape | features/demand/src/pages/forecast-price/utils/forecast-price.excelForm.test.ts | 64 |
| meta | DEPT_NAME | Team | 180 |  |  |  | meta-shape | features/demand/src/pages/forecast-price/utils/forecast-price.excelForm.test.ts | 65 |
| meta | END_CUSTOMER | End Customer | 150 |  |  |  | meta-shape | features/demand/src/pages/forecast-price/utils/forecast-price.excelForm.test.ts | 66 |
| meta | PROJECT_CODE | Project Code | 100 |  |  |  | meta-shape | features/demand/src/pages/forecast-price/utils/forecast-price.excelForm.test.ts | 67 |
| meta | CURRENCY | Currency | 80 |  |  |  | meta-shape | features/demand/src/pages/forecast-price/utils/forecast-price.excelForm.test.ts | 68 |
| meta | ITEM_ID | Model | 150 |  |  |  | meta-shape | features/demand/src/pages/forecast-price/utils/forecast-price.excelForm.test.ts | 69 |
| meta | t | t | 40 |  |  |  | meta-map | features/demand/src/pages/forecast-price/utils/forecast-price.excelForm.test.ts | 70 |
| toPreviewColumns | col.key | col.isMonth ? monthLabel(col.header) : col.header | col.width ?? (col.isMonth ? 90 : 120) | true |  |  | meta-map | features/demand/src/pages/forecast-price/utils/forecast-price.excelForm.ts | 149 |

## 7. 메시지 코드
| code | count |
|---|---|
| MSG00009 | 1 |
| MSG00011 | 1 |
| LBL00112 | 1 |
| LBL00001 | 5 |
| LBL00044 | 1 |
| LBL00080 | 2 |
| LBL00011 | 1 |
| LBL00085 | 1 |
| LBL00090 | 1 |
| LBL00710 | 1 |
| LBL00005 | 1 |
| LBL00687 | 1 |
| LBL00689 | 1 |
| LBL00632 | 1 |
| MSG00026 | 2 |
| MSG00027 | 1 |
| MSG00108 | 2 |
| LBL00661 | 3 |
| LBL00664 | 4 |
| LBL00674 | 3 |
| LBL00762 | 2 |
| LBL00763 | 1 |
| LBL00627 | 3 |
| LBL00662 | 5 |
| LBL00617 | 1 |
| LBL00669 | 1 |
| LBL00111 | 1 |
| LBL00608 | 1 |
| LBL00682 | 1 |
| LBL00683 | 1 |
| LBL00684 | 1 |
| MSG00429 | 1 |
| MSG00002 | 1 |
| MSG00001 | 1 |
| MSG00043 | 1 |
| MSG00113 | 1 |
| MSG00164 | 1 |
| MSG00227 | 1 |
| MSG00260 | 1 |
| MSG00283 | 1 |
| MSG00255 | 1 |
| MSG00662 | 1 |
| MSG00667 | 1 |
| MSG00680 | 2 |
| MSG00670 | 1 |
| MSG00671 | 1 |
| MSG00477 | 1 |
| MSG00476 | 1 |
| MSG00004 | 1 |
| MSG00137 | 1 |
| MSG00330 | 1 |
| MSG00409 | 1 |
| MSG00672 | 1 |
| MSG00689 | 1 |
| MSG00618 | 1 |
| MSG01023 | 1 |
| LBL00346 | 1 |
| LBL00605 | 2 |
| LBL00310 | 2 |
| LBL00764 | 1 |
| LBL00765 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: DMF0082(43), DMF0003(27), DMF0020(18), DMF0021(4), DMF0042(2), DMF0074(2), DMF0073(1), SYS0004(1), COM0005(1), COM0006(1), DMF0043(1)
- SP/PKG: PKG_DMF0082(12), DMF0082_SAVE_MAIN_DATA(8), P_DMF0082_GET_BUTTON_AUTH(7), PR_GET_SHEET_COLUMN_LIST(4), DMF0073_GET_VERSION_SALESPRICE(3), P_DMF0082_GET_EXCEL_UPLOAD_DATA(3), DMF0082_GET_SPREAD_TITLE(2), PKG_DMF0000(2), P_DMF0000_SAVE_EXCHANGE_POPUP_DATA(2), PR_SCM_MST_EXCHANGE_RATE_UI(2), P_DMF0082_GET_EXCEL_FORM_DATA(2), DMF0000_GET_COMMON_SPREAD_TITLE(2), PKG_SCM0002(2), P_DMF0082_SAVE_MAIN_DATA(2), P_USERINFO(2), DMF0003_GET_BUCKET_TYPE_CODE(1), PKG_DMF0020(1), PR_SCM_MST_EXCHANGE_RATE(1), DMF0082_GET_EXCEL_FORM(1), SCM0002_GET_VERSIONBYWATERFALLPOPUP(1), P_VERSION_TYPE(1), P_SCM0002_GET_VERSIONBYWATERFALLPOPUP(1), P_DMF0082_EXCEL_UPLOAD(1), P_DMF0082_GET_MAIN_DATA(1), PKG_COM0000(1), P_COM0008_GET_ITEM_BY_DIVISION_POPUP(1), P_DEPT_ID(1), P_DMF0002_GET_ITEM_BY_DIVISION_POPUPEX(1), PR_GET_DAY_RANGE(1), DMF0002_GET_TITLESET_POPUP(1), SCM0002_SET_TITLESET_POPUP(1), P_MODE(1), PR_GET_LOOKUP_INFO_LIST(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| endpoint | Bucket 옵션 = CMBO 'BucketType' 동적 fetch (DMF0003_GET_BUCKET_TYPE_CODE 1:1 — CMBO 등록명). | features/demand/src/pages/forecast-price/components/ForecastPriceForm.tsx | 66 |
| code | const applyEditMeasures = (dataItem: WijmoRowItem, clearStale = false) => { | features/demand/src/pages/forecast-price/components/ForecastPriceGrid.tsx | 594 |
| code | applyEditMeasures(item); | features/demand/src/pages/forecast-price/components/ForecastPriceGrid.tsx | 739 |
| code | applyCellProdSites(item); | features/demand/src/pages/forecast-price/components/ForecastPriceGrid.tsx | 740 |
| jsx | `<DataGrid>` 가 `handleInitialized`(DataGrid.tsx:542)에서 이미 만들며, 그쪽이 React | features/demand/src/pages/forecast-price/components/ForecastPriceGrid.tsx | 1152 |
| jsx | → 대상 목록은 `<DataGrid filterColumns={...}>` 로 넘긴다(아래 JSX). 생성 주체는 DataGrid 단일. | features/demand/src/pages/forecast-price/components/ForecastPriceGrid.tsx | 1156 |
| jsx | CODE='9' / RESULT_MSG='fail' / EVENT=<SQLERRM> 를 돌려주는데, RESULT_MSG 만 읽으면 | features/demand/src/pages/forecast-price/components/modals/ExchangeRateModal.tsx | 219 |
| code | 그 전에 실행되고 끝난다. 예전처럼 `if (!g) return` 으로 포기하면 deps 가 다시 바뀌지 않는 한 | features/demand/src/pages/forecast-price/components/modals/ExchangeRateModal.tsx | 394 |
| code | dtEndCustomer = DataService.GetDMInnerTable("EndCustomerByDivision", Filter); | features/demand/src/pages/forecast-price/components/modals/SavePricePeriodModal.tsx | 297 |
| code | 컬럼/메저를 복원된 division 기준으로 다시 받는다(별도 순서 await 불필요). | features/demand/src/pages/forecast-price/ForecastPrice.tsx | 133 |
| code | error.response 를 그대로 resolve 한다(axios-interceptors.ts L53~55) → await 가 throw 안 함. | features/demand/src/pages/forecast-price/ForecastPrice.tsx | 750 |

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

