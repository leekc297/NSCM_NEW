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

import { toYmd8Date } from './projectRouteWarranty.date';

export type WarrantySaveRow = MainRow;

export interface WarrantySaveResult {
  ok: boolean;
  message?: string;
}

// FROM/TO 는 그리드에서 Date(FPDate 편집)·조회직후 'YYYY-MM-DD' 문자열·8자리가 섞인다 — 전부
//   'YYYYMMDD' 로 되돌린다(Date→format, 문자열→숫자만). toYmd8Date 이 Date 를 함께 처리한다.
const ymd8 = (v: unknown) => (v instanceof Date ? toYmd8Date(v) : safeString(v).replace(/\D/g, ''));

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
    // 저장 원본은 PLANT_SITE_ID_B(design/03 col29) 지만, 신규행은 셀콤보 선택이 표시컬럼
    //   PLANT_SITE_ID 에만 쓰고 PLANT_SITE_ID_B 는 비어 있다(GET 조회행에만 존재). AS-IS(cs:566~570)
    //   는 PLANT_SITE_ID_B 가 비면 PLANT_SITE_ID 로 폴백한다 — 같은 폴백을 적용한다. 없으면 신규행
    //   plantSiteId 가 공백으로 저장돼 ORA-01407 로 롤백된다(2026-10-19 교정).
    const plantSiteB = safeString(rec.PLANT_SITE_ID_B);
    acc.plantSiteId.push(plantSiteB !== '' ? plantSiteB : safeString(rec.PLANT_SITE_ID));
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
    // false-success 1차 차단(nscm-patterns §5-10) — 공용 responseInterceptor 가 code!=0 /
    //   result.O_RESULT_CURSOR[0].CODE!=0 이면 throw 하고, 403/500 은 resolve 하므로 여기서 status 로 잡는다.
    // 한계(SCP0048 고유): SAVE SP(P_SCP0048_SAVE_PROJECTROUTE_WARRANTY)는 실패를 스칼라 OUT
    //   O_RESULT_CODE='F' 로만 돌려주는데, BE BaseService.selectList 가 '@'-커서 OUT 만 result 에 싣고
    //   스칼라 OUT 은 버린다(code 는 상시 '0'). 즉 SP 의 ROLLBACK(예: ORA-01407 PLANT_SITE_ID NOT NULL)은
    //   이 가드로 감지되지 않고 ok:true 로 통과한다 — 근본 해결은 BE 가 O_RESULT_CODE 를 노출해야 가능.
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
