# SYS0016 — To-Be Fact Pack 요약

- page_key: `admin/notice-setup` · feature: admin · As-is Fact Pack 없음(화면ID 미대응)
- 파일 17 · 엔드포인트 호출 7 (미해결 0, 주석 속 3) · 이벤트 51 · 컴포넌트 사용 32 · 하드코딩 컬럼 0 · 메시지 59
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 0건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/admin/src/pages/notice-setup/components/NoticePreviewDialog.module.scss | component | 217 |
| features/admin/src/pages/notice-setup/components/NoticePreviewDialog.tsx | component | 144 |
| features/admin/src/pages/notice-setup/components/NoticeRichTextEditor.module.scss | component | 173 |
| features/admin/src/pages/notice-setup/components/NoticeRichTextEditor.tsx | component | 634 |
| features/admin/src/pages/notice-setup/components/NoticeSetupDialog.module.scss | component | 327 |
| features/admin/src/pages/notice-setup/components/NoticeSetupDialog.tsx | component | 419 |
| features/admin/src/pages/notice-setup/components/NoticeSetupForm.module.scss | component | 4 |
| features/admin/src/pages/notice-setup/components/NoticeSetupForm.tsx | component | 112 |
| features/admin/src/pages/notice-setup/components/NoticeSetupGrid.module.scss | component | 46 |
| features/admin/src/pages/notice-setup/components/NoticeSetupGrid.tsx | component | 102 |
| features/admin/src/pages/notice-setup/index.ts | index | 2 |
| features/admin/src/pages/notice-setup/notice-setup.constants.ts | constants | 23 |
| features/admin/src/pages/notice-setup/notice-setup.types.ts | types | 23 |
| features/admin/src/pages/notice-setup/notice-setup.util.ts | other | 123 |
| features/admin/src/pages/notice-setup/NoticeSetup.tsx | page | 159 |
| features/admin/src/pages/notice-setup/useNoticeImageUpload.ts | hook | 28 |
| features/admin/src/pages/notice-setup/useNoticeSetupStore.ts | store | 187 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueries) | hook | 2 | Y | NoticeSetupDialog.tsx:43 NoticeSetupForm.tsx:32 |
| SYS0016/main//call-proc | hook | 2 | Y | NoticeSetup.tsx:40 NoticeSetup.tsx:48 |
| /file/image-upload | http | 1 | Y | useNoticeImageUpload.ts:13 |
| /admin/menu/SYS0016/column | http | 1 | Y | useNoticeSetupStore.ts:84 |
| /admin/menu/SYS0016/search-conditions | http | 1 | Y | useNoticeSetupStore.ts:94 |

## 3. procedures.d.ts 등재 시트
| sheet | request_keys | response_cursors | sp_hints |
|---|---|---|---|
| main | module subModule activeYn | o_rc1 |  |

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| document | keydown | handleKeyDown | addEventListener | features/admin/src/pages/notice-setup/components/NoticePreviewDialog.tsx | 42 |
| button | onClick | <arrow> setIsZoomed | jsx | features/admin/src/pages/notice-setup/components/NoticePreviewDialog.tsx | 98 |
| Checkbox | onChange | setPreviewHideToday | jsx | features/admin/src/pages/notice-setup/components/NoticePreviewDialog.tsx | 120 |
| button | onClick | <arrow> setIsZoomed | jsx | features/admin/src/pages/notice-setup/components/NoticePreviewDialog.tsx | 134 |
| button | onMouseDown | handleToolbarMouseDown | jsx | features/admin/src/pages/notice-setup/components/NoticeRichTextEditor.tsx | 530 |
| button | onClick | <arrow> applyTextFormat | jsx | features/admin/src/pages/notice-setup/components/NoticeRichTextEditor.tsx | 531 |
| button | onMouseDown | handleToolbarMouseDown | jsx | features/admin/src/pages/notice-setup/components/NoticeRichTextEditor.tsx | 539 |
| button | onClick | <arrow> applyTextFormat | jsx | features/admin/src/pages/notice-setup/components/NoticeRichTextEditor.tsx | 540 |
| button | onMouseDown | handleToolbarMouseDown | jsx | features/admin/src/pages/notice-setup/components/NoticeRichTextEditor.tsx | 548 |
| button | onClick | <arrow> applyTextFormat | jsx | features/admin/src/pages/notice-setup/components/NoticeRichTextEditor.tsx | 549 |
| button | onMouseDown | handleToolbarMouseDown | jsx | features/admin/src/pages/notice-setup/components/NoticeRichTextEditor.tsx | 558 |
| button | onClick | <arrow> handleToggleStyle | jsx | features/admin/src/pages/notice-setup/components/NoticeRichTextEditor.tsx | 559 |
| button | onMouseDown | handleToolbarMouseDown | jsx | features/admin/src/pages/notice-setup/components/NoticeRichTextEditor.tsx | 567 |
| button | onClick | <arrow> handleToggleStyle | jsx | features/admin/src/pages/notice-setup/components/NoticeRichTextEditor.tsx | 568 |
| button | onMouseDown | handleToolbarMouseDown | jsx | features/admin/src/pages/notice-setup/components/NoticeRichTextEditor.tsx | 576 |
| button | onClick | <arrow> handleToggleStyle | jsx | features/admin/src/pages/notice-setup/components/NoticeRichTextEditor.tsx | 577 |
| button | onMouseDown | handleToolbarMouseDown | jsx | features/admin/src/pages/notice-setup/components/NoticeRichTextEditor.tsx | 586 |
| button | onClick | <arrow> runCommand | jsx | features/admin/src/pages/notice-setup/components/NoticeRichTextEditor.tsx | 587 |
| button | onMouseDown | handleToolbarMouseDown | jsx | features/admin/src/pages/notice-setup/components/NoticeRichTextEditor.tsx | 595 |
| button | onClick | <arrow> runCommand | jsx | features/admin/src/pages/notice-setup/components/NoticeRichTextEditor.tsx | 596 |
| button | onMouseDown | handleToolbarMouseDown | jsx | features/admin/src/pages/notice-setup/components/NoticeRichTextEditor.tsx | 604 |
| button | onClick | handleCreateLink | jsx | features/admin/src/pages/notice-setup/components/NoticeRichTextEditor.tsx | 605 |
| button | onMouseDown | handleToolbarMouseDown | jsx | features/admin/src/pages/notice-setup/components/NoticeRichTextEditor.tsx | 613 |
| button | onClick | clearNoticeFormatting | jsx | features/admin/src/pages/notice-setup/components/NoticeRichTextEditor.tsx | 614 |
| div | onInput | handleInput | jsx | features/admin/src/pages/notice-setup/components/NoticeRichTextEditor.tsx | 627 |
| div | onPaste | handlePaste | jsx | features/admin/src/pages/notice-setup/components/NoticeRichTextEditor.tsx | 628 |
| div | onBlur | syncContent | jsx | features/admin/src/pages/notice-setup/components/NoticeRichTextEditor.tsx | 629 |
| CustomDropdown | onChange | <arrow> rawSubModules.find,setDraft | jsx | features/admin/src/pages/notice-setup/components/NoticeSetupDialog.tsx | 149 |
| InputField | onChange | <arrow> setDraft | jsx | features/admin/src/pages/notice-setup/components/NoticeSetupDialog.tsx | 190 |
| input | onChange | <arrow> setDraft | jsx | features/admin/src/pages/notice-setup/components/NoticeSetupDialog.tsx | 209 |
| input | onChange | <arrow> setDraft | jsx | features/admin/src/pages/notice-setup/components/NoticeSetupDialog.tsx | 219 |
| input | onChange | <arrow> setDraft | jsx | features/admin/src/pages/notice-setup/components/NoticeSetupDialog.tsx | 239 |
| input | onChange | <arrow> setDraft | jsx | features/admin/src/pages/notice-setup/components/NoticeSetupDialog.tsx | 249 |
| DatePickerCalendar | onChange | <arrow> handleDateChange | jsx | features/admin/src/pages/notice-setup/components/NoticeSetupDialog.tsx | 274 |
| DatePickerCalendar | onChange | <arrow> handleDateChange | jsx | features/admin/src/pages/notice-setup/components/NoticeSetupDialog.tsx | 291 |
| InputField | onChange | <arrow> setDraft | jsx | features/admin/src/pages/notice-setup/components/NoticeSetupDialog.tsx | 313 |
| div | onDragOver | handleImageDragOver | jsx | features/admin/src/pages/notice-setup/components/NoticeSetupDialog.tsx | 325 |
| div | onDrop | handleImageDrop | jsx | features/admin/src/pages/notice-setup/components/NoticeSetupDialog.tsx | 326 |
| input | onChange | handleImageChange | jsx | features/admin/src/pages/notice-setup/components/NoticeSetupDialog.tsx | 346 |
| button | onClick | <arrow> setDraft | jsx | features/admin/src/pages/notice-setup/components/NoticeSetupDialog.tsx | 362 |
| Button | onClick | openDraftPreview | jsx | features/admin/src/pages/notice-setup/components/NoticeSetupDialog.tsx | 388 |
| Button | onClick | onSave | jsx | features/admin/src/pages/notice-setup/components/NoticeSetupDialog.tsx | 395 |
| Button | onClick | onDelete | jsx | features/admin/src/pages/notice-setup/components/NoticeSetupDialog.tsx | 403 |
| Button | onClick | closeEditor | jsx | features/admin/src/pages/notice-setup/components/NoticeSetupDialog.tsx | 411 |
| SearchArea | onSearch | onSearch | jsx | features/admin/src/pages/notice-setup/components/NoticeSetupForm.tsx | 51 |
| CustomDropdown | onChange | <arrow> setSearchParams | jsx | features/admin/src/pages/notice-setup/components/NoticeSetupForm.tsx | 68 |
| CustomDropdown | onChange | <arrow> setSearchParams | jsx | features/admin/src/pages/notice-setup/components/NoticeSetupForm.tsx | 102 |
| grid | formatItem | formatActions | addHandler | features/admin/src/pages/notice-setup/components/NoticeSetupGrid.tsx | 79 |
| NoticeSetupForm | onSearch | handleSearch | jsx | features/admin/src/pages/notice-setup/NoticeSetup.tsx | 144 |
| NoticeSetupDialog | onSave | handleSave | jsx | features/admin/src/pages/notice-setup/NoticeSetup.tsx | 154 |
| NoticeSetupDialog | onDelete | handleDelete | jsx | features/admin/src/pages/notice-setup/NoticeSetup.tsx | 154 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| FormItem | 7 |
| Button | 4 |
| CustomDropdown | 3 |
| CustomDialog | 2 |
| InputField | 2 |
| DatePickerCalendar | 2 |
| Grid | 2 |
| Checkbox | 1 |
| NoticeRichTextEditor | 1 |
| SearchArea | 1 |
| DataGrid | 1 |
| MainTitle | 1 |
| NoticeSetupForm | 1 |
| SubTitle | 1 |
| NoticeSetupGrid | 1 |
| NoticeSetupDialog | 1 |
| NoticePreviewDialog | 1 |

## 6. 하드코딩 Grid 컬럼
(없음)

## 7. 메시지 코드
| code | count |
|---|---|
| LBL00388 | 2 |
| LBL00389 | 2 |
| LBL00412 | 1 |
| LBL00381 | 1 |
| LBL00107 | 1 |
| LBL00832 | 1 |
| LBL00833 | 2 |
| LBL00834 | 1 |
| LBL00835 | 1 |
| LBL00837 | 1 |
| LBL00838 | 1 |
| LBL00839 | 1 |
| LBL00840 | 1 |
| LBL00841 | 1 |
| LBL00842 | 1 |
| LBL00843 | 1 |
| LBL00826 | 1 |
| MSG00003 | 1 |
| LBL00380 | 1 |
| LBL00396 | 1 |
| LBL00391 | 1 |
| LBL00379 | 2 |
| LBL00397 | 1 |
| LBL00007 | 2 |
| LBL00398 | 1 |
| LBL00399 | 1 |
| LBL00382 | 1 |
| LBL00402 | 1 |
| LBL00401 | 1 |
| LBL00390 | 1 |
| LBL00392 | 1 |
| LBL00383 | 1 |
| LBL00384 | 1 |
| LBL00404 | 1 |
| LBL00410 | 2 |
| LBL00411 | 1 |
| LBL00393 | 1 |
| LBL00416 | 1 |
| LBL00406 | 1 |
| LBL00407 | 2 |
| LBL00386 | 1 |
| LBL00385 | 3 |
| LBL00395 | 1 |
| LBL00394 | 1 |
| LBL00112 | 1 |
| LBL00414 | 2 |
| MSG00023 | 1 |
| MSG00108 | 1 |
| MSG00024 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: (없음)
- SP/PKG: (없음)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| endpoint | const [modules, subModules] = useTabComboQueries({ | features/admin/src/pages/notice-setup/components/NoticeSetupDialog.tsx | 39 |
| code | }); | features/admin/src/pages/notice-setup/components/NoticeSetupDialog.tsx | 42 |
| endpoint | const [modules, subModules, yesOrNo] = useTabComboQueries({ | features/admin/src/pages/notice-setup/components/NoticeSetupForm.tsx | 24 |
| code | }); | features/admin/src/pages/notice-setup/components/NoticeSetupForm.tsx | 26 |
| endpoint | const [modules, subModules, yesOrNo] = useTabComboQueries({ | features/admin/src/pages/notice-setup/components/NoticeSetupForm.tsx | 29 |
| code | }); | features/admin/src/pages/notice-setup/components/NoticeSetupForm.tsx | 31 |
| code | .map(item => ({ label: item.NAME, value: item.CODE })) ?? []; | features/admin/src/pages/notice-setup/components/NoticeSetupForm.tsx | 45 |

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

