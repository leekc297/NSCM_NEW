# SYS0007 — To-Be Fact Pack 요약

- page_key: `admin/group-management` · feature: admin · As-is Fact Pack 없음(화면ID 미대응)
- 파일 6 · 엔드포인트 호출 3 (미해결 0, 주석 속 0) · 이벤트 0 · 컴포넌트 사용 5 · 하드코딩 컬럼 0 · 메시지 0
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 0건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/admin/src/pages/group-management/components/GroupManagementGrid.tsx | component | 28 |
| features/admin/src/pages/group-management/group-management.constants.ts | constants | 7 |
| features/admin/src/pages/group-management/GroupManagement.tsx | page | 106 |
| features/admin/src/pages/group-management/index.ts | index | 2 |
| features/admin/src/pages/group-management/useGroupManagementStore.test.tsx | test | 120 |
| features/admin/src/pages/group-management/useGroupManagementStore.ts | store | 61 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| SYS0007/groupMgmt//call-proc | hook | 2 | Y | GroupManagement.tsx:28 GroupManagement.tsx:36 |
| /admin/menu/SYS0007/column | http | 1 | Y | useGroupManagementStore.ts:42 |

## 3. procedures.d.ts 등재 시트
| sheet | request_keys | response_cursors | sp_hints |
|---|---|---|---|
| groupMgmt | group useYn | o_rc |  |

## 4. 이벤트 배선
(없음)

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| DataGrid | 1 |
| MainTitle | 1 |
| SubTitle | 1 |
| GroupManagementGrid | 1 |
| TabIdContext.Provider | 1 |

## 6. 하드코딩 Grid 컬럼
(없음)

## 7. 메시지 코드
(없음)

## 8. 주석 속 As-is 참조
- 화면ID: (없음)
- SP/PKG: (없음)
## 9. 주석 처리된 코드 (현행 기능 아님)
(없음)

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

