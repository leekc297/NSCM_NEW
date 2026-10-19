# SYS0012 — To-Be Fact Pack 요약

- page_key: `authority/auth-approval` · feature: authority · As-is Fact Pack 없음(화면ID 미대응)
- 파일 10 · 엔드포인트 호출 6 (미해결 0, 주석 속 0) · 이벤트 15 · 컴포넌트 사용 26 · 하드코딩 컬럼 0 · 메시지 32
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 0건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/authority/src/pages/auth-approval/auth-approval.constants.ts | constants | 21 |
| features/authority/src/pages/auth-approval/auth-approval.types.ts | types | 34 |
| features/authority/src/pages/auth-approval/AuthApproval.tsx | page | 236 |
| features/authority/src/pages/auth-approval/components/AuthApprovalForm.module.scss | component | 35 |
| features/authority/src/pages/auth-approval/components/AuthApprovalForm.tsx | component | 130 |
| features/authority/src/pages/auth-approval/components/AuthApprovalGrid.tsx | component | 58 |
| features/authority/src/pages/auth-approval/components/AuthRejectPopup.module.scss | component | 19 |
| features/authority/src/pages/auth-approval/components/AuthRejectPopup.tsx | component | 89 |
| features/authority/src/pages/auth-approval/index.ts | index | 2 |
| features/authority/src/pages/auth-approval/useAuthApprovalStore.ts | store | 129 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| SYS0012/main//call-proc | hook | 1 | Y | AuthApproval.tsx:53 |
| /SYS0012/main/APPROVE/call-proc | http | 1 | Y | AuthApproval.tsx:105 |
| /SYS0012/main/REJECT/call-proc | http | 1 | Y | AuthApproval.tsx:141 |
| (useTabComboQueries) | hook | 1 | Y | AuthApprovalForm.tsx:25 |
| /admin/menu/SYS0012/column | http | 1 | Y | useAuthApprovalStore.ts:86 |
| /admin/menu/SYS0012/search-conditions | http | 1 | Y | useAuthApprovalStore.ts:96 |

## 3. procedures.d.ts 등재 시트
(없음)

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| AuthApprovalForm | onSearch | handleSearch | jsx | features/authority/src/pages/auth-approval/AuthApproval.tsx | 218 |
| AuthRejectPopup | onReject | doReject | jsx | features/authority/src/pages/auth-approval/AuthApproval.tsx | 231 |
| SearchArea | onSearch | onSearch | jsx | features/authority/src/pages/auth-approval/components/AuthApprovalForm.tsx | 50 |
| CustomDropdown | onChange | <arrow> setSc | jsx | features/authority/src/pages/auth-approval/components/AuthApprovalForm.tsx | 63 |
| InputField | onChange | <arrow> setSc | jsx | features/authority/src/pages/auth-approval/components/AuthApprovalForm.tsx | 79 |
| InputField | onKeyDown | <arrow> onSearch | jsx | features/authority/src/pages/auth-approval/components/AuthApprovalForm.tsx | 80 |
| InputField | onChange | <arrow> setSc | jsx | features/authority/src/pages/auth-approval/components/AuthApprovalForm.tsx | 94 |
| InputField | onKeyDown | <arrow> onSearch | jsx | features/authority/src/pages/auth-approval/components/AuthApprovalForm.tsx | 95 |
| CustomDropdown | onChange | <arrow> setSc | jsx | features/authority/src/pages/auth-approval/components/AuthApprovalForm.tsx | 110 |
| PeriodField | onChange | <arrow> setSc | jsx | features/authority/src/pages/auth-approval/components/AuthApprovalForm.tsx | 123 |
| DataGrid | selectionChanged | onSelectionchange | jsx | features/authority/src/pages/auth-approval/components/AuthApprovalGrid.tsx | 53 |
| DataGrid | formatItem | handleFormatItem | jsx | features/authority/src/pages/auth-approval/components/AuthApprovalGrid.tsx | 54 |
| InputField | onChange | <arrow> setReason | jsx | features/authority/src/pages/auth-approval/components/AuthRejectPopup.tsx | 60 |
| Button | onClick | handleSave | jsx | features/authority/src/pages/auth-approval/components/AuthRejectPopup.tsx | 74 |
| Button | onClick | <arrow> setOpen | jsx | features/authority/src/pages/auth-approval/components/AuthRejectPopup.tsx | 81 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| FormItem | 5 |
| Grid | 4 |
| InputField | 3 |
| CustomDropdown | 2 |
| Button | 2 |
| MainTitle | 1 |
| AuthApprovalForm | 1 |
| SubTitle | 1 |
| AuthRejectPopup | 1 |
| AuthApprovalGrid | 1 |
| SearchArea | 1 |
| PeriodField | 1 |
| DataGrid | 1 |
| CustomDialog | 1 |
| ControlConfirmIcon | 1 |

## 6. 하드코딩 Grid 컬럼
(없음)

## 7. 메시지 코드
| code | count |
|---|---|
| MSG00619 | 2 |
| MSG00621 | 4 |
| MSG00622 | 1 |
| MSG00003 | 4 |
| MSG00181 | 2 |
| MSG00620 | 2 |
| MSG00623 | 1 |
| LBL00623 | 1 |
| LBL00624 | 1 |
| LBL00632 | 1 |
| LBL00620 | 1 |
| LBL00634 | 1 |
| LBL00635 | 1 |
| LBL00112 | 1 |
| LBL00001 | 1 |
| LBL00339 | 1 |
| LBL00615 | 1 |
| LBL00678 | 1 |
| LBL00747 | 1 |
| LBL00628 | 1 |
| LBL00625 | 1 |
| LBL00111 | 1 |
| LBL00627 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: SYS0012(3), DMF0043(1), SCM0009(1)
- SP/PKG: P_SYS0012_GET_APPROVAL_LIST(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| code | await queryClient.invalidateQueries({ queryKey: [tabId] }); | features/authority/src/pages/auth-approval/AuthApproval.tsx | 110 |

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

