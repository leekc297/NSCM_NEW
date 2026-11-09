# SCP0133 — To-Be Fact Pack 요약

- page_key: `supply/warehouse-capacity` · feature: supply · As-is Fact Pack 있음
- 파일 13 · 엔드포인트 호출 11 (미해결 0, 주석 속 5) · 이벤트 28 · 컴포넌트 사용 37 · 하드코딩 컬럼 0 · 메시지 17
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 0건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/supply/src/pages/warehouse-capacity/components/WarehouseCapacityForm.tsx | component | 334 |
| features/supply/src/pages/warehouse-capacity/components/WarehouseCapacityGrid.tsx | component | 162 |
| features/supply/src/pages/warehouse-capacity/components/WarehouseItemMappingGrid.module.scss | component | 20 |
| features/supply/src/pages/warehouse-capacity/components/WarehouseItemMappingGrid.tsx | component | 230 |
| features/supply/src/pages/warehouse-capacity/index.ts | index | 2 |
| features/supply/src/pages/warehouse-capacity/useWarehouseCapacityStore.ts | store | 212 |
| features/supply/src/pages/warehouse-capacity/utils/warehouseCapacity.saveRequest.ts | util | 128 |
| features/supply/src/pages/warehouse-capacity/utils/warehouseCapacityEditLock.ts | util | 112 |
| features/supply/src/pages/warehouse-capacity/warehouse-capacity.constants.ts | constants | 133 |
| features/supply/src/pages/warehouse-capacity/warehouse-capacity.types.ts | types | 23 |
| features/supply/src/pages/warehouse-capacity/WarehouseCapacity.module.scss | style | 12 |
| features/supply/src/pages/warehouse-capacity/WarehouseCapacity.tsx | page | 367 |
| features/supply/src/pages/warehouse-capacity/__asis-mapping__.md | mapping | 53 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueries) | hook | 4 | Y | WarehouseCapacityForm.tsx:59 WarehouseCapacityForm.tsx:67 WarehouseCapacityGrid.tsx:63 WarehouseCapacity.tsx:118 |
| (useTabLookupQuery) | hook | 1 | Y | WarehouseCapacityForm.tsx:65 |
| /admin/menu/SCP0133/search-conditions | http | 1 | Y | useWarehouseCapacityStore.ts:172 |
| /admin/menu/SCP0133/column | http | 2 | Y | useWarehouseCapacityStore.ts:189 useWarehouseCapacityStore.ts:192 |
| /SCP0133/main\|itemMapping/SAVE/call-proc | http | 1 | Y | warehouseCapacity.saveRequest.ts:115 |
| SCP0133/main//call-proc | hook | 1 | Y | WarehouseCapacity.tsx:69 |
| SCP0133/itemMapping//call-proc | hook | 1 | Y | WarehouseCapacity.tsx:104 |

## 3. procedures.d.ts 등재 시트
| sheet | request_keys | response_cursors | sp_hints |
|---|---|---|---|
| main | divisionId opmzPlanGrId siteId stage whNm fromYyyymmdd toYyyymmdd itemId validYn | o_rc1 | SCP0133_GET_WAREHOUSE_CAPACITY SCP0133_GET_WAREHOUSE_ITEM_MAPPING SCP0133_GET_SEARCH_INFO SCP0133_SAVE_WAREHOUSE_CAPACITY SCP0133_SAVE_WAREHOUSE_ITEM_MAPPING PKG_SCP0133 |
| itemMapping | divisionId opmzPlanGrId siteId stage whNm fromYyyymmdd toYyyymmdd itemId validYn | o_rc1 | SCP0133_GET_WAREHOUSE_CAPACITY SCP0133_GET_WAREHOUSE_ITEM_MAPPING SCP0133_GET_SEARCH_INFO SCP0133_SAVE_WAREHOUSE_CAPACITY SCP0133_SAVE_WAREHOUSE_ITEM_MAPPING PKG_SCP0133 |

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| SearchArea | onSearch | onSearch | jsx | features/supply/src/pages/warehouse-capacity/components/WarehouseCapacityForm.tsx | 151 |
| CustomDropdown | onChange | <arrow> confirmIfDirtyKey(tabDirtyKey(tabId),'search').then,confirmIfDirtyKey,tabDirtyKey,setDivision,String | jsx | features/supply/src/pages/warehouse-capacity/components/WarehouseCapacityForm.tsx | 168 |
| CustomDropdown | onChange | <arrow> set,toMultiArray | jsx | features/supply/src/pages/warehouse-capacity/components/WarehouseCapacityForm.tsx | 199 |
| CustomDropdown | onChange | <arrow> set,String | jsx | features/supply/src/pages/warehouse-capacity/components/WarehouseCapacityForm.tsx | 218 |
| CustomDropdown | onChange | <arrow> set,String | jsx | features/supply/src/pages/warehouse-capacity/components/WarehouseCapacityForm.tsx | 236 |
| CustomDropdown | onChange | <arrow> set,toMultiArray | jsx | features/supply/src/pages/warehouse-capacity/components/WarehouseCapacityForm.tsx | 257 |
| CustomDropdown | onChange | <arrow> set,toMultiArray | jsx | features/supply/src/pages/warehouse-capacity/components/WarehouseCapacityForm.tsx | 283 |
| PeriodField | onChange | <arrow> set | jsx | features/supply/src/pages/warehouse-capacity/components/WarehouseCapacityForm.tsx | 295 |
| InputField | onChange | <arrow> set | jsx | features/supply/src/pages/warehouse-capacity/components/WarehouseCapacityForm.tsx | 323 |
| Button | onClick | onItemSearch | jsx | features/supply/src/pages/warehouse-capacity/components/WarehouseCapacityForm.tsx | 319 |
| g | updatedLayout | apply | addHandler | features/supply/src/pages/warehouse-capacity/components/WarehouseCapacityGrid.tsx | 77 |
| g | beginningEdit | beginningEditHandler | addHandler | features/supply/src/pages/warehouse-capacity/components/WarehouseCapacityGrid.tsx | 100 |
| g | pastingCell | beginningEditHandler | addHandler | features/supply/src/pages/warehouse-capacity/components/WarehouseCapacityGrid.tsx | 101 |
| g | cellEditEnded | cellEditEndedHandler | addHandler | features/supply/src/pages/warehouse-capacity/components/WarehouseCapacityGrid.tsx | 131 |
| g | pastedCell | cellEditEndedHandler | addHandler | features/supply/src/pages/warehouse-capacity/components/WarehouseCapacityGrid.tsx | 132 |
| DataGrid | gotFocus | onFocus | jsx | features/supply/src/pages/warehouse-capacity/components/WarehouseCapacityGrid.tsx | 158 |
| g | beginningEdit | beginningEditHandler | addHandler | features/supply/src/pages/warehouse-capacity/components/WarehouseItemMappingGrid.tsx | 89 |
| g | pastingCell | beginningEditHandler | addHandler | features/supply/src/pages/warehouse-capacity/components/WarehouseItemMappingGrid.tsx | 90 |
| g | formatItem | formatItemHandler | addHandler | features/supply/src/pages/warehouse-capacity/components/WarehouseItemMappingGrid.tsx | 121 |
| g | cellEditEnded | storLocDeriveHandler | addHandler | features/supply/src/pages/warehouse-capacity/components/WarehouseItemMappingGrid.tsx | 142 |
| g | pastedCell | storLocDeriveHandler | addHandler | features/supply/src/pages/warehouse-capacity/components/WarehouseItemMappingGrid.tsx | 143 |
| g | cellEditEnded | whDeriveHandler | addHandler | features/supply/src/pages/warehouse-capacity/components/WarehouseItemMappingGrid.tsx | 163 |
| g | pastedCell | whDeriveHandler | addHandler | features/supply/src/pages/warehouse-capacity/components/WarehouseItemMappingGrid.tsx | 164 |
| DataGrid | gotFocus | onFocus | jsx | features/supply/src/pages/warehouse-capacity/components/WarehouseItemMappingGrid.tsx | 205 |
| WarehouseCapacityForm | onSearch | handleSearch | jsx | features/supply/src/pages/warehouse-capacity/WarehouseCapacity.tsx | 309 |
| WarehouseCapacityForm | onItemSearch | <arrow> setOpenItem | jsx | features/supply/src/pages/warehouse-capacity/WarehouseCapacity.tsx | 310 |
| WarehouseCapacityGrid | onFocus | <arrow>  | jsx | features/supply/src/pages/warehouse-capacity/WarehouseCapacity.tsx | 339 |
| WarehouseItemMappingGrid | onFocus | <arrow>  | jsx | features/supply/src/pages/warehouse-capacity/WarehouseCapacity.tsx | 351 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Grid | 7 |
| FormItem | 7 |
| CustomDropdown | 6 |
| DataGrid | 2 |
| MaterialByDivisionModal | 2 |
| TabItem | 2 |
| SearchArea | 1 |
| PeriodField | 1 |
| InputField | 1 |
| Button | 1 |
| FunctionSearchIcon | 1 |
| MainTitle | 1 |
| WarehouseCapacityForm | 1 |
| SubTitle | 1 |
| TabWrapper | 1 |
| WarehouseCapacityGrid | 1 |
| WarehouseItemMappingGrid | 1 |

## 6. 하드코딩 Grid 컬럼
(없음)

## 7. 메시지 코드
| code | count |
|---|---|
| LBL00112 | 1 |
| LBL00002 | 1 |
| LBL00016 | 1 |
| LBL00061 | 1 |
| LBL00064 | 1 |
| LBL00007 | 1 |
| LBL00013 | 1 |
| LBL00618 | 1 |
| MSG00004 | 1 |
| MSG00013 | 1 |
| MSG00703 | 1 |
| MSG01135 | 1 |
| MSG00611 | 1 |
| MSG00085 | 1 |
| MSG01149 | 1 |
| MSG00003 | 1 |
| MSG00002 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: SCP0133(9), SCP0127(2), SCP0129(1), SCP0025(1), SCP0006(1), SCP0126(1), SCP0020(1)
- SP/PKG: PKG_SCP0133(10), P_SCP0133_GET_WAREHOUSE_ITEM_MAPPING(2), P_SCP0133_SAVE_WAREHOUSE_ITEM_MAPPING(2), P_SCP0133_GET(2), P_USER_ID(1), P_SCP0133_SAVE_(1), P_SCP0133_GET_WAREHOUSE_CAPACITY(1), P_SCP0133_SAVE_WAREHOUSE_CAPACITY(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| endpoint | ui-dynamic-property-management §2.3 — admin SCM_MST_SHEET_COLUMNS 동적 fetch(31행 등록됨, | features/supply/src/pages/warehouse-capacity/useWarehouseCapacityStore.ts | 23 |
| endpoint | 왜 useProcMutation({data:[rows]}) 가 아닌가: PKG_SCP0133 SAVE SP 2종은 각 컬럼이 별도 CLOB 인자이고 | features/supply/src/pages/warehouse-capacity/utils/warehouseCapacity.saveRequest.ts | 5 |
| endpoint | PKG_SCP0133 에 배포돼 있어(gap-resolve iter-2 실측) main 시트와 동일하게 useTabProcQuery(조회)/ | features/supply/src/pages/warehouse-capacity/WarehouseCapacity.tsx | 35 |
| endpoint | useProcMutation(저장)으로 배선한다(A2/A3 해소). 두 시트 조회조건은 동일 9파라미터다. | features/supply/src/pages/warehouse-capacity/WarehouseCapacity.tsx | 36 |
| endpoint | 공용 useProcMutation({data:[rows]}) 은 이 SP 계약(컬럼별 CLOB)에서 전 파라미터 NULL 바인딩 → | features/supply/src/pages/warehouse-capacity/WarehouseCapacity.tsx | 81 |

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

