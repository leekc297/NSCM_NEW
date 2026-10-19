# SCP0084 — To-Be Fact Pack 요약

- page_key: `supply/long-term-stock` · feature: supply · As-is Fact Pack 있음
- 파일 9 · 엔드포인트 호출 5 (미해결 0, 주석 속 0) · 이벤트 9 · 컴포넌트 사용 18 · 하드코딩 컬럼 0 · 메시지 13
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 0건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/supply/src/pages/long-term-stock/components/LongTermStockForm.tsx | component | 259 |
| features/supply/src/pages/long-term-stock/components/LongTermStockGrid.tsx | component | 101 |
| features/supply/src/pages/long-term-stock/hooks/useLongTermStockValidation.ts | hook | 28 |
| features/supply/src/pages/long-term-stock/index.ts | index | 2 |
| features/supply/src/pages/long-term-stock/long-term-stock.constants.ts | constants | 122 |
| features/supply/src/pages/long-term-stock/long-term-stock.types.ts | types | 15 |
| features/supply/src/pages/long-term-stock/LongTermStock.tsx | page | 186 |
| features/supply/src/pages/long-term-stock/useLongTermStockStore.ts | store | 136 |
| features/supply/src/pages/long-term-stock/__asis-mapping__.md | mapping | 58 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueries) | hook | 1 | Y | LongTermStockForm.tsx:58 |
| SCP0084/main//call-proc | hook | 1 | Y | LongTermStock.tsx:46 |
| /SCP0084/main/SAVE/call-proc | http | 1 | Y | LongTermStock.tsx:97 |
| /admin/menu/SCP0084/column | http | 1 | Y | useLongTermStockStore.ts:99 |
| /admin/menu/SCP0084/search-conditions | http | 1 | Y | useLongTermStockStore.ts:116 |

## 3. procedures.d.ts 등재 시트
| sheet | request_keys | response_cursors | sp_hints |
|---|---|---|---|
| main | yyyymm divisionId plantId longTermTypeCode debugMode | o_rc1 | SCP0084_GET_LONG_TERM_STOCK SCP0084_SAVE_LONG_TERM_STOCK_MEMO_ROW_DATASET PKG_SCP0084 |

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| SearchArea | onSearch | onSearch | jsx | features/supply/src/pages/long-term-stock/components/LongTermStockForm.tsx | 161 |
| DatePickerCalendar | onChange | <arrow> date?.format,set | jsx | features/supply/src/pages/long-term-stock/components/LongTermStockForm.tsx | 179 |
| CustomDropdown | onChange | <arrow> set | jsx | features/supply/src/pages/long-term-stock/components/LongTermStockForm.tsx | 211 |
| CustomDropdown | onChange | <arrow> set | jsx | features/supply/src/pages/long-term-stock/components/LongTermStockForm.tsx | 230 |
| CustomDropdown | onChange | <arrow> set | jsx | features/supply/src/pages/long-term-stock/components/LongTermStockForm.tsx | 249 |
| g | updatedLayout | apply | addHandler | features/supply/src/pages/long-term-stock/components/LongTermStockGrid.tsx | 43 |
| g | beginningEdit | handler | addHandler | features/supply/src/pages/long-term-stock/components/LongTermStockGrid.tsx | 62 |
| g | formatItem | handler | addHandler | features/supply/src/pages/long-term-stock/components/LongTermStockGrid.tsx | 78 |
| LongTermStockForm | onSearch | handleSearch | jsx | features/supply/src/pages/long-term-stock/LongTermStock.tsx | 162 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Grid | 4 |
| FormItem | 4 |
| CustomDropdown | 3 |
| SearchArea | 1 |
| DatePickerCalendar | 1 |
| DataGrid | 1 |
| MainTitle | 1 |
| LongTermStockForm | 1 |
| SubTitle | 1 |
| LongTermStockGrid | 1 |

## 6. 하드코딩 Grid 컬럼
(없음)

## 7. 메시지 코드
| code | count |
|---|---|
| MSG00013 | 1 |
| LBL00066 | 1 |
| LBL00001 | 1 |
| LBL00030 | 1 |
| LBL00067 | 1 |
| LBL00112 | 1 |
| LBL00414 | 1 |
| MSG00097 | 1 |
| MSG00719 | 1 |
| MSG00004 | 1 |
| MSG00003 | 2 |
| MSG00002 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: SCP0084(3), SCP0006(1)
- SP/PKG: PKG_SCP0084(2), SCP0084_GET_MONTH_RANGE(2), SCP0084_GET_LONG_TERM_STOCK(1), SCP0084_SAVE_LONG_TERM_STOCK_MEMO_ROW_DATASET(1), P_SCP0084_SAVE_LONG_TERM_STOCK_MEMO_ROW_DATASET(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
(없음)

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

