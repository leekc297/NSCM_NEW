// ⭐ DMF0042 — call-proc 직접 호출 헬퍼 (titleSet 영구 저장 + SAVE '^' bulk + 커스텀 버튼 SP 결과 파싱).
//   '^' delim 다건 SAVE 는 apiClient.post 직접 — useProcMutation array unfold 회피 표준
//   (memory feedback_save_sp_bulk_payload_apiclient_post).
import { apiClient } from '@foundation/apis';

import { MENU_ID, SHEETS } from '../business-plan.constants';

// titleSet(SCM_MST_TITLESET_USER) 영구 저장은 공용 유틸이 담당한다
//   (features/master/src/components — saveTitleSet, POST /admin/menu/{mnuId}/titleset).
//   화면마다 SCM_ADM_MNU_BTN_MPG_M 등록이 필요한 call-proc 경로 대신 공용 엔드포인트를 쓴다.

// call-proc 결과 공통 파싱 — 첫 커서 첫 행 첫 값 == 'success' 성공 / ≠ 'success' 는 SP 오류문 passthrough
//   (AS-IS SaveData L1136~1138 sRet 판정 1:1 — DMF0042 SP 계열 공통 규약).
export interface CallProcResult {
  ok: boolean;
  message?: string;
  // SP 가 처리 건수를 돌려준 경우(커서의 CNT). 완료 안내에 "{0}건" 으로 쓴다.
  count?: number;
}

/**
 * ⭐ SP 성공 토큰 (2026-08-07 교정).
 *   구현은 'success' 하나만 성공으로 봤는데, DMF0042 계열 SP 는 **'OK'** 를 돌려준다
 *   (Replace 실측: `o_result_cursor:[{RESULT:'OK'}] / data:[{CNT:79030, RESULT:'OK'}]`).
 *   그래서 79,030 건이 정상 처리됐는데도 FE 가 실패로 분류해 알럿에 "OK" 를 오류문으로 띄웠다.
 *   ⚠ 이 함수는 Save/SetPrice/Cutoff/Replace 가 공유하는 판정이라, 성공 토큰을 빠뜨리면
 *     "성공했는데 오류처럼 보이는" 사고가 화면 전체에서 재발한다.
 */
const isSuccessToken = (v: string): boolean => {
  const s = v.trim().toLowerCase();
  return s === 'success' || s === 'ok';
};

/** 커서에서 처리 건수(CNT) 추출 — 없으면 undefined. */
const parseCount = (data: unknown): number | undefined => {
  const result = (data as { result?: Record<string, unknown> })?.result;
  if (!result || typeof result !== 'object') return undefined;
  for (const v of Object.values(result)) {
    if (!Array.isArray(v)) continue;
    const first = v[0] as Record<string, unknown> | undefined;
    const cnt = first?.CNT;
    if (typeof cnt === 'number') return cnt;
    if (typeof cnt === 'string' && cnt.trim() !== '' && !Number.isNaN(Number(cnt))) {
      return Number(cnt);
    }
  }
  return undefined;
};

const parseFirstValue = (data: unknown): string | undefined => {
  const result = (data as { result?: unknown })?.result;
  const rows = Array.isArray(result)
    ? (result as unknown[])
    : result && typeof result === 'object'
      ? (Object.values(result as Record<string, unknown>).find(v => Array.isArray(v)) as
          | unknown[]
          | undefined)
      : undefined;
  const first = rows?.[0];
  if (!first || typeof first !== 'object') return undefined;
  const firstVal = Object.values(first as Record<string, unknown>).find(
    v => typeof v === 'string' && String(v).trim() !== ''
  );
  return typeof firstVal === 'string' ? firstVal.trim() : undefined;
};

/** call-proc POST 공통 — HTTP/BE code 차단까지만 하고 커서 해석은 호출자에 맡긴다. */
const postProc = async (
  sheet: string,
  btnCd: string,
  payload: Record<string, string>
): Promise<{ failed: true; message?: string } | { failed: false; data: unknown }> => {
  const res = await apiClient.post<Record<string, unknown>>(
    `/${MENU_ID}/${sheet}/${btnCd}/call-proc`,
    payload
  );
  // status 500/403 은 responseErrorInterceptor 가 resolve → 직접 차단 (false success 방지).
  if (res.status >= 400 || Number((res.data as { code?: string })?.code)) {
    return { failed: true, message: (res.data as { message?: string })?.message?.trim() };
  }
  return { failed: false, data: res.data };
};

export const callProc = async (
  sheet: string,
  btnCd: string,
  payload: Record<string, string>
): Promise<CallProcResult> => {
  const res = await postProc(sheet, btnCd, payload);
  if (res.failed) return { ok: false, message: res.message };
  const firstVal = parseFirstValue(res.data);
  if (firstVal && !isSuccessToken(firstVal) && String(Number(firstVal)) !== firstVal) {
    // 숫자(건수) 반환 SP 는 성공 취급 — 문자열 오류문만 실패 passthrough
    return { ok: false, message: firstVal };
  }
  return { ok: true, count: parseCount(res.data) };
};

// 메인 SAVE — PKG_DMF0042.P_DMF0042_SAVE_DM_PLN_BP_FCST (SP 21 IN — '^' bulk 19키 + 감사 2키.
//   감사 2키도 FE 가 세션 userId 로 싣는다 — BE 자동 주입은 sesUserId/sesLangCd 뿐이다.)
export const callSaveBusinessPlan = (payload: Record<string, string>): Promise<CallProcResult> =>
  callProc(SHEETS.MAIN, 'SAVE', payload);

// ── Set Price — P_DMF0042_SAVE_DM_PLN_BP_FCST_PRICE_CONV ───────────────────────────────────────
//   2026-08-24 SP 개편: OUT 이 SYS_REFCURSOR 3종이 됐다.
//     o_rc1           수행 성공 메시지. NVL(s_flag,'X') <> 'CALL' AND v_log_message IS NULL 일 때만
//                     OPEN — 조건 미충족이면 커서 자체를 안 열어 응답 키가 null/부재다.
//     o_rc2           '[' || sqlcode || ']' || v_log_message. 항상 OPEN 되고 정상일 때 '[]' 다.
//     o_result_cursor CODE('0'=성공) / MSG / EVENT(=N_LOG_COUNT 처리건수).
//   금지: 공용 callProc 사용. 그 판정은 'result 안 아무 배열 중 첫 번째'를 집는 구조라
//     (parseFirstValue) 커서가 3개가 되면 o_rc1 의 성공 문구를 오류문으로 오인해 알럿에 띄우고
//     ok=false 로 재조회까지 막는다. BE 는 결과를 HashMap 으로 직렬화해 키 순서 보장도 없다.
//   주의: o_rc1·o_rc2 는 SELECT 에 alias 가 없어 컬럼명이 표현식 원문이다 — 이름으로 읽지 말고
//     첫 컬럼 값으로 읽는다. (BE 에 alias 추가를 요청하면 이 방어는 남겨둔 채 단순해진다.)

/** 커서 이름으로 행 배열을 찾는다 — SCM_ADM_PROC_M 의 COL_NM 대소문자가 화면마다 갈려 무시하고 비교. */
const cursorRows = (
  result: Record<string, unknown> | undefined,
  name: string
): Record<string, unknown>[] => {
  if (!result) return [];
  const key = Object.keys(result).find(k => k.toLowerCase() === name.toLowerCase());
  const rows = key ? result[key] : undefined;
  return Array.isArray(rows) ? (rows as Record<string, unknown>[]) : [];
};

/** 커서 셀 → 문자열. 스칼라만 취한다 (객체가 오면 '[object Object]' 를 메시지로 띄우게 되므로 버린다). */
const toText = (v: unknown): string | undefined => {
  if (typeof v === 'string') return v.trim() || undefined;
  if (typeof v === 'number' || typeof v === 'boolean') return String(v);
  return undefined;
};

/** alias 없는 커서의 첫 행 첫 값 — 컬럼명에 의존하지 않는다. */
const firstCell = (rows: Record<string, unknown>[]): string | undefined =>
  Object.values(rows[0] ?? {})
    .map(toText)
    .find(v => v !== undefined);

/** 이름 있는 커서의 컬럼 — CustomMap 이 HashMap 이라 키 순서가 없으므로 반드시 이름으로 읽는다. */
const cell = (rows: Record<string, unknown>[], col: string): string | undefined => {
  const row = rows[0];
  if (!row) return undefined;
  const key = Object.keys(row).find(k => k.toLowerCase() === col.toLowerCase());
  return key ? toText(row[key]) : undefined;
};

/**
 * o_rc2 로그 파싱 — '[' || sqlcode || ']' || message.
 * 정상은 sqlcode·message 가 모두 NULL 이라 '[]' 한 건이 온다. sqlcode 만 있고 메시지가 비어도
 * 0 이 아니면 오류로 본다 (SP 가 메시지를 못 채운 경우까지 성공으로 넘기지 않는다).
 */
const isLogError = (raw?: string): boolean => {
  if (!raw) return false;
  const m = /^\[([^\]]*)\]([\s\S]*)$/.exec(raw.trim());
  if (!m) return raw.trim() !== '';
  const sqlCode = m[1].trim();
  const message = m[2].trim();
  if (message !== '') return true;
  return sqlCode !== '' && sqlCode !== '0';
};

/** SET_PRICE 커서 3종 해석 — 테스트 대상(순수 함수). */
export const parseSetPriceResult = (
  result: Record<string, unknown> | undefined
): CallProcResult => {
  const log = firstCell(cursorRows(result, 'o_rc2'));
  if (isLogError(log)) return { ok: false, message: log };

  const resultRows = cursorRows(result, 'o_result_cursor');
  const code = cell(resultRows, 'CODE');
  if (code != null && code !== '' && code !== '0') {
    return { ok: false, message: cell(resultRows, 'MSG') ?? code };
  }

  // o_rc1 미오픈(s_flag='CALL' 등) = 메시지 없음. 부르는 쪽이 토스트로 대체한다.
  const okMessage = firstCell(cursorRows(result, 'o_rc1'));
  const eventRaw = cell(resultRows, 'EVENT');
  const count = eventRaw == null || eventRaw === '' ? NaN : Number(eventRaw);
  return {
    ok: true,
    ...(okMessage ? { message: okMessage } : {}),
    ...(Number.isFinite(count) ? { count } : {}),
  };
};

export const callSetPrice = async (divisionId: string): Promise<CallProcResult> => {
  try {
    const res = await postProc(SHEETS.MAIN, 'SET_PRICE', { flag: '', divisionId });
    if (res.failed) return { ok: false, message: res.message };
    return parseSetPriceResult((res.data as { result?: Record<string, unknown> })?.result);
  } catch (e) {
    // 필수: 공용 responseInterceptor 가 result.O_RESULT_CURSOR[0].CODE 를 보고 0 이 아니면 throw 한다.
    //   이 SP 는 이제 CODE 커서를 항상 돌려주므로 오류 분기가 여기로 온다. 잡지 않으면 호출부에
    //   try/catch 가 없어 알럿도 재조회도 없이 "버튼이 안 먹는" 무반응이 된다.
    return { ok: false, message: e instanceof Error ? e.message : undefined };
  }
};

// Ver. Cutoff — DMF0042_SAVE_DM_PLN_BP_FCST_CUTOFF (verType='BP_M' — AS-IS L2857. createdBy BE주입)
export const callCutoff = (
  divisionId: string,
  versionDescription: string,
  verType: string,
  auditUserId: string
): Promise<CallProcResult> =>
  callProc(SHEETS.MAIN, 'CUTOFF', {
    divisionId,
    versionDescription,
    verType,
    createdBy: auditUserId,
    lastUpdatedBy: auditUserId,
  });
// Replace by Cutoff — DMF0042_SAVE_DM_PLN_BP_REPLACE_BY_CUTOFF (AS-IS L3465. createdBy BE주입)
export const callReplaceByCutoff = (params: {
  divisionId: string;
  versionType: string;
  yyyymmFrom: string;
  yyyymmTo: string;
  versionNo: string;
  auditUserId: string;
}): Promise<CallProcResult> => {
  const { auditUserId, ...rest } = params;
  return callProc(SHEETS.MAIN, 'REPLACE', {
    ...rest,
    createdBy: auditUserId,
    lastUpdatedBy: auditUserId,
  });
};
// Exchange Rate 저장 — DMF0042_SAVE_DM_BP_EXCHANGE_RATE ('^' bulk 6키 + 감사 2키 FE 세션 전송.
//   BE(BaseService.makeProcedure)는 감사키를 주입하지 않는다 — 누락 시 CREATED_BY ORA-01400)
export const callSaveExchangeRate = (payload: Record<string, string>): Promise<CallProcResult> =>
  callProc(SHEETS.EXCHANGE_RATE, 'SAVE', payload);
