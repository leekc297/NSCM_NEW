// SDM 공통 — 종속 셀 콤보 첫 후보 자동 입력 (Cascade AutoFill).
//   상위 셀(예: CELL_TYPE)이 편집/붙여넣기로 실제 변경되면, 그 값에 종속된 콤보 셀
//   (예: STACK_METHOD)에 새 후보 목록의 첫 번째 값을 미리 채운다.
//
//   종속 관계 선언은 별도 rule 이 아니라 컬럼 메타 ATTRIBUTE2('행컬럼:바인드명' —
//   parseComboFilterBindings 문법)를 그대로 읽는다. 공용 DataGrid 의 후보 좁힘/stale clear 와
//   같은 원천을 쓰므로 화면별 하드코딩 없이 종속 콤보가 있는 그리드 어디든 붙는다.
//
//   전제(공용 DataGrid 계약 — DataGrid.tsx handleInitialized):
//   · 후보 목록 = wijmo column.dataMap.getDisplayValues(rowItem) (행 단위 좁힘 — F 경로
//     getDataMap / D 경로 getRowParamDataMap / 화면 자체 override 전부 이 계약을 만족).
//   · 이 핸들러는 화면 effect 에서 붙어 공용 핸들러들(EditTracker → stale clear →
//     행 파라미터 조회 등록)보다 뒤에 호출된다(Wijmo Event 등록 순서) — 정리 후 채움 순서 보장.
//   · 행 파라미터 콤보(PARAM10='D')는 새 조합의 후보가 비동기로 도착하므로, 후보가 아직
//     없으면 짧게 재시도한다(공용 registerRowParamHandler 가 같은 이벤트에서 조회를 올려 둠).
import type { FlexGrid } from '@mescius/wijmo.grid';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import { parseComboFilterBindings } from '@foundation/utils';

import { toText } from './call-proc';

// 비동기 후보 도착 대기 — 300ms × 10회(≈3초). 그 안에 안 오면 채우지 않고 조용히 끝낸다
//   (stale clear 가 이미 비워 둔 상태라 잘못된 값이 남는 일은 없다).
const RETRY_INTERVAL_MS = 300;
const RETRY_MAX = 10;

interface CascadeEditTracker {
  storeChange: (item: never, binding: string, originalValue: never, newValue: never) => void;
}

interface AttachParams<T> {
  grid: FlexGrid<T>;
  /** 표시 중인 컬럼 메타 — 화면이 ATTRIBUTE2 patch 를 얹은 뒤의 목록을 최신으로 반환할 것 */
  getColumns: () => RawFlexGridColumnConfig[];
  /** 저장 시 변경분 전송을 위해 자동 입력도 EditTracker 에 기록한다 */
  getEditTracker: () => CascadeEditTracker | undefined;
}

/** 상위 바인딩 → 그 값에 종속된 콤보 컬럼(colNm) 목록 (ATTRIBUTE2 역인덱스). */
const buildDependentIndex = (columns: RawFlexGridColumnConfig[]): Map<string, string[]> => {
  const index = new Map<string, string[]>();
  for (const column of columns) {
    if (!column.cellCboDataTp) continue;
    for (const parentBinding of Object.keys(parseComboFilterBindings(column.attribute2))) {
      if (parentBinding === column.colNm) continue;
      const list = index.get(parentBinding) ?? [];
      list.push(column.colNm);
      index.set(parentBinding, list);
    }
  }
  return index;
};

/**
 * 그리드에 종속 콤보 첫 후보 자동 입력 핸들러를 건다. 반환값은 해제 함수 —
 * 핸들러 등록 effect 의 cleanup 에서 호출한다.
 */
export const attachComboCascadeAutoFill = <T>({
  grid,
  getColumns,
  getEditTracker,
}: AttachParams<T>): (() => void) => {
  // 편집/붙여넣기 직전 값 — "실제 변경" 판정용 (같은 값 재선택 시 하위 셀을 건드리지 않는다).
  const preValues = new WeakMap<object, Record<string, string>>();

  const readCell = (row: object, binding: string): string =>
    toText((row as Record<string, unknown>)[binding]);

  // event.cancel 은 보지 않는다 — beginningEdit 시점의 cancel 은 중간값이다. 공용 게이트가
  // true 로 걸어도 화면 게이트(insert-only 재판정 등)가 뒤에서 false 로 뒤집는데, 화면 핸들러가
  // effect 재실행으로 재등록되면 이 핸들러보다 뒤로 밀려 여기서는 cancel=true 만 보인다
  // (SDM5010 TAB1 IM 컬럼 실사고). 진짜 취소된 편집은 cellEditEnded 가 안 오므로 캡처는 무해.
  const capturePreValue = (sender: FlexGrid<T>, event: { row: number; col: number }) => {
    const binding = sender.columns[event.col]?.binding ?? '';
    if (!binding) return;
    const row = sender.rows[event.row]?.dataItem as object | undefined;
    if (!row) return;
    const stored = preValues.get(row) ?? {};
    stored[binding] = readCell(row, binding);
    preValues.set(row, stored);
  };

  // 상위 바뀐 행의 종속 콤보 셀마다: 현재 값이 새 후보 안에 있으면 유지, 없을 때만 첫 후보를
  // 채운다. 후보 미도착(행 파라미터 콤보 비동기)이면 재시도. 채운 값도 상위가 될 수 있어
  // 자기재귀로 연쇄 채움하고 visited 로 순환을 차단한다.
  const cascadeFrom = (row: object, parentBinding: string, visited: Set<string>) => {
    const dependents = buildDependentIndex(getColumns()).get(parentBinding) ?? [];
    for (const dependent of dependents) {
      if (visited.has(dependent)) continue;
      visited.add(dependent);

      const fillFirstCandidate = (triesLeft: number) => {
        if (!grid.hostElement?.isConnected) return;
        const column = grid.getColumn(dependent);
        const dataMap = column?.dataMap ?? null;
        if (!dataMap) return;

        const candidates: string[] = dataMap.getDisplayValues(row as never) ?? [];
        if (candidates.length === 0) {
          if (triesLeft > 0)
            globalThis.setTimeout(() => fillFirstCandidate(triesLeft - 1), RETRY_INTERVAL_MS);
          return;
        }

        const current = readCell(row, dependent);
        // 현재 값이 새 후보에 아직 유효하면 그대로 둔다 (표시명 후보 ↔ 코드 값 비교).
        if (
          current !== '' &&
          candidates.some(name => toText(dataMap.getKeyValue(name)) === current)
        )
          return;

        const firstName = toText(candidates[0]);
        const nextValue = toText(dataMap.getKeyValue(firstName) ?? firstName);
        if (nextValue === '' || nextValue === current) return;

        getEditTracker()?.storeChange(
          row as never,
          dependent,
          current as never,
          nextValue as never
        );
        (row as Record<string, unknown>)[dependent] = nextValue;
        grid.invalidate();

        cascadeFrom(row, dependent, visited);
      };
      fillFirstCandidate(RETRY_MAX);
    }
  };

  const handleEditEnded = (sender: FlexGrid<T>, event: { row: number; col: number }) => {
    const binding = sender.columns[event.col]?.binding ?? '';
    if (!binding) return;
    const row = sender.rows[event.row]?.dataItem as object | undefined;
    if (!row) return;
    const before = preValues.get(row)?.[binding];
    if (before === undefined || before === readCell(row, binding)) return;
    // microtask 로 미룬다 — 같은 이벤트에 걸린 다른 핸들러(공용 stale clear, 화면별 하위 초기화)가
    // 등록 순서와 무관하게 전부 끝난 뒤에 채워야 "정리 → 첫 후보 입력" 최종 상태가 보장된다.
    globalThis.queueMicrotask(() => cascadeFrom(row, binding, new Set([binding])));
  };

  grid.beginningEdit.addHandler(capturePreValue as never);
  grid.pastingCell.addHandler(capturePreValue as never);
  grid.cellEditEnded.addHandler(handleEditEnded as never);
  grid.pastedCell.addHandler(handleEditEnded as never);

  return () => {
    try {
      grid.beginningEdit?.removeHandler(capturePreValue as never);
      grid.pastingCell?.removeHandler(capturePreValue as never);
      grid.cellEditEnded?.removeHandler(handleEditEnded as never);
      grid.pastedCell?.removeHandler(handleEditEnded as never);
    } catch {
      /* unmount race */
    }
  };
};
