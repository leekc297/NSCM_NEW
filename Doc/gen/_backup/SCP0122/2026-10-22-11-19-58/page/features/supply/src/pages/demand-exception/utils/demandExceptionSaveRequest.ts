// SCP0129 Demand Exception 저장 — payload 조립 + 직접 POST + false-success 판별.
//   SAVE SP(PKG_SCP0129.P_SCP0129_SAVE_DEMAND_EXCEPTION)의 IN 파라미터 19개는 전부 DATA_TP_CD='CLOB'
//   (컬럼별 '^'-fold — 본문 C_DELIMITER='^', SCM_ARR_SPL_VAL 로 행별 분해, 루프수=P_ACTIVE_FLAG 토큰수.
//   ora.py 실측 2026-10-13). BE makeProcedure 는 CLOB 을 접지 않고 params.get(COL_NM) 을 그대로 바인드.
//   → 공용 useProcMutation({data:[rows]}) 로는 top-level 에 activeFlag/divisionId... 키가 없어 전부
//     null 바인딩되고 SP 는 루프 0회로 SUCCESS 를 반환하나 실제 저장은 조용히 no-op 된다(형제 SCP0128
//     SafetyStock 과 동일 결함). FE 가 미리 접은 스칼라를 camelCase COL_NM 키로 보내야 저장이 성립한다.
//   정본 패턴: safety-stock/utils/safetyStockSaveRequest.ts.

import { apiClient } from '@foundation/apis';
import type { EditTracker } from '@foundation/utils';
import { safeString } from '@foundation/utils';

import { MENU_ID, SHEETS } from '../demand-exception.constants';

import { toYmd8 } from './demand-exception.util';

export interface SaveResult {
  ok: boolean;
  message?: string;
}

/**
 * 변경(I/M/D)된 행들을 SAVE SP 의 19개 CLOB IN 파라미터(^-delim)로 조립해 call-proc 호출.
 *   - activeFlag = row.CRUD_TYPE('I'/'M'/'D'). 루프수 기준 파라미터.
 *   - FROM/TO 는 'YYYYMMDD' 8자리로 정규화(AS-IS SaveData .cs:662~663, Replace("-","").Substring(0,8)).
 *   - pre* = 변경 전 원본 키값(EditTracker originals, 미편집 키는 현재값). 신규행은 비워 보낸다
 *     (AS-IS .cs:727~737 — FlagI 면 pre 공백).
 *   - userId 는 단일 스칼라(SP 가 루프 안에서 split 하지 않는다 — 본문 실측, AS-IS 단일값 전달과 일치).
 */
export const submitDemandExceptionSave = async <T extends WijmoRowItem>(
  changed: T[],
  tracker: EditTracker<T> | undefined,
  userId: string
): Promise<SaveResult> => {
  const acc: Record<string, string[]> = {
    activeFlag: [],
    divisionId: [],
    opmzPlanGrId: [],
    scmSiteId: [],
    itemId: [],
    stage: [],
    fromYyyymmdd: [],
    toYyyymmdd: [],
    stockException: [],
    valueDescription: [],
    validYn: [],
    preDivisionId: [],
    preOpmzPlanGrId: [],
    preScmSiteId: [],
    preItemId: [],
    preStage: [],
    preFromYyyymmdd: [],
    preToYyyymmdd: [],
  };

  for (const row of changed) {
    const rec = row as Record<string, unknown>;
    const crud = safeString(rec.CRUD_TYPE); // 'I' | 'M' | 'D'
    const isInsert = crud === 'I';
    const originals = tracker?.getOriginalValues().get(row);
    // 신규행은 pre 를 비운다. 그 외에는 편집된 키만 원본으로, 미편집 키는 현재값으로 집는다.
    const preRaw = (binding: string): unknown => {
      if (isInsert) return '';
      return originals && binding in originals ? originals[binding] : rec[binding];
    };
    const preOf = (binding: string): string => safeString(preRaw(binding));

    acc.activeFlag.push(crud);
    acc.divisionId.push(safeString(rec.DIVISION_ID));
    acc.opmzPlanGrId.push(safeString(rec.OPMZ_PLAN_GR_ID));
    acc.scmSiteId.push(safeString(rec.SCM_SITE_ID));
    acc.itemId.push(safeString(rec.ITEM_ID));
    acc.stage.push(safeString(rec.STAGE));
    acc.fromYyyymmdd.push(toYmd8(rec.FROM_YYYYMMDD));
    acc.toYyyymmdd.push(toYmd8(rec.TO_YYYYMMDD));
    acc.stockException.push(safeString(rec.STOCK_EXCEPTION));
    acc.valueDescription.push(safeString(rec.VALUE_DESCRIPTION));
    acc.validYn.push(safeString(rec.VALID_YN));

    acc.preDivisionId.push(preOf('DIVISION_ID'));
    acc.preOpmzPlanGrId.push(preOf('OPMZ_PLAN_GR_ID'));
    acc.preScmSiteId.push(preOf('SCM_SITE_ID'));
    acc.preItemId.push(preOf('ITEM_ID'));
    acc.preStage.push(preOf('STAGE'));
    acc.preFromYyyymmdd.push(toYmd8(preRaw('FROM_YYYYMMDD')));
    acc.preToYyyymmdd.push(toYmd8(preRaw('TO_YYYYMMDD')));
  }

  const payload: Record<string, string> = {};
  for (const [key, arr] of Object.entries(acc)) payload[key] = arr.join('^');
  payload.userId = userId; // 단일 스칼라 — SP 는 행별로 split 하지 않는다.

  try {
    const res = await apiClient.post<Record<string, unknown>>(
      `/${MENU_ID}/${SHEETS.MAIN}/SAVE/call-proc`,
      payload
    );
    // false-success 차단 — 인터셉터가 500 도 resolve 하고, SP 실패는 result.code != 0 로만 온다.
    if (res.status >= 400 || Number(res.data?.code)) {
      const reason = (res.data as { message?: string })?.message?.trim();
      return { ok: false, message: reason };
    }
    return { ok: true };
  } catch (e) {
    return { ok: false, message: e instanceof Error ? e.message : undefined };
  }
};
