# SCP0084 — To-Be Fact Pack 요약

- page_key: `supply/long-term-stock` · feature: supply · As-is Fact Pack 있음
- 파일 9 · 엔드포인트 호출 5 (미해결 0, 주석 속 0) · 이벤트 10 · 컴포넌트 사용 18 · 하드코딩 컬럼 0 · 메시지 13
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 0건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/supply/src/pages/long-term-stock/components/LongTermStockForm.tsx | component | 279 |
| features/supply/src/pages/long-term-stock/components/LongTermStockGrid.tsx | component | 151 |
| features/supply/src/pages/long-term-stock/hooks/useLongTermStockValidation.ts | hook | 28 |
| features/supply/src/pages/long-term-stock/index.ts | index | 2 |
| features/supply/src/pages/long-term-stock/long-term-stock.constants.ts | constants | 123 |
| features/supply/src/pages/long-term-stock/long-term-stock.types.ts | types | 15 |
| features/supply/src/pages/long-term-stock/LongTermStock.tsx | page | 186 |
| features/supply/src/pages/long-term-stock/useLongTermStockStore.ts | store | 155 |
| features/supply/src/pages/long-term-stock/__asis-mapping__.md | mapping | 58 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueries) | hook | 1 | Y | LongTermStockForm.tsx:59 |
| SCP0084/main//call-proc | hook | 1 | Y | LongTermStock.tsx:46 |
| /SCP0084/main/SAVE/call-proc | http | 1 | Y | LongTermStock.tsx:97 |
| /admin/menu/SCP0084/column | http | 1 | Y | useLongTermStockStore.ts:118 |
| /admin/menu/SCP0084/search-conditions | http | 1 | Y | useLongTermStockStore.ts:135 |

## 3. procedures.d.ts 등재 시트
| sheet | request_keys | response_cursors | sp_hints |
|---|---|---|---|
| main | yyyymm divisionId plantId longTermTypeCode debugMode | o_rc1 | SCP0084_GET_LONG_TERM_STOCK SCP0084_SAVE_LONG_TERM_STOCK_MEMO_ROW_DATASET PKG_SCP0084 |

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| SearchArea | onSearch | onSearch | jsx | features/supply/src/pages/long-term-stock/components/LongTermStockForm.tsx | 181 |
| DatePickerCalendar | onChange | <arrow> date?.format,set | jsx | features/supply/src/pages/long-term-stock/components/LongTermStockForm.tsx | 199 |
| CustomDropdown | onChange | <arrow> set | jsx | features/supply/src/pages/long-term-stock/components/LongTermStockForm.tsx | 231 |
| CustomDropdown | onChange | <arrow> set | jsx | features/supply/src/pages/long-term-stock/components/LongTermStockForm.tsx | 250 |
| CustomDropdown | onChange | <arrow> set | jsx | features/supply/src/pages/long-term-stock/components/LongTermStockForm.tsx | 269 |
| g | updatedLayout | apply | addHandler | features/supply/src/pages/long-term-stock/components/LongTermStockGrid.tsx | 92 |
| g | beginningEdit | handler | addHandler | features/supply/src/pages/long-term-stock/components/LongTermStockGrid.tsx | 111 |
| g | formatItem | handler | addHandler | features/supply/src/pages/long-term-stock/components/LongTermStockGrid.tsx | 127 |
| DataGrid | initialized | handleInitialized | jsx | features/supply/src/pages/long-term-stock/components/LongTermStockGrid.tsx | 141 |
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
- 화면ID: SCP0084(3), SCP0006(1), SCP0001(1), SSP0005(1)
- SP/PKG: PKG_SCP0084(2), SCP0084_GET_MONTH_RANGE(2), SCP0084_GET_LONG_TERM_STOCK(1), SCP0084_SAVE_LONG_TERM_STOCK_MEMO_ROW_DATASET(1), P_SCP0084_SAVE_LONG_TERM_STOCK_MEMO_ROW_DATASET(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| code | const plantOptions = useMemo(() => { | features/supply/src/pages/long-term-stock/components/LongTermStockForm.tsx | 137 |
| code | const selected = toSelectedSet(sc.divisionId); | features/supply/src/pages/long-term-stock/components/LongTermStockForm.tsx | 138 |
| code | const filtered = (plantsAllRaw ?? []).filter(r => { | features/supply/src/pages/long-term-stock/components/LongTermStockForm.tsx | 139 |
| code | if (str(r.CODE).trim() === '') return false; | features/supply/src/pages/long-term-stock/components/LongTermStockForm.tsx | 140 |
| code | if (selected.size === 0) return true; | features/supply/src/pages/long-term-stock/components/LongTermStockForm.tsx | 141 |
| code | return selected.has(str(r.DIVISION_ID)); | features/supply/src/pages/long-term-stock/components/LongTermStockForm.tsx | 142 |
| code | }); | features/supply/src/pages/long-term-stock/components/LongTermStockForm.tsx | 143 |
| code | return toOptions(filtered); | features/supply/src/pages/long-term-stock/components/LongTermStockForm.tsx | 144 |
| code | }, [plantsAllRaw, sc.divisionId]); | features/supply/src/pages/long-term-stock/components/LongTermStockForm.tsx | 145 |
| code | import { COL, MEMO_EDITABLE_BG, MERGE_COLUMNS } from '../long-term-stock.constants'; | features/supply/src/pages/long-term-stock/components/LongTermStockGrid.tsx | 17 |
| code | const apply = () => { | features/supply/src/pages/long-term-stock/components/LongTermStockGrid.tsx | 77 |
| code | for (const col of g.columns) { | features/supply/src/pages/long-term-stock/components/LongTermStockGrid.tsx | 78 |
| code | if (!col.binding) continue; | features/supply/src/pages/long-term-stock/components/LongTermStockGrid.tsx | 79 |
| code | col.allowMerging = MERGE_COLUMNS.has(col.binding); | features/supply/src/pages/long-term-stock/components/LongTermStockGrid.tsx | 80 |
| code | }; | features/supply/src/pages/long-term-stock/components/LongTermStockGrid.tsx | 82 |
| code | export const MERGE_COLUMNS: ReadonlySet<string> = new Set([ | features/supply/src/pages/long-term-stock/long-term-stock.constants.ts | 102 |
| code | ]); | features/supply/src/pages/long-term-stock/long-term-stock.constants.ts | 107 |

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

