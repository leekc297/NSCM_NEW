// DMF0042 Exchange Rate 팝업 — 2단 헤더(YYYY/MM)의 월 컬럼 목록.
//   AS-IS DMF0042_ExchangeRatePopup.cs L222 InitSpread 는 헤더를 데이터 SP 가 아니라 별도
//   SP DMF0020_GET_EXCHANGE_POPUP_SPREAD_TITLE (SCM_SYS_CALENDAR_M 을 기간으로 GROUP BY) 로
//   만든다 = 환율이 등록 안 된 월도 컬럼이 선다. TO-BE 는 그 달력 왕복 대신 기간을 직접 나열한다.
//   금지: 조회 결과 행에서만 월을 모으는 것 — 데이터가 종료월 전에 끊기면 헤더도 잘린다.
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
