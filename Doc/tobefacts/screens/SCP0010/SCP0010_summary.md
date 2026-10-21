# SCP0010 — To-Be Fact Pack 요약

- page_key: `supply/shipment-plan-semi` · feature: supply · As-is Fact Pack 없음(화면ID 미대응)
- 파일 16 · 엔드포인트 호출 15 (미해결 1, 주석 속 0) · 이벤트 22 · 컴포넌트 사용 31 · 하드코딩 컬럼 3 · 메시지 35
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 3건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/supply/src/pages/shipment-plan-semi/components/ShipmentPlanSemiForm.tsx | component | 408 |
| features/supply/src/pages/shipment-plan-semi/components/ShipmentPlanSemiGrid.tsx | component | 473 |
| features/supply/src/pages/shipment-plan-semi/hooks/useShipmentPlanSemiValidation.ts | hook | 36 |
| features/supply/src/pages/shipment-plan-semi/index.ts | index | 2 |
| features/supply/src/pages/shipment-plan-semi/shipment-plan-semi.columns.ts | other | 48 |
| features/supply/src/pages/shipment-plan-semi/shipment-plan-semi.constants.ts | constants | 131 |
| features/supply/src/pages/shipment-plan-semi/shipment-plan-semi.types.ts | types | 44 |
| features/supply/src/pages/shipment-plan-semi/ShipmentPlanSemi.tsx | page | 495 |
| features/supply/src/pages/shipment-plan-semi/useShipmentPlanSemiStore.test.tsx | test | 122 |
| features/supply/src/pages/shipment-plan-semi/useShipmentPlanSemiStore.ts | store | 265 |
| features/supply/src/pages/shipment-plan-semi/utils/shipment-plan-semi.buildColumns.ts | util | 42 |
| features/supply/src/pages/shipment-plan-semi/utils/shipment-plan-semi.deptDayDistribute.ts | util | 59 |
| features/supply/src/pages/shipment-plan-semi/utils/shipment-plan-semi.editLock.ts | util | 190 |
| features/supply/src/pages/shipment-plan-semi/utils/shipment-plan-semi.headerMerge.ts | util | 58 |
| features/supply/src/pages/shipment-plan-semi/utils/shipment-plan-semi.save.ts | util | 237 |
| features/supply/src/pages/shipment-plan-semi/__asis-mapping__.md | mapping | 520 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueries) | hook | 6 | Y | ShipmentPlanSemiForm.tsx:55 ShipmentPlanSemiForm.tsx:64 ShipmentPlanSemiForm.tsx:68 ShipmentPlanSemiForm.tsx:69 ShipmentPlanSemiForm.tsx:70 ShipmentPlanSemiForm.tsx:72 |
| SCP0010/main//call-proc | hook | 1 | Y | ShipmentPlanSemi.tsx:74 |
| SCP0010/calendar//call-proc | hook | 1 | Y | ShipmentPlanSemi.tsx:81 |
| /SCP0010/main/{action}/call-proc | http | 1 | N | ShipmentPlanSemi.tsx:176 |
| /SCP0010/main/SAVE/call-proc | http | 1 | Y | ShipmentPlanSemi.tsx:342 |
| /admin/menu/SCP0010/column | http | 1 | Y | useShipmentPlanSemiStore.ts:202 |
| /admin/menu/SCP0010/measure | http | 1 | Y | useShipmentPlanSemiStore.ts:222 |
| /admin/menu/SCP0010/search-conditions | http | 1 | Y | useShipmentPlanSemiStore.ts:242 |
| /SCP0010/main/FIX/call-proc | propagated | 1 | Y | ShipmentPlanSemi.tsx:224 |
| /SCP0010/main/UNFIX/call-proc | propagated | 1 | Y | ShipmentPlanSemi.tsx:248 |

## 3. procedures.d.ts 등재 시트
(없음)

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| CustomDropdown | onChange | <arrow> onPick,String(picked??'').split(',').filter,String(picked??'').split,String,v.toUpperCase | jsx | features/supply/src/pages/shipment-plan-semi/components/ShipmentPlanSemiForm.tsx | 231 |
| CustomDropdown | onChange | <arrow> onPick,String | jsx | features/supply/src/pages/shipment-plan-semi/components/ShipmentPlanSemiForm.tsx | 255 |
| SearchArea | onSearch | onSearch | jsx | features/supply/src/pages/shipment-plan-semi/components/ShipmentPlanSemiForm.tsx | 265 |
| CustomDropdown | onChange | <arrow> String,confirmIfDirtyKey(tabDirtyKey(tabId),'search').then,confirmIfDirtyKey,tabDirtyKey,setDivision | jsx | features/supply/src/pages/shipment-plan-semi/components/ShipmentPlanSemiForm.tsx | 286 |
| InputField | onChange | <arrow> set | jsx | features/supply/src/pages/shipment-plan-semi/components/ShipmentPlanSemiForm.tsx | 323 |
| InputField | onKeyDown | <arrow> onSearch | jsx | features/supply/src/pages/shipment-plan-semi/components/ShipmentPlanSemiForm.tsx | 324 |
| FunctionSearchIcon | onClick | onItemSearch | jsx | features/supply/src/pages/shipment-plan-semi/components/ShipmentPlanSemiForm.tsx | 319 |
| PlanVersionCascade | onChange | <arrow> set | jsx | features/supply/src/pages/shipment-plan-semi/components/ShipmentPlanSemiForm.tsx | 362 |
| PeriodRangePicker | onChange | <arrow> set | jsx | features/supply/src/pages/shipment-plan-semi/components/ShipmentPlanSemiForm.tsx | 378 |
| Checkbox | onChange | <arrow> set | jsx | features/supply/src/pages/shipment-plan-semi/components/ShipmentPlanSemiForm.tsx | 397 |
| g | beginningEdit | beginningEditHandler | addHandler | features/supply/src/pages/shipment-plan-semi/components/ShipmentPlanSemiGrid.tsx | 322 |
| g | cellEditEnded | cellEditEndedHandler | addHandler | features/supply/src/pages/shipment-plan-semi/components/ShipmentPlanSemiGrid.tsx | 358 |
| g | pastedCell | cellEditEndedHandler | addHandler | features/supply/src/pages/shipment-plan-semi/components/ShipmentPlanSemiGrid.tsx | 359 |
| g | formatItem | formatItemHandler | addHandler | features/supply/src/pages/shipment-plan-semi/components/ShipmentPlanSemiGrid.tsx | 410 |
| grid | updatedLayout | applyHeaderHeight | addHandler | features/supply/src/pages/shipment-plan-semi/components/ShipmentPlanSemiGrid.tsx | 454 |
| DataGrid | initialized | handleGridInitialized | jsx | features/supply/src/pages/shipment-plan-semi/components/ShipmentPlanSemiGrid.tsx | 467 |
| DataGrid | gotFocus | onFocus | jsx | features/supply/src/pages/shipment-plan-semi/components/ShipmentPlanSemiGrid.tsx | 468 |
| ShipmentPlanSemiForm | onSearch | handleSearch | jsx | features/supply/src/pages/shipment-plan-semi/ShipmentPlanSemi.tsx | 386 |
| ShipmentPlanSemiForm | onItemSearch | <arrow> setOpenItem | jsx | features/supply/src/pages/shipment-plan-semi/ShipmentPlanSemi.tsx | 386 |
| ShipmentPlanSemiGrid | onFocus | <arrow>  | jsx | features/supply/src/pages/shipment-plan-semi/ShipmentPlanSemi.tsx | 437 |
| MeasureSelectModal | onApply | <arrow> currentMeasures.map,saveTitleSet({menuId:MENU_ID,sheetName:MEASURE_SHEET_NAME[measureSheetGroup],columnType:TITLESET_MEASURE_TYPE,rows:selected.map((name,i)=>({name,sortOrderNo:i+1})),}).then,saveTitleSet,selected.map,setToast,t | jsx | features/supply/src/pages/shipment-plan-semi/ShipmentPlanSemi.tsx | 465 |
| NewPlanModal | onSaved | handleNewPlanSaved | jsx | features/supply/src/pages/shipment-plan-semi/ShipmentPlanSemi.tsx | 490 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Grid | 7 |
| FormItem | 5 |
| CustomDropdown | 3 |
| SearchArea | 1 |
| InputField | 1 |
| Button | 1 |
| FunctionSearchIcon | 1 |
| PlanVersionCascade | 1 |
| PeriodRangePicker | 1 |
| Checkbox | 1 |
| DataGrid | 1 |
| MainTitle | 1 |
| ShipmentPlanSemiForm | 1 |
| SubTitle | 1 |
| IcMeasureSelect | 1 |
| ShipmentPlanSemiGrid | 1 |
| MaterialByDivisionModal | 1 |
| MeasureSelectModal | 1 |
| NewPlanModal | 1 |

## 6. 하드코딩 Grid 컬럼
| context | binding | header | width | visible | isReadOnly | dataType | via | file | line |
|---|---|---|---|---|---|---|---|---|---|
| toLeafConfig | l.binding | l.header | 90 | l.visible |  |  | object | features/supply/src/pages/shipment-plan-semi/components/ShipmentPlanSemiGrid.tsx | 160 |
| leaf | m.binding | m.kind === 'D' ? m.leaf : 'SUM' |  | isDynVisible(m.kind) |  |  | object | features/supply/src/pages/shipment-plan-semi/components/ShipmentPlanSemiGrid.tsx | 181 |
| buildColumns | c.key | c.header | c.width ?? 100 | c.visible !== false |  |  | meta-map | features/supply/src/pages/shipment-plan-semi/utils/shipment-plan-semi.buildColumns.ts | 29 |

## 7. 메시지 코드
| code | count |
|---|---|
| MSG00002 | 4 |
| MSG00049 | 2 |
| MSG00108 | 2 |
| MSG01046 | 1 |
| MSG01196 | 1 |
| MSG01438 | 1 |
| MSG01273 | 1 |
| MSG00003 | 1 |
| MSG00225 | 1 |
| MSG00165 | 1 |
| MSG00004 | 1 |
| MSG01262 | 1 |
| LBL01028 | 1 |
| LBL00771 | 1 |
| LBL00772 | 1 |
| LBL00112 | 1 |
| LBL00001 | 1 |
| LBL00027 | 1 |
| LBL00039 | 1 |
| LBL00040 | 1 |
| LBL00768 | 1 |
| LBL00013 | 1 |
| LBL00022 | 1 |
| LBL00023 | 1 |
| LBL00038 | 1 |
| LBL00669 | 1 |
| LBL00618 | 1 |
| LBL00710 | 1 |
| LBL00687 | 1 |
| LBL00310 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: SCP0010(18), SCP0009(14), SCP0013(12), SCP0011(1)
- SP/PKG: PKG_SCP0010(11), P_SCP0010_SAVE_SEMI_DATASET(6), PKG_COM0000(3), P_SCP0009_GET_SHEET_CALENDAR_3SPAN(3), SCP0013_GET_PLAN_TYPE_SAVE_YN(3), P_DATA(3), P_SCP0010_GET_SHIP_PLAN_SEMI(2), P_USER_ID(2), P_BIZ_TYPE(2), SCM0001_GET_SCP_DAY_PERIOD(1), P_SCP0010_SAVE_SEMI_FIX_DS(1), P_SCP0010_SAVE_SEMI_WEEKLY(1), P_SHEET_NAME(1), P_LOAD_INPUT(1), P_SEMI_FIX_HIST_DS(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
(없음)

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

