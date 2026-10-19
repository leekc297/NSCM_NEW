# SYS0006 — To-Be Fact Pack 요약

- page_key: `admin/api-management` · feature: admin · As-is Fact Pack 없음(화면ID 미대응)
- 파일 6 · 엔드포인트 호출 6 (미해결 0, 주석 속 0) · 이벤트 6 · 컴포넌트 사용 16 · 하드코딩 컬럼 0 · 메시지 4
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 0건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/admin/src/pages/api-management/api-management.constants.ts | constants | 7 |
| features/admin/src/pages/api-management/ApiManagement.tsx | page | 153 |
| features/admin/src/pages/api-management/components/ApiManagementForm.tsx | component | 127 |
| features/admin/src/pages/api-management/components/ApiManagementGrid.tsx | component | 57 |
| features/admin/src/pages/api-management/index.ts | index | 2 |
| features/admin/src/pages/api-management/useApiManagementStore.ts | store | 117 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| SYS0006/apiList//call-proc | hook | 2 | Y | ApiManagement.tsx:48 ApiManagement.tsx:56 |
| (useTabComboQueries) | hook | 1 | Y | ApiManagementForm.tsx:40 |
| (useTabLookupQueries) | hook | 1 | Y | ApiManagementForm.tsx:44 |
| /admin/menu/SYS0006/column | http | 1 | Y | useApiManagementStore.ts:66 |
| /admin/menu/SYS0006/search-conditions | http | 1 | Y | useApiManagementStore.ts:77 |

## 3. procedures.d.ts 등재 시트
| sheet | request_keys | response_cursors | sp_hints |
|---|---|---|---|
| apiList | apiType apiId useYn | o_rc |  |

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| ApiManagementForm | onSearch | handleSearch | jsx | features/admin/src/pages/api-management/ApiManagement.tsx | 126 |
| SearchArea | onSearch | onSearch | jsx | features/admin/src/pages/api-management/components/ApiManagementForm.tsx | 55 |
| CustomDropdown | onChange | <arrow> setSearchParams | jsx | features/admin/src/pages/api-management/components/ApiManagementForm.tsx | 77 |
| InputField | onChange | <arrow> setTypedApiId | jsx | features/admin/src/pages/api-management/components/ApiManagementForm.tsx | 93 |
| InputField | onBlur | commitApiId | jsx | features/admin/src/pages/api-management/components/ApiManagementForm.tsx | 94 |
| CustomDropdown | onChange | <arrow> setSearchParams | jsx | features/admin/src/pages/api-management/components/ApiManagementForm.tsx | 115 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Grid | 3 |
| FormItem | 3 |
| CustomDropdown | 2 |
| MainTitle | 1 |
| ApiManagementForm | 1 |
| SubTitle | 1 |
| ApiManagementGrid | 1 |
| MessageModal | 1 |
| SearchArea | 1 |
| InputField | 1 |
| DataGrid | 1 |

## 6. 하드코딩 Grid 컬럼
(없음)

## 7. 메시지 코드
| code | count |
|---|---|
| LBL00112 | 1 |
| LBL00345 | 1 |
| LBL00323 | 1 |
| LBL00007 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: (없음)
- SP/PKG: (없음)
## 9. 주석 처리된 코드 (현행 기능 아님)
(없음)

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

