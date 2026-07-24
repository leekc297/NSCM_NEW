// ⭐ DMF0049 — call-proc 직접 호출 헬퍼 (SAVE '^' bulk 단일 + United 액션[DMF0044 SP 공유]).
//   '^' delim 다건 SAVE 는 apiClient.post 직접 — useProcMutation array unfold 회피 표준
//   (memory feedback_save_sp_bulk_payload_apiclient_post). DMF0042 api 골격 1:1.
import { apiClient } from '@foundation/apis';

import { MENU_ID, SHEETS } from '../etc-sales-reports.constants';

// titleSet(SCM_MST_TITLESET_USER) 영구 저장 — SCM0002_SET_TITLESET_POPUP ('C'=Column / 'M'=Measure)
export const saveTitleSet = async (
  columnType: 'C' | 'M',
  saveRows: { name: string; sortOrderNo?: number; subTotalFlag?: string; sortMethodCode?: string }[]
): Promise<boolean> => {
  if (saveRows.length === 0) return false;
  try {
    const payload = {
      programId: MENU_ID,
      sheetName: SHEETS.MAIN, // 'MDF Reports' — SHEET_COLUMNS/MEASURE 등록명 (rename 금지)
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

// call-proc 결과 공통 파싱 — 첫 커서 첫 값 'success'/숫자 = 성공, 문자열 오류문 = passthrough
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
  if (res.status >= 400 || Number((res.data as { code?: string })?.code)) {
    return { ok: false, message: (res.data as { message?: string })?.message?.trim() };
  }
  const firstVal = parseFirstValue(res.data);
  if (firstVal && firstVal.toLowerCase() !== 'success' && String(Number(firstVal)) !== firstVal) {
    return { ok: false, message: firstVal };
  }
  return { ok: true };
};

// 메인 SAVE — 단일 SP `DMF0049_SAVE_SALES_ETC_REPORT_C` ('^' bulk 35키 — sesUserId(36번) BE주입)
export const callSaveEtcReport = (payload: Record<string, string>): Promise<CallProcResult> =>
  callProc(SHEETS.MAIN, 'SAVE', payload);

// United 버전 액션 — SP_W 계열: DMF0044_SAVE_SALES_PLAN_VERSION_COPY (8 IN — createdBy BE주입)
export const callVersionAction = (params: {
  divisionId: string;
  versionNo: string;
  versionDescription: string;
  resultDate: string;
  actionType: string; // 'D' / 'CP' / 'CR'
  mvPlanYyyymm: string;
  updateYn: string;
}): Promise<CallProcResult> => callProc(SHEETS.UNITED_VERSION, 'ACTION', { ...params });

// United 버전 액션 — BP_M 계열 분기: PKG.P_DMF0044_SAVE_BIZ_PLAN_VERSION_COPY (5 IN)
export const callVersionActionBp = (params: {
  divisionId: string;
  versionNo: string;
  versionDescription: string;
  actionType: string;
}): Promise<CallProcResult> => callProc(SHEETS.UNITED_VERSION, 'ACTION_BP', { ...params });

// United Transfer/Cancel — DMF0044_MOBILE_REPORT_CREATE (action 'T'/'C' — GDW 전송)
export const callTransfer = (params: {
  divisionId: string;
  versionNo: string;
  versionType: string;
  actionType: string;
}): Promise<CallProcResult> => callProc(SHEETS.UNITED_VERSION, 'TRANSFER', { ...params });

