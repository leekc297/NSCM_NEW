# SSP0017 — To-Be Fact Pack 요약

- page_key: `shipping/inventory-raw` · feature: shipping · As-is Fact Pack 있음
- 파일 8 · 엔드포인트 호출 5 (미해결 0, 주석 속 0) · 이벤트 10 · 컴포넌트 사용 25 · 하드코딩 컬럼 0 · 메시지 8
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 0건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/shipping/src/pages/inventory-raw/components/InventoryRawForm.tsx | component | 198 |
| features/shipping/src/pages/inventory-raw/components/InventoryRawGrid.tsx | component | 118 |
| features/shipping/src/pages/inventory-raw/index.ts | index | 2 |
| features/shipping/src/pages/inventory-raw/inventory-raw.constants.ts | constants | 83 |
| features/shipping/src/pages/inventory-raw/inventory-raw.types.ts | types | 14 |
| features/shipping/src/pages/inventory-raw/InventoryRaw.tsx | page | 176 |
| features/shipping/src/pages/inventory-raw/useInventoryRawStore.ts | store | 140 |
| features/shipping/src/pages/inventory-raw/__asis-mapping__.md | mapping | 79 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueries) | hook | 1 | Y | InventoryRawForm.tsx:56 |
| (useTabLookupQueries) | hook | 1 | Y | InventoryRawForm.tsx:61 |
| SSP0017/main//call-proc | hook | 1 | Y | InventoryRaw.tsx:46 |
| /admin/menu/SSP0017/column | http | 1 | Y | useInventoryRawStore.ts:86 |
| /admin/menu/SSP0017/search-conditions | http | 1 | Y | useInventoryRawStore.ts:115 |

## 3. procedures.d.ts 등재 시트
| sheet | request_keys | response_cursors | sp_hints |
|---|---|---|---|
| main | divisionId plantSite itemId inventoryType planStartYyyymmdd | o_rc1 | SSP0017_GET_INVENTORY_RAW |

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| SearchArea | onSearch | onSearch | jsx | features/shipping/src/pages/inventory-raw/components/InventoryRawForm.tsx | 90 |
| CustomDropdown | onChange | <arrow> set,String(picked??'').split(',').filter,String(picked??'').split,String | jsx | features/shipping/src/pages/inventory-raw/components/InventoryRawForm.tsx | 119 |
| InputField | onChange | <arrow> set | jsx | features/shipping/src/pages/inventory-raw/components/InventoryRawForm.tsx | 153 |
| Button | onClick | onItemSearch | jsx | features/shipping/src/pages/inventory-raw/components/InventoryRawForm.tsx | 149 |
| CustomDropdown | onChange | <arrow> set,String | jsx | features/shipping/src/pages/inventory-raw/components/InventoryRawForm.tsx | 170 |
| CustomDropdown | onChange | <arrow> set,String | jsx | features/shipping/src/pages/inventory-raw/components/InventoryRawForm.tsx | 188 |
| grid | updatedLayout | applyAggregates | addHandler | features/shipping/src/pages/inventory-raw/components/InventoryRawGrid.tsx | 90 |
| grid | formatItem | formatFooter | addHandler | features/shipping/src/pages/inventory-raw/components/InventoryRawGrid.tsx | 91 |
| InventoryRawForm | onSearch | handleSearch | jsx | features/shipping/src/pages/inventory-raw/InventoryRaw.tsx | 134 |
| InventoryRawForm | onItemSearch | <arrow> setOpenItemModal | jsx | features/shipping/src/pages/inventory-raw/InventoryRaw.tsx | 134 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Grid | 5 |
| FormItem | 5 |
| CustomDropdown | 4 |
| SearchArea | 1 |
| InputField | 1 |
| Button | 1 |
| FunctionSearchIcon | 1 |
| DataGrid | 1 |
| IcMeasureSelect | 1 |
| MainTitle | 1 |
| InventoryRawForm | 1 |
| SubTitle | 1 |
| InventoryRawGrid | 1 |
| MaterialByDivisionModal | 1 |

## 6. 하드코딩 Grid 컬럼
(없음)

## 7. 메시지 코드
| code | count |
|---|---|
| LBL00001 | 1 |
| LBL00022 | 1 |
| LBL01087 | 1 |
| LBL00618 | 1 |
| LBL00039 | 1 |
| LBL00112 | 1 |
| LBL00310 | 1 |
| MSG00614 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: SSP0021(2), SSP0001(2), SCP0053(2), SSP0015(1), DMF0045(1), SSP0019(1), SSP0017(1), DMF0004(1)
- SP/PKG: SSP0017_GET_INVENTORY_RAW(3)
## 9. 주석 처리된 코드 (현행 기능 아님)
(없음)

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

