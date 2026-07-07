// ⭐ grid cell 배경 = hook #95 `grid-cell-backcolor-standard` 공통 표준 준수.
//   기본(조회/비편집) = White + 홀짝 zebra (클래스 없음 → foundation `.wj-cell.wj-alt`, alternatingRowStep=1).
//   편집가능 = `wj-cell-editable`(Yellow) — 공용 DataGrid `formatEditableColumns(isEditableCell)` 자동.
//   조회 전용 grid 를 통째 회색칠하지 않는다(기존 applyReadOnlyColoring blanket gray 제거, 2026-06-28).
export {};
