# DMF0003 — To-Be Fact Pack 요약

- page_key: `demand/mkt-fcst` · feature: demand · As-is Fact Pack 있음
- 파일 31 · 엔드포인트 호출 23 (미해결 2, 주석 속 4) · 이벤트 46 · 컴포넌트 사용 93 · 하드코딩 컬럼 42 · 메시지 104
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 사용 · 하드코딩 컬럼 정의 42건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/demand/src/pages/mkt-fcst/components/MktFcstForm.module.scss | component | 60 |
| features/demand/src/pages/mkt-fcst/components/MktFcstForm.tsx | component | 452 |
| features/demand/src/pages/mkt-fcst/components/MktFcstGrid.tsx | component | 2255 |
| features/demand/src/pages/mkt-fcst/components/modals/index.ts | index | 8 |
| features/demand/src/pages/mkt-fcst/components/modals/mkt-fcst-modals.constants.ts | constants | 376 |
| features/demand/src/pages/mkt-fcst/components/modals/PrHistoryModal.tsx | component | 216 |
| features/demand/src/pages/mkt-fcst/components/modals/PrModal.tsx | component | 355 |
| features/demand/src/pages/mkt-fcst/components/modals/SspSyncCompareModal.tsx | component | 123 |
| features/demand/src/pages/mkt-fcst/components/modals/SspSyncResultModal.tsx | component | 83 |
| features/demand/src/pages/mkt-fcst/index.ts | index | 2 |
| features/demand/src/pages/mkt-fcst/mkt-fcst.constants.ts | constants | 399 |
| features/demand/src/pages/mkt-fcst/mkt-fcst.types.ts | types | 72 |
| features/demand/src/pages/mkt-fcst/MktFcst.module.scss | style | 101 |
| features/demand/src/pages/mkt-fcst/MktFcst.tsx | page | 1196 |
| features/demand/src/pages/mkt-fcst/useMktFcstStore.ts | store | 563 |
| features/demand/src/pages/mkt-fcst/utils/mkt-fcst.comboDebug.ts | util | 261 |
| features/demand/src/pages/mkt-fcst/utils/mkt-fcst.core.test.ts | test | 264 |
| features/demand/src/pages/mkt-fcst/utils/mkt-fcst.division.ts | util | 160 |
| features/demand/src/pages/mkt-fcst/utils/mkt-fcst.editLock.ts | util | 283 |
| features/demand/src/pages/mkt-fcst/utils/mkt-fcst.gridCombos.ts | util | 589 |
| features/demand/src/pages/mkt-fcst/utils/mkt-fcst.merge.ts | util | 222 |
| features/demand/src/pages/mkt-fcst/utils/mkt-fcst.prContext.ts | util | 208 |
| features/demand/src/pages/mkt-fcst/utils/mkt-fcst.recalc.test.ts | test | 256 |
| features/demand/src/pages/mkt-fcst/utils/mkt-fcst.recalc.ts | util | 404 |
| features/demand/src/pages/mkt-fcst/utils/mkt-fcst.save.ts | util | 186 |
| features/demand/src/pages/mkt-fcst/utils/mkt-fcst.searchCombos.ts | util | 106 |
| features/demand/src/pages/mkt-fcst/utils/mkt-fcst.sspSync.ts | util | 46 |
| features/demand/src/pages/mkt-fcst/utils/mkt-fcst.validate.ts | util | 214 |
| features/demand/src/pages/mkt-fcst/__2047935-readd-list__.md | other | 93 |
| features/demand/src/pages/mkt-fcst/__asis-mapping__.md | mapping | 662 |
| features/demand/src/pages/mkt-fcst/__grid-combos__.md | other | 267 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueries) | hook | 9 | Y | MktFcstForm.tsx:57 MktFcstForm.tsx:93 MktFcstGrid.tsx:262 MktFcstGrid.tsx:444 MktFcstGrid.tsx:496 MktFcstGrid.tsx:629 |
| {?param} | http | 1 | N | MktFcstGrid.tsx:565 |
| {?buildVmiLookupParam(editedRowRec,division)} | http | 1 | N | MktFcstGrid.tsx:1587 |
| DMF0003/prHistory//call-proc | hook | 1 | Y | PrHistoryModal.tsx:73 |
| DMF0003/prPopup//call-proc | hook | 1 | Y | PrModal.tsx:90 |
| /DMF0003/prPopup/SAVE/call-proc | http | 1 | Y | PrModal.tsx:183 |
| DMF0003/sspCompare//call-proc | hook | 1 | Y | SspSyncCompareModal.tsx:60 |
| DMF0003/dayRange//call-proc | hook | 1 | Y | MktFcst.tsx:113 |
| DMF0003/Mkt Fcst//call-proc | hook | 1 | Y | MktFcst.tsx:282 |
| DMF0003/spreadTitle//call-proc | hook | 1 | Y | MktFcst.tsx:292 |
| /DMF0003/Mkt Fcst/SAVE/call-proc | http | 1 | Y | MktFcst.tsx:764 |
| /admin/menu/DMF0003/column | http | 1 | Y | useMktFcstStore.ts:345 |
| DMF0003/titleSet/SEARCH/call-proc | http | 1 | Y | useMktFcstStore.ts:379 |
| /admin/menu/DMF0003/measure | http | 1 | Y | useMktFcstStore.ts:435 |
| /admin/menu/DMF0003/search-conditions | http | 1 | Y | useMktFcstStore.ts:453 |

## 3. procedures.d.ts 등재 시트
| sheet | request_keys | response_cursors | sp_hints |
|---|---|---|---|
| Mkt Fcst | divisionId scmSiteId plantSiteId teamId customer bizType projectCode itemId fromYyyymmdd toYyyymmdd createdBy userGroup itemType owner qtyYn cellYn invalidExec asYn userDeptId senderCode sesUserId mnuId | o_rc1 o_rc2 o_rc3 | DMF0003_GET_MKT_FCST_DATA DMF0003_GET_SPREAD_TITLE P_USER_ID P_MENU_ID P_CREATED_BY P_USER_GROUP |
| spreadTitle | startYyyymmdd endYyyymmdd createdBy divisionId userGroup type | o_rc1 | DMF0003_GET_MKT_FCST_DATA DMF0003_GET_SPREAD_TITLE P_USER_ID P_MENU_ID P_CREATED_BY P_USER_GROUP |
| measureCount |  | o_rc1 | DMF0003_GET_MKT_FCST_DATA DMF0003_GET_SPREAD_TITLE P_USER_ID P_MENU_ID P_CREATED_BY P_USER_GROUP |
| sspCompare | divisionId scmSiteId projectCode itemId domExp fcstType incoterms yyyymmdd | o_rc1 | DMF0003_GET_MKT_FCST_COMPARE_POPUP DMF0003_GET_MKT_FCST_DATA DMF0003_GET_SPREAD_TITLE P_USER_ID P_MENU_ID P_CREATED_BY P_USER_GROUP |
| prPopup | popupType requestNo divisionId projectCode scmSiteId itemId domExp fcstType incoterms plantSiteId yyyymmdd planQty | o_rc1 o_rc2 o_rc3 | DMF0003_GET_PRPOPUP DMF0003_SAVE_PRPOPUP DMF0003_GET_MKT_FCST_DATA DMF0003_GET_SPREAD_TITLE P_USER_ID P_MENU_ID P_CREATED_BY P_USER_GROUP |
| prHistory | popupType divisionId requestNo projectCode scmSiteId itemId domExp fcstType incoterms plantSiteId yyyymmdd planQty | o_rc1 o_rc2 | DMF0003_GET_PR_HISTORY_POPUP DMF0003_GET_MKT_FCST_DATA DMF0003_GET_SPREAD_TITLE P_USER_ID P_MENU_ID P_CREATED_BY P_USER_GROUP |
| dayRange | createdBy month | o_rc1 o_rc2 | DMF0003_GET_MKT_FCST_DATA DMF0003_GET_SPREAD_TITLE P_USER_ID P_MENU_ID P_CREATED_BY P_USER_GROUP |

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| CustomDropdown | onChange | <arrow> onPick,String(picked??'').split(',').filter,String(picked??'').split,String | jsx | features/demand/src/pages/mkt-fcst/components/MktFcstForm.tsx | 154 |
| SearchArea | onSearch | onSearch | jsx | features/demand/src/pages/mkt-fcst/components/MktFcstForm.tsx | 196 |
| CustomDropdown | onChange | <arrow> confirmIfDirtyKey(tabDirtyKey(tabId),'search').then,confirmIfDirtyKey,tabDirtyKey,String,set | jsx | features/demand/src/pages/mkt-fcst/components/MktFcstForm.tsx | 210 |
| PeriodField | onChange | <arrow> set | jsx | features/demand/src/pages/mkt-fcst/components/MktFcstForm.tsx | 317 |
| CustomDropdown | onChange | <arrow> setAlert,t,setBucketKey,set | jsx | features/demand/src/pages/mkt-fcst/components/MktFcstForm.tsx | 330 |
| ProjectField | onChange | <arrow> set | jsx | features/demand/src/pages/mkt-fcst/components/MktFcstForm.tsx | 366 |
| ItemField | onChange | <arrow> set | jsx | features/demand/src/pages/mkt-fcst/components/MktFcstForm.tsx | 378 |
| CustomDropdown | onChange | <arrow> set,String(options??'').split(',').filter,String(options??'').split,String | jsx | features/demand/src/pages/mkt-fcst/components/MktFcstForm.tsx | 400 |
| OwnerField | onChange | <arrow> set | jsx | features/demand/src/pages/mkt-fcst/components/MktFcstForm.tsx | 415 |
| Checkbox | onChange | <arrow> set | jsx | features/demand/src/pages/mkt-fcst/components/MktFcstForm.tsx | 430 |
| Checkbox | onChange | <arrow> set | jsx | features/demand/src/pages/mkt-fcst/components/MktFcstForm.tsx | 435 |
| Checkbox | onChange | <arrow> set | jsx | features/demand/src/pages/mkt-fcst/components/MktFcstForm.tsx | 442 |
| g | formatItem | formatHandler | addHandler | features/demand/src/pages/mkt-fcst/components/MktFcstGrid.tsx | 1175 |
| g | beginningEdit | beginningEditHandler | addHandler | features/demand/src/pages/mkt-fcst/components/MktFcstGrid.tsx | 1430 |
| g | cellEditEnded | cellEditEndedHandler | addHandler | features/demand/src/pages/mkt-fcst/components/MktFcstGrid.tsx | 1685 |
| g.hostElement | dblclick | dblclickHandler | addEventListener | features/demand/src/pages/mkt-fcst/components/MktFcstGrid.tsx | 1754 |
| li | mouseenter | <arrow>  | addEventListener | features/demand/src/pages/mkt-fcst/components/MktFcstGrid.tsx | 1850 |
| li | mouseleave | <arrow>  | addEventListener | features/demand/src/pages/mkt-fcst/components/MktFcstGrid.tsx | 1851 |
| li | mousedown | <arrow> e.preventDefault,e.stopPropagation,handlePrAction | addEventListener | features/demand/src/pages/mkt-fcst/components/MktFcstGrid.tsx | 1853 |
| document | mousedown | dismissOutside | addEventListener | features/demand/src/pages/mkt-fcst/components/MktFcstGrid.tsx | 1863 |
| document | contextmenu | dismissOutside | addEventListener | features/demand/src/pages/mkt-fcst/components/MktFcstGrid.tsx | 1864 |
| g | cellEditEnding | editChangeHandler | addHandler | features/demand/src/pages/mkt-fcst/components/MktFcstGrid.tsx | 1878 |
| g.hostElement | keydown | blockQtyDotKey | addEventListener | features/demand/src/pages/mkt-fcst/components/MktFcstGrid.tsx | 1887 |
| g | cellEditEnding | truncQtyOnCommit | addHandler | features/demand/src/pages/mkt-fcst/components/MktFcstGrid.tsx | 1898 |
| g | pastingCell | pastingCellHandler | addHandler | features/demand/src/pages/mkt-fcst/components/MktFcstGrid.tsx | 2015 |
| g | pastedCell | pastedCellHandler | addHandler | features/demand/src/pages/mkt-fcst/components/MktFcstGrid.tsx | 2016 |
| g | scrollPositionChanged | handleScrollInvalidate | addHandler | features/demand/src/pages/mkt-fcst/components/MktFcstGrid.tsx | 2020 |
| g | updatedLayout | applyHeaderHeight | addHandler | features/demand/src/pages/mkt-fcst/components/MktFcstGrid.tsx | 2135 |
| g | updatedLayout | applyDynVisibility | addHandler | features/demand/src/pages/mkt-fcst/components/MktFcstGrid.tsx | 2188 |
| f | filterApplied | onFilterApplied | addHandler | features/demand/src/pages/mkt-fcst/components/MktFcstGrid.tsx | 2219 |
| g | selectionChanged | onSelection | addHandler | features/demand/src/pages/mkt-fcst/components/modals/PrHistoryModal.tsx | 106 |
| Button | onClick | modalClose | jsx | features/demand/src/pages/mkt-fcst/components/modals/PrHistoryModal.tsx | 208 |
| InputField | onChange | <arrow> setPrHeader | jsx | features/demand/src/pages/mkt-fcst/components/modals/PrModal.tsx | 277 |
| InputField | onChange | <arrow> setPuchMgr | jsx | features/demand/src/pages/mkt-fcst/components/modals/PrModal.tsx | 291 |
| InputField | onChange | <arrow> setPuchGroup | jsx | features/demand/src/pages/mkt-fcst/components/modals/PrModal.tsx | 305 |
| Button | onClick | handleSave | jsx | features/demand/src/pages/mkt-fcst/components/modals/PrModal.tsx | 339 |
| Button | onClick | modalClose | jsx | features/demand/src/pages/mkt-fcst/components/modals/PrModal.tsx | 347 |
| Button | onClick | modalClose | jsx | features/demand/src/pages/mkt-fcst/components/modals/SspSyncCompareModal.tsx | 115 |
| Button | onClick | modalClose | jsx | features/demand/src/pages/mkt-fcst/components/modals/SspSyncResultModal.tsx | 75 |
| MktFcstForm | onSearch | handleSearch | jsx | features/demand/src/pages/mkt-fcst/MktFcst.tsx | 903 |
| MktFcstGrid | onPopupCellDblClick | <arrow> toCellStr,isEssItemPopupBlocked,cell,setAlert,t,setPopupGroupId | jsx | features/demand/src/pages/mkt-fcst/MktFcst.tsx | 933 |
| MktFcstGrid | onPrContext | handlePrContext | jsx | features/demand/src/pages/mkt-fcst/MktFcst.tsx | 964 |
| MktFcstGrid | onSspCompare | handleSspCompare | jsx | features/demand/src/pages/mkt-fcst/MktFcst.tsx | 965 |
| PrModal | onSaved | <arrow> refetch | jsx | features/demand/src/pages/mkt-fcst/MktFcst.tsx | 1087 |
| ColumnLayoutModal | onSave | <arrow> clearGridOnSettingChange,applyColumnLayout,settings.map,settings.filter,saveTitleSet({menuId:MENU_ID,//⚠️팝업조회(위sheetName/columnType)와반드시같은값이어야한다.sheetName:SHEETS.MAIN,columnType:'C',rows:visible.map((s,i)=>({name:s.COLUMN_NAME,sortOrderNo:i+1,colWidth:s.COL_WIDTH,cellColor:s.CELL_COLOR,textColor:s.TEXT_COLOR,})),}).then,saveTitleSet | jsx | features/demand/src/pages/mkt-fcst/MktFcst.tsx | 1114 |
| MeasureSelectModal | onApply | <arrow> clearGridOnSettingChange,applyVisibleMeasures,staticMeasures[SHEETS.MAIN].map,saveTitleSet({menuId:MENU_ID,sheetName:SHEETS.MAIN,//Measure개인화—폭/색은대상이아니라미전달(빈값으로저장됨).columnType:'M',rows:selected.map((name,i)=>({name,sortOrderNo:i+1})),}).then,saveTitleSet,selected.map | jsx | features/demand/src/pages/mkt-fcst/MktFcst.tsx | 1166 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Grid | 17 |
| FormItem | 16 |
| InputField | 12 |
| DataGrid | 5 |
| Button | 5 |
| CustomDropdown | 4 |
| CustomDialog | 4 |
| ResultArea | 4 |
| SearchArea | 3 |
| Checkbox | 3 |
| PeriodField | 1 |
| ProjectField | 1 |
| ItemField | 1 |
| OwnerField | 1 |
| Stack | 1 |
| IcGridColumnSetup | 1 |
| IcMeasureSelect | 1 |
| MainTitle | 1 |
| MktFcstForm | 1 |
| SubTitle | 1 |
| MktFcstGrid | 1 |
| ProjectByDivisionModal | 1 |
| ItemByDivisionModal | 1 |
| SspSyncCompareModal | 1 |
| SspSyncResultModal | 1 |
| PrModal | 1 |
| PrHistoryModal | 1 |
| ColumnLayoutModal | 1 |
| MeasureSelectModal | 1 |
| ProgressIndicator | 1 |

## 6. 하드코딩 Grid 컬럼
| context | binding | header | width | visible | isReadOnly | dataType | via | file | line |
|---|---|---|---|---|---|---|---|---|---|
| mergedColumns | c.key | c.header | c.width ?? 100 | true |  |  | object | features/demand/src/pages/mkt-fcst/components/MktFcstGrid.tsx | 317 |
| mergedColumns | col.colNm | col.colLblNm \|\| fb?.header \|\| col.colNm | col.colWth ?? fb?.width ?? 100 | col.visible !== false |  |  | object | features/demand/src/pages/mkt-fcst/components/MktFcstGrid.tsx | 336 |
| mainStaticColumns | c.binding | c.header | c.width | true |  |  | meta-map | features/demand/src/pages/mkt-fcst/components/MktFcstGrid.tsx | 837 |
| mainDynamicColumns | m.binding | m.kind === 'D' ? m.leaf \|\| m.small \|\| 'SUM' : 'SUM' | 90 | DYN_RANK[m.kind] < DYN_RANK[bucketPrefix] ? sumYnRef.current |  |  | object | features/demand/src/pages/mkt-fcst/components/MktFcstGrid.tsx | 922 |
| SSP_COMPARE_COLUMNS | PROJECT_CODE | End Customer | 110 | true |  |  | meta-shape | features/demand/src/pages/mkt-fcst/components/modals/mkt-fcst-modals.constants.ts | 14 |
| SSP_COMPARE_COLUMNS | SCM_SITE_ID | Sales Site | 150 | true |  |  | meta-shape | features/demand/src/pages/mkt-fcst/components/modals/mkt-fcst-modals.constants.ts | 23 |
| SSP_COMPARE_COLUMNS | ITEM_ID | Model | 140 | true |  |  | meta-shape | features/demand/src/pages/mkt-fcst/components/modals/mkt-fcst-modals.constants.ts | 32 |
| SSP_COMPARE_COLUMNS | INCOTERMS | Incoterms | 70 | true |  |  | meta-shape | features/demand/src/pages/mkt-fcst/components/modals/mkt-fcst-modals.constants.ts | 41 |
| SSP_COMPARE_COLUMNS | FCST_TYPE | Fcst Type | 70 | true |  |  | meta-shape | features/demand/src/pages/mkt-fcst/components/modals/mkt-fcst-modals.constants.ts | 50 |
| SSP_COMPARE_COLUMNS | DOM_EXP | Customs Handbook | 50 | false |  |  | meta-shape | features/demand/src/pages/mkt-fcst/components/modals/mkt-fcst-modals.constants.ts | 60 |
| SSP_COMPARE_COLUMNS | CATEGORY | Measure | 125 | true |  |  | meta-shape | features/demand/src/pages/mkt-fcst/components/modals/mkt-fcst-modals.constants.ts | 69 |
| SSP_COMPARE_COLUMNS | CONFIRM_ID | Confirm ID | 110 | true |  |  | meta-shape | features/demand/src/pages/mkt-fcst/components/modals/mkt-fcst-modals.constants.ts | 78 |
| SSP_COMPARE_COLUMNS | SO_NO | So No | 80 | true |  |  | meta-shape | features/demand/src/pages/mkt-fcst/components/modals/mkt-fcst-modals.constants.ts | 87 |
| SSP_COMPARE_COLUMNS | PLAN_QTY | Qty | 100 | true |  |  | meta-shape | features/demand/src/pages/mkt-fcst/components/modals/mkt-fcst-modals.constants.ts | 96 |
| SSP_COMPARE_COLUMNS | RESULT_QTY | Shipment Result Qty | 100 | true |  |  | meta-shape | features/demand/src/pages/mkt-fcst/components/modals/mkt-fcst-modals.constants.ts | 107 |
| SSP_SYNC_COLUMNS | MEASURE | MEASURE | 50 | false |  |  | meta-shape | features/demand/src/pages/mkt-fcst/components/modals/mkt-fcst-modals.constants.ts | 122 |
| SSP_SYNC_COLUMNS | PROJECT_CODE | End Customer | 100 | true |  |  | meta-shape | features/demand/src/pages/mkt-fcst/components/modals/mkt-fcst-modals.constants.ts | 131 |
| SSP_SYNC_COLUMNS | SCM_SITE_ID | Sales Site | 100 | true |  |  | meta-shape | features/demand/src/pages/mkt-fcst/components/modals/mkt-fcst-modals.constants.ts | 140 |
| SSP_SYNC_COLUMNS | ITEM_ID | Model | 140 | true |  |  | meta-shape | features/demand/src/pages/mkt-fcst/components/modals/mkt-fcst-modals.constants.ts | 149 |
| SSP_SYNC_COLUMNS | INCOTERMS | Incoterms | 70 | true |  |  | meta-shape | features/demand/src/pages/mkt-fcst/components/modals/mkt-fcst-modals.constants.ts | 158 |
| SSP_SYNC_COLUMNS | FCST_TYPE | Fcst Type | 70 | true |  |  | meta-shape | features/demand/src/pages/mkt-fcst/components/modals/mkt-fcst-modals.constants.ts | 167 |
| SSP_SYNC_COLUMNS | DOM_EXP | Customs Handbook | 70 | true |  |  | meta-shape | features/demand/src/pages/mkt-fcst/components/modals/mkt-fcst-modals.constants.ts | 176 |
| SSP_SYNC_COLUMNS | YYYYMMDD | YYYYMMDD | 90 | true |  |  | meta-shape | features/demand/src/pages/mkt-fcst/components/modals/mkt-fcst-modals.constants.ts | 185 |
| SSP_SYNC_COLUMNS | SYNC_QTY | Sync Qty | 70 | true |  |  | meta-shape | features/demand/src/pages/mkt-fcst/components/modals/mkt-fcst-modals.constants.ts | 194 |
| SSP_SYNC_COLUMNS | QTY | DP Qty | 70 | true |  |  | meta-shape | features/demand/src/pages/mkt-fcst/components/modals/mkt-fcst-modals.constants.ts | 205 |
| PR_DETAIL_COLUMNS | ITEM_SEQ | Seq | 50 | true |  |  | meta-shape | features/demand/src/pages/mkt-fcst/components/modals/mkt-fcst-modals.constants.ts | 222 |
| PR_DETAIL_COLUMNS | STORAGE_PLANT_ID | Plant Site | 80 | true |  |  | meta-shape | features/demand/src/pages/mkt-fcst/components/modals/mkt-fcst-modals.constants.ts | 231 |
| PR_DETAIL_COLUMNS | SCM_SITE_ID | Sales Site | 80 | true |  |  | meta-shape | features/demand/src/pages/mkt-fcst/components/modals/mkt-fcst-modals.constants.ts | 240 |
| PR_DETAIL_COLUMNS | YYYYMMDD | YYYYMMDD | 90 | true |  |  | meta-shape | features/demand/src/pages/mkt-fcst/components/modals/mkt-fcst-modals.constants.ts | 249 |
| PR_DETAIL_COLUMNS | PROJECT_CODE | Project Code | 100 | true |  |  | meta-shape | features/demand/src/pages/mkt-fcst/components/modals/mkt-fcst-modals.constants.ts | 258 |
| PR_DETAIL_COLUMNS | ITEM_ID | Model | 120 | true |  |  | meta-shape | features/demand/src/pages/mkt-fcst/components/modals/mkt-fcst-modals.constants.ts | 267 |
| PR_DETAIL_COLUMNS | ITEM_NAME | Model Name | 120 | true |  |  | meta-shape | features/demand/src/pages/mkt-fcst/components/modals/mkt-fcst-modals.constants.ts | 276 |
| PR_DETAIL_COLUMNS | ITEM_UOM | UOM | 45 | true |  |  | meta-shape | features/demand/src/pages/mkt-fcst/components/modals/mkt-fcst-modals.constants.ts | 285 |
| PR_DETAIL_COLUMNS | QTY | Qty | 80 | true |  |  | meta-shape | features/demand/src/pages/mkt-fcst/components/modals/mkt-fcst-modals.constants.ts | 294 |
| PR_DETAIL_COLUMNS | SLOC | SLOC | 60 | true |  |  | meta-shape | features/demand/src/pages/mkt-fcst/components/modals/mkt-fcst-modals.constants.ts | 304 |
| PR_DETAIL_COLUMNS | ITEM_DETAIL | Item Detail | 220 | true |  |  | meta-shape | features/demand/src/pages/mkt-fcst/components/modals/mkt-fcst-modals.constants.ts | 313 |
| PR_HISTORY_COLUMNS | REQUEST_NO | Request No | 120 | true |  |  | meta-shape | features/demand/src/pages/mkt-fcst/components/modals/mkt-fcst-modals.constants.ts | 326 |
| PR_HISTORY_COLUMNS | REQUEST_DATE | Request Date | 100 | true |  |  | meta-shape | features/demand/src/pages/mkt-fcst/components/modals/mkt-fcst-modals.constants.ts | 335 |
| PR_HISTORY_COLUMNS | REQUESTED_BY | Requested By | 100 | true |  |  | meta-shape | features/demand/src/pages/mkt-fcst/components/modals/mkt-fcst-modals.constants.ts | 344 |
| PR_HISTORY_COLUMNS | ITEM_QTY | Qty | 80 | true |  |  | meta-shape | features/demand/src/pages/mkt-fcst/components/modals/mkt-fcst-modals.constants.ts | 353 |
| PR_HISTORY_COLUMNS | ITEM_DETAIL | Item Detail | 220 | true |  |  | meta-shape | features/demand/src/pages/mkt-fcst/components/modals/mkt-fcst-modals.constants.ts | 363 |
| buildGroupKeyOf | column?.binding ?? '' |  |  | column?.visible !== false |  |  | object | features/demand/src/pages/mkt-fcst/MktFcst.tsx | 564 |

## 7. 메시지 코드
| code | count |
|---|---|
| LBL00682 | 2 |
| LBL00683 | 2 |
| LBL00684 | 2 |
| LBL00112 | 1 |
| LBL00001 | 1 |
| LBL00044 | 1 |
| LBL00080 | 2 |
| LBL00011 | 3 |
| LBL00085 | 1 |
| LBL00090 | 1 |
| LBL00710 | 1 |
| LBL00005 | 2 |
| LBL00068 | 1 |
| LBL00687 | 1 |
| LBL00689 | 1 |
| LBL00690 | 1 |
| LBL00709 | 2 |
| MSG00652 | 1 |
| LBL00674 | 4 |
| LBL00700 | 1 |
| LBL00748 | 2 |
| LBL00749 | 1 |
| LBL00669 | 3 |
| LBL00751 | 1 |
| LBL00697 | 2 |
| MSG00649 | 1 |
| MSG00651 | 2 |
| MSG00650 | 1 |
| LBL00696 | 1 |
| LBL00744 | 1 |
| LBL00641 | 1 |
| LBL00746 | 1 |
| LBL00747 | 1 |
| LBL00698 | 1 |
| LBL00699 | 1 |
| LBL00694 | 1 |
| LBL00695 | 1 |
| LBL00740 | 1 |
| LBL00741 | 1 |
| LBL00742 | 1 |
| LBL00743 | 1 |
| MSG00429 | 1 |
| MSG00113 | 1 |
| MSG00001 | 1 |
| MSG00043 | 1 |
| MSG00260 | 1 |
| MSG00097 | 1 |
| MSG00108 | 1 |
| MSG00164 | 1 |
| MSG00227 | 1 |
| MSG00152 | 1 |
| MSG00448 | 1 |
| MSG00660 | 1 |
| MSG00661 | 1 |
| MSG00662 | 1 |
| MSG00663 | 1 |
| MSG00664 | 1 |
| MSG00665 | 1 |
| MSG00666 | 1 |
| MSG00096 | 1 |
| MSG00476 | 1 |
| MSG00477 | 1 |
| MSG00478 | 1 |
| MSG00147 | 1 |
| MSG00618 | 3 |
| LBL00666 | 1 |
| MSG00606 | 1 |
| LBL00605 | 2 |
| LBL00310 | 3 |
| LBL00711 | 1 |
| LBL00764 | 1 |
| LBL00765 | 1 |
| LBL00091 | 1 |
| LBL01141 | 1 |
| LBL00024 | 1 |
| LBL00702 | 2 |
| LBL00703 | 1 |
| LBL00704 | 1 |
| LBL00705 | 1 |
| LBL00706 | 1 |
| LBL00707 | 1 |
| LBL00708 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: DMF0003(25), DMF0020(19), DMF0021(8), DMF0082(8), DMF0040(2), SYS0004(1), DMF0053(1), DMF0042(1), DMF0004(1)
- SP/PKG: DMF0003_GET_MKT_FCST_DATA(8), DMF0003_GET_SPREAD_TITLE(6), PR_HEADER(4), DMF0003_SAVE_PRPOPUP(2), DMF0003_GET_MKT_FCST_COMPARE_POPUP(2), DMF0003_SAVE_MKT_FCST(2), PKG_DMF0003(2), DMF0002_GET_TITLESET_POPUP(2), PR_GET_SHEET_COLUMN_LIST(2), DMF0003_GET_PR_HISTORY_POPUP(1), DMF0003_GET_PRPOPUP(1), DMF0003_GET_BUCKET_TYPE_CODE(1), PR_GET_SHEET_MEASURE_LIST(1), PR_GET_DAY_RANGE(1), P_USER_GROUP(1), SCM0002_SET_TITLESET_POPUP(1), P_CREATED_BY(1), P_BUCKET(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| code | const NOTATION_FIXED3 = new Intl.NumberFormat('en-US', { | features/demand/src/pages/mkt-fcst/components/MktFcstGrid.tsx | 109 |
| code | }); | features/demand/src/pages/mkt-fcst/components/MktFcstGrid.tsx | 112 |
| code | const NOTATION_TRIM3 = new Intl.NumberFormat('en-US', { | features/demand/src/pages/mkt-fcst/components/MktFcstGrid.tsx | 113 |
| code | }); | features/demand/src/pages/mkt-fcst/components/MktFcstGrid.tsx | 116 |
| code | const NOTATION_INT = new Intl.NumberFormat('en-US', { maximumFractionDigits: 0 }); | features/demand/src/pages/mkt-fcst/components/MktFcstGrid.tsx | 117 |
| code | const formatQtyByNotation = (raw: unknown, notation: unknown): string => { | features/demand/src/pages/mkt-fcst/components/MktFcstGrid.tsx | 118 |
| code | if (raw == null \|\| raw === '') return ''; | features/demand/src/pages/mkt-fcst/components/MktFcstGrid.tsx | 119 |
| code | const n = toNumber(raw); | features/demand/src/pages/mkt-fcst/components/MktFcstGrid.tsx | 120 |
| code | const nt = toCellStr(notation).trim().toUpperCase(); | features/demand/src/pages/mkt-fcst/components/MktFcstGrid.tsx | 121 |
| code | if (nt === 'INTEGER') return NOTATION_INT.format(Math.round(n)); | features/demand/src/pages/mkt-fcst/components/MktFcstGrid.tsx | 122 |
| code | if (nt === 'POINT3') return n === 0 ? '0' : NOTATION_FIXED3.format(n); | features/demand/src/pages/mkt-fcst/components/MktFcstGrid.tsx | 123 |
| code | return NOTATION_TRIM3.format(n); | features/demand/src/pages/mkt-fcst/components/MktFcstGrid.tsx | 125 |
| code | }; | features/demand/src/pages/mkt-fcst/components/MktFcstGrid.tsx | 126 |
| code | e.cell.textContent = formatQtyByNotation(dynVal, rowItem?.NOTATION); | features/demand/src/pages/mkt-fcst/components/MktFcstGrid.tsx | 1053 |
| code | 비어 있을 수 있다(캐시 hit 이면 fetchRowParamCombo 가 즉시 return 하므로 무해). | features/demand/src/pages/mkt-fcst/components/MktFcstGrid.tsx | 1566 |
| code | g.hostElement.addEventListener('contextmenu', contextMenuHandler, { capture: true }); | features/demand/src/pages/mkt-fcst/components/MktFcstGrid.tsx | 1868 |
| code | applyStaticCascade 는 비-insert('I' 아님) 행에서 즉시 return 하므로 EditTracker 에 | features/demand/src/pages/mkt-fcst/components/MktFcstGrid.tsx | 1979 |
| code | g.hostElement?.removeEventListener('contextmenu', contextMenuHandler, { capture: true }); | features/demand/src/pages/mkt-fcst/components/MktFcstGrid.tsx | 2051 |
| endpoint | ⚠️ Phase 2 fallback 전용 — 정본은 admin SCM_MST_SHEET_COLUMNS 동적 fetch (fetchStaticColumns). | features/demand/src/pages/mkt-fcst/mkt-fcst.constants.ts | 96 |
| jsx | WijmoRowItem(값=WijmoPrimitive) 제약을 충족 → 공용 DataGrid 제네릭 <DataGrid<MktFcstRow>> | features/demand/src/pages/mkt-fcst/mkt-fcst.types.ts | 38 |
| endpoint | ⭐ mount 시 1회 admin 메타 fetch (#42/#65 동적 속성관리 baseline) | features/demand/src/pages/mkt-fcst/MktFcst.tsx | 322 |
| endpoint | queryKey(filters) 갱신 → enabled 와 함께 react-query 자동 fetch (최신 payload) | features/demand/src/pages/mkt-fcst/MktFcst.tsx | 487 |
| code | const p = dmTimeRow.CODE.split('^'); | features/demand/src/pages/mkt-fcst/MktFcst.tsx | 513 |
| code | ); | features/demand/src/pages/mkt-fcst/MktFcst.tsx | 517 |
| code | p.forEach((v, i) => { | features/demand/src/pages/mkt-fcst/MktFcst.tsx | 518 |
| code | msg = msg.replace(`{${i}}`, v); | features/demand/src/pages/mkt-fcst/MktFcst.tsx | 519 |
| code | }); | features/demand/src/pages/mkt-fcst/MktFcst.tsx | 520 |
| code | void setAlert({ type: 'alert', content: msg }); | features/demand/src/pages/mkt-fcst/MktFcst.tsx | 521 |
| code | 반환값 = 복원된 개인화(없으면 null). fetchStaticColumns 가 await 후 override 적용. | features/demand/src/pages/mkt-fcst/useMktFcstStore.ts | 110 |
| code | display 도 함께 맞춰 공통 DataGrid(.filter(c => c.display)) 경로와도 정합. | features/demand/src/pages/mkt-fcst/useMktFcstStore.ts | 215 |
| endpoint | ⭐ master hook §5 — Measure 동적 fetch (PIVOT 화면 의무) | features/demand/src/pages/mkt-fcst/useMktFcstStore.ts | 429 |
| code | 머지 범위를 가르는 키 컬럼 — 표시 순서에서 0번부터 클릭한 컬럼까지의 정적 컬럼. 근거: 아래 HierarchicalMergeManager 의 데이터 셀 머지는 계층형이다. 컬럼 c 의 머지 키가 fixedBindings.slice(0, idx + 1) 값 전부(sameRow)라, 어떤 컬럼의 셀이 위아래로 붙어 보이려면 그 왼쪽 컬럼이 전부 같아야 한다. 즉 컬럼 c 의 병합 범위 = 0..c 값이 모두 같은 연속 행이고 | features/demand/src/pages/mkt-fcst/utils/mkt-fcst.merge.ts | 76 |
| jsx | AS-IS: D_<YYYYMMDD> 컬럼 셀에만 색 적용 (.cs L1430). Division 40·82 만 (.cs L1415). | features/demand/src/pages/mkt-fcst/utils/mkt-fcst.sspSync.ts | 8 |
| code | if (!str(c.divisionId)) { void setAlert({ type: 'alert', content: t(MSG.REQUIRE_DIVISION, '_Division 을 선택하세요.'), }); return { ok: false, msgId: MSG.REQUIRE_DIVISION }; } | features/demand/src/pages/mkt-fcst/utils/mkt-fcst.validate.ts | 41 |

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

