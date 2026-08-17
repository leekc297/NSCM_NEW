import { CRUD_TYPE } from '@foundation/constants';
import type { EditTracker } from '@foundation/utils';

import type { MENU_ID, RESPONSE_SET, SHEETS } from '../sales-site.constants';

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

// Sales Site 채번 규칙: Sold To Customer(NAME) + _ + Country + _ + City 코드의 뒤 3글자
//   SOLDTO_CUSTOMER 는 row 에 CODE 로만 저장되므로, NAME 은 콤보 목록에서 찾아 호출부가 넘겨준다.
export const buildSalesSite = (row: WijmoRowItem, soldToCustomerName?: string) => {
  const soldToCustomer = (soldToCustomerName ?? String(row['SOLDTO_CUSTOMER'] ?? '')).trim();
  const country = String(row['COUNTRY'] ?? '').trim();
  const city = String(row['CITY'] ?? '')
    .trim()
    .slice(-3);

  if (!soldToCustomer || !country || !city) return '';

  return `${soldToCustomer}_${country}_${city}`;
};

// Rep Yn = Y 는 동일 Sales Site 기준 1건만 허용 — 저장 SP 와 같은 규칙을 화면에서 먼저 막는다.
//   메시지는 저장 SP 가 쓰는 다국어 코드(MSG00028)와 동일.
export const REP_YN_DUPLICATE_MSG_ID = 'MSG00028';
export const REP_YN_DUPLICATE_MSG =
  '_Rep Yn = Y 인 데이터 동일 Sales Site 기준으로 하나만 존재할 수 있습니다.';

// 컬럼 정의(콤보 'Y'/'N' · 체크박스 boolean)에 따라 셀 값 타입이 달라 정규화해서 비교한다.
export const isRepresentative = (value: WijmoPrimitive | undefined) =>
  typeof value === 'boolean'
    ? value
    : String(value ?? '')
        .trim()
        .toUpperCase() === 'Y';

// Customer 그리드는 상단에서 고른 Sales Site 한 건만 조회하므로,
//   아직 SCM_SITE_ID 가 비어 있는 신규 행도 같은 site 로 본다.
const isSameSite = (a?: WijmoPrimitive, b?: WijmoPrimitive) => !a || !b || String(a) === String(b);

export const hasRepresentative = (
  rows: ResponseData<MENU_ID, SHEETS.CUSTOMER, RESPONSE_SET.CUSTOMER>[],
  scmSiteId?: WijmoPrimitive,
  exclude?: ResponseData<MENU_ID, SHEETS.CUSTOMER, RESPONSE_SET.CUSTOMER>
) =>
  rows.some(
    row =>
      row !== exclude &&
      row.CRUD_TYPE !== CRUD_TYPE.DELETE &&
      isRepresentative(row.REP_YN) &&
      isSameSite(row.SCM_SITE_ID, scmSiteId)
  );

// SCM_SITE_ID 값 자동생성
export const applySalesSite = <
  T extends ResponseData<MENU_ID, SHEETS.CUSTOMER> | ResponseData<MENU_ID, SHEETS.SITE>,
>(
  row: T,
  editTracker?: EditTracker<T>,
  soldToCustomerName?: string
) => {
  const next = buildSalesSite(row, soldToCustomerName);
  editTracker?.storeChange(row, 'SCM_SITE_ID', row['SCM_SITE_ID'], next);
  row['SCM_SITE_ID'] = next;
};
