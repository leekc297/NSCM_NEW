// SCP0097 SAVE payload 조립 + 호출 (design 03 §4.3, AS-IS SaveData_Main cs:371~426 1:1).
//   '^' bulk 다건 = apiClient.post 직접(useProcMutation array unfold 회피 표준 — sales-plan 선례).
//   SAVE SP(PKG_SCP0097.P_SCP0097_SAVE_SCP_BOM_ELEC)는 '^' 로 결합된 CLOB 6종 + userId + debugMode 를 IN 으로 받는다.
//   dirty(CRUD_TYPE) 행만 activeFlag='M' 로 전송 — UPDATE 전용(INSERT/DELETE 분기 SP 부재, R4).
import { apiClient } from '@foundation/apis';

import { MENU_ID, RESPONSE_KEY, SHEETS } from '../scp-bom-elec.constants';

type Row = Record<string, unknown>;

const s = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

export interface SaveScpBomElecResult {
  ok: boolean;
  count?: number;
  errorMessage?: string;
}

// SAVE SP IN 8 (all_arguments 실측 — CLOB 6 + VARCHAR2 2):
//   activeFlag(CRUD 마커 join·SP 미파싱) / divisionId / parentItemId / childItemId / scpYn / stockYn(컬럼 STOCK_SUM)
//   + userId(세션 — 빈문자열 금지) + debugMode('F' 고정).
//   서버 UPDATE SET = SCP_YN/STOCK_SUM/감사2, WHERE = division+parent+child(3키 UPPER 정규화, design 03 §4.3).
//   SCM_ADM_PROC_M 등록 완료(05_register.sql (h), 15행 실측) — 아래 키 = PROC_M COL_NM 과 1:1 일치.
export const buildSavePayload = (dirty: Row[], userId: string): Record<string, string> | null => {
  if (dirty.length === 0) return null;
  const join = (sel: (r: Row) => string): string => dirty.map(sel).join('^');
  return {
    activeFlag: dirty.map(() => 'M').join('^'), // CRUD_TYPE dirty → 'M' (design 03 §4.3)
    divisionId: join(r => s(r.DIVISION_ID)),
    parentItemId: join(r => s(r.PARENT_ITEM_ID)),
    childItemId: join(r => s(r.CHILD_ITEM_ID)),
    scpYn: join(r => s(r.SCP_YN)),
    stockYn: join(r => s(r.STOCK_SUM)), // 파라미터 P_STOCK_YN ↔ 컬럼 STOCK_SUM (design 03 §1 주의)
    userId, // 세션 사용자 (빈문자열 금지 — convert-core §2.5 감사키 규약)
    debugMode: 'F',
  };
};

// RESULT_CNT 가 비어올 때 저장 건수 폴백 — activeFlag 토큰 수.
const dirtyCountFallback = (payload: Record<string, string>): number =>
  payload.activeFlag ? payload.activeFlag.split('^').length : 0;

// result 객체에서 커서명 대소문자/키 변형에 방어적으로 배열을 찾는다(PROC_M 미등록 대비).
const pickCursor = (result: unknown, key: string): Row[] => {
  if (!result || typeof result !== 'object') return [];
  const rec = result as Record<string, unknown>;
  const hit = rec[key] ?? rec[key.toUpperCase()] ?? rec[key.toLowerCase()];
  return Array.isArray(hit) ? (hit as Row[]) : [];
};

// SAVE 호출 + 응답 계약 판정 (design 03 §3.3/§4.3):
//   O_RESULT_CURSOR.RESULT_CODE='S' → 성공(RESULT_CNT 건수) / 'F' → ERR_MESSAGE 실표시(AS-IS dead code 재현 금지).
//   status 500/403 은 responseErrorInterceptor 가 resolve → 직접 차단(false success 방지, hook #132).
export const callSaveScpBomElec = async (
  payload: Record<string, string>
): Promise<SaveScpBomElecResult> => {
  const res = await apiClient.post<Record<string, unknown>>(
    `/${MENU_ID}/${SHEETS.MAIN}/SAVE/call-proc`,
    payload
  );
  if (res.status >= 400 || Number((res.data as { code?: string })?.code)) {
    return { ok: false, errorMessage: (res.data as { message?: string })?.message?.trim() };
  }
  const result = (res.data as { result?: unknown })?.result;
  const resultCursor = pickCursor(result, 'O_RESULT_CURSOR');
  const first = resultCursor[0] ?? {};
  const code = s(first.RESULT_CODE).trim().toUpperCase();

  if (code === 'S') {
    const cnt = Number(s(first.RESULT_CNT));
    return { ok: true, count: Number.isFinite(cnt) ? cnt : dirtyCountFallback(payload) };
  }

  // 실패 — O_RESULT_CURSOR.ERR_MESSAGE 실표시(design 03 §3.3 V3). 데이터 커서에도 있으면 병합.
  const errFromResult = s(first.ERR_MESSAGE).trim();
  const errRows = pickCursor(result, RESPONSE_KEY);
  const errFromRows = errRows
    .map(r => s(r.ERR_MESSAGE).trim())
    .filter(Boolean)
    .join('\n');
  return { ok: false, errorMessage: errFromResult || errFromRows || undefined };
};
