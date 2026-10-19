# spms-demand_components_user-search-popup — To-Be Fact Pack 요약

- page_key: `spms-demand/components/user-search-popup` · feature: spms-demand · As-is Fact Pack 없음(화면ID 미대응)
- 파일 3 · 엔드포인트 호출 2 (미해결 2, 주석 속 0) · 이벤트 8 · 컴포넌트 사용 8 · 하드코딩 컬럼 0 · 메시지 5
- Grid 컬럼 출처: 메타(/column·titleSet) 미사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 0건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/spms-demand/src/components/user-search-popup/index.ts | index | 3 |
| features/spms-demand/src/components/user-search-popup/UserSearchPopup.module.scss | style | 73 |
| features/spms-demand/src/components/user-search-popup/UserSearchPopup.tsx | page | 264 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| {MENU_ID}/{?SHEETS.POPUP_ORG}//call-proc | hook | 1 | N | UserSearchPopup.tsx:66 |
| {MENU_ID}/{?SHEETS.POPUP_USER}//call-proc | hook | 1 | N | UserSearchPopup.tsx:78 |

## 3. procedures.d.ts 등재 시트
(없음)

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| g.hostElement | click | <arrow> g.hitTest,setTimeout,g.rows.filter,checkedRows.forEach,g.invalidate | addEventListener | features/spms-demand/src/components/user-search-popup/UserSearchPopup.tsx | 130 |
| g.hostElement | dblclick | <arrow> g.hitTest,pickRef.current | addEventListener | features/spms-demand/src/components/user-search-popup/UserSearchPopup.tsx | 146 |
| InputField | onChange | <arrow> setUserKeyword | jsx | features/spms-demand/src/components/user-search-popup/UserSearchPopup.tsx | 211 |
| InputField | onKeyDown | <arrow> handleSearchUser | jsx | features/spms-demand/src/components/user-search-popup/UserSearchPopup.tsx | 212 |
| Button | onClick | handleSearchUser | jsx | features/spms-demand/src/components/user-search-popup/UserSearchPopup.tsx | 221 |
| OrgTree | onSelect | handleSelectDept | jsx | features/spms-demand/src/components/user-search-popup/UserSearchPopup.tsx | 231 |
| DataGrid | initialized | handleGridInitialized | jsx | features/spms-demand/src/components/user-search-popup/UserSearchPopup.tsx | 245 |
| Button | onClick | handleOk | jsx | features/spms-demand/src/components/user-search-popup/UserSearchPopup.tsx | 256 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Button | 2 |
| CustomDialog | 1 |
| ProgressIndicator | 1 |
| InputField | 1 |
| FunctionSearchIcon | 1 |
| OrgTree | 1 |
| DataGrid | 1 |

## 6. 하드코딩 Grid 컬럼
(없음)

## 7. 메시지 코드
| code | count |
|---|---|
| MSG00717 | 1 |
| MSG00014 | 1 |
| LBL00339 | 1 |
| LBL00664 | 1 |
| LBL00866 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: SDM1010(2)
- SP/PKG: (없음)
## 9. 주석 처리된 코드 (현행 기능 아님)
(없음)

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

