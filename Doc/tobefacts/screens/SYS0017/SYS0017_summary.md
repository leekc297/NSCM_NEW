# SYS0017 — To-Be Fact Pack 요약

- page_key: `admin/mail-setup` · feature: admin · As-is Fact Pack 없음(화면ID 미대응)
- 파일 17 · 엔드포인트 호출 12 (미해결 0, 주석 속 0) · 이벤트 35 · 컴포넌트 사용 37 · 하드코딩 컬럼 0 · 메시지 31
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 0건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/admin/src/pages/mail-setup/components/MailCategoryGrid.module.scss | component | 36 |
| features/admin/src/pages/mail-setup/components/MailCategoryGrid.tsx | component | 145 |
| features/admin/src/pages/mail-setup/components/MailContentDialog.tsx | component | 90 |
| features/admin/src/pages/mail-setup/components/MailDialog.module.scss | component | 43 |
| features/admin/src/pages/mail-setup/components/MailMessageGrid.tsx | component | 77 |
| features/admin/src/pages/mail-setup/components/MailReceiverPanel.tsx | component | 155 |
| features/admin/src/pages/mail-setup/components/MailSetupForm.module.scss | component | 4 |
| features/admin/src/pages/mail-setup/components/MailSetupForm.tsx | component | 105 |
| features/admin/src/pages/mail-setup/components/MailSqlDialog.tsx | component | 97 |
| features/admin/src/pages/mail-setup/components/MailTabGrid.module.scss | component | 40 |
| features/admin/src/pages/mail-setup/index.ts | index | 2 |
| features/admin/src/pages/mail-setup/mail-setup.constants.ts | constants | 55 |
| features/admin/src/pages/mail-setup/mail-setup.types.ts | types | 31 |
| features/admin/src/pages/mail-setup/mail-setup.util.ts | other | 78 |
| features/admin/src/pages/mail-setup/MailSetup.module.scss | style | 26 |
| features/admin/src/pages/mail-setup/MailSetup.tsx | page | 585 |
| features/admin/src/pages/mail-setup/useMailSetupStore.ts | store | 224 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueries) | hook | 1 | Y | MailSetupForm.tsx:22 |
| SYS0017/sqlText//call-proc | hook | 1 | Y | MailSqlDialog.tsx:41 |
| SYS0017/main//call-proc | hook | 1 | Y | MailSetup.tsx:72 |
| SYS0017/message//call-proc | hook | 1 | Y | MailSetup.tsx:87 |
| SYS0017/allReceiver//call-proc | hook | 1 | Y | MailSetup.tsx:95 |
| SYS0017/selReceiver//call-proc | hook | 1 | Y | MailSetup.tsx:103 |
| /SYS0017/main/SAVE/call-proc | http | 1 | Y | MailSetup.tsx:184 |
| /SYS0017/message/SAVE/call-proc | http | 1 | Y | MailSetup.tsx:219 |
| /SYS0017/selReceiver/SAVE/call-proc | http | 1 | Y | MailSetup.tsx:241 |
| /SYS0017/sqlText/SAVE/call-proc | http | 1 | Y | MailSetup.tsx:415 |
| /admin/menu/SYS0017/column | http | 1 | Y | useMailSetupStore.ts:83 |
| /admin/menu/SYS0017/search-conditions | http | 1 | Y | useMailSetupStore.ts:147 |

## 3. procedures.d.ts 등재 시트
| sheet | request_keys | response_cursors | sp_hints |
|---|---|---|---|
| main | useType module submodule active | o_rc1 |  |
| message | useType categoryId | o_rc1 |  |
| allReceiver | user dept | o_rc1 |  |
| selReceiver | useType categoryId | o_rc1 |  |
| sqlText | useType module submodule categoryId | o_rc1 |  |

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| grid | selectionChanged | handleSelectionChanged | addHandler | features/admin/src/pages/mail-setup/components/MailCategoryGrid.tsx | 44 |
| grid | formatItem | handleFormatItem | addHandler | features/admin/src/pages/mail-setup/components/MailCategoryGrid.tsx | 95 |
| DataGrid | gotFocus | onFocus | jsx | features/admin/src/pages/mail-setup/components/MailCategoryGrid.tsx | 139 |
| textarea | onChange | <arrow> handleChange | jsx | features/admin/src/pages/mail-setup/components/MailContentDialog.tsx | 60 |
| Button | onClick | handleOk | jsx | features/admin/src/pages/mail-setup/components/MailContentDialog.tsx | 74 |
| Button | onClick | closeContentDialog | jsx | features/admin/src/pages/mail-setup/components/MailContentDialog.tsx | 82 |
| DataGrid | gotFocus | onFocus | jsx | features/admin/src/pages/mail-setup/components/MailMessageGrid.tsx | 68 |
| InputField | onChange | <arrow> setReceiverSearchParams | jsx | features/admin/src/pages/mail-setup/components/MailReceiverPanel.tsx | 88 |
| InputField | onChange | <arrow> setReceiverSearchParams | jsx | features/admin/src/pages/mail-setup/components/MailReceiverPanel.tsx | 98 |
| Button | onClick | onSearchReceiver | jsx | features/admin/src/pages/mail-setup/components/MailReceiverPanel.tsx | 102 |
| Button | onClick | onAddReceiver | jsx | features/admin/src/pages/mail-setup/components/MailReceiverPanel.tsx | 120 |
| Button | onClick | onRemoveReceiver | jsx | features/admin/src/pages/mail-setup/components/MailReceiverPanel.tsx | 123 |
| InputField | onChange | <arrow>  | jsx | features/admin/src/pages/mail-setup/components/MailReceiverPanel.tsx | 134 |
| DataGrid | gotFocus | onSelReceiverFocus | jsx | features/admin/src/pages/mail-setup/components/MailReceiverPanel.tsx | 147 |
| SearchArea | onSearch | onSearch | jsx | features/admin/src/pages/mail-setup/components/MailSetupForm.tsx | 45 |
| CustomDropdown | onChange | <arrow> setSearchParams | jsx | features/admin/src/pages/mail-setup/components/MailSetupForm.tsx | 61 |
| CustomDropdown | onChange | <arrow> setSearchParams | jsx | features/admin/src/pages/mail-setup/components/MailSetupForm.tsx | 95 |
| textarea | onChange | <arrow> setSqlText | jsx | features/admin/src/pages/mail-setup/components/MailSqlDialog.tsx | 69 |
| Button | onClick | <arrow> onSave | jsx | features/admin/src/pages/mail-setup/components/MailSqlDialog.tsx | 82 |
| Button | onClick | closeSqlDialog | jsx | features/admin/src/pages/mail-setup/components/MailSqlDialog.tsx | 89 |
| MailSetupForm | onSearch | handleSearch | jsx | features/admin/src/pages/mail-setup/MailSetup.tsx | 477 |
| MailCategoryGrid | onOpenSqlDialog | <arrow> selectCategory,openSqlDialog | jsx | features/admin/src/pages/mail-setup/MailSetup.tsx | 513 |
| MailCategoryGrid | onFocus | <arrow> setFocused | jsx | features/admin/src/pages/mail-setup/MailSetup.tsx | 517 |
| button | onClick | <arrow> setActiveTab,setFocused | jsx | features/admin/src/pages/mail-setup/MailSetup.tsx | 529 |
| button | onClick | <arrow> setReceiverFilters,setActiveTab,setFocused | jsx | features/admin/src/pages/mail-setup/MailSetup.tsx | 542 |
| MailMessageGrid | onOpenContent | <arrow> openContentDialog | jsx | features/admin/src/pages/mail-setup/MailSetup.tsx | 558 |
| MailMessageGrid | onFocus | <arrow> setFocused | jsx | features/admin/src/pages/mail-setup/MailSetup.tsx | 561 |
| MailReceiverPanel | onSearchReceiver | handleSearchReceiver | jsx | features/admin/src/pages/mail-setup/MailSetup.tsx | 571 |
| MailReceiverPanel | onAddReceiver | handleAddReceiver | jsx | features/admin/src/pages/mail-setup/MailSetup.tsx | 572 |
| MailReceiverPanel | onAddReceiverRow | handleAddReceiverRow | jsx | features/admin/src/pages/mail-setup/MailSetup.tsx | 573 |
| MailReceiverPanel | onRemoveReceiver | handleRemoveReceiver | jsx | features/admin/src/pages/mail-setup/MailSetup.tsx | 574 |
| MailReceiverPanel | onRemoveReceiverRow | handleRemoveReceiverRow | jsx | features/admin/src/pages/mail-setup/MailSetup.tsx | 575 |
| MailReceiverPanel | onSelReceiverFocus | <arrow> setFocused | jsx | features/admin/src/pages/mail-setup/MailSetup.tsx | 576 |
| MailContentDialog | onApply | handleApplyContent | jsx | features/admin/src/pages/mail-setup/MailSetup.tsx | 580 |
| MailSqlDialog | onSave | handleSaveSqlText | jsx | features/admin/src/pages/mail-setup/MailSetup.tsx | 581 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Button | 8 |
| FormItem | 5 |
| DataGrid | 4 |
| InputField | 3 |
| CustomDialog | 2 |
| ControlConfirmIcon | 2 |
| Grid | 2 |
| CustomDropdown | 2 |
| SearchArea | 1 |
| MainTitle | 1 |
| MailSetupForm | 1 |
| SubTitle | 1 |
| MailCategoryGrid | 1 |
| MailMessageGrid | 1 |
| MailReceiverPanel | 1 |
| MailContentDialog | 1 |
| MailSqlDialog | 1 |

## 6. 하드코딩 Grid 컬럼
(없음)

## 7. 메시지 코드
| code | count |
|---|---|
| LBL00780 | 2 |
| MSG00165 | 1 |
| LBL00782 | 1 |
| LBL00359 | 2 |
| LBL00107 | 2 |
| LBL00615 | 2 |
| LBL00339 | 1 |
| LBL00112 | 3 |
| LBL00109 | 1 |
| LBL00407 | 1 |
| LBL00379 | 1 |
| LBL00007 | 1 |
| MSG00697 | 1 |
| MSG00695 | 1 |
| MSG00696 | 1 |
| MSG00691 | 1 |
| MSG00694 | 1 |
| MSG00003 | 4 |
| MSG00429 | 1 |
| MSG00060 | 1 |
| LBL00383 | 1 |
| LBL00774 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: SCM0007(1), SCM0006(1)
- SP/PKG: PKG_SYS0017(1), P_SYS0017_SAVE_RECIPIENT_MASTER_U(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| code | const subModuleOptions = (subModules as ComboOption[] \| undefined) ?.filter(item => !selectedModules \|\| selectedModules.includes(item.PARENT_CODE ?? '')).map(item => ({ label: item.NAME, value: item.CODE })); | features/admin/src/pages/mail-setup/components/MailSetupForm.tsx | 35 |
| code | PopSQL 8분할 텍스트 결합 (AS-IS TEXT1~TEXT8) -> CLOB — SP가 VARCHAR2 4000자 제한으로 sql_text 커럼 하나로 반환하도록 변경 export const joinSqlText = (row?: Record<string, string>) => { if (!row) return ''; return [1, 2, 3, 4, 5, 6, 7, 8].map(index => row[`TEXT${ind | features/admin/src/pages/mail-setup/mail-setup.util.ts | 73 |
| code | }); | features/admin/src/pages/mail-setup/MailSetup.tsx | 150 |
| code | const handleDeleteCategory = () => { | features/admin/src/pages/mail-setup/MailSetup.tsx | 331 |
| code | if (!categoryGridRef.current) return; | features/admin/src/pages/mail-setup/MailSetup.tsx | 332 |
| code | GridAction.removeRow(categoryGridRef.current, true); | features/admin/src/pages/mail-setup/MailSetup.tsx | 333 |
| code | }; | features/admin/src/pages/mail-setup/MailSetup.tsx | 334 |

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

