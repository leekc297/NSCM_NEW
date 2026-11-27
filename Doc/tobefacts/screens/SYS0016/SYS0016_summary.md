# SYS0016 — To-Be Fact Pack 요약

- page_key: `admin/notice-setup` · feature: admin · As-is Fact Pack 없음(화면ID 미대응)
- 파일 20 · 엔드포인트 호출 10 (미해결 2, 주석 속 3) · 이벤트 55 · 컴포넌트 사용 31 · 하드코딩 컬럼 0 · 메시지 56
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 0건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/admin/src/pages/notice-setup/components/NoticePreviewDialog.module.scss | component | 313 |
| features/admin/src/pages/notice-setup/components/NoticePreviewDialog.tsx | component | 176 |
| features/admin/src/pages/notice-setup/components/NoticeRichTextEditor.module.scss | component | 178 |
| features/admin/src/pages/notice-setup/components/NoticeRichTextEditor.tsx | component | 748 |
| features/admin/src/pages/notice-setup/components/NoticeSetupDialog.module.scss | component | 411 |
| features/admin/src/pages/notice-setup/components/NoticeSetupDialog.tsx | component | 451 |
| features/admin/src/pages/notice-setup/components/NoticeSetupForm.module.scss | component | 4 |
| features/admin/src/pages/notice-setup/components/NoticeSetupForm.tsx | component | 112 |
| features/admin/src/pages/notice-setup/components/NoticeSetupGrid.module.scss | component | 46 |
| features/admin/src/pages/notice-setup/components/NoticeSetupGrid.tsx | component | 102 |
| features/admin/src/pages/notice-setup/index.ts | index | 2 |
| features/admin/src/pages/notice-setup/notice-setup.constants.ts | constants | 23 |
| features/admin/src/pages/notice-setup/notice-setup.types.ts | types | 30 |
| features/admin/src/pages/notice-setup/notice-setup.util.test.ts | test | 59 |
| features/admin/src/pages/notice-setup/notice-setup.util.ts | other | 179 |
| features/admin/src/pages/notice-setup/NoticeSetup.tsx | page | 221 |
| features/admin/src/pages/notice-setup/useAttachmentUpload.ts | hook | 33 |
| features/admin/src/pages/notice-setup/useNoticeAttachments.ts | hook | 38 |
| features/admin/src/pages/notice-setup/useNoticeImageUpload.ts | hook | 28 |
| features/admin/src/pages/notice-setup/useNoticeSetupStore.ts | store | 217 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueries) | hook | 2 | Y | NoticeSetupDialog.tsx:75 NoticeSetupForm.tsx:32 |
| SYS0016/main//call-proc | hook | 2 | Y | NoticeSetup.tsx:43 NoticeSetup.tsx:51 |
| /file/upload | http | 1 | Y | useAttachmentUpload.ts:21 |
| /notice/{encodeURIComponent(noticeId)}/attachments | http | 2 | N | useNoticeAttachments.ts:16 useNoticeAttachments.ts:29 |
| /file/image-upload | http | 1 | Y | useNoticeImageUpload.ts:13 |
| /admin/menu/SYS0016/column | http | 1 | Y | useNoticeSetupStore.ts:95 |
| /admin/menu/SYS0016/search-conditions | http | 1 | Y | useNoticeSetupStore.ts:105 |

## 3. procedures.d.ts 등재 시트
| sheet | request_keys | response_cursors | sp_hints |
|---|---|---|---|
| main | module subModule activeYn | o_rc1 |  |

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| document | keydown | handleKeyDown | addEventListener | features/admin/src/pages/notice-setup/components/NoticePreviewDialog.tsx | 57 |
| button | onClick | closePreview | jsx | features/admin/src/pages/notice-setup/components/NoticePreviewDialog.tsx | 81 |
| button | onClick | closePreview | jsx | features/admin/src/pages/notice-setup/components/NoticePreviewDialog.tsx | 92 |
| div | onClick | handleContentClick | jsx | features/admin/src/pages/notice-setup/components/NoticePreviewDialog.tsx | 102 |
| button | onClick | <arrow> setZoomedImage | jsx | features/admin/src/pages/notice-setup/components/NoticePreviewDialog.tsx | 117 |
| Checkbox | onChange | setPreviewHideToday | jsx | features/admin/src/pages/notice-setup/components/NoticePreviewDialog.tsx | 156 |
| button | onClick | <arrow> setZoomedImage | jsx | features/admin/src/pages/notice-setup/components/NoticePreviewDialog.tsx | 166 |
| button | onMouseDown | handleToolbarMouseDown | jsx | features/admin/src/pages/notice-setup/components/NoticeRichTextEditor.tsx | 624 |
| button | onClick | <arrow> applyTextFormat | jsx | features/admin/src/pages/notice-setup/components/NoticeRichTextEditor.tsx | 625 |
| button | onMouseDown | handleToolbarMouseDown | jsx | features/admin/src/pages/notice-setup/components/NoticeRichTextEditor.tsx | 633 |
| button | onClick | <arrow> applyTextFormat | jsx | features/admin/src/pages/notice-setup/components/NoticeRichTextEditor.tsx | 634 |
| button | onMouseDown | handleToolbarMouseDown | jsx | features/admin/src/pages/notice-setup/components/NoticeRichTextEditor.tsx | 642 |
| button | onClick | <arrow> applyTextFormat | jsx | features/admin/src/pages/notice-setup/components/NoticeRichTextEditor.tsx | 643 |
| button | onMouseDown | handleToolbarMouseDown | jsx | features/admin/src/pages/notice-setup/components/NoticeRichTextEditor.tsx | 652 |
| button | onClick | <arrow> handleToggleStyle | jsx | features/admin/src/pages/notice-setup/components/NoticeRichTextEditor.tsx | 653 |
| button | onMouseDown | handleToolbarMouseDown | jsx | features/admin/src/pages/notice-setup/components/NoticeRichTextEditor.tsx | 661 |
| button | onClick | <arrow> handleToggleStyle | jsx | features/admin/src/pages/notice-setup/components/NoticeRichTextEditor.tsx | 662 |
| button | onMouseDown | handleToolbarMouseDown | jsx | features/admin/src/pages/notice-setup/components/NoticeRichTextEditor.tsx | 670 |
| button | onClick | <arrow> handleToggleStyle | jsx | features/admin/src/pages/notice-setup/components/NoticeRichTextEditor.tsx | 671 |
| button | onMouseDown | handleToolbarMouseDown | jsx | features/admin/src/pages/notice-setup/components/NoticeRichTextEditor.tsx | 680 |
| button | onClick | <arrow> runCommand | jsx | features/admin/src/pages/notice-setup/components/NoticeRichTextEditor.tsx | 681 |
| button | onMouseDown | handleToolbarMouseDown | jsx | features/admin/src/pages/notice-setup/components/NoticeRichTextEditor.tsx | 689 |
| button | onClick | <arrow> runCommand | jsx | features/admin/src/pages/notice-setup/components/NoticeRichTextEditor.tsx | 690 |
| button | onMouseDown | handleToolbarMouseDown | jsx | features/admin/src/pages/notice-setup/components/NoticeRichTextEditor.tsx | 698 |
| button | onClick | handleCreateLink | jsx | features/admin/src/pages/notice-setup/components/NoticeRichTextEditor.tsx | 699 |
| button | onMouseDown | handleToolbarMouseDown | jsx | features/admin/src/pages/notice-setup/components/NoticeRichTextEditor.tsx | 708 |
| button | onClick | <arrow> saveEditorSelection,imageInputRef.current?.click | jsx | features/admin/src/pages/notice-setup/components/NoticeRichTextEditor.tsx | 709 |
| input | onChange | handleImageInputChange | jsx | features/admin/src/pages/notice-setup/components/NoticeRichTextEditor.tsx | 721 |
| button | onMouseDown | handleToolbarMouseDown | jsx | features/admin/src/pages/notice-setup/components/NoticeRichTextEditor.tsx | 727 |
| button | onClick | clearNoticeFormatting | jsx | features/admin/src/pages/notice-setup/components/NoticeRichTextEditor.tsx | 728 |
| div | onInput | handleInput | jsx | features/admin/src/pages/notice-setup/components/NoticeRichTextEditor.tsx | 741 |
| div | onPaste | handlePaste | jsx | features/admin/src/pages/notice-setup/components/NoticeRichTextEditor.tsx | 742 |
| div | onBlur | syncContent | jsx | features/admin/src/pages/notice-setup/components/NoticeRichTextEditor.tsx | 743 |
| CustomDropdown | onChange | <arrow> rawSubModules.find,setDraft | jsx | features/admin/src/pages/notice-setup/components/NoticeSetupDialog.tsx | 180 |
| InputField | onChange | <arrow> setDraft | jsx | features/admin/src/pages/notice-setup/components/NoticeSetupDialog.tsx | 221 |
| input | onChange | <arrow> setDraft | jsx | features/admin/src/pages/notice-setup/components/NoticeSetupDialog.tsx | 240 |
| input | onChange | <arrow> setDraft | jsx | features/admin/src/pages/notice-setup/components/NoticeSetupDialog.tsx | 250 |
| input | onChange | <arrow> setDraft | jsx | features/admin/src/pages/notice-setup/components/NoticeSetupDialog.tsx | 270 |
| input | onChange | <arrow> setDraft | jsx | features/admin/src/pages/notice-setup/components/NoticeSetupDialog.tsx | 280 |
| DatePickerCalendar | onChange | <arrow> handleDateChange | jsx | features/admin/src/pages/notice-setup/components/NoticeSetupDialog.tsx | 305 |
| DatePickerCalendar | onChange | <arrow> handleDateChange | jsx | features/admin/src/pages/notice-setup/components/NoticeSetupDialog.tsx | 322 |
| InputField | onChange | <arrow> setDraft | jsx | features/admin/src/pages/notice-setup/components/NoticeSetupDialog.tsx | 344 |
| input | onChange | handleAttachmentChange | jsx | features/admin/src/pages/notice-setup/components/NoticeSetupDialog.tsx | 361 |
| button | onClick | <arrow> removeAttachment | jsx | features/admin/src/pages/notice-setup/components/NoticeSetupDialog.tsx | 390 |
| Button | onClick | openDraftPreview | jsx | features/admin/src/pages/notice-setup/components/NoticeSetupDialog.tsx | 420 |
| Button | onClick | onSave | jsx | features/admin/src/pages/notice-setup/components/NoticeSetupDialog.tsx | 427 |
| Button | onClick | onDelete | jsx | features/admin/src/pages/notice-setup/components/NoticeSetupDialog.tsx | 435 |
| Button | onClick | closeEditor | jsx | features/admin/src/pages/notice-setup/components/NoticeSetupDialog.tsx | 443 |
| SearchArea | onSearch | onSearch | jsx | features/admin/src/pages/notice-setup/components/NoticeSetupForm.tsx | 51 |
| CustomDropdown | onChange | <arrow> setSearchParams | jsx | features/admin/src/pages/notice-setup/components/NoticeSetupForm.tsx | 68 |
| CustomDropdown | onChange | <arrow> setSearchParams | jsx | features/admin/src/pages/notice-setup/components/NoticeSetupForm.tsx | 102 |
| grid | formatItem | formatActions | addHandler | features/admin/src/pages/notice-setup/components/NoticeSetupGrid.tsx | 79 |
| NoticeSetupForm | onSearch | handleSearch | jsx | features/admin/src/pages/notice-setup/NoticeSetup.tsx | 206 |
| NoticeSetupDialog | onSave | handleSave | jsx | features/admin/src/pages/notice-setup/NoticeSetup.tsx | 216 |
| NoticeSetupDialog | onDelete | handleDelete | jsx | features/admin/src/pages/notice-setup/NoticeSetup.tsx | 216 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| FormItem | 7 |
| Button | 4 |
| CustomDropdown | 3 |
| InputField | 2 |
| DatePickerCalendar | 2 |
| Grid | 2 |
| Checkbox | 1 |
| CustomDialog | 1 |
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
| MSG00003 | 2 |
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
| LBL00410 | 1 |
| LBL00843 | 1 |
| LBL00386 | 2 |
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
| LBL00393 | 1 |
| LBL00407 | 2 |
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
| endpoint | const [modules, subModules] = useTabComboQueries({ | features/admin/src/pages/notice-setup/components/NoticeSetupDialog.tsx | 71 |
| code | }); | features/admin/src/pages/notice-setup/components/NoticeSetupDialog.tsx | 74 |
| jsx | 2026-09-16 사용자 요구 - Module:Sub Module 1:1 매핑이라 입력 칸 제거, Module 선택 시 자동 매핑 <FormItem label={t('LBL00378', '_Sub Module')} labelAlign='right' required render={() => ( <CustomDropdown isInput={false} value={draft.SUB_MODULE} options={subModule | features/admin/src/pages/notice-setup/components/NoticeSetupDialog.tsx | 196 |
| endpoint | const [modules, subModules, yesOrNo] = useTabComboQueries({ | features/admin/src/pages/notice-setup/components/NoticeSetupForm.tsx | 24 |
| code | }); | features/admin/src/pages/notice-setup/components/NoticeSetupForm.tsx | 26 |
| endpoint | const [modules, subModules, yesOrNo] = useTabComboQueries({ | features/admin/src/pages/notice-setup/components/NoticeSetupForm.tsx | 29 |
| code | }); | features/admin/src/pages/notice-setup/components/NoticeSetupForm.tsx | 31 |
| code | .map(item => ({ label: item.NAME, value: item.CODE })) ?? []; | features/admin/src/pages/notice-setup/components/NoticeSetupForm.tsx | 45 |
| jsx | 2026-09-11 사용자 요구로 Sub Module 조회조건 제거 <Grid size={3}> <FormItem className={commonStyles.formItem} label={t('LBL00378', '_Sub Module')} labelAlign='right' render={() => ( <CustomDropdown allOption isInput={false} value={searchParams.subModul | features/admin/src/pages/notice-setup/components/NoticeSetupForm.tsx | 73 |

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

