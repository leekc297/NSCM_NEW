# SCP0039 — To-Be Fact Pack 요약

- page_key: `supply/master-validation` · feature: supply · As-is Fact Pack 있음
- 파일 11 · 엔드포인트 호출 6 (미해결 1, 주석 속 3) · 이벤트 14 · 컴포넌트 사용 24 · 하드코딩 컬럼 0 · 메시지 6
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 0건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/supply/src/pages/master-validation/components/MasterValidationDetailGrid.tsx | component | 36 |
| features/supply/src/pages/master-validation/components/MasterValidationForm.tsx | component | 173 |
| features/supply/src/pages/master-validation/components/MasterValidationMasterGrid.module.scss | component | 8 |
| features/supply/src/pages/master-validation/components/MasterValidationMasterGrid.tsx | component | 90 |
| features/supply/src/pages/master-validation/index.ts | index | 2 |
| features/supply/src/pages/master-validation/master-validation.constants.ts | constants | 164 |
| features/supply/src/pages/master-validation/master-validation.types.ts | types | 32 |
| features/supply/src/pages/master-validation/MasterValidation.module.scss | style | 40 |
| features/supply/src/pages/master-validation/MasterValidation.tsx | page | 270 |
| features/supply/src/pages/master-validation/useMasterValidationStore.ts | store | 137 |
| features/supply/src/pages/master-validation/__asis-mapping__.md | mapping | 61 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueries) | hook | 2 | Y | MasterValidationForm.tsx:34 MasterValidationForm.tsx:40 |
| (useTabLookupQueries) | hook | 1 | Y | MasterValidation.tsx:62 |
| SCP0039/{?spec.sheet}/SEARCH/call-proc | callProc | 1 | N | MasterValidation.tsx:128 |
| /admin/menu/SCP0039/column | http | 1 | Y | useMasterValidationStore.ts:59 |
| /admin/menu/SCP0039/search-conditions | http | 1 | Y | useMasterValidationStore.ts:116 |

## 3. procedures.d.ts 등재 시트
| sheet | request_keys | response_cursors | sp_hints |
|---|---|---|---|
| bom | divisionId searchType planGroupId itemId | o_rc1 | PKG_SCP0039 P_DIVISION_ID P_SEARCH_TYPE P_PLAN_GROUP_ID P_ITEM_ID |
| projectRoute | divisionId searchType planGroupId itemId | o_rc1 | PKG_SCP0039 P_DIVISION_ID P_SEARCH_TYPE P_PLAN_GROUP_ID P_ITEM_ID |
| projectRouteElec | divisionId searchType planGroupId itemId | o_rc1 | PKG_SCP0039 P_DIVISION_ID P_SEARCH_TYPE P_PLAN_GROUP_ID P_ITEM_ID |
| bod | divisionId searchType planGroupId itemId | o_rc1 | PKG_SCP0039 P_DIVISION_ID P_SEARCH_TYPE P_PLAN_GROUP_ID P_ITEM_ID |
| lineAssign | divisionId searchType planGroupId itemId | o_rc1 | PKG_SCP0039 P_DIVISION_ID P_SEARCH_TYPE P_PLAN_GROUP_ID P_ITEM_ID |
| tactTime | divisionId searchType planGroupId itemId | o_rc1 | PKG_SCP0039 P_DIVISION_ID P_SEARCH_TYPE P_PLAN_GROUP_ID P_ITEM_ID |
| tactTimeOsp | divisionId searchType planGroupId itemId | o_rc1 | PKG_SCP0039 P_DIVISION_ID P_SEARCH_TYPE P_PLAN_GROUP_ID P_ITEM_ID |
| outsourcingCapacity | divisionId searchType planGroupId itemId | o_rc1 | PKG_SCP0039 P_DIVISION_ID P_SEARCH_TYPE P_PLAN_GROUP_ID P_ITEM_ID |
| stockOsp | divisionId searchType planGroupId itemId | o_rc1 | PKG_SCP0039 P_DIVISION_ID P_SEARCH_TYPE P_PLAN_GROUP_ID P_ITEM_ID |
| planGroup | divisionId searchType planGroupId itemId | o_rc1 | PKG_SCP0039 P_DIVISION_ID P_SEARCH_TYPE P_PLAN_GROUP_ID P_ITEM_ID |
| intransitInventory | divisionId searchType planGroupId itemId | o_rc1 | PKG_SCP0039 P_DIVISION_ID P_SEARCH_TYPE P_PLAN_GROUP_ID P_ITEM_ID |
| yield | divisionId searchType planGroupId itemId | o_rc1 | PKG_SCP0039 P_DIVISION_ID P_SEARCH_TYPE P_PLAN_GROUP_ID P_ITEM_ID |
| itemSearch | divisionId itemId | o_rc1 | PKG_SCP0039 P_DIVISION_ID P_SEARCH_TYPE P_PLAN_GROUP_ID P_ITEM_ID |

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| DataGrid | gotFocus | gotFocus | jsx | features/supply/src/pages/master-validation/components/MasterValidationDetailGrid.tsx | 33 |
| SearchArea | onSearch | noDivisionAuth ? undefined : onSearch | jsx | features/supply/src/pages/master-validation/components/MasterValidationForm.tsx | 64 |
| CustomDropdown | onChange | <arrow> String,confirmIfDirtyKey(tabDirtyKey(tabId),'search').then,confirmIfDirtyKey,tabDirtyKey,setDivision | jsx | features/supply/src/pages/master-validation/components/MasterValidationForm.tsx | 81 |
| CustomDropdown | onChange | <arrow> setSearchParams,String(picked??'').split(',').filter,String(picked??'').split,String,v.toUpperCase | jsx | features/supply/src/pages/master-validation/components/MasterValidationForm.tsx | 107 |
| InputField | onChange | <arrow> setSearchParams | jsx | features/supply/src/pages/master-validation/components/MasterValidationForm.tsx | 146 |
| FunctionSearchIcon | onClick | <arrow> setOpenItemModal | jsx | features/supply/src/pages/master-validation/components/MasterValidationForm.tsx | 140 |
| grid | formatItem | handler | addHandler | features/supply/src/pages/master-validation/components/MasterValidationMasterGrid.tsx | 57 |
| DataGrid | gotFocus | gotFocus | jsx | features/supply/src/pages/master-validation/components/MasterValidationMasterGrid.tsx | 86 |
| MasterValidationForm | onSearch | handleSearch | jsx | features/supply/src/pages/master-validation/MasterValidation.tsx | 230 |
| MasterValidationMasterGrid | onQuery | handleQuery | jsx | features/supply/src/pages/master-validation/MasterValidation.tsx | 250 |
| MasterValidationMasterGrid | onOpen | handleOpen | jsx | features/supply/src/pages/master-validation/MasterValidation.tsx | 251 |
| MasterValidationMasterGrid | onRowSelect | handleRowSelect | jsx | features/supply/src/pages/master-validation/MasterValidation.tsx | 252 |
| MasterValidationMasterGrid | gotFocus | <arrow> setFocusDetail | jsx | features/supply/src/pages/master-validation/MasterValidation.tsx | 253 |
| MasterValidationDetailGrid | gotFocus | <arrow> setFocusDetail | jsx | features/supply/src/pages/master-validation/MasterValidation.tsx | 263 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Grid | 3 |
| FormItem | 3 |
| DataGrid | 2 |
| CustomDropdown | 2 |
| Panel | 2 |
| SearchArea | 1 |
| InputField | 1 |
| Button | 1 |
| FunctionSearchIcon | 1 |
| ItemByDivisionModal | 1 |
| MainTitle | 1 |
| MasterValidationForm | 1 |
| SubTitle | 1 |
| PanelGroup | 1 |
| MasterValidationMasterGrid | 1 |
| PanelSeparator | 1 |
| MasterValidationDetailGrid | 1 |

## 6. 하드코딩 Grid 컬럼
(없음)

## 7. 메시지 코드
| code | count |
|---|---|
| LBL00001 | 1 |
| LBL00002 | 1 |
| LBL00669 | 1 |
| LBL00112 | 1 |
| MSG01052 | 2 |

## 8. 주석 속 As-is 참조
- 화면ID: SCP0039(6), SCP0006(1), SCP0025(1)
- SP/PKG: PKG_SCP0039(3)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| endpoint | 마스터 "Validation Info" 컬럼 메타는 admin fetch(하드코딩 금지). mount 1회 + F10 리셋 자가복구. | features/supply/src/pages/master-validation/MasterValidation.tsx | 64 |
| endpoint | detail(결과) 그리드 컬럼 메타 캐시 — 검증유형별 sheetNm 로 admin fetch(design 03 §5 #03). | features/supply/src/pages/master-validation/useMasterValidationStore.ts | 9 |
| endpoint | 마스터 "Validation Info" 메타 fetch(mount 1회). 이미 있으면 재조회 생략(정적 메타). | features/supply/src/pages/master-validation/useMasterValidationStore.ts | 87 |

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

