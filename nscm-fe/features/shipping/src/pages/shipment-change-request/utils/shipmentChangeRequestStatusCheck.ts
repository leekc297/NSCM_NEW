import { apiClient } from '@foundation/apis';

import { BTN_STATUS_CHECK, MENU_ID, SHEETS } from '../shipment-change-request.constants';
import { FOLD } from './shipmentChangeRequestNewSave';

type Row = Record<string, unknown>;

const s = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

export interface ShipmentStatusBlock {
  /** 등록 MSG 코드(없으면 '' — defaultText 로 안내). */
  msgCode: string;
  /** MSG 미등록 시 영문 fallback. `{0}` = CONFIRM_ID 목록(호출부 수동 치환). */
  defaultText: string;
  /** 차단 사유가 된 CONFIRM_ID 목록(콤마). */
  confirmIds: string;
}

/**
 * 저장 전 출하상태 재검사 — AS-IS `GetShipmentStatusChk`(cs:3416 호출 / 3558~3616 본문) 이식.
 *
 *   `SSP0201_GET_SHIPMENT_STATUS`(PKG_SSP0201.P_SSP0201_GET_SHIPMENT_STATUS)가 **3 결과셋**으로
 *   저장을 막을 CONFIRM_ID 를 돌려준다:
 *     o_rc1 = 다른 사용자가 이미 변경요청(MSG00248)
 *     o_rc2 = 확정계획 삭제 Qty:0(MSG00249)
 *     o_rc3 = ERP DO 생성 erp_status='C'(MSG00189 -> TO-BE MSG01202)
 *   하나라도 있으면 저장 차단. AS-IS 는 3건을 각각 알리지만 **우선순위(①→②→③) 첫 사유** 하나로
 *   막아도 충분하므로 그 하나를 돌려준다. 전부 비면 null(통과).
 *
 *   call-proc 응답 커서는 `res.data.result.o_rc1/2/3` 에 온다(readResultCode 규약과 동일 — 저 util 은
 *   o_rc1 에서 RESULT_CODE 를 읽지만, 이 SELECT SP 의 o_rc1~3 은 차단 CONFIRM_ID 데이터셋이다).
 *   payload 키는 PROC_M COL_NM(divisionId/confirmId) 그대로다.
 */
export const checkShipmentStatus = async (
  divisionId: string,
  confirmIds: string[]
): Promise<ShipmentStatusBlock | null> => {
  // SP 가 STRING_SPLIT(P_CONFIRM_ID, '^') 로 나누므로 **'^'(FOLD)** 로 묶는다. ',' 로 묶으면 2건 이상이
  //   한 값('A,B')으로 비교돼 0행 → 검사가 조용히 통과한다(SO 전파로 다건이 되는 바로 그 경우가 샌다).
  const confirmId = [...new Set(confirmIds.filter(Boolean))].join(FOLD);
  if (!confirmId) return null; // 검사할 CONFIRM_ID 없음(신규행만 등) = 통과

  const res = await apiClient.post<Record<string, unknown>>(
    `/${MENU_ID}/${SHEETS.MAIN}/${BTN_STATUS_CHECK}/call-proc`,
    { divisionId, confirmId }
  );
  const result = (res.data as { result?: Record<string, Row[]> } | undefined)?.result;
  const idsOf = (rows: Row[] | undefined): string =>
    [...new Set((rows ?? []).map(r => s(r.CONFIRM_ID)).filter(Boolean))].join(', ');

  const otherUser = idsOf(result?.o_rc1);
  if (otherUser) {
    return {
      msgCode: '', // MSG00248 TO-BE 미등록 — fallback 문구 사용
      defaultText: 'Another user has requested a shipment plan change. [ CONFIRM ID : {0} ]',
      confirmIds: otherUser,
    };
  }
  const deleted = idsOf(result?.o_rc2);
  if (deleted) {
    return {
      msgCode: '', // MSG00249 TO-BE 미등록 — fallback 문구 사용
      defaultText:
        'A confirmed plan was deleted (Qty:0). Please re-query and try again. [ CONFIRM ID : {0} ]',
      confirmIds: deleted,
    };
  }
  const erpLocked = idsOf(result?.o_rc3);
  if (erpLocked) {
    return {
      msgCode: 'MSG01202', // AS-IS MSG00189 등가 — ERP DO 생성 변경 차단
      defaultText: 'In ERP, DO is created and cannot request change. [ CONFIRM ID : {0} ]',
      confirmIds: erpLocked,
    };
  }
  return null;
};
