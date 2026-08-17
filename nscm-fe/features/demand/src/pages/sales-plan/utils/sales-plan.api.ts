// ⭐ DMF0021 — call-proc 직접 호출 헬퍼 (titleSet 영구 저장 + SAVE '^' bulk 결과 파싱).
//   '^' delim 다건 SAVE 는 apiClient.post 직접 — useProcMutation array unfold 회피 표준
//   (memory feedback_save_sp_bulk_payload_apiclient_post).
import { apiClient } from '@foundation/apis';

import { MENU_ID, SHEETS } from '../sales-plan.constants';

// titleSet(SCM_MST_TITLESET_USER) 영구 저장은 공용 유틸이 담당한다
//   (features/master/src/components — saveTitleSet, POST /admin/menu/{mnuId}/titleset).
//   화면마다 SCM_ADM_MNU_BTN_MPG_M 등록이 필요한 call-proc 경로 대신 공용 엔드포인트를 쓴다.

// SAVE 결과 — AS-IS L2717~2794: 첫 셀 == 'success' 성공 / ≠ 'success' 는 'messageCode^addmessage'
//   (SP 내장 중복검증 등 — [E20250520-000572] 통합 방식. msgCode = MSG ID → 호출측 t() 변환).
export interface SaveSalesPlanResult {
  ok: boolean;
  msgCode?: string;
  addMessage?: string;
}

export const callSaveSalesPlan = async (
  payload: Record<string, string>
): Promise<SaveSalesPlanResult> => {
  const res = await apiClient.post<Record<string, unknown>>(
    `/${MENU_ID}/${SHEETS.MAIN}/SAVE/call-proc`,
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
  if (resultValues.length === 0) return { ok: true };

  const status = String(resultValues[0]).trim();
  if (status === '0' || status.toLowerCase() === 'success') return { ok: true };

  const following = resultValues
    .slice(1)
    .map(value => String(value).trim())
    .filter(Boolean);
  const errorText =
    status === '-1' ? following.join('^') : status.startsWith('-1^') ? status.slice(3) : status;
  const [candidateCode, ...rest] = errorText.split('^');
  const msgCode = candidateCode.trim();
  const isMessageCode = /^MSG\d+$/i.test(msgCode);
  return {
    ok: false,
    msgCode: isMessageCode ? msgCode : undefined,
    addMessage: isMessageCode
      ? rest.join('^').trim() || following.join('^').trim() || undefined
      : [errorText, ...following].filter(Boolean).join('^').trim() || undefined,
  };
};
