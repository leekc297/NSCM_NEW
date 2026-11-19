import type { Dayjs } from 'dayjs';

import dayjs from '@foundation/dayjs';
import isoWeek from '@foundation/isoWeek';
import { isInsertRow, safeString } from '@foundation/utils';
import { useMessageStore } from '@shared/stores';

import { BUNDLE_KEY_COLS, MDL_GR_LENGTH, MEASURE_CODE } from '../sales-price-model-group.constants';
import type {
  ExchangeRateRow,
  ModelGroupRow,
  PeriodAxisRow,
} from '../sales-price-model-group.types';

// DMF0083 화면 전용 도우미 (STR-17 utils/{kebab}.util.ts) — 행 · 묶음, 기간 · 날짜, 환율, 알림.

// ===== 행 · 묶음 =====
// 신규 묶음 식별 칸 — 행 추가 때 묶음(KRW · USD · LOC 3행)에 같은 값을 넣는다. 그리드 칸이 아니라 화면 내부 칸이다.
export const INSERT_GROUP_ID = 'INSERT_GROUP_ID';

// 셀 값 → 앞뒤 공백을 뗀 문자열 (null · undefined → ''). 변환은 공용 safeString.
export const cellOf = (row: ModelGroupRow | undefined, binding: string): string =>
  safeString(row?.[binding]).trim();

// 저장 · 조회와 같은 묶음 키 (PKG_DMF0083 GROUP BY 7칸).
export const bundleKeyOf = (row: ModelGroupRow): string =>
  BUNDLE_KEY_COLS.map(col => cellOf(row, col)).join('|');

// 다중 선택값 → 조회 인자. 고른 값이 없거나 'ALL' 뿐이면 'ALL', 아니면 구분자로 잇는다.
//   PKG_DMF0083 조회 인자는 '^', 공용 팝업(COM0005 · COM0008) 조건은 ','.
export const joinCodes = (values: readonly string[], separator: '^' | ','): string => {
  const picked = values.map(v => v.trim()).filter(v => v !== '' && v.toUpperCase() !== 'ALL');
  return picked.length === 0 ? 'ALL' : picked.join(separator);
};

// 조회 시점 묶음 키 — 조회된 행에 한 번 찍어 두는 화면 내부 칸(그리드 칸 아님).
//   Currency 는 묶음 키의 한 칸인데 기존 행에서 고칠 수 있다(2026-11-12). 고친 뒤의 값으로 묶음을 찾으면
//   같은 6키(사업부 · Project · Sales Site · Model Group · Incoterms · FCST Type)에 새 통화를 이미 가진
//   다른 묶음과 섞인다. 그래서 묶음 찾기(머지 · 편집 전파 · 저장 묶음)는 이 값으로 한다.
//   프로시저에 보내는 키는 지금 값(bundleKeyOf)이다 — 새 통화로 나가야 통화 변경으로 처리된다.
export const ORIGIN_BUNDLE_KEY = 'ORIGIN_BUNDLE_KEY';

export const stampOriginBundleKey = (rows: ModelGroupRow[]): ModelGroupRow[] => {
  for (const row of rows) {
    if (!isInsertRow(row) && cellOf(row, ORIGIN_BUNDLE_KEY) === '') row[ORIGIN_BUNDLE_KEY] = bundleKeyOf(row);
  }
  return rows;
};

export const originBundleKeyOf = (row: ModelGroupRow): string =>
  cellOf(row, ORIGIN_BUNDLE_KEY) || bundleKeyOf(row);

// 기존 행은 조회 시점 묶음 키로, 신규 행은 행 추가 때 붙인 묶음 식별 값으로 같은 묶음인지 본다.
export const sameBundle = (a: ModelGroupRow, b: ModelGroupRow): boolean => {
  const aInsert = isInsertRow(a);
  if (aInsert !== isInsertRow(b)) return false;
  if (aInsert) {
    const groupId = cellOf(a, INSERT_GROUP_ID);
    return groupId !== '' && groupId === cellOf(b, INSERT_GROUP_ID);
  }
  return originBundleKeyOf(a) === originBundleKeyOf(b);
};

// 고른 Model 목록(쉼표) → Model Group 목록 (앞 12자리, 중복 제거, 고른 순서 유지).
export const modelGroupsOf = (itemIds: string | undefined): string[] => {
  const result: string[] = [];
  for (const id of (itemIds ?? '').split(',')) {
    const mdlGr = id.trim().slice(0, MDL_GR_LENGTH);
    if (mdlGr && !result.includes(mdlGr)) result.push(mdlGr);
  }
  return result;
};

// 셀 숫자 값 — 빈 값 · 숫자 아님은 null. 사용자가 쉼표를 넣어 붙여넣은 값도 받는다.
export const numberOf = (v: unknown): number | null => {
  if (typeof v === 'number') return Number.isNaN(v) ? null : v;
  if (typeof v !== 'string' || v.trim() === '') return null;
  const n = Number(v.replace(/,/g, '').trim());
  return Number.isNaN(n) ? null : n;
};

// ===== 기간 · 날짜 =====
dayjs.extend(isoWeek);

// 기간 칸 키 — 조회 결과 칸 이름과 같다(PKG_DMF0083 P_OPEN_MDL_GR_CURSOR: 'W_' || 주 시작일, 'M_' || 연월 || '01').
export const WEEK_KEY_RE = /^W_\d{8}$/;
export const MONTH_KEY_RE = /^M_\d{8}$/;
export const isPeriodKey = (key: string): boolean => WEEK_KEY_RE.test(key) || MONTH_KEY_RE.test(key);

const YMD = 'YYYYMMDD';

// 8자리 날짜만 받는다 — 형식이 다르면 null (호출부가 입력값을 그대로 돌려준다).
const dateOf = (yyyymmdd: string): Dayjs | null => {
  if (!/^\d{8}$/.test(yyyymmdd)) return null;
  const d = dayjs(yyyymmdd);
  return d.isValid() ? d : null;
};

// 그 날짜가 든 주의 월요일 — ISO 주 기준(일요일은 앞 월요일). PKG_DMF0083 의 TRUNC(SYSDATE, 'IW') 와 같다.
//   과거 주 잠금, Model Group Exist 판정 구간, 52주 채우기 시작이 모두 이 기준이라 화면도 같은 기준을 쓴다.
export const mondayOf = (yyyymmdd: string): string =>
  dateOf(yyyymmdd)?.startOf('isoWeek').format(YMD) ?? yyyymmdd;

export const thisWeekMonday = (): string => dayjs().startOf('isoWeek').format(YMD);

export const addWeeks = (yyyymmdd: string, weeks: number): string =>
  dateOf(yyyymmdd)?.add(weeks, 'week').format(YMD) ?? yyyymmdd;

// 기간 칸이 지난 칸인지 (설계서 W_ I57 · M_ R58).
//   주 칸: 주 시작일 < 이번 주 월요일. 월 칸: 그 달이 이번 주 월요일이 든 달보다 앞설 때만 지난 칸이다(이번 달부터 입력).
export const isPastPeriodKey = (key: string, monday: string): boolean => {
  const tag = key.slice(2);
  if (key.startsWith('M_')) return tag.slice(0, 6) < monday.slice(0, 6);
  return tag < monday;
};

// LOC 행에 조회 기간의 이번 주 이후 가격이 있는지 — 기존 묶음의 Currency 를 바꿀 수 있는 조건이다.
//   Currency 변경은 화면이 보내는 주만 새 통화가 된다(프로시저 3-0, 2026-11-12 변경). 보낼 이번 주 이후 주가 없으면
//   바꿀 것이 없고, 지난 주로 보내면 지난 주에 새 통화 행이 생긴다(사용자 결정 2026-11-12: 이런 묶음은 화면에서 막는다).
//   Y 묶음은 0 이 아닌 값이 있어야 한다(Y 의 0 = 삭제라 보내면 지워진다). N 묶음은 0 도 저장된 값이라 센다.
//   조회 결과는 주 칸 · 월 칸을 함께 내려주므로 Bucket 과 무관하게 주 칸으로 본다.
export const hasFutureLocPrice = (
  loc: ModelGroupRow | undefined,
  monday: string,
  allowZero = false
): boolean =>
  !!loc &&
  Object.keys(loc).some(key => {
    if (!WEEK_KEY_RE.test(key) || isPastPeriodKey(key, monday)) return false;
    const value = numberOf(loc[key]);
    return value !== null && (allowZero || value !== 0);
  });

// 조회 기간 기본값 — 원천 DMF0020 과 같은 이번 달 1일 ~ 5개월 뒤 말일 (설계서 [개요] I15 "미정 (원천: …)").
export const defaultPeriod = (): { from: string; to: string } => {
  const first = dayjs().startOf('month');
  return { from: first.format(YMD), to: first.add(5, 'month').endOf('month').format(YMD) };
};

// 시간축(SPREAD_TITLE_DATE) 행 → 기간 칸 키 (중복 제거, 오름차순).
//   조회 결과는 BE 가 NULL 칸을 응답에서 빼므로 값 없는 주가 칸으로 서지 않는다. 칸 뼈대는 달력에서 받는다(원천 DMF0020 과 같은 방식).
export const periodKeysOf = (rows: readonly PeriodAxisRow[] | undefined): string[] => {
  const set = new Set<string>();
  for (const r of rows ?? []) {
    if (WEEK_KEY_RE.test(r.WEEK_COL_KEY ?? '')) set.add(r.WEEK_COL_KEY);
    if (MONTH_KEY_RE.test(r.MONTH_COL_KEY ?? '')) set.add(r.MONTH_COL_KEY);
  }
  return [...set].sort();
};

// 시간축 행 → 연월별 주 시작일 목록. 월 칸 값을 그 달의 실제 주로 펼쳐 저장할 때 쓴다(설계서 M_ R58).
//   달력이 월 경계에서 주를 나누므로(예: 20260928 · 20261001) 연월은 행의 BASIS_YYYYMM 을 그대로 쓴다.
export const weeksByMonthOf = (
  rows: readonly PeriodAxisRow[] | undefined
): Map<string, string[]> => {
  const map = new Map<string, string[]>();
  for (const r of rows ?? []) {
    const week = r.BASIS_START_DATE ?? '';
    const ym = r.BASIS_YYYYMM ?? '';
    if (!/^\d{8}$/.test(week) || !/^\d{6}$/.test(ym)) continue;
    const list = map.get(ym) ?? [];
    if (!list.includes(week)) list.push(week);
    map.set(ym, list);
  }
  for (const list of map.values()) list.sort();
  return map;
};

// 기간 안의 주 시작일 (월요일 또는 월 1일 — 달력의 월 경계 분할 주와 같은 규칙).
//   Price Batch Input 은 메인 시간축을 쓰지 않으므로 팝업 Period 양 끝으로 주 칸을 만든다(원천 DMF0020 팝업과 같음).
export const enumerateWeekStarts = (from: string, to: string): string[] => {
  const start = dateOf(from);
  const end = dateOf(to);
  if (!start || !end) return [];
  const result: string[] = [];
  for (let cur = start; !cur.isAfter(end, 'day'); cur = cur.add(1, 'day')) {
    if (cur.isoWeekday() === 1 || cur.date() === 1) result.push(cur.format(YMD));
  }
  return result;
};

// 기간(YYYYMM ~ YYYYMM)의 모든 달. Exchange Rate 팝업의 월 칸을 조회한 기간 전체로 세울 때 쓴다.
//   형식이 다르거나 시작이 종료보다 늦으면 빈 배열.
export const enumerateYyyymm = (start: string, end: string): string[] => {
  if (!/^\d{6}$/.test(start) || !/^\d{6}$/.test(end) || start > end) return [];
  const last = dayjs(`${end}01`);
  const result: string[] = [];
  for (let cur = dayjs(`${start}01`); cur.isValid() && !cur.isAfter(last, 'month'); cur = cur.add(1, 'month')) {
    result.push(cur.format('YYYYMM'));
  }
  return result;
};

// 주 칸 헤더 — ISO 주차 번호 (원천 DMF0020 그리드와 같은 값).
export const isoWeekLabel = (yyyymmdd: string): string =>
  `W${String(dayjs(yyyymmdd).isoWeek()).padStart(2, '0')}`;

// ===== 환율 =====
// 환율 맵 키 = 사업부 | 통화 | 단위통화 | 연월. 값 = EXCHANGE_PRICE.
export type ExchangeRateMap = Map<string, number>;

const rateKey = (division: string, currency: string, unitCurrency: string, yyyymm: string) =>
  `${division}|${currency}|${unitCurrency}|${yyyymm}`;

export const buildExchangeRateMap = (rows: readonly ExchangeRateRow[] | undefined): ExchangeRateMap => {
  const map: ExchangeRateMap = new Map();
  for (const r of rows ?? []) {
    const division = String(r.DIVISION_ID ?? '').trim();
    const currency = String(r.CURRENCY ?? '').trim();
    const unit = String(r.UNIT_CURRENCY ?? '').trim();
    const ym = String(r.YYYYMM ?? '').trim();
    const price = Number(r.EXCHANGE_PRICE);
    if (!division || !currency || !unit || !ym || Number.isNaN(price)) continue;
    map.set(rateKey(division, currency, unit, ym), price);
  }
  return map;
};

const round3 = (v: number): number => Math.round(v * 1000) / 1000;

// LOC 값으로 KRW · USD 를 계산한다. 환율이 없으면 0 (설계서 [Measure 규칙] E4, [개요] C82).
//   계산식은 PKG_DMF0083 저장 2-5 보충과 같다 — 화면에 보인 값과 저장값이 어긋나지 않게 한다.
//     KRW = 통화가 KRW 면 LOC, 아니면 ROUND(LOC × 환율(KRW←통화), 3)
//     USD = 통화가 USD 면 LOC, KRW←USD 환율이 없거나 0 이면 0, 아니면 ROUND(KRW 값 ÷ 환율(KRW←USD), 3)
//   원천 DMF0020 GetExchangeRate 와 결과가 같고(환율 테이블은 CURRENCY='KRW' 행) 반올림만 패키지에 맞췄다.
export const convertLocPrice = (
  map: ExchangeRateMap,
  division: string,
  currency: string,
  measure: string,
  yyyymm: string,
  locPrice: number
): number => {
  if (measure === MEASURE_CODE.LOC) return locPrice;
  const krwRate = map.get(rateKey(division, MEASURE_CODE.KRW, currency, yyyymm)) ?? 0;
  const krw = currency === MEASURE_CODE.KRW ? locPrice : round3(locPrice * krwRate);
  if (measure === MEASURE_CODE.KRW) return krw;
  if (measure === MEASURE_CODE.USD) {
    if (currency === MEASURE_CODE.USD) return locPrice;
    const usdRate = map.get(rateKey(division, MEASURE_CODE.KRW, MEASURE_CODE.USD, yyyymm)) ?? 0;
    return usdRate === 0 ? 0 : round3(krw / usdRate);
  }
  return 0;
};

// ===== 알림 =====
// 읽고 넘어가야 하는 안내(검증 실패 · 저장 실패) — 화면 · 저장 훅 · 팝업이 같이 쓴다(MSG-01, UI-09).
export const showAlert = (content: string): void =>
  void useMessageStore.getState().setAlert({ type: 'alert', content });
