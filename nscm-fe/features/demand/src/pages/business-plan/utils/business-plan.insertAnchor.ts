import { isInsertRow } from '@foundation/utils';

import type { BusinessPlanRow } from '../business-plan.types';

// DMF0042 Insert 위치 산정 — DMF0021(sales-plan) 의 동명 유틸을 그대로 이식했다.
//   원본 계보는 forecast-price(DMF0082) ForecastPriceGridUtils 의 groupKeyBindings/findGroupTopIndex 다.
//   DMF0042 는 머지 구현(utils/business-plan.merge.ts)이 DMF0021 복제본이라 판정 규약이 같다.
//   차이는 동적 컬럼 축뿐 — DMF0021 은 M_/W_/D_, DMF0042 는 Y_/Q_/M_ 다.
//
// 요구(2026-08-21 사용자): "Insert 하면 무조건 선택된 cell 위 라인으로 추가한다.
//   group(measure 여러개) 이 있는 경우는 group 위로 추가."
//
// 판정은 이 화면의 머지 구현(utils/business-plan.merge.ts HierarchicalMergeManager)을 따라간다:
//   1. 빈 셀도 머지된다. HierarchicalMergeManager.sameRow 는 `(a[k] ?? '') === (b[k] ?? '')` 라
//      값이 없는 컬럼도 위아래로 붙는다 (DMF0082 가 쓰는 공용 CustomMergeManager 의
//      isEmptyCellValue 제외 규칙이 여기엔 없다). 따라서 "빈 셀 클릭 = 폴백" 분기를 두지 않는다.
//   2. 화면 머지는 viewport(panel.viewRange) 안으로 잘리지만, 그건 sticky 렌더링 제약일 뿐이다.
//      Insert 앵커는 스크롤 위치와 무관해야 하므로 여기서는 논리 블록 전체를 훑는다.

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

/**
 * 선택한 셀이 속한 머지 블록의 첫 행 인덱스 — Insert 가 그 블록 맨 위에 행을 넣기 위한 앵커.
 *
 * 위로 훑다가 멈추는 조건 2가지:
 *   1. 키 컬럼 값이 하나라도 다르면 = 다른 그룹.
 *   2. 신규행(CRUD_TYPE='I') 이면 = 병합이 끊기는 자리다. HierarchicalMergeManager 가 신규행을
 *      머지에서 빼므로(business-plan.merge.ts) 화면상으로도 거기서 블록이 갈린다. 앞서 추가한
 *      신규행 위로 타고 올라가면 누른 순서가 뒤집힌다.
 *
 * 그룹을 못 찾거나 신규행에서 눌렀으면 `index` 를 그대로 돌려준다(= 포커스 행 바로 위).
 */
export const findGroupTopIndex = (
  rows: readonly (BusinessPlanRow | undefined)[],
  index: number,
  keyBindings: readonly string[]
): number => {
  const target = rows[index];
  if (!target || keyBindings.length === 0 || isInsertRow(target)) return index;

  // 타입 안전 변환 — 원시값만 비교 대상(객체는 ''). no-base-to-string 회피.
  const cell = (row: BusinessPlanRow, binding: string): string => {
    const value: unknown = row[binding];
    if (typeof value === 'string') return value;
    if (typeof value === 'number' || typeof value === 'boolean') return String(value);
    return '';
  };
  const isSameGroup = (row: BusinessPlanRow): boolean =>
    keyBindings.every(binding => cell(row, binding) === cell(target, binding));

  let top = index;
  while (top > 0) {
    const prev = rows[top - 1];
    if (!prev || isInsertRow(prev) || !isSameGroup(prev)) break;
    top--;
  }
  return top;
};

/** 저장 전 신규행 1건 — 그리드 표시 위치를 결정하는 앵커를 함께 보관한다. */
export interface PendingInsert {
  row: BusinessPlanRow;
  /** Insert 를 누른 시점의 선택 셀이 속한 머지 블록의 첫 행 객체 참조. null = 그리드 맨 위. */
  anchor: BusinessPlanRow | null;
}

/**
 * 조회행 + 신규행 병합 — 신규행은 앵커(= 선택 셀이 속한 머지 블록의 첫 행) 바로 위에 놓는다.
 *
 * 앵커가 사라진 경우(재조회로 객체 참조 교체 등)는 맨 위로 폴백 — 행이 증발하지 않게 한다.
 * 같은 앵커에 연속 Insert 하면 `pending` 배열 순서(= 누른 순서)대로 위에서 아래로 쌓인다.
 * 앵커가 신규행인 경우(추가한 행을 다시 찍고 Insert)까지 재귀로 펼친다.
 */
export const mergeInsertedRows = (
  baseRows: readonly BusinessPlanRow[],
  pending: readonly PendingInsert[]
): BusinessPlanRow[] => {
  if (pending.length === 0) return [...baseRows];

  const knownRows = new Set<BusinessPlanRow>(baseRows);
  pending.forEach(p => knownRows.add(p.row));

  const rowsByAnchor = new Map<BusinessPlanRow, BusinessPlanRow[]>();
  const orphanRows: BusinessPlanRow[] = [];
  pending.forEach(({ row, anchor }) => {
    if (!anchor || !knownRows.has(anchor)) {
      orphanRows.push(row);
      return;
    }
    const bucket = rowsByAnchor.get(anchor);
    if (bucket) bucket.push(row);
    else rowsByAnchor.set(anchor, [row]);
  });

  const merged: BusinessPlanRow[] = [];
  const emit = (target: BusinessPlanRow) => {
    rowsByAnchor.get(target)?.forEach(emit);
    merged.push(target);
  };
  orphanRows.forEach(emit);
  baseRows.forEach(emit);
  return merged;
};
