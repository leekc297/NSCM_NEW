// ⭐ DMF0042 — call-proc 직접 호출 헬퍼 (titleSet 영구 저장 + SAVE '^' bulk + 커스텀 버튼 SP 결과 파싱).
//   '^' delim 다건 SAVE 는 apiClient.post 직접 — useProcMutation array unfold 회피 표준
//   (memory feedback_save_sp_bulk_payload_apiclient_post).
import { apiClient } from '@foundation/apis';

import { MENU_ID, SHEETS } from '../business-plan.constants';

// titleSet(SCM_MST_TITLESET_USER) 영구 저장 — SCM0002_SET_TITLESET_POPUP ('C'=Column / 'M'=Measure).
//   AS-IS DM0002_TitleSetForm_Popup OK 1:1 (btnColumn L2807 / btnMeasure L2819 — DMF0021 선례).
export const saveTitleSet = async (
  columnType: 'C' | 'M',
  saveRows: { name: string; sortOrderNo?: number; subTotalFlag?: string; sortMethodCode?: string }[]
): Promise<boolean> => {
  if (saveRows.length === 0) return false;
  try {
    const payload = {
      programId: MENU_ID,
      sheetName: SHEETS.MAIN, // 'Biz Plan' — SP 리터럴 6곳·SHEET_COLUMNS/MEASURE 일치 (P3 rename 근거)
      columnType,
      activeFlag: saveRows.map(() => 'Y').join('^'),
      columnName: saveRows.map(r => r.name).join('^'),
      sortOrderNo: saveRows.map((r, i) => String(r.sortOrderNo ?? i + 1)).join('^'),
      subTotalFlag: saveRows.map(r => r.subTotalFlag ?? 'N').join('^'),
      sortMethodCode: saveRows.map(r => r.sortMethodCode ?? 'ASC').join('^'),
    };
    const res = await apiClient.post<{ CODE?: string }[]>(
      `/${MENU_ID}/${SHEETS.TITLE_SET}/SAVE/call-proc`,
      payload
    );
    if (res.status >= 400 || Number((res.data as { code?: string })?.code)) return false;
    const row = (res.data.result ?? [])[0];
    return !row || row.CODE === undefined || String(row.CODE) === '0';
  } catch {
    return false;
  }
};

// call-proc 결과 공통 파싱 — 첫 커서 첫 행 첫 값 == 'success' 성공 / ≠ 'success' 는 SP 오류문 passthrough
//   (AS-IS SaveData L1136~1138 sRet 판정 1:1 — DMF0042 SP 계열 공통 규약).
export interface CallProcResult {
  ok: boolean;
  message?: string;
}

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
  if (firstVal && firstVal.toLowerCase() !== 'success' && String(Number(firstVal)) !== firstVal) {
    // 숫자(건수) 반환 SP 는 성공 취급 — 문자열 오류문만 실패 passthrough
    return { ok: false, message: firstVal };
  }
  // 성공 시 첫 값(건수/success)을 함께 반환 — Cutoff 결과 연결(MSG00675)·Replace 건수(MSG00401) 표시용
  return { ok: true, message: firstVal };
};

// 메인 SAVE — PKG_DMF0042.P_DMF0042_SAVE_DM_PLN_BP_FCST ('^' bulk 19키 + 감사 2 BE주입)
export const callSaveBusinessPlan = (payload: Record<string, string>): Promise<CallProcResult> =>
  callProc(SHEETS.MAIN, 'SAVE', payload);

// Set Price — DMF0042_SAVE_DM_PLN_BP_FCST_PRICE_CONV (s_flag=''/s_division_id — AS-IS L3124~3130)
export const callSetPrice = (divisionId: string): Promise<CallProcResult> =>
  callProc(SHEETS.MAIN, 'SET_PRICE', { flag: '', divisionId });

// Ver. Cutoff — DMF0042_SAVE_DM_PLN_BP_FCST_CUTOFF (verType='BP_M' — AS-IS L2857).
//   ⚠ createdBy 는 FE 필수 전달 — BE 자동 주입은 sesUserId 키뿐. 미전달 시 NULL 바인딩 →
//   PR_DM_PLN_VERSION_CREATE 채번 실패(CREATED_BY NOT NULL) → VERSION_NO NULL ORA-01400 (2026-08-05 실측).
export const callCutoff = (
  divisionId: string,
  versionDescription: string,
  verType: string,
  createdBy: string
): Promise<CallProcResult> =>
  callProc(SHEETS.MAIN, 'CUTOFF', { divisionId, versionDescription, verType, createdBy });

// Replace by Cutoff — DMF0042_SAVE_DM_PLN_BP_REPLACE_BY_CUTOFF (AS-IS L3465. createdBy FE 필수 전달 — 위 동일)
export const callReplaceByCutoff = (params: {
  divisionId: string;
  versionType: string;
  yyyymmFrom: string;
  yyyymmTo: string;
  versionNo: string;
  createdBy: string;
}): Promise<CallProcResult> => callProc(SHEETS.MAIN, 'REPLACE', { ...params });

// Exchange Rate 저장 — DMF0042_SAVE_DM_BP_EXCHANGE_RATE ('^' bulk 6키 + 감사 2 BE주입)
export const callSaveExchangeRate = (payload: Record<string, string>): Promise<CallProcResult> =>
  callProc(SHEETS.EXCHANGE_RATE, 'SAVE', payload);
