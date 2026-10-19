# SYS0008 — To-Be Fact Pack 요약

- page_key: `admin/group-menu` · feature: admin · As-is Fact Pack 없음(화면ID 미대응)
- 파일 8 · 엔드포인트 호출 9 (미해결 0, 주석 속 0) · 이벤트 3 · 컴포넌트 사용 15 · 하드코딩 컬럼 0 · 메시지 5
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 0건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/admin/src/pages/group-menu/components/ButtonGrid.tsx | component | 38 |
| features/admin/src/pages/group-menu/components/GroupGrid.tsx | component | 57 |
| features/admin/src/pages/group-menu/components/MenuGrid.tsx | component | 75 |
| features/admin/src/pages/group-menu/group-menu.constants.ts | constants | 19 |
| features/admin/src/pages/group-menu/GroupMenuManagement.module.scss | style | 88 |
| features/admin/src/pages/group-menu/GroupMenuManagement.tsx | page | 200 |
| features/admin/src/pages/group-menu/index.ts | index | 2 |
| features/admin/src/pages/group-menu/useGroupMenuStore.ts | store | 90 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| SYS0008/group//call-proc | hook | 2 | Y | GroupMenuManagement.tsx:44 GroupMenuManagement.tsx:68 |
| SYS0008/menu//call-proc | hook | 2 | Y | GroupMenuManagement.tsx:51 GroupMenuManagement.tsx:73 |
| SYS0008/button//call-proc | hook | 2 | Y | GroupMenuManagement.tsx:58 GroupMenuManagement.tsx:78 |
| /admin/menu/SYS0008/column | http | 3 | Y | useGroupMenuStore.ts:67 useGroupMenuStore.ts:70 useGroupMenuStore.ts:73 |

## 3. procedures.d.ts 등재 시트
| sheet | request_keys | response_cursors | sp_hints |
|---|---|---|---|
| group |  | o_rc |  |
| menu | groupId | o_rc |  |
| button | groupId menuId | o_rc |  |

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| DataGrid | gotFocus | handleFocus | jsx | features/admin/src/pages/group-menu/components/ButtonGrid.tsx | 34 |
| DataGrid | gotFocus | handleFocus | jsx | features/admin/src/pages/group-menu/components/GroupGrid.tsx | 51 |
| DataGrid | gotFocus | handleFocus | jsx | features/admin/src/pages/group-menu/components/MenuGrid.tsx | 70 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| DataGrid | 3 |
| Label | 3 |
| Panel | 2 |
| MainTitle | 1 |
| SubTitle | 1 |
| GroupGrid | 1 |
| PanelGroup | 1 |
| MenuGrid | 1 |
| PanelSeparator | 1 |
| ButtonGrid | 1 |

## 6. 하드코딩 Grid 컬럼
(없음)

## 7. 메시지 코드
| code | count |
|---|---|
| MSG00005 | 1 |
| MSG00008 | 1 |
| LBL00357 | 1 |
| LBL00356 | 1 |
| LBL00355 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: (없음)
- SP/PKG: (없음)
## 9. 주석 처리된 코드 (현행 기능 아님)
(없음)

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

