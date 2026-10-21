# SCP0024 — To-Be Fact Pack 요약

- page_key: `supply/production-plan-fix` · feature: supply · As-is Fact Pack 없음(화면ID 미대응)
- 파일 16 · 엔드포인트 호출 7 (미해결 0, 주석 속 2) · 이벤트 17 · 컴포넌트 사용 21 · 하드코딩 컬럼 2 · 메시지 25
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 2건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/supply/src/pages/production-plan-fix/components/ProductionPlanFixForm.tsx | component | 260 |
| features/supply/src/pages/production-plan-fix/components/ProductionPlanFixGrid.tsx | component | 241 |
| features/supply/src/pages/production-plan-fix/hooks/useProductionPlanFixValidation.ts | hook | 99 |
| features/supply/src/pages/production-plan-fix/index.ts | index | 2 |
| features/supply/src/pages/production-plan-fix/production-plan-fix.constants.ts | constants | 179 |
| features/supply/src/pages/production-plan-fix/production-plan-fix.types.ts | types | 22 |
| features/supply/src/pages/production-plan-fix/ProductionPlanFix.module.scss | style | 12 |
| features/supply/src/pages/production-plan-fix/ProductionPlanFix.tsx | page | 238 |
| features/supply/src/pages/production-plan-fix/useProductionPlanFixStore.ts | store | 208 |
| features/supply/src/pages/production-plan-fix/utils/productionPlanFixColumns.ts | util | 156 |
| features/supply/src/pages/production-plan-fix/utils/productionPlanFixDerive.ts | util | 29 |
| features/supply/src/pages/production-plan-fix/utils/productionPlanFixEditLock.ts | util | 77 |
| features/supply/src/pages/production-plan-fix/utils/productionPlanFixHeaderMerge.ts | util | 57 |
| features/supply/src/pages/production-plan-fix/utils/productionPlanFixSave.test.ts | test | 80 |
| features/supply/src/pages/production-plan-fix/utils/productionPlanFixSave.ts | util | 164 |
| features/supply/src/pages/production-plan-fix/__asis-mapping__.md | mapping | 136 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueries) | hook | 1 | Y | ProductionPlanFixForm.tsx:51 |
| (useTabLookupQueries) | hook | 1 | Y | ProductionPlanFixForm.tsx:60 |
| SCP0024/main//call-proc | hook | 2 | Y | ProductionPlanFix.tsx:62 ProductionPlanFix.tsx:72 |
| /admin/menu/SCP0024/column | http | 1 | Y | useProductionPlanFixStore.ts:141 |
| /admin/menu/SCP0024/measure | http | 1 | Y | useProductionPlanFixStore.ts:162 |
| /admin/menu/SCP0024/search-conditions | http | 1 | Y | useProductionPlanFixStore.ts:185 |

## 3. procedures.d.ts 등재 시트
| sheet | request_keys | response_cursors | sp_hints |
|---|---|---|---|
| main | divisionId operationGroup scmSiteId lineId itemId fromYyyymmdd toYyyymmdd electrodeType debugMode | o_rc1 | PKG_SCP0024 P_SCP0024_GET_PROD_PLAN_FIX |

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| CustomDropdown | onChange | <arrow> onPick,String(picked??'').split(',').filter,String(picked??'').split,String,v.toUpperCase | jsx | features/supply/src/pages/production-plan-fix/components/ProductionPlanFixForm.tsx | 129 |
| CustomDropdown | onChange | <arrow> onPick,String | jsx | features/supply/src/pages/production-plan-fix/components/ProductionPlanFixForm.tsx | 159 |
| SearchArea | onSearch | onSearch | jsx | features/supply/src/pages/production-plan-fix/components/ProductionPlanFixForm.tsx | 170 |
| Checkbox | onChange | <arrow> set | jsx | features/supply/src/pages/production-plan-fix/components/ProductionPlanFixForm.tsx | 180 |
| PeriodRangePicker | onChange | <arrow> set | jsx | features/supply/src/pages/production-plan-fix/components/ProductionPlanFixForm.tsx | 217 |
| InputField | onChange | <arrow> set | jsx | features/supply/src/pages/production-plan-fix/components/ProductionPlanFixForm.tsx | 249 |
| InputField | onKeyDown | <arrow> onSearch | jsx | features/supply/src/pages/production-plan-fix/components/ProductionPlanFixForm.tsx | 250 |
| FunctionSearchIcon | onClick | onItemSearch | jsx | features/supply/src/pages/production-plan-fix/components/ProductionPlanFixForm.tsx | 245 |
| g | beginningEdit | readOnlyHandler | addHandler | features/supply/src/pages/production-plan-fix/components/ProductionPlanFixGrid.tsx | 81 |
| g | pastingCell | readOnlyHandler | addHandler | features/supply/src/pages/production-plan-fix/components/ProductionPlanFixGrid.tsx | 82 |
| g | formatItem | formatHandler | addHandler | features/supply/src/pages/production-plan-fix/components/ProductionPlanFixGrid.tsx | 108 |
| g.hostElement? | dblclick | dblClickHandler | addEventListener | features/supply/src/pages/production-plan-fix/components/ProductionPlanFixGrid.tsx | 149 |
| g | updatedLayout | applyHeaderHeight | addHandler | features/supply/src/pages/production-plan-fix/components/ProductionPlanFixGrid.tsx | 218 |
| DataGrid | gotFocus | onFocus | jsx | features/supply/src/pages/production-plan-fix/components/ProductionPlanFixGrid.tsx | 237 |
| ProductionPlanFixForm | onSearch | handleSearch | jsx | features/supply/src/pages/production-plan-fix/ProductionPlanFix.tsx | 182 |
| ProductionPlanFixForm | onItemSearch | <arrow> setOpenItem | jsx | features/supply/src/pages/production-plan-fix/ProductionPlanFix.tsx | 183 |
| ProductionPlanFixGrid | onFocus | <arrow>  | jsx | features/supply/src/pages/production-plan-fix/ProductionPlanFix.tsx | 218 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Grid | 4 |
| FormItem | 3 |
| CustomDropdown | 2 |
| SearchArea | 1 |
| Checkbox | 1 |
| PeriodRangePicker | 1 |
| InputField | 1 |
| Button | 1 |
| FunctionSearchIcon | 1 |
| DataGrid | 1 |
| MainTitle | 1 |
| ProductionPlanFixForm | 1 |
| SubTitle | 1 |
| ProductionPlanFixGrid | 1 |
| MaterialByDivisionModal | 1 |

## 6. 하드코딩 Grid 컬럼
| context | binding | header | width | visible | isReadOnly | dataType | via | file | line |
|---|---|---|---|---|---|---|---|---|---|
| fallbackToRaw | c.key | c.header | c.width ?? 100 | true |  |  | meta-map | features/supply/src/pages/production-plan-fix/utils/productionPlanFixColumns.ts | 17 |
| leaf | DIVISION_ID:DIVISION_ID,END_CUSTOMER:END_CUSTOMER | kind === 'D' ? binding.slice(8, 10) : 'SUM' | 70 | isPivotVisible(binding, bucket, chkSum) |  |  | object | features/supply/src/pages/production-plan-fix/utils/productionPlanFixColumns.ts | 113 |

## 7. 메시지 코드
| code | count |
|---|---|
| MSG00096 | 1 |
| MSG00014 | 1 |
| MSG00429 | 1 |
| MSG01078 | 1 |
| MSG00672 | 1 |
| MSG00683 | 1 |
| MSG01034 | 1 |
| MSG00004 | 1 |
| MSG00003 | 1 |
| MSG00108 | 1 |
| MSG01187 | 1 |
| MSG00225 | 1 |
| MSG00165 | 1 |
| MSG00662 | 1 |
| LBL00001 | 1 |
| LBL00027 | 1 |
| LBL00005 | 1 |
| LBL00010 | 1 |
| LBL00038 | 1 |
| LBL00710 | 1 |
| LBL00013 | 1 |
| LBL00021 | 1 |
| LBL00687 | 1 |
| LBL00112 | 1 |
| LBL00772 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: SCP0024(15), SCP0013(12), SCP0025(5), SCP0020(3), DMF0082(1)
- SP/PKG: PKG_SCP0024(8), P_SCP0024_SAVE_PLAN_FIX_DS(3), P_SCP0024_GET_PROD_PLAN_FIX(1), P_DATA(1), P_USER_ID(1), P_SCP0024_SAVE_PROD_PLAN_FIX(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| code | 노출 + 명시적 무동작(insert/delete: ()=>undefined). EditButton=MSG00109("Read-only mode.") 안내 후 | features/supply/src/pages/production-plan-fix/ProductionPlanFix.tsx | 28 |
| code | return(cs:621-634, SwitchLock 주석) — 모드 토글 자체는 asis_to_tobe.md §11 (b) 결정으로 미이식. | features/supply/src/pages/production-plan-fix/ProductionPlanFix.tsx | 29 |
| endpoint | — mount 1회 fetch(hook #66). Search 시에도 refetch(handleSearch). | features/supply/src/pages/production-plan-fix/ProductionPlanFix.tsx | 90 |
| code | R1 — 미조회(데이터 없음) 상태면 안내 후 return. AS-IS 는 무반응(cs:1259)이나 TO-BE 는 안내를 유지(사용자 결정). | features/supply/src/pages/production-plan-fix/ProductionPlanFix.tsx | 123 |
| code | 종전 `() => undefined` 상시 노출(2026-09-26 G20)을 대체한다 — 권한 판정을 타게 되었으므로 | features/supply/src/pages/production-plan-fix/ProductionPlanFix.tsx | 160 |
| endpoint | admin SCM_MST_SHEET_COLUMNS('Model') 동적 fetch (ui-dynamic-property-management §2.3). 12행 등록 확인. | features/supply/src/pages/production-plan-fix/useProductionPlanFixStore.ts | 30 |

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

