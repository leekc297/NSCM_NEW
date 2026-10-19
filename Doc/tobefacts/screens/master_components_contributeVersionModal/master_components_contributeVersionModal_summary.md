# master_components_contributeVersionModal — To-Be Fact Pack 요약

- page_key: `master/components/contributeVersionModal` · feature: master · As-is Fact Pack 없음(화면ID 미대응)
- 파일 4 · 엔드포인트 호출 4 (미해결 0, 주석 속 0) · 이벤트 10 · 컴포넌트 사용 13 · 하드코딩 컬럼 0 · 메시지 12
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 0건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/master/src/components/contributeVersionModal/contribute-version-modal.constants.ts | constants | 21 |
| features/master/src/components/contributeVersionModal/ContributeVersionModal.module.scss | style | 22 |
| features/master/src/components/contributeVersionModal/ContributeVersionModal.tsx | page | 451 |
| features/master/src/components/contributeVersionModal/contributeVersionModalStore.ts | store | 52 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| DMF0043/yearPopup//call-proc | hook | 1 | Y | ContributeVersionModal.tsx:111 |
| DMF0043/ratePopup//call-proc | hook | 1 | Y | ContributeVersionModal.tsx:134 |
| /DMF0043/version/SAVE/call-proc | http | 1 | Y | ContributeVersionModal.tsx:323 |
| /admin/menu/DMF0043/column | http | 1 | Y | contributeVersionModalStore.ts:40 |

## 3. procedures.d.ts 등재 시트
(없음)

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| globalThis.window | keydown | handler | addEventListener | features/master/src/components/contributeVersionModal/ContributeVersionModal.tsx | 85 |
| grid | formatItem | <arrow>  | addHandler | features/master/src/components/contributeVersionModal/ContributeVersionModal.tsx | 195 |
| GridHotkeys | onInsert | handleInsert | jsx | features/master/src/components/contributeVersionModal/ContributeVersionModal.tsx | 365 |
| GridHotkeys | onDelete | handleDelete | jsx | features/master/src/components/contributeVersionModal/ContributeVersionModal.tsx | 365 |
| SearchArea | onSearch | handleFind | jsx | features/master/src/components/contributeVersionModal/ContributeVersionModal.tsx | 368 |
| CustomDropdown | onChange | <arrow> yearOptions.find,String,setSelectedYear,String(opt?.CODE).substring | jsx | features/master/src/components/contributeVersionModal/ContributeVersionModal.tsx | 383 |
| Button | onClick | handleInsert | jsx | features/master/src/components/contributeVersionModal/ContributeVersionModal.tsx | 420 |
| Button | onClick | handleDelete | jsx | features/master/src/components/contributeVersionModal/ContributeVersionModal.tsx | 427 |
| Button | onClick | <arrow> handleSave | jsx | features/master/src/components/contributeVersionModal/ContributeVersionModal.tsx | 436 |
| Button | onClick | <arrow> modalClose | jsx | features/master/src/components/contributeVersionModal/ContributeVersionModal.tsx | 443 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Button | 4 |
| CustomDialog | 1 |
| GridHotkeys | 1 |
| SearchArea | 1 |
| FormItem | 1 |
| CustomDropdown | 1 |
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
| MSG00019 | 1 |
| MSG00014 | 1 |
| MSG00002 | 1 |
| MSG00003 | 1 |
| LBL00604 | 1 |
| LBL00664 | 1 |
| LBL00086 | 1 |
| LBL00121 | 1 |
| LBL00108 | 1 |
| LBL00111 | 1 |
| LBL00107 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: DMF0043(1), DMF0082(1)
- SP/PKG: DMF0043_GET_CONTRIBUTE_RATE_POPUP(3), DMF0043_SAVE_DM_MST_CONTRIBUTE_VER(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
(없음)

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

