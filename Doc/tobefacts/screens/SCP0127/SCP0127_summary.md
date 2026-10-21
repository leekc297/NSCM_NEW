# SCP0127 — To-Be Fact Pack 요약

- page_key: `supply/precede-safety-stock-day` · feature: supply · As-is Fact Pack 없음(화면ID 미대응)
- 파일 11 · 엔드포인트 호출 9 (미해결 0, 주석 속 4) · 이벤트 16 · 컴포넌트 사용 33 · 하드코딩 컬럼 0 · 메시지 21
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 0건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/supply/src/pages/precede-safety-stock-day/components/PrecedeSafetyStockDayForm.tsx | component | 303 |
| features/supply/src/pages/precede-safety-stock-day/components/PrecedeSafetyStockDayGrid.tsx | component | 233 |
| features/supply/src/pages/precede-safety-stock-day/index.ts | index | 2 |
| features/supply/src/pages/precede-safety-stock-day/precede-safety-stock-day.constants.ts | constants | 115 |
| features/supply/src/pages/precede-safety-stock-day/precede-safety-stock-day.types.ts | types | 16 |
| features/supply/src/pages/precede-safety-stock-day/PrecedeSafetyStockDay.tsx | page | 230 |
| features/supply/src/pages/precede-safety-stock-day/usePrecedeSafetyStockDayStore.ts | store | 167 |
| features/supply/src/pages/precede-safety-stock-day/utils/precede-safety-stock-day.util.ts | util | 109 |
| features/supply/src/pages/precede-safety-stock-day/utils/precedeSafetyStockDayEditLock.ts | util | 60 |
| features/supply/src/pages/precede-safety-stock-day/utils/precedeSafetyStockDaySaveRequest.ts | util | 122 |
| features/supply/src/pages/precede-safety-stock-day/utils/precedeSafetyStockDaySaveValidation.ts | util | 101 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueries) | hook | 3 | Y | PrecedeSafetyStockDayForm.tsx:57 PrecedeSafetyStockDayForm.tsx:60 PrecedeSafetyStockDayGrid.tsx:89 |
| SCP0127/init//call-proc | hook | 2 | Y | PrecedeSafetyStockDayForm.tsx:64 PrecedeSafetyStockDayGrid.tsx:101 |
| SCP0127/main//call-proc | hook | 1 | Y | PrecedeSafetyStockDay.tsx:74 |
| /admin/menu/SCP0127/column | http | 1 | Y | usePrecedeSafetyStockDayStore.ts:121 |
| /admin/menu/SCP0127/search-conditions | http | 1 | Y | usePrecedeSafetyStockDayStore.ts:147 |
| /SCP0127/main/SAVE/call-proc | http | 1 | Y | precedeSafetyStockDaySaveRequest.ts:108 |

## 3. procedures.d.ts 등재 시트
| sheet | request_keys | response_cursors | sp_hints |
|---|---|---|---|
| main | divisionId planGroupId scmSiteId itemId stage validYn valueType periodFrom periodTo | o_rc1 | SCP0127_GET_PRECEDE_SAFETY_STOCK_DAY SCP0127_SAVE_PRECEDE_SAFETY_STOCK_DAY PKG_SCP0127 |
| init | divisionId scmSiteId | o_rc1 o_rc2 o_rc3 o_rc4 o_rc5 o_rc6 | PKG_SCP0127 P_SCP0127_GET_SEARCH_INFO SCP0127_GET_PRECEDE_SAFETY_STOCK_DAY SCP0127_SAVE_PRECEDE_SAFETY_STOCK_DAY |

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| SearchArea | onSearch | onSearch | jsx | features/supply/src/pages/precede-safety-stock-day/components/PrecedeSafetyStockDayForm.tsx | 131 |
| CustomDropdown | onChange | <arrow> confirmIfDirtyKey(tabDirtyKey(tabId),'search').then,confirmIfDirtyKey,tabDirtyKey,setDivision | jsx | features/supply/src/pages/precede-safety-stock-day/components/PrecedeSafetyStockDayForm.tsx | 147 |
| CustomDropdown | onChange | <arrow> setSearchParams | jsx | features/supply/src/pages/precede-safety-stock-day/components/PrecedeSafetyStockDayForm.tsx | 168 |
| CustomDropdown | onChange | <arrow> setSearchParams | jsx | features/supply/src/pages/precede-safety-stock-day/components/PrecedeSafetyStockDayForm.tsx | 184 |
| CustomDropdown | onChange | <arrow> setSearchParams | jsx | features/supply/src/pages/precede-safety-stock-day/components/PrecedeSafetyStockDayForm.tsx | 201 |
| CustomDropdown | onChange | <arrow> setSearchParams | jsx | features/supply/src/pages/precede-safety-stock-day/components/PrecedeSafetyStockDayForm.tsx | 223 |
| InputField | onChange | <arrow> setSearchParams | jsx | features/supply/src/pages/precede-safety-stock-day/components/PrecedeSafetyStockDayForm.tsx | 256 |
| FunctionSearchIcon | onClick | <arrow> setOpenItemModal | jsx | features/supply/src/pages/precede-safety-stock-day/components/PrecedeSafetyStockDayForm.tsx | 250 |
| PeriodRangePicker | onChange | <arrow> setSearchParams | jsx | features/supply/src/pages/precede-safety-stock-day/components/PrecedeSafetyStockDayForm.tsx | 266 |
| CustomDropdown | onChange | <arrow> setSearchParams | jsx | features/supply/src/pages/precede-safety-stock-day/components/PrecedeSafetyStockDayForm.tsx | 282 |
| g | updatedLayout | apply | addHandler | features/supply/src/pages/precede-safety-stock-day/components/PrecedeSafetyStockDayGrid.tsx | 125 |
| g | beginningEdit | beginningEditHandler | addHandler | features/supply/src/pages/precede-safety-stock-day/components/PrecedeSafetyStockDayGrid.tsx | 153 |
| g | pastingCell | beginningEditHandler | addHandler | features/supply/src/pages/precede-safety-stock-day/components/PrecedeSafetyStockDayGrid.tsx | 154 |
| g | pastedCell | pastedCellHandler | addHandler | features/supply/src/pages/precede-safety-stock-day/components/PrecedeSafetyStockDayGrid.tsx | 171 |
| g | updatedLayout | applyDateColumnTypes | addHandler | features/supply/src/pages/precede-safety-stock-day/components/PrecedeSafetyStockDayGrid.tsx | 175 |
| PrecedeSafetyStockDayGrid | onItemModalOpenChange | setItemModalOpen | jsx | features/supply/src/pages/precede-safety-stock-day/PrecedeSafetyStockDay.tsx | 225 |

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
| PrecedeSafetyStockDayForm | 1 |
| SubTitle | 1 |
| PrecedeSafetyStockDayGrid | 1 |

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
| LBL00002 | 1 |
| LBL00061 | 1 |
| LBL00013 | 1 |
| LBL00618 | 1 |
| LBL00007 | 1 |
| MSG00013 | 1 |
| MSG00260 | 1 |
| MSG00046 | 1 |
| MSG00219 | 1 |
| MSG00085 | 1 |
| MSG00458 | 1 |
| MSG00004 | 1 |
| MSG00003 | 1 |
| MSG00002 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: SCP0128(9), SCP0127(8), SCP0025(3), SCP0001(2), SDM5010(2), SCP0124(2), SCP0006(2), SCP0011(2), SCP0122(1), SCP0123(1)
- SP/PKG: PKG_SCP0127(5), P_SCP0127_GET_SEARCH_INFO(2), P_SCP0127_SAVE_PRECEDE_SAFETY_STOCK_DAY(1), P_USER_ID(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| endpoint | 조회조건 콤보 SQL_ID — design/02_search-combo.md §2·§5 실측 확정분만 배선한다. DIVISION: AS-IS `BLUtils.GetDivision(false, "")` 의 정본 SQL_ID 를 소스 미확보로 확정하지 못했다(Division_SCP 유력 후보, §2-1). SCP0124 선례와 동일하게 인자 시그니처가 가장 근접한 `Division_SCP`(DB 실측 등록 확인)을 채택한다 — 확 | features/supply/src/pages/precede-safety-stock-day/precede-safety-stock-day.constants.ts | 25 |
| endpoint | SCP0127 Precede/Safety Stock Day — 단일 그리드 CRUD 마스터(SCP0122 계열 구조). 보완(iter-2 gap-resolve) 판정 — convert-flow/goal.md ①. domain 은 이번 회차 `05_register.sql` 실행으로 `SCM_ADM_MNU_M`(UPPR_MNU_ID='Supply_Master') 등록 후 재실측(`Supply_Master`→`Supply`)으로 * | features/supply/src/pages/precede-safety-stock-day/PrecedeSafetyStockDay.tsx | 24 |
| code | buttonGuards#1 — fps==null(선택 행 없음) 시 무동작 return(design/01_layout.md §2 #3). | features/supply/src/pages/precede-safety-stock-day/PrecedeSafetyStockDay.tsx | 126 |
| endpoint | 공용 useProcMutation({data:[rows]}) 로는 전부 null 바인딩돼 조용히 no-op 된다 — 전용 조립 util 로 | features/supply/src/pages/precede-safety-stock-day/PrecedeSafetyStockDay.tsx | 134 |
| endpoint | → 공용 useProcMutation({data:[rows]}) 로는 top-level 에 activeFlag/divisionId... 키가 없어 전부 | features/supply/src/pages/precede-safety-stock-day/utils/precedeSafetyStockDaySaveRequest.ts | 5 |

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

