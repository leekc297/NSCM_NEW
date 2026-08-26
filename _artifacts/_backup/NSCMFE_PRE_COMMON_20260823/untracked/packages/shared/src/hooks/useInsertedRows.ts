import {
  useCallback,
  useEffect,
  useRef,
  useState,
  type Dispatch,
  type SetStateAction,
} from 'react';

import { useDirtyReset } from '@shared/stores';

/**
 * ⭐ 신규행(CRUD_TYPE='I') 삽입 위치 공통 처리 — "선택한 행 바로 위에 추가".
 *
 * 문제(2026-07-29 사용자 리포트 · DMF0082 Fcst&Price MGMT 에서 최초 확인):
 *   6개 화면이 그리드 소스를 `[...insertedRows, ...spRows]` 로 조립해, 신규행이 **구조적으로**
 *   항상 맨 위에만 생겼다. 7번째 행을 클릭하든 24번째 행을 클릭하든 결과가 같았던 이유 —
 *   선택행은 시드값 복사에만 쓰이고 위치 결정에는 전혀 관여하지 않았기 때문.
 *   (공통 GridAction.addRow 는 이미 정상 동작하지만, 이 6개 화면은 그 경로를 타지 않는다.)
 *
 * 해결:
 *   신규행마다 "어느 행 위에 삽입되었는지"(anchor)를 기록해 두고, 렌더 시 조회결과를 훑으며
 *   anchor 바로 앞에 신규행을 끼워 넣는다. anchor 를 **인덱스가 아니라 행 참조/키**로 잡으므로
 *   이후 삽입·삭제로 행 위치가 밀려도 "선택했던 그 행 바로 위"가 그대로 유지된다.
 *   선택행이 없으면(selection.row < 0) 기존과 동일하게 맨 위에 추가한다.
 *
 * 화면 측 교체 지점은 3곳뿐 — `setInsertedRows` 를 그대로 노출하므로 기존 delete/reset/patch
 * 코드(`prev.filter(...)` / `[]` / `prev.map(r => ({ ...r, ... }))`)는 무수정으로 동작한다:
 *
 * ```ts
 * - const [insertedRows, setInsertedRows] = useState<Row[]>([]);
 * + const { insertedRows, setInsertedRows, insertAbove, mergeRows } = useInsertedRows<Row>(gridRef);
 *
 * - const rows = useMemo(() => [...insertedRows, ...spRows], [insertedRows, spRows]);
 * + const rows = mergeRows(spRows);
 *
 * - setInsertedRows(prev => [newRow, ...prev]);
 * + insertAbove(newRow);
 * ```
 *
 * `gridRef` 를 넘기면 병합 셀 클릭 보정(hitTest)까지 동작한다 — 아래 clickedRowRef 주석 참고.
 */

/**
 * 신규행 식별 키. **Symbol** 인 이유 — 화면들이 팝업 선택값 반영 시
 * `prev.map(r => ({ ...r, PROJECT_CODE }))` 로 행 객체를 통째로 갈아끼운다(참조 소멸).
 * spread 는 own enumerable **symbol** 속성도 복사하므로 키가 살아남아 anchor 가 유지되고,
 * 동시에 `Object.keys`/`Object.entries`/`JSON.stringify`(저장 payload 조립 경로)에는
 * 절대 노출되지 않는다 — 문자열 키였다면 SP payload 에 쓰레기 컬럼이 섞인다.
 */
const INSERT_ROW_KEY = Symbol('nscm.insertedRowKey');

/** anchor 토큰 — 조회행은 행 참조 자체, 신규행은 INSERT_ROW_KEY 문자열(참조가 교체되므로). */
type AnchorToken = string | object;

/**
 * 신규행 1건의 삽입 위치 정보.
 *
 * `token` = "이 행 바로 위" 기준 행. 참조/키 기반이라 이후 삽입·삭제로 위치가 밀려도 정확하다.
 * `index` = 삽입 당시 화면에서의 위치. **token 을 못 찾을 때의 폴백**이다.
 *   조회 데이터가 새 객체로 갈리는 등 어떤 이유로든 token 매칭이 깨지면 예전에는 신규행이
 *   전부 맨 위로 떨어졌다(2026-07-29 리포트 — 중간 행을 눌러도 1행에 생성). 위치 정보를 이중으로
 *   들고 있으면 최악의 경우에도 "누른 자리 근처"를 유지한다.
 */
type AnchorInfo = { token: AnchorToken | null; index: number };

const keyOf = (row: unknown): string | undefined =>
  (row as Record<symbol, unknown> | null | undefined)?.[INSERT_ROW_KEY] as string | undefined;

/**
 * FlexGrid 최소 구조 — wijmo 타입에 하드 의존하지 않기 위한 structural type
 * (테스트에서 그리드 없이 anchor 동작을 검증할 수 있게 하는 목적도 겸한다).
 */
export type InsertAnchorGrid = {
  selection?: { row: number; row2?: number; col?: number } | null;
  rows: ArrayLike<{ dataItem?: unknown }>;
  select?: (row: number, col: number) => void;
  scrollIntoView?: (row: number, col: number) => unknown;
  /** 아래 세 개는 "실제로 클릭한 행" 판정용 — 없으면 selection 만으로 동작한다. */
  hostElement?: HTMLElement | null;
  cells?: unknown;
  hitTest?: (e: MouseEvent) => { row: number; panel?: unknown } | null;
};

/** 그리드 인스턴스 참조 — 페이지가 이미 들고 있는 `gridRef` 를 그대로 넘긴다. */
export type InsertAnchorGridRef = {
  current?: InsertAnchorGrid | null;
};

/**
 * "기준 행"(이 행 바로 위에 삽입) 인덱스 판정.
 *
 * 기본은 `selection.row` 지만, 병합된 셀을 클릭하면 Wijmo 가 선택을 병합 블록 전체
 * (`row`~`row2`)로 잡아 `row` 가 블록 첫 행이 된다. 그래서 마우스로 실제 누른 행이
 * 그 선택 범위 안이면 그 행을 쓴다 — 사용자가 집은 행이 기준이 되도록.
 *
 * 키보드(방향키) 이동은 mousedown 이 없어 clickedRow 가 낡은 값인데, 그 값은 새 선택 범위
 * 밖일 가능성이 크므로 범위 검사에서 자연히 걸러진다.
 */
const resolveSelectedRow = (
  grid: InsertAnchorGrid | null | undefined,
  clickedRow: number | null
): number => {
  const selection = grid?.selection;
  const row = selection?.row ?? -1;
  if (row < 0 || clickedRow == null) return row;
  const row2 = selection?.row2 ?? row;
  const lo = Math.min(row, row2);
  const hi = Math.max(row, row2);
  return clickedRow >= lo && clickedRow <= hi ? clickedRow : row;
};

/**
 * 조회결과(spRows)에 신규행(insertedRows)을 anchor 위치대로 끼워 넣어 그리드 소스를 만든다.
 * 순수 함수 — 훅과 별개로 단위 테스트 대상.
 *
 * @param anchors 신규행 키 → 위치 정보. `token: null`(= 선택행 없이 추가) 이면 맨 위.
 */
export const mergeInsertedRows = <T>(
  spRows: readonly T[],
  insertedRows: readonly T[],
  anchors: ReadonlyMap<string, AnchorInfo>
): T[] => {
  if (insertedRows.length === 0) return [...spRows];

  // anchor 토큰 → 그 앞에 들어갈 신규행들. push 순서 = 위→아래 표시 순서
  // (같은 행을 선택해 연속 Insert 하면 먼저 넣은 행이 위 — AS-IS 체감과 동일).
  const before = new Map<AnchorToken, T[]>();
  const top: T[] = [];

  for (const row of insertedRows) {
    const key = keyOf(row);
    const anchor = key === undefined ? null : (anchors.get(key)?.token ?? null);
    if (anchor === null) {
      top.push(row);
      continue;
    }
    const list = before.get(anchor);
    if (list) list.push(row);
    else before.set(anchor, [row]);
  }

  const out: T[] = [];
  const seen = new Set<T>();
  // 행을 출력하기 직전에 "그 행을 anchor 로 삼은 신규행들"을 먼저 출력(재귀 —
  // 신규행 위에 다시 Insert 한 체인도 순서대로 풀린다). seen = 비정상 순환 방어.
  const emit = (row: T) => {
    if (seen.has(row)) return;
    seen.add(row);

    const key = keyOf(row);
    if (key !== undefined) {
      const anchored = before.get(key);
      if (anchored) {
        before.delete(key);
        anchored.forEach(emit);
      }
    }
    const anchoredByRef = before.get(row as unknown as object);
    if (anchoredByRef) {
      before.delete(row as unknown as object);
      anchoredByRef.forEach(emit);
    }

    out.push(row);
  };

  top.forEach(emit);
  spRows.forEach(emit);

  // anchor 행을 못 찾은 신규행 — 유실 금지. 맨 위로 몰지 않고 "삽입 당시 화면 위치"로 되돌린다.
  //   (anchor 였던 신규행을 Delete 한 경우 / 조회 데이터가 새 객체로 갈린 경우 등)
  //   index 오름차순으로 splice 해야 뒤 행의 목표 위치가 밀리지 않는다.
  const orphans = insertedRows
    .filter(row => !seen.has(row))
    .map(row => ({ row, index: anchors.get(keyOf(row) ?? '')?.index ?? 0 }))
    .sort((a, b) => a.index - b.index);

  orphans.forEach(({ row, index }) => {
    out.splice(Math.min(Math.max(index, 0), out.length), 0, row);
  });

  return out;
};

export type UseInsertedRowsResult<T> = {
  /** 신규행 목록 — 저장 payload/검증/pending 가드용. 표시 순서와는 무관하다. */
  insertedRows: T[];
  /** 기존 코드 호환 — delete(filter) / reset([]) / 팝업 patch(map) 그대로 사용. */
  setInsertedRows: Dispatch<SetStateAction<T[]>>;
  /**
   * 선택행 **바로 위**에 신규행 추가. 선택행이 없으면 맨 위(기존 동작 유지).
   * `grid` 를 생략하면 훅에 넘긴 `gridRef.current` 를 쓴다.
   */
  insertAbove: (rows: T | readonly T[], grid?: InsertAnchorGrid | null) => void;
  /** 조회결과와 신규행을 합쳐 그리드 소스 생성. 입력이 같으면 같은 배열 참조를 돌려준다. */
  mergeRows: (spRows: readonly T[]) => T[];
};

export const useInsertedRows = <T extends object>(
  gridRef?: InsertAnchorGridRef | null
): UseInsertedRowsResult<T> => {
  const [insertedRows, setRows] = useState<T[]>([]);
  const anchorsRef = useRef(new Map<string, AnchorInfo>());
  const seqRef = useRef(0);
  // 삽입 직후 선택을 되돌릴 대상 — 아래 useEffect 가 소비한다.
  const focusRef = useRef<{ grid: InsertAnchorGrid; row: T; col: number } | null>(null);
  // 마지막으로 마우스로 누른 데이터 행 — 병합 셀 보정용 (아래 useEffect 가 채운다).
  const clickedRowRef = useRef<number | null>(null);

  // ⭐ 병합 셀 클릭 보정 — Wijmo 는 병합된 셀을 클릭하면 선택을 병합 블록 전체로 잡아
  //   `selection.row` 가 "누른 행"이 아니라 "블록의 첫 행"이 된다. End Customer/Sales Site 처럼
  //   같은 값이 길게 이어지는 컬럼은 블록이 수십~수백 행이라, 40행을 눌러도 블록 첫 행(=1행)이
  //   기준이 되어 "항상 맨 위에 생긴다"로 보였다(2026-07-29 리포트).
  //   ⇒ hitTest 로 실제 누른 행을 따로 기록해 둔다. document capture 로 받으므로 그리드가
  //     언제 mount/재생성되든(gridRef.current 를 이벤트 시점에 읽는다) 배선이 깨지지 않는다.
  useEffect(() => {
    if (!gridRef) return;
    const onMouseDown = (e: MouseEvent) => {
      const grid = gridRef.current;
      const host = grid?.hostElement;
      if (!grid?.hitTest || !host || !(e.target instanceof Node) || !host.contains(e.target))
        return;
      const hit = grid.hitTest(e);
      // 데이터 셀(cells 패널)만 — 컬럼헤더/행헤더 클릭은 무시.
      if (hit && hit.row >= 0 && (hit.panel === undefined || hit.panel === grid.cells))
        clickedRowRef.current = hit.row;
    };
    document.addEventListener('mousedown', onMouseDown, true);
    return () => document.removeEventListener('mousedown', onMouseDown, true);
  }, [gridRef]);

  const setInsertedRows = useCallback<Dispatch<SetStateAction<T[]>>>(action => {
    setRows(prev => {
      const next = typeof action === 'function' ? (action as (p: T[]) => T[])(prev) : action;
      // 신규행 0건 = 재조회/저장/division 변경 등 reset 시점 — anchor 기록도 함께 비운다.
      if (next.length === 0) anchorsRef.current.clear();
      return next;
    });
  }, []);

  // 이탈 confirm 에서 "확인"(버리고 진행)을 누르면 신규행 state 도 함께 비운다.
  //   그리드(DataGrid)의 되돌리기는 collectionView 에서만 지우므로, state 를 안 비우면
  //   다음 렌더에 mergeRows 가 신규행을 다시 끼워 넣는다.
  useDirtyReset(() => setInsertedRows([]));

  const insertAbove = useCallback(
    (rows: T | readonly T[], gridArg?: InsertAnchorGrid | null) => {
      const newRows = (Array.isArray(rows) ? [...rows] : [rows]) as T[];
      if (newRows.length === 0) return;

      const grid = gridArg ?? gridRef?.current ?? null;
      const selectedIndex = resolveSelectedRow(grid, clickedRowRef.current);
      const selected =
        selectedIndex >= 0 ? ((grid?.rows[selectedIndex]?.dataItem ?? null) as T | null) : null;
      // 선택행이 신규행이면 키를(참조가 팝업 patch 로 교체될 수 있음), 조회행이면 참조 자체를 anchor 로.
      const anchor: AnchorToken | null = selected
        ? (keyOf(selected) ?? (selected as unknown as object))
        : null;

      // 삽입 당시 화면 위치 — token 매칭 실패 시의 폴백 (블록은 첫 행부터 순서대로).
      const baseIndex = selectedIndex >= 0 ? selectedIndex : 0;

      newRows.forEach((row, offset) => {
        seqRef.current += 1;
        const key = `ins_${seqRef.current}`;
        (row as Record<symbol, unknown>)[INSERT_ROW_KEY] = key;
        anchorsRef.current.set(key, { token: anchor, index: baseIndex + offset });
      });

      // 삽입 후 그리드 선택을 새 행으로 되돌리기 위해 기억해 둔다 (아래 useEffect).
      if (grid) focusRef.current = { grid, row: newRows[0], col: grid.selection?.col ?? 0 };

      setRows(prev => [...prev, ...newRows]);
    },
    [gridRef]
  );

  // ⭐ 삽입 후 포커스 유지 — itemsSource 배열 참조가 바뀌면 Wijmo 가 CollectionView 를 새로 만들며
  //   선택을 (0,0) 으로 초기화한다. 그래서 "행은 선택한 자리에 생겼는데 포커스만 1번 행으로 튀는"
  //   현상이 생긴다(2026-07-29 사용자 리포트). 신규행 위치를 다시 찾아 선택/스크롤을 복원한다.
  //   (기존 맨 위 삽입 방식에서는 신규행이 마침 0번이라 이 초기화가 드러나지 않았을 뿐이다.)
  useEffect(() => {
    const focus = focusRef.current;
    if (!focus) return;

    const apply = (): boolean => {
      const { grid, row, col } = focus;
      const gridRows = grid.rows;
      for (let i = 0; i < gridRows.length; i++) {
        if (gridRows[i]?.dataItem !== row) continue;
        grid.select?.(i, col);
        grid.scrollIntoView?.(i, col);
        return true;
      }
      return false;
    };

    // 그리드는 자식이라 새 itemsSource 를 이미 반영한 상태가 정상이지만,
    // 반영 전이면(래퍼 구현 차이) 다음 프레임에 1회만 재시도한다.
    if (apply()) {
      focusRef.current = null;
      return;
    }
    const frame = requestAnimationFrame(() => {
      apply();
      focusRef.current = null;
    });
    return () => cancelAnimationFrame(frame);
  }, [insertedRows]);

  // 그리드 itemsSource 참조 안정화 — 매 렌더 새 배열이면 Wijmo 가 CollectionView 를 재생성한다
  // (스크롤/선택/병합 리셋). 입력(spRows·insertedRows) 참조가 그대로면 이전 결과를 재사용.
  const cacheRef = useRef<{ sp: readonly T[]; ins: readonly T[]; out: T[] } | null>(null);
  const mergeRows = useCallback(
    (spRows: readonly T[]): T[] => {
      const cached = cacheRef.current;
      if (cached && cached.sp === spRows && cached.ins === insertedRows) return cached.out;
      const out = mergeInsertedRows(spRows, insertedRows, anchorsRef.current);
      cacheRef.current = { sp: spRows, ins: insertedRows, out };
      return out;
    },
    [insertedRows]
  );

  return { insertedRows, setInsertedRows, insertAbove, mergeRows };
};
