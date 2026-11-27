# supply_components_bodMasterModal — To-Be Fact Pack 요약

- page_key: `supply/components/bodMasterModal` · feature: supply · As-is Fact Pack 없음(화면ID 미대응)
- 파일 3 · 엔드포인트 호출 1 (미해결 1, 주석 속 0) · 이벤트 6 · 컴포넌트 사용 7 · 하드코딩 컬럼 15 · 메시지 0
- Grid 컬럼 출처: 메타(/column·titleSet) 미사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 15건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/supply/src/components/bodMasterModal/BodMasterModal.module.scss | style | 27 |
| features/supply/src/components/bodMasterModal/BodMasterModal.tsx | page | 265 |
| features/supply/src/components/bodMasterModal/index.ts | index | 2 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| /{menuId}/bodMaster/SEARCH/call-proc | http | 1 | N | BodMasterModal.tsx:122 |

## 3. procedures.d.ts 등재 시트
(없음)

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| grid | loadedRows | keepLockedChecked | addHandler | features/supply/src/components/bodMasterModal/BodMasterModal.tsx | 183 |
| grid | updatedView | keepLockedChecked | addHandler | features/supply/src/components/bodMasterModal/BodMasterModal.tsx | 184 |
| grid | formatItem | <arrow> isLockedRow,e.cell.querySelector,e.cell.classList.toggle | addHandler | features/supply/src/components/bodMasterModal/BodMasterModal.tsx | 186 |
| DataGrid | initialized | handleInitialized | jsx | features/supply/src/components/bodMasterModal/BodMasterModal.tsx | 237 |
| Button | onClick | handleSubmit | jsx | features/supply/src/components/bodMasterModal/BodMasterModal.tsx | 250 |
| Button | onClick | modalClose | jsx | features/supply/src/components/bodMasterModal/BodMasterModal.tsx | 257 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Button | 2 |
| CustomDialog | 1 |
| ProgressIndicator | 1 |
| ResultArea | 1 |
| DataGrid | 1 |
| ControlConfirmIcon | 1 |

## 6. 하드코딩 Grid 컬럼
| context | binding | header | width | visible | isReadOnly | dataType | via | file | line |
|---|---|---|---|---|---|---|---|---|---|
| buildColumns | FIRST_SITE_NAME | To Site\|From Site | 150 |  |  |  | meta-shape | features/supply/src/components/bodMasterModal/BodMasterModal.tsx | 76 |
| buildColumns | SECOND_SITE_NAME | From Site\|To Site | 150 |  |  |  | meta-shape | features/supply/src/components/bodMasterModal/BodMasterModal.tsx | 77 |
| buildColumns | PRIORITY | Priority | 70 |  |  |  | meta-shape | features/supply/src/components/bodMasterModal/BodMasterModal.tsx | 78 |
| buildColumns | INCOTERMS | Incoterms | 80 |  |  |  | meta-shape | features/supply/src/components/bodMasterModal/BodMasterModal.tsx | 79 |
| buildColumns | TRANSPORT_MODE | Trans Mode | 90 |  |  |  | meta-shape | features/supply/src/components/bodMasterModal/BodMasterModal.tsx | 80 |
| buildColumns | DAYS_MON | Mon | 45 |  |  |  | meta-shape | features/supply/src/components/bodMasterModal/BodMasterModal.tsx | 81 |
| buildColumns | DAYS_TUE | Tue | 45 |  |  |  | meta-shape | features/supply/src/components/bodMasterModal/BodMasterModal.tsx | 82 |
| buildColumns | DAYS_WED | Wed | 45 |  |  |  | meta-shape | features/supply/src/components/bodMasterModal/BodMasterModal.tsx | 83 |
| buildColumns | DAYS_THU | Thu | 45 |  |  |  | meta-shape | features/supply/src/components/bodMasterModal/BodMasterModal.tsx | 84 |
| buildColumns | DAYS_FRI | Fri | 45 |  |  |  | meta-shape | features/supply/src/components/bodMasterModal/BodMasterModal.tsx | 85 |
| buildColumns | DAYS_SAT | Sat | 45 |  |  |  | meta-shape | features/supply/src/components/bodMasterModal/BodMasterModal.tsx | 86 |
| buildColumns | DAYS_SUN | Sun | 45 |  |  |  | meta-shape | features/supply/src/components/bodMasterModal/BodMasterModal.tsx | 87 |
| buildColumns | LT_TOTAL | L/T(Day) | 80 |  |  |  | meta-shape | features/supply/src/components/bodMasterModal/BodMasterModal.tsx | 88 |
| buildColumns | FROM_YYYYMMDD | From | 100 |  |  |  | meta-shape | features/supply/src/components/bodMasterModal/BodMasterModal.tsx | 89 |
| buildColumns | TO_YYYYMMDD | To | 100 |  |  |  | meta-shape | features/supply/src/components/bodMasterModal/BodMasterModal.tsx | 90 |

## 7. 메시지 코드
(없음)

## 8. 주석 속 As-is 참조
- 화면ID: SCP0009(2), SCP0010(1)
- SP/PKG: PKG_SCM0002(1), P_SCM0002_GET_BOD_FG_POPUP(1), P_SCM0002_GET_BOD_SEMI_POPUP(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
(없음)

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

