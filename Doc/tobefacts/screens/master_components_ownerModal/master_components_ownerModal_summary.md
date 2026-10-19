# master_components_ownerModal — To-Be Fact Pack 요약

- page_key: `master/components/ownerModal` · feature: master · As-is Fact Pack 없음(화면ID 미대응)
- 파일 4 · 엔드포인트 호출 2 (미해결 0, 주석 속 0) · 이벤트 7 · 컴포넌트 사용 17 · 하드코딩 컬럼 0 · 메시지 6
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 0건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/master/src/components/ownerModal/owner-modal.constants.ts | constants | 13 |
| features/master/src/components/ownerModal/OwnerModal.module.scss | style | 52 |
| features/master/src/components/ownerModal/OwnerModal.tsx | page | 321 |
| features/master/src/components/ownerModal/ownerModalStore.ts | store | 41 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| COM0004/owner//call-proc | hook | 1 | Y | OwnerModal.tsx:83 |
| /admin/menu/COM0004/column | http | 1 | Y | ownerModalStore.ts:27 |

## 3. procedures.d.ts 등재 시트
(없음)

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| SearchArea | onSearch | handleSearch | jsx | features/master/src/components/ownerModal/OwnerModal.tsx | 221 |
| InputField | onChange | <arrow> setUserInput | jsx | features/master/src/components/ownerModal/OwnerModal.tsx | 231 |
| InputField | onKeyDown | <arrow> handleSearch | jsx | features/master/src/components/ownerModal/OwnerModal.tsx | 232 |
| Button | onClick | handleSelectUsers | jsx | features/master/src/components/ownerModal/OwnerModal.tsx | 266 |
| Button | onClick | handleCancelUsers | jsx | features/master/src/components/ownerModal/OwnerModal.tsx | 270 |
| Button | onClick | handleSubmit | jsx | features/master/src/components/ownerModal/OwnerModal.tsx | 306 |
| Button | onClick | modalClose | jsx | features/master/src/components/ownerModal/OwnerModal.tsx | 313 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Button | 4 |
| ResultArea | 2 |
| DataGrid | 2 |
| ArrowChevron2Icon | 2 |
| CustomDialog | 1 |
| SearchArea | 1 |
| Grid | 1 |
| FormItem | 1 |
| InputField | 1 |
| ProgressIndicator | 1 |
| ControlConfirmIcon | 1 |

## 6. 하드코딩 Grid 컬럼
(없음)

## 7. 메시지 코드
| code | count |
|---|---|
| MSG01000 | 1 |
| LBL00674 | 2 |
| LBL00336 | 1 |
| LBL00664 | 1 |
| LBL00326 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: COM0004(2), DMF0005(1), DMF0082(1)
- SP/PKG: (없음)
## 9. 주석 처리된 코드 (현행 기능 아님)
(없음)

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

