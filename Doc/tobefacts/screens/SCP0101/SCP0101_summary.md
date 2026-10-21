# SCP0101 — To-Be Fact Pack 요약

- page_key: `supply/inventory-trend` · feature: supply · As-is Fact Pack 없음(화면ID 미대응)
- 파일 8 · 엔드포인트 호출 4 (미해결 0, 주석 속 0) · 이벤트 13 · 컴포넌트 사용 21 · 하드코딩 컬럼 0 · 메시지 7
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 0건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/supply/src/pages/inventory-trend/components/InventoryTrendForm.tsx | component | 171 |
| features/supply/src/pages/inventory-trend/components/InventoryTrendGrid.tsx | component | 179 |
| features/supply/src/pages/inventory-trend/index.ts | index | 2 |
| features/supply/src/pages/inventory-trend/inventory-trend.constants.ts | constants | 141 |
| features/supply/src/pages/inventory-trend/inventory-trend.types.ts | types | 15 |
| features/supply/src/pages/inventory-trend/InventoryTrend.tsx | page | 136 |
| features/supply/src/pages/inventory-trend/useInventoryTrendStore.ts | store | 148 |
| features/supply/src/pages/inventory-trend/__asis-mapping__.md | mapping | 80 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueries) | hook | 1 | Y | InventoryTrendForm.tsx:44 |
| SCP0101/main//call-proc | hook | 1 | Y | InventoryTrend.tsx:44 |
| /admin/menu/SCP0101/column | http | 1 | Y | useInventoryTrendStore.ts:103 |
| /admin/menu/SCP0101/search-conditions | http | 1 | Y | useInventoryTrendStore.ts:127 |

## 3. procedures.d.ts 등재 시트
| sheet | request_keys | response_cursors | sp_hints |
|---|---|---|---|
| main | yyyymm divisionId plantId itemId debugMode | o_rc1 | SCP0101_GET_INVENTORY_TREND PKG_SCP0101 |

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| SearchArea | onSearch | onSearch | jsx | features/supply/src/pages/inventory-trend/components/InventoryTrendForm.tsx | 72 |
| DatePickerCalendar | onChange | <arrow> set,date?.format | jsx | features/supply/src/pages/inventory-trend/components/InventoryTrendForm.tsx | 88 |
| CustomDropdown | onChange | <arrow> set | jsx | features/supply/src/pages/inventory-trend/components/InventoryTrendForm.tsx | 111 |
| CustomDropdown | onChange | <arrow> set | jsx | features/supply/src/pages/inventory-trend/components/InventoryTrendForm.tsx | 130 |
| InputField | onChange | <arrow> set | jsx | features/supply/src/pages/inventory-trend/components/InventoryTrendForm.tsx | 160 |
| InputField | onKeyDown | <arrow> onSearch | jsx | features/supply/src/pages/inventory-trend/components/InventoryTrendForm.tsx | 161 |
| FunctionSearchIcon | onClick | onItemSearch | jsx | features/supply/src/pages/inventory-trend/components/InventoryTrendForm.tsx | 155 |
| g | updatedLayout | apply | addHandler | features/supply/src/pages/inventory-trend/components/InventoryTrendGrid.tsx | 76 |
| g | updatedLayout | apply | addHandler | features/supply/src/pages/inventory-trend/components/InventoryTrendGrid.tsx | 94 |
| g | formatItem | handler | addHandler | features/supply/src/pages/inventory-trend/components/InventoryTrendGrid.tsx | 123 |
| g | formatItem | handler | addHandler | features/supply/src/pages/inventory-trend/components/InventoryTrendGrid.tsx | 159 |
| InventoryTrendForm | onSearch | handleSearch | jsx | features/supply/src/pages/inventory-trend/InventoryTrend.tsx | 107 |
| InventoryTrendForm | onItemSearch | <arrow> setOpenItem | jsx | features/supply/src/pages/inventory-trend/InventoryTrend.tsx | 107 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Grid | 4 |
| FormItem | 4 |
| CustomDropdown | 2 |
| SearchArea | 1 |
| DatePickerCalendar | 1 |
| InputField | 1 |
| Button | 1 |
| FunctionSearchIcon | 1 |
| DataGrid | 1 |
| MainTitle | 1 |
| InventoryTrendForm | 1 |
| SubTitle | 1 |
| InventoryTrendGrid | 1 |
| ItemByDivisionModal | 1 |

## 6. 하드코딩 Grid 컬럼
(없음)

## 7. 메시지 코드
| code | count |
|---|---|
| MSG00667 | 1 |
| MSG00719 | 1 |
| LBL00112 | 1 |
| LBL00066 | 1 |
| LBL00001 | 1 |
| LBL00030 | 1 |
| LBL00021 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: SCP0006(2), SCP0101(1), SCP0053(1), SCP0100(1)
- SP/PKG: PKG_SCP0101(2), SCP0101_GET_INVENTORY_TREND(1), SCP0084_GET_MONTH_RANGE(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
(없음)

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

