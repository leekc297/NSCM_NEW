# master_components_ownerByDivisionModal — To-Be Fact Pack 요약

- page_key: `master/components/ownerByDivisionModal` · feature: master · As-is Fact Pack 없음(화면ID 미대응)
- 파일 4 · 엔드포인트 호출 4 (미해결 0, 주석 속 0) · 이벤트 5 · 컴포넌트 사용 23 · 하드코딩 컬럼 0 · 메시지 8
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 0건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/master/src/components/ownerByDivisionModal/owner-by-division-modal.constants.ts | constants | 8 |
| features/master/src/components/ownerByDivisionModal/OwnerByDivisionModal.module.scss | style | 20 |
| features/master/src/components/ownerByDivisionModal/OwnerByDivisionModal.tsx | page | 358 |
| features/master/src/components/ownerByDivisionModal/ownerByDivisionModalStore.ts | store | 43 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueries) | hook | 2 | Y | OwnerByDivisionModal.tsx:60 OwnerByDivisionModal.tsx:75 |
| COM0006/ownerByDivision//call-proc | hook | 1 | Y | OwnerByDivisionModal.tsx:85 |
| /admin/menu/COM0006/column | http | 1 | Y | ownerByDivisionModalStore.ts:29 |

## 3. procedures.d.ts 등재 시트
(없음)

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| SearchArea | onSearch | handleSearch | jsx | features/master/src/components/ownerByDivisionModal/OwnerByDivisionModal.tsx | 198 |
| InputField | onChange | <arrow> setOwnerKeyword | jsx | features/master/src/components/ownerByDivisionModal/OwnerByDivisionModal.tsx | 295 |
| InputField | onKeyDown | <arrow> handleSearch | jsx | features/master/src/components/ownerByDivisionModal/OwnerByDivisionModal.tsx | 296 |
| Button | onClick | handleSubmit | jsx | features/master/src/components/ownerByDivisionModal/OwnerByDivisionModal.tsx | 343 |
| Button | onClick | modalClose | jsx | features/master/src/components/ownerByDivisionModal/OwnerByDivisionModal.tsx | 350 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Grid | 5 |
| FormItem | 5 |
| CustomDropdown | 4 |
| Button | 2 |
| CustomDialog | 1 |
| SearchArea | 1 |
| InputField | 1 |
| ProgressIndicator | 1 |
| ResultArea | 1 |
| DataGrid | 1 |
| ControlConfirmIcon | 1 |

## 6. 하드코딩 Grid 컬럼
(없음)

## 7. 메시지 코드
| code | count |
|---|---|
| LBL00674 | 1 |
| LBL00336 | 1 |
| LBL00664 | 1 |
| LBL00001 | 1 |
| LBL00044 | 1 |
| LBL00080 | 1 |
| LBL00011 | 1 |
| LBL00082 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: DMF0008(1), COM0006(1), DMF0005(1), DMF0082(1)
- SP/PKG: P_OWNER_ID(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
(없음)

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

