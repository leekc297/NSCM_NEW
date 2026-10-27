// SCP0053 SAVE payload 조립 + 호출 (design 03 §4.2/§4.3, AS-IS SaveData_Main cs:494~610 1:1).
//   '^' bulk 다건 = apiClient.post 직접(useProcMutation array unfold 회피 표준 — sales-plan 선례).
//   SAVE SP(PKG_SCP0053.P_SCP0053_SAVE_SCP_BOM)는 '^' 로 결합된 문자열 13종을 IN 으로 받아 파싱한다.
//   dirty(CRUD_TYPE) 행만 activeFlag='M' 로 전송 — UPDATE 전용(INSERT/DELETE 분기 SP 부재, R4/R5).
import { apiClient } from '@foundation/apis';

import { MENU_ID, SHEETS } from '../scp-bom.constants';

type Row = Record<string, unknown>;

const s = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

// 날짜 → 'YYYYMMDD' 선두 8자 (design 03 §4.2 — AS-IS ToString("yyyyMMdd"), SP TO_DATE(SUBSTR(v,1,8))).
//   ISO/구분자 무관하게 숫자만 추출해 앞 8자. 빈 값은 '' 유지.
const toYmd = (v: unknown): string => s(v).replace(/[^0-9]/g, '').slice(0, 8);

export interface SaveScpBomResult {
  ok: boolean;
  count?: number;
  errorMessage?: string;
}

// SAVE SP IN 13종(PROC_M COL_NM 실측, sesUserId 는 @LoginUser 자동·debugMode 미전달):
//   activeFlag / divisionId / plantCd / modelId / parentItemId / childItemId / altId /
//   effStartDate / effEndDate / ecoCode / scpYn / siAltPriority / siScpYn.
//   UPDATE SET = scpYn/siAltPriority(ATTRIBUTE11)/siScpYn(ATTRIBUTE12), WHERE = division+parent+child(전 플랜트 반영).
export const buildSavePayload = (dirty: Row[]): Record<string, string> | null => {
  if (dirty.length === 0) return null;
  const join = (sel: (r: Row) => string): string => dirty.map(sel).join('^');
  return {
    activeFlag: dirty.map(() => 'M').join('^'), // CRUD_TYPE dirty → 'M' (design 03 §4.2)
    divisionId: join(r => s(r.DIVISION_ID)),
    plantCd: join(r => s(r.PLANT_ID)),
    modelId: join(r => s(r.MODEL_ID)),
    parentItemId: join(r => s(r.PARENT_ITEM_ID)),
    childItemId: join(r => s(r.CHILD_ITEM_ID)),
    altId: join(r => s(r.ALT_ID)),
    effStartDate: join(r => toYmd(r.EFF_START_DATE)),
    effEndDate: join(r => toYmd(r.EFF_END_DATE)),
    ecoCode: join(r => s(r.ECO_CODE)),
    scpYn: join(r => s(r.SCP_PLAN_YN)),
    siAltPriority: join(r => s(r.SI_ALT_PRIORITY)),
    siScpYn: join(r => s(r.SI_SCP_YN)),
  };
};

// RESULT_CNT 가 비어올 때 저장 건수 폴백 — activeFlag 토큰 수.
const dirtyCountFallback = (payload: Record<string, string>): number =>
  payload.activeFlag ? payload.activeFlag.split('^').length : 0;

// result 객체에서 커서명 대소문자/키 변형에 방어적으로 배열을 찾는다.
const pickCursor = (result: unknown, key: string): Row[] => {
  if (!result || typeof result !== 'object') return [];
  const rec = result as Record<string, unknown>;
  const hit =
    rec[key] ?? rec[key.toUpperCase()] ?? rec[key.toLowerCase()];
  return Array.isArray(hit) ? (hit as Row[]) : [];
};

// SAVE 호출 + 응답 계약 판정 (design 03 §4.3):
//   O_RESULT_CURSOR.RESULT_CODE='S' → 성공(RESULT_CNT 건수) / 'F' → o_rc 에러행(ERR_MESSAGE) 표시.
//   status 500/403 은 responseErrorInterceptor 가 resolve → 직접 차단(false success 방지).
export const callSaveScpBom = async (
  payload: Record<string, string>
): Promise<SaveScpBomResult> => {
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

  // 실패 — o_rc 에러행의 ERR_MESSAGE 조합(AS-IS 는 미표시였으나 TO-BE 는 표준 노출, design 03 §3.1 V7).
  const errRows = pickCursor(result, 'o_rc');
  const errMsg = errRows
    .map(r => s(r.ERR_MESSAGE).trim())
    .filter(Boolean)
    .join('\n');
  return { ok: false, errorMessage: errMsg || undefined };
};
