# SSP0017 — To-Be Fact Pack 요약

- page_key: `shipping/inventory-raw` · feature: shipping · As-is Fact Pack 없음(화면ID 미대응)
- 파일 8 · 엔드포인트 호출 5 (미해결 0, 주석 속 0) · 이벤트 9 · 컴포넌트 사용 25 · 하드코딩 컬럼 0 · 메시지 8
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 0건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/shipping/src/pages/inventory-raw/components/InventoryRawForm.tsx | component | 163 |
| features/shipping/src/pages/inventory-raw/components/InventoryRawGrid.tsx | component | 47 |
| features/shipping/src/pages/inventory-raw/index.ts | index | 2 |
| features/shipping/src/pages/inventory-raw/inventory-raw.constants.ts | constants | 68 |
| features/shipping/src/pages/inventory-raw/inventory-raw.types.ts | types | 14 |
| features/shipping/src/pages/inventory-raw/InventoryRaw.tsx | page | 153 |
| features/shipping/src/pages/inventory-raw/useInventoryRawStore.ts | store | 140 |
| features/shipping/src/pages/inventory-raw/__asis-mapping__.md | mapping | 55 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueries) | hook | 1 | Y | InventoryRawForm.tsx:41 |
| (useTabLookupQueries) | hook | 1 | Y | InventoryRawForm.tsx:46 |
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
| SearchArea | onSearch | onSearch | jsx | features/shipping/src/pages/inventory-raw/components/InventoryRawForm.tsx | 55 |
| CustomDropdown | onChange | <arrow> set,String(picked??'').split(',').filter,String(picked??'').split,String | jsx | features/shipping/src/pages/inventory-raw/components/InventoryRawForm.tsx | 83 |
| CustomDropdown | onChange | <arrow> set,String | jsx | features/shipping/src/pages/inventory-raw/components/InventoryRawForm.tsx | 106 |
| InputField | onChange | <arrow> set | jsx | features/shipping/src/pages/inventory-raw/components/InventoryRawForm.tsx | 132 |
| InputField | onKeyDown | <arrow> onSearch | jsx | features/shipping/src/pages/inventory-raw/components/InventoryRawForm.tsx | 133 |
| FunctionSearchIcon | onClick | onItemSearch | jsx | features/shipping/src/pages/inventory-raw/components/InventoryRawForm.tsx | 128 |
| CustomDropdown | onChange | <arrow> set,String | jsx | features/shipping/src/pages/inventory-raw/components/InventoryRawForm.tsx | 153 |
| InventoryRawForm | onSearch | handleSearch | jsx | features/shipping/src/pages/inventory-raw/InventoryRaw.tsx | 122 |
| InventoryRawForm | onItemSearch | <arrow> setOpenItemModal | jsx | features/shipping/src/pages/inventory-raw/InventoryRaw.tsx | 122 |

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
| ItemByDivisionModal | 1 |

## 6. 하드코딩 Grid 컬럼
(없음)

## 7. 메시지 코드
| code | count |
|---|---|
| LBL00001 | 1 |
| LBL00005 | 1 |
| LBL01087 | 1 |
| LBL00669 | 1 |
| LBL00039 | 1 |
| LBL00112 | 1 |
| LBL00310 | 1 |
| MSG00614 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: SSP0001(2), SCP0053(2), SSP0017(1), DMF0004(1)
- SP/PKG: SSP0017_GET_INVENTORY_RAW(3)
## 9. 주석 처리된 코드 (현행 기능 아님)
(없음)

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

