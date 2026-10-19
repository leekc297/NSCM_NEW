# DMF0042 — To-Be Fact Pack 요약

- page_key: `demand/business-plan` · feature: demand · As-is Fact Pack 있음
- 파일 39 · 엔드포인트 호출 25 (미해결 1, 주석 속 2) · 이벤트 62 · 컴포넌트 사용 84 · 하드코딩 컬럼 8 · 메시지 61
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 사용 · 하드코딩 컬럼 정의 8건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/demand/src/pages/business-plan/business-plan.constants.ts | constants | 201 |
| features/demand/src/pages/business-plan/business-plan.types.ts | types | 63 |
| features/demand/src/pages/business-plan/BusinessPlan.module.scss | style | 167 |
| features/demand/src/pages/business-plan/BusinessPlan.tsx | page | 700 |
| features/demand/src/pages/business-plan/components/BusinessPlanForm.module.scss | component | 8 |
| features/demand/src/pages/business-plan/components/BusinessPlanForm.tsx | component | 430 |
| features/demand/src/pages/business-plan/components/BusinessPlanGrid.tsx | component | 1142 |
| features/demand/src/pages/business-plan/components/BusinessPlanModals.tsx | component | 308 |
| features/demand/src/pages/business-plan/components/modals/ExchangeRateModal.module.scss | component | 38 |
| features/demand/src/pages/business-plan/components/modals/ExchangeRateModal.tsx | component | 847 |
| features/demand/src/pages/business-plan/components/modals/exchangeRateModalStore.ts | store | 33 |
| features/demand/src/pages/business-plan/components/modals/index.ts | index | 4 |
| features/demand/src/pages/business-plan/components/modals/MeasureSelectModal.tsx | component | 268 |
| features/demand/src/pages/business-plan/components/modals/ReplaceByCutoffModal.tsx | component | 303 |
| features/demand/src/pages/business-plan/components/modals/replaceByCutoffModalStore.ts | store | 32 |
| features/demand/src/pages/business-plan/components/modals/VersionCutoffModal.tsx | component | 373 |
| features/demand/src/pages/business-plan/components/modals/versionCutoffModalStore.ts | store | 32 |
| features/demand/src/pages/business-plan/index.ts | index | 2 |
| features/demand/src/pages/business-plan/useBusinessPlanStore.test.tsx | test | 211 |
| features/demand/src/pages/business-plan/useBusinessPlanStore.ts | store | 490 |
| features/demand/src/pages/business-plan/utils/business-plan.api.test.ts | test | 84 |
| features/demand/src/pages/business-plan/utils/business-plan.api.ts | api | 269 |
| features/demand/src/pages/business-plan/utils/business-plan.division.test.ts | test | 119 |
| features/demand/src/pages/business-plan/utils/business-plan.division.ts | util | 170 |
| features/demand/src/pages/business-plan/utils/business-plan.editLock.test.ts | test | 65 |
| features/demand/src/pages/business-plan/utils/business-plan.editLock.ts | util | 291 |
| features/demand/src/pages/business-plan/utils/business-plan.exchangePeriod.ts | util | 31 |
| features/demand/src/pages/business-plan/utils/business-plan.gridCombos.ts | util | 52 |
| features/demand/src/pages/business-plan/utils/business-plan.insertAnchor.test.ts | test | 69 |
| features/demand/src/pages/business-plan/utils/business-plan.insertAnchor.ts | util | 69 |
| features/demand/src/pages/business-plan/utils/business-plan.merge.test.ts | test | 59 |
| features/demand/src/pages/business-plan/utils/business-plan.merge.ts | util | 132 |
| features/demand/src/pages/business-plan/utils/business-plan.save.test.ts | test | 197 |
| features/demand/src/pages/business-plan/utils/business-plan.save.ts | util | 225 |
| features/demand/src/pages/business-plan/utils/business-plan.searchCombos.ts | util | 103 |
| features/demand/src/pages/business-plan/utils/business-plan.spread.test.ts | test | 101 |
| features/demand/src/pages/business-plan/utils/business-plan.spread.ts | util | 180 |
| features/demand/src/pages/business-plan/utils/business-plan.validate.ts | util | 125 |
| features/demand/src/pages/business-plan/__asis-mapping__.md | mapping | 139 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| DMF0042/dayRange//call-proc | hook | 1 | Y | BusinessPlan.tsx:82 |
| DMF0042/Biz Plan//call-proc | hook | 1 | Y | BusinessPlan.tsx:102 |
| DMF0042/spreadTitle//call-proc | hook | 1 | Y | BusinessPlan.tsx:111 |
| (useTabComboQueries) | hook | 10 | Y | BusinessPlan.tsx:141 BusinessPlan.tsx:144 BusinessPlanForm.tsx:97 BusinessPlanForm.tsx:107 BusinessPlanForm.tsx:124 BusinessPlanGrid.tsx:182 |
| DMF0042/futurePriceData//call-proc | hook | 1 | Y | ExchangeRateModal.tsx:169 |
| DMF0042/mdfVersion//call-proc | hook | 2 | Y | ReplaceByCutoffModal.tsx:102 VersionCutoffModal.tsx:128 |
| /admin/menu/DMF0042/search-conditions | http | 1 | Y | useBusinessPlanStore.ts:283 |
| /admin/menu/DMF0042/column | http | 1 | Y | useBusinessPlanStore.ts:359 |
| /admin/menu/DMF0042/measure | http | 1 | Y | useBusinessPlanStore.ts:433 |
| /DMF0042/{sheet}/{btnCd}/call-proc | http | 1 | N | business-plan.api.ts:73 |
| DMF0042/Biz Plan/SAVE/call-proc | callProc | 1 | Y | business-plan.api.ts:102 |
| DMF0042/Biz Plan/REPLACE/call-proc | callProc | 1 | Y | business-plan.api.ts:259 |
| DMF0042/exchangeRate/SAVE/call-proc | callProc | 1 | Y | business-plan.api.ts:268 |
| /DMF0042/Biz Plan/SET_PRICE/call-proc | propagated | 1 | Y | business-plan.api.ts:189 |
| /DMF0042/Biz Plan/CUTOFF/call-proc | propagated | 1 | Y | business-plan.api.ts:233 |

## 3. procedures.d.ts 등재 시트
| sheet | request_keys | response_cursors | sp_hints |
|---|---|---|---|
| Biz Plan | divisionId deptId endCustomer scmSiteId projectCode itemId itemType fromYyyymmdd nowYyyymmdd toYyyymmdd plantSiteId bizType userGroup owner qtyYn | data calendar |  |
| spreadTitle | startYyyymmdd endYyyymmdd divisionId userId mnuId | data |  |
| dayRange | createdBy month | o_rc1 o_rc2 |  |
| titleSet | programId sheetName columnType divisionId | o_rc1 |  |
| futurePriceData | divisionId fromYyyymmdd toYyyymmdd cate userId mnuId | data |  |
| cutoffVersion | divisionId yyyymmFrom yyyymmTo versionType userId mnuId | data |  |
| mdfVersion | divisionId versionDescription versionType fromYyyymmdd toYyyymmdd userId mnuId | data |  |

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| BusinessPlanForm | onSearch | handleSearch | jsx | features/demand/src/pages/business-plan/BusinessPlan.tsx | 621 |
| BusinessPlanForm | onDivisionChange | handleDivisionChange | jsx | features/demand/src/pages/business-plan/BusinessPlan.tsx | 622 |
| BusinessPlanGrid | onPopupCellDblClick | handlePopupCellDblClick | jsx | features/demand/src/pages/business-plan/BusinessPlan.tsx | 652 |
| BusinessPlanModals | onClose | <arrow> setPopupRow,closers[key] | jsx | features/demand/src/pages/business-plan/BusinessPlan.tsx | 668 |
| BusinessPlanModals | onRefetch | <arrow> refetch,Promise.resolve | jsx | features/demand/src/pages/business-plan/BusinessPlan.tsx | 681 |
| BusinessPlanModals | onSettingChanged | clearGridOnSettingChange | jsx | features/demand/src/pages/business-plan/BusinessPlan.tsx | 695 |
| CustomDropdown | onChange | <arrow> onPick,String(picked??'').split(',').filter,String(picked??'').split,String | jsx | features/demand/src/pages/business-plan/components/BusinessPlanForm.tsx | 165 |
| SearchArea | onSearch | onSearch | jsx | features/demand/src/pages/business-plan/components/BusinessPlanForm.tsx | 203 |
| CustomDropdown | onChange | <arrow> confirmIfDirtyKey(tabDirtyKey(tabId),'search').then,confirmIfDirtyKey,tabDirtyKey,set,String,onDivisionChange | jsx | features/demand/src/pages/business-plan/components/BusinessPlanForm.tsx | 220 |
| BizTypeField | onChange | <arrow> set | jsx | features/demand/src/pages/business-plan/components/BusinessPlanForm.tsx | 308 |
| PeriodField | onChange | <arrow> set | jsx | features/demand/src/pages/business-plan/components/BusinessPlanForm.tsx | 318 |
| CustomDropdown | onChange | <arrow> validation.validateBucketChange,hasPendingChanges,set | jsx | features/demand/src/pages/business-plan/components/BusinessPlanForm.tsx | 330 |
| ProjectField | onChange | <arrow> set | jsx | features/demand/src/pages/business-plan/components/BusinessPlanForm.tsx | 348 |
| ItemField | onChange | <arrow> set | jsx | features/demand/src/pages/business-plan/components/BusinessPlanForm.tsx | 360 |
| OwnerField | onChange | <arrow> set | jsx | features/demand/src/pages/business-plan/components/BusinessPlanForm.tsx | 372 |
| Checkbox | onChange | <arrow> set | jsx | features/demand/src/pages/business-plan/components/BusinessPlanForm.tsx | 410 |
| Checkbox | onChange | <arrow> set | jsx | features/demand/src/pages/business-plan/components/BusinessPlanForm.tsx | 418 |
| g | formatItem | formatHandler | addHandler | features/demand/src/pages/business-plan/components/BusinessPlanGrid.tsx | 574 |
| g | beginningEdit | beginningEditHandler | addHandler | features/demand/src/pages/business-plan/components/BusinessPlanGrid.tsx | 635 |
| g | pastingCell | beginningEditHandler | addHandler | features/demand/src/pages/business-plan/components/BusinessPlanGrid.tsx | 637 |
| g | cellEditEnded | cellEditEndedHandler | addHandler | features/demand/src/pages/business-plan/components/BusinessPlanGrid.tsx | 750 |
| g | pastedCell | pastedCellHandler | addHandler | features/demand/src/pages/business-plan/components/BusinessPlanGrid.tsx | 760 |
| g | selectionChanged | selectionChangedHandler | addHandler | features/demand/src/pages/business-plan/components/BusinessPlanGrid.tsx | 787 |
| g.hostElement | click | clickAsDblHandler | addEventListener | features/demand/src/pages/business-plan/components/BusinessPlanGrid.tsx | 890 |
| g | scrollPositionChanged | handleScrollInvalidate | addHandler | features/demand/src/pages/business-plan/components/BusinessPlanGrid.tsx | 894 |
| g | updatedLayout | applyHeaderHeight | addHandler | features/demand/src/pages/business-plan/components/BusinessPlanGrid.tsx | 997 |
| g | updatedLayout | applyDynVisibility | addHandler | features/demand/src/pages/business-plan/components/BusinessPlanGrid.tsx | 1047 |
| f | filterApplied | onFilterApplied | addHandler | features/demand/src/pages/business-plan/components/BusinessPlanGrid.tsx | 1110 |
| ColumnLayoutModal | onSave | <arrow> onSettingChanged,applyColumnLayout,settings.map,settings.filter,saveTitleSet({menuId:MENU_ID,sheetName:SHEETS.MAIN,columnType:TITLESET_COLUMN_TYPE,rows:visible.map((s,i)=>({name:s.COLUMN_NAME,sortOrderNo:i+1,colWidth:s.COL_WIDTH,cellColor:s.CELL_COLOR,textColor:s.TEXT_COLOR,})),}).then,saveTitleSet | jsx | features/demand/src/pages/business-plan/components/BusinessPlanModals.tsx | 206 |
| MeasureSelectModal | onApply | <arrow> applyVisibleMeasures,staticMeasures.map,saveTitleSet({menuId:MENU_ID,sheetName:SHEETS.MAIN,//Measure개인화—폭/색은대상이아니라미전달(빈값으로저장됨).columnType:TITLESET_MEASURE_TYPE,rows:selected.map((name,i)=>({name,sortOrderNo:i+1})),}).then,saveTitleSet,selected.map,alertSaveFailed | jsx | features/demand/src/pages/business-plan/components/BusinessPlanModals.tsx | 253 |
| g | formatItem | formatHandler | addHandler | features/demand/src/pages/business-plan/components/modals/ExchangeRateModal.tsx | 400 |
| g | cellEditEnded | cellEditEndedHandler | addHandler | features/demand/src/pages/business-plan/components/modals/ExchangeRateModal.tsx | 441 |
| g | pastedCell | pastedHandler | addHandler | features/demand/src/pages/business-plan/components/modals/ExchangeRateModal.tsx | 445 |
| g | updatedLayout | normalizeHeader | addHandler | features/demand/src/pages/business-plan/components/modals/ExchangeRateModal.tsx | 563 |
| SearchArea | onSearch | handleFind | jsx | features/demand/src/pages/business-plan/components/modals/ExchangeRateModal.tsx | 743 |
| CustomDropdown | onChange | <arrow> setApplied,String | jsx | features/demand/src/pages/business-plan/components/modals/ExchangeRateModal.tsx | 758 |
| PeriodField | onChange | <arrow> setApplied,toYm | jsx | features/demand/src/pages/business-plan/components/modals/ExchangeRateModal.tsx | 771 |
| Button | onClick | handleInsert | jsx | features/demand/src/pages/business-plan/components/modals/ExchangeRateModal.tsx | 813 |
| Button | onClick | handleDelete | jsx | features/demand/src/pages/business-plan/components/modals/ExchangeRateModal.tsx | 822 |
| Button | onClick | <arrow> handleSave | jsx | features/demand/src/pages/business-plan/components/modals/ExchangeRateModal.tsx | 831 |
| Button | onClick | <arrow> modalClose | jsx | features/demand/src/pages/business-plan/components/modals/ExchangeRateModal.tsx | 839 |
| ColumnSelectDualList | onToggleLeft | toggleLeft | jsx | features/demand/src/pages/business-plan/components/modals/MeasureSelectModal.tsx | 229 |
| ColumnSelectDualList | onToggleRight | toggleRight | jsx | features/demand/src/pages/business-plan/components/modals/MeasureSelectModal.tsx | 230 |
| ColumnSelectDualList | onToggleAllLeft | toggleAllLeft | jsx | features/demand/src/pages/business-plan/components/modals/MeasureSelectModal.tsx | 231 |
| ColumnSelectDualList | onToggleAllRight | toggleAllRight | jsx | features/demand/src/pages/business-plan/components/modals/MeasureSelectModal.tsx | 232 |
| ColumnSelectDualList | onMoveRight | moveToUser | jsx | features/demand/src/pages/business-plan/components/modals/MeasureSelectModal.tsx | 233 |
| ColumnSelectDualList | onMoveLeft | moveToBase | jsx | features/demand/src/pages/business-plan/components/modals/MeasureSelectModal.tsx | 234 |
| ColumnSelectDualList | onReorderRight | reorderRight | jsx | features/demand/src/pages/business-plan/components/modals/MeasureSelectModal.tsx | 235 |
| Button | onClick | handleDefault | jsx | features/demand/src/pages/business-plan/components/modals/MeasureSelectModal.tsx | 244 |
| Button | onClick | handleOk | jsx | features/demand/src/pages/business-plan/components/modals/MeasureSelectModal.tsx | 253 |
| Button | onClick | modalClose | jsx | features/demand/src/pages/business-plan/components/modals/MeasureSelectModal.tsx | 260 |
| g | formatItem | formatHandler | addHandler | features/demand/src/pages/business-plan/components/modals/ReplaceByCutoffModal.tsx | 142 |
| SearchArea | onSearch | <arrow> refetch | jsx | features/demand/src/pages/business-plan/components/modals/ReplaceByCutoffModal.tsx | 233 |
| PeriodField | onChange | <arrow> setRange,toYm | jsx | features/demand/src/pages/business-plan/components/modals/ReplaceByCutoffModal.tsx | 247 |
| Button | onClick | <arrow> handleReplace | jsx | features/demand/src/pages/business-plan/components/modals/ReplaceByCutoffModal.tsx | 288 |
| Button | onClick | <arrow> modalClose | jsx | features/demand/src/pages/business-plan/components/modals/ReplaceByCutoffModal.tsx | 295 |
| g | formatItem | formatHandler | addHandler | features/demand/src/pages/business-plan/components/modals/VersionCutoffModal.tsx | 168 |
| SearchArea | onSearch | <arrow> description.trim,refetch,setAppliedDescription | jsx | features/demand/src/pages/business-plan/components/modals/VersionCutoffModal.tsx | 255 |
| InputField | onChange | <arrow> setDescription | jsx | features/demand/src/pages/business-plan/components/modals/VersionCutoffModal.tsx | 300 |
| PeriodField | onChange | <arrow> setPeriod | jsx | features/demand/src/pages/business-plan/components/modals/VersionCutoffModal.tsx | 316 |
| Button | onClick | <arrow> handleCutoff | jsx | features/demand/src/pages/business-plan/components/modals/VersionCutoffModal.tsx | 358 |
| Button | onClick | modalClose | jsx | features/demand/src/pages/business-plan/components/modals/VersionCutoffModal.tsx | 365 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Button | 11 |
| Grid | 9 |
| FormItem | 9 |
| ProgressIndicator | 5 |
| CustomDropdown | 4 |
| SearchArea | 4 |
| PeriodField | 4 |
| DataGrid | 4 |
| CustomDialog | 4 |
| InputField | 4 |
| ResultArea | 3 |
| Checkbox | 2 |
| ControlConfirmIcon | 2 |
| IcGridColumnSetup | 1 |
| MainTitle | 1 |
| BusinessPlanForm | 1 |
| SubTitle | 1 |
| BusinessPlanGrid | 1 |
| BusinessPlanModals | 1 |
| BizTypeField | 1 |
| ProjectField | 1 |
| ItemField | 1 |
| OwnerField | 1 |
| Stack | 1 |
| ProjectByDivisionModal | 1 |
| ItemByDivisionModal | 1 |
| ColumnLayoutModal | 1 |
| MeasureSelectModal | 1 |
| ExchangeRateModal | 1 |
| VersionCutoffModal | 1 |
| ReplaceByCutoffModal | 1 |
| ColumnSelectDualList | 1 |

## 6. 하드코딩 Grid 컬럼
| context | binding | header | width | visible | isReadOnly | dataType | via | file | line |
|---|---|---|---|---|---|---|---|---|---|
| buildGroupKeyOf | column?.binding ?? '' |  |  | column?.visible !== false |  |  | object | features/demand/src/pages/business-plan/BusinessPlan.tsx | 170 |
| mainDynamicColumns | m.binding | tag.kind === 'M' ? m.leaf \|\| String(tag.month).padStart(2, ' | 90 | true |  |  | object | features/demand/src/pages/business-plan/components/BusinessPlanGrid.tsx | 376 |
| gridStaticColumns | c.key | c.header | c.width | true |  |  | meta-map | features/demand/src/pages/business-plan/components/modals/ExchangeRateModal.tsx | 303 |
| gridDynamicColumns | `M_${ym}` | ym.slice(4, 6) | 90 | true |  |  | object | features/demand/src/pages/business-plan/components/modals/ExchangeRateModal.tsx | 346 |
| sourceRows | m.colNm | m.colLblNm \|\| m.colNm |  | Y\|N |  |  | meta-map | features/demand/src/pages/business-plan/components/modals/MeasureSelectModal.tsx | 59 |
| gridStaticColumns | c.key | c.header | c.width | true |  |  | meta-map | features/demand/src/pages/business-plan/components/modals/ReplaceByCutoffModal.tsx | 118 |
| gridStaticColumns | c.key | c.header | c.width | true |  |  | meta-map | features/demand/src/pages/business-plan/components/modals/VersionCutoffModal.tsx | 144 |
| col | DIVISION_ID:DIVISION_ID,END_CUSTOMER:END_CUSTOMER |  |  | visible |  |  | object | features/demand/src/pages/business-plan/utils/business-plan.insertAnchor.test.ts | 11 |

## 7. 메시지 코드
| code | count |
|---|---|
| MSG00097 | 1 |
| MSG00108 | 1 |
| MSG00677 | 1 |
| MSG00429 | 1 |
| MSG00113 | 1 |
| MSG00227 | 1 |
| MSG00043 | 2 |
| MSG00002 | 1 |
| MSG00004 | 1 |
| MSG00676 | 1 |
| MSG00679 | 1 |
| MSG00678 | 1 |
| MSG00033 | 1 |
| MSG00675 | 1 |
| MSG00680 | 1 |
| MSG00618 | 2 |
| LBL00661 | 4 |
| LBL00605 | 2 |
| LBL00684 | 1 |
| LBL00112 | 1 |
| LBL00001 | 4 |
| LBL00044 | 1 |
| LBL00080 | 3 |
| LBL00011 | 3 |
| LBL00005 | 2 |
| LBL00710 | 1 |
| LBL00068 | 1 |
| LBL00687 | 1 |
| LBL00711 | 1 |
| LBL00764 | 2 |
| LBL00765 | 2 |
| LBL00664 | 3 |
| LBL00713 | 3 |
| LBL00310 | 2 |
| LBL00052 | 1 |
| LBL00608 | 1 |
| LBL00669 | 2 |
| LBL00024 | 2 |

## 8. 주석 속 As-is 참조
- 화면ID: DMF0042(20), DMF0021(9), DMF0082(6), DMF0003(4), DMF0020(2), DM0020(1), SYS0004(1)
- SP/PKG: PR_GET_DAY_RANGE(6), DMF0042_GET_SPREAD_TITLE(6), P_DMF0042_SAVE_DM_PLN_BP_FCST(6), DMF0042_GET_DM_PLN_BUSINESS_PLAN_DATA(5), DMF0042_GET_DM_MDF_VERSION(5), P_QTY_YN(3), PKG_DMF0042(3), P_USERINFO(3), DMF0042_SAVE_DM_BP_EXCHANGE_RATE(3), P_CATE(2), DMF0042_SAVE_DM_PLN_BP_REPLACE_BY_CUTOFF(2), P_CREATED_BY(2), P_DMF0042_SAVE_DM_PLN_BP_FCST_PRICE_CONV(2), P_UNIT_ENERGY(2), DMF0042_GET_SCM_MST_FUTURE_PRICE_POPUP_DATA(1), P_DMF0042_SAVE_DM_BP_EXCHANGE_RATE(1), DMF0042_SAVE_DM_PLN_BP_FCST_CUTOFF(1), DMF0042_GET_DM_PLN_BP_CUTOFF_VERSION(1), P_FROM(1), P_BUCKET(1), P_NOW_YYYYMMDD(1), DMF0002_GET_TITLESET_POPUP(1), P_DMF0042_SAVE_DM_PLN_BP_FCST_CUTOFF(1), PR_DM_PLN_VERSION_CREATE(1), DMF0020_GET_EXCHANGE_POPUP_SPREAD_TITLE(1), P_LAST_UPDATED_BY(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| code | action: () => setOpenMeasureSelect(true), | features/demand/src/pages/business-plan/BusinessPlan.tsx | 574 |
| jsx | iconComponent: <IcMeasureSelect />, | features/demand/src/pages/business-plan/BusinessPlan.tsx | 575 |
| code | ⭐ 개인화 색 (ColumnLayoutModal 저장값) — 정적 컬럼만 (동적 기간 컬럼은 위에서 return). | features/demand/src/pages/business-plan/components/BusinessPlanGrid.tsx | 555 |
| code | `let s = getMergedRange(cells, C, d, false); | features/demand/src/pages/business-plan/components/BusinessPlanGrid.tsx | 764 |
| code | 예전처럼 `if (!g) return;` 으로 포기하면 deps(displayRows)가 다시 바뀌지 않는 한 핸들러가 | features/demand/src/pages/business-plan/components/modals/ExchangeRateModal.tsx | 373 |
| code | 저장된 컬럼 개인화(titleSet) 복원 — fetchStaticColumns 가 await 후 메타에 적용. | features/demand/src/pages/business-plan/useBusinessPlanStore.ts | 93 |
| endpoint | ⭐ master hook §2.3 — Column 동적 fetch (SHEET_COLUMNS 63건, division 서버 직접 비교 — hook #113). | features/demand/src/pages/business-plan/useBusinessPlanStore.ts | 351 |
| endpoint | ⭐ master hook §5 — Measure 동적 fetch (SHEET_MEASURE 9건 — Measure Select 팝업 대상) | features/demand/src/pages/business-plan/useBusinessPlanStore.ts | 430 |

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

