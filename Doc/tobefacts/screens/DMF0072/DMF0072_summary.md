# DMF0072 — To-Be Fact Pack 요약

- page_key: `master/nn-master-mapping` · feature: master · As-is Fact Pack 없음(화면ID 미대응)
- 파일 12 · 엔드포인트 호출 10 (미해결 0, 주석 속 2) · 이벤트 17 · 컴포넌트 사용 30 · 하드코딩 컬럼 0 · 메시지 19
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 0건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/master/src/pages/nn-master-mapping/components/NnMasterMappingForm.module.scss | component | 57 |
| features/master/src/pages/nn-master-mapping/components/NnMasterMappingForm.tsx | component | 397 |
| features/master/src/pages/nn-master-mapping/components/NnMasterMappingGrid.tsx | component | 382 |
| features/master/src/pages/nn-master-mapping/index.ts | index | 2 |
| features/master/src/pages/nn-master-mapping/nn-master-mapping.constants.ts | constants | 48 |
| features/master/src/pages/nn-master-mapping/nn-master-mapping.types.ts | types | 11 |
| features/master/src/pages/nn-master-mapping/NnMasterMapping.module.scss | style | 181 |
| features/master/src/pages/nn-master-mapping/NnMasterMapping.tsx | page | 393 |
| features/master/src/pages/nn-master-mapping/useNnMasterMappingStore.ts | store | 124 |
| features/master/src/pages/nn-master-mapping/utils/nn-master-mapping.merge.ts | util | 40 |
| features/master/src/pages/nn-master-mapping/utils/searchCombos.ts | util | 100 |
| features/master/src/pages/nn-master-mapping/__asis-mapping__.md | mapping | 75 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| /admin/menu/DMF0072/search-conditions | http | 1 | Y | NnMasterMappingForm.tsx:54 |
| DMF0072/dataType//call-proc | hook | 1 | Y | NnMasterMappingForm.tsx:73 |
| (useTabComboQueries) | hook | 4 | Y | NnMasterMappingForm.tsx:87 NnMasterMappingForm.tsx:93 NnMasterMappingForm.tsx:96 NnMasterMapping.tsx:75 |
| (useTabLookupQueries) | hook | 1 | Y | NnMasterMappingGrid.tsx:73 |
| DMF0072/main//call-proc | hook | 1 | Y | NnMasterMapping.tsx:94 |
| /DMF0072/main/SAVE/call-proc | http | 1 | Y | NnMasterMapping.tsx:319 |
| /admin/menu/DMF0072/column | http | 1 | Y | useNnMasterMappingStore.ts:91 |

## 3. procedures.d.ts 등재 시트
(없음)

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| CustomDropdown | onChange | <arrow> onPick,String | jsx | features/master/src/pages/nn-master-mapping/components/NnMasterMappingForm.tsx | 163 |
| SearchArea | onSearch | onSearch | jsx | features/master/src/pages/nn-master-mapping/components/NnMasterMappingForm.tsx | 191 |
| CustomDropdown | onChange | <arrow> set | jsx | features/master/src/pages/nn-master-mapping/components/NnMasterMappingForm.tsx | 205 |
| CustomDropdown | onChange | <arrow> confirmIfDirtyKey(tabDirtyKey(tabId),'search').then,confirmIfDirtyKey,tabDirtyKey,set,String | jsx | features/master/src/pages/nn-master-mapping/components/NnMasterMappingForm.tsx | 221 |
| InputField | onChange | <arrow> set | jsx | features/master/src/pages/nn-master-mapping/components/NnMasterMappingForm.tsx | 282 |
| InputField | onDoubleClick | <arrow> setOpenProjectModal | jsx | features/master/src/pages/nn-master-mapping/components/NnMasterMappingForm.tsx | 298 |
| InputField | onKeyDown | <arrow> setOpenProjectModal | jsx | features/master/src/pages/nn-master-mapping/components/NnMasterMappingForm.tsx | 300 |
| FunctionSearchIcon | onClick | <arrow> setOpenProjectModal | jsx | features/master/src/pages/nn-master-mapping/components/NnMasterMappingForm.tsx | 292 |
| InputField | onChange | <arrow> set | jsx | features/master/src/pages/nn-master-mapping/components/NnMasterMappingForm.tsx | 321 |
| InputField | onDoubleClick | <arrow> setOpenItemModal | jsx | features/master/src/pages/nn-master-mapping/components/NnMasterMappingForm.tsx | 336 |
| InputField | onKeyDown | <arrow> setOpenItemModal | jsx | features/master/src/pages/nn-master-mapping/components/NnMasterMappingForm.tsx | 338 |
| FunctionSearchIcon | onClick | <arrow> setOpenItemModal | jsx | features/master/src/pages/nn-master-mapping/components/NnMasterMappingForm.tsx | 330 |
| grid | updatedLayout | attach | addHandler | features/master/src/pages/nn-master-mapping/components/NnMasterMappingGrid.tsx | 104 |
| g | beginningEdit | handleBeginningEdit | addHandler | features/master/src/pages/nn-master-mapping/components/NnMasterMappingGrid.tsx | 163 |
| g | formatItem | handleFormatItem | addHandler | features/master/src/pages/nn-master-mapping/components/NnMasterMappingGrid.tsx | 194 |
| DataGrid | cellEditEnded | handleCellEditEnded | jsx | features/master/src/pages/nn-master-mapping/components/NnMasterMappingGrid.tsx | 335 |
| NnMasterMappingForm | onSearch | handleSearch | jsx | features/master/src/pages/nn-master-mapping/NnMasterMapping.tsx | 373 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Grid | 5 |
| FormItem | 5 |
| CustomDropdown | 3 |
| InputField | 2 |
| Button | 2 |
| FunctionSearchIcon | 2 |
| ProjectByDivisionModal | 2 |
| ItemByDivisionModal | 2 |
| SearchArea | 1 |
| DataGrid | 1 |
| CustomerModal | 1 |
| MainTitle | 1 |
| NnMasterMappingForm | 1 |
| SubTitle | 1 |
| NnMasterMappingGrid | 1 |

## 6. 하드코딩 Grid 컬럼
(없음)

## 7. 메시지 코드
| code | count |
|---|---|
| LBL00112 | 1 |
| LBL00089 | 1 |
| LBL00001 | 1 |
| LBL00044 | 1 |
| LBL00080 | 1 |
| LBL00617 | 1 |
| LBL00618 | 1 |
| LBL00011 | 1 |
| MSG00608 | 1 |
| MSG00610 | 1 |
| MSG00611 | 1 |
| MSG00108 | 1 |
| MSG00612 | 1 |
| MSG00613 | 1 |
| MSG00614 | 1 |
| MSG00615 | 1 |
| MSG00616 | 1 |
| MSG00002 | 1 |
| MSG00618 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: DMF0004(4), DMF0072(3), DMF0043_01(1), SCP0048(1), DMF0021(1)
- SP/PKG: PR_GET_SHEET_COLUMN_LIST(2), DMF0072_GET_NNMASTER_MAPPING(1), DMF0008_GET_MY_DIVISION_LIST(1), SCM0001_GET_LOOKUP_VALUES(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| code | (change-effect 는 grid mount 전에 early-return 될 수 있다 — SCP0048 선례). | features/master/src/pages/nn-master-mapping/components/NnMasterMappingGrid.tsx | 96 |
| code | const object — enum 대체 (NSCM 단일 cursor 표준 'o_rc1' 다수 중복 허용) | features/master/src/pages/nn-master-mapping/nn-master-mapping.constants.ts | 20 |
| endpoint | BE 메타 SHEET_COLUMNS 동적 fetch (admin UI Category Setup 즉시 반영, 룰 #65) | features/master/src/pages/nn-master-mapping/useNnMasterMappingStore.ts | 23 |
| endpoint | fetchStaticColumns — admin SHEET_COLUMNS 동적 fetch (DMF0004 표준). 메모리 feedback_admin_meta_dynamic_fetch + feedback_grid_no_hardcoded_static_columns. BE: POST /admin/menu/{MENU_ID}/column { sheetNm } | features/master/src/pages/nn-master-mapping/useNnMasterMappingStore.ts | 83 |

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

