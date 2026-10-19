# SCP0009 — To-Be Fact Pack 요약

- page_key: `supply/shipment-plan-fg` · feature: supply · As-is Fact Pack 있음
- 파일 20 · 엔드포인트 호출 19 (미해결 1, 주석 속 0) · 이벤트 34 · 컴포넌트 사용 44 · 하드코딩 컬럼 11 · 메시지 47
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 11건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/supply/src/pages/shipment-plan-fg/components/modals/FixReasonModal.tsx | component | 79 |
| features/supply/src/pages/shipment-plan-fg/components/ShipmentPlanFgForm.tsx | component | 474 |
| features/supply/src/pages/shipment-plan-fg/components/ShipmentPlanFgGrid.tsx | component | 469 |
| features/supply/src/pages/shipment-plan-fg/index.ts | index | 2 |
| features/supply/src/pages/shipment-plan-fg/shipment-plan-fg.columns.ts | other | 77 |
| features/supply/src/pages/shipment-plan-fg/shipment-plan-fg.constants.ts | constants | 173 |
| features/supply/src/pages/shipment-plan-fg/shipment-plan-fg.types.ts | types | 51 |
| features/supply/src/pages/shipment-plan-fg/ShipmentPlanFg.tsx | page | 589 |
| features/supply/src/pages/shipment-plan-fg/useShipmentPlanFgStore.ts | store | 259 |
| features/supply/src/pages/shipment-plan-fg/utils/shipment-plan-fg.buildColumns.ts | util | 42 |
| features/supply/src/pages/shipment-plan-fg/utils/shipment-plan-fg.drilldown.test.ts | test | 56 |
| features/supply/src/pages/shipment-plan-fg/utils/shipment-plan-fg.drilldown.ts | util | 34 |
| features/supply/src/pages/shipment-plan-fg/utils/shipment-plan-fg.editLock.test.ts | test | 129 |
| features/supply/src/pages/shipment-plan-fg/utils/shipment-plan-fg.editLock.ts | util | 150 |
| features/supply/src/pages/shipment-plan-fg/utils/shipment-plan-fg.fix.test.ts | test | 158 |
| features/supply/src/pages/shipment-plan-fg/utils/shipment-plan-fg.fix.ts | util | 153 |
| features/supply/src/pages/shipment-plan-fg/utils/shipment-plan-fg.headerMerge.ts | util | 57 |
| features/supply/src/pages/shipment-plan-fg/utils/shipment-plan-fg.save.test.ts | test | 60 |
| features/supply/src/pages/shipment-plan-fg/utils/shipment-plan-fg.save.ts | util | 150 |
| features/supply/src/pages/shipment-plan-fg/__asis-mapping__.md | mapping | 474 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueries) | hook | 9 | Y | ShipmentPlanFgForm.tsx:60 ShipmentPlanFgForm.tsx:70 ShipmentPlanFgForm.tsx:79 ShipmentPlanFgForm.tsx:87 ShipmentPlanFgForm.tsx:101 ShipmentPlanFgForm.tsx:105 |
| SCP0009/main//call-proc | hook | 1 | Y | ShipmentPlanFg.tsx:88 |
| SCP0009/calendar//call-proc | hook | 1 | Y | ShipmentPlanFg.tsx:95 |
| /SCP0009/saveYn/SEARCH/call-proc | http | 1 | Y | ShipmentPlanFg.tsx:175 |
| /SCP0009/main/{action}/call-proc | http | 1 | N | ShipmentPlanFg.tsx:225 |
| /SCP0009/main/SAVE/call-proc | http | 1 | Y | ShipmentPlanFg.tsx:395 |
| /admin/menu/SCP0009/column | http | 1 | Y | useShipmentPlanFgStore.ts:183 |
| /admin/menu/SCP0009/measure | http | 1 | Y | useShipmentPlanFgStore.ts:205 |
| /admin/menu/SCP0009/search-conditions | http | 1 | Y | useShipmentPlanFgStore.ts:236 |
| /SCP0009/main/FIX/call-proc | propagated | 1 | Y | ShipmentPlanFg.tsx:299 |
| /SCP0009/main/UNFIX/call-proc | propagated | 1 | Y | ShipmentPlanFg.tsx:332 |

## 3. procedures.d.ts 등재 시트
(없음)

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| InputField | onChange | <arrow> setReason,e.target.value.replace(/\^/g,'').slice,e.target.value.replace | jsx | features/supply/src/pages/shipment-plan-fg/components/modals/FixReasonModal.tsx | 55 |
| Button | onClick | <arrow> onConfirm | jsx | features/supply/src/pages/shipment-plan-fg/components/modals/FixReasonModal.tsx | 64 |
| Button | onClick | onClose | jsx | features/supply/src/pages/shipment-plan-fg/components/modals/FixReasonModal.tsx | 71 |
| CustomDropdown | onChange | <arrow> onPick,String(picked??'').split(',').filter,String(picked??'').split,String,v.toUpperCase | jsx | features/supply/src/pages/shipment-plan-fg/components/ShipmentPlanFgForm.tsx | 261 |
| CustomDropdown | onChange | <arrow> onPick,String | jsx | features/supply/src/pages/shipment-plan-fg/components/ShipmentPlanFgForm.tsx | 290 |
| SearchArea | onSearch | onSearch | jsx | features/supply/src/pages/shipment-plan-fg/components/ShipmentPlanFgForm.tsx | 301 |
| CustomDropdown | onChange | <arrow> confirmIfDirtyKey(tabDirtyKey(tabId),'search').then,confirmIfDirtyKey,tabDirtyKey,set,String,clearFilters | jsx | features/supply/src/pages/shipment-plan-fg/components/ShipmentPlanFgForm.tsx | 318 |
| PeriodRangePicker | onChange | <arrow> set | jsx | features/supply/src/pages/shipment-plan-fg/components/ShipmentPlanFgForm.tsx | 370 |
| Checkbox | onChange | <arrow> set | jsx | features/supply/src/pages/shipment-plan-fg/components/ShipmentPlanFgForm.tsx | 391 |
| InputField | onChange | <arrow> set | jsx | features/supply/src/pages/shipment-plan-fg/components/ShipmentPlanFgForm.tsx | 436 |
| InputField | onKeyDown | <arrow> onSearch | jsx | features/supply/src/pages/shipment-plan-fg/components/ShipmentPlanFgForm.tsx | 437 |
| FunctionSearchIcon | onClick | onProjectSearch | jsx | features/supply/src/pages/shipment-plan-fg/components/ShipmentPlanFgForm.tsx | 432 |
| InputField | onChange | <arrow> set | jsx | features/supply/src/pages/shipment-plan-fg/components/ShipmentPlanFgForm.tsx | 463 |
| InputField | onKeyDown | <arrow> onSearch | jsx | features/supply/src/pages/shipment-plan-fg/components/ShipmentPlanFgForm.tsx | 464 |
| FunctionSearchIcon | onClick | onItemSearch | jsx | features/supply/src/pages/shipment-plan-fg/components/ShipmentPlanFgForm.tsx | 459 |
| g | beginningEdit | beginningEditHandler | addHandler | features/supply/src/pages/shipment-plan-fg/components/ShipmentPlanFgGrid.tsx | 260 |
| g | pastingCell | pastingCellHandler | addHandler | features/supply/src/pages/shipment-plan-fg/components/ShipmentPlanFgGrid.tsx | 270 |
| g | cellEditEnded | cellEditEndedHandler | addHandler | features/supply/src/pages/shipment-plan-fg/components/ShipmentPlanFgGrid.tsx | 291 |
| g | pastedCell | cellEditEndedHandler | addHandler | features/supply/src/pages/shipment-plan-fg/components/ShipmentPlanFgGrid.tsx | 292 |
| g | formatItem | formatItemHandler | addHandler | features/supply/src/pages/shipment-plan-fg/components/ShipmentPlanFgGrid.tsx | 327 |
| g | updatedLayout | applyDrill | addHandler | features/supply/src/pages/shipment-plan-fg/components/ShipmentPlanFgGrid.tsx | 376 |
| g.hostElement | dblclick | dblClickHandler | addEventListener | features/supply/src/pages/shipment-plan-fg/components/ShipmentPlanFgGrid.tsx | 392 |
| g | updatedLayout | applyHeaderHeight | addHandler | features/supply/src/pages/shipment-plan-fg/components/ShipmentPlanFgGrid.tsx | 446 |
| DataGrid | gotFocus | onFocus | jsx | features/supply/src/pages/shipment-plan-fg/components/ShipmentPlanFgGrid.tsx | 465 |
| ShipmentPlanFgForm | onSearch | handleSearch | jsx | features/supply/src/pages/shipment-plan-fg/ShipmentPlanFg.tsx | 464 |
| ShipmentPlanFgForm | onChangeBucketType | handleChangeBucketType | jsx | features/supply/src/pages/shipment-plan-fg/ShipmentPlanFg.tsx | 465 |
| ShipmentPlanFgForm | onItemSearch | <arrow> setOpenItem | jsx | features/supply/src/pages/shipment-plan-fg/ShipmentPlanFg.tsx | 466 |
| ShipmentPlanFgForm | onProjectSearch | <arrow> setOpenProject | jsx | features/supply/src/pages/shipment-plan-fg/ShipmentPlanFg.tsx | 467 |
| ShipmentPlanFgGrid | onFocus | <arrow>  | jsx | features/supply/src/pages/shipment-plan-fg/ShipmentPlanFg.tsx | 515 |
| FixReasonModal | onClose | <arrow> setOpenFixReason | jsx | features/supply/src/pages/shipment-plan-fg/ShipmentPlanFg.tsx | 536 |
| FixReasonModal | onConfirm | handleFixReasonConfirm | jsx | features/supply/src/pages/shipment-plan-fg/ShipmentPlanFg.tsx | 536 |
| NewPlanModal | onSaved | handleNewPlanSaved | jsx | features/supply/src/pages/shipment-plan-fg/ShipmentPlanFg.tsx | 542 |
| ColumnLayoutModal | onSave | handleSaveColumnLayout | jsx | features/supply/src/pages/shipment-plan-fg/ShipmentPlanFg.tsx | 554 |
| MeasureSelectModal | onApply | <arrow> applyVisibleMeasures,staticMeasures.map,saveTitleSet({menuId:MENU_ID,sheetName:MEASURE_SHEET_NAME,columnType:TITLESET_MEASURE_TYPE,rows:selected.map((name,i)=>({name,sortOrderNo:i+1})),}).then,saveTitleSet,selected.map,setToast | jsx | features/supply/src/pages/shipment-plan-fg/ShipmentPlanFg.tsx | 567 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Grid | 7 |
| FormItem | 6 |
| Button | 4 |
| InputField | 3 |
| CustomDropdown | 3 |
| FunctionSearchIcon | 2 |
| CustomDialog | 1 |
| Stack | 1 |
| SearchArea | 1 |
| PeriodRangePicker | 1 |
| Checkbox | 1 |
| Label | 1 |
| DataGrid | 1 |
| MainTitle | 1 |
| ShipmentPlanFgForm | 1 |
| SubTitle | 1 |
| IcGridColumnSetup | 1 |
| IcMeasureSelect | 1 |
| ShipmentPlanFgGrid | 1 |
| MaterialByDivisionModal | 1 |
| ProjectByDivisionModal | 1 |
| FixReasonModal | 1 |
| NewPlanModal | 1 |
| ColumnLayoutModal | 1 |
| MeasureSelectModal | 1 |

## 6. 하드코딩 Grid 컬럼
| context | binding | header | width | visible | isReadOnly | dataType | via | file | line |
|---|---|---|---|---|---|---|---|---|---|
| toLeafConfig | l.binding | l.header | 90 | l.visible |  |  | object | features/supply/src/pages/shipment-plan-fg/components/ShipmentPlanFgGrid.tsx | 166 |
| leaf | m.binding | m.kind === 'D' ? m.leaf : 'SUM' |  | isDynVisible(m.kind) |  |  | object | features/supply/src/pages/shipment-plan-fg/components/ShipmentPlanFgGrid.tsx | 190 |
| dynCols | c.binding ?? '' |  |  | c.visible |  |  | object | features/supply/src/pages/shipment-plan-fg/components/ShipmentPlanFgGrid.tsx | 388 |
| buildColumns | c.key | c.header | c.width ?? 100 | c.visible !== false |  |  | meta-map | features/supply/src/pages/shipment-plan-fg/utils/shipment-plan-fg.buildColumns.ts | 29 |
| col | DIVISION_ID:DIVISION_ID,END_CUSTOMER:END_CUSTOMER |  |  | visible |  |  | object | features/supply/src/pages/shipment-plan-fg/utils/shipment-plan-fg.drilldown.test.ts | 5 |
| columns | MEASURE |  |  | true |  |  | object | features/supply/src/pages/shipment-plan-fg/utils/shipment-plan-fg.fix.test.ts | 38 |
| columns | W_20260209 |  |  | true |  |  | object | features/supply/src/pages/shipment-plan-fg/utils/shipment-plan-fg.fix.test.ts | 39 |
| columns | D_20260209 |  |  | true |  |  | object | features/supply/src/pages/shipment-plan-fg/utils/shipment-plan-fg.fix.test.ts | 40 |
| columns | D_20260210 |  |  | true |  |  | object | features/supply/src/pages/shipment-plan-fg/utils/shipment-plan-fg.fix.test.ts | 41 |
| columns | W_20260216 |  |  | true |  |  | object | features/supply/src/pages/shipment-plan-fg/utils/shipment-plan-fg.fix.test.ts | 42 |
| columns | D_20260216 |  |  | false |  |  | object | features/supply/src/pages/shipment-plan-fg/utils/shipment-plan-fg.fix.test.ts | 43 |

## 7. 메시지 코드
| code | count |
|---|---|
| MSG00013 | 1 |
| MSG00096 | 1 |
| MSG01196 | 1 |
| MSG01153 | 1 |
| MSG01059 | 1 |
| MSG01078 | 1 |
| MSG01046 | 1 |
| MSG00683 | 1 |
| MSG01273 | 1 |
| MSG00002 | 1 |
| MSG00003 | 1 |
| MSG00225 | 1 |
| MSG00165 | 1 |
| MSG00720 | 1 |
| MSG00721 | 1 |
| MSG00004 | 1 |
| MSG01075 | 1 |
| MSG01104 | 1 |
| MSG01126 | 1 |
| MSG00001 | 1 |
| MSG00428 | 1 |
| MSG01271 | 1 |
| MSG00672 | 1 |
| LBL00112 | 1 |
| LBL00001 | 1 |
| LBL00027 | 1 |
| LBL00039 | 1 |
| LBL00040 | 1 |
| LBL00768 | 1 |
| LBL00013 | 1 |
| LBL00022 | 1 |
| LBL00023 | 1 |
| LBL00044 | 1 |
| LBL00038 | 1 |
| LBL00012 | 1 |
| LBL00618 | 1 |
| LBL00710 | 1 |
| LBL00632 | 1 |
| LBL00687 | 1 |
| LBL00309 | 1 |
| LBL00310 | 1 |
| LBL00771 | 1 |
| LBL00772 | 1 |
| LBL00627 | 1 |
| LBL00674 | 1 |
| LBL00716 | 1 |
| LBL00111 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: SCP0009(9), SCP0025(1), SCM0002(1)
- SP/PKG: PKG_SCP0009(6), P_SCP0009_SAVE_ANL_SHIP_PLAN_FG_WEEKLY(5), P_SCP0009_GET_SHEET_CALENDAR_3SPAN(4), P_SCP0009_GET_SHIPMENT_PLAN_FG(3), PKG_COM0000(3), PKG_SCP0013(2), P_SCP0013_GET_PLAN_SAVE_YN(2), P_SCP0009_SAVE_ANL_SHIP_FG_FIX_DATASET(2), P_ACTIVE_FLAG(2), P_FIX_REASON(1), P_SCP0009_GET_SHIP_PLAN_FG_TITLE_PARAL(1), P_SCP0013_SAVE_YN_GET(1), P_BUCKET(1), SCM0001_GET_SCP_DAILY_PLAN_PERIOD(1), P_CHK_ALL(1), P_SCP0009(1), P_SCP0009_FIX_SAVE(1), SCM0001_GET_SCP_DAY_PERIOD(1), P_SHEET_NAME(1), P_SCP0009_SAVE_ANL_SHIP_PLAN_FG_WEEKLY_JSON(1), P_SCP0009_SAVE_ANL_SHIP_FG_FIX_DATASET_JSON(1), P_ELECTRODE_TYPE(1), P_YYYYMMDD(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
(없음)

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

