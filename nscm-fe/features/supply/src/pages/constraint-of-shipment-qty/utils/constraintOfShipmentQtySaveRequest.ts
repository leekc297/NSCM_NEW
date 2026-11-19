// SCP0132 Constraint Of Shipment Qty 저장 — payload 조립 + 직접 POST + false-success 판별.
//   SAVE SP(PKG_SCP0132.P_SCP0132_SAVE_CONSTRAINT_OF_SHIPMENT_QTY)의 IN 파라미터는 전부
//   DATA_TP_CD='CLOB'(JVARCHAR 아님, PROC_M 실측 2026-10-14)이라 BE cvtJsonToJVarchar 의 ^-fold 가
//   발동하지 않는다(BaseService makeProcedure 가 CLOB 은 접지 않고 params.get(COL_NM) 을 그대로 바인드).
//   → 공용 useProcMutation({data:[rows]}) 로는 top-level 에 activeFlag/divisionId... camelCase 키가 없어
//     전부 null 바인딩되고 SP 는 SCM_ARR_SPL_CNT=0 으로 루프 0회·SUCCESS 를 반환하나 실제 저장은 조용히
//     no-op 된다(저장 성공 토스트는 뜨는데 DB 미반영). FE 가 미리 접은 스칼라를 camelCase COL_NM 키로
//     보내야 저장이 성립한다. 자매 정본 패턴: SCP0127 precedeSafetyStockDaySaveRequest.ts /
//     SCP0006 projectRoute.plantSaveRequest.ts / SCP0011 productionPlanLineSave.ts.

import { apiClient } from '@foundation/apis';
import type { EditTracker } from '@foundation/utils';
import { safeString } from '@foundation/utils';

import { MENU_ID, SHEETS } from '../constraint-of-shipment-qty.constants';

import { toYmd8 } from './constraint-of-shipment-qty.editLock';

export interface SaveResult {
  ok: boolean;
  message?: string;
}

// 커서 이름 · 칸 이름은 서버가 대소문자를 바꿔 내려줄 수 있어 대소문자 구분 없이 찾는다(SCP0128 저장 판정과 같음).
const pickIgnoreCase = (obj: unknown, ...keys: string[]): unknown => {
  if (!obj || typeof obj !== 'object') return undefined;
  const entries = Object.entries(obj as Record<string, unknown>);
  for (const key of keys) {
    const hit = entries.find(([k]) => k.toUpperCase() === key.toUpperCase());
    if (hit) return hit[1];
  }
  return undefined;
};

const firstRow = (cursor: unknown): unknown => (Array.isArray(cursor) ? cursor[0] : undefined);

// 저장 프로그램의 업무 거부 판정 — 서버는 프로그램 실행만 끝나면 응답 code 를 성공으로 쓰므로 결과 커서를 본다
//   (갭분석 C-20). O_RC1 RESULT_CODE 'S' 아님 또는 O_RESULT_CURSOR RESULT_CODE '0' 아님 = 거부.
//   AS-IS .cs:862~875 : 결과 S 가 아니면 저장 프로그램 문구를 표시하고 재조회하지 않는다.
const rejectedMessage = (result: unknown): string | undefined => {
  const head = firstRow(pickIgnoreCase(result, 'O_RESULT_CURSOR'));
  const headCode = safeString(pickIgnoreCase(head, 'RESULT_CODE')).trim();
  const rc1 = firstRow(pickIgnoreCase(result, 'O_RC1'));
  const rc1Code = safeString(pickIgnoreCase(rc1, 'RESULT_CODE')).trim();
  if ((headCode === '' || headCode === '0') && (rc1Code === '' || rc1Code === 'S')) {
    return undefined;
  }
  const message =
    safeString(pickIgnoreCase(head, 'RESULT_MESSAGE')).trim() ||
    safeString(pickIgnoreCase(rc1, 'RESULT_CNT')).trim();
  // 사용자 정의 오류 머리(ORA-20xxx: )는 떼어 업무 문구만 보인다. 그 밖의 오류는 그대로 둔다.
  return message.replace(/^ORA-20\d{3}:\s*/, '').trim() || 'Error';
};

// SAVE SP pre-image 복합키 4컬럼(SP 본문 UPDATE/DELETE WHERE 실측 .body:520~523) ↔ 그리드 UPPERCASE.
//   SCP_OPMZ_CONSTRAINT_OF_SHIPMENT_QTY 열쇠 = DIVISION_ID/OPMZ_PLAN_GR_ID/MDL_GR_NM/ITEM_ID.
//   WHERE 는 NVL(pre, C_NOMATCH) 로 self 를 집으므로 신규행(I)은 pre 를 비워 보낸다.

/**
 * 변경(I/M/D)된 행들을 SP 24개 CLOB IN 파라미터(^-delim)로 조립해 SAVE call-proc 호출.
 *   - activeFlag = row.CRUD_TYPE('I'/'M'/'D'). 신규행은 pre-image 4키를 비운다(중복체크 NOT 절·
 *     UPDATE/DELETE WHERE 가 NVL(pre, C_NOMATCH) 로 self 제외를 판정 — 신규행 pre 가 현재값이면 어긋난다).
 *   - pre* = 변경 전 원본 열쇠값(EditTracker originals, 미편집 키는 현재값). 키 컬럼을 편집해도
 *     UPDATE/DELETE 가 원본 행을 정확히 집는다.
 *   - userId 는 단일 스칼라(SP 가 SUBSTR(P_USER_ID) 한 번만 읽고 행별로 split 하지 않는다).
 */
export const submitConstraintOfShipmentQtySave = async <T extends WijmoRowItem>(
  changed: T[],
  tracker: EditTracker<T> | undefined,
  userId: string
): Promise<SaveResult> => {
  // 키 순서는 가독성용일 뿐 — BE 는 COL_NM 으로 바인드하므로 payload 는 순서 무관.
  const acc: Record<string, string[]> = {
    activeFlag: [],
    divisionId: [],
    opmzPlanGrId: [],
    mdlGrNm: [],
    itemId: [],
    stage: [],
    fromSteId: [],
    toSteId: [],
    fromYyyymmdd: [],
    toYyyymmdd: [],
    sipmMinQyt: [],
    sipmMaxQty: [],
    satSipmMinQty: [],
    satSipmMaxQty: [],
    sunSipmMinQty: [],
    sunSipmMaxQty: [],
    valTpCd: [],
    valueDescription: [],
    validYn: [],
    preDivisionId: [],
    preOpmzPlanGrId: [],
    preMdlGrNm: [],
    preItemId: [],
  };

  for (const row of changed) {
    const rec = row as Record<string, unknown>;
    const crud = safeString(rec.CRUD_TYPE); // 'I' | 'M' | 'D'
    const isInsert = crud === 'I';
    const originals = tracker?.getOriginalValues().get(row);
    // 신규행은 pre 를 비운다. 그 외에는 편집된 키만 원본으로, 미편집 키는 현재값으로 집는다.
    const preRaw = (binding: string): unknown =>
      originals && binding in originals ? originals[binding] : rec[binding];
    const preOf = (binding: string): string => (isInsert ? '' : safeString(preRaw(binding)));

    acc.activeFlag.push(crud);
    acc.divisionId.push(safeString(rec.DIVISION_ID));
    acc.opmzPlanGrId.push(safeString(rec.OPMZ_PLAN_GR_ID));
    acc.mdlGrNm.push(safeString(rec.MDL_GR_NM));
    acc.itemId.push(safeString(rec.ITEM_ID));
    acc.stage.push(safeString(rec.STAGE));
    acc.fromSteId.push(safeString(rec.FROM_STE_ID));
    acc.toSteId.push(safeString(rec.TO_STE_ID));
    // 날짜는 8자리 YYYYMMDD 로 접는다 — GET SP 는 TO_CHAR(...,'YYYY-MM-DD') 로 하이픈 포함 반환하고
    //   FPDate 편집은 Date 객체를 쓸 수 있으나, SAVE SP 는 받은 문자열을 변환 없이 컬럼에 넣는다. 하이픈째
    //   보내면 DB 오염 + (M/D 행) pre-image WHERE 가 원본 8자리와 불일치해 0건 처리된다.
    acc.fromYyyymmdd.push(toYmd8(rec.FROM_YYYYMMDD));
    acc.toYyyymmdd.push(toYmd8(rec.TO_YYYYMMDD));
    acc.sipmMinQyt.push(safeString(rec.SIPM_MIN_QYT));
    acc.sipmMaxQty.push(safeString(rec.SIPM_MAX_QTY));
    acc.satSipmMinQty.push(safeString(rec.SAT_SIPM_MIN_QTY));
    acc.satSipmMaxQty.push(safeString(rec.SAT_SIPM_MAX_QTY));
    acc.sunSipmMinQty.push(safeString(rec.SUN_SIPM_MIN_QTY));
    acc.sunSipmMaxQty.push(safeString(rec.SUN_SIPM_MAX_QTY));
    // VAL_TP_CD 는 SP 가 SAT/SUN 유무로 A/B 를 재산정해 덮으나(.body:428~438), AS-IS 파리티로 현재값도
    //   함께 보낸다(신규행 기본값 'A'는 SP 가 그대로 쓰거나 재산정). 그리드는 항상잠금이라 사용자 편집 없음.
    acc.valTpCd.push(safeString(rec.VAL_TP_CD));
    acc.valueDescription.push(safeString(rec.VALUE_DESCRIPTION));
    acc.validYn.push(safeString(rec.VALID_YN));

    acc.preDivisionId.push(preOf('DIVISION_ID'));
    acc.preOpmzPlanGrId.push(preOf('OPMZ_PLAN_GR_ID'));
    acc.preMdlGrNm.push(preOf('MDL_GR_NM'));
    acc.preItemId.push(preOf('ITEM_ID'));
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
    const rejected = rejectedMessage((res.data as { result?: unknown })?.result);
    if (rejected) return { ok: false, message: rejected };
    return { ok: true };
  } catch (e) {
    return { ok: false, message: e instanceof Error ? e.message : undefined };
  }
};
