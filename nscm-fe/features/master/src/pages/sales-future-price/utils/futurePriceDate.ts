// AS-IS DMF0020_SalesFuturePrice.cs L3505 GetThisWeekMonday + Form_Load PR_GET_DAY_RANGE
//   (1) 이번 주 월요일 — Sunday 면 -6 / 그 외 -(dayOfWeek-1)
//   (2) YYYYMMDD ↔ Date 변환
//   (3) Period 역전 가드 (start > end → MSG00108)

export const yyyymmddOf = (d: Date): string =>
  `${d.getFullYear()}${String(d.getMonth() + 1).padStart(2, '0')}${String(d.getDate()).padStart(2, '0')}`;

export const fromYyyymmdd = (s: string): Date | null => {
  if (!/^\d{8}$/.test(s)) return null;
  const y = Number(s.slice(0, 4));
  const m = Number(s.slice(4, 6)) - 1;
  const d = Number(s.slice(6, 8));
  const dt = new Date(y, m, d);
  return Number.isNaN(dt.getTime()) ? null : dt;
};

// AS-IS .cs L3505 — DayOfWeek.Monday 일 때 그대로, Sunday(0) 면 -6, 그 외 -(d-1)
export const thisWeekMonday = (today = new Date()): Date => {
  const d = today.getDay();
  const offset = d === 0 ? -6 : -(d - 1);
  const monday = new Date(today);
  monday.setDate(today.getDate() + offset);
  return monday;
};

// Period 역전 체크 — AS-IS L1307 if (int.Parse(sPeriod[0]) > int.Parse(sPeriod[1])) MSG00108
export const isPeriodInverted = (start: string, end: string): boolean =>
  /^\d{8}$/.test(start) && /^\d{8}$/.test(end) && start > end;

// 조회 기간(YYYYMM 또는 YYYYMMDD)의 모든 월을 YYYYMM 으로 나열.
//   용도: Exchange Rate 팝업 2단 헤더를 "데이터가 있는 월"이 아니라 "조회한 기간"으로 만들기 위함.
//   근거: AS-IS DMF0042_ExchangeRatePopup.cs L222 InitSpread 는 헤더를 데이터 SP 가 아니라 별도
//     SP DMF0020_GET_EXCHANGE_POPUP_SPREAD_TITLE (SCM_SYS_CALENDAR_M 을 기간으로 GROUP BY) 로
//     만든다 = 환율이 등록 안 된 월도 컬럼이 선다. TO-BE 는 그 달력 왕복 대신 기간을 직접 나열한다.
//   데이터가 종료월보다 앞에서 끊기면 헤더도 중간에서 잘리던 문제 방어.
//   방어: 잘못된 입력(역전/형식 불일치)은 빈 배열, 과도 기간은 MAX_PERIOD_MONTHS 에서 절단.
const MAX_PERIOD_MONTHS = 600;

export const enumerateYyyymm = (start: string, end: string): string[] => {
  const s = (start ?? '').slice(0, 6);
  const e = (end ?? '').slice(0, 6);
  if (!/^\d{6}$/.test(s) || !/^\d{6}$/.test(e) || s > e) return [];
  let y = Number(s.slice(0, 4));
  let m = Number(s.slice(4, 6));
  const endMonth = Number(e.slice(4, 6));
  if (m < 1 || m > 12 || endMonth < 1 || endMonth > 12) return [];

  const keys: string[] = [];
  for (let i = 0; i < MAX_PERIOD_MONTHS; i++) {
    const cur = `${y}${String(m).padStart(2, '0')}`;
    if (cur > e) break;
    keys.push(cur);
    m += 1;
    if (m > 12) {
      m = 1;
      y += 1;
    }
  }
  return keys;
};
