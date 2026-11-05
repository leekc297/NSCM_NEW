import { apiClient } from '@foundation/apis';
import { CRUD_TYPE } from '@foundation/constants';
import dayjs from '@foundation/dayjs';
import { useTabLookupQueries } from '@shared/hooks';

import {
  LOOKUP,
  MENU_ID,
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

// 'yyyy-MM-dd'·'yyyyMMdd' 혼재 문자열 -> dayjs(8자리). 파싱 불가면 undefined
//   (dayjs(문자열) 추론 의존 금지 — 숫자만 추려 8자리로 파싱).
const parseYmd8 = (v: unknown): ReturnType<typeof dayjs> | undefined => {
  const digits = str(v).replace(/\D/g, '').slice(0, 8);
  if (digits.length !== 8) return undefined;
  const d = dayjs(digits, 'YYYYMMDD');
  return d.isValid() ? d : undefined;
};

// C7 저장 시 출하일 조회구간 검증 — AS-IS SSP_Main_Validation(cs:3173-3178 수정행 / 3383-3388 신규행,
//   MSG00359 -> TO-BE MSG01353). 저장 대상 행의 SHIPMENT_DATE 가 조회 Period[from,to] 밖이면 true.
//   from/to = store Period(YYYYMMDD, SCM0001_GET_SCP_DAY_PERIOD 산출). 둘 중 하나라도 없으면 검증 생략
//   (근사 대체 금지 — dDay 미확보 시 날짜검증 생략과 같은 축). 비교는 inclusive(경계 포함).
//   AS-IS 는 SHIPMENT_DATE(그리드 셀)를 읽는다 — NEW_SHIPMENT_DATE 아님(파생 생략 시 stale 회피).
//   파싱 불가분은 건너뛴다 — 날짜형식 오류는 완료 경로(checkCompleteQtyDate INVALID_DATE_FORMAT) 소관.
//   hook 상태(dDay·룩업)에 의존하지 않는 순수 함수라 모듈 레벨로 두고 테스트한다.
export const checkShipmentDateInPeriod = (
  rows: Record<string, unknown>[],
  fromYyyymmdd: string,
  toYyyymmdd: string
): boolean => {
  const from = parseYmd8(fromYyyymmdd);
  const to = parseYmd8(toYyyymmdd);
  if (!from || !to) return false;
  for (const r of rows) {
    const d = parseYmd8(r.SHIPMENT_DATE);
    if (!d) continue;
    if (d.isBefore(from, 'day') || d.isAfter(to, 'day')) return true;
  }
  return false;
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

/** ERP 차단게이트 판정 3값 — 'clear'(차단 아님) / 'blocked'(차단) / 'unknown'(판정 불가). */
export interface ErpBlockResult {
  status: 'clear' | 'blocked' | 'unknown';
  /** 차단기간 안내 문구(BLOCK_YN='Y' 행의 PERIOD/NAME). 'blocked' 외에는 ''. */
  period: string;
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
  const [shipPeriodDay, changeReqDay] = useTabLookupQueries({
    filters: [{ lookupType: LOOKUP.SHIPMENT_PERIOD_DAY }, { lookupType: LOOKUP.CHANGE_REQ_DAY }],
  });
  const dDay: number | undefined = (() => {
    const first = changeReqDay?.[0];
    if (!first) return undefined;
    const raw = str(first.NAME ?? (first as Record<string, unknown>).SEGMENT2 ?? '');
    if (!raw.trim()) return undefined;
    const value = Number(raw.replace(/,/g, ''));
    return Number.isFinite(value) ? value : undefined;
  })();

  // 저장 시 출하일 허용범위 [오늘-'2D-', 오늘+'1D+'] — SHIPMENT_PERIOD_DAY lookup(CODE/NAME) 실값.
  //   AS-IS cs:490 dateMax/MinShipDate(=inner-table VALUE) 등가. 자매 SSP0200 shipDateRange 미러.
  //   lookup 미도착·비수치면 undefined(임의 기본값으로 전건 차단 방지 — checkShipDateInRange 가 검사 생략).
  const shipDateRange: { max: ReturnType<typeof dayjs>; min: ReturnType<typeof dayjs> } | undefined =
    (() => {
      const rows = (shipPeriodDay ?? []) as Record<string, unknown>[];
      const dayOf = (code: string): number | undefined => {
        const r = rows.find(x => str(x.CODE ?? (x).SEGMENT1).trim() === code);
        if (!r) return undefined;
        const raw = str(r.NAME ?? (r).SEGMENT2 ?? '');
        const n = Number(raw.replace(/,/g, ''));
        return raw.trim() && Number.isFinite(n) ? n : undefined;
      };
      const plus = dayOf('1D+');
      const minus = dayOf('2D-');
      if (plus === undefined || minus === undefined) return undefined;
      const today = dayjs().startOf('day');
      return { max: today.add(plus, 'day'), min: today.subtract(minus, 'day') };
    })();

  // R8 화면레벨 ERP 차단 게이트 — SSPBlockCheckIF_SCP 조회, BLOCK_YN='Y'면 저장/변경요청 차단.
  //   저장/변경요청 mutate 직전에 호출(design 01 §2 R8 :2532).
  //
  //   필수 파라미터는 `segment1`(=화면ID) 다 — 콤보 본문이
  //   `WHERE LOOKUP_TYPE='FUNCTION_BLOCK' AND SEGMENT1=@segment1` 라서 divisionId 를 보내면
  //   BE 가 @segment1 을 '' 로 치환해 0행이 되고 게이트가 **영구 무발동**한다(04 GAP-ERP-BIND,
  //   자매 3화면 SSP0200/0202/0003 은 전부 segment1 전달). getCombo 는 segment1 을 자동주입하지
  //   않으므로(axios.ts getCombo) 화면이 명시 전달한다. divisionId 는 이 콤보가 쓰지 않아 넘기지 않는다.
  //
  //   0행/오류를 '차단 없음'(clear)으로 확정하지 않고 'unknown'으로 구분한다(false-clear 제거, SSP0200
  //   미러) — SEGMENT2 시각포함 ↔ 콤보 TO_DATE('YYYY-MM-DD') 마스크 불일치(ORA-01830, GAP-ERP-DATEFMT,
  //   공용 콤보)로 조회가 실패할 수 있어, 조용히 통과시키지도 영구 차단하지도 않고 호출부가 고지 후 진행한다.
  const checkErpBlock = async (): Promise<ErpBlockResult> => {
    try {
      const rows = await apiClient.getCombo({ comboId: 'SSPBlockCheckIF_SCP', segment1: MENU_ID });
      const first = (rows ?? [])[0];
      if (!first) return { status: 'unknown', period: '' };
      const blockYn = str(first.BLOCK_YN ?? first.CODE);
      return {
        status: blockYn === 'Y' ? 'blocked' : 'clear',
        period: str(first.PERIOD ?? first.NAME),
      };
    } catch {
      return { status: 'unknown', period: '' };
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

  // GAP: 저장 시 **수정행만** SoldTo/ShipTo 빈값 검사(AS-IS SSP_Main_Validation_SoldTo_ShipTo cs:3096-3122,
  //   호출 cs:3151 — StringAction=="M" 분기에서만 호출). 신규행(CRUD_TYPE='I')은 제외 — AS-IS 가 "I" 분기
  //   (cs:3375 위)에서 이 검사를 주석/미호출하고, SoldTo/ShipTo 는 잠금·파생 컬럼이라서다(사용자 확인
  //   2026-10-27). SoldTo/ShipTo 는 GET 응답에 실존(TO_SITE_SOLDTO_CODE/TO_SITE_SHIPTO_CODE, BE log 실측)
  //   하나 화면 미표시·사용자 편집 불가라, 마스터 데이터가 비어 있으면 변경요청 자체를 막는 무결성 게이트다.
  //   첫 위반 컬럼의 라벨을 반환(없으면 null) — 호출부가 REQUIRED_FIELD(MSG00614)로 안내.
  const firstModifiedRowMissingSoldtoShipto = (rows: Record<string, unknown>[]): string | null => {
    for (const row of rows) {
      if (str(row.CRUD_TYPE) !== CRUD_TYPE.MODIFY) continue; // 수정행만 (신규 'I'·삭제 'D'·무변경 제외)
      if (!str(row.TO_SITE_SOLDTO_CODE).trim()) return 'Sold To';
      if (!str(row.TO_SITE_SHIPTO_CODE).trim()) return 'Ship To';
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
      const d = parseYmd8(ship);
      if (!d) {
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

  // GAP: 저장 시 출하일 허용범위 검사(AS-IS SSP_Main_Validation cs:3165 수정행 / cs:3368 신규행, MSG00194).
  //   dirty(수정·신규) 행의 SHIPMENT_DATE 가 [min,max] 밖이면 위반 — 반환 { dDay }=메시지 {0} 치환값
  //   (AS-IS args=dDay=CHANGE_REQ_DAY). 범위 미확보(lookup 미도착)면 null(검사 생략). 파싱불가 행은 건너뛴다.
  //   C7(조회구간 MSG00359, checkShipmentDateInPeriod)과 별개 축 — 조회기간을 과거로 넓혀 C7 을 통과하는
  //   범위밖(오늘-56~-31) 출하일을 여기서 막는다(지적 2026-10-27). AS-IS 는 완료가 아닌 **저장** 때 건다.
  const checkShipDateInRange = (rows: Record<string, unknown>[]): { dDay: string } | null => {
    if (!shipDateRange) return null;
    for (const r of rows) {
      const d = parseYmd8(r.SHIPMENT_DATE);
      if (!d) continue;
      if (d.isAfter(shipDateRange.max, 'day') || d.isBefore(shipDateRange.min, 'day')) {
        return { dDay: dDay !== undefined ? String(dDay) : '' };
      }
    }
    return null;
  };

  return {
    checkErpBlock,
    checkChangeRequestRequired,
    checkRequiredMainColumns,
    firstModifiedRowMissingSoldtoShipto,
    checkCompleteQtyDate,
    checkShipmentDateInPeriod,
    checkShipDateInRange,
  };
};
