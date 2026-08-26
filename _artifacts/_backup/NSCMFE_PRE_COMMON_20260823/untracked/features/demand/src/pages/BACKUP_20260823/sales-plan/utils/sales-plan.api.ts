// ⭐ DMF0021 — call-proc 직접 호출 헬퍼 (titleSet 영구 저장 + SAVE '^' bulk 결과 파싱).
//   '^' delim 다건 SAVE 는 apiClient.post 직접 — useProcMutation array unfold 회피 표준
//   (memory feedback_save_sp_bulk_payload_apiclient_post).
import { apiClient } from '@foundation/apis';

import { MENU_ID, SHEETS } from '../sales-plan.constants';

// titleSet(SCM_MST_TITLESET_USER) 영구 저장은 공용 유틸이 담당한다
//   (features/master/src/components — saveTitleSet, POST /admin/menu/{mnuId}/titleset).
//   화면마다 SCM_ADM_MNU_BTN_MPG_M 등록이 필요한 call-proc 경로 대신 공용 엔드포인트를 쓴다.

// SAVE 결과 — AS-IS L2717~2794: 첫 셀 == 'success'/'0' 성공 / 그 외는 실패.
//   실패 커서에서 '^' 로 구분된 토큰 중 MSG 코드를 뽑아 msgCode 로 올린다(호출측 t() 변환).
//   코드를 못 찾으면 SP 오류문 원문을 addMessage 로 그대로 넘긴다
//   (SP 내장 중복검증 등 — [E20250520-000572] 통합 방식). 상세 규약은 parseSaveOutcome 주석.
export interface SaveSalesPlanResult {
  ok: boolean;
  msgCode?: string;
  addMessage?: string;
}

const MSG_CODE_RE = /^MSG\d+$/i;

/**
 * SP 결과 값 배열 → 저장 판정 (첫 커서 첫 행의 값들, 컬럼 순서 그대로).
 *
 * 실패 시 결과 커서 규약이 CODE / MSG / EVENT 3열로 굳어졌고, 다국어 MSG 코드는
 * MSG 컬럼이 아니라 EVENT 컬럼 안에 'MSG00473^<validation값>' 으로 들어온다
 * (SP: `SELECT '-1' AS CODE, 'ERR_RTN: - Validation Check' AS MSG,
 *       V_S_CODE || '^' || V_S_VALIDATION AS EVENT FROM DUAL`).
 * 그래서 첫 토큰만 코드로 보던 예전 판정은 앞의 고정 문구에 막혀 코드를 놓치고
 * 'ERR_RTN: - Validation Check^-1^MSG00473^' 를 그대로 팝업에 띄웠다.
 *
 * 판정: 전 컬럼을 '^' 로 평탄화한 뒤 첫 MSG 코드 토큰을 찾는다.
 *   - 코드 발견: 그 뒤 토큰들이 추가문구 (앞의 상태/고정 문구 토큰은 사용자에게 의미 없어 버린다).
 *   - 코드 없음: 선행 '-1' 상태 토큰만 제외하고 SP 오류문 원문을 그대로 넘긴다.
 */
export const parseSaveOutcome = (resultValues: unknown[]): SaveSalesPlanResult => {
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

  const rest = tokens[0] === '-1' ? tokens.slice(1) : tokens;
  return { ok: false, msgCode: undefined, addMessage: rest.join('^') || undefined };
};

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
  return parseSaveOutcome(resultValues);
};
