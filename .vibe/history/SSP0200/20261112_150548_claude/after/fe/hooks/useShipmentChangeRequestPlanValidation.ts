import { useCallback, useMemo } from 'react';

import { apiClient } from '@foundation/apis';
import dayjs from '@foundation/dayjs';
import { useTabLookupQueries } from '@shared/hooks';

import {
  CHANGE_REASON_NONE,
  CHANGE_TYPE_PLAN,
  COLUMN,
  COMBO,
  LBL,
  LOOKUP,
  MENU_ID,
  MSG,
} from '../shipment-change-request-plan.constants';
import type { RequestInfo } from '../shipment-change-request-plan.types';
import { str, type GridRowData } from '../utils/shipmentChangeRequestPlanDerive';

interface RequiredMiss {
  /** 라벨 i18n 코드 — AS-IS 는 LayoutControlItem.Text 를 그대로 메시지 인자로 썼다(cs:3329 등). */
  labelKey: string;
  defaultLabel: string;
  /** 항목별 메시지 코드. 콤보 미선택은 design 02 §4.7 지정 코드(MSG00429)를 쓴다. */
  msgId: string;
}

/**
 * 요청정보 필수 4항목 검사 (checkRequired cs:3322~3373 / L-115~L-118 / V-17).
 *   순서 보존: Approval -> Title -> Change Reason -> Reason Detail.
 *   메시지는 MSG00614/MSG00429 를 쓴다 — AS-IS 번호는 TO-BE 에서 뜻이 달라 재사용 금지(hook #114).
 */
export const checkRequestInfoRequired = (info: RequestInfo): RequiredMiss | null => {
  if (!info.approval.trim()) {
    return { labelKey: LBL.APPROVAL, defaultLabel: 'Approval', msgId: MSG.REQUIRED_VALUE };
  }
  if (!info.title.trim()) {
    return { labelKey: LBL.TITLE, defaultLabel: 'Title', msgId: MSG.REQUIRED_VALUE };
  }
  // cboChangeReason.SelectedIndex == 0 (= ALL 행) / '-' 더미 / 공백 전부 미선택으로 본다(§4.7).
  const reason = info.changeReason.trim();
  if (!reason || reason === 'ALL' || reason === CHANGE_REASON_NONE) {
    return {
      labelKey: LBL.CHANGE_REASON,
      defaultLabel: 'Change Reason',
      msgId: MSG.REQUIRED_COMBO,
    };
  }
  if (!info.reasonDetail.trim()) {
    return { labelKey: LBL.REASON_DETAIL, defaultLabel: 'Reason Detail', msgId: MSG.REQUIRED_VALUE };
  }
  return null;
};

/**
 * 요청 대상 수량 0 검증 — **detail(spdSub) 전용**이고 ChangeType 으로 분기한다
 * (AS-IS cs:3237~3271 / §4e #21·#22 / MSG00202 -> TO-BE MSG01213).
 *
 *  - ChangeType='P' : spdSub **전 행 합계**가 0 이면 차단(행별 검사 없음, cs:3241~3254).
 *  - 그 외(C/N)     : `NEW_YN='Y'` 행의 `NEW_SHIPMENT_CONFIRM_QTY` 가 0 이하면 차단(cs:3259~3269).
 *
 * master 행 수량 0 차단은 **AS-IS 에 없다** — 신설 가드였으므로 제거했다(2026-09-28).
 * 빈 값은 필수검증(`useSaveWithValidation`) 소관이라 여기서는 숫자만 본다
 *   (AS-IS 는 `Convert.ToDouble("")` 로 예외가 나는 자리다 — 조용한 통과가 아니라 다른 경로다).
 */
export const hasZeroQty = (subRows: GridRowData[], changeType: string): boolean => {
  const numberOf = (v: unknown): number | undefined => {
    const raw = str(v).trim();
    if (raw === '') return undefined;
    const num = Number(raw);
    return Number.isFinite(num) ? num : undefined;
  };
  if (changeType === CHANGE_TYPE_PLAN) {
    const total = subRows.reduce((sum, r) => sum + (numberOf(r[COLUMN.NEW_SHIPMENT_CONFIRM_QTY]) ?? 0), 0);
    return total === 0;
  }
  return subRows.some(r => {
    if (str(r[COLUMN.NEW_YN]) !== 'Y') return false;
    const qty = numberOf(r[COLUMN.NEW_SHIPMENT_CONFIRM_QTY]);
    return qty !== undefined && qty <= 0;
  });
};

// ====================================================================================
// 출하일 상·하한 (R-22 / validations #30·#33)
// ====================================================================================
const ymd8 = (v: unknown): string => str(v).replace(/\D/g, '').slice(0, 8);

/** AS-IS `dBaseDate = dtDate.Value.AddDays(dDay)`(cs:508) — dDay 는 음수(-56)이므로 하한이다. */
const baseDateOf = (changeReqDay: number) => dayjs().startOf('day').add(changeReqDay, 'day');

/**
 * 기준일수(dDay) 공급 — `CHANGE_REQ_DAY` lookup 1행의 NAME 열이다(AS-IS `dtBaseDay.Rows[0][1]`).
 *   MASTER 헤더가 SEGMENT1='CODE'/SEGMENT2='NAME' 라 응답 키가 CODE/NAME 이다(ora.py 실측).
 *   미조회·비수치면 `undefined` 를 돌려준다 — 임의 기본값(예 -56 하드코딩)으로 검증을 돌리지 않는다.
 */
export const useShipmentChangeRequestPlanBaseDay = (): number | undefined => {
  const [dayRows] = useTabLookupQueries({ filters: [{ lookupType: LOOKUP.CHANGE_REQ_DAY }] });
  return useMemo(() => {
    const first = (dayRows ?? [])[0];
    if (!first) return undefined;
    const value = Number(str(first.NAME ?? first.SEGMENT2 ?? ''));
    return Number.isFinite(value) ? value : undefined;
  }, [dayRows]);
};

/**
 * 셀 입력 하한 위반 (cs:6318 `if (dBaseDate > dDate)`) — 위반이면 호출부가 값을 비운다.
 *   기준일수를 모르면(`undefined`) 판정하지 않는다 — 조용히 통과시키는 것이 아니라 검증 미수행이다.
 */
export const isShipmentDateBelowBase = (value: unknown, changeReqDay?: number): boolean => {
  if (changeReqDay === undefined) return false;
  const digits = ymd8(value);
  if (digits.length !== 8) return false;
  const date = dayjs(digits, 'YYYYMMDD');
  return date.isValid() && date.isBefore(baseDateOf(changeReqDay));
};

export interface ShipDateViolation {
  msgId: string;
  defaultText: string;
  arg: string;
}

/**
 * 요청확정 출하일 상·하한 (cs:3271~3297) — detail 전 행의 `NEW_SHIPMENT_DATE` 기준.
 *   하한: `dBaseDate > dShipDate`            -> MSG01212(AS-IS MSG00201)
 *   상한: `dShipDate > 오늘 + |dDay|`         -> MSG01206(AS-IS MSG00194)
 *   날짜로 해석되지 않으면 AS-IS 는 `Convert.ToDateTime` 에서 예외가 난다 — TO-BE 는 같은 흐름의
 *   MSG01081(유효하지 않은 날짜 형식)로 명시 차단한다(조용한 skip 금지).
 */
export const checkRequestShipDates = (
  subRows: GridRowData[],
  changeReqDay?: number
): ShipDateViolation | null => {
  if (changeReqDay === undefined) return null;
  const arg = String(changeReqDay);
  const lower = baseDateOf(changeReqDay);
  const upper = dayjs().startOf('day').add(Math.abs(changeReqDay), 'day');

  for (const row of subRows) {
    const digits = ymd8(row[COLUMN.NEW_SHIPMENT_DATE]);
    const date = digits.length === 8 ? dayjs(digits, 'YYYYMMDD') : undefined;
    if (!date?.isValid()) {
      return {
        msgId: MSG.INVALID_DATE_FORMAT,
        defaultText: 'This is not a valid date format. {0}',
        arg: str(row[COLUMN.NEW_SHIPMENT_DATE]),
      };
    }
    if (date.isBefore(lower)) {
      return {
        msgId: MSG.SHIPMENT_DATE_BEFORE_BASE,
        defaultText: 'Current D + {0} days can not be requested.\nPlease delete and request again.',
        arg,
      };
    }
    if (date.isAfter(upper)) {
      return {
        msgId: MSG.SHIPMENT_DATE_UNDER_BASE,
        defaultText: 'Change requests are possible from the current D + {0} ship date.',
        arg,
      };
    }
  }
  return null;
};

/** 게이트 판정 3값 — 'clear'(차단 아님) / 'blocked'(차단) / 'unknown'(판정 불가). */
export interface ErpBlockResult {
  status: 'clear' | 'blocked' | 'unknown';
  period: string;
}

export const useShipmentChangeRequestPlanValidation = () => {
  /**
   * 저장 전 ERP 중단기간 게이트 (L-079/L-082/L-102 / V-13).
   *   AS-IS Data_SCP.Common(Type.SSPBlockCheckIF, false, "SSP0200") -> BLOCK_YN=='Y' 면 저장 전체 차단.
   *
   *   필수 파라미터는 `segment1` 이다 — CMBO 본문이
   *   `WHERE LOOKUP_TYPE='FUNCTION_BLOCK' AND SEGMENT1=@segment1` 라서 `mnuId` 를 보내면
   *   BE 가 @segment1 을 '' 로 치환해 0행이 되고 게이트가 영구 무발동한다(자매 SSP0202 는 segment1 전달).
   *   콤보 파라미터 인용은 getCombo 가 처리한다 — 화면이 따옴표를 붙이지 않는다.
   *
   *   0행/오류를 '차단 없음' 으로 확정하지 않고 'unknown' 으로 구분해 돌려준다(V-13 정직 판정).
   */
  const checkErpBlock = useCallback(async (): Promise<ErpBlockResult> => {
    try {
      const rows = await apiClient.getCombo({ comboId: COMBO.ERP_BLOCK, segment1: MENU_ID });
      const first = (rows ?? [])[0];
      // 0행 = 판정 근거 없음. FUNCTION_BLOCK 에 이 화면 행이 있어도 SEGMENT2/3 형식 문제로 조회가
      //   실패할 수 있다(실측 ORA-01830 — 메타 축 결함, 04 확인필요) → 'clear' 로 단정하지 않는다.
      if (!first) return { status: 'unknown', period: '' };
      const blockYn = first.BLOCK_YN ?? first.CODE ?? '';
      return {
        status: blockYn === 'Y' ? 'blocked' : 'clear',
        period: first.PERIOD ?? first.NAME ?? '',
      };
    } catch {
      return { status: 'unknown', period: '' };
    }
  }, []);

  return { checkErpBlock };
};
