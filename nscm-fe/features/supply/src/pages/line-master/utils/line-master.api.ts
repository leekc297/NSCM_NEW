// Packer(OSP) 저장 — PKG_SCP0002.P_SCP0002_SAVE_LINE_MASTER_OSP (CLOB 9키 '^' bulk).
//   useProcMutation(행 배열 그대로 전송)으로는 저장되지 않는다 — BE makeProcedure 가 PROC_M 의
//   CLOB 파라미터를 이름(activeFlag/divisionId/...)으로 찾는데 {data:[rows]} 엔 그 키가 없어
//   전 CLOB 이 NULL → proc loop 0회 → 0건 저장(에러 없이 END). 그래서 컬럼별 '^' 폴딩 객체를
//   call-proc 에 직접 POST 한다(memory save-proc-per-column-caret-fold / useProcMutation array unfold 회피).
import { apiClient } from '@foundation/apis';

import { MENU_ID, SHEETS } from '../line-master.constants';

type Row = Record<string, unknown>;

const s = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' || typeof v === 'boolean' ? String(v) : '';

export interface SavePackerResult {
  ok: boolean;
  message?: string;
}

// activeFlag=CRUD_TYPE(I/M) · operationId 는 RACK_YN 파생(_R1) 반영분 · createdBy=세션 사번(행 수만큼).
//   RACK_YN 은 OSP 테이블 컬럼이 아니라 OPERATION_ID 접미사로 저장되므로 payload 키에 없다(SP 인자와 일치).
export const savePackerOsp = async (rows: Row[], createdBy: string): Promise<SavePackerResult> => {
  const join = (sel: (r: Row) => string): string => rows.map(sel).join('^');
  const payload: Record<string, string> = {
    activeFlag: join(r => s(r.CRUD_TYPE)),
    divisionId: join(r => s(r.DIVISION_ID)),
    scmSiteId: join(r => s(r.SCM_SITE_ID)),
    lineId: join(r => s(r.LINE_ID)),
    lineName: join(r => s(r.LINE_NAME)),
    operationId: join(r => s(r.OPERATION_ID)),
    scsProdAmend: join(r => s(r.SCS_PROD_AMEND)),
    validYn: join(r => s(r.VALID_YN)),
    createdBy: rows.map(() => createdBy).join('^'),
  };
  const res = await apiClient.post<Record<string, unknown>>(
    `/${MENU_ID}/${SHEETS.PACKER}/SAVE/call-proc`,
    payload
  );
  // status 500/403 은 interceptor 가 resolve 하므로 직접 차단(false success 방지).
  if (res.status >= 400 || Number((res.data as { code?: string })?.code)) {
    return { ok: false, message: (res.data as { message?: string })?.message?.trim() };
  }
  return { ok: true };
};
