import { GUBUN, HEADER_COLORS, type Gubun } from '../demand-plan-waterfall.constants';

import { dynKindOf } from './waterfall.periods';

const pad2 = (n: number): string => String(n).padStart(2, '0');
const yyyymm = (d: Date): string => `${d.getFullYear()}${pad2(d.getMonth() + 1)}`;

/**
 * AS-IS 기준일 = **이번 주 월요일** (`DateTime.Today.AddDays(DayOfWeek.Monday - Today.DayOfWeek)`
 * — 0035 .cs:1839 / 0022 .cs:1962 / 0051 .cs:1238). C# DayOfWeek 과 JS getDay() 는 Sun=0 로 동일.
 */
export const mondayOf = (today: Date): Date => {
  const d = new Date(today.getFullYear(), today.getMonth(), today.getDate());
  d.setDate(d.getDate() + (1 - d.getDay()));
  return d;
};

export interface CurrentPeriodInput {
  gubun: Gubun;
  /** TITLE SP 순서 그대로의 기간 컬럼 binding (AS-IS 컬럼 순회 순서 = `check` 플래그 재현에 필요) */
  dynBindings: string[];
  /** 메인 SP o_rc2 의 ISO_WEEK (없으면 '' — W_ 주차 판정 불가) */
  isoWeek: string;
  today?: Date;
}

/**
 * 당기(당월·당주·당분기·당년) 버킷 헤더 = Green Bold 대상 binding.
 * AS-IS `SetSpreadColumn()` 의 `chkColor/chkMem == false` 분기 1:1
 *   MKT·SALES (0035 .cs:1873-1902 / 0022 .cs:2000-2029)
 *     M_ : tag.Substring(2) == 기준월(yyyymm)
 *     W_ : (ISO_WEEK == tag.Substring(8) && tag.Substring(2,6) == 기준월) 우선,
 *          그게 한 번도 안 맞았을 때만 `W_ + 오늘yyyyMM + ISO_WEEK` 대체 매칭
 *          (AS-IS `check` 플래그는 루프 밖 선언이라 **한 번 맞으면 이후 대체 매칭이 막힌다** — 그대로 재현)
 *   BIZ (0051 .cs:1271-1302) : M_ 당월 / Q_ `yyyy_q` 당분기 / Y_ 당년
 */
export const currentPeriodBindings = ({
  gubun,
  dynBindings,
  isoWeek,
  today = new Date(),
}: CurrentPeriodInput): Set<string> => {
  const base = mondayOf(today);
  const baseYm = yyyymm(base);
  const marked = new Set<string>();

  if (gubun === GUBUN.BIZ_PLAN) {
    const baseYear = String(base.getFullYear());
    const quarter = String(Math.ceil((base.getMonth() + 1) / 3));
    dynBindings.forEach(b => {
      const kind = dynKindOf(b);
      const tag = b.slice(2);
      if (kind === 'M') {
        if (tag === baseYm) marked.add(b);
      } else if (kind === 'Q') {
        if (tag === `${baseYear}_${quarter}`) marked.add(b);
      } else if (kind === 'Y') {
        if (tag === baseYear) marked.add(b);
      }
    });
    return marked;
  }

  const thisWeekTag = `W_${yyyymm(today)}${isoWeek}`;
  let check = false;
  dynBindings.forEach(b => {
    const kind = dynKindOf(b);
    if (kind === 'M') {
      if (b.slice(2) === baseYm) marked.add(b);
      return;
    }
    if (kind !== 'W') return;
    if (isoWeek !== '' && b.slice(8) === isoWeek && b.slice(2, 8) === baseYm) {
      marked.add(b);
      check = true;
      return;
    }
    if (!check && isoWeek !== '' && b === thisWeekTag) marked.add(b);
  });
  return marked;
};

/**
 * 주말 헤더 글자색 — AS-IS 는 TITLE SP 의 `DAY_CODE`('SAT'/'SUN')로 판정한다
 * (0035 .cs:568-570 `ColumnHeader.Cells[2, n].ForeColor = SAT ? Blue : Red`). 일자 컬럼(3단 leaf) 전용.
 */
export const weekendColorOf = (dayCode: string | null | undefined): string | null => {
  const code = String(dayCode ?? '').trim().toUpperCase();
  if (code === 'SAT') return HEADER_COLORS.SATURDAY;
  if (code === 'SUN') return HEADER_COLORS.SUNDAY;
  return null;
};
