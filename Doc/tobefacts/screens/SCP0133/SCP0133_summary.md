# SCP0133 — To-Be Fact Pack 요약

- page_key: `supply/warehouse-capacity` · feature: supply · As-is Fact Pack 있음
- 파일 10 · 엔드포인트 호출 8 (미해결 0, 주석 속 1) · 이벤트 26 · 컴포넌트 사용 37 · 하드코딩 컬럼 0 · 메시지 16
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 0건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/supply/src/pages/warehouse-capacity/components/WarehouseCapacityForm.tsx | component | 275 |
| features/supply/src/pages/warehouse-capacity/components/WarehouseCapacityGrid.tsx | component | 127 |
| features/supply/src/pages/warehouse-capacity/components/WarehouseItemMappingGrid.tsx | component | 161 |
| features/supply/src/pages/warehouse-capacity/index.ts | index | 2 |
| features/supply/src/pages/warehouse-capacity/useWarehouseCapacityStore.ts | store | 187 |
| features/supply/src/pages/warehouse-capacity/utils/warehouseCapacityEditLock.ts | util | 56 |
| features/supply/src/pages/warehouse-capacity/warehouse-capacity.constants.ts | constants | 101 |
| features/supply/src/pages/warehouse-capacity/warehouse-capacity.types.ts | types | 20 |
| features/supply/src/pages/warehouse-capacity/WarehouseCapacity.module.scss | style | 12 |
| features/supply/src/pages/warehouse-capacity/WarehouseCapacity.tsx | page | 239 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueries) | hook | 2 | Y | WarehouseCapacityForm.tsx:54 WarehouseCapacityForm.tsx:62 |
| (useTabLookupQuery) | hook | 1 | Y | WarehouseCapacityForm.tsx:60 |
| /admin/menu/SCP0133/search-conditions | http | 1 | Y | useWarehouseCapacityStore.ts:147 |
| /admin/menu/SCP0133/column | http | 2 | Y | useWarehouseCapacityStore.ts:164 useWarehouseCapacityStore.ts:167 |
| SCP0133/main//call-proc | hook | 2 | Y | WarehouseCapacity.tsx:67 WarehouseCapacity.tsx:74 |

## 3. procedures.d.ts 등재 시트
| sheet | request_keys | response_cursors | sp_hints |
|---|---|---|---|
| main | divisionId opmzPlanGrId siteId stage whNm fromYyyymmdd toYyyymmdd itemId validYn | o_rc1 | SCP0133_GET_WAREHOUSE_CAPACITY SCP0133_GET_SEARCH_INFO SCP0133_SAVE_WAREHOUSE_CAPACITY SCP0133_SAVE_WAREHOUSE_ITEM_MAPPING PKG_SCP0133 |

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| SearchArea | onSearch | onSearch | jsx | features/supply/src/pages/warehouse-capacity/components/WarehouseCapacityForm.tsx | 101 |
| CustomDropdown | onChange | <arrow> confirmIfDirtyKey(tabDirtyKey(tabId),'search').then,confirmIfDirtyKey,tabDirtyKey,setDivision,String | jsx | features/supply/src/pages/warehouse-capacity/components/WarehouseCapacityForm.tsx | 114 |
| CustomDropdown | onChange | <arrow> set,toMultiArray | jsx | features/supply/src/pages/warehouse-capacity/components/WarehouseCapacityForm.tsx | 142 |
| CustomDropdown | onChange | <arrow> set,toMultiArray | jsx | features/supply/src/pages/warehouse-capacity/components/WarehouseCapacityForm.tsx | 163 |
| CustomDropdown | onChange | <arrow> set,toMultiArray | jsx | features/supply/src/pages/warehouse-capacity/components/WarehouseCapacityForm.tsx | 184 |
| InputField | onChange | <arrow> set,e.target.value.split(',').map(v=>v.trim()).filter,e.target.value.split(',').map,e.target.value.split,v.trim | jsx | features/supply/src/pages/warehouse-capacity/components/WarehouseCapacityForm.tsx | 201 |
| InputField | onKeyDown | <arrow> onSearch | jsx | features/supply/src/pages/warehouse-capacity/components/WarehouseCapacityForm.tsx | 209 |
| CustomDropdown | onChange | <arrow> set,String | jsx | features/supply/src/pages/warehouse-capacity/components/WarehouseCapacityForm.tsx | 227 |
| PeriodField | onChange | <arrow> set | jsx | features/supply/src/pages/warehouse-capacity/components/WarehouseCapacityForm.tsx | 239 |
| InputField | onChange | <arrow> set | jsx | features/supply/src/pages/warehouse-capacity/components/WarehouseCapacityForm.tsx | 264 |
| InputField | onKeyDown | <arrow> onSearch | jsx | features/supply/src/pages/warehouse-capacity/components/WarehouseCapacityForm.tsx | 265 |
| FunctionSearchIcon | onClick | onItemSearch | jsx | features/supply/src/pages/warehouse-capacity/components/WarehouseCapacityForm.tsx | 259 |
| g | beginningEdit | beginningEditHandler | addHandler | features/supply/src/pages/warehouse-capacity/components/WarehouseCapacityGrid.tsx | 68 |
| g | pastingCell | beginningEditHandler | addHandler | features/supply/src/pages/warehouse-capacity/components/WarehouseCapacityGrid.tsx | 69 |
| g | cellEditEnded | cellEditEndedHandler | addHandler | features/supply/src/pages/warehouse-capacity/components/WarehouseCapacityGrid.tsx | 99 |
| g | pastedCell | cellEditEndedHandler | addHandler | features/supply/src/pages/warehouse-capacity/components/WarehouseCapacityGrid.tsx | 100 |
| DataGrid | gotFocus | onFocus | jsx | features/supply/src/pages/warehouse-capacity/components/WarehouseCapacityGrid.tsx | 123 |
| g | beginningEdit | beginningEditHandler | addHandler | features/supply/src/pages/warehouse-capacity/components/WarehouseItemMappingGrid.tsx | 75 |
| g | pastingCell | beginningEditHandler | addHandler | features/supply/src/pages/warehouse-capacity/components/WarehouseItemMappingGrid.tsx | 76 |
| g | cellEditEnded | storLocDeriveHandler | addHandler | features/supply/src/pages/warehouse-capacity/components/WarehouseItemMappingGrid.tsx | 97 |
| g | pastedCell | storLocDeriveHandler | addHandler | features/supply/src/pages/warehouse-capacity/components/WarehouseItemMappingGrid.tsx | 98 |
| DataGrid | gotFocus | onFocus | jsx | features/supply/src/pages/warehouse-capacity/components/WarehouseItemMappingGrid.tsx | 136 |
| WarehouseCapacityForm | onSearch | handleSearch | jsx | features/supply/src/pages/warehouse-capacity/WarehouseCapacity.tsx | 187 |
| WarehouseCapacityForm | onItemSearch | <arrow> setOpenItem | jsx | features/supply/src/pages/warehouse-capacity/WarehouseCapacity.tsx | 187 |
| WarehouseCapacityGrid | onFocus | <arrow>  | jsx | features/supply/src/pages/warehouse-capacity/WarehouseCapacity.tsx | 209 |
| WarehouseItemMappingGrid | onFocus | <arrow>  | jsx | features/supply/src/pages/warehouse-capacity/WarehouseCapacity.tsx | 220 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Grid | 7 |
| FormItem | 7 |
| CustomDropdown | 5 |
| InputField | 2 |
| DataGrid | 2 |
| MaterialByDivisionModal | 2 |
| TabItem | 2 |
| SearchArea | 1 |
| PeriodField | 1 |
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
| LBL00319 | 1 |
| LBL00001 | 1 |
| LBL00002 | 1 |
| LBL00015 | 1 |
| LBL00061 | 1 |
| LBL00639 | 1 |
| LBL00013 | 1 |
| LBL01142 | 2 |
| MSG00004 | 1 |
| MSG00013 | 1 |
| MSG00703 | 1 |
| MSG00219 | 1 |
| MSG00085 | 1 |
| LBL00641 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: SCP0133(6), SCP0129(1), SCP0025(1), SCP0020(1)
- SP/PKG: SCP0133_GET_WAREHOUSE_CAPACITY(2), PKG_SCP0133(1), SCP0133_SAVE_WAREHOUSE_CAPACITY(1), SCP0133_SAVE_WAREHOUSE_ITEM_MAPPING(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| endpoint | ui-dynamic-property-management §2.3 — admin SCM_MST_SHEET_COLUMNS 동적 fetch(31행 등록됨, | features/supply/src/pages/warehouse-capacity/useWarehouseCapacityStore.ts | 22 |

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

