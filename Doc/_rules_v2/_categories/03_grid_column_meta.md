# 카테고리 03 — Grid·컬럼 메타·Wijmo / Grid, Column Meta & Wijmo

> **연다: 언제?** DataGrid/컬럼 구성/SHEET_COLUMNS/PIVOT 동적 컬럼/머지/셀 인터랙션을 다룰 때.

## A. Grid 공용 컴포넌트·구성
| # | Hook | 강도 | 계율 1줄 |
|---:|---|:--:|---|
| 10 | [datagrid-shared-component-mandatory](../hooks/datagrid-shared-component-mandatory.md) | ⭐⭐⭐ | 공용 DataGrid 만 사용 — FlexGrid JSX 직접 금지 + foundation utils 4종 |
| 67 | [wijmo-flexgrid-entry](../hooks/wijmo-flexgrid-entry.md) | ⭐⭐ | Wijmo 작업 진입점 — 가이드 2파일 + 안티패턴 10 |
| 18 | [grid-cell-interaction-patterns-mandatory](../hooks/grid-cell-interaction-patterns-mandatory.md) | ⭐⭐⭐ | Grid 3 시나리오(A/B/C) + drill-down + 다중 popup + CSV |
| 21 | [grid-interaction-patterns](../hooks/grid-interaction-patterns.md) | ⭐ | selectionMode=Row + server state 자동체크 금지 + loadedRows |
| 69 | [wijmo-merge-sticky-content](../hooks/wijmo-merge-sticky-content.md) | ⭐⭐ | 세로 merge + viewport sticky (CustomMergeManager) |
| 68 | [wijmo-insert-cell-dropdown](../hooks/wijmo-insert-cell-dropdown.md) | ⭐ | Insert cell ComboBox 12단계 1-pass |
| 102 | [custom-context-menu-standard](../hooks/custom-context-menu-standard.md) | ⭐⭐ | 우클릭 메뉴 3종 세트 — 항목 실행=mousedown / dismiss=persistent+contains 가드 |
| 103 | [pivot-header-drilldown](../hooks/pivot-header-drilldown.md) | ⭐⭐ | PIVOT 헤더 dblclick 드릴다운 — 전 버킷 상시 렌더 + 표시 rank 분리 |
| 89 | [screen-grid-edit-merge-and-meta-mandatory](../hooks/screen-grid-edit-merge-and-meta-mandatory.md) §G | ⭐⭐⭐ | mergeManager=DataGrid props 직접 + sameRow 기준 `CRUD_TYPE`+`INSERT_GROUP_ID` |
| 97 | [common-button-grid-routing](../hooks/common-button-grid-routing.md) | ⭐⭐ | 그리드 자체 Add/Delete toolbar 금지 → 공통버튼 활성그리드 라우팅 + No 컬럼 2방식 |

## B. 컬럼 메타 (SHEET_COLUMNS·표시·개인화)
| # | Hook | 강도 | 계율 1줄 |
|---:|---|:--:|---|
| 19 | [grid-column-meta](../hooks/grid-column-meta.md) | ⭐ | Grid/Column 메타 14 ctrl + 5 edit type |
| 7 | [column-lookup-meta-standard](../hooks/column-lookup-meta-standard.md) | ⭐⭐ | dropdown=`CELL_COMBO_DATA_TYPE` 위치 / `INPUT_TP_CD` 5종(`MI` 금지) |
| 54 | [sheet-columns-binding-match](../hooks/sheet-columns-binding-match.md) | ⭐ | SHEET_COLUMNS ↔ SP alias 일치 — 하드코딩 staticColumns 금지 |
| 84 | [sheet-columns-meta-completeness](../hooks/sheet-columns-meta-completeness.md) | ⭐ | SHEET_COLUMNS 완전성 + obsolete sheet 정리 |
| 65 | [ui-category-setup-column-meta](../hooks/ui-category-setup-column-meta.md) | ⭐⭐ | admin column 메타 동적 fetch + 부재 시 신규 등록 (child) |
| 92 | [column-division-id-visibility](../hooks/column-division-id-visibility.md) | ⭐⭐⭐ | DIVISION_ID 콤마 토큰 기반 컬럼 표시 (구방식 — 신규는 #113 우선) |
| 113 | [ui-category-division-direct-compare](../hooks/ui-category-division-direct-compare.md) | ⭐⭐ | DIVISION_ID 가시성=서버 직접 비교(divisionId 전송+재fetch). 하드코딩/화이트리스트/FALLBACK 금지 |
| 8 | [column-meta-rework-checklist](../hooks/column-meta-rework-checklist.md) | ⭐⭐ | 기존 column 재작업 8 점검 |
| 20 | [grid-column-setting-popup-pattern](../hooks/grid-column-setting-popup-pattern.md) | ⭐⭐ | Column 표시설정 popup 5단계 + 재진입 복원 |
| 130 | [ui-meta-consumption-and-crud-path-coverage](../hooks/ui-meta-consumption-and-crud-path-coverage.md) | ⭐⭐⭐ | **메타 "존재" 가 아니라 "실소비"** — 컬럼명 배열 상수로 편집/잠금 결정 BLOCK(AS-IS `LockRange` → FE 상수 이식이 전형 함정, 파리티는 `INPUT_TP_CD` 값으로) + 셀 컨트롤 3요소(메타·트리거·파라미터) + 저장 경로 전수(신규행 C·조회 R 은 대체 불가) + 완료 선언 커버리지 표(안 본 축=ERROR) |
| 115 | [titleset-cache-immunization](../hooks/titleset-cache-immunization.md) | ⭐⭐⭐ | titleset 'C' 캐시 오염 면역 3층(SP 가드+모달 dedup+메타 동기) — 일회성 DELETE 금지 |

## Cross-ref
- TO-BE 정밀: `_tobe/07_datagrid.md` / `_tobe/08_column_meta.md` · DDL: 메모리 `reference_scm_sheet_columns_ddl`
- 메모리(다수): `feedback_grid_cell_cascade_standard`(#59 §5-G) / `feedback_wijmo_*` 계열 / `feedback_sheet_columns_binding_must_match_sp` / `feedback_titleset_cache_immunization`
- 관련 카테고리: 편집 잠금·색 → 02/01, 콤보 → 04
