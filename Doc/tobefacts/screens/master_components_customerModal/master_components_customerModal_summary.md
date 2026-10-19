# master_components_customerModal — To-Be Fact Pack 요약

- page_key: `master/components/customerModal` · feature: master · As-is Fact Pack 없음(화면ID 미대응)
- 파일 4 · 엔드포인트 호출 3 (미해결 0, 주석 속 0) · 이벤트 7 · 컴포넌트 사용 17 · 하드코딩 컬럼 0 · 메시지 6
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 0건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/master/src/components/customerModal/customer-modal.constants.ts | constants | 8 |
| features/master/src/components/customerModal/CustomerModal.module.scss | style | 21 |
| features/master/src/components/customerModal/CustomerModal.tsx | page | 268 |
| features/master/src/components/customerModal/customerModalStore.ts | store | 41 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueries) | hook | 1 | Y | CustomerModal.tsx:52 |
| COM0002/customer//call-proc | hook | 1 | Y | CustomerModal.tsx:72 |
| /admin/menu/COM0002/column | http | 1 | Y | customerModalStore.ts:27 |

## 3. procedures.d.ts 등재 시트
(없음)

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| SearchArea | onSearch | handleSearch | jsx | features/master/src/components/customerModal/CustomerModal.tsx | 171 |
| InputField | onChange | <arrow> setSoldToInput | jsx | features/master/src/components/customerModal/CustomerModal.tsx | 198 |
| InputField | onKeyDown | <arrow> handleSearch | jsx | features/master/src/components/customerModal/CustomerModal.tsx | 199 |
| InputField | onChange | <arrow> setShipToInput | jsx | features/master/src/components/customerModal/CustomerModal.tsx | 213 |
| InputField | onKeyDown | <arrow> handleSearch | jsx | features/master/src/components/customerModal/CustomerModal.tsx | 214 |
| Button | onClick | handleSubmit | jsx | features/master/src/components/customerModal/CustomerModal.tsx | 253 |
| Button | onClick | modalClose | jsx | features/master/src/components/customerModal/CustomerModal.tsx | 260 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Grid | 3 |
| FormItem | 3 |
| InputField | 3 |
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
| LBL00337 | 1 |
| LBL00664 | 1 |
| LBL00001 | 1 |
| LBL00081 | 1 |
| LBL00320 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: DMF0082(1)
- SP/PKG: (없음)
## 9. 주석 처리된 코드 (현행 기능 아님)
(없음)

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

