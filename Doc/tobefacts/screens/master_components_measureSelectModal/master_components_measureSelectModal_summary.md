# master_components_measureSelectModal — To-Be Fact Pack 요약

- page_key: `master/components/measureSelectModal` · feature: master · As-is Fact Pack 없음(화면ID 미대응)
- 파일 2 · 엔드포인트 호출 0 (미해결 0, 주석 속 1) · 이벤트 12 · 컴포넌트 사용 6 · 하드코딩 컬럼 2 · 메시지 6
- Grid 컬럼 출처: 메타(/column·titleSet) 미사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 2건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/master/src/components/measureSelectModal/MeasureSelectModal.module.scss | style | 30 |
| features/master/src/components/measureSelectModal/MeasureSelectModal.tsx | page | 399 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
(없음)

## 3. procedures.d.ts 등재 시트
(없음)

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| ColumnSelectDualList | onToggleLeft | toggleLeft | jsx | features/master/src/components/measureSelectModal/MeasureSelectModal.tsx | 357 |
| ColumnSelectDualList | onToggleRight | toggleRight | jsx | features/master/src/components/measureSelectModal/MeasureSelectModal.tsx | 358 |
| ColumnSelectDualList | onToggleAllLeft | toggleAllLeft | jsx | features/master/src/components/measureSelectModal/MeasureSelectModal.tsx | 359 |
| ColumnSelectDualList | onToggleAllRight | toggleAllRight | jsx | features/master/src/components/measureSelectModal/MeasureSelectModal.tsx | 360 |
| ColumnSelectDualList | onMoveRight | moveToUser | jsx | features/master/src/components/measureSelectModal/MeasureSelectModal.tsx | 361 |
| ColumnSelectDualList | onMoveLeft | moveToBase | jsx | features/master/src/components/measureSelectModal/MeasureSelectModal.tsx | 362 |
| ColumnSelectDualList | onReorderRight | reorderRight | jsx | features/master/src/components/measureSelectModal/MeasureSelectModal.tsx | 363 |
| ColumnSelectDualList | onRowDoubleClickLeft | moveOneToUser | jsx | features/master/src/components/measureSelectModal/MeasureSelectModal.tsx | 364 |
| ColumnSelectDualList | onRowDoubleClickRight | moveOneToBase | jsx | features/master/src/components/measureSelectModal/MeasureSelectModal.tsx | 365 |
| Button | onClick | handleDefault | jsx | features/master/src/components/measureSelectModal/MeasureSelectModal.tsx | 375 |
| Button | onClick | handleOk | jsx | features/master/src/components/measureSelectModal/MeasureSelectModal.tsx | 384 |
| Button | onClick | modalClose | jsx | features/master/src/components/measureSelectModal/MeasureSelectModal.tsx | 391 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Button | 3 |
| CustomDialog | 1 |
| ColumnSelectDualList | 1 |
| ControlConfirmIcon | 1 |

## 6. 하드코딩 Grid 컬럼
| context | binding | header | width | visible | isReadOnly | dataType | via | file | line |
|---|---|---|---|---|---|---|---|---|---|
| sourceRows | measure.colNm | measure.colLblNm \|\| measure.colNm |  | Y\|N |  |  | meta-map | features/master/src/components/measureSelectModal/MeasureSelectModal.tsx | 104 |
| sourceRows | code | code |  | N |  |  | meta-map | features/master/src/components/measureSelectModal/MeasureSelectModal.tsx | 113 |

## 7. 메시지 코드
| code | count |
|---|---|
| LBL00713 | 3 |
| LBL00310 | 1 |
| LBL00764 | 1 |
| LBL00765 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: DMF0082(2), DMF0002(1), DMF0021(1), DMF0022(1), DMF0035(1)
- SP/PKG: (없음)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| endpoint | 데이터: measures = SCM_MST_SHEET_MEASURE 동적 fetch(BE GridMeasure camelCase). 화면이 주입. | features/master/src/components/measureSelectModal/MeasureSelectModal.tsx | 15 |

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

