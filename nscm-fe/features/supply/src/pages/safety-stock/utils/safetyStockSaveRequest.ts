// SCP0128 Safety Stock 저장 — payload 조립 + 직접 POST + false-success 판별.
//   SAVE SP(PKG_SCP0128.P_SCP0128_SAVE_SAFETY_STOCK)의 IN 파라미터는 전부 DATA_TP_CD='CLOB'(JVARCHAR
//   아님)이라 BE cvtJsonToJVarchar 의 ^-fold 가 발동하지 않는다(BaseService makeProcedure 가 CLOB 은
//   접지 않고 params.get(COL_NM) 을 그대로 바인드).
//   → 공용 useProcMutation({data:[rows]}) 로는 top-level 에 activeFlag/divisionId... 키가 없어 전부
//     null 바인딩되고 SP 는 루프 0회로 SUCCESS 를 반환하나 실제 저장은 조용히 no-op 된다(자매 SCP0127
//     과 동일 결함 — 2026-10-12 확인). FE 가 미리 접은 스칼라를 camelCase COL_NM 키로 보내야 저장이
//     성립한다. 정본 패턴: SCP0006 projectRoute.plantSaveRequest.ts / SCP0011 productionPlanLineSave.ts.

import { apiClient } from '@foundation/apis';
import type { EditTracker } from '@foundation/utils';
import { safeString } from '@foundation/utils';

import { MENU_ID, SHEETS } from '../safety-stock.constants';

import { toYmd8 } from './safety-stock.util';

// FROM/TO 는 DB 에 8자리(YYYYMMDD)로 저장 — 현재값·pre-image 모두 'YYYYMMDD' 로 정규화해 WHERE 가
//   일치하게 한다. 그리드값은 Date(FPDate 편집)·조회직후 문자열·8자리가 섞이므로 toYmd8 이 전부
//   8자리로 되돌린다(Date→format, 문자열→숫자만 추려 앞 8자리 — 시각포함 14자리 오염도 차단).

export interface SaveResult {
  ok: boolean;
  message?: string;
}

// 커서 이름·칸 이름은 서버가 대소문자를 바꿔 내려줄 수 있어 대소문자 구분 없이 찾는다(자매 SCP0132 동형).
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

// 저장 프로그램의 업무 거부 판정 — 일부 SAVE SP(날짜 중복 등)는 예외를 자체 CATCH·ROLLBACK 하고 응답
//   envelope 는 code:"0"/message:"success" 그대로 둔 채 결과 커서에만 실패를 담는다(O_RC1 RESULT_CODE='F'
//   또는 O_RESULT_CURSOR RESULT_CODE≠'0'). envelope code 만 보면 성공 토스트가 떠 "거부됐는데 저장된
//   것처럼" 보인다(AS-IS SaveData 는 결과 S 가 아니면 문구 표시·재조회 안 함, .cs:855~871).
//   direct-post-saverequest-false-success-inner-cursor 메모리·자매 SCP0132 constraintOfShipmentQtySaveRequest 동형.
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

// SAVE SP 의 pre-image 복합키 8컬럼(UPDATE/DELETE WHERE) ↔ 그리드 UPPERCASE 컬럼명.
//   SCP_OPMZ_SAFETY_STOCK PK = DIVISION_ID/SCM_SITE_ID/OPMZ_PLAN_GR_ID/STAGE/ITEM_ID/VALUE_TYPE/
//   FROM_YYYYMMDD/TO_YYYYMMDD(safetyStockSaveValidation.ts §중복체크 실측과 일치).

/**
 * 변경(I/M/D)된 행들을 SP 21개 CLOB IN 파라미터(^-delim)로 조립해 SAVE call-proc 호출.
 *   - activeFlag = row.CRUD_TYPE('I'/'M'/'D'). 신규행은 pre-image 를 비워 보낸다.
 *   - pre* = 변경 전 원본 키값(EditTracker originals, 미변경 키는 현재값).
 *   - userId 는 단일 스칼라(SP 가 SUBSTR(P_USER_ID) 한 번만 읽고 행별로 split 하지 않는다).
 */
export const submitSafetyStockSave = async <T extends WijmoRowItem>(
  changed: T[],
  tracker: EditTracker<T> | undefined,
  userId: string
): Promise<SaveResult> => {
  const acc: Record<string, string[]> = {
    activeFlag: [],
    valueType: [],
    divisionId: [],
    opmzPlanGrId: [],
    scmSiteId: [],
    itemId: [],
    stage: [],
    fromYyyymmdd: [],
    toYyyymmdd: [],
    aplQty: [],
    valueDescription: [],
    validYn: [],
    preValueType: [],
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
    acc.valueType.push(safeString(rec.VALUE_TYPE));
    acc.divisionId.push(safeString(rec.DIVISION_ID));
    acc.opmzPlanGrId.push(safeString(rec.OPMZ_PLAN_GR_ID));
    acc.scmSiteId.push(safeString(rec.SCM_SITE_ID));
    acc.itemId.push(safeString(rec.ITEM_ID));
    acc.stage.push(safeString(rec.STAGE));
    acc.fromYyyymmdd.push(toYmd8(rec.FROM_YYYYMMDD));
    acc.toYyyymmdd.push(toYmd8(rec.TO_YYYYMMDD));
    acc.aplQty.push(safeString(rec.APL_QTY));
    acc.valueDescription.push(safeString(rec.VALUE_DESCRIPTION));
    acc.validYn.push(safeString(rec.VALID_YN));

    acc.preValueType.push(preOf('VALUE_TYPE'));
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
    // false-success 1차 차단 — 인터셉터가 500 도 resolve 하고, SP 가 예외를 re-raise 하면 result.code != 0.
    if (res.status >= 400 || Number(res.data?.code)) {
      const reason = (res.data as { message?: string })?.message?.trim();
      return { ok: false, message: reason };
    }
    // false-success 2차 차단 — SP 가 예외를 자체 CATCH·ROLLBACK 하면 envelope code 는 0 이라 결과 커서
    //   RESULT_CODE 로만 거부가 드러난다(날짜 중복 등). 이게 없으면 거부가 성공 토스트로 오표시된다.
    const rejected = rejectedMessage((res.data as { result?: unknown })?.result);
    if (rejected) return { ok: false, message: rejected };
    return { ok: true };
  } catch (e) {
    return { ok: false, message: e instanceof Error ? e.message : undefined };
  }
};
