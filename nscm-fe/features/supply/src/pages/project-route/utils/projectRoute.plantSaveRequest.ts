// SCP0006 Plant 저장(design/03 §4.4) — payload 조립 + POST + false-success 판별.
//   SCP0006 본 화면 Save 와 Input All 팝업(SCM0002_ProjectRouteListSavePopup) Save 가 AS-IS 에서도
//   동일 SP(SCP.SCP0006_SAVE_PROJECT_ROUTE_PLANT)를 호출한다(Roslyn 실측) — payload 조립 로직을
//   공유해 두 화면이 갈라지지 않게 한다.

import { apiClient } from '@foundation/apis';
import { t } from '@foundation/i18n';
import { safeString } from '@foundation/utils';

import { MENU_ID, MSG, SHEETS } from '../project-route.constants';
import type { PlantRow } from '../project-route.types';

// PlantRow 는 이미 CRUD_TYPE 을 포함한다(WijmoRowItem 상속) — 별칭만 유지.
export type PlantSaveRow = PlantRow;

export interface PlantSaveResult {
  ok: boolean;
  message?: string;
}

const ymd8 = (v: unknown) => safeString(v).replace(/\D/g, '');

/**
 * 변경된 Plant 행들을 SP payload(^-delim CLOB)로 조립해 SAVE 호출.
 * userId 는 CREATED_BY/LAST_UPDATED_BY 갱신용 — 호출부가 세션에서 읽어 전달한다.
 */
export const submitPlantSaveRequest = async (
  changed: PlantSaveRow[],
  userId: string
): Promise<PlantSaveResult> => {
  const acc: Record<string, string[]> = {
    activeFlag: [],
    prioritySeq: [],
    divisionId: [],
    projectCode: [],
    scmSiteId: [],
    plantSiteId: [],
    itemId: [],
    priority: [],
    fromYyyymmdd: [],
    toYyyymmdd: [],
    validYn: [],
    // createdBy/lastUpdatedBy 키는 BE 세션 덮어쓰기 회피 위해 List 접미(nscm-patterns §5-11).
    createdByList: [],
    creationDate: [],
    lastUpdatedByList: [],
  };
  for (const r of changed) {
    const rec = r as Record<string, unknown>;
    const isInsert = r.CRUD_TYPE === 'I';
    acc.activeFlag.push(isInsert ? 'I' : 'M');
    acc.prioritySeq.push(safeString(rec.PRIORITY_SEQ));
    acc.divisionId.push(safeString(rec.DIVISION_ID));
    acc.projectCode.push(safeString(rec.PROJECT_CODE));
    acc.scmSiteId.push(safeString(rec.SCM_SITE_ID));
    acc.plantSiteId.push(safeString(rec.PLANT_SITE_ID));
    acc.itemId.push(safeString(rec.ITEM_ID));
    acc.priority.push(safeString(rec.PRIORITY));
    acc.fromYyyymmdd.push(ymd8(rec.FROM_YYYYMMDD));
    acc.toYyyymmdd.push(ymd8(rec.TO_YYYYMMDD));
    acc.validYn.push(safeString(rec.VALID_YN));
    acc.createdByList.push(isInsert ? userId : safeString(rec.CREATED_BY));
    acc.creationDate.push(isInsert ? '' : safeString(rec.CREATION_DATE));
    acc.lastUpdatedByList.push(userId);
  }
  const payload: Record<string, string> = {};
  for (const [k, arr] of Object.entries(acc)) payload[k] = arr.join('^');

  try {
    const res = await apiClient.post<Record<string, unknown>>(
      `/${MENU_ID}/${SHEETS.PLANT}/SAVE/call-proc`,
      payload
    );
    // false-success 차단(nscm-patterns §5-10) — 인터셉터가 500 도 resolve.
    if (res.status >= 400 || Number(res.data?.code)) {
      const reason =
        (res.data as { message?: string })?.message?.trim() ||
        t(MSG.SAVE_ERROR, '_저장 중 오류가 발생했습니다.');
      return { ok: false, message: reason };
    }
    return { ok: true };
  } catch (e) {
    const msg = e instanceof Error ? e.message : t(MSG.SAVE_ERROR, '_저장 중 오류가 발생했습니다.');
    return { ok: false, message: msg };
  }
};
