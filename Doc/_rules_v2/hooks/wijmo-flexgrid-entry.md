# Hook — Wijmo FlexGrid 작업 진입점 (사용자 가이드 2 파일 의무 참조)

> ⚠️ **Wijmo FlexGrid 코드 작성 / 수정 시 본 hook 이 단일 진입점**
> 사용자 추가 가이드 2 파일을 사전 의무 Read + 자기 점검 + 기존 wijmo hooks 5 종 cross-ref.

작성: 2026-06-17 (사용자가 `Doc/` 하위에 Wijmo FlexGrid 가이드 2 파일 추가 + 클로드코드 통합 요구)
관련 룰: `column-meta-rework-checklist.md`, `grid-column-meta.md`, `ui-category-setup-column-meta.md`
상위 룰: `anti-simplification.md`

---

## §0. 배경 — 사용자 추가 가이드 2 파일 (2026-06-17)

| 파일 | 크기 | 용도 |
|---|---|---|
| `Doc/wijmo-flexgrid-guide.md` | 17.7 KB | **개념 정신 모델** — CollectionView 중심 + 패키지 imports + 편집/변경 추적 + Column 정의 + 셀 커스터마이징 4 방식 + DataMap + React 함정 + **§10 안티패턴 → 올바른 패턴 (Claude Code 교정용)** + §11 CLAUDE.md 규칙 블록 |
| `Doc/wijmo-flexgrid-api-reference.md` | 22.8 KB | **정확한 시그니처 (grep 용)** — FlexGrid 속성/메서드/이벤트 + Column 속성 + CollectionView 옵션/메서드 |

> 가이드 §11 자체가 "CLAUDE.md 에 붙여넣을 규칙 블록" 형식. 본 hook 이 그 진입점.

---

## §1. 적용 시점

다음 트리거 발동 시 본 hook 의무 진입:

| 트리거 | 예 |
|---|---|
| T01 / T04 / T07 작업 | "DMF0043 그리드 수정", "FlexGrid 컬럼 추가" |
| Wijmo 직접 사용 화면 작업 | DMF0008/0020/0043/0043_01 등 (DataGrid wrapper 우회) |
| `@mescius/wijmo*` import 신규 / 변경 | 모든 신규 화면 + 기존 화면 grid 변경 |
| `CollectionView` 사용 | 정렬/필터/그룹/페이징/변경추적 필요 시 |
| `cellTemplate` / `itemFormatter` / `FlexGridCellTemplate` 작성 | 셀 커스터마이징 |

---

## §2. 사전 필독 (의무 Read)

### 2.1 가이드 — 정신 모델

```
Read: Doc/wijmo-flexgrid-guide.md
  ⭐ §0  "Claude Code 가 가장 자주 틀리는 3가지" (FlexGrid ≠ SpreadJS ≠ AG Grid ≠ MUI, @mescius/* 패키지, CollectionView 중심)
  ⭐ §10 안티패턴 → 올바른 패턴 (Claude Code 교정용, 10 row)
  §11 CLAUDE.md 붙여넣을 규칙 블록
  §1~9 작성 직전 한 번 정독 (1회로 충분)
```

### 2.2 API reference — 정확한 시그니처 (grep)

```
Read (on-demand): Doc/wijmo-flexgrid-api-reference.md
  §1 패키지 맵 (무엇을 어디서 import)
  §2 FlexGrid 속성 / §3 메서드 / §4 이벤트
  §5 Column 속성
  §6 CollectionView 옵션/속성/메서드
  → 특정 prop / 메서드 / 이벤트 시그니처 필요 시 grep
```

---

## §3. 핵심 안티패턴 → 올바른 패턴 (가이드 §10 발췌)

| ❌ Claude Code 가 흔히 하는 것 | ✅ 올바른 Wijmo FlexGrid |
|---|---|
| `gridApi`, `columnDefs`, `rowData` 사용 | AG Grid 문법 — FlexGrid 엔 없음. `columns` + `itemsSource` |
| `renderCell`, `valueGetter`, `valueFormatter` | MUI 문법 — `cellTemplate` / `itemFormatter` / `column.format` |
| `sheet.getCell(r,c).value()` | SpreadJS 문법 — `getCellData(r, c)` 또는 데이터 객체 직접 |
| `@grapecity/wijmo` / `wijmo` import | `@mescius/wijmo*` |
| 렌더마다 `new CollectionView(...)` | `useMemo` / `useRef` 로 **1회 생성** |
| 원본 배열 `push` / 직접 수정 후 저장 | `view.addNew/commitNew`, `editItem/commitEdit` (trackChanges 위해) |
| `cell.innerHTML` 로 직접 DOM 조립 | `CellMaker` 또는 `FlexGridCellTemplate` |
| 정렬/필터 변경 후 화면 안 바뀜 | `view.refresh()` 호출 |
| `yyyy-mm-dd` 포맷 | `yyyy-MM-dd` (월은 대문자) |
| 자동 열 생성 그대로 둠 | `autoGenerateColumns={false}` + 명시적 `columns` |
| 코드값을 그대로 표시 | `DataMap` 으로 코드↔명칭 매핑 |

---

## §4. 자기 점검 5 항목 (코드 작성 직후)

```
[ ] 1. 패키지 imports 가 모두 @mescius/* 인지 (`@grapecity/wijmo` / scope-less `wijmo` 0건)
       grep -nE "from ['\"]@grapecity/wijmo|from ['\"]wijmo[/'\"]" src/

[ ] 2. CollectionView 가 useMemo / useRef 로 1회 생성되는지 (컴포넌트 본문 직접 호출 금지)
       grep -nE "new CollectionView\(" src/   →   결과 모두 useMemo / useRef 안

[ ] 3. column 정의 — autoGenerateColumns 명시 또는 DataGrid wrapper 사용
       (Wijmo 직접 grid 시 `autoGenerateColumns={false}` 명시 + 명시적 columns)

[ ] 4. 셀 커스터마이징이 가이드 §6 4 방식 중 적절한 선택인지
       단순 포맷 → column.format / 정형 위젯 → CellMaker / 성능·스타일 → itemFormatter / React 컴포넌트 → FlexGridCellTemplate
       `cell.innerHTML` 직접 조립 0건

[ ] 5. 날짜 포맷이 yyyy-MM-dd (대문자 MM) 인지 — yyyy-mm-dd 0건
       grep -nE "yyyy-mm-dd|YYYY-mm-dd" src/   →   0 row
```

→ 1건이라도 ❌ 시 **사용자에게 보고 + 보강 후 PR 제출**.

---

## §5. 관련 hook / 메모리 (cross-ref)

### 기존 wijmo / grid hooks

- `wijmo-insert-cell-dropdown.md` — Insert cell dropdown 12 단계 표준 패턴
- `wijmo-merge-sticky-content.md` — Wijmo merge cell sticky content 처리
- `grid-column-meta.md` — Grid Column 메타 표준 (CELL_CONTROL_TYPE 14 + CELL_INPUT_EDIT_TYPE 5)
- `column-meta-rework-checklist.md` — Column 속성 재작업 8 점검 (DMF0008/0020/0043/0043_01)
- `column-lookup-meta-standard.md` — `CELL_COMBO_DATA_TYPE` 표준 위치 + INPUT_TP_CD 'IM' 표준
- `runtime-error-prevention.md` — `FlexGridColumnGroup` JSX single-child 회피 등
- `ui-category-setup-column-meta.md` — admin 메타 동적 fetch (staticColumns 5 단계)
- `ui-dynamic-property-management.md` — 3 구성요소 admin 동적 fetch
- `pivot-dynamic-column-nvl.md` — PIVOT dynamic 컬럼 NULL → NVL wrap 의무 (DMF0043 사고 후)

### 관련 메모리

- `feedback_wijmo_columngroup_jsx_avoid.md` — `_setOwnerList is not a function` 사고 (React 19 + FlexGridColumnGroup JSX single-child)
- `feedback_wijmo_direct_static_columns.md` — Wijmo 직접 grid 도 staticColumns/staticMeasures 동적 반영
- `feedback_fe_grid_visible_no_fallback_loss.md` — Wijmo 직접 grid 의 fallback 안티패턴
- `feedback_shared_global_prop_change_forbidden.md` — DataGrid wrapper 전역 prop 변경 금지 (autoGenerateColumns 사고)
- `reference_wijmo_flexgrid_guides.md` — 본 가이드 2 파일 위치 + 사용 시점

---

## §6. 작업 진입 의무 행동 표

| 시점 | 행동 |
|---|---|
| T04 트리거 감지 | 본 hook §2.1 Read 의무 |
| `@mescius/wijmo*` 신규 import 시 | §2.1 + §3 안티패턴 사전 점검 |
| 특정 prop / 메서드 시그니처 필요 시 | §2.2 API reference grep |
| 코드 작성 직후 | §4 자기 점검 5 항목 실행 |
| PR 직전 | `screen-completion-gate.md` 8 게이트 + 본 hook §4 cross-check |

---

## §7. 사용자 명시 요구 (2026-06-17)

1. "그리드 사용시 참고할 수 있도록 해주세요"
2. "WIJMO 2개 참조파일 추가하였습니다. 이것까지 같이 클로드코드에서 사용할 수 있도록 해주세요"

→ 본 hook 이 단일 진입점. 사용자 가이드 2 파일은 NSCM 룰셋 자동 참조 시스템의 정신 모델 + API 정확 시그니처 source.
