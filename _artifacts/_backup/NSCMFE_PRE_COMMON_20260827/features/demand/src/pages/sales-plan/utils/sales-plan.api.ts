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
// 코드가 문구와 한 토큰에 붙어 오는 경우를 위한 패턴 — SP 마다 구분자가 '^' 가 아니라 공백인
//   경우가 있다 (실측: 'MSG00462 Project Code____ : ...' 한 덩어리). 위 정확일치만 보면 코드를
//   놓쳐 t() 를 못 타고 코드가 그대로 팝업에 노출된다.
const MSG_CODE_IN_TOKEN_RE = /\bMSG\d+\b/i;

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
 *   - 코드 토큰 발견: 그 뒤 토큰들이 추가문구 (앞의 상태/고정 문구 토큰은 사용자에게 의미 없어 버린다).
 *   - 코드가 문구에 붙어 있는 경우: 코드만 떼어내고 같은 토큰의 나머지를 추가문구 앞에 잇는다.
 *     구분자를 '^' 가 아니라 공백으로 쓰는 SP 가 있어서다 (실측 MSG00462 —
 *     'MSG00462 Project Code____ : ...' 가 한 덩어리로 온다). 이 분기가 없으면 코드가 t() 를
 *     못 타고 'MSG00462' 가 그대로 팝업 첫 줄에 노출된다.
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

/**
 * 줄바꿈 표기를 실제 줄바꿈 문자로 통일한다.
 *
 * MSG_M 다국어 본문에는 줄바꿈이 제어문자가 아니라 역슬래시 두 글자('\' + 'n') 그대로 저장돼
 * 있다 (실측 MSG00462: '동일 주차에 Price 정보가 아직 등록되지 않았습니다.\r\n'). 그대로 두면
 * 팝업에 역슬래시가 글자로 노출된다. SP 상세문구는 반대로 진짜 CRLF 를 쓰기도 해서 둘 다 받는다.
 */
const normalizeNewlines = (text: string): string =>
  text.replace(/\\r\\n|\\n|\\r/g, '\n').replace(/\r\n?/g, '\n');

/**
 * 저장 실패 팝업 문구 조립 — AS-IS SaveData L2776~2788 [E20250520-000572] 1:1.
 *
 * AS-IS 는 `GMessageBox(messageCode, new object[]{ addmessage })` 로 MSG_M 본문의 `{0}` 자리에
 * '^' 뒤 토큰을 **치환**한다. 줄바꿈으로 덧붙이면 본문의 `{0}` 이 그대로 화면에 노출된다.
 *
 * 규칙 세 가지:
 *   1. MSG_M 미등록 — t() 는 못 찾으면 키를 그대로 돌려준다. 'MSG00462' 같은 코드만 덩그러니
 *      띄우면 사용자가 읽을 수 없으므로 SP 가 실어 보낸 상세문구만 보여준다
 *      (상세도 없으면 코드라도 남긴다 — 지원 문의용). 근본 해결은 MSG_M 등록이다.
 *   2. 본문에 `{0}` 이 있으면 상세문구로 치환 (AS-IS 파라미터 전달과 동일).
 *   3. `{0}` 이 없으면 상세문구를 버리지 않고 줄바꿈으로 잇는다 — SP 가 실어 보낸 원인 정보를
 *      잃지 않기 위함 (AS-IS 는 남는 파라미터를 조용히 무시한다).
 *
 * 상세문구 안의 '^' 는 SP 가 항목을 잇는 구분자다. 그대로 두면 한 줄로 붙어 읽을 수 없어
 * 줄 단위로 편다. 팝업 본문은 `white-space: pre-line` 이라 줄바꿈이 그대로 그려진다.
 *
 * @param template   MSG_M 다국어 변환을 마친 본문 (t(msgCode) 결과)
 * @param addMessage '^' 뒤 추가 문구 (parseSaveOutcome 이 뽑아낸 값)
 * @param msgCode    원본 MSG 코드 — template 과 같으면 MSG_M 미등록으로 판정
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
