# SYS0010 — To-Be Fact Pack 요약

- page_key: `admin/lookup` · feature: admin · As-is Fact Pack 없음(화면ID 미대응)
- 파일 12 · 엔드포인트 호출 9 (미해결 0, 주석 속 0) · 이벤트 7 · 컴포넌트 사용 22 · 하드코딩 컬럼 0 · 메시지 9
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 0건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/admin/src/pages/lookup/components/LookupDetailGrid.tsx | component | 74 |
| features/admin/src/pages/lookup/components/LookupForm.module.scss | component | 9 |
| features/admin/src/pages/lookup/components/LookupForm.tsx | component | 131 |
| features/admin/src/pages/lookup/components/LookupMasterGrid.tsx | component | 64 |
| features/admin/src/pages/lookup/index.ts | index | 2 |
| features/admin/src/pages/lookup/lookup.constants.ts | constants | 14 |
| features/admin/src/pages/lookup/Lookup.module.scss | style | 90 |
| features/admin/src/pages/lookup/Lookup.tsx | page | 324 |
| features/admin/src/pages/lookup/lookup.utils.test.ts | test | 75 |
| features/admin/src/pages/lookup/lookup.utils.ts | other | 175 |
| features/admin/src/pages/lookup/useLookupStore.ts | store | 195 |
| features/admin/src/pages/lookup/__asis-mapping__.md | mapping | 84 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabLookupQueries) | hook | 1 | Y | LookupForm.tsx:24 |
| (useTabComboQueries) | hook | 1 | Y | LookupForm.tsx:32 |
| /admin/menu/SYS0010/search-conditions | http | 1 | Y | LookupForm.tsx:39 |
| SYS0010/lookupMaster//call-proc | hook | 2 | Y | Lookup.tsx:63 Lookup.tsx:82 |
| SYS0010/lookupDetail//call-proc | hook | 2 | Y | Lookup.tsx:74 Lookup.tsx:92 |
| /admin/menu/SYS0010/column | http | 2 | Y | useLookupStore.ts:138 useLookupStore.ts:141 |

## 3. procedures.d.ts 등재 시트
| sheet | request_keys | response_cursors | sp_hints |
|---|---|---|---|
| lookupMaster | lookupType lookupGroup validYn | o_rc |  |
| lookupDetail | lookupType | o_rc |  |

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| DataGrid | gotFocus | handleGotFocus | jsx | features/admin/src/pages/lookup/components/LookupDetailGrid.tsx | 70 |
| SearchArea | onSearch | onSubmit | jsx | features/admin/src/pages/lookup/components/LookupForm.tsx | 62 |
| InputField | onChange | <arrow> setSearchParams | jsx | features/admin/src/pages/lookup/components/LookupForm.tsx | 74 |
| CustomDropdown | onChange | <arrow> setSearchParams | jsx | features/admin/src/pages/lookup/components/LookupForm.tsx | 95 |
| CustomDropdown | onChange | <arrow> setSearchParams | jsx | features/admin/src/pages/lookup/components/LookupForm.tsx | 118 |
| DataGrid | gotFocus | handleGotFocus | jsx | features/admin/src/pages/lookup/components/LookupMasterGrid.tsx | 59 |
| LookupForm | onSubmit | handleSubmit | jsx | features/admin/src/pages/lookup/Lookup.tsx | 276 |

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
| MainTitle | 1 |
| LookupForm | 1 |
| SubTitle | 1 |
| PanelGroup | 1 |
| LookupMasterGrid | 1 |
| PanelSeparator | 1 |
| TitleArea | 1 |
| LookupDetailGrid | 1 |

## 6. 하드코딩 Grid 컬럼
(없음)

## 7. 메시지 코드
| code | count |
|---|---|
| LBL00112 | 1 |
| LBL00057 | 2 |
| LBL00638 | 1 |
| LBL00007 | 1 |
| MSG00002 | 1 |
| MSG00624 | 1 |
| MSG00060 | 1 |
| LBL00637 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: SYS0010(3), SCP0120(1), SCM0103(1), SYS0004(1)
- SP/PKG: P_SYS0010_GET_LOOKUP_MASTER_DETAIL(1), P_SYS0010_SAVE_LOOKUP_MASTER_DETAIL(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| code | .catch(() => { | features/admin/src/pages/lookup/Lookup.tsx | 128 |
| code | }); | features/admin/src/pages/lookup/Lookup.tsx | 130 |

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

