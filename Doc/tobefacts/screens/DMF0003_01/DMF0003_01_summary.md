# DMF0003_01 — To-Be Fact Pack 요약

- page_key: `demand/mkt-fcst-01` · feature: demand · As-is Fact Pack 없음(화면ID 미대응)
- 파일 26 · 엔드포인트 호출 23 (미해결 2, 주석 속 4) · 이벤트 46 · 컴포넌트 사용 67 · 하드코딩 컬럼 27 · 메시지 81
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 사용 · 하드코딩 컬럼 정의 27건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/demand/src/pages/mkt-fcst-01/components/MktFcst01Form.module.scss | component | 60 |
| features/demand/src/pages/mkt-fcst-01/components/MktFcst01Form.tsx | component | 435 |
| features/demand/src/pages/mkt-fcst-01/components/MktFcst01Grid.tsx | component | 2285 |
| features/demand/src/pages/mkt-fcst-01/components/modals/index.ts | index | 8 |
| features/demand/src/pages/mkt-fcst-01/components/modals/mkt-fcst-01-modals.constants.ts | constants | 222 |
| features/demand/src/pages/mkt-fcst-01/components/modals/ModelPopupModal.tsx | component | 209 |
| features/demand/src/pages/mkt-fcst-01/components/modals/PrdnCtryModal.tsx | component | 218 |
| features/demand/src/pages/mkt-fcst-01/components/modals/SspSyncCompareModal.tsx | component | 123 |
| features/demand/src/pages/mkt-fcst-01/components/modals/SspSyncResultModal.tsx | component | 83 |
| features/demand/src/pages/mkt-fcst-01/index.ts | index | 2 |
| features/demand/src/pages/mkt-fcst-01/mkt-fcst-01.constants.ts | constants | 391 |
| features/demand/src/pages/mkt-fcst-01/mkt-fcst-01.types.ts | types | 72 |
| features/demand/src/pages/mkt-fcst-01/MktFcst01.module.scss | style | 116 |
| features/demand/src/pages/mkt-fcst-01/MktFcst01.tsx | page | 1223 |
| features/demand/src/pages/mkt-fcst-01/useMktFcst01Store.ts | store | 585 |
| features/demand/src/pages/mkt-fcst-01/utils/mkt-fcst-01.cell.ts | util | 24 |
| features/demand/src/pages/mkt-fcst-01/utils/mkt-fcst-01.comboDebug.ts | util | 261 |
| features/demand/src/pages/mkt-fcst-01/utils/mkt-fcst-01.division.ts | util | 160 |
| features/demand/src/pages/mkt-fcst-01/utils/mkt-fcst-01.editLock.ts | util | 297 |
| features/demand/src/pages/mkt-fcst-01/utils/mkt-fcst-01.gridCombos.ts | util | 597 |
| features/demand/src/pages/mkt-fcst-01/utils/mkt-fcst-01.merge.ts | util | 229 |
| features/demand/src/pages/mkt-fcst-01/utils/mkt-fcst-01.recalc.ts | util | 404 |
| features/demand/src/pages/mkt-fcst-01/utils/mkt-fcst-01.save.ts | util | 235 |
| features/demand/src/pages/mkt-fcst-01/utils/mkt-fcst-01.searchCombos.ts | util | 151 |
| features/demand/src/pages/mkt-fcst-01/utils/mkt-fcst-01.sspSync.ts | util | 46 |
| features/demand/src/pages/mkt-fcst-01/utils/mkt-fcst-01.validate.ts | util | 214 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueries) | hook | 9 | Y | MktFcst01Form.tsx:62 MktFcst01Form.tsx:99 MktFcst01Grid.tsx:291 MktFcst01Grid.tsx:476 MktFcst01Grid.tsx:528 MktFcst01Grid.tsx:661 |
| {?param} | http | 1 | N | MktFcst01Grid.tsx:597 |
| {?buildVmiLookupParam(editedRowRec,division)} | http | 1 | N | MktFcst01Grid.tsx:1639 |
| DMF0003_01/modelPopup//call-proc | hook | 1 | Y | ModelPopupModal.tsx:80 |
| DMF0003_01/prdnCtry//call-proc | hook | 1 | Y | PrdnCtryModal.tsx:52 |
| DMF0003_01/sspCompare//call-proc | hook | 1 | Y | SspSyncCompareModal.tsx:60 |
| DMF0003_01/dayRange//call-proc | hook | 1 | Y | MktFcst01.tsx:114 |
| DMF0003_01/Mkt Fcst//call-proc | hook | 1 | Y | MktFcst01.tsx:294 |
| DMF0003_01/spreadTitle//call-proc | hook | 1 | Y | MktFcst01.tsx:304 |
| /DMF0003_01/Mkt Fcst/SAVE/call-proc | http | 1 | Y | MktFcst01.tsx:789 |
| /admin/menu/DMF0003_01/column | http | 2 | Y | useMktFcst01Store.ts:349 useMktFcst01Store.ts:376 |
| DMF0003_01/titleSet/SEARCH/call-proc | http | 1 | Y | useMktFcst01Store.ts:401 |
| /admin/menu/DMF0003_01/measure | http | 1 | Y | useMktFcst01Store.ts:457 |
| /admin/menu/DMF0003_01/search-conditions | http | 1 | Y | useMktFcst01Store.ts:475 |

## 3. procedures.d.ts 등재 시트
| sheet | request_keys | response_cursors | sp_hints |
|---|---|---|---|
| Mkt Fcst | divisionId scmSiteId plantSiteId teamId customer bizType projectCode itemId fromYyyymmdd toYyyymmdd createdBy userGroup itemType owner qtyYn cellYn invalidExec asYn userDeptId senderCode sesUserId mnuId | o_rc1 o_rc2 o_rc3 |  |
| spreadTitle | startYyyymmdd endYyyymmdd createdBy divisionId userGroup type | o_rc1 |  |
| sspCompare | divisionId scmSiteId projectCode itemId domExp fcstType incoterms yyyymmdd | o_rc1 | DMF0003_GET_MKT_FCST_COMPARE_POPUP |
| dayRange | createdBy month | o_rc1 o_rc2 |  |
| prdnCtry | divisionId createdBy | o_rc1 | PKG_DMF0003_01 P_DMF0003_01_GET_PRDN_CTRY_POPUP |
| modelPopup | divisionId deptId endCustomer salesSite projectCode itemId activeFlag prdnCtry | o_rc1 | PKG_DMF0003_01 P_DMF0003_01_GET_MODEL_POPUP |

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| CustomDropdown | onChange | <arrow> onPick,String(picked??'').split(',').filter,String(picked??'').split,String | jsx | features/demand/src/pages/mkt-fcst-01/components/MktFcst01Form.tsx | 160 |
| SearchArea | onSearch | onSearch | jsx | features/demand/src/pages/mkt-fcst-01/components/MktFcst01Form.tsx | 202 |
| CustomDropdown | onChange | <arrow> confirmIfDirtyKey(tabDirtyKey(tabId),'search').then,confirmIfDirtyKey,tabDirtyKey,set,buildDivisionChangePatch,String | jsx | features/demand/src/pages/mkt-fcst-01/components/MktFcst01Form.tsx | 216 |
| PeriodField | onChange | <arrow> set | jsx | features/demand/src/pages/mkt-fcst-01/components/MktFcst01Form.tsx | 300 |
| CustomDropdown | onChange | <arrow> setAlert,t,setBucketKey,set | jsx | features/demand/src/pages/mkt-fcst-01/components/MktFcst01Form.tsx | 313 |
| ProjectField | onChange | <arrow> set | jsx | features/demand/src/pages/mkt-fcst-01/components/MktFcst01Form.tsx | 349 |
| ItemField | onChange | <arrow> set | jsx | features/demand/src/pages/mkt-fcst-01/components/MktFcst01Form.tsx | 361 |
| CustomDropdown | onChange | <arrow> set,String(options??'').split(',').filter,String(options??'').split,String | jsx | features/demand/src/pages/mkt-fcst-01/components/MktFcst01Form.tsx | 383 |
| OwnerField | onChange | <arrow> set | jsx | features/demand/src/pages/mkt-fcst-01/components/MktFcst01Form.tsx | 398 |
| Checkbox | onChange | <arrow> set | jsx | features/demand/src/pages/mkt-fcst-01/components/MktFcst01Form.tsx | 413 |
| Checkbox | onChange | <arrow> set | jsx | features/demand/src/pages/mkt-fcst-01/components/MktFcst01Form.tsx | 418 |
| Checkbox | onChange | <arrow> set | jsx | features/demand/src/pages/mkt-fcst-01/components/MktFcst01Form.tsx | 425 |
| g | formatItem | formatHandler | addHandler | features/demand/src/pages/mkt-fcst-01/components/MktFcst01Grid.tsx | 1220 |
| g | beginningEdit | beginningEditHandler | addHandler | features/demand/src/pages/mkt-fcst-01/components/MktFcst01Grid.tsx | 1482 |
| g | cellEditEnded | cellEditEndedHandler | addHandler | features/demand/src/pages/mkt-fcst-01/components/MktFcst01Grid.tsx | 1766 |
| g.hostElement | dblclick | dblclickHandler | addEventListener | features/demand/src/pages/mkt-fcst-01/components/MktFcst01Grid.tsx | 1846 |
| g | cellEditEnding | editChangeHandler | addHandler | features/demand/src/pages/mkt-fcst-01/components/MktFcst01Grid.tsx | 1857 |
| g.hostElement | keydown | blockQtyDotKey | addEventListener | features/demand/src/pages/mkt-fcst-01/components/MktFcst01Grid.tsx | 1866 |
| g | cellEditEnding | truncQtyOnCommit | addHandler | features/demand/src/pages/mkt-fcst-01/components/MktFcst01Grid.tsx | 1877 |
| g | pastingCell | pastingCellHandler | addHandler | features/demand/src/pages/mkt-fcst-01/components/MktFcst01Grid.tsx | 1994 |
| g | pastedCell | pastedCellHandler | addHandler | features/demand/src/pages/mkt-fcst-01/components/MktFcst01Grid.tsx | 1995 |
| g | scrollPositionChanged | handleScrollInvalidate | addHandler | features/demand/src/pages/mkt-fcst-01/components/MktFcst01Grid.tsx | 1999 |
| g | updatedLayout | applyHeaderHeight | addHandler | features/demand/src/pages/mkt-fcst-01/components/MktFcst01Grid.tsx | 2110 |
| g | updatedLayout | applyDynVisibility | addHandler | features/demand/src/pages/mkt-fcst-01/components/MktFcst01Grid.tsx | 2163 |
| f | filterApplied | onFilterApplied | addHandler | features/demand/src/pages/mkt-fcst-01/components/MktFcst01Grid.tsx | 2194 |
| g | updatedLayout | applyFooter | addHandler | features/demand/src/pages/mkt-fcst-01/components/MktFcst01Grid.tsx | 2243 |
| SearchArea | onSearch | handleSearch | jsx | features/demand/src/pages/mkt-fcst-01/components/modals/ModelPopupModal.tsx | 146 |
| InputField | onChange | <arrow> setItemId | jsx | features/demand/src/pages/mkt-fcst-01/components/modals/ModelPopupModal.tsx | 164 |
| InputField | onKeyDown | <arrow> handleSearch | jsx | features/demand/src/pages/mkt-fcst-01/components/modals/ModelPopupModal.tsx | 165 |
| Button | onClick | modalClose | jsx | features/demand/src/pages/mkt-fcst-01/components/modals/ModelPopupModal.tsx | 193 |
| Button | onClick | handleOk | jsx | features/demand/src/pages/mkt-fcst-01/components/modals/ModelPopupModal.tsx | 201 |
| g | updatedLayout | fillLast | addHandler | features/demand/src/pages/mkt-fcst-01/components/modals/PrdnCtryModal.tsx | 86 |
| document | click | capture | addEventListener | features/demand/src/pages/mkt-fcst-01/components/modals/PrdnCtryModal.tsx | 130 |
| document | click | adjust | addEventListener | features/demand/src/pages/mkt-fcst-01/components/modals/PrdnCtryModal.tsx | 131 |
| Button | onClick | modalClose | jsx | features/demand/src/pages/mkt-fcst-01/components/modals/PrdnCtryModal.tsx | 201 |
| Button | onClick | handleSkip | jsx | features/demand/src/pages/mkt-fcst-01/components/modals/PrdnCtryModal.tsx | 202 |
| Button | onClick | handleOk | jsx | features/demand/src/pages/mkt-fcst-01/components/modals/PrdnCtryModal.tsx | 210 |
| Button | onClick | modalClose | jsx | features/demand/src/pages/mkt-fcst-01/components/modals/SspSyncCompareModal.tsx | 115 |
| Button | onClick | modalClose | jsx | features/demand/src/pages/mkt-fcst-01/components/modals/SspSyncResultModal.tsx | 75 |
| MktFcst01Form | onSearch | handleSearch | jsx | features/demand/src/pages/mkt-fcst-01/MktFcst01.tsx | 895 |
| MktFcst01Grid | onPopupCellDblClick | <arrow> toCellStr,isEssItemPopupBlocked,cell,setAlert,t,setPopupGroupId | jsx | features/demand/src/pages/mkt-fcst-01/MktFcst01.tsx | 925 |
| MktFcst01Grid | onSspCompare | handleSspCompare | jsx | features/demand/src/pages/mkt-fcst-01/MktFcst01.tsx | 957 |
| ModelPopupModal | onSelect | <arrow> spRows.find,gridRef.current?.invalidate,setPopupGroupId | jsx | features/demand/src/pages/mkt-fcst-01/MktFcst01.tsx | 1039 |
| PrdnCtryModal | onConfirm | <arrow> Object.entries,editTrackerRef.current?.storeChange,editTrackerRef.current?.getOriginalValues().has,editTrackerRef.current?.getOriginalValues,gridRef.current?.invalidate | jsx | features/demand/src/pages/mkt-fcst-01/MktFcst01.tsx | 1081 |
| ColumnLayoutModal | onSave | <arrow> clearGridOnSettingChange,applyColumnLayout,settings.map,settings.filter,saveTitleSet({menuId:MENU_ID,//⚠️팝업조회(위sheetName/columnType)와반드시같은값이어야한다.sheetName:SHEETS.MAIN,columnType:'C',rows:visible.map((s,i)=>({name:s.COLUMN_NAME,sortOrderNo:i+1,colWidth:s.COL_WIDTH,cellColor:s.CELL_COLOR,textColor:s.TEXT_COLOR,})),}).then,saveTitleSet | jsx | features/demand/src/pages/mkt-fcst-01/MktFcst01.tsx | 1141 |
| MeasureSelectModal | onApply | <arrow> clearGridOnSettingChange,applyVisibleMeasures,staticMeasures[SHEETS.MAIN].map,saveTitleSet({menuId:MENU_ID,sheetName:SHEETS.MAIN,//Measure개인화—폭/색은대상이아니라미전달(빈값으로저장됨).columnType:'M',rows:selected.map((name,i)=>({name,sortOrderNo:i+1})),}).then,saveTitleSet,selected.map | jsx | features/demand/src/pages/mkt-fcst-01/MktFcst01.tsx | 1193 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Grid | 7 |
| Button | 7 |
| FormItem | 6 |
| DataGrid | 5 |
| CustomDropdown | 4 |
| CustomDialog | 4 |
| ResultArea | 4 |
| Checkbox | 3 |
| ProgressIndicator | 3 |
| SearchArea | 2 |
| InputField | 2 |
| ControlConfirmIcon | 2 |
| PeriodField | 1 |
| ProjectField | 1 |
| ItemField | 1 |
| OwnerField | 1 |
| Stack | 1 |
| IcGridColumnSetup | 1 |
| IcMeasureSelect | 1 |
| MainTitle | 1 |
| MktFcst01Form | 1 |
| SubTitle | 1 |
| MktFcst01Grid | 1 |
| ProjectByDivisionModal | 1 |
| ModelPopupModal | 1 |
| PrdnCtryModal | 1 |
| SspSyncCompareModal | 1 |
| SspSyncResultModal | 1 |
| ColumnLayoutModal | 1 |
| MeasureSelectModal | 1 |

## 6. 하드코딩 Grid 컬럼
| context | binding | header | width | visible | isReadOnly | dataType | via | file | line |
|---|---|---|---|---|---|---|---|---|---|
| mergedColumns | c.key | c.header | c.width ?? 100 | true |  |  | object | features/demand/src/pages/mkt-fcst-01/components/MktFcst01Grid.tsx | 347 |
| mergedColumns | col.colNm | prdnCtryHeader(col.colNm, col.colLblNm \|\| fb?.header \|\| col. | col.colWth ?? fb?.width ?? 100 | col.visible !== false |  |  | object | features/demand/src/pages/mkt-fcst-01/components/MktFcst01Grid.tsx | 366 |
| dynColMetas | r.COLUMN_NAME |  | spColumnWidth(r.COLUMN_WIDTH) |  |  |  | object | features/demand/src/pages/mkt-fcst-01/components/MktFcst01Grid.tsx | 787 |
| mainStaticColumns | c.binding | c.header | c.width | true |  |  | meta-map | features/demand/src/pages/mkt-fcst-01/components/MktFcst01Grid.tsx | 872 |
| mainDynamicColumns | m.binding | m.kind === 'D' ? m.leaf \|\| m.small \|\| 'SUM' : 'SUM' | m.width ?? DYN_COL_DEFAULT_WIDTH | DYN_RANK[m.kind] < DYN_RANK[bucketPrefix] ? sumYnRef.current |  |  | object | features/demand/src/pages/mkt-fcst-01/components/MktFcst01Grid.tsx | 957 |
| SSP_COMPARE_COLUMNS | PROJECT_CODE | End Customer | 110 | true |  |  | meta-shape | features/demand/src/pages/mkt-fcst-01/components/modals/mkt-fcst-01-modals.constants.ts | 14 |
| SSP_COMPARE_COLUMNS | SCM_SITE_ID | Sales Site | 150 | true |  |  | meta-shape | features/demand/src/pages/mkt-fcst-01/components/modals/mkt-fcst-01-modals.constants.ts | 23 |
| SSP_COMPARE_COLUMNS | ITEM_ID | Model | 140 | true |  |  | meta-shape | features/demand/src/pages/mkt-fcst-01/components/modals/mkt-fcst-01-modals.constants.ts | 32 |
| SSP_COMPARE_COLUMNS | INCOTERMS | Incoterms | 70 | true |  |  | meta-shape | features/demand/src/pages/mkt-fcst-01/components/modals/mkt-fcst-01-modals.constants.ts | 41 |
| SSP_COMPARE_COLUMNS | FCST_TYPE | Fcst Type | 70 | true |  |  | meta-shape | features/demand/src/pages/mkt-fcst-01/components/modals/mkt-fcst-01-modals.constants.ts | 50 |
| SSP_COMPARE_COLUMNS | DOM_EXP | Customs Handbook | 50 | false |  |  | meta-shape | features/demand/src/pages/mkt-fcst-01/components/modals/mkt-fcst-01-modals.constants.ts | 60 |
| SSP_COMPARE_COLUMNS | CATEGORY | Measure | 125 | true |  |  | meta-shape | features/demand/src/pages/mkt-fcst-01/components/modals/mkt-fcst-01-modals.constants.ts | 69 |
| SSP_COMPARE_COLUMNS | CONFIRM_ID | Confirm ID | 110 | true |  |  | meta-shape | features/demand/src/pages/mkt-fcst-01/components/modals/mkt-fcst-01-modals.constants.ts | 78 |
| SSP_COMPARE_COLUMNS | SO_NO | So No | 80 | true |  |  | meta-shape | features/demand/src/pages/mkt-fcst-01/components/modals/mkt-fcst-01-modals.constants.ts | 87 |
| SSP_COMPARE_COLUMNS | PLAN_QTY | Qty | 100 | true |  |  | meta-shape | features/demand/src/pages/mkt-fcst-01/components/modals/mkt-fcst-01-modals.constants.ts | 96 |
| SSP_COMPARE_COLUMNS | RESULT_QTY | Shipment Result Qty | 100 | true |  |  | meta-shape | features/demand/src/pages/mkt-fcst-01/components/modals/mkt-fcst-01-modals.constants.ts | 107 |
| SSP_SYNC_COLUMNS | MEASURE | MEASURE | 50 | false |  |  | meta-shape | features/demand/src/pages/mkt-fcst-01/components/modals/mkt-fcst-01-modals.constants.ts | 122 |
| SSP_SYNC_COLUMNS | PROJECT_CODE | End Customer | 100 | true |  |  | meta-shape | features/demand/src/pages/mkt-fcst-01/components/modals/mkt-fcst-01-modals.constants.ts | 131 |
| SSP_SYNC_COLUMNS | SCM_SITE_ID | Sales Site | 100 | true |  |  | meta-shape | features/demand/src/pages/mkt-fcst-01/components/modals/mkt-fcst-01-modals.constants.ts | 140 |
| SSP_SYNC_COLUMNS | ITEM_ID | Model | 140 | true |  |  | meta-shape | features/demand/src/pages/mkt-fcst-01/components/modals/mkt-fcst-01-modals.constants.ts | 149 |
| SSP_SYNC_COLUMNS | INCOTERMS | Incoterms | 70 | true |  |  | meta-shape | features/demand/src/pages/mkt-fcst-01/components/modals/mkt-fcst-01-modals.constants.ts | 158 |
| SSP_SYNC_COLUMNS | FCST_TYPE | Fcst Type | 70 | true |  |  | meta-shape | features/demand/src/pages/mkt-fcst-01/components/modals/mkt-fcst-01-modals.constants.ts | 167 |
| SSP_SYNC_COLUMNS | DOM_EXP | Customs Handbook | 70 | true |  |  | meta-shape | features/demand/src/pages/mkt-fcst-01/components/modals/mkt-fcst-01-modals.constants.ts | 176 |
| SSP_SYNC_COLUMNS | YYYYMMDD | YYYYMMDD | 90 | true |  |  | meta-shape | features/demand/src/pages/mkt-fcst-01/components/modals/mkt-fcst-01-modals.constants.ts | 185 |
| SSP_SYNC_COLUMNS | SYNC_QTY | Sync Qty | 70 | true |  |  | meta-shape | features/demand/src/pages/mkt-fcst-01/components/modals/mkt-fcst-01-modals.constants.ts | 194 |
| SSP_SYNC_COLUMNS | QTY | DP Qty | 70 | true |  |  | meta-shape | features/demand/src/pages/mkt-fcst-01/components/modals/mkt-fcst-01-modals.constants.ts | 205 |
| buildGroupKeyOf | column?.binding ?? '' |  |  | column?.visible !== false |  |  | object | features/demand/src/pages/mkt-fcst-01/MktFcst01.tsx | 576 |

## 7. 메시지 코드
| code | count |
|---|---|
| LBL00682 | 2 |
| LBL00683 | 2 |
| LBL00684 | 2 |
| LBL00112 | 1 |
| LBL00001 | 2 |
| LBL00044 | 2 |
| LBL00080 | 3 |
| LBL00011 | 4 |
| LBL00085 | 1 |
| LBL00090 | 1 |
| LBL00710 | 1 |
| LBL00005 | 2 |
| LBL00068 | 1 |
| LBL00687 | 1 |
| LBL00689 | 1 |
| LBL00690 | 1 |
| LBL00674 | 3 |
| LBL00343 | 1 |
| LBL00664 | 1 |
| LBL00012 | 1 |
| LBL00618 | 1 |
| LBL01278 | 3 |
| LBL00694 | 1 |
| LBL00695 | 1 |
| MSG00429 | 1 |
| MSG00113 | 1 |
| MSG00001 | 1 |
| MSG00043 | 1 |
| MSG00260 | 1 |
| MSG00097 | 1 |
| MSG00108 | 1 |
| MSG01505 | 1 |
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
| MSG01165 | 1 |
| MSG00618 | 3 |
| LBL00666 | 1 |
| MSG00606 | 1 |
| LBL00605 | 2 |
| LBL00310 | 3 |
| LBL00711 | 1 |
| LBL00764 | 1 |
| LBL00765 | 1 |
| LBL00748 | 1 |
| LBL00669 | 2 |
| LBL01141 | 1 |
| LBL00024 | 1 |
| MSG00004 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: DMF0003_01(25), DMF0003(23), DMF0020(20), DMF0021(8), DMF0082(7), COM0008(2), DMF0040(2), SYS0004(1), DMF0053(1), DMF0042(1), DMF0004(1)
- SP/PKG: DMF0003_GET_MKT_FCST_DATA(8), DMF0003_GET_SPREAD_TITLE(6), DMF0002_GET_TITLESET_POPUP(3), PKG_DMF0003_01(2), DMF0003_GET_MKT_FCST_COMPARE_POPUP(2), DMF0003_SAVE_MKT_FCST(2), PKG_DMF0003(2), PR_GET_SHEET_COLUMN_LIST(2), PR_DETAIL_COLUMNS(1), PR_HISTORY_COLUMNS(1), P_DMF0003_01_GET_MODEL_POPUP(1), P_DMF0003_01_GET_PRDN_CTRY_POPUP(1), DMF0003_GET_BUCKET_TYPE_CODE(1), PR_GET_SHEET_MEASURE_LIST(1), PR_GET_DAY_RANGE(1), P_USER_GROUP(1), P_TEAM_ID(1), SCM0002_SET_TITLESET_POPUP(1), P_CREATED_BY(1), P_BUCKET(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| code | 비어 있을 수 있다(캐시 hit 이면 fetchRowParamCombo 가 즉시 return 하므로 무해). | features/demand/src/pages/mkt-fcst-01/components/MktFcst01Grid.tsx | 1618 |
| code | applyStaticCascade 는 비-insert('I' 아님) 행에서 즉시 return 하므로 EditTracker 에 | features/demand/src/pages/mkt-fcst-01/components/MktFcst01Grid.tsx | 1958 |
| endpoint | ⚠️ Phase 2 fallback 전용 — 정본은 admin SCM_MST_SHEET_COLUMNS 동적 fetch (fetchStaticColumns). | features/demand/src/pages/mkt-fcst-01/mkt-fcst-01.constants.ts | 86 |
| endpoint | ⭐ mount 시 1회 admin 메타 fetch (#42/#65 동적 속성관리 baseline) | features/demand/src/pages/mkt-fcst-01/MktFcst01.tsx | 334 |
| endpoint | queryKey(filters) 갱신 → enabled 와 함께 react-query 자동 fetch (최신 payload) | features/demand/src/pages/mkt-fcst-01/MktFcst01.tsx | 499 |
| code | const p = dmTimeRow.CODE.split('^'); | features/demand/src/pages/mkt-fcst-01/MktFcst01.tsx | 525 |
| code | ); | features/demand/src/pages/mkt-fcst-01/MktFcst01.tsx | 529 |
| code | p.forEach((v, i) => { | features/demand/src/pages/mkt-fcst-01/MktFcst01.tsx | 530 |
| code | msg = msg.replace(`{${i}}`, v); | features/demand/src/pages/mkt-fcst-01/MktFcst01.tsx | 531 |
| code | }); | features/demand/src/pages/mkt-fcst-01/MktFcst01.tsx | 532 |
| code | void setAlert({ type: 'alert', content: msg }); | features/demand/src/pages/mkt-fcst-01/MktFcst01.tsx | 533 |
| code | 반환값 = 복원된 개인화(없으면 null). fetchStaticColumns 가 await 후 override 적용. | features/demand/src/pages/mkt-fcst-01/useMktFcst01Store.ts | 112 |
| code | display 도 함께 맞춰 공통 DataGrid(.filter(c => c.display)) 경로와도 정합. | features/demand/src/pages/mkt-fcst-01/useMktFcst01Store.ts | 217 |
| endpoint | ⭐ master hook §5 — Measure 동적 fetch (PIVOT 화면 의무) | features/demand/src/pages/mkt-fcst-01/useMktFcst01Store.ts | 451 |
| code | fields.push({ col: 'DOM_EXP', lblKey: 'LBL00091', fallback: 'Customs Handbook' }); | features/demand/src/pages/mkt-fcst-01/utils/mkt-fcst-01.division.ts | 153 |
| code | 머지 범위를 가르는 키 컬럼 — 표시 순서에서 0번부터 클릭한 컬럼까지의 정적 컬럼. 근거: 아래 HierarchicalMergeManager 의 데이터 셀 머지는 계층형이다. 컬럼 c 의 머지 키가 fixedBindings.slice(0, idx + 1) 값 전부(sameRow)라, 어떤 컬럼의 셀이 위아래로 붙어 보이려면 그 왼쪽 컬럼이 전부 같아야 한다. 즉 컬럼 c 의 병합 범위 = 0..c 값이 모두 같은 연속 행이고 | features/demand/src/pages/mkt-fcst-01/utils/mkt-fcst-01.merge.ts | 76 |
| jsx | AS-IS: D_<YYYYMMDD> 컬럼 셀에만 색 적용 (.cs L1430). Division 40·82 만 (.cs L1415). | features/demand/src/pages/mkt-fcst-01/utils/mkt-fcst-01.sspSync.ts | 8 |

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

