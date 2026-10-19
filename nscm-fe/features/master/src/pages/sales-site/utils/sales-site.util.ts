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

// Sales Site 채번 규칙 = AS-IS DMF0004_SalesSite.cs shtMainDataModel_Changed(.cs:2470~2475) 1:1
//   Sold To Customer(CODE) + _ + City 코드 1~2번째 자리 + _ + City 코드 3~5번째 자리
//   GPD/DE2BZ -> GPD_DE_2BZ, Asus/CHBE1 -> Asus_CH_BE1.
//   Country 칸은 쓰지 않는다. 종전 규칙(Country + City 뒤 3자리)은 Country 칸 값과 City 코드 앞
//   2자리가 다른 사이트(원장 실측 2026-10-06: 2,915건 중 9건)에서 AS-IS 와 다른 코드를 만들어,
//   같은 거래처·도시 사이트가 다른 코드로 중복 등록되고 저장 SP 의 기존 Site 차단도 비껴갔다.
//   City 코드는 원장 전건 5자리라 5자리 미만이면 채번하지 않는다(AS-IS 는 Substring 예외).
//   NAME 을 쓰면 CODE 가 division 별로 중복되는 LGE 가 다른 법인명(LG ENERGY SOLUTION)으로
//   풀려서 잘못 채번된다. 콤보 붙여넣기로 row 에 NAME 이 들어온 경우만 호출부가
//   division 기준으로 CODE 를 풀어서 넘긴다.
export const buildSalesSite = (row: WijmoRowItem, soldToCustomerCode?: string) => {
  const soldToCustomer = String(soldToCustomerCode ?? row['SOLDTO_CUSTOMER'] ?? '').trim();
  const city = String(row['CITY'] ?? '').trim();

  if (!soldToCustomer || city.length < 5) return '';

  return `${soldToCustomer}_${city.slice(0, 2)}_${city.slice(2, 5)}`;
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

// ── 하단 탭 중복 키 검사 (AS-IS DMF0004_SalesSite.cs MSG00060 파리티) ──
//   AS-IS 는 그리드 안 행끼리 키 값을 문자열로 비교해 두 번째부터 MSG00060 으로 막는다.
//   저장 SP 에는 같은 사이트 안 중복 검사가 없으므로 화면에서 막지 않으면 그대로 저장된다.
export const DUPLICATE_KEY_MSG_ID = 'MSG00060';
export const DUPLICATE_KEY_MSG = '_중복된 키가 존재합니다.';

/** Sales Location — 저장 직전 전체 행 검사. AS-IS SaveButton shtSubLocation 분기(.cs:1470~1532). */
export const LOCATION_DUPLICATE_KEYS = [
  'DIVISION_ID',
  'SCM_SITE_ID',
  'LOCATION_CODE',
  'PLANT_ID',
] as const;

/** Sales Bucket — Incoterms 입력 즉시 검사. AS-IS shtSubBucketDataModel_Changed(.cs:2395~2423). */
export const BUCKET_DUPLICATE_KEYS = ['DIVISION_ID', 'SCM_SITE_ID', 'INCOTERMS'] as const;

const keyValuesOf = (row: WijmoRowItem, keys: readonly string[]) =>
  keys.map(key => String(row[key] ?? '').trim());

const isLiveRow = (row: WijmoRowItem) => row.CRUD_TYPE !== CRUD_TYPE.DELETE;

/**
 * row 와 같은 키를 가진 다른 행이 rows 안에 있는가.
 *   키 중 하나라도 비어 있으면 중복으로 보지 않는다 — AS-IS 도 필수 검증(MSG00002)을 먼저 통과한
 *   행만 비교했고, TO-BE 는 saveWithValidation 의 필수 검증이 그 역할을 한다.
 */
export const hasDuplicateKey = (
  rows: readonly WijmoRowItem[],
  row: WijmoRowItem,
  keys: readonly string[]
) => {
  const target = keyValuesOf(row, keys);
  if (target.some(value => value === '')) return false;
  return rows.some(
    other =>
      other !== row &&
      isLiveRow(other) &&
      keyValuesOf(other, keys).every((value, index) => value === target[index])
  );
};

/**
 * 저장 직전 전체 검사 — 변경 행(CRUD_TYPE 있음) 중 다른 행과 키가 겹치는 첫 행을 돌려준다.
 *   AS-IS 는 전 행을 돌며 첫 중복에서 멈추고 저장을 취소한다(.cs:1512~1532).
 *   변경이 없는 기존 행끼리의 중복은 이번 저장 대상이 아니라 보지 않는다 — 이관 데이터에 같은
 *   사이트·Plant·SLOC 중복이 이미 있어(2026-10-06 실측 237그룹 1,800행) 그 사이트의 다른 행
 *   수정까지 막히면 안 된다.
 */
export const findDuplicateKeyRow = <T extends WijmoRowItem>(
  rows: readonly T[],
  keys: readonly string[]
): T | undefined =>
  rows.find(row => isLiveRow(row) && !!row.CRUD_TYPE && hasDuplicateKey(rows, row, keys));

/** MSG00060 뒤에 비교한 키 칸 이름을 붙인다 — AS-IS 는 {0} 인자로 칸 이름을 넘겼다(공유 번역에 {0} 없음). */
export const formatDuplicateKeyMessage = (
  base: string,
  keys: readonly string[],
  headerOf: (key: string) => string | null | undefined
) => `${base} (${keys.map(key => headerOf(key) || key).join(', ')})`;

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
