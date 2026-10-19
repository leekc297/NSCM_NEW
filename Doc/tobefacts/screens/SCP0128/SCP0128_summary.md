# SCP0128 — To-Be Fact Pack 요약

- page_key: `supply/safety-stock` · feature: supply · As-is Fact Pack 있음
- 파일 13 · 엔드포인트 호출 9 (미해결 0, 주석 속 4) · 이벤트 16 · 컴포넌트 사용 33 · 하드코딩 컬럼 0 · 메시지 20
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 0건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/supply/src/pages/safety-stock/components/SafetyStockForm.tsx | component | 276 |
| features/supply/src/pages/safety-stock/components/SafetyStockGrid.tsx | component | 220 |
| features/supply/src/pages/safety-stock/index.ts | index | 2 |
| features/supply/src/pages/safety-stock/safety-stock.constants.ts | constants | 90 |
| features/supply/src/pages/safety-stock/safety-stock.types.ts | types | 26 |
| features/supply/src/pages/safety-stock/SafetyStock.tsx | page | 218 |
| features/supply/src/pages/safety-stock/useSafetyStockStore.ts | store | 174 |
| features/supply/src/pages/safety-stock/utils/safety-stock.util.ts | util | 73 |
| features/supply/src/pages/safety-stock/utils/safetyStockDivisionMap.ts | util | 22 |
| features/supply/src/pages/safety-stock/utils/safetyStockEditLock.ts | util | 56 |
| features/supply/src/pages/safety-stock/utils/safetyStockSaveRequest.ts | util | 119 |
| features/supply/src/pages/safety-stock/utils/safetyStockSaveValidation.ts | util | 108 |
| features/supply/src/pages/safety-stock/__asis-mapping__.md | mapping | 177 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueries) | hook | 3 | Y | SafetyStockForm.tsx:43 SafetyStockForm.tsx:46 SafetyStockGrid.tsx:82 |
| SCP0128/init//call-proc | hook | 2 | Y | SafetyStockForm.tsx:51 SafetyStockGrid.tsx:94 |
| SCP0128/main//call-proc | hook | 1 | Y | SafetyStock.tsx:66 |
| /admin/menu/SCP0128/column | http | 1 | Y | useSafetyStockStore.ts:132 |
| /admin/menu/SCP0128/search-conditions | http | 1 | Y | useSafetyStockStore.ts:153 |
| /SCP0128/main/SAVE/call-proc | http | 1 | Y | safetyStockSaveRequest.ts:105 |

## 3. procedures.d.ts 등재 시트
| sheet | request_keys | response_cursors | sp_hints |
|---|---|---|---|
| main | divisionId planGroupId scmSiteId itemId stage validYn valueType periodFrom periodTo | o_rc1 | PKG_SCP0128 P_SCP0128_GET_SAFETY_STOCK P_SCP0128_GET_SEARCH_INFO |
| init | divisionId scmSiteId | o_rc1 o_rc2 o_rc3 o_rc4 o_rc5 o_rc6 o_rc7 | PKG_SCP0128 P_SCP0128_GET_SAFETY_STOCK P_SCP0128_GET_SEARCH_INFO |

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| SearchArea | onSearch | onSearch | jsx | features/supply/src/pages/safety-stock/components/SafetyStockForm.tsx | 113 |
| CustomDropdown | onChange | <arrow> setSearchParams | jsx | features/supply/src/pages/safety-stock/components/SafetyStockForm.tsx | 126 |
| CustomDropdown | onChange | <arrow> setSearchParams | jsx | features/supply/src/pages/safety-stock/components/SafetyStockForm.tsx | 145 |
| CustomDropdown | onChange | <arrow> setSearchParams | jsx | features/supply/src/pages/safety-stock/components/SafetyStockForm.tsx | 160 |
| CustomDropdown | onChange | <arrow> setSearchParams | jsx | features/supply/src/pages/safety-stock/components/SafetyStockForm.tsx | 175 |
| CustomDropdown | onChange | <arrow> setSearchParams | jsx | features/supply/src/pages/safety-stock/components/SafetyStockForm.tsx | 199 |
| InputField | onChange | <arrow> setSearchParams | jsx | features/supply/src/pages/safety-stock/components/SafetyStockForm.tsx | 230 |
| FunctionSearchIcon | onClick | <arrow> setOpenItemModal | jsx | features/supply/src/pages/safety-stock/components/SafetyStockForm.tsx | 224 |
| PeriodRangePicker | onChange | <arrow> setSearchParams | jsx | features/supply/src/pages/safety-stock/components/SafetyStockForm.tsx | 240 |
| CustomDropdown | onChange | <arrow> setSearchParams | jsx | features/supply/src/pages/safety-stock/components/SafetyStockForm.tsx | 255 |
| g | updatedLayout | apply | addHandler | features/supply/src/pages/safety-stock/components/SafetyStockGrid.tsx | 118 |
| g | beginningEdit | beginningEditHandler | addHandler | features/supply/src/pages/safety-stock/components/SafetyStockGrid.tsx | 139 |
| g | pastingCell | beginningEditHandler | addHandler | features/supply/src/pages/safety-stock/components/SafetyStockGrid.tsx | 140 |
| g | pastedCell | pastedCellHandler | addHandler | features/supply/src/pages/safety-stock/components/SafetyStockGrid.tsx | 156 |
| g | updatedLayout | applyDateColumnTypes | addHandler | features/supply/src/pages/safety-stock/components/SafetyStockGrid.tsx | 160 |
| SafetyStockGrid | onItemModalOpenChange | setItemModalOpen | jsx | features/supply/src/pages/safety-stock/SafetyStock.tsx | 213 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Grid | 8 |
| FormItem | 7 |
| CustomDropdown | 6 |
| MaterialByDivisionModal | 2 |
| SearchArea | 1 |
| InputField | 1 |
| Button | 1 |
| FunctionSearchIcon | 1 |
| PeriodRangePicker | 1 |
| DataGrid | 1 |
| MainTitle | 1 |
| SafetyStockForm | 1 |
| SubTitle | 1 |
| SafetyStockGrid | 1 |

## 6. 하드코딩 Grid 컬럼
(없음)

## 7. 메시지 코드
| code | count |
|---|---|
| MSG00614 | 3 |
| LBL00112 | 1 |
| LBL00001 | 1 |
| LBL00016 | 1 |
| LBL00052 | 1 |
| LBL00061 | 1 |
| LBL00002 | 1 |
| LBL00013 | 1 |
| LBL00007 | 1 |
| LBL00618 | 1 |
| MSG00001 | 1 |
| MSG00260 | 1 |
| MSG00046 | 1 |
| MSG00219 | 1 |
| MSG00085 | 1 |
| MSG00458 | 1 |
| MSG00003 | 1 |
| MSG00002 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: SCP0127(9), SCP0128(6), SCP0001(2), SDM5010(2), SCP0122(2), SCP0006(2), SCP0011(2), SCP0125(1), SCP0126(1), SCP0002(1)
- SP/PKG: PKG_SCP0128(10), P_SCP0128_GET_SEARCH_INFO(5), P_SCP0128_SAVE_SAFETY_STOCK(2), P_SCP0128_GET_SAFETY_STOCK(1), SCP0128_GET_SEARCH_INFO(1), P_USER_ID(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| endpoint | 조회조건 콤보 SQL_ID — design/02_search-combo.md §2·§5 실측 확정분만 배선한다. DIVISION: SP직접 SQL_ID, AS-IS `BLUtils.GetDivision(false,"")` ↔ TO-BE 1:1 확정(§2-1, EE 포함 유지 — WithoutEE 아님). PLAN_GROUP: `PlanGroup` — GAP-01 해소(react-gap-audit fail, 본 회차 재확인 완료 | features/supply/src/pages/safety-stock/safety-stock.constants.ts | 35 |
| endpoint | SCP0128 Safety Stock — 단일 그리드 CRUD 마스터(SCP0122/SCP0127 계열 구조). 신규(NEW) 판정 — convert-flow/goal.md ①. domain=SCP(형제 트리 실측 + namespace + SCP0122 선례 3중 근거, 00_checklist.md §0). nscmPath 는 goal.md ①에서 확정한 `features/supply/src/ pages/safety-stock | features/supply/src/pages/safety-stock/SafetyStock.tsx | 21 |
| code | buttonGuards#1 — fps==null(선택 행 없음) 시 무동작 return(design/01_layout.md §2 L4). | features/supply/src/pages/safety-stock/SafetyStock.tsx | 118 |
| endpoint | 공용 useProcMutation({data:[rows]}) 로는 전부 null 바인딩돼 조용히 no-op 된다 — 전용 조립 util 로 | features/supply/src/pages/safety-stock/SafetyStock.tsx | 126 |
| endpoint | → 공용 useProcMutation({data:[rows]}) 로는 top-level 에 activeFlag/divisionId... 키가 없어 전부 | features/supply/src/pages/safety-stock/utils/safetyStockSaveRequest.ts | 5 |

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

