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

// 콤보 행에서 먼저 값이 있는 컬럼을 고른다. 공백만 든 셀은 없는 값으로 본다.
//   같은 SQL_ID 라도 풀네임 컬럼으로 개정된 것과 종전 이름이 섞여 있어 양쪽을 다 견뎌야 한다
//   (SearchFields.utils 의 readRow 와 같은 사정).
const pickComboValue = (item: ComboResponse, columns: readonly string[]) => {
  for (const column of columns) {
    const value = normalizeComboValue(item[column]);
    if (value !== '') return value;
  }
  return '';
};

/** 콤보가 코드/이름을 담아 내려주는 컬럼 후보. 앞에 적은 것부터 본다. */
export interface ComboValueColumns {
  code: readonly string[];
  name: readonly string[];
}

/** 'EndCustomer' 콤보. 풀네임 개정본과 종전 이름을 함께 견딘다. */
export const END_CUSTOMER_COLUMNS: ComboValueColumns = {
  code: ['END_CUSTOMER', 'END_CUSTOMER_CODE', 'CODE'],
  name: ['END_CUSTOMER_NAME', 'NAME'],
};

/** 'SoldCustomer' 콤보. CASCADE_LEVELS.soldToCustomer 와 같은 컬럼을 본다. */
export const SOLD_CUSTOMER_COLUMNS: ComboValueColumns = {
  code: ['SOLD_CUSTOMER_CODE', 'SOLDTO_CUSTOMER', 'CODE'],
  name: ['SOLD_CUSTOMER_NAME', 'NAME'],
};

// 조회조건 드롭다운 옵션 — division 으로 좁히고 코드 기준 중복을 접는다.
//   이 화면의 End Customer / Sold-To Customer 는 자기 콤보('EndCustomer' / 'SoldCustomer')를
//   통째로 받아 여기서 거른다. 조인 콤보 cascade 로 묶지 않는 이유는 Sales Site 원천이
//   조건마다 달라(utils/sales-site.salesSiteCombo 참조) 단계로 엮이지 않기 때문이다.
//
//   division 이 빈 행은 통과시킨다(관대 매칭). 카탈로그 SearchFields 의 toOptions 가 같은
//   콤보를 그렇게 읽는다 — 자르면 목록이 통째로 비는 콤보가 있다.
//   코드를 못 읽은 행은 버린다. 남기면 라벨도 값도 빈 항목이 드롭다운에 하나 뜬다.
export const toDivisionComboOptions = (
  comboRows: readonly ComboResponse[] | undefined,
  divisionId: string,
  columns: ComboValueColumns = { code: ['CODE'], name: ['NAME'] }
) => {
  const division = normalizeComboValue(divisionId);
  return [
    ...new Map(
      (comboRows ?? [])
        .filter(item => {
          const rowDivision = readComboDivision(item);
          return rowDivision === '' || rowDivision === division;
        })
        .map(item => {
          const code = pickComboValue(item, columns.code);
          return [
            code,
            { label: pickComboValue(item, columns.name) || code, value: code },
          ] as const;
        })
        .filter(([code]) => code !== '')
    ).values(),
  ];
};

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
