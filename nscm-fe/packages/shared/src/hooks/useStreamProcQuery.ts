import type { FlexGrid } from '@mescius/wijmo.grid';
import { useCallback, useEffect, useRef, useState, type MutableRefObject } from 'react';

import { apiClient } from '@foundation/apis';
import type { ProcStreamResult } from '@foundation/models';

/**
 * [E20261015-STREAMPROC] 대량 조회 스트리밍 훅 — call-proc-stream 결과를 받는 즉시 그리드에 이어 붙인다.
 *
 * 왜: 기존 useTabProcQuery 는 결과 전량(예 SCP0030 28.9만 행·234MB)을 다 받은 뒤에야 그리드를 그린다.
 *   이 훅은 첫 묶음(약 1,000행)이 오면 바로 표시하고, 이후 묶음은 같은 배열에 push 한 뒤
 *   collectionView.refresh() 로 반영한다(배열 참조를 바꾸지 않으므로 DataGrid 가 다시 바인딩되지 않음).
 *
 * 사용:
 *   const stream = useStreamProcQuery<Row>({ menuId, sheetName, gridRef, transformRow });
 *   stream.start(filters)            // 조회 (진행 중이면 이전 요청 취소 후 새로 시작)
 *   <DataGrid itemsSource={stream.data} .../>
 *   stream.isStreaming / stream.loadedCount  // 수신 중 표시·버튼 비활성
 *
 * 수신 중에는 데이터가 아직 불완전하므로 저장·엑셀 등은 화면에서 isStreaming 동안 막는다.
 */
export interface UseStreamProcQueryOptions<Row> {
  menuId: string;
  sheetName: string;
  procedureAction?: string;
  /** 그리드에 넣을 데이터 커서 이름 (PROC_M COL_NM) */
  dataCursor?: string;
  /** 데이터를 이어 붙일 그리드 — collectionView.refresh 대상 */
  gridRef?: MutableRefObject<FlexGrid | undefined>;
  /** 행 정규화(날짜 등) — 묶음 도착 시 행마다 1회 */
  transformRow?: (row: Row) => Row;
  /** 수신 중 그리드 갱신 최소 간격(ms) */
  refreshIntervalMs?: number;
  onDone?: (result: ProcStreamResult & { loaded: number }) => void;
  onError?: (error: Error) => void;
}

export const useStreamProcQuery = <Row extends object>({
  menuId,
  sheetName,
  procedureAction = 'SEARCH',
  dataCursor = 'o_rc1',
  gridRef,
  transformRow,
  refreshIntervalMs = 1000,
  onDone,
  onError,
}: UseStreamProcQueryOptions<Row>) => {
  const [data, setData] = useState<Row[]>([]);
  const [isStreaming, setIsStreaming] = useState(false);
  const [loadedCount, setLoadedCount] = useState(0);
  const [error, setError] = useState<Error | undefined>(undefined);

  const rowsRef = useRef<Row[]>([]);
  const controllerRef = useRef<AbortController | undefined>(undefined);
  const runIdRef = useRef(0);
  const lastRefreshRef = useRef(0);
  // 콜백은 최신 것을 쓰되 start 의 참조는 고정한다(조건 변경마다 effect 재실행 방지)
  const optionsRef = useRef({ transformRow, onDone, onError, gridRef, refreshIntervalMs });
  optionsRef.current = { transformRow, onDone, onError, gridRef, refreshIntervalMs };

  const refreshGrid = useCallback((force: boolean) => {
    const grid = optionsRef.current.gridRef?.current;
    const view = grid?.collectionView;
    if (!grid || !view || view.sourceCollection !== rowsRef.current) return;
    if (!force && grid.activeEditor) return; // 셀 편집 중에는 다음 기회로 미룬다
    const now = Date.now();
    if (!force && now - lastRefreshRef.current < optionsRef.current.refreshIntervalMs) return;
    lastRefreshRef.current = now;
    view.refresh();
  }, []);

  const cancel = useCallback(() => {
    controllerRef.current?.abort();
    controllerRef.current = undefined;
  }, []);

  const start = useCallback(
    (params: object | undefined) => {
      cancel();
      const runId = ++runIdRef.current;
      const controller = new AbortController();
      controllerRef.current = controller;
      const rows: Row[] = [];
      rowsRef.current = rows;
      let bound = false;
      lastRefreshRef.current = 0;
      setData([]);
      setLoadedCount(0);
      setError(undefined);
      setIsStreaming(true);

      apiClient
        .callProcStream<Row>(
          menuId,
          sheetName,
          procedureAction,
          params,
          {
            onRows: (cursorName, batch) => {
              if (runId !== runIdRef.current || cursorName !== dataCursor) return;
              const transform = optionsRef.current.transformRow;
              for (const raw of batch) rows.push(transform ? transform(raw) : raw);
              if (!bound) {
                // 첫 묶음 — 이 배열을 그리드에 바인딩(이후에는 같은 배열에 push 만)
                bound = true;
                setData(rows);
              } else {
                refreshGrid(false);
              }
              setLoadedCount(rows.length);
            },
          },
          controller.signal
        )
        .then(result => {
          if (runId !== runIdRef.current) return;
          if (!bound) setData(rows); // 0행 결과
          refreshGrid(true);
          setLoadedCount(rows.length);
          setIsStreaming(false);
          optionsRef.current.onDone?.({ ...result, loaded: rows.length });
        })
        .catch((e: unknown) => {
          if (runId !== runIdRef.current) return;
          setIsStreaming(false);
          if (e instanceof DOMException && e.name === 'AbortError') return;
          const err = e instanceof Error ? e : new Error(String(e));
          setError(err);
          optionsRef.current.onError?.(err);
        });
    },
    [cancel, dataCursor, menuId, procedureAction, refreshGrid, sheetName]
  );

  // 화면(탭) 종료 시 진행 중 수신 취소
  useEffect(() => cancel, [cancel]);

  return { data, start, cancel, isStreaming, loadedCount, error };
};
