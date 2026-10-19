# SYS0001 — To-Be Fact Pack 요약

- page_key: `admin/message-management` · feature: admin · As-is Fact Pack 없음(화면ID 미대응)
- 파일 8 · 엔드포인트 호출 5 (미해결 0, 주석 속 0) · 이벤트 4 · 컴포넌트 사용 16 · 하드코딩 컬럼 0 · 메시지 3
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 0건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/admin/src/pages/message-management/components/MessageManagementForm.module.scss | component | 9 |
| features/admin/src/pages/message-management/components/MessageManagementForm.tsx | component | 93 |
| features/admin/src/pages/message-management/components/MessageManagementGrid.tsx | component | 32 |
| features/admin/src/pages/message-management/index.ts | index | 2 |
| features/admin/src/pages/message-management/message-management.constants.ts | constants | 7 |
| features/admin/src/pages/message-management/MessageManagement.tsx | page | 105 |
| features/admin/src/pages/message-management/useMessageManagementStore.test.tsx | test | 127 |
| features/admin/src/pages/message-management/useMessageManagementStore.ts | store | 110 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueries) | hook | 1 | Y | MessageManagementForm.tsx:17 |
| SYS0001/msgMgmt//call-proc | hook | 2 | Y | MessageManagement.tsx:31 MessageManagement.tsx:39 |
| /admin/menu/SYS0001/column | http | 1 | Y | useMessageManagementStore.ts:71 |
| /admin/menu/SYS0001/search-conditions | http | 1 | Y | useMessageManagementStore.ts:81 |

## 3. procedures.d.ts 등재 시트
| sheet | request_keys | response_cursors | sp_hints |
|---|---|---|---|
| msgMgmt | messageType message useYn | o_rc |  |

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| SearchArea | onSearch | setFilters | jsx | features/admin/src/pages/message-management/components/MessageManagementForm.tsx | 24 |
| CustomDropdown | onChange | <arrow> setSearchParams | jsx | features/admin/src/pages/message-management/components/MessageManagementForm.tsx | 43 |
| InputField | onChange | <arrow> setSearchParams | jsx | features/admin/src/pages/message-management/components/MessageManagementForm.tsx | 59 |
| CustomDropdown | onChange | <arrow> setSearchParams | jsx | features/admin/src/pages/message-management/components/MessageManagementForm.tsx | 80 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Grid | 3 |
| FormItem | 3 |
| CustomDropdown | 2 |
| SearchArea | 1 |
| InputField | 1 |
| DataGrid | 1 |
| MainTitle | 1 |
| MessageManagementForm | 1 |
| SubTitle | 1 |
| MessageManagementGrid | 1 |
| TabIdContext.Provider | 1 |

## 6. 하드코딩 Grid 컬럼
(없음)

## 7. 메시지 코드
| code | count |
|---|---|
| LBL00112 | 1 |
| LBL00052 | 1 |
| LBL00007 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: (없음)
- SP/PKG: (없음)
## 9. 주석 처리된 코드 (현행 기능 아님)
(없음)

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

