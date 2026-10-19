// 저장 I/M/D 판정 + ^-결합 payload (03_grid-columns.md §3-d/§4-3, AS-IS SAVE SP 계약 재현).
//   SP(SCP0121_SAVE_PLAN_GROUP_LINE) 미배포 — AS-IS MSSQL 본문이 정본(convert-sp 후속).
import { safeString } from '@foundation/utils';

import { ALL_MODEL, COLUMNS, SAVE_DELIM } from '../plan-group-master.constants';
import type { ComboOption, PlanGroupRow } from '../plan-group-master.types';

// SP 커서 값 타입은 unknown — String(v??'') 는 no-base-to-string 에 걸린다. 공용 safeString(원시값만 변환) 경유.
const str = (v: unknown): string => safeString(v).trim();

export type CrudAction = 'I' | 'M' | 'D';

export interface ActionRow {
  row: PlanGroupRow;
  action: CrudAction;
  itemId: string; // 공백 → '-'(All) 치환 적용본
}

/**
 * 행별 I/M/D 판정 (03_grid §3-d).
 * · item_id 공백 → '-'(All) 치환.
 * · plan_gr_id==pre && item_id==pre → 변경없음 skip.
 * · pre 둘 다 공백 → 'I'(신규).
 * · pre_plan_gr_id 있고 plan_gr_id 공백 → 'D'(Plan Group 공백화 = 삭제).
 * · 그 외 → 'M'.
 * CRUD_TYPE(EditTracker 'I'/'M') 마킹된 행만 들어온다 — 자체 상태필드 신설 금지(convert-core §2.4).
 */
export const resolveAction = (row: PlanGroupRow): ActionRow | null => {
  const planGrId = str(row[COLUMNS.OPMZ_PLAN_GR_ID]);
  const rawItem = str(row[COLUMNS.OPMZ_PLAN_GR_ITEM_ID]);
  const itemId = rawItem === '' ? ALL_MODEL : rawItem;
  const prePlanGrId = str(row[COLUMNS.PRE_PLAN_GR_ID]);
  const preItemRaw = str(row[COLUMNS.PRE_PLAN_GR_ITEM_ID]);
  const preItem = preItemRaw === '' ? ALL_MODEL : preItemRaw;

  // 변경 없음 skip.
  if (planGrId === prePlanGrId && itemId === preItem) return null;
  // 신규 (pre 둘 다 공백).
  if (prePlanGrId === '' && preItemRaw === '') return { row, action: 'I', itemId };
  // 삭제 (기존행 Plan Group 공백화).
  if (prePlanGrId !== '' && planGrId === '') return { row, action: 'D', itemId };
  return { row, action: 'M', itemId };
};

export const buildActionRows = (rows: readonly PlanGroupRow[]): ActionRow[] =>
  rows.map(resolveAction).filter((r): r is ActionRow => r !== null);

/**
 * ^-결합 저장 payload (AS-IS SaveData nvc 동등, 10 파라미터).
 * createdBy/lastUpdatedBy 는 BE 가 세션 단일값으로 덮어쓰므로 createdByList/lastUpdatedByList 로 회피
 *   (nscm-patterns §5-11, DMF0020 선례).
 */
export const buildSavePayload = (
  actionRows: readonly ActionRow[],
  userId: string
): Record<string, string> => {
  const join = (pick: (a: ActionRow) => string): string =>
    actionRows.map(pick).join(SAVE_DELIM);
  const uid = str(userId);
  return {
    crudType: join(a => a.action),
    divisionId: join(a => str(a.row[COLUMNS.DIVISION_ID])),
    lineId: join(a => str(a.row[COLUMNS.LINE_ID])),
    operationId: join(a => str(a.row[COLUMNS.OPERATION_ID])),
    factoryId: join(a => str(a.row[COLUMNS.FACTORY_ID])),
    plantId: join(a => str(a.row[COLUMNS.PLANT_ID])),
    planGroupId: join(a => str(a.row[COLUMNS.OPMZ_PLAN_GR_ID])),
    itemId: join(a => a.itemId),
    prePlanGroupId: join(a => str(a.row[COLUMNS.PRE_PLAN_GR_ID])),
    preItemId: join(a => {
      const p = str(a.row[COLUMNS.PRE_PLAN_GR_ITEM_ID]);
      return p === '' ? ALL_MODEL : p;
    }),
    createdByList: actionRows.map(() => uid).join(SAVE_DELIM),
    lastUpdatedByList: actionRows.map(() => uid).join(SAVE_DELIM),
  };
};

/**
 * 붙여넣기 NAME→CODE 역변환 (03_grid §3-c W8). 표시명(NAME)으로 붙이면 CODE 로 치환.
 * 미매칭 시 undefined 반환 → 호출 측이 셀 미변경(NRE 방어, convert-core §2.4).
 */
export const resolvePlanGroupCode = (
  pasted: string,
  options: readonly ComboOption[]
): string | undefined => {
  const needle = str(pasted);
  if (needle === '') return '';
  // 이미 CODE 면 그대로.
  if (options.some(o => o.value === needle)) return needle;
  // NAME 매칭 → CODE.
  const byName = options.find(o => o.label === needle);
  return byName?.value;
};
