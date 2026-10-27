// 조회기간 초기값 계산 — AS-IS SetCalendar(SCP0100_Global_PSI_Report.cs:1317) → GetDayRange "MONTH"(.cs:1409~1423).
//   start = ScpUtils.GetPlanDateYearMonth(cboPlanDate)(= Plan Date 'YYYY-MM-DD' 의 '-' 제거 후 앞 6자리) + '01'
//   end   = GetPlanEndDate()(.cs:2029, HORIZON_END_DATE)
//   둘 다 있을 때만 "start:end" 를 만든다. 하나라도 비면 null — UsrDateRangePicker3.InitValue('') 는
//   Length>0 && ':' 조건을 못 넘어 기간을 바꾸지 않으므로(호출부는 기존 기간 유지).
export const planDayRange = (
  planStartYyyymmdd: string,
  planEndYyyymmdd: string
): { fromYyyymmdd: string; toYyyymmdd: string } | null => {
  const plan = planStartYyyymmdd.trim();
  const end = planEndYyyymmdd.trim();
  if (plan.length < 6 || !end) return null;
  return { fromYyyymmdd: `${plan.slice(0, 6)}01`, toYyyymmdd: end };
};

// 조회 시작일 > Plan 시작일 판정 — AS-IS DCalendar_ValueChanged(.cs:2010-2013) `if (dStart > dPlan)`.
//   YYYYMMDD 문자열은 사전식 비교가 날짜 대소와 같다. 둘 중 하나라도 비면 판정하지 않는다(false).
export const isStartAfterPlan = (fromYyyymmdd: string, planStartYyyymmdd: string): boolean => {
  const from = fromYyyymmdd.trim();
  const plan = planStartYyyymmdd.trim();
  return !!from && !!plan && from > plan;
};
