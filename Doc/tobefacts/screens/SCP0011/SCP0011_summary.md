# SCP0011 — To-Be Fact Pack 요약

- page_key: `supply/production-plan` · feature: supply · As-is Fact Pack 없음(화면ID 미대응)
- 파일 14 · 엔드포인트 호출 9 (미해결 0, 주석 속 2) · 이벤트 26 · 컴포넌트 사용 33 · 하드코딩 컬럼 2 · 메시지 26
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 2건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/supply/src/pages/production-plan/components/ProductionPlanForm.tsx | component | 404 |
| features/supply/src/pages/production-plan/components/ProductionPlanGrid.tsx | component | 411 |
| features/supply/src/pages/production-plan/index.ts | index | 2 |
| features/supply/src/pages/production-plan/production-plan.constants.ts | constants | 215 |
| features/supply/src/pages/production-plan/production-plan.types.ts | types | 36 |
| features/supply/src/pages/production-plan/ProductionPlan.module.scss | style | 46 |
| features/supply/src/pages/production-plan/ProductionPlan.tsx | page | 483 |
| features/supply/src/pages/production-plan/useProductionPlanStore.ts | store | 308 |
| features/supply/src/pages/production-plan/utils/productionPlanColumns.ts | util | 130 |
| features/supply/src/pages/production-plan/utils/productionPlanDerive.ts | util | 187 |
| features/supply/src/pages/production-plan/utils/productionPlanDrilldown.ts | util | 69 |
| features/supply/src/pages/production-plan/utils/productionPlanEditLock.ts | util | 150 |
| features/supply/src/pages/production-plan/utils/productionPlanLineSave.ts | util | 137 |
| features/supply/src/pages/production-plan/__asis-mapping__.md | mapping | 78 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueries) | hook | 1 | Y | ProductionPlanForm.tsx:66 |
| SCP0011/main//call-proc | hook | 1 | Y | ProductionPlan.tsx:91 |
| SCP0011/line//call-proc | hook | 1 | Y | ProductionPlan.tsx:99 |
| SCP0011/editInfo//call-proc | hook | 1 | Y | ProductionPlan.tsx:107 |
| SCP0011/amend//call-proc | hook | 1 | Y | ProductionPlan.tsx:115 |
| /admin/menu/SCP0011/search-conditions | http | 1 | Y | useProductionPlanStore.ts:131 |
| /admin/menu/SCP0011/column | http | 1 | Y | useProductionPlanStore.ts:266 |
| /admin/menu/SCP0011/measure | http | 1 | Y | useProductionPlanStore.ts:290 |
| /SCP0011/line/SAVE/call-proc | http | 1 | Y | productionPlanLineSave.ts:124 |

## 3. procedures.d.ts 등재 시트
(없음)

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| CustomDropdown | onChange | <arrow> onPick,String(picked??'').split(',').filter,String(picked??'').split,String,v.toUpperCase | jsx | features/supply/src/pages/production-plan/components/ProductionPlanForm.tsx | 219 |
| CustomDropdown | onChange | <arrow> onPick,String | jsx | features/supply/src/pages/production-plan/components/ProductionPlanForm.tsx | 247 |
| InputField | onChange | <arrow> onChange | jsx | features/supply/src/pages/production-plan/components/ProductionPlanForm.tsx | 281 |
| InputField | onKeyDown | <arrow> onSearch | jsx | features/supply/src/pages/production-plan/components/ProductionPlanForm.tsx | 282 |
| FunctionSearchIcon | onClick | onIconClick | jsx | features/supply/src/pages/production-plan/components/ProductionPlanForm.tsx | 277 |
| SearchArea | onSearch | onSearch | jsx | features/supply/src/pages/production-plan/components/ProductionPlanForm.tsx | 300 |
| PlanVersionCascade | onChange | <arrow> set | jsx | features/supply/src/pages/production-plan/components/ProductionPlanForm.tsx | 354 |
| PeriodRangePicker | onChange | <arrow> set | jsx | features/supply/src/pages/production-plan/components/ProductionPlanForm.tsx | 370 |
| Checkbox | onChange | <arrow> set | jsx | features/supply/src/pages/production-plan/components/ProductionPlanForm.tsx | 393 |
| grid | updatedLayout | applyHeaderHeight | addHandler | features/supply/src/pages/production-plan/components/ProductionPlanGrid.tsx | 168 |
| g | beginningEdit | beginningEditHandler | addHandler | features/supply/src/pages/production-plan/components/ProductionPlanGrid.tsx | 218 |
| g | pastingCell | beginningEditHandler | addHandler | features/supply/src/pages/production-plan/components/ProductionPlanGrid.tsx | 219 |
| g | cellEditEnding | negativeEditHandler | addHandler | features/supply/src/pages/production-plan/components/ProductionPlanGrid.tsx | 235 |
| g | pastingCell | negativePasteHandler | addHandler | features/supply/src/pages/production-plan/components/ProductionPlanGrid.tsx | 236 |
| g | cellEditEnded | cellEditEndedHandler | addHandler | features/supply/src/pages/production-plan/components/ProductionPlanGrid.tsx | 281 |
| g | pastedCell | cellEditEndedHandler | addHandler | features/supply/src/pages/production-plan/components/ProductionPlanGrid.tsx | 282 |
| g | formatItem | formatHandler | addHandler | features/supply/src/pages/production-plan/components/ProductionPlanGrid.tsx | 323 |
| g.hostElement? | click | clickDblHandler | addEventListener | features/supply/src/pages/production-plan/components/ProductionPlanGrid.tsx | 371 |
| DataGrid | initialized | handleGridInitialized | jsx | features/supply/src/pages/production-plan/components/ProductionPlanGrid.tsx | 406 |
| DataGrid | gotFocus | onFocus | jsx | features/supply/src/pages/production-plan/components/ProductionPlanGrid.tsx | 407 |
| ProductionPlanForm | onSearch | handleSearch | jsx | features/supply/src/pages/production-plan/ProductionPlan.tsx | 335 |
| ProductionPlanForm | onItemSearch | <arrow> setOpenItem | jsx | features/supply/src/pages/production-plan/ProductionPlan.tsx | 336 |
| ProductionPlanGrid | onRowDoubleClick | handleMasterRowDoubleClick | jsx | features/supply/src/pages/production-plan/ProductionPlan.tsx | 392 |
| ProductionPlanGrid | onFocus | <arrow> setFocusedSheet | jsx | features/supply/src/pages/production-plan/ProductionPlan.tsx | 393 |
| ProductionPlanGrid | onFocus | <arrow> setFocusedSheet | jsx | features/supply/src/pages/production-plan/ProductionPlan.tsx | 422 |
| MeasureSelectModal | onApply | <arrow> setVisibleModel,setVisibleLine,(staticMeasures[sheet]??[]).map,saveTitleSet({menuId:MENU_ID,sheetName:MEASURE_SHEET_NAME[sheet],columnType:'M',rows:selected.map((name,i)=>({name,sortOrderNo:i+1})),}).then,saveTitleSet,selected.map | jsx | features/supply/src/pages/production-plan/ProductionPlan.tsx | 456 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Grid | 6 |
| FormItem | 4 |
| CustomDropdown | 2 |
| SubTitle | 2 |
| Panel | 2 |
| ProductionPlanGrid | 2 |
| InputField | 1 |
| Button | 1 |
| FunctionSearchIcon | 1 |
| SearchArea | 1 |
| PlanVersionCascade | 1 |
| PeriodRangePicker | 1 |
| Checkbox | 1 |
| DataGrid | 1 |
| MainTitle | 1 |
| ProductionPlanForm | 1 |
| IcMeasureSelect | 1 |
| PanelGroup | 1 |
| PanelSeparator | 1 |
| MaterialByDivisionModal | 1 |
| MeasureSelectModal | 1 |

## 6. 하드코딩 Grid 컬럼
| context | binding | header | width | visible | isReadOnly | dataType | via | file | line |
|---|---|---|---|---|---|---|---|---|---|
| fallbackToRaw | c.key | c.header | c.width ?? 100 | true |  |  | meta-map | features/supply/src/pages/production-plan/utils/productionPlanColumns.ts | 14 |
| buildPivotColumns | DIVISION_ID:DIVISION_ID,END_CUSTOMER:END_CUSTOMER | leafHeader | 70 | true |  |  | object | features/supply/src/pages/production-plan/utils/productionPlanColumns.ts | 90 |

## 7. 메시지 코드
| code | count |
|---|---|
| MSG00429 | 1 |
| MSG00096 | 1 |
| MSG00225 | 1 |
| MSG01217 | 1 |
| MSG00004 | 1 |
| MSG00002 | 1 |
| MSG00006 | 1 |
| MSG00108 | 1 |
| LBL00112 | 1 |
| LBL00641 | 1 |
| LBL00027 | 1 |
| LBL00005 | 1 |
| LBL00038 | 1 |
| LBL00021 | 1 |
| LBL00618 | 1 |
| LBL00039 | 1 |
| LBL00040 | 1 |
| LBL00041 | 1 |
| LBL00013 | 1 |
| LBL00710 | 1 |
| LBL00687 | 1 |
| LBL00632 | 1 |
| LBL01058 | 1 |
| LBL00310 | 1 |
| LBL00669 | 1 |
| LBL00010 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: SCP0013(14), SCP0011(11), DMF0014(1), SCP0025(1), SCP0006(1)
- SP/PKG: PKG_SCP0011(4), P_SCP0011_SAVE_PROD_PLAN_LINE(3), P_SCP_ANL_PROD_PLAN_I_AMEND(2), PKG_COM0000(2), P_SCP0011_GET_PLAN_EDIT_INFO(2), PR_GET_SHEET_MEASURE_LIST(2), P_DIVISION_ID(2), P_SCP0011_GET_PROD_PLAN_MODEL(1), P_SCP0009_GET_SHEET_CALENDAR_3SPAN(1), DM0003_GET_BUCKET_TYPE_CODE(1), P_SCP0011_(1), P_USER_ID(1), P_ORIGIN_DIVISION_ID(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| code | Insert/Delete = NO-OP(버튼 노출 + () => undefined, design 01 R-A3/R-A4). btnCal=Amend, btnMeasure=TitleSet. | features/supply/src/pages/production-plan/ProductionPlan.tsx | 40 |
| endpoint | DATA_TP_CD='CLOB' 이라 공용 useProcMutation({data:[rows]})로는 키 불일치로 조용히 no-op 된다(react-gap-audit H2). | features/supply/src/pages/production-plan/ProductionPlan.tsx | 269 |
| code | const weekGroups = [...month.weeks.values()]; | features/supply/src/pages/production-plan/utils/productionPlanColumns.ts | 106 |
| endpoint | 공용 useProcMutation({data:[rows]}) 로는 top-level 에 activeFlag/divisionId... 키가 없어 전부 null 바인딩되고 | features/supply/src/pages/production-plan/utils/productionPlanLineSave.ts | 6 |

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

