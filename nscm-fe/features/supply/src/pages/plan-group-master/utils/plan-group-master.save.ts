// 저장 I/M/D 판정 + ^-결합 payload (03_grid-columns.md §3-d/§4-3, AS-IS SAVE SP 계약 재현).
//   SP(SCP0121_SAVE_PLAN_GROUP_LINE) 미배포 — AS-IS MSSQL 본문이 정본(convert-sp 후속).
import { CRUD_TYPE } from '@foundation/constants';
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
 * · item_id 공백 → '-'(All) 치환 — 저장 payload·중복검증 키 용(ActionRow.itemId).
 * · Delete(F9) 표시(CRUD_TYPE='D')는 값 비교보다 먼저 판정한다 — pre_plan_gr_id 있으면 'D', 없으면(그룹 미지정 행)
 *   원장에 지울 행이 없어 제외(갭분석 C-17). 값 변경이 없는 행이라 아래 skip 에 묻히면 삭제 요청이 안 나간다.
 * · 신규(pre 둘 다 공백)는 변경없음 skip 보다 먼저 'I' 로 확정 — 빈 신규행도 저장 시 validation
 *   (W9 Plan Group 필수)을 받아야 하므로 "변경없음"으로 묻히면 안 된다(2026-10-14 신규행 저장 실사고).
 * · 기존행 변경없음 skip 은 raw 비교: plan_gr_id==pre && item(raw)==pre_item(raw). 정규화(공백↔'-')를
 *   skip 판정에 쓰면 All('-') 셀을 지워도 '변경없음'으로 묻혀 status=M(EditTracker)과 어긋난다(2026-10-14).
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

  // Delete(F9) 표시 행 — SAVE SP 의 'D' 경로는 pre 키로 지운다.
  if ((row as { CRUD_TYPE?: string }).CRUD_TYPE === CRUD_TYPE.DELETE) {
    return prePlanGrId !== '' ? { row, action: 'D', itemId } : null;
  }
  // 신규 (pre 둘 다 공백) — 변경없음 skip 보다 먼저. 빈 신규행도 'I' 로 잡아 validation(W9) 받게 한다.
  if (prePlanGrId === '' && preItemRaw === '') return { row, action: 'I', itemId };
  // 변경 없음 skip (기존행) — EditTracker 와 일치시키려 raw 비교(공백↔'-' 정규화 안 씀).
  if (planGrId === prePlanGrId && rawItem === preItemRaw) return null;
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
 * 저장 거부 안내 문구. 공용 응답 처리가 결과 커서 CODE ≠ 0 을 오류로 던지므로(error.message = 결과 커서 MSG)
 *   저장 처리에서 받아 그대로 보인다(AS-IS cs:828-831 서버 문구 표시, 갭분석 C-20). 문구가 없으면 undefined.
 */
export const toSaveErrorMessage = (error: unknown): string | undefined => {
  const message = error instanceof Error ? str(error.message) : '';
  return message === '' ? undefined : message;
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
