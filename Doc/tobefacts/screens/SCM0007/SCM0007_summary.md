# SCM0007 — To-Be Fact Pack 요약

- page_key: `admin/sms-setup` · feature: admin · As-is Fact Pack 있음
- 파일 16 · 엔드포인트 호출 11 (미해결 0, 주석 속 0) · 이벤트 40 · 컴포넌트 사용 34 · 하드코딩 컬럼 0 · 메시지 34
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 0건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/admin/src/pages/sms-setup/components/SmsCategoryGrid.module.scss | component | 12 |
| features/admin/src/pages/sms-setup/components/SmsCategoryGrid.tsx | component | 144 |
| features/admin/src/pages/sms-setup/components/SmsContentDialog.tsx | component | 97 |
| features/admin/src/pages/sms-setup/components/SmsDialog.module.scss | component | 31 |
| features/admin/src/pages/sms-setup/components/SmsMessageGrid.tsx | component | 119 |
| features/admin/src/pages/sms-setup/components/SmsReceiverPanel.tsx | component | 205 |
| features/admin/src/pages/sms-setup/components/SmsSetupForm.module.scss | component | 4 |
| features/admin/src/pages/sms-setup/components/SmsSetupForm.tsx | component | 87 |
| features/admin/src/pages/sms-setup/components/SmsTabGrid.module.scss | component | 40 |
| features/admin/src/pages/sms-setup/index.ts | index | 2 |
| features/admin/src/pages/sms-setup/sms-setup.constants.ts | constants | 56 |
| features/admin/src/pages/sms-setup/sms-setup.types.ts | types | 32 |
| features/admin/src/pages/sms-setup/sms-setup.util.ts | other | 75 |
| features/admin/src/pages/sms-setup/SmsSetup.module.scss | style | 26 |
| features/admin/src/pages/sms-setup/SmsSetup.tsx | page | 662 |
| features/admin/src/pages/sms-setup/useSmsSetupStore.ts | store | 211 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueries) | hook | 1 | Y | SmsSetupForm.tsx:22 |
| SCM0007/main//call-proc | hook | 1 | Y | SmsSetup.tsx:65 |
| SCM0007/message//call-proc | hook | 1 | Y | SmsSetup.tsx:80 |
| SCM0007/allReceiver//call-proc | hook | 1 | Y | SmsSetup.tsx:88 |
| SCM0007/selReceiver//call-proc | hook | 1 | Y | SmsSetup.tsx:105 |
| /SCM0007/main/SAVE/call-proc | http | 1 | Y | SmsSetup.tsx:191 |
| /SCM0007/message/SAVE/call-proc | http | 1 | Y | SmsSetup.tsx:237 |
| /SCM0007/allReceiver/SAVE/call-proc | http | 1 | Y | SmsSetup.tsx:266 |
| /SCM0007/selReceiver/SAVE/call-proc | http | 1 | Y | SmsSetup.tsx:288 |
| /admin/menu/SCM0007/column | http | 1 | Y | useSmsSetupStore.ts:74 |
| /admin/menu/SCM0007/search-conditions | http | 1 | Y | useSmsSetupStore.ts:140 |

## 3. procedures.d.ts 등재 시트
| sheet | request_keys | response_cursors | sp_hints |
|---|---|---|---|
| main | useType module submodule active | o_rc1 |  |
| message | useType categoryId | o_rc1 |  |
| allReceiver | group phone | o_rc1 |  |
| selReceiver | categoryId | o_rc1 |  |

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| grid | selectionChanged | handleSelectionChanged | addHandler | features/admin/src/pages/sms-setup/components/SmsCategoryGrid.tsx | 44 |
| grid | formatItem | formatItemHandler | addHandler | features/admin/src/pages/sms-setup/components/SmsCategoryGrid.tsx | 74 |
| grid | beginningEdit | beginningEditHandler | addHandler | features/admin/src/pages/sms-setup/components/SmsCategoryGrid.tsx | 99 |
| grid | cellEditEnded | cellEditEndedHandler | addHandler | features/admin/src/pages/sms-setup/components/SmsCategoryGrid.tsx | 118 |
| grid | pastedCell | cellEditEndedHandler | addHandler | features/admin/src/pages/sms-setup/components/SmsCategoryGrid.tsx | 119 |
| DataGrid | gotFocus | onFocus | jsx | features/admin/src/pages/sms-setup/components/SmsCategoryGrid.tsx | 138 |
| textarea | onChange | <arrow> handleChange | jsx | features/admin/src/pages/sms-setup/components/SmsContentDialog.tsx | 66 |
| Button | onClick | handleOk | jsx | features/admin/src/pages/sms-setup/components/SmsContentDialog.tsx | 81 |
| Button | onClick | closeContentDialog | jsx | features/admin/src/pages/sms-setup/components/SmsContentDialog.tsx | 89 |
| grid | formatItem | formatItemHandler | addHandler | features/admin/src/pages/sms-setup/components/SmsMessageGrid.tsx | 72 |
| grid | beginningEdit | beginningEditHandler | addHandler | features/admin/src/pages/sms-setup/components/SmsMessageGrid.tsx | 84 |
| DataGrid | gotFocus | onFocus | jsx | features/admin/src/pages/sms-setup/components/SmsMessageGrid.tsx | 110 |
| grid | cellEditEnded | sanitizePhoneHandler | addHandler | features/admin/src/pages/sms-setup/components/SmsReceiverPanel.tsx | 78 |
| grid | pastedCell | sanitizePhoneHandler | addHandler | features/admin/src/pages/sms-setup/components/SmsReceiverPanel.tsx | 79 |
| InputField | onChange | <arrow> setReceiverSearchParams | jsx | features/admin/src/pages/sms-setup/components/SmsReceiverPanel.tsx | 125 |
| InputField | onChange | <arrow> setReceiverSearchParams | jsx | features/admin/src/pages/sms-setup/components/SmsReceiverPanel.tsx | 136 |
| Button | onClick | onSearchReceiver | jsx | features/admin/src/pages/sms-setup/components/SmsReceiverPanel.tsx | 140 |
| DataGrid | gotFocus | onAllReceiverFocus | jsx | features/admin/src/pages/sms-setup/components/SmsReceiverPanel.tsx | 157 |
| Button | onClick | onAddReceiver | jsx | features/admin/src/pages/sms-setup/components/SmsReceiverPanel.tsx | 164 |
| Button | onClick | onRemoveReceiver | jsx | features/admin/src/pages/sms-setup/components/SmsReceiverPanel.tsx | 167 |
| InputField | onChange | <arrow>  | jsx | features/admin/src/pages/sms-setup/components/SmsReceiverPanel.tsx | 179 |
| InputField | onChange | <arrow>  | jsx | features/admin/src/pages/sms-setup/components/SmsReceiverPanel.tsx | 184 |
| DataGrid | gotFocus | onSelReceiverFocus | jsx | features/admin/src/pages/sms-setup/components/SmsReceiverPanel.tsx | 197 |
| SearchArea | onSearch | onSearch | jsx | features/admin/src/pages/sms-setup/components/SmsSetupForm.tsx | 45 |
| CustomDropdown | onChange | <arrow> setSearchParams | jsx | features/admin/src/pages/sms-setup/components/SmsSetupForm.tsx | 61 |
| CustomDropdown | onChange | <arrow> setSearchParams | jsx | features/admin/src/pages/sms-setup/components/SmsSetupForm.tsx | 77 |
| SmsSetupForm | onSearch | handleSearch | jsx | features/admin/src/pages/sms-setup/SmsSetup.tsx | 561 |
| SmsCategoryGrid | onFocus | <arrow> setFocused | jsx | features/admin/src/pages/sms-setup/SmsSetup.tsx | 598 |
| button | onClick | <arrow> setActiveTab,setFocused | jsx | features/admin/src/pages/sms-setup/SmsSetup.tsx | 607 |
| button | onClick | <arrow> setActiveTab,setFocused | jsx | features/admin/src/pages/sms-setup/SmsSetup.tsx | 621 |
| SmsMessageGrid | onOpenContent | <arrow> openContentDialog | jsx | features/admin/src/pages/sms-setup/SmsSetup.tsx | 635 |
| SmsMessageGrid | onFocus | <arrow> setFocused | jsx | features/admin/src/pages/sms-setup/SmsSetup.tsx | 638 |
| SmsReceiverPanel | onSearchReceiver | handleSearchReceiver | jsx | features/admin/src/pages/sms-setup/SmsSetup.tsx | 648 |
| SmsReceiverPanel | onAddReceiver | handleAddReceiver | jsx | features/admin/src/pages/sms-setup/SmsSetup.tsx | 649 |
| SmsReceiverPanel | onAddReceiverRow | handleAddReceiverRow | jsx | features/admin/src/pages/sms-setup/SmsSetup.tsx | 650 |
| SmsReceiverPanel | onRemoveReceiver | handleRemoveReceiver | jsx | features/admin/src/pages/sms-setup/SmsSetup.tsx | 651 |
| SmsReceiverPanel | onRemoveReceiverRow | handleRemoveReceiverRow | jsx | features/admin/src/pages/sms-setup/SmsSetup.tsx | 652 |
| SmsReceiverPanel | onAllReceiverFocus | <arrow> setFocused | jsx | features/admin/src/pages/sms-setup/SmsSetup.tsx | 653 |
| SmsReceiverPanel | onSelReceiverFocus | <arrow> setFocused | jsx | features/admin/src/pages/sms-setup/SmsSetup.tsx | 654 |
| SmsContentDialog | onApply | handleApplyContent | jsx | features/admin/src/pages/sms-setup/SmsSetup.tsx | 658 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Button | 6 |
| FormItem | 6 |
| DataGrid | 4 |
| InputField | 4 |
| Grid | 2 |
| CustomDropdown | 2 |
| CustomDialog | 1 |
| ControlConfirmIcon | 1 |
| SearchArea | 1 |
| MainTitle | 1 |
| SmsSetupForm | 1 |
| SubTitle | 1 |
| SmsCategoryGrid | 1 |
| SmsMessageGrid | 1 |
| SmsReceiverPanel | 1 |
| SmsContentDialog | 1 |

## 6. 하드코딩 Grid 컬럼
(없음)

## 7. 메시지 코드
| code | count |
|---|---|
| MSG00692 | 1 |
| MSG00693 | 1 |
| MSG00165 | 1 |
| LBL01049 | 1 |
| LBL00359 | 1 |
| LBL00107 | 1 |
| LBL00037 | 2 |
| LBL01048 | 2 |
| LBL00112 | 3 |
| LBL00109 | 1 |
| LBL00407 | 1 |
| LBL00379 | 1 |
| LBL00007 | 1 |
| MSG00697 | 1 |
| MSG00695 | 1 |
| MSG00696 | 1 |
| MSG00691 | 1 |
| MSG00060 | 1 |
| MSG00694 | 1 |
| MSG00003 | 4 |
| MSG00429 | 1 |
| MSG01448 | 1 |
| MSG00005 | 2 |
| MSG01450 | 1 |
| LBL00383 | 1 |
| LBL01047 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: SYS0017(7), SCM0007(5), SCM0006(1)
- SP/PKG: SCM0007_GET_RECIPIENT_SMS_GROUP_LIST(2), SCM0007_GET_RECIPIENT_SMS_ASSIGN(1), SCM0007_SAVE_RECIPIENT_SMS_GROUP(1), SCM0007_SAVE_RECIPIENT_SMS_ASSIGN(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
(없음)

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

