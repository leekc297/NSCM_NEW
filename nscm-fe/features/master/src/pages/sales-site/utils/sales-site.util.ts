import { CRUD_TYPE } from '@foundation/constants';
import type { ComboResponse } from '@foundation/models';
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

// 콤보 행/셀 값 비교용 정규화. 콤보 응답의 DIVISION_ID 가 숫자(81)로 내려오고 그리드 행은
//   문자열('81')이라 === 비교가 조용히 어긋나던 사고가 있었다. 양쪽 다 문자열로 맞춘다.
const normalizeComboValue = (value: string | number | null | undefined) =>
  String(value ?? '').trim();

// 콤보 통일화 과도기라 division 컬럼 이름이 DIVISION_ID / DIVISION_CODE 두 가지로 내려온다.
const readComboDivision = (item: ComboResponse) =>
  normalizeComboValue(item.DIVISION_ID) || normalizeComboValue(item.DIVISION_CODE);

// 셀에 든 값(CODE 또는 NAME)을 콤보 기준 CODE 로 되돌린다.
//   필수: 같은 division 안에서 먼저 찾는다. CODE 가 division 별로 중복되는 LGE 같은 값이
//   다른 법인의 NAME 으로 먼저 걸리면 엉뚱한 CODE 로 풀린다.
//   division 으로 못 찾을 때만 division 을 무시하고 CODE -> NAME 순으로 다시 찾는다.
//   NAME 전역 탐색이 없으면 콤보 붙여넣기/직접 입력으로 들어온 NAME 이 그대로 채번에 쓰인다.
export const resolveComboCodeByDivision = (
  comboRows: readonly ComboResponse[],
  divisionId: string,
  value: string
) => {
  const target = normalizeComboValue(value);
  if (!target) return value;

  const division = normalizeComboValue(divisionId);
  const inDivision = comboRows.filter(item => readComboDivision(item) === division);

  return (
    inDivision.find(item => normalizeComboValue(item.CODE) === target)?.CODE ??
    inDivision.find(item => normalizeComboValue(item.NAME) === target)?.CODE ??
    comboRows.find(item => normalizeComboValue(item.CODE) === target)?.CODE ??
    comboRows.find(item => normalizeComboValue(item.NAME) === target)?.CODE ??
    value
  );
};

// TODO: DB에서 받는 데이터 형식에 따라 필요없을 수 있음, 삭제 필요 - 강민재
export const expandByDayOfWeek = <T extends WijmoRowItem>(item: T): T[] => {
  return DAY_MAP.filter(day => item[day.key as keyof T] !== undefined).map(day => ({
    ...item,
    YYYYMMDD: day.label,
    BUCKET_PER: item[day.key as keyof T] as string,
  }));
};

// Sales Site 채번 규칙: Sold To Customer(CODE) + _ + Country + _ + City 코드의 뒤 3글자
//   GPD/DE/DE2BZ -> GPD_DE_2BZ, LGE/JM/JMALP -> LGE_JM_ALP (2026-08-23 테스트 명세 기준).
//   NAME 을 쓰면 CODE 가 division 별로 중복되는 LGE 가 다른 법인명(LG ENERGY SOLUTION)으로
//   풀려서 잘못 채번된다. 콤보 붙여넣기로 row 에 NAME 이 들어온 경우만 호출부가
//   division 기준으로 CODE 를 풀어서 넘긴다.
export const buildSalesSite = (row: WijmoRowItem, soldToCustomerCode?: string) => {
  const soldToCustomer = String(soldToCustomerCode ?? row['SOLDTO_CUSTOMER'] ?? '').trim();
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
  soldToCustomerCode?: string
) => {
  const next = buildSalesSite(row, soldToCustomerCode);
  editTracker?.storeChange(row, 'SCM_SITE_ID', row['SCM_SITE_ID'], next);
  row['SCM_SITE_ID'] = next;
};
