# master_components_storageLocationModal — To-Be Fact Pack 요약

- page_key: `master/components/storageLocationModal` · feature: master · As-is Fact Pack 없음(화면ID 미대응)
- 파일 4 · 엔드포인트 호출 3 (미해결 0, 주석 속 0) · 이벤트 5 · 컴포넌트 사용 14 · 하드코딩 컬럼 0 · 메시지 5
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 0건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/master/src/components/storageLocationModal/storage-location-modal.constants.ts | constants | 8 |
| features/master/src/components/storageLocationModal/StorageLocationModal.module.scss | style | 20 |
| features/master/src/components/storageLocationModal/StorageLocationModal.tsx | page | 223 |
| features/master/src/components/storageLocationModal/storageLocationModalStore.ts | store | 41 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueries) | hook | 1 | Y | StorageLocationModal.tsx:43 |
| COM0003/sloc//call-proc | hook | 1 | Y | StorageLocationModal.tsx:62 |
| /admin/menu/COM0003/column | http | 1 | Y | storageLocationModalStore.ts:27 |

## 3. procedures.d.ts 등재 시트
(없음)

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| SearchArea | onSearch | handleSearch | jsx | features/master/src/components/storageLocationModal/StorageLocationModal.tsx | 144 |
| InputField | onChange | <arrow> setStorageIdInput | jsx | features/master/src/components/storageLocationModal/StorageLocationModal.tsx | 168 |
| InputField | onKeyDown | <arrow> handleSearch | jsx | features/master/src/components/storageLocationModal/StorageLocationModal.tsx | 169 |
| Button | onClick | handleSubmit | jsx | features/master/src/components/storageLocationModal/StorageLocationModal.tsx | 208 |
| Button | onClick | modalClose | jsx | features/master/src/components/storageLocationModal/StorageLocationModal.tsx | 215 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Grid | 2 |
| FormItem | 2 |
| InputField | 2 |
| Button | 2 |
| CustomDialog | 1 |
| SearchArea | 1 |
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
| LBL00335 | 1 |
| LBL00664 | 1 |
| LBL00001 | 1 |
| LBL00319 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: COM0003(2), DMF0082(1)
- SP/PKG: (없음)
## 9. 주석 처리된 코드 (현행 기능 아님)
(없음)

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

