// SCP0111 저장 call-proc 직접 호출 — '^'delim bulk payload 는 useProcMutation(배열 unfold)을 우회해
//   apiClient.post 로 직접 보낸다(feedback_save_sp_bulk_payload_apiclient_post 규약). false-success 방지:
//   status>=400 / code!=0 / 결과커서 첫값 판정(design 03 §4 Tables[0][0]=='S', cs:1717~).
import { apiClient } from '@foundation/apis';

import { MENU_ID, SAVE_ACTION, SHEETS } from '../integration-psi.constants';
import type { SaveMode } from '../integration-psi.types';

export interface SaveResult {
  ok: boolean;
  msgCode?: string; // MSG 코드(있으면 호출부 t() 변환)
  addMessage?: string; // SP 상세 오류문
}

const MSG_CODE_RE = /^MSG\d+$/i;

// 결과 커서 값 배열 → 저장 판정 (design 03 §4-저장: Tables[0][0][0]=='S'/'success'/'0' 성공).
//   실패 시 '^' 평탄화 후 첫 MSG 코드 토큰을 뽑고 뒤 토큰을 상세문구로. 코드 없으면 원문 전달.
export const parseSaveOutcome = (resultValues: unknown[]): SaveResult => {
  if (resultValues.length === 0) return { ok: true };
  const status = String(resultValues[0]).trim().toLowerCase();
  if (status === 's' || status === '0' || status === 'success') return { ok: true };

  const tokens = resultValues
    .flatMap(v => String(v).split('^'))
    .map(t => t.trim())
    .filter(Boolean);
  const codeIdx = tokens.findIndex(t => MSG_CODE_RE.test(t));
  if (codeIdx >= 0) {
    return {
      ok: false,
      msgCode: tokens[codeIdx],
      addMessage: tokens.slice(codeIdx + 1).join('\n') || undefined,
    };
  }
  const rest = tokens[0] === '-1' ? tokens.slice(1) : tokens;
  return { ok: false, addMessage: rest.join('\n') || undefined };
};

// SAVE 실행 — mode 로 procedureAction(일반 SAVE / ADMIN SAVEDETAIL) 분기.
export const callSaveIntegrationPsi = async (
  mode: SaveMode,
  payload: Record<string, string>
): Promise<SaveResult> => {
  const action = mode === 'ADMIN' ? SAVE_ACTION.ADMIN : SAVE_ACTION.GENERAL;
  const res = await apiClient.post<Record<string, unknown>>(
    `/${MENU_ID}/${SHEETS.MAIN}/${action}/call-proc`,
    payload
  );
  // status 500/403 은 인터셉터가 resolve → 직접 차단(false-success 방지).
  if (res.status >= 400 || Number((res.data as { code?: string })?.code)) {
    return { ok: false, addMessage: (res.data as { message?: string })?.message?.trim() };
  }
  // 결과 커서 첫 행 첫 값 판정 — 커서명 비의존(방어적).
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
    v =>
      (typeof v === 'string' && v.trim() !== '') || (typeof v === 'number' && Number.isFinite(v))
  );
  return parseSaveOutcome(resultValues);
};
