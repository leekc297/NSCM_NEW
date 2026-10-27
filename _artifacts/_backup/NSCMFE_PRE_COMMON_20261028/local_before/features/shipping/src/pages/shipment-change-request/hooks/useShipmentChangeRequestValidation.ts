import { apiClient } from '@foundation/apis';
import dayjs from '@foundation/dayjs';
import { useTabLookupQueries } from '@shared/hooks';

import {
  FIXED_DIVISION,
  LOOKUP,
  MSG,
  PLAN_TYPE_PLAN,
  REQUIRED_MAIN_COLUMNS,
} from '../shipment-change-request.constants';
import type { RequestInfo } from '../shipment-change-request.types';
import { isEndCustomerDivision } from '../utils/shipmentChangeRequestEditLock';

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

const num = (v: unknown): number => {
  const n = Number(str(v).replace(/,/g, ''));
  return Number.isFinite(n) ? n : 0;
};

/**
 * 요청완료 차단 1건 — 메시지 코드와 **그 코드 전용 영문 fallback**, `{0}` 치환값을 함께 돌려준다.
 *   종전엔 `{ msg: 'QTY_ZERO' | … }` 키만 돌려주고 호출부가 3종에 `_Invalid.` 하나를 공유했다.
 *   코드가 미등록이면 그 한 문구만 떠서 어느 검증에 걸렸는지 알 수 없었다(사용자 신고 2026-10-13).
 */
export interface CompleteViolation {
  msgId: string;
  defaultText: string;
  /** `{0}` 치환값. i18next 보간({{}})이 아니라 **문자열 replace** 다 — 호출부가 치환한다. */
  arg?: string;
}

// SCM_ADM_MSG_M EN 실문구(ora.py 실측 2026-10-13) — 등록돼 있으므로 fallback 은 보험이다.
const QTY_ZERO_TEXT = 'Enter a number greater than 0.';
const DATE_UNDER_BASE_TEXT =
  'Current D + {0} days can not be requested.\nPlease delete and request again.';
const DATE_OVER_MAX_TEXT = 'Change requests are possible from the current D + {0} ship date.';
const INVALID_DATE_TEXT = 'This is not a valid date format. {0}';

// SSP0201 저장/변경요청 검증 (design 01 §2 R8/R14, roslyn validations 실측).
export const useShipmentChangeRequestValidation = () => {
  // dDay = CHANGE_REQ_DAY lookup 1행의 NAME 열(MASTER 헤더 SEGMENT1='CODE'/SEGMENT2='NAME' —
  //   ora.py 실측 CODE='D' / NAME='-56'). 출하일 하한·상한 계산 근거(design 01 R14 :2868).
  //   하드코딩 금지 — lookup 실값만 쓴다.
  //   **미조회·비수치면 `undefined`** 다. 종전엔 `num()` 으로 0 으로 떨어뜨려, 룩업이 아직 도착하지
  //   않은 순간에 하한=상한=오늘이 되어 **오늘이 아닌 모든 출하일이 차단**됐다(사용자 신고 2026-10-13
  //   "Request Complete 누르면 _Invalid."). 기준일수를 모르면 날짜 검증을 **수행하지 않는다**.
  const [changeReqDay] = useTabLookupQueries({ filters: [{ lookupType: LOOKUP.CHANGE_REQ_DAY }] });
  const dDay: number | undefined = (() => {
    const first = changeReqDay?.[0];
    if (!first) return undefined;
    const raw = str(first.NAME ?? (first as Record<string, unknown>).SEGMENT2 ?? '');
    if (!raw.trim()) return undefined;
    const value = Number(raw.replace(/,/g, ''));
    return Number.isFinite(value) ? value : undefined;
  })();

  // R8 화면레벨 ERP 차단 게이트 — SSPBlockCheckIF_SCP 조회, BLOCK_YN='Y'면 저장/변경요청 차단.
  //   저장/변경요청 mutate 직전에 호출(design 01 §2 R8 :2532). 조회 실패 시 안전하게 차단하지 않음
  //   (false-block 방지) — 대신 false 반환 후 저장 진행은 서버 SP 가 최종 방어.
  const checkErpBlock = async (divisionId: string): Promise<boolean> => {
    try {
      const rows = await apiClient.getCombo({
        comboId: 'SSPBlockCheckIF_SCP',
        divisionId: divisionId || FIXED_DIVISION,
      });
      return (rows ?? []).some(r => str(r.BLOCK_YN ?? (r as Record<string, unknown>).CODE) === 'Y');
    } catch {
      return false;
    }
  };

  // R14 변경요청 완료(BtnChangeRe) 필수 4항목 — 누락 시 첫 누락 필드 반환(MSG00002 alert).
  //   승인자(approval)/제목(title)/변경사유(changeReason)/사유상세(reasonDetail).
  const checkChangeRequestRequired = (info: RequestInfo): string | null => {
    if (!str(info.approval).trim()) return 'Approval';
    if (!str(info.title).trim()) return 'Title';
    if (!str(info.changeReason).trim()) return 'Change Reason';
    if (!str(info.reasonDetail).trim()) return 'Reason Detail';
    return null;
  };

  // GAP-01 라벨 `*` 9컬럼 필수 — INPUT_TP_CD 전건 'S'라 useSaveWithValidation(메타 M/IM)가 무동작이므로
  //   화면이 직접 빈값검사(design 03 §1.1/§4.4, checkRequiredOfSpread(siMain) L800 대체).
  //   Division 40/EE 상호배타(END_CUSTOMER vs PROJECT_CODE)로 미적용 컬럼은 필수에서 제외.
  //   저장 대상(dirty) 행에만 적용 — 기존행은 GET 로 이미 채워져 있고 신규행 입력분만 실효.
  const checkRequiredMainColumns = (rows: Record<string, unknown>[]): string | null => {
    for (const row of rows) {
      for (const col of REQUIRED_MAIN_COLUMNS) {
        if (col === 'END_CUSTOMER' && !isEndCustomerDivision(row)) continue;
        if (col === 'PROJECT_CODE' && isEndCustomerDivision(row)) continue;
        if (!str(row[col]).trim()) return col;
      }
    }
    return null;
  };

  // GAP-07 변경요청 완료 전 수량0 + 출하일 하한/상한 검증(design 01 R14, AS-IS SSP0201.cs 실측).
  //   Plan(changeType='P') 분기: NEW 수량합계==0 -> MSG00202. 그 외 분기: 신규(NEW_YN='Y') 중 수량0 -> MSG00202.
  //   출하일 하한: dBaseDate(오늘+dDay, dDay=CHANGE_REQ_DAY=-56) > NEW_SHIPMENT_DATE 이면 MSG00201(cs:2865).
  //   출하일 상한: NEW_SHIPMENT_DATE > dShipDateAfter(오늘+Abs(dDay)) 이면 MSG00194(cs:2874/2876).
  //     gap-resolve iter-1: AS-IS SSP0201.cs 실측으로 산식 확정 — `dShipDateAfter =
  //     DateTime.Now.AddDays(Math.Abs(dDay))`, `if (dShipDate > dShipDateAfter) MSG00194`. args=dDay(cs:2863).
  const checkCompleteQtyDate = (
    subRows: Record<string, unknown>[],
    changeType: string
  ): CompleteViolation | null => {
    if (changeType === PLAN_TYPE_PLAN) {
      const sum = subRows.reduce((s, r) => s + num(r.NEW_SHIPMENT_CONFIRM_QTY), 0);
      if (sum === 0) return { msgId: MSG.QTY_ZERO, defaultText: QTY_ZERO_TEXT };
    } else if (subRows.some(r => str(r.NEW_YN) === 'Y' && num(r.NEW_SHIPMENT_CONFIRM_QTY) === 0)) {
      return { msgId: MSG.QTY_ZERO, defaultText: QTY_ZERO_TEXT };
    }

    // 기준일수 미확보 시 날짜 검증 생략 — 임의 기본값(0·-56 하드코딩)으로 판정하지 않는다.
    if (dDay === undefined) return null;
    const arg = String(dDay);
    const dBaseDate = dayjs().startOf('day').add(dDay, 'day'); // 하한(오늘+dDay, dDay<0)
    const dShipDateAfter = dayjs().startOf('day').add(Math.abs(dDay), 'day'); // 상한(오늘+|dDay|)
    for (const r of subRows) {
      const ship = str(r.NEW_SHIPMENT_DATE);
      if (!ship) continue;
      // 'yyyy-MM-dd'·'yyyyMMdd' 혼재 — 숫자만 추려 8자리로 파싱한다(dayjs(문자열) 추론 의존 금지).
      const digits = ship.replace(/\D/g, '').slice(0, 8);
      const d = digits.length === 8 ? dayjs(digits, 'YYYYMMDD') : undefined;
      if (!d?.isValid()) {
        return { msgId: MSG.INVALID_DATE_FORMAT, defaultText: INVALID_DATE_TEXT, arg: ship };
      }
      if (dBaseDate.isAfter(d)) {
        return { msgId: MSG.DATE_UNDER_BASE, defaultText: DATE_UNDER_BASE_TEXT, arg };
      }
      if (d.isAfter(dShipDateAfter)) {
        return { msgId: MSG.DATE_OVER_MAX, defaultText: DATE_OVER_MAX_TEXT, arg };
      }
    }
    return null;
  };

  return {
    checkErpBlock,
    checkChangeRequestRequired,
    checkRequiredMainColumns,
    checkCompleteQtyDate,
  };
};
