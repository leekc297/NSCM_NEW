# spms-demand__misc — To-Be Fact Pack 요약

- page_key: `spms-demand/_misc` · feature: spms-demand · As-is Fact Pack 없음(화면ID 미대응)
- 파일 7 · 엔드포인트 호출 0 (미해결 0, 주석 속 0) · 이벤트 8 · 컴포넌트 사용 0 · 하드코딩 컬럼 0 · 메시지 0
- Grid 컬럼 출처: 메타(/column·titleSet) 미사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 0건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/spms-demand/src/lib/bulk-save.test.ts | test | 83 |
| features/spms-demand/src/lib/bulk-save.ts | other | 75 |
| features/spms-demand/src/lib/call-proc.ts | other | 86 |
| features/spms-demand/src/lib/comboCascadeAutoFill.ts | other | 161 |
| features/spms-demand/src/lib/date.ts | other | 41 |
| features/spms-demand/src/lib/grid.ts | other | 227 |
| features/spms-demand/src/lib/pendingBuild.ts | other | 49 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
(없음)

## 3. procedures.d.ts 등재 시트
(없음)

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| grid | beginningEdit | capturePreValue | addHandler | features/spms-demand/src/lib/comboCascadeAutoFill.ts | 145 |
| grid | pastingCell | capturePreValue | addHandler | features/spms-demand/src/lib/comboCascadeAutoFill.ts | 146 |
| grid | cellEditEnded | handleEditEnded | addHandler | features/spms-demand/src/lib/comboCascadeAutoFill.ts | 147 |
| grid | pastedCell | handleEditEnded | addHandler | features/spms-demand/src/lib/comboCascadeAutoFill.ts | 148 |
| grid | beginningEdit | wrapAllColumnDataMaps | addHandler | features/spms-demand/src/lib/grid.ts | 84 |
| grid | pastingCell | wrapAllColumnDataMaps | addHandler | features/spms-demand/src/lib/grid.ts | 85 |
| grid | formatItem | <arrow> sender.editRange?.contains,toText | addHandler | features/spms-demand/src/lib/grid.ts | 98 |
| grid | updatedLayout | apply | addHandler | features/spms-demand/src/lib/grid.ts | 189 |

## 5. 컴포넌트 사용 집계
(없음)

## 6. 하드코딩 Grid 컬럼
(없음)

## 7. 메시지 코드
(없음)

## 8. 주석 속 As-is 참조
- 화면ID: SDM1010(6), SDM2020(3), SDM5010(2), DMF0044(1), SDM2010(1)
- SP/PKG: P_SES_USER_ID(1), P_SOP_DATE(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
(없음)

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

