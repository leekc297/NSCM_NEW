// SDM 공통 — call-proc 결과커서 판정 (project-list.api / project-master.api 사본 통합.
//   화면군 밖 공용(@foundation) 승격은 보류 — SDM 내부 전용).
//   성공 = 결과커서 CODE **이름 기반** '0' + EVENT 처리건수 (위치기반 추출 금지 —
//   memory feedback_callproc_result_cursor_code_check). EVENT 0 = 성공 토스트 금지 축
//   (허위성공 방지 계보). 실패(예외)는 RAISE_APPLICATION_ERROR → HTTP 오류 경로로 수신.

export interface CallProcResult {
  ok: boolean;
  /** SP 결과커서 CODE 원문 — '0'=성공 (그 외 '1'/'-1' 등 = 가드 실패) */
  code?: string;
  /** SP 결과커서 MSG ('SUCCESS') 또는 BE 오류 메시지 */
  message?: string;
  /** SP 결과커서 EVENT — 처리건수 (GET 계열 NULL → 0) */
  event: number;
  /** SP 실패 시 EVENT 에 담긴 다국어 메시지 코드 (예: 'MSG00060' 또는 'MSG00060^상세') */
  messageId?: string;
}

// 커서 셀 값 문자열 정규화 — string 외 스칼라(number/boolean/bigint)만 문자열화, 그 외 ''.
//   FPCheckBox 등이 boolean 을 실어줄 수 있어 boolean 을 버리면 안 된다
export const toText = (value: unknown): string => {
  if (typeof value === 'string') return value;
  if (typeof value === 'number' || typeof value === 'boolean' || typeof value === 'bigint') {
    return String(value);
  }
  return '';
};

// 결과커서 rows 추출 — result 가 배열(단일 커서) 또는 {커서명: rows[]} 객체 양쪽 대응
const extractRows = (data: unknown): Record<string, unknown>[] | undefined => {
  const result = (data as { result?: unknown })?.result;
  if (Array.isArray(result)) return result as Record<string, unknown>[];
  if (result && typeof result === 'object') {
    const arr = Object.values(result as Record<string, unknown>).find(v => Array.isArray(v));
    return arr as Record<string, unknown>[] | undefined;
  }
  return undefined;
};

// apiClient.post 응답 → CallProcResult.
//   status 500/403 은 responseErrorInterceptor 가 resolve → 여기서 직접 차단 (false success 방지 — gate §1-3)
export const parseCallProcResult = (status: number, data: unknown): CallProcResult => {
  if (status >= 400 || Number((data as { code?: string })?.code)) {
    return {
      ok: false,
      event: 0,
      message: (data as { message?: string })?.message?.trim(),
    };
  }
  const first = extractRows(data)?.[0];
  if (!first || !('CODE' in first)) {
    // CODE 커서 미반환 응답 — 전 SP O_RESULT_CURSOR 필수 계약에서 비정상 → 실패 취급
    return { ok: false, event: 0, message: undefined };
  }
  const code = toText(first.CODE).trim();
  const msg = typeof first.MSG === 'string' ? first.MSG.trim() : undefined;
  const rawEvent = toText(first.EVENT).trim();
  const event = Number(rawEvent || '0');
  const messageId = rawEvent
    .split('^')
    .map(value => value.trim())
    .find(value => /^MSG\d+$/i.test(value));
  return {
    ok: code === '0',
    code,
    message: msg,
    event: Number.isFinite(event) ? event : 0,
    messageId: messageId?.toUpperCase(),
  };
};

// 행별 단건 순차 실행 — 실패 시 중단 + EVENT 합산.
//   중도 실패: BTN·SAVE SP 는 내부 COMMIT — 앞선 행은 이미 확정이므로 호출부는 오류 안내 후
//   재조회로 원장 상태와 정합시킨다 (totalEvent > 0 이면 재조회)
export const runPerRowProc = async (
  calls: Array<() => Promise<CallProcResult>>
): Promise<{ ok: boolean; totalEvent: number; message?: string }> => {
  let totalEvent = 0;
  for (const call of calls) {
    const res = await call();
    if (!res.ok) return { ok: false, totalEvent, message: res.message };
    totalEvent += res.event;
  }
  return { ok: true, totalEvent };
};
