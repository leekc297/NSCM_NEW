# DMF0006 — To-Be Fact Pack 요약

- page_key: `master/customer-model-mapping` · feature: master · As-is Fact Pack 없음(화면ID 미대응)
- 파일 10 · 엔드포인트 호출 10 (미해결 1, 주석 속 0) · 이벤트 21 · 컴포넌트 사용 41 · 하드코딩 컬럼 0 · 메시지 13
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 0건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/master/src/pages/customer-model-mapping/components/CustomerModelMappingForm.module.scss | component | 23 |
| features/master/src/pages/customer-model-mapping/components/CustomerModelMappingForm.tsx | component | 349 |
| features/master/src/pages/customer-model-mapping/components/CustomerModelMappingGrid.tsx | component | 383 |
| features/master/src/pages/customer-model-mapping/customer-model-mapping.constants.ts | constants | 320 |
| features/master/src/pages/customer-model-mapping/customer-model-mapping.duplicateCheck.ts | other | 131 |
| features/master/src/pages/customer-model-mapping/customer-model-mapping.gridCombos.ts | other | 88 |
| features/master/src/pages/customer-model-mapping/customer-model-mapping.types.ts | types | 12 |
| features/master/src/pages/customer-model-mapping/CustomerModelMapping.tsx | page | 190 |
| features/master/src/pages/customer-model-mapping/index.ts | index | 2 |
| features/master/src/pages/customer-model-mapping/useCustomerModelMappingStore.ts | store | 123 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueries) | hook | 4 | Y | CustomerModelMappingForm.tsx:48 CustomerModelMappingForm.tsx:80 CustomerModelMappingForm.tsx:93 CustomerModelMappingGrid.tsx:97 |
| {?row} | http | 1 | N | customer-model-mapping.duplicateCheck.ts:117 |
| DMF0006/customerModelMapping//call-proc | hook | 2 | Y | CustomerModelMapping.tsx:40 CustomerModelMapping.tsx:48 |
| DMF0006/customerModelMapping/SEARCH/call-proc | callProc | 1 | Y | CustomerModelMapping.tsx:83 |
| /admin/menu/DMF0006/column | http | 1 | Y | useCustomerModelMappingStore.ts:88 |
| /admin/menu/DMF0006/search-conditions | http | 1 | Y | useCustomerModelMappingStore.ts:101 |

## 3. procedures.d.ts 등재 시트
| sheet | request_keys | response_cursors | sp_hints |
|---|---|---|---|
| customerModelMapping | divisionId deptId endCustomer salesSite customerPJT customerModel projectCode itemId activeFlag | o_rc1 |  |

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| SearchArea | onSearch | setFilters | jsx | features/master/src/pages/customer-model-mapping/components/CustomerModelMappingForm.tsx | 106 |
| CustomDropdown | onChange | <arrow> confirmIfDirtyKey(tabDirtyKey(tabId),'search').then,confirmIfDirtyKey,tabDirtyKey,setSearchParams | jsx | features/master/src/pages/customer-model-mapping/components/CustomerModelMappingForm.tsx | 119 |
| CustomDropdown | onChange | <arrow> setSearchParams | jsx | features/master/src/pages/customer-model-mapping/components/CustomerModelMappingForm.tsx | 158 |
| CustomDropdown | onChange | <arrow> setSearchParams | jsx | features/master/src/pages/customer-model-mapping/components/CustomerModelMappingForm.tsx | 187 |
| CustomDropdown | onChange | <arrow> setSearchParams | jsx | features/master/src/pages/customer-model-mapping/components/CustomerModelMappingForm.tsx | 210 |
| InputField | onChange | <arrow> setSearchParams | jsx | features/master/src/pages/customer-model-mapping/components/CustomerModelMappingForm.tsx | 230 |
| InputField | onDoubleClick | <arrow> setOpenPrjByDivisionModal | jsx | features/master/src/pages/customer-model-mapping/components/CustomerModelMappingForm.tsx | 246 |
| FunctionSearchIcon | onClick | <arrow> setOpenPrjByDivisionModal | jsx | features/master/src/pages/customer-model-mapping/components/CustomerModelMappingForm.tsx | 240 |
| InputField | onChange | <arrow> setSearchParams | jsx | features/master/src/pages/customer-model-mapping/components/CustomerModelMappingForm.tsx | 261 |
| InputField | onDoubleClick | <arrow> setOpenModelByDivisionModal | jsx | features/master/src/pages/customer-model-mapping/components/CustomerModelMappingForm.tsx | 276 |
| FunctionSearchIcon | onClick | <arrow> setOpenModelByDivisionModal | jsx | features/master/src/pages/customer-model-mapping/components/CustomerModelMappingForm.tsx | 270 |
| InputField | onChange | <arrow> setSearchParams | jsx | features/master/src/pages/customer-model-mapping/components/CustomerModelMappingForm.tsx | 289 |
| InputField | onChange | <arrow> setSearchParams | jsx | features/master/src/pages/customer-model-mapping/components/CustomerModelMappingForm.tsx | 304 |
| CustomDropdown | onChange | <arrow> setSearchParams | jsx | features/master/src/pages/customer-model-mapping/components/CustomerModelMappingForm.tsx | 323 |
| g | updatedLayout | applyTeamDataMap | addHandler | features/master/src/pages/customer-model-mapping/components/CustomerModelMappingGrid.tsx | 127 |
| g | beginningEdit | beginningEditHandler | addHandler | features/master/src/pages/customer-model-mapping/components/CustomerModelMappingGrid.tsx | 159 |
| g | formatItem | formatHandler | addHandler | features/master/src/pages/customer-model-mapping/components/CustomerModelMappingGrid.tsx | 175 |
| g | cellEditEnded | cascadeClearHandler | addHandler | features/master/src/pages/customer-model-mapping/components/CustomerModelMappingGrid.tsx | 205 |
| g | pastedCell | cascadeClearHandler | addHandler | features/master/src/pages/customer-model-mapping/components/CustomerModelMappingGrid.tsx | 206 |
| g | beginningEdit | beginningEditHandler | addHandler | features/master/src/pages/customer-model-mapping/components/CustomerModelMappingGrid.tsx | 228 |
| g | formatItem | formatHandler | addHandler | features/master/src/pages/customer-model-mapping/components/CustomerModelMappingGrid.tsx | 242 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Grid | 9 |
| FormItem | 9 |
| CustomDropdown | 5 |
| InputField | 4 |
| Button | 2 |
| FunctionSearchIcon | 2 |
| ProjectByDivisionModal | 2 |
| ItemByDivisionModal | 2 |
| SearchArea | 1 |
| DataGrid | 1 |
| MainTitle | 1 |
| CustomerModelMappingForm | 1 |
| SubTitle | 1 |
| CustomerModelMappingGrid | 1 |

## 6. 하드코딩 Grid 컬럼
(없음)

## 7. 메시지 코드
| code | count |
|---|---|
| LBL00112 | 1 |
| LBL00001 | 1 |
| LBL00044 | 1 |
| LBL00080 | 1 |
| LBL00011 | 1 |
| LBL00617 | 1 |
| LBL00618 | 1 |
| LBL00083 | 1 |
| LBL00084 | 1 |
| LBL00007 | 1 |
| MSG00060 | 2 |
| MSG00618 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: DMF0049(2), DMF0006(2), DMF0007(2), DMF0042(1), DMF0020(1), DMF0043(1), DMF0004(1), DMF0003(1)
- SP/PKG: PKG_DMF0006(1), P_PR_DM_MST_SAVE_CUSTOMER_MODEL_MAPPING_DATA(1), PR_GET_SHEET_COLUMN_LIST(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| code | 조회조건 콤보 원천 7종. 등록명은 AS-IS DMF0006_CustomerModelMapping.cs 호출부와 1:1 이다. DMF0006 은 속도개선(PJT202350699) 대상에서 빠진 화면이라 SetChangeControl / GetDMInnerTable 이 한 줄도 없다. 조회조건 콤보와 그리드 셀 콤보 모두 예외 없이 재조회 방식이다. 조인 평면 콤보 1건으로 묶는 CascadeFields 는 이 화면에 쓰지 않는 | features/master/src/pages/customer-model-mapping/customer-model-mapping.constants.ts | 182 |

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

