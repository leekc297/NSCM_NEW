# master_components_contributeRateModal — To-Be Fact Pack 요약

- page_key: `master/components/contributeRateModal` · feature: master · As-is Fact Pack 없음(화면ID 미대응)
- 파일 4 · 엔드포인트 호출 2 (미해결 0, 주석 속 0) · 이벤트 2 · 컴포넌트 사용 6 · 하드코딩 컬럼 0 · 메시지 1
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 0건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/master/src/components/contributeRateModal/contribute-rate-modal.constants.ts | constants | 10 |
| features/master/src/components/contributeRateModal/ContributeRateModal.module.scss | style | 20 |
| features/master/src/components/contributeRateModal/ContributeRateModal.tsx | page | 164 |
| features/master/src/components/contributeRateModal/contributeRateModalStore.ts | store | 41 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| DMF0043/ratePopup//call-proc | hook | 1 | Y | ContributeRateModal.tsx:55 |
| /admin/menu/DMF0043/column | http | 1 | Y | contributeRateModalStore.ts:29 |

## 3. procedures.d.ts 등재 시트
(없음)

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| Button | onClick | modalClose | jsx | features/master/src/components/contributeRateModal/ContributeRateModal.tsx | 147 |
| Button | onClick | handleSubmit | jsx | features/master/src/components/contributeRateModal/ContributeRateModal.tsx | 156 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Button | 2 |
| CustomDialog | 1 |
| ResultArea | 1 |
| DataGrid | 1 |
| ControlConfirmIcon | 1 |

## 6. 하드코딩 Grid 컬럼
(없음)

## 7. 메시지 코드
| code | count |
|---|---|
| LBL00674 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: DMF0043(1), DMF0082(1)
- SP/PKG: (없음)
## 9. 주석 처리된 코드 (현행 기능 아님)
(없음)

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

