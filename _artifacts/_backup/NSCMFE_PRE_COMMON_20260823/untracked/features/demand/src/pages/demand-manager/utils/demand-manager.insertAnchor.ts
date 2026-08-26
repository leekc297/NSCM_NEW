import { toCellStr } from '../demand-manager.constants';
import type { DemandManagerRow } from '../demand-manager.types';

// DMF0068 Insert 위치 산정 — "신규행은 클릭한 행 위에" 라는 앱 표준을 이 화면에 맞춘 것.
//   기존 구현은 `[...insertedRows, ...spRows]` 로 그리드 소스를 조립해, 선택행이 위치 결정에
//   전혀 관여하지 않았다 = 몇 번째 행을 눌러도 신규 세트가 항상 맨 위에 생겼다.
//   계보: DMF0082(forecast-price) → DMF0021(sales-plan) → DMF0042(business-plan) 의 동명 유틸.
//
// 이 화면만의 단순화: 한 건 = Measure 2행 1세트이고 병합 판정이 그룹 키(KEYVALUE2) 하나로
//   끝난다(utils/demand-manager.merge.ts pairRange). 그래서 DMF0042 처럼 클릭 컬럼에서
//   머지 키 컬럼을 역산할 필요가 없다 — 그룹 키가 같은 인접 행이 곧 병합 블록이다.
//   ⇒ 앵커 = 클릭한 행이 속한 세트의 첫 행. 짝 행(Sales Amt.)을 눌러도 신규 세트가
//     QTY / Sales Amt. 사이에 끼지 않는다.

/** 세트 그룹 키 — 조회행은 KEYVALUE2, 신규행은 INSERT_GROUP_ID. 빈 값이면 그룹 없음. */
export const groupKeyOf = (row: DemandManagerRow | undefined): string =>
  row ? toCellStr(row.KEYVALUE2 ?? row.INSERT_GROUP_ID) : '';

/**
 * 선택한 행이 속한 세트의 첫 행 인덱스 — Insert 앵커.
 *
 * 위로 훑다가 그룹 키가 달라지면 멈춘다. 그룹 키가 없는 행(빈 값)은 세트를 이루지 못하므로
 * 자기 자신이 곧 앵커다.
 *
 * 참고: 병합 셀(Project·수주 기간·행 헤더)을 클릭하면 Wijmo 가 선택을 블록 전체로 잡아
 *   `selection.row` 가 이미 세트 첫 행이다. 이 함수는 병합되지 않은 컬럼(Measure·월 컬럼)을
 *   눌러 둘째 행이 선택된 경우를 같은 결과로 맞춘다.
 */
export const findGroupTopIndex = (
  rows: readonly (DemandManagerRow | undefined)[],
  index: number
): number => {
  if (index <= 0) return Math.max(index, 0);
  const key = groupKeyOf(rows[index]);
  if (!key) return index;

  let top = index;
  while (top > 0 && groupKeyOf(rows[top - 1]) === key) top--;
  return top;
};

/** 저장 전 신규행 1건 — 그리드 표시 위치를 결정하는 앵커를 함께 보관한다. */
export interface PendingInsert {
  row: DemandManagerRow;
  /** Insert 를 누른 시점의 선택 행이 속한 세트의 첫 행 참조. null = 그리드 맨 위. */
  anchor: DemandManagerRow | null;
}

/**
 * 조회행 + 신규행 병합 — 신규행은 앵커(= 선택 세트의 첫 행) 바로 위에 놓는다.
 *
 * 앵커를 인덱스가 아니라 행 참조로 잡으므로, 이후 삽입·삭제로 행 위치가 밀려도 "그때 그 행 위"가
 * 유지된다. 앵커를 못 찾으면(재조회로 객체 참조가 갈린 경우 등) 맨 위로 폴백한다 — 행이 증발하는
 * 것보다 낫다.
 *
 * 같은 앵커에 연속 Insert 하면 `pending` 배열 순서(= 누른 순서)대로 위에서 아래로 쌓인다.
 * 앵커가 신규행인 경우(추가한 행을 다시 찍고 Insert)까지 재귀로 펼친다.
 */
export const mergeInsertedRows = (
  baseRows: readonly DemandManagerRow[],
  pending: readonly PendingInsert[]
): DemandManagerRow[] => {
  if (pending.length === 0) return [...baseRows];

  const knownRows = new Set<DemandManagerRow>(baseRows);
  pending.forEach(p => knownRows.add(p.row));

  const rowsByAnchor = new Map<DemandManagerRow, DemandManagerRow[]>();
  const orphanRows: DemandManagerRow[] = [];
  pending.forEach(({ row, anchor }) => {
    if (!anchor || !knownRows.has(anchor)) {
      orphanRows.push(row);
      return;
    }
    const bucket = rowsByAnchor.get(anchor);
    if (bucket) bucket.push(row);
    else rowsByAnchor.set(anchor, [row]);
  });

  const merged: DemandManagerRow[] = [];
  const emitted = new Set<DemandManagerRow>();
  // 행을 내보내기 직전에 "그 행을 앵커로 삼은 신규행" 을 먼저 내보낸다. emitted 는 비정상 순환 방어.
  const emit = (target: DemandManagerRow) => {
    if (emitted.has(target)) return;
    emitted.add(target);
    rowsByAnchor.get(target)?.forEach(emit);
    merged.push(target);
  };
  orphanRows.forEach(emit);
  baseRows.forEach(emit);
  return merged;
};

/**
 * 신규 세트 삭제 — 같은 그룹 키를 가진 신규행을 빼고, 그 행을 앵커로 삼던 신규행에게 앵커를 승계한다.
 *
 * 승계하지 않으면 앵커 유실로 딸린 행들이 그리드 맨 위로 튄다(mergeInsertedRows 의 orphan 폴백).
 */
export const removePendingGroup = (
  pending: readonly PendingInsert[],
  groupKey: string
): PendingInsert[] => {
  const isRemoved = (p: PendingInsert) => groupKeyOf(p.row) === groupKey;

  const inherited = new Map<DemandManagerRow, DemandManagerRow | null>();
  pending.filter(isRemoved).forEach(p => inherited.set(p.row, p.anchor));
  if (inherited.size === 0) return [...pending];

  // 승계 대상이 또 삭제된 행이면 살아 있는 앵커가 나올 때까지 타고 올라간다(순환 가드 포함).
  const resolve = (anchor: DemandManagerRow | null): DemandManagerRow | null => {
    const seen = new Set<DemandManagerRow>();
    let cur = anchor;
    while (cur && inherited.has(cur) && !seen.has(cur)) {
      seen.add(cur);
      cur = inherited.get(cur) ?? null;
    }
    return cur;
  };

  return pending
    .filter(p => !isRemoved(p))
    .map(p => (p.anchor && inherited.has(p.anchor) ? { ...p, anchor: resolve(p.anchor) } : p));
};
