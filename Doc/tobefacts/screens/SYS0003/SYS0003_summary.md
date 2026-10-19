# SYS0003 — To-Be Fact Pack 요약

- page_key: `admin/menu-management` · feature: admin · As-is Fact Pack 없음(화면ID 미대응)
- 파일 8 · 엔드포인트 호출 9 (미해결 0, 주석 속 0) · 이벤트 3 · 컴포넌트 사용 9 · 하드코딩 컬럼 0 · 메시지 3
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 0건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/admin/src/pages/menu-management/components/LevelOneMenuGrid.tsx | component | 91 |
| features/admin/src/pages/menu-management/components/LevelThreeMenuGrid.tsx | component | 80 |
| features/admin/src/pages/menu-management/components/LevelTwoMenuGrid.tsx | component | 89 |
| features/admin/src/pages/menu-management/index.ts | index | 2 |
| features/admin/src/pages/menu-management/menu-management.constants.ts | constants | 19 |
| features/admin/src/pages/menu-management/MenuManagement.module.scss | style | 12 |
| features/admin/src/pages/menu-management/MenuManagement.tsx | page | 310 |
| features/admin/src/pages/menu-management/useMenuManagementStore.ts | store | 123 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| SYS0003/levelOneMenu//call-proc | hook | 2 | Y | MenuManagement.tsx:62 MenuManagement.tsx:86 |
| SYS0003/levelTwoMenu//call-proc | hook | 2 | Y | MenuManagement.tsx:69 MenuManagement.tsx:91 |
| SYS0003/levelThreeMenu//call-proc | hook | 2 | Y | MenuManagement.tsx:76 MenuManagement.tsx:96 |
| /admin/menu/SYS0003/column | http | 3 | Y | useMenuManagementStore.ts:81 useMenuManagementStore.ts:84 useMenuManagementStore.ts:87 |

## 3. procedures.d.ts 등재 시트
| sheet | request_keys | response_cursors | sp_hints |
|---|---|---|---|
| levelOneMenu |  | o_rc |  |
| levelTwoMenu | menuId | o_rc |  |
| levelThreeMenu | menuId | o_rc |  |

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| DataGrid | gotFocus | handleFocus | jsx | features/admin/src/pages/menu-management/components/LevelOneMenuGrid.tsx | 87 |
| DataGrid | gotFocus | handleFocus | jsx | features/admin/src/pages/menu-management/components/LevelThreeMenuGrid.tsx | 75 |
| DataGrid | gotFocus | handleFocus | jsx | features/admin/src/pages/menu-management/components/LevelTwoMenuGrid.tsx | 84 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| DataGrid | 3 |
| MainTitle | 1 |
| SubTitle | 1 |
| LevelOneMenuGrid | 1 |
| LevelTwoMenuGrid | 1 |
| LevelThreeMenuGrid | 1 |
| MessageModal | 1 |

## 6. 하드코딩 Grid 컬럼
(없음)

## 7. 메시지 코드
| code | count |
|---|---|
| MSG00005 | 3 |

## 8. 주석 속 As-is 참조
- 화면ID: (없음)
- SP/PKG: (없음)
## 9. 주석 처리된 코드 (현행 기능 아님)
(없음)

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

