/**
 * SSP0201 저장 결과 판정 — **단일 판정 함수**.
 *
 * 종전에는 `httpFailed`(HTTP/BE code) 와 `resultCodeOf`(SP RESULT_CODE) 둘로 갈려 있어, 호출부마다
 * 둘을 어떤 순서로 묶는지가 조금씩 달랐다. 두 축을 한 함수로 합쳐 세 값으로만 답한다.
 *
 *   ok      저장됐다           — SP 가 RESULT_CODE='S' 를 돌려줬다.
 *   fail    저장되지 않았다    — HTTP 오류 / BE code 비0 / RESULT_CODE 가 'S' 가 아닌 다른 값.
 *   unknown 알 수 없다        — 응답 형태가 판정 근거를 주지 않았다(RESULT_CODE 부재·공백,
 *                                BE code 가 숫자가 아님, 통신 자체가 끊김).
 *
 * `unknown` 을 `fail` 과 분리하는 이유: **성공 토스트를 띄우지 않기 위한 축**이기 때문이다.
 * 판정 근거가 없을 때 ok 로 떨어지면 저장되지 않은 건이 "저장되었습니다" 로 새어 나간다
 * (인터셉터가 403·500 을 reject 하지 않고 resolve 하므로 status 분기가 없으면 실제로 새어 나갔다).
 * 반대로 unknown 을 fail 로 단정하면 "실패했다" 고 알린 건이 실제로는 커밋돼 있을 수 있다 —
 * 그래서 호출부가 둘을 구분할 수 있게 값을 따로 둔다.
 *
 * 판정 순서는 **바깥 축부터**다. HTTP -> BE code -> SP RESULT_CODE. 바깥이 깨졌으면 안쪽 본문은
 * 믿을 수 없다(500 응답 본문에 직전 성공 커서가 남아 있는 경우가 있다).
 */

import { safeString } from '@foundation/utils';

export type SaveOutcome = 'ok' | 'fail' | 'unknown';

/** apiClient.post 응답 중 판정에 쓰는 부분만. 제네릭 data 타입에 묶이지 않게 unknown 으로 받는다. */
export interface JudgeableResponse {
  status?: number;
  data?: unknown;
}

const SUCCESS_CODE = 'S';

type Row = Record<string, unknown>;

const s = (v: unknown): string => safeString(v).trim();

/**
 * SP 반환코드를 **이름으로** 읽는다.
 *
 * 성공 커서가 RESULT_CODE 외에 부가열(CHANGE_REQ_NO·CONFIRM_ID 등)을 함께 돌려줄 때 위치([0])로
 * 읽으면 부가열을 코드로 오인한다 — 자매 SSP0200 이 실제로 그 사고를 겪었다(DRAFTING 성공인데
 * REQUEST_NO 'R…' 를 실패코드로 오판, shipmentChangeRequestPlanSave.ts §98 주석). `call-proc` 결과맵은
 * 열 순서를 보장하지 않으므로 위치 폴백을 두지 않는다. 행 키는 getColumnLabel 로 대문자가 표준이고,
 * 소문자 변형만 함께 본다.
 */
export const readResultCode = (data: unknown): string => {
  const rows = (data as { result?: { o_rc1?: Row[] } } | undefined)?.result?.o_rc1 ?? ([] as Row[]);
  const row = rows[0];
  if (!row) return '';
  return s(row.RESULT_CODE ?? row.result_code);
};

/**
 * 응답 1건을 판정한다. `apiClient.post` 가 **resolve 한** 경우에만 쓴다(reject 는 judgeSaveError).
 */
export const judgeSaveResponse = (res: JudgeableResponse): SaveOutcome => {
  // 1) HTTP — 인터셉터가 403·500 을 error.response 로 **resolve** 하므로 여기서 걸러야 한다.
  if (Number(res.status) >= 400) return 'fail';

  // 2) BE 봉투 code — `ApiResponse.code` 는 optional string 이다. 부재·null·공백은 "신호 없음" 이라
  //    다음 축으로 넘긴다(종전 `!!Number(code)` 도 부재를 통과시켰다 — 그 거동을 지킨다).
  //    값이 있는데 숫자로 읽히지 않으면 봉투를 해석할 수 없다는 뜻이라 unknown 이다.
  const code = (res.data as { code?: unknown } | undefined)?.code;
  if (code !== null && code !== undefined && s(code) !== '') {
    const n = Number(code);
    if (Number.isNaN(n)) return 'unknown';
    if (n !== 0) return 'fail';
  }

  // 3) SP RESULT_CODE — 여기까지 와서 근거가 없으면(부재·공백) 저장 여부를 단정하지 않는다.
  const resultCode = readResultCode(res.data);
  if (!resultCode) return 'unknown';
  return resultCode === SUCCESS_CODE ? 'ok' : 'fail';
};

/**
 * `apiClient.post` 가 **reject 한** 경우를 판정한다.
 *
 * 인터셉터는 DB 오류행을 `new Error(MSG, { cause: resultRow })` 로 던진다(axios-interceptors §33) —
 * `cause` 가 실려 있으면 서버가 오류를 **판정해서** 돌려준 것이므로 저장되지 않았다(fail).
 * 그 밖의 throw(네트워크 단절·타임아웃·BE code 예외)는 요청이 서버에 닿았는지조차 알 수 없어 unknown 이다.
 *
 * 한계: 인터셉터의 통신오류 분기도 `{ cause: error }` 를 붙인다(§65). 그 경로는 여기서 fail 로
 * 읽히는데, 엄밀히는 unknown 이다. 사용자 지시(2026-10-12)의 판정 규칙을 그대로 구현한 것이고,
 * 두 경로를 가르려면 cause 가 axios error 인지(= 통신) DB 결과행인지로 한 번 더 나눠야 한다.
 */
export const judgeSaveError = (error: unknown): SaveOutcome =>
  !!error && typeof error === 'object' && 'cause' in error && (error as { cause?: unknown }).cause
    ? 'fail'
    : 'unknown';
