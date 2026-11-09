import type { CellRangeEventArgs, FlexGrid } from '@mescius/wijmo.grid';
import { useCallback, useEffect, useRef, type MutableRefObject } from 'react';

import { CRUD_TYPE } from '@foundation/constants';
import type { EditTracker } from '@foundation/utils';

type TrackedValue = WijmoPrimitive | undefined;

/** "값이 비어 있다" 의 모든 표현 — 셀을 오가는 값의 타입은 제각각이다. */
const isBlank = (value: TrackedValue): boolean =>
  value === null || value === undefined || value === '';

const isSameValue = (a: TrackedValue, b: TrackedValue): boolean => {
  if (a === b) return true;
  if (isBlank(a) || isBlank(b)) return isBlank(a) && isBlank(b);
  if (a instanceof Date && b instanceof Date) return a.getTime() === b.getTime();
  const isCanonicalNumber = (num: number, text: string): boolean => String(num) === text.trim();
  if (typeof a === 'number' && typeof b === 'string') return isCanonicalNumber(a, b);
  if (typeof a === 'string' && typeof b === 'number') return isCanonicalNumber(b, a);
  return false;
};

export const useEditBaseline = <T extends WijmoRowItem>({
  gridRef,
  editTrackerRef,
  data,
}: {
  gridRef: MutableRefObject<FlexGrid<T> | undefined>;
  editTrackerRef: MutableRefObject<EditTracker<T> | undefined>;
  data: T[];
}) => {
  // 행 객체를 키로 잡는다 — 재조회로 행이 교체되면 기준선도 함께 버려지는 것이 맞다.
  const baselinesRef = useRef(new WeakMap<T, Record<string, WijmoPrimitive>>());

  // 조회 결과가 바뀔 때마다 새로 실린 행만 스냅샷한다. 편집은 렌더 이후에만 일어나므로 이
  // 시점의 행 값이 곧 조회 원본이고, 구조 공유로 살아남은 행은 이미 스냅샷이 있어 건너뛴다.
  useEffect(() => {
    data.forEach(row => {
      if (!baselinesRef.current.has(row)) {
        baselinesRef.current.set(row, { ...row } as Record<string, WijmoPrimitive>);
      }
    });
  }, [data]);

  const resyncRow = useCallback(
    (row: T | undefined) => {
      const grid = gridRef.current;
      const tracker = editTrackerRef.current;
      if (!grid || !tracker || !row) return;
      if (row.CRUD_TYPE === CRUD_TYPE.INSERT || row.CRUD_TYPE === CRUD_TYPE.DELETE) return;

      const baseline = baselinesRef.current.get(row);
      // 조회 결과에 없던 행(신규행 등) — 판단 근거가 없으므로 공용 판정을 그대로 둔다.
      if (!baseline) return;

      const originals = tracker.getOriginalValues();
      let record = originals.get(row);

      grid.columns.forEach(column => {
        const binding = column.binding;
        if (!binding || binding === 'CRUD_TYPE') return;
        // 조회 응답에 아예 없던 컬럼은 기준선이 없다 — 오판보다 공용 판정 유지가 안전하다.
        if (!(binding in baseline)) return;

        if (isSameValue(baseline[binding], (row as WijmoRowItem)[binding])) {
          if (record) delete record[binding];
          return;
        }
        if (!record) {
          record = {};
          originals.set(row, record);
        }
        record[binding] = baseline[binding];
      });

      if (record && Object.keys(record).length === 0) originals.delete(row);
      row.CRUD_TYPE = originals.has(row) ? CRUD_TYPE.MODIFY : undefined;
      grid.invalidate();
    },
    [gridRef, editTrackerRef]
  );

  // EditTracker 는 DataGrid 의 initialized 안에서 걸린다. mount 후 등록하는 이 핸들러는 항상
  // 그보다 뒤에 호출되므로(Wijmo Event 는 등록 순서대로), 공용 판정 결과를 덮어쓸 수 있다.
  useEffect(() => {
    const grid = gridRef.current;
    if (!grid) return;

    const handler = (sender: FlexGrid<T>, event: CellRangeEventArgs) =>
      resyncRow(sender.rows[event.row]?.dataItem as T | undefined);

    grid.cellEditEnded.addHandler(handler);
    grid.pastedCell.addHandler(handler);
    return () => {
      grid.cellEditEnded.removeHandler(handler);
      grid.pastedCell.removeHandler(handler);
    };
  }, [gridRef, resyncRow]);

  // 팝업 선택처럼 편집 이벤트를 거치지 않고 행을 직접 고치는 경로에서 호출한다.
  return resyncRow;
};
