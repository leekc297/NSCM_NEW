# Hook #95 — grid-cell-backcolor-standard (Grid Cell Backcolor 표준 — 필수·공통)

> **트리거**: 모든 TO-BE grid 작업 (T01 신규화면 / T01M 화면수정 / T04 grid / formatItem 작성·수정)
> **상태**: ⭐⭐⭐ 필수 적용 (사용자 명시 2026-06-28, DMF0020 정립 → DMF0008 미적용 사고 후 공통 룰 확정)
> **PR 차단**: grid cell 배경을 임의 색/전체 회색으로 칠하면 위반.

---

## §0. 표준 3색 (불변)

| 셀 상태 | 배경 | 적용 방법 |
|---|---|---|
| **기본(비편집/조회)** | **White + 홀짝 zebra** | **클래스 없음** → foundation `.wj-cell`(white) / `.wj-cell.wj-alt`(#F7F7F8) 자동. `alternatingRowStep=1`(Wijmo 기본). |
| **편집 가능** | **Yellow (#fff8cd)** | `wj-cell-editable` 클래스 |
| **편집가능하나 잠금(특수)** | **Gray (#f1f4f3)** | `wj-cell-non-editable` 클래스 — **특정 셀에만** |

> 색 소스: foundation `packages/foundation/src/styles/wijmo/parts/_grid.scss` (`.wj-cell-editable` / `.wj-cell-non-editable` / `.wj-cell.wj-alt`) + `misc/_variables.scss`. **임의 hex/​inline `backgroundColor` 금지** — 위 클래스만 사용.

---

## §1. 핵심 원칙

1. **기본은 White = "클래스를 붙이지 않는다"** (순수 흰색 강제 아님). 클래스가 없으면 표준 홀/짝 zebra(`.wj-alt`)가 자동 표시된다. → **zebra 를 죽이지 말 것**(셀에 흰색 inline 강제 금지).
2. **편집 가능 셀 = `wj-cell-editable`(Yellow).** 가능하면 **컬럼 메타 editable**(`inputTpCd` O/M/IM/IO)로 표시 → 공용 `DataGrid` 의 `formatEditableColumns`(`GridUtils.isEditableCell`)가 **자동** 부여. 메타로 표현 못 하는 조건부 편집셀만 화면 `formatItem` 에서 `toggleClass(cell,'wj-cell-editable', editable)`.
3. **Gray(`wj-cell-non-editable`) = "원래 편집 가능하나 지금 잠긴" 특수 셀에만.** 예: DMF0020 LOC measure 동적셀의 **과거 주차**(이번 주 월요일 이전). **조회 전용 grid / 비편집 컬럼 전체를 회색칠 금지.**
4. **상호배타 toggle**: Wijmo 셀 재활용으로 클래스 잔존 → 모든 분기에서 `toggleClass(cell,'wj-cell-editable',cond)` + `toggleClass(cell,'wj-cell-non-editable',cond2)` 양쪽 명시(false 포함).
5. `alternatingRowStep` 은 Wijmo 기본 1(zebra ON). 공용 `DataGrid` 가 끄지 않음 — 화면이 0 으로 바꾸지 말 것(필요 시 `g.alternatingRowStep=1` 명시 보장).

---

## §2. 안티패턴 (PR 차단)

| # | 금지 | 사고 |
|---:|---|---|
| 1 | ❌ 모든 cell 에 `wj-cell-non-editable` 일괄 toggle (조회 grid 통째 회색) | **DMF0008 `applyReadOnlyColoring`** — 전체 회색, 표준 미적용 |
| 2 | ❌ 비편집 전부에 `toggleClass('wj-cell-non-editable', !editable)` | DMF0020 초기 — 전체 회색 |
| 3 | ❌ 편집셀에 inline `cell.style.backgroundColor='...'` (임의 hex/rgba) | DMF0008 Sspm/SalesSite — 표준색 불일치 |
| 4 | ❌ 비편집 셀에 흰색 inline 강제 → `.wj-alt` zebra 제거 | zebra 소실 |
| 5 | ❌ `alternatingRowStep=0` 으로 zebra OFF | 표준 위반 |

---

## §3. 표준 구현 패턴

### 3.1 조회 전용 / 일반 grid (대부분)
**아무 것도 하지 않는다.** 공용 `DataGrid` 의 `formatEditableColumns` 가 editable 컬럼만 Yellow, 나머지는 클래스 없음 → White+zebra. → 화면 `formatItem` 불필요(또는 다른 용도만).

### 3.2 조건부 편집 셀 (화면 formatItem 필요 시)
```ts
const handleFormatItem = (grid, e: FormatItemEventArgs) => {
  if (e.panel.cellType !== CellType.Cell) return;
  const editable = /* 행/컬럼/상태 기반 조건 */;
  toggleClass(e.cell, 'wj-cell-editable', editable);
  toggleClass(e.cell, 'wj-cell-non-editable', false); // 기본 비편집 = White (회색 아님)
};
```

### 3.3 "편집가능하나 잠금" Gray (특수만)
```ts
// 예: DMF0020 LOC 동적셀 과거주차
const isLockedButEditable = isLocRow && isPastWeek;
toggleClass(e.cell, 'wj-cell-editable', isLocRow && !isPastWeek);
toggleClass(e.cell, 'wj-cell-non-editable', isLockedButEditable);
// 비-LOC(원래 비편집) → 둘 다 false = White+zebra
```

---

## §4. cross-ref
- 색 클래스/zebra: `packages/foundation/src/styles/wijmo/parts/_grid.scss` (불변)
- 공용 자동 coloring: `packages/shared/.../data-grid/dataGridUtils.ts formatEditableColumns` (불변)
- 짝 hook: `grid-multi-tier-header-height.md`(#93) · `screen-grid-edit-merge-and-meta-mandatory.md`(#89) · `grid-column-meta.md`
- 기준 화면: **DMF0020**(정립) / **DMF0008**(2026-06-28 표준 적용)
