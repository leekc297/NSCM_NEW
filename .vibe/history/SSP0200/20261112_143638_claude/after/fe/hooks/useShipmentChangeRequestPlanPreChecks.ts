import { useCallback } from 'react';

import { apiClient } from '@foundation/apis';
import { useSessionStore } from '@shared/stores';

import {
  BTN_GET_CHANGE_REQ_NO,
  BTN_GET_ERP_SO_NO_CNT,
  BTN_GET_SHIPMENT_STATUS,
  COLUMN,
  MENU_ID,
  MSG,
  RESULT_SUCCESS,
  SCREEN_TEXT,
  SHEETS,
} from '../shipment-change-request-plan.constants';
import { str, type GridRowData } from '../utils/shipmentChangeRequestPlanDerive';

type ProcResult = Record<string, Record<string, unknown>[] | undefined>;

const post = async (buttonCode: string, payload: Record<string, string>): Promise<ProcResult> => {
  const res = await apiClient.post<ProcResult>(
    `/${MENU_ID}/${SHEETS.MAIN}/${buttonCode}/call-proc`,
    payload
  );
  // 인터셉터가 500/403 도 resolve 한다 — 실패를 "0행" 으로 흡수하면 검증이 조용히 통과한다.
  if (res.status >= 400 || Number(res.data?.code)) throw new Error('call-proc failed');
  return res.data.result ?? {};
};

const cell = (row: Record<string, unknown> | undefined, index: number): string =>
  row ? str(Object.values(row)[index]) : '';

/** CONFIRM_ID 열만 콤마로 모은다 — AS-IS 는 역순 누적 후 마지막 콤마를 잘라냈다(cs:4110). */
const joinConfirmIds = (rows: Record<string, unknown>[] | undefined): string =>
  (rows ?? [])
    .map(r => str(r.CONFIRM_ID ?? r.confirm_id))
    .filter(Boolean)
    .reverse()
    .join(',');

export interface PreCheckFail {
  msgId: string;
  defaultText: string;
  arg: string;
}

/**
 * SaveButton 사전 서버검증 3종 + 요청번호 채번.
 *
 * 주의: AS-IS 는 이 3건을 **SaveButton(cs:845~930 -> GetERPInterface cs:3818)** 에서 부른다.
 *   요청확정(BtnChangeRe_Click cs:3213)에는 서버검증이 없다 — 직전 감사 리포트의 "요청확정에서
 *   재현" 기대는 AS-IS 축과 다르다. 여기서는 AS-IS 가 부르는 자리를 그대로 따른다.
 *
 * 도구 한계: 결과 커서 3개는 '조회되면 위반' 규약이다(0행 = 통과). 커서 별칭이 SP 별로 달라
 *   키 이름이 아니라 등장 순서(o_rc1/o_rc2/o_rc3)로 읽는다 — PROC_M 실측 순서와 일치한다.
 */
export const useShipmentChangeRequestPlanPreChecks = () => {
  const session = useSessionStore(s => s.session);

  /** 채번(cs:864~874) — 1행 1열 'S' 일 때 1행 2열이 변경요청번호다. 실패 시 빈 문자열. */
  const fetchChangeReqNo = useCallback(async (): Promise<string> => {
    try {
      const result = await post(BTN_GET_CHANGE_REQ_NO, { userId: String(session.userId ?? '') });
      const first = result.o_rc1?.[0];
      return cell(first, 0) === RESULT_SUCCESS ? cell(first, 1) : '';
    } catch {
      return '';
    }
  }, [session.userId]);

  /**
   * GetShipmentStatusChk(cs:4090) — 3커서 전부 "행이 있으면 위반".
   *   o_rc1 타 사용자 변경요청 / o_rc2 확정계획 삭제(Qty:0) / o_rc3 ERP DO 생성.
   *   호출 자체가 실패하면 통과로 보지 않는다 — AS-IS 는 catch 에서 false(= 저장 중단)를 돌려준다.
   */
  const checkShipmentStatus = useCallback(
    async (divisionId: string, confirmId: string): Promise<PreCheckFail | null> => {
      try {
        const result = await post(BTN_GET_SHIPMENT_STATUS, { divisionId, confirmId });
        if (result.o_rc1?.length) {
          return {
            msgId: MSG.OTHER_USER_REQUEST,
            defaultText:
              'ConfirmID exists when another user makes a request to change the shipment plan.\n[ CONFIRM ID : {0} ]',
            arg: joinConfirmIds(result.o_rc1),
          };
        }
        if (result.o_rc2?.length) {
          return {
            msgId: MSG.DELETED_CONFIRM_PLAN,
            defaultText:
              'Confirm ID has been deleted (Qty: 0).\nPlease check again and try again.\n[ Confirm ID : {0} ]',
            arg: joinConfirmIds(result.o_rc2),
          };
        }
        if (result.o_rc3?.length) {
          return {
            msgId: MSG.ERP_DO_CREATED,
            defaultText:
              'In ERP, DO is created and can not request change.\nPlease cancel the generated DO and request a change.',
            arg: joinConfirmIds(result.o_rc3),
          };
        }
        return null;
      } catch {
        // 사전검증 호출 자체가 실패 = 저장 중단(AS-IS catch 가 false 를 돌려준다).
        //   MSG00328('판가 미입력')은 SP 결과 'F' 전용이라 이 자리에서 재사용하지 않는다.
        return { msgId: SCREEN_TEXT.SAVE_FAILED, defaultText: 'Save failed.', arg: '' };
      }
    },
    []
  );

  /** GetErpSoNoCnt(cs:4155) — 1행 CNT. 실패 시 -1 로 구분해 "동수 통과" 오판을 막는다. */
  const fetchErpSoNoCnt = useCallback(
    async (divisionId: string, erpSoNo: string): Promise<number> => {
      try {
        const result = await post(BTN_GET_ERP_SO_NO_CNT, { divisionId, erpSoNo });
        const first = result.o_rc1?.[0];
        if (!first) return 0;
        const raw = str(first.CNT ?? first.cnt ?? Object.values(first)[0]);
        const num = Number(raw);
        return Number.isFinite(num) ? num : -1;
      } catch {
        return -1;
      }
    },
    []
  );

  /**
   * GetERPInterface 첫 루프(cs:3826~3875) 재현 — 변경행마다
   *   (1) 출하상태 3검사, (2) ERP_SO_NO 가 있으면 화면 건수와 DB 건수 일치 검사.
   *   EDIT_MAIN='Y' 인 행만 confirmId 를 넘기는 것도 AS-IS 그대로다(cs:3836).
   */
  const checkErpInterface = useCallback(
    async (changedRows: GridRowData[], allRows: GridRowData[]): Promise<PreCheckFail | null> => {
      for (const row of changedRows) {
        const divisionId = str(row[COLUMN.DIVISION_ID]);
        const confirmId =
          str(row[COLUMN.EDIT_MAIN]) === 'Y' ? str(row[COLUMN.CONFIRM_ID]) : '';
        const statusFail = await checkShipmentStatus(divisionId, confirmId);
        if (statusFail) return statusFail;

        const erpSoNo = str(row[COLUMN.ERP_SO_NO]).trim();
        if (!erpSoNo) continue;
        const dbCount = await fetchErpSoNoCnt(divisionId, erpSoNo);
        const sheetCount = allRows.filter(r => str(r[COLUMN.ERP_SO_NO]) === erpSoNo).length;
        if (dbCount !== sheetCount) {
          return {
            msgId: MSG.SO_PARTIAL_SELECT,
            defaultText:
              'Another case created with the same SO number exists.\nChanges must be made identically based on the SO number.\n[ SO NO : {0} ]',
            arg: erpSoNo,
          };
        }
      }
      return null;
    },
    [checkShipmentStatus, fetchErpSoNoCnt]
  );

  return { fetchChangeReqNo, checkShipmentStatus, fetchErpSoNoCnt, checkErpInterface };
};
