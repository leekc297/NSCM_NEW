# master_components_columnSettingModal — To-Be Fact Pack 요약

- page_key: `master/components/columnSettingModal` · feature: master · As-is Fact Pack 없음(화면ID 미대응)
- 파일 2 · 엔드포인트 호출 1 (미해결 1, 주석 속 0) · 이벤트 13 · 컴포넌트 사용 6 · 하드코딩 컬럼 0 · 메시지 0
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 0건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/master/src/components/columnSettingModal/ColumnSettingModal.module.scss | style | 46 |
| features/master/src/components/columnSettingModal/ColumnSettingModal.tsx | page | 394 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| {?menuId}/titleSet//call-proc | hook | 1 | N | ColumnSettingModal.tsx:98 |

## 3. procedures.d.ts 등재 시트
(없음)

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| button | onClick | <arrow> e.stopPropagation,toggleSort | jsx | features/master/src/components/columnSettingModal/ColumnSettingModal.tsx | 226 |
| ColumnSelectDualList | onToggleLeft | toggleLeft | jsx | features/master/src/components/columnSettingModal/ColumnSettingModal.tsx | 351 |
| ColumnSelectDualList | onToggleRight | toggleRight | jsx | features/master/src/components/columnSettingModal/ColumnSettingModal.tsx | 352 |
| ColumnSelectDualList | onToggleAllLeft | toggleAllLeft | jsx | features/master/src/components/columnSettingModal/ColumnSettingModal.tsx | 353 |
| ColumnSelectDualList | onToggleAllRight | toggleAllRight | jsx | features/master/src/components/columnSettingModal/ColumnSettingModal.tsx | 354 |
| ColumnSelectDualList | onMoveRight | moveToUser | jsx | features/master/src/components/columnSettingModal/ColumnSettingModal.tsx | 355 |
| ColumnSelectDualList | onMoveLeft | moveToBase | jsx | features/master/src/components/columnSettingModal/ColumnSettingModal.tsx | 356 |
| ColumnSelectDualList | onReorderRight | reorderRight | jsx | features/master/src/components/columnSettingModal/ColumnSettingModal.tsx | 357 |
| ColumnSelectDualList | onRowDoubleClickLeft | moveOneToUser | jsx | features/master/src/components/columnSettingModal/ColumnSettingModal.tsx | 358 |
| ColumnSelectDualList | onRowDoubleClickRight | moveOneToBase | jsx | features/master/src/components/columnSettingModal/ColumnSettingModal.tsx | 359 |
| Button | onClick | handleDefault | jsx | features/master/src/components/columnSettingModal/ColumnSettingModal.tsx | 369 |
| Button | onClick | modalClose | jsx | features/master/src/components/columnSettingModal/ColumnSettingModal.tsx | 377 |
| Button | onClick | handleOk | jsx | features/master/src/components/columnSettingModal/ColumnSettingModal.tsx | 386 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Button | 3 |
| CustomDialog | 1 |
| ColumnSelectDualList | 1 |
| ControlConfirmIcon | 1 |

## 6. 하드코딩 Grid 컬럼
(없음)

## 7. 메시지 코드
(없음)

## 8. 주석 속 As-is 참조
- 화면ID: DMF0020(1), DMF0043_01(1)
- SP/PKG: DMF0002_GET_TITLESET_POPUP(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
(없음)

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

