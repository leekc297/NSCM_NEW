/**
 * 편집 기준일 — AS-IS SetEditList(.cs L9128~9138) 1:1:
 * "금주 월요일(sResultYYYYMMDD) 포함 이후 Day 는 Unlock 대상".
 */
export const thisWeekMondayYmd = (today = new Date()): string => {
  const d = new Date(today);
  d.setHours(0, 0, 0, 0);
  const dow = d.getDay(); // Sun=0
  d.setDate(d.getDate() + (dow === 0 ? -6 : -(dow - 1)));
  return `${d.getFullYear()}${String(d.getMonth() + 1).padStart(2, '0')}${String(
    d.getDate()
  ).padStart(2, '0')}`;
};

/** D_yyyymmdd binding 목록에서 편집가능(금주 월요일 이후) 일자만. */
export const editableDayColumnsOf = (dayBindings: string[], today = new Date()): string[] => {
  const cutoff = thisWeekMondayYmd(today);
  return dayBindings.filter(b => b.replace('D_', '') >= cutoff);
};
