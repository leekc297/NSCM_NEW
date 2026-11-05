import { apiClient } from '@foundation/apis';

import {
  ACTION,
  ERP_BLOCK_COMBO,
  FIXED_DIVISION,
  MENU_ID,
  SHEETS,
  SUB_COLUMN,
} from '../shipment-change-request-confirm.constants';
import { BTN } from '../utils/shipmentChangeRequestConfirmSave';

type Row = Record<string, unknown>;

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

/** `call-proc` 응답에서 지정 커서의 행 배열을 꺼낸다. */
const cursorRows = (data: unknown, key: string): Row[] =>
  ((data as { result?: Record<string, Row[]> } | undefined)?.result?.[key] ?? []);

/** 커서 첫 행의 첫 값(AS-IS `Tables[n].Rows[0][0]` 등가). 열 이름을 모를 때만 쓴다. */
const firstValue = (rows: Row[]): string => {
  const row = rows[0];
  return row ? str(Object.values(row)[0]) : '';
};

// SSP0202 승인/반려/자기반려 액션 서버체크 (design 01 §2 E2/E10/E11, roslyn validations 실측).
export const useShipmentChangeRequestConfirmActions = () => {
  // E2/E6/E12 ERP 차단 게이트 — SSPBlockCheckIF_SCP(@segment1='SSP0202'), BLOCK_YN='Y'면 차단(MSG00267->MSG01395).
  //   조회 실패 시 false(차단 안 함) — false-block 방지, 서버 SAVE SP 가 최종 방어(자매 SSP0201 동일).
  const checkErpBlock = async (divisionId: string): Promise<boolean> => {
    try {
      const rows = await apiClient.getCombo({
        comboId: ERP_BLOCK_COMBO,
        divisionId: divisionId || FIXED_DIVISION,
        segment1: MENU_ID,
      });
      return (rows ?? []).some(r => str(r.BLOCK_YN ?? (r as Record<string, unknown>).CODE) === 'Y');
    } catch {
      return false;
    }
  };

  /**
   * E10 `chkSaveYN` — SCS 실적 발생 Confirm ID 체크(AS-IS L1119~1175, 승인 전용).
   *   `P_SSP0202_GET_SCS_CONFIRM_ID_CHECK(p_confirm_id CLOB)` — 하위 전 행의 CONFIRM_ID 를
   *   **콤마(`,`)** 로 이어 보낸다(AS-IS L1126 — 저장 payload 의 `^` 와 구분자가 다르다).
   *   판정: `o_rc1` 또는 `o_rc2` 의 CNT > 0 이면 **차단**(MSG00362 -> TO-BE MSG01356).
   *
   *   반환 true = 차단. 조회 실패는 false(통과) — false-block 방지, 서버 SAVE 가 최종 방어다
   *   (checkErpBlock 과 같은 정책).
   */
  const checkScsConfirmId = async (subRows: Row[]): Promise<boolean> => {
    const confirmIds = subRows.map(r => str(r[SUB_COLUMN.CONFIRM_ID])).filter(Boolean);
    if (confirmIds.length === 0) return false;
    try {
      const res = await apiClient.post<Record<string, unknown>>(
        `/${MENU_ID}/${SHEETS.MAIN}/${BTN.SCS_CHECK}/call-proc`,
        { confirmId: confirmIds.join(',') }
      );
      const hit = (key: string) => Number(firstValue(cursorRows(res.data, key)) || 0) > 0;
      return hit('o_rc1') || hit('o_rc2');
    } catch {
      return false;
    }
  };

  /**
   * E11 `EngProcessingChk` — SSP 일일계획 처리중 체크(AS-IS L1081~1116, 승인 전용).
   *   `P_SSP0202_GET_SSP_PLAN_PROCESSING_CHECK(p_division_id VARCHAR2)`.
   *   판정: `o_rc1` 첫 행 1열 == 'Y' 면 처리중 **차단**, 2열이 남은 분(remain minute)이다
   *   (MSG00291 -> TO-BE MSG01294 `{0}` 에 들어간다).
   *
   *   반환: 차단이면 남은 분 문자열, 통과면 null. 조회 실패는 null(통과).
   */
  const checkPlanProcessing = async (divisionId: string): Promise<string | null> => {
    try {
      const res = await apiClient.post<Record<string, unknown>>(
        `/${MENU_ID}/${SHEETS.MAIN}/${BTN.PLAN_CHECK}/call-proc`,
        { divisionId: divisionId || FIXED_DIVISION }
      );
      const row = cursorRows(res.data, 'o_rc1')[0];
      if (!row) return null;
      const values = Object.values(row);
      if (str(values[0]).toUpperCase() !== 'Y') return null;
      return str(values[1]); // 남은 분
    } catch {
      return null;
    }
  };

  /**
   * E12 `GetErpIFCheck` — 저장 **직전** ERP I/F 적재 체크(AS-IS L966~1036).
   *   `P_SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK(changeRequestNo, changeStatus, timeZone, changeType)`.
   *   판정: `o_rc1` 의 `RESULT_CODE`(AS-IS `result_code`) == 'S' 면 통과, 아니면 중단.
   *
   *   `changeType` 변환(AS-IS L975~982): 원 타입이 'N' 이면 승인('A')→'P', 그 외→'C'. 'N' 이 아니면 원본 유지.
   *
   *   **주의 — 여기서 ERP 웹서비스를 호출하지 않는다.** AS-IS 의 `CallClient.FN_ERP_UIWebService(...)`
   *   (L1000~1028)는 **전면 주석** 상태라 미이식이 곧 패리티다(사용자 지시 2026-10-14 잔여 확정).
   *   이 함수는 동명의 **DB 프로시저**만 호출한다.
   *
   *   반환 true = 통과(저장 진행). 조회 실패는 true — 차단 축이 아니라 적재 체크라 막지 않는다.
   */
  const checkErpIf = async (params: {
    changeRequestNo: string;
    action: ACTION;
    changeType: string;
    timeZone: string;
  }): Promise<boolean> => {
    const changeType =
      params.changeType === 'N' ? (params.action === ACTION.APPROVAL ? 'P' : 'C') : params.changeType;
    try {
      const res = await apiClient.post<Record<string, unknown>>(
        `/${MENU_ID}/${SHEETS.MAIN}/${BTN.IF_CHECK}/call-proc`,
        {
          changeRequestNo: params.changeRequestNo,
          changeStatus: params.action,
          timeZone: params.timeZone,
          changeType,
        }
      );
      const row = cursorRows(res.data, 'o_rc1')[0];
      if (!row) return true;
      return str(row.RESULT_CODE ?? row.result_code).toUpperCase() === 'S';
    } catch {
      return true;
    }
  };

  return { checkErpBlock, checkScsConfirmId, checkPlanProcessing, checkErpIf };
};
