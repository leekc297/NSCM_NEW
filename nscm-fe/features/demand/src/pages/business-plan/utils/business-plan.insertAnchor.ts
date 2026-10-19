// DMF0042 Insert 위치 산정 — groupKeyBindings 만 이 파일에 남는다. 앵커 계산(옛
//   findGroupTopIndex)과 신규 세트 병합(옛 mergeInsertedRows/PendingInsert)은
//   packages/foundation/src/utils/gridAction.ts 의 GridAction.addRowSet(groupKey=...) 이
//   대체한다 — BusinessPlan.tsx buildGroupKeyOf 가 이 함수로 groupKey 클로저를 만들어 넘긴다.
//   groupKeyBindings 자체(그룹 폭을 정하는 업무 규칙)만 화면 고유 로직으로 남는다.
//   차이는 동적 컬럼 축뿐 — DMF0021(sales-plan) 은 M_/W_/D_, DMF0042 는 Y_/Q_/M_ 다.
//
// 요구(2026-08-21 사용자): "Insert 하면 무조건 선택된 cell 위 라인으로 추가한다.
//   group(measure 여러개) 이 있는 경우는 group 위로 추가."
//
// 판정은 이 화면의 머지 구현(utils/business-plan.merge.ts HierarchicalMergeManager)을 따라간다:
//   빈 셀도 머지된다. HierarchicalMergeManager.sameRow 는 `(a[k] ?? '') === (b[k] ?? '')` 라
//   값이 없는 컬럼도 위아래로 붙는다(DMF0082 가 쓰는 공용 CustomMergeManager 의
//   isEmptyCellValue 제외 규칙이 여기엔 없다) — buildGroupKeyOf 의 groupKey 도 같은 `?? ''`
//   비교라 이 계약을 그대로 잇는다.

/** 그룹 판정 입력 — 그리드 표시 순서 그대로의 컬럼 정보. */
export interface GroupKeyColumn {
  binding: string;
  visible: boolean;
}

const isDynamicBinding = (binding: string): boolean => /^[YQM]_/.test(binding);

/**
 * 머지 범위를 가르는 키 컬럼 — 표시 순서에서 0번부터 클릭한 컬럼까지의 정적 컬럼.
 *
 * 근거: HierarchicalMergeManager 의 좌측 고정 컬럼 머지는 계층형이다. 컬럼 c 의 병합 범위는
 *   `fixedBindings.slice(0, c+1)` 값이 모두 같은 연속 행이다(sameRow 의 leftBindings).
 *   즉 어떤 컬럼의 셀이 위아래로 붙어 보이려면 그 왼쪽 컬럼이 전부 같아야 한다.
 *   ⇒ 누른 병합 셀이 덮는 범위 = 위로 보낼 범위. Sales Site 셀은 그 안의 여러 Model 블록을,
 *   Model 셀은 그 안의 Incoterms 블록을, Incoterms 셀은 measure 블록만 덮는다.
 *
 * 필수: 기준을 컬럼 인덱스로 받는다(binding 문자열 역탐색 금지). `g.selection.col` 이 곧
 *   `g.columns` 의 인덱스라 그대로 쓰면 어긋날 여지가 없다.
 *
 * 클릭 컬럼이 병합 축이 못 되면(MEASURE 자신 · 동적 기간 컬럼 Y_/Q_/M_ · 비표시 · 범위 밖)
 *   MEASURE 직전까지를 기준으로 폴백한다 = 통합테스트 35번의 "data Group"(키가 모두 같고
 *   measure 만 다른 블록).
 *
 * 주의: 비표시 컬럼은 키에서 뺀다 — 화면에 없는 컬럼은 머지에도 참여하지 않는다.
 *
 * 주의(설계상 당연한 귀결, 버그 아님): 조회 결과가 그 컬럼 값 하나로만 이뤄져 있으면 병합 블록이
 *   곧 그리드 전체라 신규행이 맨 위로 간다. 범위를 좁히려면 더 오른쪽 컬럼을 누르면 된다.
 */
export const groupKeyBindings = (
  columnsInOrder: readonly GroupKeyColumn[],
  clickedIndex: number
): string[] => {
  const usable = (column: GroupKeyColumn | undefined): boolean =>
    !!column && column.visible && !!column.binding && !isDynamicBinding(column.binding);

  const clicked = columnsInOrder[clickedIndex];
  let end: number;
  if (usable(clicked) && clicked?.binding !== 'MEASURE') {
    end = clickedIndex + 1;
  } else {
    const measureIndex = columnsInOrder.findIndex(column => column.binding === 'MEASURE');
    end = measureIndex < 0 ? columnsInOrder.length : measureIndex;
  }

  const keys: string[] = [];
  for (let i = 0; i < end && i < columnsInOrder.length; i++) {
    const column = columnsInOrder[i];
    if (usable(column)) keys.push(column.binding);
  }
  return keys;
};
