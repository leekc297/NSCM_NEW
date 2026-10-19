// SCP0048 저장(design/03 §4.3) — payload 조립 + POST + false-success 판별.
//   SAVE = P_SCP0048_SAVE_PROJECTROUTE_WARRANTY(18 args = 14 CLOB IN + P_DEBUG_MODE + O_* 3).
//   14 CLOB 은 `^`-delim 병렬배열(자매 SCP0006 submitPlantSaveRequest 패턴 검증).
//   PLANT_SITE_ID 저장원본 = PLANT_SITE_ID_B(표시 합성문자열이 아니라 원본, design/03 §1 col29).
//   ITEM_ID 는 .toUpperCase()(design/03 R-D8 · SAVE 계약).

import { apiClient } from '@foundation/apis';
import { t } from '@foundation/i18n';
import { safeString } from '@foundation/utils';

import { MENU_ID, MSG, SHEETS } from '../project-route-warranty.constants';
import type { MainRow } from '../project-route-warranty.types';

export type WarrantySaveRow = MainRow;

export interface WarrantySaveResult {
  ok: boolean;
  message?: string;
}

const ymd8 = (v: unknown) => safeString(v).replace(/\D/g, '');

/**
 * 변경된 행들을 SP payload(^-delim CLOB)로 조립해 SAVE 호출.
 * userId 는 CREATED_BY/LAST_UPDATED_BY 갱신용 — 호출부가 세션에서 읽어 전달한다.
 * DEBUG_MODE 는 상수 'F'(design/03 SAVE 계약 P_DEBUG_MODE).
 */
export const submitWarrantySaveRequest = async (
  changed: WarrantySaveRow[],
  userId: string
): Promise<WarrantySaveResult> => {
  const acc: Record<string, string[]> = {
    activeFlag: [], // P_ACTIVE_FLAG(I/M)
    prioritySeq: [], // P_PRIORITY_SEQ
    divisionId: [], // P_DIVISION_ID
    projectCode: [], // P_PROJECT_CODE
    scmSiteId: [], // P_SCM_SITE_ID
    plantSiteId: [], // P_PLANT_SITE_ID = PLANT_SITE_ID_B 원본
    itemId: [], // P_ITEM_ID = toUpperCase
    priority: [], // P_PRIORITY
    fromYyyymmdd: [], // P_FROM_YYYYMMDD(8자리)
    toYyyymmdd: [], // P_TO_YYYYMMDD(8자리)
    validYn: [], // P_VALID_YN
    // createdBy/lastUpdatedBy 키는 BE 세션 덮어쓰기 회피 위해 List 접미(nscm-patterns §5-11).
    createdByList: [], // P_CREATED_BY
    creationDate: [], // P_CREATION_DATE
    lastUpdatedByList: [], // P_LAST_UPDATED_BY
  };
  for (const r of changed) {
    const rec = r as Record<string, unknown>;
    const isInsert = r.CRUD_TYPE === 'I';
    acc.activeFlag.push(isInsert ? 'I' : 'M');
    acc.prioritySeq.push(safeString(rec.PRIORITY_SEQ));
    acc.divisionId.push(safeString(rec.DIVISION_ID));
    acc.projectCode.push(safeString(rec.PROJECT_CODE));
    acc.scmSiteId.push(safeString(rec.SCM_SITE_ID));
    // 표시컬럼 PLANT_SITE_ID 는 합성문자열 — 저장은 원본 PLANT_SITE_ID_B(design/03 col29).
    acc.plantSiteId.push(safeString(rec.PLANT_SITE_ID_B));
    acc.itemId.push(safeString(rec.ITEM_ID).toUpperCase());
    acc.priority.push(safeString(rec.PRIORITY));
    acc.fromYyyymmdd.push(ymd8(rec.FROM_YYYYMMDD));
    acc.toYyyymmdd.push(ymd8(rec.TO_YYYYMMDD));
    acc.validYn.push(safeString(rec.VALID_YN));
    acc.createdByList.push(isInsert ? userId : safeString(rec.CREATED_BY));
    acc.creationDate.push(isInsert ? '' : safeString(rec.CREATION_DATE));
    acc.lastUpdatedByList.push(userId);
  }
  const payload: Record<string, string> = { debugMode: 'F' };
  for (const [k, arr] of Object.entries(acc)) payload[k] = arr.join('^');

  try {
    const res = await apiClient.post<Record<string, unknown>>(
      `/${MENU_ID}/${SHEETS.MAIN}/SAVE/call-proc`,
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
