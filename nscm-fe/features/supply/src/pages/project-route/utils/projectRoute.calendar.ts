import type { FlexGridColumnConfig } from '@foundation/models';

import { DYN_MONTH_PREFIX } from '../project-route.constants';

// SCP0006 Main 시트 동적 월 컬럼(design/02 SetCalendar / design/03 §2).
//   AS-IS 는 CalendarMonth CommonData 로 From~To 월 컬럼을 생성한다. TO-BE 는 조회조건 Period
//   범위(YYYYMM)에서 컬럼 집합을 파생하고 SITE GET 응답의 M_YYYYMM key 값을 매핑한다(데이터 아닌
//   조회조건 파생 계약). 컬럼 재빌드 트리거 = Period From/To 변경.

/** From~To(YYYYMM, inclusive) 월 목록. 비정상 입력이면 빈 배열(그리드 정적 컬럼만). */
export const monthsInRange = (fromYyyymm: string, toYyyymm: string): string[] => {
  if (!/^\d{6}$/.test(fromYyyymm) || !/^\d{6}$/.test(toYyyymm)) return [];
  const toIdx = (ym: string): number => {
    const y = Number(ym.slice(0, 4));
    const m = Number(ym.slice(4, 6));
    return y * 12 + (m - 1);
  };
  const start = toIdx(fromYyyymm);
  const end = toIdx(toYyyymm);
  if (end < start) return [];
  const out: string[] = [];
  for (let i = start; i <= end; i++) {
    const y = Math.floor(i / 12);
    const m = (i % 12) + 1;
    out.push(`${y}${String(m).padStart(2, '0')}`);
  }
  return out;
};

/** 월 목록 → DataGrid dynamicColumns(binding=M_YYYYMM, header=YYYY-MM, numeric read-only). */
export const buildMonthColumns = (
  fromYyyymm: string,
  toYyyymm: string
): FlexGridColumnConfig[] =>
  monthsInRange(fromYyyymm, toYyyymm).map(ym => ({
    binding: `${DYN_MONTH_PREFIX}${ym}`,
    header: `${ym.slice(0, 4)}-${ym.slice(4, 6)}`,
    align: 'right',
    format: 'n0',
    width: 75,
    allowSorting: false,
    allowMerging: false,
    visible: true,
  }));
