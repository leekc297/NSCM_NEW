import { safeString } from '@foundation/utils';
import { useMessageStore } from '@shared/stores';

import { ALL_MODEL, COLUMNS, MSG } from '../plan-group-master.constants';
import type { PlanGroupRow } from '../plan-group-master.types';
import type { ActionRow } from '../utils/plan-group-master.save';

// SP 커서 값 타입은 unknown — String(v??'') 는 no-base-to-string 에 걸린다. 공용 safeString(원시값만 변환) 경유.
const str = (v: unknown): string => safeString(v).trim();

// Line 단위 키 (LINE/OPERATION/FACTORY/PLANT) — raw 행 기준.
const lineKeyOf = (row: PlanGroupRow): string =>
  [
    str(row[COLUMNS.LINE_ID]),
    str(row[COLUMNS.OPERATION_ID]),
    str(row[COLUMNS.FACTORY_ID]),
    str(row[COLUMNS.PLANT_ID]),
  ].join('|');

// 그리드 전체(dtmain 등가)의 비교용 정규화 — AS-IS 는 셀에 '-' 치환을 쓰지 않고 ISNULL(ITEM,'-')/
//   (item==''||'-') 로 판정하므로, 비교 시점에만 공백 Model 을 '-' 로 본다(원본 셀은 미변경).
interface GridKey {
  lineKey: string;
  planGr: string;
  item: string; // 공백 → '-' 정규화본
}
const toGridKey = (row: PlanGroupRow): GridKey => {
  const rawItem = str(row[COLUMNS.OPMZ_PLAN_GR_ITEM_ID]);
  return {
    lineKey: lineKeyOf(row),
    planGr: str(row[COLUMNS.OPMZ_PLAN_GR_ID]),
    item: rawItem === '' ? ALL_MODEL : rawItem,
  };
};

const isAllModel = (item: string): boolean => item === ALL_MODEL || item === '';

/**
 * 저장 전 검증 3종 + 필수(03_grid §3-d, W9/W10/W11/W12). 'D' 행은 제외(AS-IS: 'D' 아닌 경우만 검증).
 *
 * GAP-03(AS-IS cs:688-745 재현): 변경행끼리가 아니라 **그리드 전체 source(미변경 기존행 포함 = dtmain)** 와
 *   대조한다. AS-IS 는 각 I/M 행을 trigger 로 dtmain 을 필터해 행수(dv.Count / Rows.Count)로 판정하므로
 *   여기서도 전체 행을 세트로 두고 trigger 별 행수로 판정한다(distinct 아님 — AS-IS 는 row count).
 * 반환 ok=false 면 호출 측이 저장 중단(alert 는 이 훅이 띄운다).
 */
export const usePlanGroupMasterValidation = () => {
  const { t } = useTranslation();
  const { setAlert } = useMessageStore.getState();

  const fail = (content: string): { ok: false } => {
    void setAlert({ type: 'alert', content });
    return { ok: false };
  };

  const validate = (
    actionRows: readonly ActionRow[],
    allRows: readonly PlanGroupRow[]
  ): { ok: boolean } => {
    // 변경행 중 'D' 가 아닌 것만 검증 trigger (AS-IS: action != D 인 경우만 중복/제약 체크).
    const triggers = actionRows.filter(a => a.action !== 'D');

    // W9 신규행 Plan Group 필수 (TO-BE MSG00013 — AS-IS MSG00001 은 TO-BE 문구 불일치로 미사용, GAP-11).
    for (const a of triggers) {
      if (a.action === 'I' && str(a.row[COLUMNS.OPMZ_PLAN_GR_ID]) === '') {
        return fail(t(MSG.REQUIRE_PLAN_GROUP, '_Plan Group is required.'));
      }
    }

    // 그리드 전체(dtmain) 를 비교 세트로 준비 — 편집분이 반영된 현재 source 전체.
    const gridKeys = allRows.map(toGridKey);

    for (const a of triggers) {
      const lk = lineKeyOf(a.row);
      const planGr = str(a.row[COLUMNS.OPMZ_PLAN_GR_ID]);

      // W10 동일키 중복 (TO-BE MSG00060 — AS-IS MSG00443 TO-BE 미등록, GAP-11) — dtmain 에서 Line+PlanGroup+ISNULL(Item,'-') 일치 행수>1 (cs:680-695).
      const dupCount = gridKeys.filter(
        g => g.lineKey === lk && g.planGr === planGr && g.item === a.itemId
      ).length;
      if (dupCount > 1) return fail(t(MSG.DUPLICATE_KEY, '_Duplicated key exists.'));

      // W11 동일 Line·동일 Plan Group 에 All('-')+모델 혼재 금지 (cs:697-721).
      //   dtmain 에서 Line+PlanGroup 일치 행수>1 이면서 그 중 item 이 '-'/'' 인 행이 있으면 금지.
      const samePlanGr = gridKeys.filter(g => g.lineKey === lk && g.planGr === planGr);
      if (samePlanGr.length > 1 && samePlanGr.some(g => isAllModel(g.item))) {
        return fail(
          t(MSG.ALL_MODEL_MIX, '_Cannot mix All(-) and specific models for the same Line/Plan Group.')
        );
      }

      // W12 동일 Line 에 Plan Group 2개 이상(지정된 행수>1)이면 All('-') 금지 (cs:723-745).
      //   dtmain 에서 Line + PlanGroup<>'' 행수>1 이면서 그 중 item 이 '-'/'' 인 행이 있으면 금지.
      const nonEmptyPlanGr = gridKeys.filter(g => g.lineKey === lk && g.planGr !== '');
      if (nonEmptyPlanGr.length > 1 && nonEmptyPlanGr.some(g => isAllModel(g.item))) {
        return fail(
          t(MSG.MULTI_PLAN_GROUP_ALL, '_Cannot use All(-) when a Line has multiple Plan Groups.')
        );
      }
    }

    return { ok: true };
  };

  return { validate };
};
