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

export const callProc = async (
  sheet: string,
  btnCd: string,
  payload: Record<string, string>
): Promise<CallProcResult> => {
  const res = await apiClient.post<Record<string, unknown>>(
    `/${MENU_ID}/${sheet}/${btnCd}/call-proc`,
    payload
  );
  // status 500/403 은 responseErrorInterceptor 가 resolve → 직접 차단 (false success 방지).
  if (res.status >= 400 || Number((res.data as { code?: string })?.code)) {
    return { ok: false, message: (res.data as { message?: string })?.message?.trim() };
  }
  const firstVal = parseFirstValue(res.data);
  if (firstVal && !isSuccessToken(firstVal) && String(Number(firstVal)) !== firstVal) {
    // 숫자(건수) 반환 SP 는 성공 취급 — 문자열 오류문만 실패 passthrough
    return { ok: false, message: firstVal };
  }
  return { ok: true, count: parseCount(res.data) };
};

// 메인 SAVE — PKG_DMF0042.P_DMF0042_SAVE_DM_PLN_BP_FCST ('^' bulk 19키 + 감사 2 BE주입)
export const callSaveBusinessPlan = (payload: Record<string, string>): Promise<CallProcResult> =>
  callProc(SHEETS.MAIN, 'SAVE', payload);

// Set Price — DMF0042_SAVE_DM_PLN_BP_FCST_PRICE_CONV (s_flag=''/s_division_id — AS-IS L3124~3130)
export const callSetPrice = (divisionId: string): Promise<CallProcResult> =>
  callProc(SHEETS.MAIN, 'SET_PRICE', { flag: '', divisionId });

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
