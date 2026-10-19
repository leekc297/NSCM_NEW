# SYS0005 — To-Be Fact Pack 요약

- page_key: `admin/procedure-management` · feature: admin · As-is Fact Pack 없음(화면ID 미대응)
- 파일 8 · 엔드포인트 호출 8 (미해결 0, 주석 속 0) · 이벤트 6 · 컴포넌트 사용 17 · 하드코딩 컬럼 0 · 메시지 4
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 0건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/admin/src/pages/procedure-management/components/ProcedureInfoGrid.tsx | component | 40 |
| features/admin/src/pages/procedure-management/components/ProcedureListGrid.tsx | component | 65 |
| features/admin/src/pages/procedure-management/components/ProcedureManagementForm.tsx | component | 94 |
| features/admin/src/pages/procedure-management/index.ts | index | 2 |
| features/admin/src/pages/procedure-management/procedure-management.constants.ts | constants | 13 |
| features/admin/src/pages/procedure-management/ProcedureManagement.module.scss | style | 11 |
| features/admin/src/pages/procedure-management/ProcedureManagement.tsx | page | 118 |
| features/admin/src/pages/procedure-management/useProcedureManagementStore.ts | store | 123 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueries) | hook | 1 | Y | ProcedureManagementForm.tsx:17 |
| SYS0005/procList//call-proc | hook | 2 | Y | ProcedureManagement.tsx:32 ProcedureManagement.tsx:48 |
| SYS0005/procInfo//call-proc | hook | 2 | Y | ProcedureManagement.tsx:40 ProcedureManagement.tsx:54 |
| /admin/menu/SYS0005/column | http | 2 | Y | useProcedureManagementStore.ts:85 useProcedureManagementStore.ts:88 |
| /admin/menu/SYS0005/search-conditions | http | 1 | Y | useProcedureManagementStore.ts:101 |

## 3. procedures.d.ts 등재 시트
| sheet | request_keys | response_cursors | sp_hints |
|---|---|---|---|
| procList | schema procedure | o_rc |  |
| procInfo | OWNER PROC_NM isYn | o_rc |  |

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| DataGrid | gotFocus | handleFocus | jsx | features/admin/src/pages/procedure-management/components/ProcedureInfoGrid.tsx | 36 |
| DataGrid | gotFocus | handleFocus | jsx | features/admin/src/pages/procedure-management/components/ProcedureListGrid.tsx | 60 |
| SearchArea | onSearch | setListFilter | jsx | features/admin/src/pages/procedure-management/components/ProcedureManagementForm.tsx | 24 |
| CustomDropdown | onChange | <arrow> setSearchParams | jsx | features/admin/src/pages/procedure-management/components/ProcedureManagementForm.tsx | 45 |
| InputField | onChange | <arrow> setSearchParams | jsx | features/admin/src/pages/procedure-management/components/ProcedureManagementForm.tsx | 61 |
| CustomDropdown | onChange | <arrow> setSearchParams | jsx | features/admin/src/pages/procedure-management/components/ProcedureManagementForm.tsx | 82 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Grid | 3 |
| FormItem | 3 |
| DataGrid | 2 |
| CustomDropdown | 2 |
| SearchArea | 1 |
| InputField | 1 |
| MainTitle | 1 |
| ProcedureManagementForm | 1 |
| SubTitle | 1 |
| ProcedureListGrid | 1 |
| ProcedureInfoGrid | 1 |

## 6. 하드코딩 Grid 컬럼
(없음)

## 7. 메시지 코드
| code | count |
|---|---|
| LBL00112 | 1 |
| LBL00303 | 1 |
| LBL00304 | 1 |
| LBL00325 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: (없음)
- SP/PKG: (없음)
## 9. 주석 처리된 코드 (현행 기능 아님)
(없음)

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

