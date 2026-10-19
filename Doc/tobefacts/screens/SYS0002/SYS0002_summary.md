# SYS0002 — To-Be Fact Pack 요약

- page_key: `admin/user-management` · feature: admin · As-is Fact Pack 없음(화면ID 미대응)
- 파일 10 · 엔드포인트 호출 6 (미해결 1, 주석 속 0) · 이벤트 8 · 컴포넌트 사용 25 · 하드코딩 컬럼 0 · 메시지 7
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 0건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/admin/src/pages/user-management/components/AssignGroupModal.module.scss | component | 68 |
| features/admin/src/pages/user-management/components/AssignGroupModal.tsx | component | 105 |
| features/admin/src/pages/user-management/components/UserManagementForm.module.scss | component | 9 |
| features/admin/src/pages/user-management/components/UserManagementForm.tsx | component | 107 |
| features/admin/src/pages/user-management/components/UserManagementGrid.module.scss | component | 8 |
| features/admin/src/pages/user-management/components/UserManagementGrid.tsx | component | 170 |
| features/admin/src/pages/user-management/index.ts | index | 2 |
| features/admin/src/pages/user-management/user-management.constants.ts | constants | 11 |
| features/admin/src/pages/user-management/UserManagement.tsx | page | 105 |
| features/admin/src/pages/user-management/useUserManagementStore.ts | store | 126 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| /user/{userId}/groups | http | 1 | N | AssignGroupModal.tsx:35 |
| (useTabComboQueries) | hook | 1 | Y | UserManagementForm.tsx:17 |
| SYS0002/userMgmt//call-proc | hook | 2 | Y | UserManagement.tsx:33 UserManagement.tsx:41 |
| /admin/menu/SYS0002/column | http | 1 | Y | useUserManagementStore.ts:71 |
| /admin/menu/SYS0002/search-conditions | http | 1 | Y | useUserManagementStore.ts:81 |

## 3. procedures.d.ts 등재 시트
| sheet | request_keys | response_cursors | sp_hints |
|---|---|---|---|
| userMgmt | user department group useYn | o_rc |  |

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| Button | onClick | onClose | jsx | features/admin/src/pages/user-management/components/AssignGroupModal.tsx | 97 |
| SearchArea | onSearch | setFilters | jsx | features/admin/src/pages/user-management/components/UserManagementForm.tsx | 24 |
| InputField | onChange | <arrow> setSearchParams | jsx | features/admin/src/pages/user-management/components/UserManagementForm.tsx | 36 |
| InputField | onChange | <arrow> setSearchParams | jsx | features/admin/src/pages/user-management/components/UserManagementForm.tsx | 50 |
| CustomDropdown | onChange | <arrow> setSearchParams | jsx | features/admin/src/pages/user-management/components/UserManagementForm.tsx | 71 |
| CustomDropdown | onChange | <arrow> setSearchParams | jsx | features/admin/src/pages/user-management/components/UserManagementForm.tsx | 94 |
| DataGrid | formatItem | handleFormatItem | jsx | features/admin/src/pages/user-management/components/UserManagementGrid.tsx | 147 |
| AssignGroupModal | onClose | <arrow> setOpenAssignGroupModal | jsx | features/admin/src/pages/user-management/components/UserManagementGrid.tsx | 165 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Grid | 4 |
| FormItem | 4 |
| InputField | 2 |
| CustomDropdown | 2 |
| CustomDialog | 1 |
| ProgressIndicator | 1 |
| Button | 1 |
| ControlConfirmIcon | 1 |
| SearchArea | 1 |
| DataGrid | 1 |
| SsoUserModal | 1 |
| SsoDeptModal | 1 |
| AssignGroupModal | 1 |
| MainTitle | 1 |
| UserManagementForm | 1 |
| SubTitle | 1 |
| UserManagementGrid | 1 |

## 6. 하드코딩 Grid 컬럼
(없음)

## 7. 메시지 코드
| code | count |
|---|---|
| LBL00627 | 1 |
| LBL00112 | 1 |
| LBL00339 | 1 |
| LBL00338 | 1 |
| LBL00340 | 1 |
| LBL00007 | 1 |
| MSG00007 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: (없음)
- SP/PKG: (없음)
## 9. 주석 처리된 코드 (현행 기능 아님)
(없음)

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

