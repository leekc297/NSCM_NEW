/**
 * 저장 응답 판정 — HTTP -> BE 봉투 code -> SP RESULT_CODE 를 **바깥 축부터** 본다.
 *   바깥이 깨졌으면 안쪽 본문은 믿을 수 없다(500 응답 본문에 직전 성공 커서가 남는 경우가 있다).
 *
 * 자매 SSP0201 `shipmentChangeRequestResult.ts` 와 같은 규약을 이 폴더에 복제한 것이다
 *   (화면 간 import 금지, CORE-05 Hard Boundary).
 */

import { safeString } from '@foundation/utils';

export type SaveOutcome = 'ok' | 'fail' | 'unknown';

export interface JudgeableResponse {
  status?: number;
  data?: unknown;
}

type Row = Record<string, unknown>;

const s = (v: unknown): string => safeString(v).trim();

/**
 * SP 반환코드를 **이름으로** 읽는다. 성공 커서가 부가열을 함께 돌려줄 때 위치([0])로 읽으면
 *   부가열을 코드로 오인한다(자매 SSP0201 이 겪은 사고). `call-proc` 결과맵은 열 순서를 보장하지 않는다.
 */
export const readResultCode = (data: unknown): string => {
  const rows = (data as { result?: { o_rc1?: Row[] } } | undefined)?.result?.o_rc1 ?? ([] as Row[]);
  const row = rows[0];
  if (!row) return '';
  return s(row.RESULT_CODE ?? row.result_code);
};

/** `apiClient.post` 가 **resolve 한** 경우에만 쓴다(reject 는 judgeSaveError). */
export const judgeSaveResponse = (res: JudgeableResponse): SaveOutcome => {
  // 1) HTTP — 인터셉터가 403·500 을 error.response 로 resolve 하므로 여기서 걸러야 한다.
  if (Number(res.status) >= 400) return 'fail';
  // 2) BE 봉투 code — 부재·null·공백은 "신호 없음" 이라 다음 축으로 넘긴다.
  const code = (res.data as { code?: unknown } | undefined)?.code;
  if (code !== null && code !== undefined && s(code) !== '') {
    const numeric = Number(s(code));
    if (Number.isNaN(numeric)) return 'unknown';
    if (numeric !== 0) return 'fail';
  }
  return 'ok';
};

/**
 * throw 된 경우. 인터셉터는 DB 오류행을 `new Error(MSG, { cause: resultRow })` 로 던지므로
 *   `cause` 가 있으면 서버가 오류를 **판정해서** 돌려준 것이다(fail). 그 밖은 요청이 닿았는지조차
 *   알 수 없어 unknown 이다.
 */
export const judgeSaveError = (error: unknown): SaveOutcome =>
  !!error && typeof error === 'object' && 'cause' in error && (error as { cause?: unknown }).cause
    ? 'fail'
    : 'unknown';
