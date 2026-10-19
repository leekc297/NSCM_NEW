// SCP0110 SAVE — '^' delim 다건 CLOB payload + call-proc 직접 호출.
//   PKG_SCP0110 PROC_M(all_arguments 실측): SAVE_GROUP_MASTER IN = activeFlag/divisionId/operationGroup/
//   groupId/groupName/validYn/(sesUserId)/onlyStock, SAVE_MODEL_LIST IN = activeFlag/divisionId/
//   projectCode/itemId/groupId/(sesUserId). sesUserId 는 BE 자동 주입(감사키 파라미터 없음).
//   '^' bulk 다건은 apiClient.post 직접 — useProcMutation array unfold 회피(business-plan 선례).
import { apiClient } from '@foundation/apis';
import { CRUD_TYPE } from '@foundation/constants';

import { MENU_ID, SHEETS } from '../demand-group-master.constants';
import type { GroupMasterRow, ModelListRow } from '../demand-group-master.types';

export interface SaveResult {
  ok: boolean;
  message?: string;
}

const str = (v: unknown): string => {
  if (v == null) return '';
  if (typeof v === 'string') return v;
  if (typeof v === 'number' || typeof v === 'boolean') return String(v);
  return '';
};

// call-proc 성공 토큰 — 첫 커서 첫 값이 success/ok/숫자면 성공, 그 외 문자열은 SP 오류문 passthrough.
const isSuccessToken = (v: string): boolean => {
  const s = v.trim().toLowerCase();
  return s === 'success' || s === 'ok';
};

const parseFirstValue = (data: unknown): string | undefined => {
  const result = (data as { result?: unknown })?.result;
  const rows =
    result && typeof result === 'object'
      ? (Object.values(result as Record<string, unknown>).find(v => Array.isArray(v)) as
          | unknown[]
          | undefined)
      : undefined;
  const first = rows?.[0];
  if (!first || typeof first !== 'object') return undefined;
  const firstVal = Object.values(first as Record<string, unknown>).find(
    v => typeof v === 'string' && v.trim() !== ''
  );
  return typeof firstVal === 'string' ? firstVal.trim() : undefined;
};

const postSave = async (sheet: SHEETS, payload: Record<string, string>): Promise<SaveResult> => {
  const res = await apiClient.post<Record<string, unknown>>(
    `/${MENU_ID}/${sheet}/SAVE/call-proc`,
    payload
  );
  // status 500/403 은 responseErrorInterceptor 가 resolve → 직접 차단(false success 방지).
  if (res.status >= 400 || Number((res.data as { code?: string })?.code)) {
    return { ok: false, message: (res.data as { message?: string })?.message?.trim() };
  }
  const firstVal = parseFirstValue(res.data);
  if (firstVal && !isSuccessToken(firstVal) && String(Number(firstVal)) !== firstVal) {
    return { ok: false, message: firstVal };
  }
  return { ok: true };
};

// Group Master 저장 payload — action(I/M/D) 행만. validYn: 삭제(D)=N / else Y.
export const buildGroupMasterPayload = (
  rows: GroupMasterRow[]
): Record<string, string> | null => {
  const dirty = rows.filter(r => (r as { CRUD_TYPE?: string }).CRUD_TYPE);
  if (dirty.length === 0) return null;
  const join = (sel: (r: GroupMasterRow) => string): string => dirty.map(sel).join('^');
  return {
    activeFlag: join(r => str((r as { CRUD_TYPE?: string }).CRUD_TYPE)),
    divisionId: join(r => str(r.DIVISION_ID)),
    operationGroup: join(r => str(r.OPERATION_GROUP)),
    groupId: join(r => str(r.GROUP_ID)),
    groupName: join(r => str(r.GROUP_NAME)),
    validYn: join(r => ((r as { CRUD_TYPE?: string }).CRUD_TYPE === CRUD_TYPE.DELETE ? 'N' : 'Y')),
    onlyStock: join(r => str(r.ONLY_STOCK)),
  };
};

// Model List 저장 payload — 수정(M)행만(GROUP_ID 재매핑 전용, 신규/삭제 없음).
export const buildModelListPayload = (rows: ModelListRow[]): Record<string, string> | null => {
  const dirty = rows.filter(r => (r as { CRUD_TYPE?: string }).CRUD_TYPE === CRUD_TYPE.MODIFY);
  if (dirty.length === 0) return null;
  const join = (sel: (r: ModelListRow) => string): string => dirty.map(sel).join('^');
  return {
    activeFlag: join(() => CRUD_TYPE.MODIFY),
    divisionId: join(r => str(r.DIVISION_ID)),
    projectCode: join(r => str(r.PROJECT_CODE)),
    itemId: join(r => str(r.ITEM_ID)),
    groupId: join(r => str(r.GROUP_ID)),
  };
};

export const callSaveGroupMaster = (payload: Record<string, string>): Promise<SaveResult> =>
  postSave(SHEETS.GROUP_NAME, payload);

export const callSaveModelList = (payload: Record<string, string>): Promise<SaveResult> =>
  postSave(SHEETS.MODEL_LIST, payload);
