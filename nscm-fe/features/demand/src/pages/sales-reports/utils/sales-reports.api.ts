// ⭐ DMF0044 — call-proc 직접 호출 헬퍼 (SAVE '^' bulk + United 액션 + Textbox 행별 반복).
//   '^' delim 다건 SAVE 는 apiClient.post 직접 — useProcMutation array unfold 회피 표준
//   (memory feedback_save_sp_bulk_payload_apiclient_post). DMF0042 api 골격 1:1.
import { apiClient } from '@foundation/apis';

import { MENU_ID, SHEETS } from '../sales-reports.constants';

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

// 내부 전용 — 외부 소비자는 아래 call* 래퍼를 쓴다(공용 `versionModal/version-modal.api.ts` 와 동일 규약).
//   export 로 두면 미배선 export 로 잡힌다(반쪽 구현 함정, post-write $0.1-B).
const callProc = async (
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

// 메인 SAVE — Data Type 이원화 (ETC='SAVE' 20키 / Cutoff='SAVE_CF' 22키 — createdBy BE주입)
export const callSaveEtc = (payload: Record<string, string>): Promise<CallProcResult> =>
  callProc(SHEETS.MAIN, 'SAVE', payload);
export const callSaveCutoff = (payload: Record<string, string>): Promise<CallProcResult> =>
  callProc(SHEETS.MAIN, 'SAVE_CF', payload);

// United 버전 액션 3종은 공용 VersionModal(components/versionModal/version-modal.api.ts)로 이동 (2026-07-30)

// Exchange Rate 저장 — PKG.P_DMF0044_SAVE_DM_EXCHANGE_RATE_REPORT ('^' bulk 7키 + 감사 2 BE주입)
export const callSaveExchangeRate = (payload: Record<string, string>): Promise<CallProcResult> =>
  callProc(SHEETS.EXCHANGE_RATE, 'SAVE', payload);

// Textbox 저장 — PKG.P_DMF0044_SAVE_TEXTBOX (16키 = 1행분 — ⭐ 정책③ 교정: 수정 행별 반복 호출.
//   AS-IS 는 루프 변수 덮어쓰기로 마지막 행만 저장되는 구조적 결함 — SP 무수정 교정)
export const callSaveTextboxRow = (payload: Record<string, string>): Promise<CallProcResult> =>
  callProc(SHEETS.TEXTBOX, 'SAVE', payload);
