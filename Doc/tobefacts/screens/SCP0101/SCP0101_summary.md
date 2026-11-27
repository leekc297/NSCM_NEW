# SCP0101 — To-Be Fact Pack 요약

- page_key: `supply/inventory-trend` · feature: supply · As-is Fact Pack 있음
- 파일 8 · 엔드포인트 호출 4 (미해결 0, 주석 속 0) · 이벤트 17 · 컴포넌트 사용 24 · 하드코딩 컬럼 0 · 메시지 9
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 0건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/supply/src/pages/inventory-trend/components/InventoryTrendForm.tsx | component | 258 |
| features/supply/src/pages/inventory-trend/components/InventoryTrendGrid.tsx | component | 299 |
| features/supply/src/pages/inventory-trend/index.ts | index | 2 |
| features/supply/src/pages/inventory-trend/inventory-trend.constants.ts | constants | 207 |
| features/supply/src/pages/inventory-trend/inventory-trend.types.ts | types | 16 |
| features/supply/src/pages/inventory-trend/InventoryTrend.tsx | page | 228 |
| features/supply/src/pages/inventory-trend/useInventoryTrendStore.ts | store | 169 |
| features/supply/src/pages/inventory-trend/__asis-mapping__.md | mapping | 80 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueries) | hook | 1 | Y | InventoryTrendForm.tsx:55 |
| SCP0101/main//call-proc | hook | 1 | Y | InventoryTrend.tsx:58 |
| /admin/menu/SCP0101/column | http | 1 | Y | useInventoryTrendStore.ts:123 |
| /admin/menu/SCP0101/search-conditions | http | 1 | Y | useInventoryTrendStore.ts:147 |

## 3. procedures.d.ts 등재 시트
| sheet | request_keys | response_cursors | sp_hints |
|---|---|---|---|
| main | yyyymm divisionId plantId itemId debugMode | o_rc1 | SCP0101_GET_INVENTORY_TREND PKG_SCP0101 |

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| SearchArea | onSearch | onSearch | jsx | features/supply/src/pages/inventory-trend/components/InventoryTrendForm.tsx | 149 |
| DatePickerCalendar | onChange | <arrow> date?.format,set | jsx | features/supply/src/pages/inventory-trend/components/InventoryTrendForm.tsx | 167 |
| CustomDropdown | onChange | <arrow> set | jsx | features/supply/src/pages/inventory-trend/components/InventoryTrendForm.tsx | 199 |
| CustomDropdown | onChange | <arrow> set | jsx | features/supply/src/pages/inventory-trend/components/InventoryTrendForm.tsx | 218 |
| InputField | onChange | <arrow> set | jsx | features/supply/src/pages/inventory-trend/components/InventoryTrendForm.tsx | 247 |
| Button | onClick | onItemSearch | jsx | features/supply/src/pages/inventory-trend/components/InventoryTrendForm.tsx | 243 |
| g | updatedLayout | apply | addHandler | features/supply/src/pages/inventory-trend/components/InventoryTrendGrid.tsx | 120 |
| g | updatedLayout | apply | addHandler | features/supply/src/pages/inventory-trend/components/InventoryTrendGrid.tsx | 138 |
| g | updatedLayout | apply | addHandler | features/supply/src/pages/inventory-trend/components/InventoryTrendGrid.tsx | 183 |
| g | updatedLayout | apply | addHandler | features/supply/src/pages/inventory-trend/components/InventoryTrendGrid.tsx | 208 |
| g | formatItem | handler | addHandler | features/supply/src/pages/inventory-trend/components/InventoryTrendGrid.tsx | 237 |
| g | formatItem | handler | addHandler | features/supply/src/pages/inventory-trend/components/InventoryTrendGrid.tsx | 275 |
| DataGrid | initialized | handleInitialized | jsx | features/supply/src/pages/inventory-trend/components/InventoryTrendGrid.tsx | 284 |
| InventoryTrendForm | onSearch | handleSearch | jsx | features/supply/src/pages/inventory-trend/InventoryTrend.tsx | 135 |
| InventoryTrendForm | onItemSearch | <arrow> setOpenItem | jsx | features/supply/src/pages/inventory-trend/InventoryTrend.tsx | 135 |
| Checkbox | onChange | <arrow> setSearchParams | jsx | features/supply/src/pages/inventory-trend/InventoryTrend.tsx | 152 |
| ColumnLayoutModal | onSave | <arrow> settings.filter,saveTitleSet({menuId:MENU_ID,sheetName:ADMIN_SHEET_NAME[SHEETS.MAIN],columnType:TITLESET_COLUMN_TYPE,rows:visible.map((s,i)=>({name:s.COLUMN_NAME,sortOrderNo:i+1,colWidth:s.COL_WIDTH,cellColor:s.CELL_COLOR,textColor:s.TEXT_COLOR,})),}).then,saveTitleSet,visible.map,setAlert,t | jsx | features/supply/src/pages/inventory-trend/InventoryTrend.tsx | 200 |

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
| IcGridColumnSetup | 1 |
| MainTitle | 1 |
| InventoryTrendForm | 1 |
| SubTitle | 1 |
| Checkbox | 1 |
| InventoryTrendGrid | 1 |
| MaterialByDivisionModal | 1 |
| ColumnLayoutModal | 1 |

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
| LBL00605 | 1 |
| MSG00618 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: SCP0100(5), SCP0101(4), COM0013(3), SCP0084(3), SCP0006(2), DMF0040(1), SCP0085(1), SCP0053(1)
- SP/PKG: PKG_SCP0101(2), SCP0084_GET_MONTH_RANGE(2), SCP0101_GET_INVENTORY_TREND(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| code | 주의: insert/delete 와 달리 save 는 공용 SubTitle 기본값이 no-op(F7=()=>undefined)이라 false 로 둬도 | features/supply/src/pages/inventory-trend/InventoryTrend.tsx | 102 |

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

