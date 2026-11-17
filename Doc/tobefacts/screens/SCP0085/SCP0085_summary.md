# SCP0085 — To-Be Fact Pack 요약

- page_key: `supply/ending-inventory` · feature: supply · As-is Fact Pack 있음
- 파일 8 · 엔드포인트 호출 6 (미해결 0, 주석 속 0) · 이벤트 19 · 컴포넌트 사용 37 · 하드코딩 컬럼 0 · 메시지 17
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 0건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/supply/src/pages/ending-inventory/components/EndingInventoryForm.tsx | component | 399 |
| features/supply/src/pages/ending-inventory/components/EndingInventoryGrid.tsx | component | 176 |
| features/supply/src/pages/ending-inventory/ending-inventory.constants.ts | constants | 151 |
| features/supply/src/pages/ending-inventory/ending-inventory.types.ts | types | 20 |
| features/supply/src/pages/ending-inventory/EndingInventory.tsx | page | 179 |
| features/supply/src/pages/ending-inventory/index.ts | index | 2 |
| features/supply/src/pages/ending-inventory/useEndingInventoryStore.ts | store | 171 |
| features/supply/src/pages/ending-inventory/__asis-mapping__.md | mapping | 73 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueries) | hook | 1 | Y | EndingInventoryForm.tsx:76 |
| (useTabLookupQueries) | hook | 1 | Y | EndingInventoryForm.tsx:128 |
| SCP0085/main//call-proc | hook | 1 | Y | EndingInventory.tsx:51 |
| SCP0085/daily//call-proc | hook | 1 | Y | EndingInventory.tsx:58 |
| /admin/menu/SCP0085/search-conditions | http | 1 | Y | useEndingInventoryStore.ts:102 |
| /admin/menu/SCP0085/column | http | 1 | Y | useEndingInventoryStore.ts:156 |

## 3. procedures.d.ts 등재 시트
| sheet | request_keys | response_cursors | sp_hints |
|---|---|---|---|
| main | yyyymm divisionId plantId itemId debugMode itemType profitCenter | o_rc1 | SCP0085_GET_ENDING_INVENTORY SCP0085_GET_ENDING_INVENTORY_DAILY PKG_SCP0085 |
| daily | yyyymmdd divisionId plantId itemId debugMode itemType profitCenter | o_rc1 | SCP0085_GET_ENDING_INVENTORY SCP0085_GET_ENDING_INVENTORY_DAILY PKG_SCP0085 |

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| input | input | onInput | addEventListener | features/supply/src/pages/ending-inventory/components/EndingInventoryForm.tsx | 159 |
| SearchArea | onSearch | onSearch | jsx | features/supply/src/pages/ending-inventory/components/EndingInventoryForm.tsx | 167 |
| Radio | onChange | <arrow> set | jsx | features/supply/src/pages/ending-inventory/components/EndingInventoryForm.tsx | 178 |
| DatePickerCalendar | onChange | <arrow> set,date?.isValid,date.format | jsx | features/supply/src/pages/ending-inventory/components/EndingInventoryForm.tsx | 196 |
| DatePickerCalendar | onChange | <arrow> date?.isValid,date.format,set | jsx | features/supply/src/pages/ending-inventory/components/EndingInventoryForm.tsx | 216 |
| CustomDropdown | onChange | <arrow> set | jsx | features/supply/src/pages/ending-inventory/components/EndingInventoryForm.tsx | 253 |
| CustomDropdown | onChange | <arrow> set | jsx | features/supply/src/pages/ending-inventory/components/EndingInventoryForm.tsx | 272 |
| Radio | onChange | <arrow> set | jsx | features/supply/src/pages/ending-inventory/components/EndingInventoryForm.tsx | 286 |
| CustomDropdown | onChange | <arrow> set | jsx | features/supply/src/pages/ending-inventory/components/EndingInventoryForm.tsx | 303 |
| CustomDropdown | onChange | <arrow> set | jsx | features/supply/src/pages/ending-inventory/components/EndingInventoryForm.tsx | 322 |
| InputField | onChange | <arrow> set | jsx | features/supply/src/pages/ending-inventory/components/EndingInventoryForm.tsx | 351 |
| Button | onClick | onItemSearch | jsx | features/supply/src/pages/ending-inventory/components/EndingInventoryForm.tsx | 347 |
| Checkbox | onChange | <arrow> set | jsx | features/supply/src/pages/ending-inventory/components/EndingInventoryForm.tsx | 373 |
| g | updatedLayout | apply | addHandler | features/supply/src/pages/ending-inventory/components/EndingInventoryGrid.tsx | 86 |
| g | updatedLayout | apply | addHandler | features/supply/src/pages/ending-inventory/components/EndingInventoryGrid.tsx | 121 |
| g | formatItem | handler | addHandler | features/supply/src/pages/ending-inventory/components/EndingInventoryGrid.tsx | 148 |
| EndingInventoryForm | onSearch | handleSearch | jsx | features/supply/src/pages/ending-inventory/EndingInventory.tsx | 139 |
| EndingInventoryForm | onItemSearch | <arrow> setOpenItem | jsx | features/supply/src/pages/ending-inventory/EndingInventory.tsx | 139 |
| EndingInventoryGrid | onToggleDetail | toggleHeaderViewDetail | jsx | features/supply/src/pages/ending-inventory/EndingInventory.tsx | 157 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Grid | 11 |
| FormItem | 7 |
| CustomDropdown | 4 |
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
| MSG00429 | 1 |
| MSG01371 | 1 |
| MSG01370 | 1 |
| LBL00112 | 1 |
| LBL00684 | 1 |
| LBL00682 | 1 |
| LBL00069 | 1 |
| LBL00066 | 1 |
| LBL00001 | 1 |
| LBL00030 | 1 |
| LBL00021 | 1 |
| LBL00068 | 1 |
| LBL01103 | 1 |
| LBL01137 | 1 |
| LBL01138 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: SCP0085(3), SCP0084(2)
- SP/PKG: SCP0085_GET_SEARCH_INFO(2), SCP0084_GET_MONTH_RANGE(2), P_YYYYMMDD(1), PKG_SCP0084(1), PKG_SCP0085(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| code | `(v) => v && dayjs.isDayjs(v) && …` 가드라 키보드로 기간을 지우면(빈값) onChange 를 호출하지 | features/supply/src/pages/ending-inventory/components/EndingInventoryForm.tsx | 148 |

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

