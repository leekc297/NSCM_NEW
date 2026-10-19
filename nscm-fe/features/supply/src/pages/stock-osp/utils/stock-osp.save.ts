// SCP0041 Pack Hold Stock SAVE payload 조립 + 호출 (design 03 §4, AS-IS SaveData cs 1:1).
//   '^' bulk 다건 = apiClient.post 직접(useProcMutation array unfold 회피 표준 — scp-bom/sales-plan 선례).
//   SAVE SP(PKG_SCP0041.P_SCP0041_SAVE_PACKER_HOLD_STOCK)는 IN 10종을 받는다(ALL_ARGUMENTS 실측):
//     pos1~9 CLOB('^' 결합): activeFlag/inspectionId/dir/plantId/prodId/cutoffDate/qty/
//                            dateForecastStart/dateForecastFinish
//     pos10 VARCHAR2       : userId(@LoginUser)
//   HOLD 행만 UPDATE(action='M') — INSERT/DELETE 분기 SP 부재(design 03 §3 R7).
import { apiClient } from '@foundation/apis';

import { MENU_ID, SHEETS } from '../stock-osp.constants';

type Row = Record<string, unknown>;

const s = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

// 날짜 → 'YYYYMMDD' 선두 8자 (design 03 §4 — AS-IS ToString("yyyyMMdd"), SP TO_DATE(SUBSTR(v,1,8))).
//   ISO/구분자 무관하게 숫자만 추출해 앞 8자. 빈 값은 '' 유지.
const toYmd = (v: unknown): string => s(v).replace(/[^0-9]/g, '').slice(0, 8);

export interface SavePackResult {
  ok: boolean;
  count?: number;
  errorMessage?: string;
}

// SAVE SP IN 10종 조립. dirty(편집된 HOLD 행)만 activeFlag='M' 로 전송 — UPDATE 전용.
export const buildSavePayload = (
  dirty: Row[],
  userId: string
): Record<string, string> | null => {
  if (dirty.length === 0) return null;
  const join = (sel: (r: Row) => string): string => dirty.map(sel).join('^');
  return {
    activeFlag: dirty.map(() => 'M').join('^'), // 전건 UPDATE (design 03 §3 R7)
    inspectionId: join(r => s(r.INSPECTION_ID)),
    dir: join(r => s(r.DIR)),
    plantId: join(r => s(r.PLANT_ID)),
    prodId: join(r => s(r.PROD_ID)),
    cutoffDate: join(r => toYmd(r.CUTOFF_DATE)),
    qty: join(r => s(r.QTY)),
    dateForecastStart: join(r => toYmd(r.DATE_FORECAST_START)),
    dateForecastFinish: join(r => toYmd(r.DATE_FORECAST_FINISH)),
    userId, // pos10 단일 VARCHAR2 — @LoginUser
  };
};

// RESULT_CNT 가 비어올 때 저장 건수 폴백 — activeFlag 토큰 수.
const dirtyCountFallback = (payload: Record<string, string>): number =>
  payload.activeFlag ? payload.activeFlag.split('^').length : 0;

// result 객체에서 커서명 대소문자/키 변형에 방어적으로 배열을 찾는다.
const pickCursor = (result: unknown, key: string): Row[] => {
  if (!result || typeof result !== 'object') return [];
  const rec = result as Record<string, unknown>;
  const hit = rec[key] ?? rec[key.toUpperCase()] ?? rec[key.toLowerCase()];
  return Array.isArray(hit) ? (hit as Row[]) : [];
};

// SAVE 호출 + 응답 계약 판정 (design 03 §4):
//   O_RESULT_CURSOR.RESULT_CODE='S' → 성공(RESULT_CNT 건수) / 'F' → o_rc 에러행(ERR_MESSAGE) 표시.
//   status 500/403 은 responseErrorInterceptor 가 resolve → 직접 차단(false success 방지).
export const callSavePack = async (
  payload: Record<string, string>
): Promise<SavePackResult> => {
  const res = await apiClient.post<Record<string, unknown>>(
    `/${MENU_ID}/${SHEETS.PACK}/SAVE/call-proc`,
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

  const errRows = pickCursor(result, 'o_rc');
  const errMsg = errRows
    .map(r => s(r.ERR_MESSAGE).trim())
    .filter(Boolean)
    .join('\n');
  return { ok: false, errorMessage: errMsg || undefined };
};
