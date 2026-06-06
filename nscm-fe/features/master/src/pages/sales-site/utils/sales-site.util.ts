import type { EditTracker } from '@foundation/utils';

import type { MENU_ID, SHEETS } from '../sales-site.constants';

const DAY_MAP = [
  { key: 'D_MON', label: 'MON' },
  { key: 'D_TUE', label: 'TUE' },
  { key: 'D_WED', label: 'WED' },
  { key: 'D_THU', label: 'THU' },
  { key: 'D_FRI', label: 'FRI' },
  { key: 'D_SAT', label: 'SAT' },
  { key: 'D_SUN', label: 'SUN' },
];

// TODO: DB에서 받는 데이터 형식에 따라 필요없을 수 있음, 삭제 필요 - 강민재
export const expandByDayOfWeek = <T extends WijmoRowItem>(item: T): T[] => {
  return DAY_MAP.filter(day => item[day.key as keyof T] !== undefined).map(day => ({
    ...item,
    YYYYMMDD: day.label,
    BUCKET_PER: item[day.key as keyof T] as string,
  }));
};

const buildSalesSite = (row: WijmoRowItem) => {
  const soldToCustomer = String(row['SOLDTO_CUSTOMER'] ?? '').trim();
  const country = String(row['COUNTRY'] ?? '')
    .trim()
    .slice(0, 2);
  // ⭐ B4 fix (Phase 7 적용, 2026-06-04): DB SCM_MST_SITE.CITY 가 5-char 합성 코드
  //    (Country prefix 2 chars + City code 3 chars — 예: 'JPHIU' = JP+HIU, 'CNSZX' = CN+SZX).
  //    DB 검증 결과 2936/2936 rows 모두 5-char CITY + 2-char COUNTRY.
  //    AS-IS DMF0004_SalesSite.cs L2565~2567 의 City.Substring(2,3) 과 동등 — 앞 2 chars (country prefix) skip 후 3 chars 추출.
  const city = String(row['CITY'] ?? '')
    .trim()
    .slice(2, 5);

  if (!soldToCustomer || !country || !city) return '';

  return `${soldToCustomer}_${country}_${city}`;
};

// SCM_SITE_ID 값 자동생성
export const applySalesSite = <
  T extends ResponseData<MENU_ID, SHEETS.CUSTOMER> | ResponseData<MENU_ID, SHEETS.SITE>,
>(
  row: T,
  editTracker?: EditTracker<T>
) => {
  const next = buildSalesSite(row);
  editTracker?.storeChange(row, 'SCM_SITE_ID', row['SCM_SITE_ID'], next);
  row['SCM_SITE_ID'] = next;
};
