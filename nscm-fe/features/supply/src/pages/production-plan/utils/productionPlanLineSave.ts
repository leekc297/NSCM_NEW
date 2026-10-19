// SCP0011 LINE 저장(design 03 §4.3) — AS-IS SaveData_Line(cs L2680-2778) 재현.
//   변경·빈 D_(일자) 셀만 수집해 17 컬럼을 '^' 로 접어 camelCase 키로 직접 POST 한다.
//   SAVE SP(PKG_COM0000.P_SCP0011_SAVE_PROD_PLAN_LINE)의 17 IN 파라미터는 DATA_TP_CD='CLOB'(JVARCHAR 아님)
//   이라 BE cvtJsonToJVarchar 의 ^-fold 가 발동하지 않는다(BaseService makeProcedure 가 CLOB 은 접지 않고
//   params.get(COL_NM) 을 그대로 바인드) → FE 가 미리 접은 스칼라를 COL_NM 키로 보내야 저장이 성립한다.
//   공용 useProcMutation({data:[rows]}) 로는 top-level 에 activeFlag/divisionId... 키가 없어 전부 null 바인딩되고
//   SP 는 SUCCESS 를 반환하나 실제 저장은 조용히 no-op 된다(react-gap-audit H2). 정본 패턴: 자매 SCP0006
//   project-route/utils/projectRoute.plantSaveRequest.ts(컬럼별 arr.join('^') + 직접 POST + false-success 가드).

import type { FlexGrid } from '@mescius/wijmo.grid';

import { apiClient } from '@foundation/apis';
import type { EditTracker } from '@foundation/utils';

import { MENU_ID, SHEETS } from '../production-plan.constants';

type Row = Record<string, unknown>;

const s = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

// D_ 바인딩 = 일자 pivot 셀. W_/M_(주/월 SUM)는 저장 대상 아님(AS-IS 는 D_ 셀만 전송).
const isDailyBinding = (b: string): boolean => b.indexOf('D_') === 0;
const dayOf = (b: string): string => b.slice(2).replace(/[^0-9]/g, '').slice(0, 8);

// SAVE SP 17 CLOB 파라미터 = PROC_M COL_NM(camelCase, SORT_ORD 1~17). programId/debugMode(VARCHAR)는 뒤에 붙인다.
const COLS = [
  'activeFlag',
  'divisionId',
  'planStartYyyymmdd',
  'planType',
  'seq',
  'operationGroup',
  'scmSiteId',
  'itemId',
  'lineId',
  'operationId',
  'measure',
  'yyyymmdd',
  'qty',
  'userId',
  'fix',
  'electrodeType',
  'originDivisionId',
] as const;

export interface LineSavePayload {
  payload: Record<string, string>;
  count: number;
  negative: boolean; // 변경 셀에 음수 수량이 있으면 true (호출부가 차단)
}

/**
 * 변경된 LINE 행의 변경 D_ 셀을 17 컬럼 '^'-fold payload 로 조립.
 *   변경 셀 판정은 EditTracker.getOriginalValues()(원본≠현재인 binding 집합)로 한다 — AS-IS 의 "빈 값 또는
 *   Red(변경)" 셀 수집과 등가다(design 03 §4.3 "변경·빈 D_ 셀만"). 빈 셀은 '0' 으로 보낸다(AS-IS 동일).
 *   변경 없으면 null.
 */
export const buildLineSavePayload = (
  grid: FlexGrid | undefined,
  tracker: EditTracker | undefined,
  userId: string
): LineSavePayload | null => {
  if (!grid || !tracker) return null;
  const originals = tracker.getOriginalValues();
  if (originals.size === 0) return null;

  const acc: Record<string, string[]> = {};
  for (const c of COLS) acc[c] = [];
  let negative = false;

  // 그리드 행 순서대로(AS-IS GetMaxRowIndex 순회와 동일) 변경된 D_ 셀만 수집.
  for (const gr of grid.rows) {
    const row = gr.dataItem as Row | undefined;
    if (!row) continue;
    const changed = originals.get(row as never);
    if (!changed) continue; // 변경 기록 없는 행 skip
    const activeFlag = s(row.CRUD_TYPE) === 'I' ? 'I' : 'M'; // 이 화면은 Insert/Delete NO-OP → 사실상 'M'

    for (const binding of Object.keys(changed)) {
      if (!isDailyBinding(binding)) continue; // D_(일자) 셀만
      const raw = s(row[binding]).replace(/,/g, '');
      const qty = raw === '' ? '0' : raw; // 빈 셀 = '0' (AS-IS strDayQty 보정)
      if (Number(qty) < 0) negative = true;

      acc.activeFlag.push(activeFlag);
      acc.divisionId.push(s(row.DIVISION_ID));
      acc.planStartYyyymmdd.push(s(row.PLAN_START_YYYYMMDD));
      acc.planType.push(s(row.PLAN_TYPE));
      acc.seq.push(s(row.PLAN_SEQ));
      acc.operationGroup.push(s(row.OPERATION_GROUP));
      acc.scmSiteId.push(s(row.SCM_SITE_ID));
      acc.itemId.push(s(row.ITEM_ID));
      acc.lineId.push(s(row.LINE_ID));
      acc.operationId.push(s(row.OPERATION_ID));
      acc.measure.push(s(row.MEASURE));
      acc.yyyymmdd.push(dayOf(binding));
      acc.qty.push(qty);
      acc.userId.push(userId); // call-proc 은 세션 미주입 → FE 가 세션 userId 를 싣는다
      acc.fix.push(''); // AS-IS p_fix = "" 고정
      acc.electrodeType.push(s(row.ELECTRODE_TYPE));
      acc.originDivisionId.push(s(row.ORIGIN_DIVISION_ID));
    }
  }

  const count = acc.activeFlag.length;
  if (count === 0) return null;

  const payload: Record<string, string> = {};
  for (const c of COLS) payload[c] = acc[c].join('^');
  payload.programId = MENU_ID;
  payload.debugMode = 'F';
  return { payload, count, negative };
};

export interface LineSaveResult {
  ok: boolean;
  message?: string;
}

/** 조립된 payload 를 SAVE call-proc 로 전송 + false-success 차단(인터셉터가 500 도 resolve). */
export const submitLineSave = async (payload: Record<string, string>): Promise<LineSaveResult> => {
  try {
    const res = await apiClient.post<Record<string, unknown>>(
      `/${MENU_ID}/${SHEETS.LINE}/SAVE/call-proc`,
      payload
    );
    if (res.status >= 400 || Number(res.data?.code)) {
      const reason = (res.data as { message?: string })?.message?.trim();
      return { ok: false, message: reason };
    }
    return { ok: true };
  } catch (e) {
    return { ok: false, message: e instanceof Error ? e.message : undefined };
  }
};
