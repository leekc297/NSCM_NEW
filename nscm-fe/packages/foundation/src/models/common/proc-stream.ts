/**
 * [E20261015-STREAMPROC] 대량 조회 스트리밍(call-proc-stream) 계약.
 *
 * BE 는 같은 메타(SCM_ADM_MNU_BTN_MPG_M → API_M → PROC_M)로 같은 프로시저를 실행하고, OUT 커서를 읽는 즉시
 * 묶음 단위 NDJSON(줄마다 JSON 1개)으로 보낸다. 상태 커서(O_RESULT_CURSOR)는 데이터 커서보다 먼저 온다.
 * 행 값 형식은 기존 call-proc 응답과 같다(날짜 'yyyy-MM-dd HH:mm:ss' 문자열, NULL 컬럼도 키 포함).
 */
export type ProcStreamLine<TRow = Record<string, unknown>> =
  | { t: 'cursor'; c: string; cols: string[] }
  | { t: 'rows'; c: string; rows: TRow[] }
  | { t: 'cursorEnd'; c: string; count: number }
  | { t: 'out'; c: string; v: unknown }
  | { t: 'error'; message: string }
  | { t: 'end'; rows: number; ms: number };

export interface ProcStreamHandlers<TRow = Record<string, unknown>> {
  /** 커서별 행 묶음 — 도착 순서대로 호출된다 (상태 커서도 같은 콜백 — 커서 이름으로 구분) */
  onRows: (cursorName: string, rows: TRow[]) => void;
  /** 커서 시작(컬럼 목록) */
  onCursor?: (cursorName: string, columns: string[]) => void;
}

export interface ProcStreamResult {
  /** BE 가 보낸 전체 행 수(모든 커서 합) */
  rows: number;
  /** BE 측 실행+전송 소요(ms) */
  ms: number;
}
