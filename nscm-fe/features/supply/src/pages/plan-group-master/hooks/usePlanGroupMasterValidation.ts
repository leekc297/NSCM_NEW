import { CRUD_MSG, CRUD_TYPE } from '@foundation/constants';
import { safeString } from '@foundation/utils';
import { useMessageStore } from '@shared/stores';

import { ALL_MODEL, COLUMNS, LABELS, MSG } from '../plan-group-master.constants';
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

// 신규 추가행(pre 둘 다 공백) 판정 — resolveAction 'I' 와 동일 기준(save.ts).
//   AS-IS W11/W12 는 dtmain(= DB 조회 원본)을 세는데, FarPoint 신규 Insert 행은 저장 트리거 시점에
//   그 카운트에 들어가지 않아 '기존행만' 기준으로 2개 이상인지 본다(사용자 실측 2026-11-03: AS-IS 는
//   같은 Line 에 기존 1개 + 신규 1개는 통과, 기존 2개 + 신규 1개=3개째부터 차단). 이를 재현하려면
//   신규행을 카운트 세트에서 빼야 한다 — 그러지 않으면 TO-BE 가 AS-IS 보다 한 개 일찍 걸린다.
const isNewRow = (row: PlanGroupRow): boolean =>
  str(row[COLUMNS.PRE_PLAN_GR_ID]) === '' && str(row[COLUMNS.PRE_PLAN_GR_ITEM_ID]) === '';

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

    // W9 신규행 Plan Group 필수 — 공용(useSaveWithValidation)·SCP0002 와 동일한 per-column 문구
    //   MSG00429 "[{컬럼}] 값은 필수 입력 항목입니다."({0}=`[라벨]`). 라벨은 조회조건과 같은 LBL00002(Plan Group).
    for (const a of triggers) {
      if (a.action === 'I' && str(a.row[COLUMNS.OPMZ_PLAN_GR_ID]) === '') {
        return fail(
          t(CRUD_MSG.REQUIRED_FIELD.id, CRUD_MSG.REQUIRED_FIELD.fallback).replace(
            '{0}',
            `[${t(LABELS.PLAN_GROUP, '_Plan Group')}]`
          )
        );
      }
    }

    // 그리드 전체(dtmain) 를 비교 세트로 준비 — 편집분이 반영된 현재 source 전체.
    //   Delete(F9) 표시 행은 저장되면 사라지므로 뺀다(AS-IS 의 삭제 항목 대상 제외 cs:729 와 같은 뜻, 갭분석 C-17).
    const liveRows = allRows.filter(
      row => (row as { CRUD_TYPE?: string }).CRUD_TYPE !== CRUD_TYPE.DELETE
    );
    const gridKeys = liveRows.map(toGridKey);
    // W11/W12 카운트 세트 — 신규 추가행(pre 둘 다 공백)을 제외한 '기존행'만. AS-IS 는 신규 Insert 행을
    //   dtmain 카운트에 넣지 않아 기존행 기준 2개 이상일 때만 발동한다(isNewRow 주석 참조, 사용자 실측
    //   2026-11-03). W10(중복키)은 신규행도 중복 대상이라 전체(gridKeys)를 그대로 쓴다.
    const existingKeys = liveRows.filter(r => !isNewRow(r)).map(toGridKey);

    for (const a of triggers) {
      const lk = lineKeyOf(a.row);
      const planGr = str(a.row[COLUMNS.OPMZ_PLAN_GR_ID]);

      // W10 동일키 중복 (TO-BE MSG01427 "중복된 항목이 있습니다." — AS-IS MSG00443 의 등가, 사용자 지정 2026-11-03) — dtmain 에서 Line+PlanGroup+ISNULL(Item,'-') 일치 행수>1 (cs:680-695).
      const dupCount = gridKeys.filter(
        g => g.lineKey === lk && g.planGr === planGr && g.item === a.itemId
      ).length;
      if (dupCount > 1) return fail(t(MSG.DUPLICATE_KEY, '_Duplicated item exists.'));

      // W11 동일 Line·동일 Plan Group 에 All('-')+모델 혼재 금지 (cs:697-721).
      //   기존행(existingKeys)에서 Line+PlanGroup 일치 행수>1 이면서 그 중 item 이 '-'/'' 인 행이 있으면 금지.
      const samePlanGr = existingKeys.filter(g => g.lineKey === lk && g.planGr === planGr);
      if (samePlanGr.length > 1 && samePlanGr.some(g => isAllModel(g.item))) {
        return fail(
          t(MSG.ALL_MODEL_MIX, '_동일 Line에 동일Plan Group에 All(-)과 모델을 같이 지정할 수 없습니다.')
        );
      }

      // W12 동일 Line 에 Plan Group 2개 이상(지정된 행수>1)이면 All('-') 금지 (cs:723-745).
      //   기존행(existingKeys)에서 Line + PlanGroup<>'' 행수>1 이면서 그 중 item 이 '-'/'' 인 행이 있으면 금지.
      const nonEmptyPlanGr = existingKeys.filter(g => g.lineKey === lk && g.planGr !== '');
      if (nonEmptyPlanGr.length > 1 && nonEmptyPlanGr.some(g => isAllModel(g.item))) {
        return fail(
          t(MSG.MULTI_PLAN_GROUP_ALL, '_동일 Line에 2개 이상의 Plan Group을 지정할 경우, All(-)을 사용할 수 없다.')
        );
      }
    }

    return { ok: true };
  };

  return { validate };
};
