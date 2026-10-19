# SYS0011 — To-Be Fact Pack 요약

- page_key: `authority/auth-request` · feature: authority · As-is Fact Pack 없음(화면ID 미대응)
- 파일 10 · 엔드포인트 호출 12 (미해결 0, 주석 속 0) · 이벤트 5 · 컴포넌트 사용 44 · 하드코딩 컬럼 0 · 메시지 27
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 0건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/authority/src/pages/auth-request/auth-request.constants.ts | constants | 32 |
| features/authority/src/pages/auth-request/auth-request.grid-utils.ts | other | 5 |
| features/authority/src/pages/auth-request/AuthRequest.module.scss | style | 37 |
| features/authority/src/pages/auth-request/AuthRequest.tsx | page | 379 |
| features/authority/src/pages/auth-request/components/AuthorityGrid.tsx | component | 39 |
| features/authority/src/pages/auth-request/components/DivisionGrid.tsx | component | 40 |
| features/authority/src/pages/auth-request/components/MyAuthorityListGrid.tsx | component | 82 |
| features/authority/src/pages/auth-request/components/UserInfoDetail.tsx | component | 99 |
| features/authority/src/pages/auth-request/index.ts | index | 2 |
| features/authority/src/pages/auth-request/useAuthRequestStore.ts | store | 99 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| SYS0011/authority//call-proc | hook | 1 | Y | AuthRequest.tsx:57 |
| SYS0011/division//call-proc | hook | 1 | Y | AuthRequest.tsx:65 |
| SYS0011/myAuthorityList//call-proc | hook | 2 | Y | AuthRequest.tsx:73 AuthRequest.tsx:89 |
| SYS0011/userInfo//call-proc | hook | 3 | Y | AuthRequest.tsx:81 AuthRequest.tsx:99 UserInfoDetail.tsx:26 |
| (useTabComboQueries) | hook | 1 | Y | UserInfoDetail.tsx:34 |
| /admin/menu/SYS0011/column | http | 4 | Y | useAuthRequestStore.ts:74 useAuthRequestStore.ts:77 useAuthRequestStore.ts:80 useAuthRequestStore.ts:83 |

## 3. procedures.d.ts 등재 시트
| sheet | request_keys | response_cursors | sp_hints |
|---|---|---|---|
| authority |  | o_rc |  |
| division |  | o_rc |  |
| myAuthorityList | sesUserId | o_rc |  |
| userInfo | sesUserId | o_rc |  |

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| Button | onClick | handleInsert | jsx | features/authority/src/pages/auth-request/AuthRequest.tsx | 296 |
| Button | onClick | handleDelete | jsx | features/authority/src/pages/auth-request/AuthRequest.tsx | 304 |
| grid | loadedRows | <arrow> applyRowSelection | addHandler | features/authority/src/pages/auth-request/components/MyAuthorityListGrid.tsx | 62 |
| CustomDropdown | onChange | <arrow> setLangCd | jsx | features/authority/src/pages/auth-request/components/UserInfoDetail.tsx | 79 |
| CustomDropdown | onChange | <arrow> setTmzCd | jsx | features/authority/src/pages/auth-request/components/UserInfoDetail.tsx | 92 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| DetailTableRow | 5 |
| DetailTableHeaderCell | 5 |
| Label | 5 |
| DetailTableDataCell | 5 |
| TitleArea | 4 |
| DataGrid | 3 |
| Typography | 3 |
| Button | 2 |
| CustomDropdown | 2 |
| CommunicationSendIcon | 1 |
| ControlAddIcon | 1 |
| EditDeleteIcon | 1 |
| MainTitle | 1 |
| SubTitle | 1 |
| AuthorityGrid | 1 |
| DivisionGrid | 1 |
| UserInfoDetail | 1 |
| MyAuthorityListGrid | 1 |
| DetailTableLine | 1 |

## 6. 하드코딩 Grid 컬럼
(없음)

## 7. 메시지 코드
| code | count |
|---|---|
| LBL00730 | 1 |
| LBL00731 | 1 |
| MSG00002 | 1 |
| MSG00020 | 2 |
| MSG00021 | 2 |
| MSG00031 | 1 |
| LBL00611 | 1 |
| LBL00733 | 1 |
| LBL00732 | 1 |
| MSG00158 | 1 |
| LBL00620 | 1 |
| LBL00621 | 1 |
| LBL00622 | 1 |
| LBL00640 | 1 |
| LBL00641 | 1 |
| LBL00658 | 1 |
| LBL00673 | 1 |
| LBL00674 | 3 |
| LBL00734 | 1 |
| LBL00735 | 1 |
| LBL00615 | 1 |
| LBL00737 | 1 |
| LBL00738 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: SYS0004(1)
- SP/PKG: (없음)
## 9. 주석 처리된 코드 (현행 기능 아님)
(없음)

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

