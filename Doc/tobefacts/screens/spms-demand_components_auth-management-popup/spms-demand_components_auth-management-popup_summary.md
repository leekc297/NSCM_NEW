# spms-demand_components_auth-management-popup — To-Be Fact Pack 요약

- page_key: `spms-demand/components/auth-management-popup` · feature: spms-demand · As-is Fact Pack 없음(화면ID 미대응)
- 파일 7 · 엔드포인트 호출 12 (미해결 8, 주석 속 0) · 이벤트 19 · 컴포넌트 사용 21 · 하드코딩 컬럼 0 · 메시지 33
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 0건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/spms-demand/src/components/auth-management-popup/AuthManagementPopup.module.scss | style | 150 |
| features/spms-demand/src/components/auth-management-popup/AuthManagementPopup.tsx | page | 855 |
| features/spms-demand/src/components/auth-management-popup/authManagementPopup.utils.test.ts | test | 74 |
| features/spms-demand/src/components/auth-management-popup/authManagementPopup.utils.ts | other | 62 |
| features/spms-demand/src/components/auth-management-popup/index.ts | index | 3 |
| features/spms-demand/src/components/auth-management-popup/OrgTree.tsx | page | 39 |
| features/spms-demand/src/components/auth-management-popup/useAuthManagementPopupStore.ts | store | 71 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| {MENU_ID}/{?SHEETS.POPUP_ORG}//call-proc | hook | 1 | N | AuthManagementPopup.tsx:98 |
| {MENU_ID}/{?SHEETS.POPUP_USER}//call-proc | hook | 1 | N | AuthManagementPopup.tsx:112 |
| {MENU_ID}/{?SHEETS.POPUP_AUTH_WRITE}//call-proc | hook | 2 | N | AuthManagementPopup.tsx:120 AuthManagementPopup.tsx:145 |
| {MENU_ID}/{?SHEETS.POPUP_AUTH_READ}//call-proc | hook | 2 | N | AuthManagementPopup.tsx:128 AuthManagementPopup.tsx:152 |
| {MENU_ID}/{?SHEETS.POPUP_AUTH_REQ}//call-proc | hook | 1 | N | AuthManagementPopup.tsx:137 |
| {MENU_ID}/{?SHEETS.POPUP_AUTH_REQ}/REJECT/call-proc | hook | 1 | N | AuthManagementPopup.tsx:159 |
| /admin/menu/{MENU_ID}/column | http | 4 | Y | useAuthManagementPopupStore.ts:45 useAuthManagementPopupStore.ts:48 useAuthManagementPopupStore.ts:51 useAuthManagementPopupStore.ts:54 |

## 3. procedures.d.ts 등재 시트
(없음)

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| InputField | onChange | <arrow> setUserKeyword | jsx | features/spms-demand/src/components/auth-management-popup/AuthManagementPopup.tsx | 655 |
| InputField | onKeyDown | <arrow> handleSearchUser | jsx | features/spms-demand/src/components/auth-management-popup/AuthManagementPopup.tsx | 656 |
| Button | onClick | handleSearchUser | jsx | features/spms-demand/src/components/auth-management-popup/AuthManagementPopup.tsx | 665 |
| OrgTree | onSelect | handleSelectDept | jsx | features/spms-demand/src/components/auth-management-popup/AuthManagementPopup.tsx | 676 |
| DataGrid | initialized | restoreMultiRangeSelection | jsx | features/spms-demand/src/components/auth-management-popup/AuthManagementPopup.tsx | 690 |
| Button | onClick | <arrow> handleAddAuth | jsx | features/spms-demand/src/components/auth-management-popup/AuthManagementPopup.tsx | 703 |
| Button | onClick | <arrow> handleRemoveAuth | jsx | features/spms-demand/src/components/auth-management-popup/AuthManagementPopup.tsx | 711 |
| Button | onClick | <arrow> handleAddAuth | jsx | features/spms-demand/src/components/auth-management-popup/AuthManagementPopup.tsx | 721 |
| Button | onClick | <arrow> handleRemoveAuth | jsx | features/spms-demand/src/components/auth-management-popup/AuthManagementPopup.tsx | 729 |
| DataGrid | initialized | restoreMultiRangeSelection | jsx | features/spms-demand/src/components/auth-management-popup/AuthManagementPopup.tsx | 744 |
| Button | onClick | <arrow> handleMoveAuth,t | jsx | features/spms-demand/src/components/auth-management-popup/AuthManagementPopup.tsx | 754 |
| Button | onClick | <arrow> handleMoveAuth,t | jsx | features/spms-demand/src/components/auth-management-popup/AuthManagementPopup.tsx | 769 |
| DataGrid | initialized | restoreMultiRangeSelection | jsx | features/spms-demand/src/components/auth-management-popup/AuthManagementPopup.tsx | 789 |
| DataGrid | formatItem | formatRequestProcess | jsx | features/spms-demand/src/components/auth-management-popup/AuthManagementPopup.tsx | 801 |
| Button | onClick | <arrow> handleApproveRequest | jsx | features/spms-demand/src/components/auth-management-popup/AuthManagementPopup.tsx | 816 |
| Button | onClick | <arrow> handleApproveRequest | jsx | features/spms-demand/src/components/auth-management-popup/AuthManagementPopup.tsx | 823 |
| Button | onClick | <arrow> handleRejectRequest | jsx | features/spms-demand/src/components/auth-management-popup/AuthManagementPopup.tsx | 830 |
| Button | onClick | <arrow> handleSave | jsx | features/spms-demand/src/components/auth-management-popup/AuthManagementPopup.tsx | 847 |
| Tree | onClick | handleClick | jsx | features/spms-demand/src/components/auth-management-popup/OrgTree.tsx | 32 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Button | 11 |
| DataGrid | 4 |
| CustomDialog | 1 |
| ProgressIndicator | 1 |
| InputField | 1 |
| FunctionSearchIcon | 1 |
| OrgTree | 1 |
| Tree | 1 |

## 6. 하드코딩 Grid 컬럼
(없음)

## 7. 메시지 코드
| code | count |
|---|---|
| LBL00635 | 1 |
| MSG00717 | 1 |
| MSG00014 | 5 |
| MSG00715 | 2 |
| MSG00716 | 2 |
| MSG00718 | 1 |
| MSG00623 | 1 |
| MSG00003 | 2 |
| MSG00002 | 1 |
| LBL00868 | 1 |
| LBL00869 | 1 |
| LBL00339 | 1 |
| LBL00664 | 1 |
| LBL00866 | 1 |
| LBL00109 | 2 |
| LBL00407 | 2 |
| LBL00872 | 2 |
| LBL00955 | 1 |
| LBL00956 | 1 |
| LBL00867 | 2 |
| LBL00871 | 1 |
| LBL00863 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: SDM1010(1)
- SP/PKG: P_SES_DIVISION_ID(1), P_SES_USER_ID(1), P_SES_(1), P_SDM1010_GET_POP_USER_ORG(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| jsx | 요청 그리드 PROCESS 셀 버튼 — 하단 OK 버튼과 같은 <Button> 컴포넌트를 그대로 써서 | features/spms-demand/src/components/auth-management-popup/AuthManagementPopup.tsx | 510 |
| jsx | formatItem 이 만드는 순수 DOM이라 <Button> 을 직접 못 앉히므로, formatItem 이 셀 안에 빈 | features/spms-demand/src/components/auth-management-popup/AuthManagementPopup.tsx | 513 |
| jsx | 컨테이너 div만 만들어 두고 그 div로 실제 <Button> 들을 createPortal 한다(JSX는 아래 requestPanel | features/spms-demand/src/components/auth-management-popup/AuthManagementPopup.tsx | 514 |

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

