// 동적 PIVOT 월 컬럼(AS-IS SCP0049_GET_SHEET_CALENDAR_POPUP — 당월부터 +41개월). SP 미배포라
//   SCP0006 utils/projectRoute.calendar.ts 와 동일하게 클라 계산으로 근사한다(SP 연결 후
//   FROM_VALUE/서버 캘린더 기준으로 교정 필요 — TODO).
import type { FlexGridColumnConfig } from '@foundation/models';

import { CALENDAR_MONTHS_SPAN, DYN_MONTH_PREFIX } from './capa-new-model-popup.constants';

const toIdx = (yyyymm: string): number => {
  const y = Number(yyyymm.slice(0, 4));
  const m = Number(yyyymm.slice(4, 6));
  return y * 12 + (m - 1);
};
const toYyyymm = (idx: number): string =>
  `${Math.floor(idx / 12)}${String((idx % 12) + 1).padStart(2, '0')}`;

/** 당월(todayYyyymm) ~ +span 개월(YYYYMM, inclusive) 목록. */
export const monthsFromToday = (
  todayYyyymm: string,
  span: number = CALENDAR_MONTHS_SPAN
): string[] => {
  if (!/^\d{6}$/.test(todayYyyymm)) return [];
  const start = toIdx(todayYyyymm);
  const out: string[] = [];
  for (let i = 0; i <= span; i++) out.push(toYyyymm(start + i));
  return out;
};

/** 월 목록 → DataGrid dynamicColumns(binding=M_YYYYMM, PRIORITY 1~9 편집). */
export const buildCapaMonthColumns = (todayYyyymm: string): FlexGridColumnConfig[] =>
  monthsFromToday(todayYyyymm).map(ym => ({
    binding: `${DYN_MONTH_PREFIX}${ym}`,
    header: `${ym.slice(0, 4)}-${ym.slice(4, 6)}`,
    align: 'right',
    format: 'n0',
    width: 60,
    allowSorting: false,
    allowMerging: false,
    visible: true,
  }));
