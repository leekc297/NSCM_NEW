# SYS0014 — To-Be Fact Pack 요약

- page_key: `admin/group-user` · feature: admin · As-is Fact Pack 없음(화면ID 미대응)
- 파일 13 · 엔드포인트 호출 8 (미해결 0, 주석 속 0) · 이벤트 13 · 컴포넌트 사용 25 · 하드코딩 컬럼 2 · 메시지 11
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 2건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/admin/src/pages/group-user/components/GroupUserInfoGrid.tsx | component | 117 |
| features/admin/src/pages/group-user/components/GroupUserMainGrid.tsx | component | 76 |
| features/admin/src/pages/group-user/components/GroupUserUnitGrid.tsx | component | 37 |
| features/admin/src/pages/group-user/components/modals/DivisionModal.module.scss | component | 164 |
| features/admin/src/pages/group-user/components/modals/DivisionModal.tsx | component | 194 |
| features/admin/src/pages/group-user/components/modals/divisionModalStore.ts | store | 27 |
| features/admin/src/pages/group-user/group-user.constants.ts | constants | 23 |
| features/admin/src/pages/group-user/group-user.types.ts | types | 5 |
| features/admin/src/pages/group-user/GroupUser.module.scss | style | 56 |
| features/admin/src/pages/group-user/GroupUser.tsx | page | 430 |
| features/admin/src/pages/group-user/index.ts | index | 2 |
| features/admin/src/pages/group-user/useGroupUserStore.ts | store | 132 |
| features/admin/src/pages/group-user/__asis-mapping__.md | mapping | 43 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| SYS0014/DivisionPopup//call-proc | hook | 1 | Y | DivisionModal.tsx:35 |
| SYS0014/GroupInfo//call-proc | hook | 2 | Y | GroupUser.tsx:96 GroupUser.tsx:118 |
| SYS0014/UserInfo//call-proc | hook | 1 | Y | GroupUser.tsx:103 |
| SYS0014/Division//call-proc | hook | 1 | Y | GroupUser.tsx:110 |
| /admin/menu/SYS0014/column | http | 3 | Y | useGroupUserStore.ts:100 useGroupUserStore.ts:103 useGroupUserStore.ts:106 |

## 3. procedures.d.ts 등재 시트
| sheet | request_keys | response_cursors | sp_hints |
|---|---|---|---|
| GroupInfo | search | o_rc1 | P_SYS0014_GET_GROUP_LIST_M |
| UserInfo | userGrId | o_rc1 | P_SYS0014_GET_GROUP_LIST_M |
| Division | userGrId userId unitTpCd | o_rc1 | P_SYS0014_GET_GROUP_LIST_M |
| DivisionPopup | searchText | o_rc | P_SYS0014_GET_GROUP_LIST_M |

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| DataGrid | selectionChanged | handleSelectionChanged | jsx | features/admin/src/pages/group-user/components/GroupUserInfoGrid.tsx | 101 |
| DataGrid | gotFocus | <arrow> setFocusSeet | jsx | features/admin/src/pages/group-user/components/GroupUserInfoGrid.tsx | 103 |
| grid | loadedRows | handler | addHandler | features/admin/src/pages/group-user/components/GroupUserMainGrid.tsx | 43 |
| grid | updatedLayout | fillLast | addHandler | features/admin/src/pages/group-user/components/GroupUserMainGrid.tsx | 57 |
| DataGrid | selectionChanged | handleSelectionChanged | jsx | features/admin/src/pages/group-user/components/GroupUserMainGrid.tsx | 70 |
| DataGrid | gotFocus | <arrow> setFocusSeet | jsx | features/admin/src/pages/group-user/components/GroupUserMainGrid.tsx | 71 |
| DataGrid | gotFocus | <arrow> setFocusSeet | jsx | features/admin/src/pages/group-user/components/GroupUserUnitGrid.tsx | 33 |
| SearchArea | onSearch | onSearch | jsx | features/admin/src/pages/group-user/components/modals/DivisionModal.tsx | 128 |
| InputField | onChange | <arrow> setSearchText | jsx | features/admin/src/pages/group-user/components/modals/DivisionModal.tsx | 139 |
| Button | onClick | handleConfirm | jsx | features/admin/src/pages/group-user/components/modals/DivisionModal.tsx | 179 |
| Button | onClick | onClose | jsx | features/admin/src/pages/group-user/components/modals/DivisionModal.tsx | 186 |
| DivisionModal | onClose | closeDivisionModal | jsx | features/admin/src/pages/group-user/GroupUser.tsx | 413 |
| DivisionModal | onSelect | selectDivisionModal | jsx | features/admin/src/pages/group-user/GroupUser.tsx | 414 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| DataGrid | 4 |
| TitleArea | 3 |
| SsoUserModal | 2 |
| Button | 2 |
| CustomDialog | 1 |
| SearchArea | 1 |
| Grid | 1 |
| FormItem | 1 |
| InputField | 1 |
| ProgressIndicator | 1 |
| ResultArea | 1 |
| ControlConfirmIcon | 1 |
| GroupUserMainGrid | 1 |
| GroupUserInfoGrid | 1 |
| GroupUserUnitGrid | 1 |
| MainTitle | 1 |
| SubTitle | 1 |
| DivisionModal | 1 |

## 6. 하드코딩 Grid 컬럼
| context | binding | header | width | visible | isReadOnly | dataType | via | file | line |
|---|---|---|---|---|---|---|---|---|---|
| columns | CODE | CODE | 290 | true |  |  | meta-shape | features/admin/src/pages/group-user/components/modals/DivisionModal.tsx | 50 |
| columns | NAME | NAME | 400 | true |  |  | meta-shape | features/admin/src/pages/group-user/components/modals/DivisionModal.tsx | 57 |

## 7. 메시지 코드
| code | count |
|---|---|
| LBL00674 | 1 |
| LBL00664 | 1 |
| LBL00716 | 1 |
| LBL00627 | 1 |
| MSG00625 | 1 |
| MSG00626 | 1 |
| MSG00627 | 1 |
| MSG00002 | 1 |
| LBL00357 | 1 |
| LBL00658 | 1 |
| LBL00641 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: SYS0014(1), DMF0082(1), SYS0009(1)
- SP/PKG: (없음)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| code | void setAlert({ type: 'alert', content: t('MSG00007', '_변경이 불가한 데이터입니다.') }); | features/admin/src/pages/group-user/components/GroupUserInfoGrid.tsx | 49 |

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

