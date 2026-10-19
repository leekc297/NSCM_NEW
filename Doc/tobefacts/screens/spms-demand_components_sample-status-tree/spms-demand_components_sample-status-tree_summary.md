# spms-demand_components_sample-status-tree — To-Be Fact Pack 요약

- page_key: `spms-demand/components/sample-status-tree` · feature: spms-demand · As-is Fact Pack 없음(화면ID 미대응)
- 파일 5 · 엔드포인트 호출 0 (미해결 0, 주석 속 0) · 이벤트 2 · 컴포넌트 사용 2 · 하드코딩 컬럼 0 · 메시지 3
- Grid 컬럼 출처: 메타(/column·titleSet) 미사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 0건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/spms-demand/src/components/sample-status-tree/index.ts | index | 10 |
| features/spms-demand/src/components/sample-status-tree/SampleStatusTree.module.scss | style | 36 |
| features/spms-demand/src/components/sample-status-tree/SampleStatusTree.tsx | page | 75 |
| features/spms-demand/src/components/sample-status-tree/sampleStatusTree.utils.test.ts | test | 92 |
| features/spms-demand/src/components/sample-status-tree/sampleStatusTree.utils.ts | other | 105 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
(없음)

## 3. procedures.d.ts 등재 시트
(없음)

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| Switch | onChange | <arrow> onToggleProgress | jsx | features/spms-demand/src/components/sample-status-tree/SampleStatusTree.tsx | 57 |
| Tree | onClick | handleClick | jsx | features/spms-demand/src/components/sample-status-tree/SampleStatusTree.tsx | 67 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Switch | 1 |
| Tree | 1 |

## 6. 하드코딩 Grid 컬럼
(없음)

## 7. 메시지 코드
| code | count |
|---|---|
| LBL01020 | 1 |
| LBL01021 | 2 |

## 8. 주석 속 As-is 참조
- 화면ID: SDM2010(2), SDM2020(2)
- SP/PKG: P_SDM2020_GET_PJT_SAMPLE_TREE(1), PKG_SDM2010(1), PKG_SDM2020(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
(없음)

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

