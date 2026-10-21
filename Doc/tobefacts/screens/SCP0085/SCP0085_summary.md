# SCP0085 — To-Be Fact Pack 요약

- page_key: `supply/ending-inventory` · feature: supply · As-is Fact Pack 없음(화면ID 미대응)
- 파일 8 · 엔드포인트 호출 5 (미해결 0, 주석 속 0) · 이벤트 18 · 컴포넌트 사용 31 · 하드코딩 컬럼 0 · 메시지 12
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 0건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/supply/src/pages/ending-inventory/components/EndingInventoryForm.tsx | component | 276 |
| features/supply/src/pages/ending-inventory/components/EndingInventoryGrid.tsx | component | 153 |
| features/supply/src/pages/ending-inventory/ending-inventory.constants.ts | constants | 129 |
| features/supply/src/pages/ending-inventory/ending-inventory.types.ts | types | 19 |
| features/supply/src/pages/ending-inventory/EndingInventory.tsx | page | 159 |
| features/supply/src/pages/ending-inventory/index.ts | index | 2 |
| features/supply/src/pages/ending-inventory/useEndingInventoryStore.ts | store | 168 |
| features/supply/src/pages/ending-inventory/__asis-mapping__.md | mapping | 73 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueries) | hook | 1 | Y | EndingInventoryForm.tsx:66 |
| SCP0085/main//call-proc | hook | 1 | Y | EndingInventory.tsx:44 |
| SCP0085/daily//call-proc | hook | 1 | Y | EndingInventory.tsx:51 |
| /admin/menu/SCP0085/search-conditions | http | 1 | Y | useEndingInventoryStore.ts:100 |
| /admin/menu/SCP0085/column | http | 1 | Y | useEndingInventoryStore.ts:153 |

## 3. procedures.d.ts 등재 시트
| sheet | request_keys | response_cursors | sp_hints |
|---|---|---|---|
| main | yyyymm divisionId plantId itemId debugMode itemType profitCenter | o_rc1 | SCP0085_GET_ENDING_INVENTORY SCP0085_GET_ENDING_INVENTORY_DAILY PKG_SCP0085 |
| daily | yyyymmdd divisionId plantId itemId debugMode itemType profitCenter | o_rc1 | SCP0085_GET_ENDING_INVENTORY SCP0085_GET_ENDING_INVENTORY_DAILY PKG_SCP0085 |

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| SearchArea | onSearch | onSearch | jsx | features/supply/src/pages/ending-inventory/components/EndingInventoryForm.tsx | 94 |
| Radio | onChange | <arrow> set | jsx | features/supply/src/pages/ending-inventory/components/EndingInventoryForm.tsx | 105 |
| DatePickerCalendar | onChange | <arrow> date?.format,set,ymd.slice | jsx | features/supply/src/pages/ending-inventory/components/EndingInventoryForm.tsx | 123 |
| DatePickerCalendar | onChange | <arrow> date?.format,set | jsx | features/supply/src/pages/ending-inventory/components/EndingInventoryForm.tsx | 140 |
| CustomDropdown | onChange | <arrow> set | jsx | features/supply/src/pages/ending-inventory/components/EndingInventoryForm.tsx | 167 |
| CustomDropdown | onChange | <arrow> set | jsx | features/supply/src/pages/ending-inventory/components/EndingInventoryForm.tsx | 186 |
| Radio | onChange | <arrow> set | jsx | features/supply/src/pages/ending-inventory/components/EndingInventoryForm.tsx | 200 |
| CustomDropdown | onChange | <arrow> set | jsx | features/supply/src/pages/ending-inventory/components/EndingInventoryForm.tsx | 217 |
| InputField | onChange | <arrow> set | jsx | features/supply/src/pages/ending-inventory/components/EndingInventoryForm.tsx | 247 |
| InputField | onKeyDown | <arrow> onSearch | jsx | features/supply/src/pages/ending-inventory/components/EndingInventoryForm.tsx | 248 |
| FunctionSearchIcon | onClick | onItemSearch | jsx | features/supply/src/pages/ending-inventory/components/EndingInventoryForm.tsx | 242 |
| Checkbox | onChange | <arrow> set | jsx | features/supply/src/pages/ending-inventory/components/EndingInventoryForm.tsx | 260 |
| g | updatedLayout | apply | addHandler | features/supply/src/pages/ending-inventory/components/EndingInventoryGrid.tsx | 85 |
| g | updatedLayout | apply | addHandler | features/supply/src/pages/ending-inventory/components/EndingInventoryGrid.tsx | 103 |
| g | formatItem | handler | addHandler | features/supply/src/pages/ending-inventory/components/EndingInventoryGrid.tsx | 125 |
| EndingInventoryForm | onSearch | handleSearch | jsx | features/supply/src/pages/ending-inventory/EndingInventory.tsx | 119 |
| EndingInventoryForm | onItemSearch | <arrow> setOpenItem | jsx | features/supply/src/pages/ending-inventory/EndingInventory.tsx | 119 |
| EndingInventoryGrid | onToggleDetail | toggleHeaderViewDetail | jsx | features/supply/src/pages/ending-inventory/EndingInventory.tsx | 137 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Grid | 8 |
| FormItem | 5 |
| CustomDropdown | 3 |
| Radio | 2 |
| DatePickerCalendar | 2 |
| SearchArea | 1 |
| InputField | 1 |
| Button | 1 |
| FunctionSearchIcon | 1 |
| Checkbox | 1 |
| DataGrid | 1 |
| MainTitle | 1 |
| EndingInventoryForm | 1 |
| SubTitle | 1 |
| EndingInventoryGrid | 1 |
| MaterialByDivisionModal | 1 |

## 6. 하드코딩 Grid 컬럼
(없음)

## 7. 메시지 코드
| code | count |
|---|---|
| MSG00097 | 1 |
| MSG00719 | 1 |
| MSG00378 | 1 |
| LBL00112 | 1 |
| LBL00684 | 1 |
| LBL00682 | 1 |
| LBL00069 | 1 |
| LBL00066 | 1 |
| LBL00001 | 1 |
| LBL00030 | 1 |
| LBL00021 | 1 |
| LBL00068 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: SCP0085(2)
- SP/PKG: SCP0084_GET_MONTH_RANGE(1), PKG_SCP0084(1), PKG_SCP0085(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
(없음)

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

