import type { MonthColumnMeta } from '../demand-manager.types';

// ⭐ 월 컬럼 동적 산출 — AS-IS SetSpreadMonth 의 하드코딩(컬럼 11~154 은닉 후 필요분만 노출)을
//    조회 기간에서 계산하는 방식으로 대체한다. n번째로 보이는 월이 곧 Mn (SP 순번 별칭 규약).
//    AS-IS 는 컬럼을 144개로 가정했고 메타에는 M1~M143 이 등록돼 있으므로 그 범위를 넘지 않도록 자른다.
export const MAX_MONTH_COLUMNS = 143;

const isYm = (s: string): boolean => /^\d{6}$/.test(s);

/** yyyyMM 문자열을 한 달 더한 값으로 (dayjs 없이 순수 계산 — 로케일 비의존) */
const nextYm = (ym: string): string => {
  const y = Number(ym.slice(0, 4));
  const m = Number(ym.slice(4, 6));
  return m === 12 ? `${y + 1}01` : `${y}${String(m + 1).padStart(2, '0')}`;
};

/**
 * 조회 기간(yyyyMM ~ yyyyMM)에서 월 컬럼 메타를 만든다.
 * 기간이 비었거나 형식이 어긋나거나 시작이 종료보다 뒤면 빈 배열을 돌려준다(그리드는 고정 컬럼만 표시).
 */
export const buildMonthColumns = (from: string, to: string): MonthColumnMeta[] => {
  if (!isYm(from) || !isYm(to) || from > to) return [];
  const metas: MonthColumnMeta[] = [];
  let cur = from;
  while (cur <= to && metas.length < MAX_MONTH_COLUMNS) {
    metas.push({
      binding: `M${metas.length + 1}`,
      yyyymm: cur,
      year: cur.slice(0, 4),
      label: `${cur.slice(0, 4)}.${cur.slice(4, 6)}`,
    });
    cur = nextYm(cur);
  }
  return metas;
};

/** 월 컬럼 여부 (M1, M2, ... — 정적 컬럼과 구분) */
export const isMonthBinding = (binding: string): boolean => /^M\d+$/.test(binding);

/**
 * 수주 기간을 벗어난 월인지 판정한다.
 * AS-IS FindData 는 행의 수주 시작월보다 이르거나 종료월보다 늦은 월 칸을 0 으로 덮어썼다.
 * (AS-IS 는 반복 시작 인덱스가 한 칸 어긋나 첫 표시 월을 건너뛰었으나 여기서는 첫 월부터 동일 적용한다.)
 */
export const isOutOfOrderRange = (
  yyyymm: string,
  orderStart: string | undefined,
  orderEnd: string | undefined
): boolean => {
  if (!isYm(yyyymm)) return false;
  const s = String(orderStart ?? '');
  const e = String(orderEnd ?? '');
  if (!isYm(s) || !isYm(e)) return false;
  return yyyymm < s || yyyymm > e;
};
