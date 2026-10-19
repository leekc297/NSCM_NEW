# SCP0129 — To-Be Fact Pack 요약

- page_key: `supply/demand-exception` · feature: supply · As-is Fact Pack 있음
- 파일 13 · 엔드포인트 호출 9 (미해결 0, 주석 속 2) · 이벤트 17 · 컴포넌트 사용 30 · 하드코딩 컬럼 0 · 메시지 16
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 0건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/supply/src/pages/demand-exception/components/DemandExceptionForm.tsx | component | 253 |
| features/supply/src/pages/demand-exception/components/DemandExceptionGrid.tsx | component | 272 |
| features/supply/src/pages/demand-exception/demand-exception.constants.ts | constants | 72 |
| features/supply/src/pages/demand-exception/demand-exception.types.ts | types | 25 |
| features/supply/src/pages/demand-exception/DemandException.tsx | page | 216 |
| features/supply/src/pages/demand-exception/index.ts | index | 2 |
| features/supply/src/pages/demand-exception/useDemandExceptionStore.ts | store | 159 |
| features/supply/src/pages/demand-exception/utils/demand-exception.util.ts | util | 34 |
| features/supply/src/pages/demand-exception/utils/demandExceptionEditLock.ts | util | 55 |
| features/supply/src/pages/demand-exception/utils/demandExceptionSaveRequest.ts | util | 109 |
| features/supply/src/pages/demand-exception/utils/demandExceptionSaveValidation.ts | util | 97 |
| features/supply/src/pages/demand-exception/utils/demandExceptionSiteCascade.ts | util | 25 |
| features/supply/src/pages/demand-exception/__asis-mapping__.md | mapping | 139 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueries) | hook | 3 | Y | DemandExceptionForm.tsx:45 DemandExceptionForm.tsx:46 DemandExceptionGrid.tsx:93 |
| SCP0129/init//call-proc | hook | 2 | Y | DemandExceptionForm.tsx:51 DemandExceptionGrid.tsx:106 |
| SCP0129/main//call-proc | hook | 1 | Y | DemandException.tsx:69 |
| /admin/menu/SCP0129/column | http | 1 | Y | useDemandExceptionStore.ts:115 |
| /admin/menu/SCP0129/search-conditions | http | 1 | Y | useDemandExceptionStore.ts:139 |
| /SCP0129/main/SAVE/call-proc | http | 1 | Y | demandExceptionSaveRequest.ts:95 |

## 3. procedures.d.ts 등재 시트
| sheet | request_keys | response_cursors | sp_hints |
|---|---|---|---|
| main | divisionId planGroupId scmSiteId itemId stage validYn periodFrom periodTo | o_rc1 | PKG_SCP0129 P_SCP0129_GET_DEMAND_EXCEPTION P_SCP0129_SAVE_DEMAND_EXCEPTION PKG_SCP0128 P_SCP0128_GET_SEARCH_INFO |
| init | divisionId scmSiteId | o_rc1 o_rc2 o_rc7 o_rc3 o_rc4 o_rc5 o_rc6 | PKG_SCP0129 P_SCP0129_GET_DEMAND_EXCEPTION P_SCP0129_SAVE_DEMAND_EXCEPTION PKG_SCP0128 P_SCP0128_GET_SEARCH_INFO |

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| SearchArea | onSearch | onSearch | jsx | features/supply/src/pages/demand-exception/components/DemandExceptionForm.tsx | 107 |
| CustomDropdown | onChange | <arrow> confirmIfDirtyKey(tabDirtyKey(tabId),'search').then,confirmIfDirtyKey,tabDirtyKey,setDivision | jsx | features/supply/src/pages/demand-exception/components/DemandExceptionForm.tsx | 123 |
| CustomDropdown | onChange | <arrow> setSearchParams | jsx | features/supply/src/pages/demand-exception/components/DemandExceptionForm.tsx | 143 |
| CustomDropdown | onChange | <arrow> setSearchParams | jsx | features/supply/src/pages/demand-exception/components/DemandExceptionForm.tsx | 158 |
| CustomDropdown | onChange | <arrow> setSearchParams | jsx | features/supply/src/pages/demand-exception/components/DemandExceptionForm.tsx | 175 |
| CustomDropdown | onChange | <arrow> setSearchParams | jsx | features/supply/src/pages/demand-exception/components/DemandExceptionForm.tsx | 193 |
| InputField | onChange | <arrow> setSearchParams | jsx | features/supply/src/pages/demand-exception/components/DemandExceptionForm.tsx | 225 |
| FunctionSearchIcon | onClick | <arrow> setOpenItemModal | jsx | features/supply/src/pages/demand-exception/components/DemandExceptionForm.tsx | 219 |
| PeriodRangePicker | onChange | <arrow> setSearchParams | jsx | features/supply/src/pages/demand-exception/components/DemandExceptionForm.tsx | 235 |
| g | updatedLayout | apply | addHandler | features/supply/src/pages/demand-exception/components/DemandExceptionGrid.tsx | 130 |
| g | beginningEdit | beginningEditHandler | addHandler | features/supply/src/pages/demand-exception/components/DemandExceptionGrid.tsx | 151 |
| g | pastingCell | beginningEditHandler | addHandler | features/supply/src/pages/demand-exception/components/DemandExceptionGrid.tsx | 152 |
| g | formatItem | formatItemHandler | addHandler | features/supply/src/pages/demand-exception/components/DemandExceptionGrid.tsx | 167 |
| g | cellEditEnded | cellEditEndedHandler | addHandler | features/supply/src/pages/demand-exception/components/DemandExceptionGrid.tsx | 190 |
| g | pastedCell | pastedCellHandler | addHandler | features/supply/src/pages/demand-exception/components/DemandExceptionGrid.tsx | 206 |
| g | updatedLayout | applyDateColumnTypes | addHandler | features/supply/src/pages/demand-exception/components/DemandExceptionGrid.tsx | 210 |
| DemandExceptionGrid | onItemModalOpenChange | setItemModalOpen | jsx | features/supply/src/pages/demand-exception/DemandException.tsx | 211 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Grid | 7 |
| FormItem | 6 |
| CustomDropdown | 5 |
| MaterialByDivisionModal | 2 |
| SearchArea | 1 |
| InputField | 1 |
| Button | 1 |
| FunctionSearchIcon | 1 |
| PeriodRangePicker | 1 |
| DataGrid | 1 |
| MainTitle | 1 |
| DemandExceptionForm | 1 |
| SubTitle | 1 |
| DemandExceptionGrid | 1 |

## 6. 하드코딩 Grid 컬럼
(없음)

## 7. 메시지 코드
| code | count |
|---|---|
| LBL00112 | 1 |
| LBL00001 | 1 |
| LBL00015 | 1 |
| LBL00061 | 1 |
| LBL00639 | 1 |
| LBL00002 | 1 |
| LBL00618 | 1 |
| LBL00013 | 1 |
| MSG00013 | 1 |
| MSG00219 | 1 |
| MSG00260 | 1 |
| MSG00458 | 1 |
| MSG00002 | 2 |
| MSG00003 | 2 |

## 8. 주석 속 As-is 참조
- 화면ID: SCP0128(24), SCP0129(10), SCP0127(5), SCP0122(3), SCP0001(1), SDM5010(1), SCP0025(1)
- SP/PKG: PKG_SCP0129(8), PKG_SCP0128(6), P_SCP0128_GET_SEARCH_INFO(5), P_SCP0129_SAVE_DEMAND_EXCEPTION(2), P_SCP0129_GET_DEMAND_EXCEPTION(1), SCP0128_GET_SEARCH_INFO(1), P_ACTIVE_FLAG(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| code | SCP0129 Demand Exception — 단일 그리드 CRUD 마스터(SCP0122/SCP0127/SCP0128 계열 구조). 신규(NEW) 판정 — convert-flow/goal.md ①. domain=SCP(형제 트리 실측 + namespace, 00_checklist.md §0). nscmPath 는 goal.md ①에서 확정한 `features/supply/src/pages/demand-exception/`.  | features/supply/src/pages/demand-exception/DemandException.tsx | 25 |
| code | buttonGuards#1 — fps==null(선택 행 없음) 시 무동작 return(design 01 §2 규칙#5). | features/supply/src/pages/demand-exception/DemandException.tsx | 111 |
| endpoint | useProcMutation({data:[rows]}) 로는 null 바인딩 no-op 이므로 전용 조립 util 을 mutationFn 으로 | features/supply/src/pages/demand-exception/DemandException.tsx | 123 |
| endpoint | → 공용 useProcMutation({data:[rows]}) 로는 top-level 에 activeFlag/divisionId... 키가 없어 전부 | features/supply/src/pages/demand-exception/utils/demandExceptionSaveRequest.ts | 5 |

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

