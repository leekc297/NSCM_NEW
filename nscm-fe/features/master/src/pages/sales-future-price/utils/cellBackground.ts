// DMF0020 정적 컬럼 셀 배경 적용 (formatItem 전용).
//
// ⭐ 인라인 !important 금지 (2026-07-28) — Wijmo 는 셀의 선택 상태 클래스
//   (`wj-state-selected` / `wj-state-multi-selected`)를 className 에 실은 뒤 formatItem 을 호출한다.
//   인라인 !important 는 모든 스타일시트 !important 를 이기므로, formatItem 에서 배경을
//   인라인 !important 로 칠하면 foundation 의 선택 규칙
//   `.wj-cells .wj-cell.wj-state-selected { background:#b4faef !important }` (_grid.scss)이 무력화되어
//   INSERT 행 셀을 클릭해도 하늘색 포커스가 표시되지 않는다(사용자 보고: User 화면과 동작 불일치).
//   → 노란색(INSERT 편집셀)은 클래스로만 칠한다. `.grid :global(.is-insert-editable)` (specificity 0,2,0)이
//     모듈/전역 single-class 규칙(0,1,0)을 이기고, 선택 규칙(0,3,0)에는 지도록 설계됨.
//   → 개인화 Cell Color(동적 값이라 클래스화 불가)는 인라인으로 두되 priority 를 붙이지 않아
//     선택 규칙(!important)이 이기게 한다.
//   우선순위: 선택(하늘색) > INSERT 편집셀 Yellow > 개인화 Cell Color > 기본(제거).
export const applyStaticCellBackground = (
  cell: HTMLElement,
  { editableForInsert, cellColor }: { editableForInsert: boolean; cellColor?: string }
): void => {
  // INSERT 편집셀 Yellow 는 클래스(is-insert-editable / wj-cell-editable)가 담당 — 인라인 미사용.
  if (editableForInsert || !cellColor) {
    cell.style.removeProperty('background-color');
    return;
  }
  cell.style.setProperty('background-color', cellColor);
};
