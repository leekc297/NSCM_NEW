# SYS0009 — To-Be Fact Pack 요약

- page_key: `admin/menu-button-management` · feature: admin · As-is Fact Pack 없음(화면ID 미대응)
- 파일 6 · 엔드포인트 호출 5 (미해결 0, 주석 속 0) · 이벤트 7 · 컴포넌트 사용 18 · 하드코딩 컬럼 0 · 메시지 5
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 0건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/admin/src/pages/menu-button-management/components/MenuButtonManagementForm.tsx | component | 106 |
| features/admin/src/pages/menu-button-management/components/MenuButtonManagementTable.tsx | component | 53 |
| features/admin/src/pages/menu-button-management/index.ts | index | 2 |
| features/admin/src/pages/menu-button-management/menu-button-management.constants.ts | constants | 7 |
| features/admin/src/pages/menu-button-management/MenuButtonManagement.tsx | page | 106 |
| features/admin/src/pages/menu-button-management/useMenuButtonManagementStore.ts | store | 111 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueries) | hook | 1 | Y | MenuButtonManagementForm.tsx:17 |
| SYS0009/menuBtnList//call-proc | hook | 1 | Y | MenuButtonManagement.tsx:31 |
| SYS0009/menuBtnList/SAVE/call-proc | hook | 1 | Y | MenuButtonManagement.tsx:39 |
| /admin/menu/SYS0009/column | http | 1 | Y | useMenuButtonManagementStore.ts:67 |
| /admin/menu/SYS0009/search-conditions | http | 1 | Y | useMenuButtonManagementStore.ts:77 |

## 3. procedures.d.ts 등재 시트
| sheet | request_keys | response_cursors | sp_hints |
|---|---|---|---|
| menuBtnList | menuId sheetNm btnCd apiNm useYn | o_rc |  |

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| SearchArea | onSearch | setFilters | jsx | features/admin/src/pages/menu-button-management/components/MenuButtonManagementForm.tsx | 24 |
| CustomDropdown | onChange | <arrow> setSearchParams | jsx | features/admin/src/pages/menu-button-management/components/MenuButtonManagementForm.tsx | 43 |
| InputField | onChange | <arrow> setSearchParams | jsx | features/admin/src/pages/menu-button-management/components/MenuButtonManagementForm.tsx | 59 |
| InputField | onChange | <arrow> setSearchParams | jsx | features/admin/src/pages/menu-button-management/components/MenuButtonManagementForm.tsx | 73 |
| CustomDropdown | onChange | <arrow> setSearchParams | jsx | features/admin/src/pages/menu-button-management/components/MenuButtonManagementForm.tsx | 94 |
| DataGrid | cellEditEnded | handleMenuChange | jsx | features/admin/src/pages/menu-button-management/components/MenuButtonManagementTable.tsx | 48 |
| DataGrid | pastedCell | handleMenuChange | jsx | features/admin/src/pages/menu-button-management/components/MenuButtonManagementTable.tsx | 49 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Grid | 4 |
| FormItem | 4 |
| CustomDropdown | 2 |
| InputField | 2 |
| SearchArea | 1 |
| DataGrid | 1 |
| MainTitle | 1 |
| MenuButtonnManagementForm | 1 |
| SubTitle | 1 |
| MenuButtonManagementTable | 1 |

## 6. 하드코딩 Grid 컬럼
(없음)

## 7. 메시지 코드
| code | count |
|---|---|
| LBL00112 | 1 |
| LBL00347 | 1 |
| LBL00306 | 1 |
| LBL00348 | 1 |
| LBL00007 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: (없음)
- SP/PKG: (없음)
## 9. 주석 처리된 코드 (현행 기능 아님)
(없음)

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

