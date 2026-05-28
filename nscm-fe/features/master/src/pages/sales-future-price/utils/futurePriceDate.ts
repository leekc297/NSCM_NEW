/**
 * DMF0020 SalesFuturePrice — 날짜 계산 유틸
 *
 * AS-IS: DMF0020_SalesFuturePrice.cs:3505 (GetThisWeekMonday) 등 보존.
 */
import dayjs, { type Dayjs } from '@foundation/dayjs';

import { BUCKET_TYPE, type BucketType } from '../sales-future-price.constants';

/** 주어진 날짜의 그 주 월요일을 반환. AS-IS .cs:3505 보존 (ISO 8601 — 월요일 시작). */
export const getThisWeekMonday = (date: Dayjs | Date | string): Dayjs => {
  const d = dayjs(date);
  const day = d.day(); // 0=Sun, 1=Mon, ..., 6=Sat
  const diff = day === 0 ? -6 : 1 - day;
  return d.add(diff, 'day').startOf('day');
};

/** YYYYMMDD 문자열을 Dayjs 로 변환. AS-IS .cs:1307 의 `int.Parse(sPeriod[0])` 비교 호환. */
export const parseYyyymmdd = (s: string): Dayjs => {
  if (!s) return dayjs();
  const cleaned = s.replace(/[-/]/g, '');
  return dayjs(cleaned, 'YYYYMMDD');
};

/** Dayjs 를 YYYYMMDD 로 포맷. */
export const formatYyyymmdd = (d: Dayjs | Date): string => dayjs(d).format('YYYYMMDD');

/**
 * Bucket 단위로 (from~to) 기간 정규화.
 * - WEEKLY: from 은 그 주 월요일로 보정, to 는 그 주 일요일.
 * - MONTHLY: from 은 그 달 1일, to 는 그 달 말일.
 */
export const normalizePeriodByBucket = (
  from: string,
  to: string,
  bucket: BucketType
): { periodFrom: string; periodTo: string } => {
  if (!from || !to) return { periodFrom: from, periodTo: to };
  const f = parseYyyymmdd(from);
  const t = parseYyyymmdd(to);
  if (bucket === BUCKET_TYPE.WEEKLY) {
    return {
      periodFrom: formatYyyymmdd(getThisWeekMonday(f)),
      periodTo: formatYyyymmdd(getThisWeekMonday(t).add(6, 'day')),
    };
  }
  return {
    periodFrom: formatYyyymmdd(f.startOf('month')),
    periodTo: formatYyyymmdd(t.endOf('month')),
  };
};
