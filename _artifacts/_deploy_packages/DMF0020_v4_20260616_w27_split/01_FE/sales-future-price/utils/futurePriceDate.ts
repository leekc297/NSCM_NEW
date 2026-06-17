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
