// 같은 셀 더블클릭 가드 — AS-IS FarPoint CellDoubleClick 등가.
//
// 이 화면의 두 그리드는 Wijmo 그리드 이벤트가 아니라 `hostElement` 에 DOM `dblclick` 을 직접 건다.
// 브라우저는 연속한 두 클릭의 **타깃이 다르면** `dblclick` 을 두 타깃의 최근접 공통 조상에
// 디스패치한다. Wijmo 는 셀마다 별도 div 를 쓰므로, 서로 다른 셀을 빠르게 두 번 클릭하면 공통
// 조상인 hostElement 에서 dblclick 이 잡히고 `hitTest` 가 마지막 셀을 돌려주면서 드릴다운·팝업이
// 열린다. 사용자에게는 "셀을 고르기만 했는데 아래 그리드가 조회됨"으로 보인다(2026-10-12 보고).
//
// AS-IS FarPoint `CellDoubleClick` 은 **같은 셀** 두 번만 더블클릭으로 인정하므로 이 현상이 없다.
// 그래서 직전 두 클릭의 셀을 기억해 두고, 둘이 같고 dblclick 이 그 셀에서 났을 때만 통과시킨다.
//
// 사용법: 클릭 핸들러에서 **early return 보다 먼저** track() 을 부른다(헤더·빈 영역 클릭도 null 로
// 기록해야 "헤더 클릭 → 셀 클릭" 이 같은 셀로 오인되지 않는다). dblclick 핸들러에서 accepts() 로
// 판정한다.

export interface GuardCell {
  row: number;
  col: number;
}

export interface SameCellDblClickGuard {
  track: (cell: GuardCell | null) => void;
  accepts: (cell: GuardCell) => boolean;
}

const keyOf = (cell: GuardCell | null): string | null =>
  cell ? `${cell.row}:${cell.col}` : null;

export const createSameCellDblClickGuard = (): SameCellDblClickGuard => {
  let prev: string | null = null;
  let last: string | null = null;

  return {
    track: cell => {
      prev = last;
      last = keyOf(cell);
    },
    accepts: cell => {
      const target = keyOf(cell);
      const ok = prev !== null && prev === last && last === target;
      // 판정 후 초기화 — 통과 여부와 무관하게 다음 더블클릭은 클릭 2회를 새로 요구한다
      // (세 번째 클릭이 직전 쌍에 얹혀 재발화하는 것을 막는다).
      prev = null;
      last = null;
      return ok;
    },
  };
};
