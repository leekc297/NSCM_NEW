// DMF0045 — call-proc 직접 호출 헬퍼 (SAVE '^' bulk 결과 파싱). DMF0021 sales-plan.api 1:1 이식.
//   '^' delim 다건 SAVE 는 apiClient.post 직접 — useProcMutation array unfold 회피 표준
//   (memory feedback_save_sp_bulk_payload_apiclient_post).
//   DMF0045 는 전용 mapper 없음 — /{MENU_ID}/{sheet}/SAVE/call-proc 로 makeProcedure(BaseService)
//   가 SCM_ADM_PROC_M.COL_NM positional 로 P_ 파라미터를 해석한다(sales-plan 검증 규약).
import { apiClient } from '@foundation/apis';

import { MENU_ID } from '../dmf0045.constants';
import type { ActiveSheet } from '../dmf0045.types';

// SAVE 결과 — AS-IS SaveData L2717~2794: 첫 셀 == 'success'/'0' 성공 / 그 외 실패.
//   실패 커서 '^' 토큰에서 MSG 코드를 뽑아 msgCode 로 올린다(호출측 t() 변환).
//   코드를 못 찾으면 SP 오류문 원문을 addMessage 로 넘긴다. 상세 규약은 parseSaveOutcome 주석.
export interface SaveShipmentRequestResult {
  ok: boolean;
  msgCode?: string;
  addMessage?: string;
}

const MSG_CODE_RE = /^MSG\d+$/i;
// 코드가 문구와 한 토큰에 붙어 오는 경우(구분자가 '^' 아니라 공백인 SP) 를 위한 패턴.
const MSG_CODE_IN_TOKEN_RE = /\bMSG\d+\b/i;

/**
 * SP 결과 값 배열 → 저장 판정 (첫 커서 첫 행 값들, 컬럼 순서 그대로).
 * 실패 커서 규약(CODE/MSG/EVENT 3열, MSG 코드는 EVENT 안 'MSGxxxxx^<value>')을 전 컬럼 '^'
 * 평탄화 후 첫 MSG 코드 토큰으로 판정한다(sales-plan.parseSaveOutcome 1:1). 상세는 그 주석 참조.
 */
export const parseSaveOutcome = (resultValues: unknown[]): SaveShipmentRequestResult => {
  if (resultValues.length === 0) return { ok: true };

  const status = String(resultValues[0]).trim();
  if (status === '0' || status.toLowerCase() === 'success') return { ok: true };

  const tokens = resultValues
    .flatMap(value => String(value).split('^'))
    .map(token => token.trim())
    .filter(Boolean);

  const codeIdx = tokens.findIndex(token => MSG_CODE_RE.test(token));
  if (codeIdx >= 0) {
    return {
      ok: false,
      msgCode: tokens[codeIdx],
      addMessage: tokens.slice(codeIdx + 1).join('^') || undefined,
    };
  }

  const embeddedIdx = tokens.findIndex(token => MSG_CODE_IN_TOKEN_RE.test(token));
  if (embeddedIdx >= 0) {
    const token = tokens[embeddedIdx];
    const match = MSG_CODE_IN_TOKEN_RE.exec(token);
    if (match) {
      const trailing = token.slice(match.index + match[0].length).trim();
      const rest = [trailing, ...tokens.slice(embeddedIdx + 1)].filter(Boolean);
      return { ok: false, msgCode: match[0], addMessage: rest.join('^') || undefined };
    }
  }

  const rest = tokens[0] === '-1' ? tokens.slice(1) : tokens;
  return { ok: false, msgCode: undefined, addMessage: rest.join('^') || undefined };
};

// 줄바꿈 표기 통일 — MSG_M 본문의 리터럴 '\r\n'/'\n' 및 진짜 CRLF 모두 '\n' 으로 (sales-plan 1:1).
const normalizeNewlines = (text: string): string =>
  text.replace(/\\r\\n|\\n|\\r/g, '\n').replace(/\r\n?/g, '\n');

/**
 * 저장 실패 팝업 문구 조립 — AS-IS SaveData L2776~2788 [E20250520-000572] 1:1.
 *   1. MSG_M 미등록(body===msgCode): SP 상세문구만(없으면 코드).
 *   2. body 에 '{0}': 상세문구로 치환. 3. 없으면 줄바꿈으로 잇는다.
 * 상세는 sales-plan.formatSaveErrorText 주석 참조.
 */
export const formatSaveErrorText = (
  template: string,
  addMessage?: string,
  msgCode?: string
): string => {
  const body = normalizeNewlines(template);
  const add = normalizeNewlines(addMessage ?? '')
    .split('^')
    .map(part => part.trim())
    .filter(Boolean)
    .join('\n');
  if (msgCode && body === msgCode) return add || body;
  if (body.includes('{0}')) return body.replace('{0}', add);
  return add ? `${body}\n${add}` : body;
};

// SAVE 호출 — 활성 시트(Pack Biz/Cell Biz) 경로로 '^' bulk payload 전송.
//   주의: call-proc SP 실패는 공용 responseInterceptor 가 O_RESULT_CURSOR[0].CODE 로 throw 하기도
//   한다(memory). 그래서 호출측(handleSave)은 try/catch 로 감싸고, 여기서는 정상 응답 경로만 판정한다.
export const callSaveShipmentRequest = async (
  sheet: ActiveSheet,
  payload: Record<string, string>
): Promise<SaveShipmentRequestResult> => {
  const res = await apiClient.post<Record<string, unknown>>(
    `/${MENU_ID}/${sheet}/SAVE/call-proc`,
    payload
  );
  // status 500/403 은 responseErrorInterceptor 가 resolve → 직접 차단 (false success 방지).
  if (res.status >= 400 || Number((res.data as { code?: string })?.code)) {
    return { ok: false, addMessage: (res.data as { message?: string })?.message?.trim() };
  }
  // 결과 커서 첫 행 첫 값 판정 — 커서명 비의존(방어적): result 가 배열이면 그대로, 객체면 첫 배열 값.
  const result = (res.data as { result?: unknown })?.result;
  const rows = Array.isArray(result)
    ? (result as unknown[])
    : result && typeof result === 'object'
      ? (Object.values(result as Record<string, unknown>).find(v => Array.isArray(v)) as
          | unknown[]
          | undefined)
      : undefined;
  const first = rows?.[0];
  const values =
    first && typeof first === 'object' ? Object.values(first as Record<string, unknown>) : [first];
  const resultValues = values.filter(
    value =>
      (typeof value === 'string' && value.trim() !== '') ||
      (typeof value === 'number' && Number.isFinite(value))
  );
  return parseSaveOutcome(resultValues);
};
