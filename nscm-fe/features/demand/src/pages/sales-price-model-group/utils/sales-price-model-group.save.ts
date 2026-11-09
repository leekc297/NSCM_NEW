import { apiClient } from '@foundation/apis';
import { BUTTON_TYPE, CRUD_TYPE } from '@foundation/constants';
import { isInsertRow } from '@foundation/utils';

import { MENU_ID, MEASURE_CODE, PRC_RPSN, SHEETS } from '../sales-price-model-group.constants';
import type { ModelGroupRow, SavePayload } from '../sales-price-model-group.types';

import {
  bundleKeyOf,
  cellOf,
  convertLocPrice,
  type ExchangeRateMap,
  INSERT_GROUP_ID,
  isPastPeriodKey,
  MONTH_KEY_RE,
  numberOf,
  WEEK_KEY_RE,
} from './sales-price-model-group.util';

// PKG_DMF0083.P_DMF0083_SAVE_SCM_MST_FUTURE_PRICE_MDL_GR 에 보내는 행 = 묶음 키 + 주 + Measure.
//   ACTIVE_FLAG : I(신규) · M(수정) · D(삭제 — LOC 0 저장, 사용자 결정 2026-11-06 해석 A)
//   D 는 LOC 만 보낸다. 패키지 2-5 가 같은 주의 KRW · USD 삭제 행을 스스로 보충한다(보내면 3쌍 검증과 어긋난다).
type ActiveFlag = typeof CRUD_TYPE.INSERT | typeof CRUD_TYPE.MODIFY | typeof CRUD_TYPE.DELETE;

interface SaveEntry {
  keyRow: ModelGroupRow;
  flag: ActiveFlag;
  yyyymmdd: string;
  measure: string;
  price: string;
  prcRpsn: string;
}

type Originals = Map<ModelGroupRow, Record<string, WijmoPrimitive>> | undefined;

// NO_PRICE : 판가대표 Y 로 저장하려는데 이번 주 이후 LOC 가격이 하나도 없다(MSG00328).
// NO_LOC_INPUT : 그 밖에 저장할 값을 만들지 못한 경우(MSG00013).
export type SaveBuildError = 'NO_PRICE' | 'NO_LOC_INPUT' | 'NO_FUTURE_WEEK';

export type SaveBuildResult =
  | { ok: true; entries: SaveEntry[] }
  | { ok: false; error: SaveBuildError; row: ModelGroupRow };

// 같은 묶음 · 주 · Measure 는 한 번만 담는다 — 먼저 담은 값이 이긴다.
//   그래서 주 칸 수정 → 월 칸 수정 → 표시 기준 보충 순서로 담는다(직접 고친 주 값이 월 펼침보다 우선).
class SaveCollector {
  private readonly entries = new Map<string, SaveEntry>();

  has(keyRow: ModelGroupRow, yyyymmdd: string, measure: string): boolean {
    return this.entries.has(`${bundleKeyOf(keyRow)}|${yyyymmdd}|${measure}`);
  }

  add(entry: SaveEntry): boolean {
    const key = `${bundleKeyOf(entry.keyRow)}|${entry.yyyymmdd}|${entry.measure}`;
    if (this.entries.has(key)) return false;
    this.entries.set(key, entry);
    return true;
  }

  list(): SaveEntry[] {
    return [...this.entries.values()];
  }
}

interface LocWriter {
  collector: SaveCollector;
  keyRow: ModelGroupRow;
  prcRpsn: string;
  rateMap: ExchangeRateMap;
}

// LOC 한 주를 담는다. LOC 가 0 이면 D(삭제)로 LOC 만, 그 밖에는 KRW · USD 를 환율로 계산해 함께 담는다.
//   price === null 은 "빈 값" — 처음부터 N 인 신규 묶음만 쓴다(패키지가 빈 값을 0 으로 넣는다, 설계서 [개요] H26).
const writeLocWeek = (
  w: LocWriter,
  yyyymmdd: string,
  price: number | null,
  baseFlag: ActiveFlag
): boolean => {
  if (w.collector.has(w.keyRow, yyyymmdd, MEASURE_CODE.LOC)) return false;
  const base = { keyRow: w.keyRow, yyyymmdd, prcRpsn: w.prcRpsn };
  if (price === 0) {
    return w.collector.add({ ...base, flag: CRUD_TYPE.DELETE, measure: MEASURE_CODE.LOC, price: '0' });
  }
  w.collector.add({
    ...base,
    flag: baseFlag,
    measure: MEASURE_CODE.LOC,
    price: price === null ? '' : String(price),
  });
  const division = cellOf(w.keyRow, 'DIVISION_ID');
  const currency = cellOf(w.keyRow, 'CURRENCY');
  for (const measure of [MEASURE_CODE.KRW, MEASURE_CODE.USD]) {
    const value =
      price === null
        ? ''
        : String(convertLocPrice(w.rateMap, division, currency, measure, yyyymmdd.slice(0, 6), price));
    w.collector.add({ ...base, flag: baseFlag, measure, price: value });
  }
  return true;
};

// 기간 칸 키 → 저장할 주. 주 칸은 그 주, 월 칸은 그 달 주 중 이번 주 월요일 이후(설계서 M_ R58).
const weeksOfKey = (key: string, weeksByMonth: Map<string, string[]>, monday: string): string[] => {
  if (WEEK_KEY_RE.test(key)) return isPastPeriodKey(key, monday) ? [] : [key.slice(2)];
  if (MONTH_KEY_RE.test(key)) {
    return (weeksByMonth.get(key.slice(2, 8)) ?? []).filter(week => week >= monday);
  }
  return [];
};

// 주 칸 먼저, 그다음 월 칸 — 직접 고친 주 값이 월 펼침보다 먼저 담기게 한다.
const orderPeriodKeys = (keys: string[]): string[] => [
  ...keys.filter(k => WEEK_KEY_RE.test(k)).sort(),
  ...keys.filter(k => MONTH_KEY_RE.test(k)).sort(),
];

const originalOf = (originals: Originals, row: ModelGroupRow, key: string): unknown => {
  const rec = originals?.get(row);
  return rec && key in rec ? rec[key] : row[key];
};

// PRC_RPSN 만 바뀐 묶음의 표식 행 — 이미 있는 주 값 하나를 원래 값 그대로 M 으로 보낸다.
//   패키지 3-4 가 저장 묶음의 PRC_RPSN 을 모든 Measure · 주에 일괄 반영하므로 한 행이면 충분하고,
//   있는 행이라 3-3(없는 행 넣기)도 일어나지 않는다. 값이 있는 주 칸은 그 행이 테이블에 있다는 뜻이다(조회 PIVOT 외부 조인).
//   Y 묶음은 3쌍 검증(2-6) 때문에 LOC 여야 한다 — KRW · USD 는 패키지 2-5 가 보충한다.
const writeMarker = (
  collector: SaveCollector,
  bundle: ModelGroupRow[],
  loc: ModelGroupRow,
  prcRpsn: string,
  originals: Originals
): boolean => {
  const candidates = prcRpsn === PRC_RPSN.YES ? [loc] : [loc, ...bundle.filter(r => r !== loc)];
  for (const row of candidates) {
    const weekKeys = Object.keys(row)
      .filter(k => WEEK_KEY_RE.test(k))
      .sort()
      .reverse();
    for (const key of weekKeys) {
      const value = numberOf(originalOf(originals, row, key));
      if (value === null) continue;
      return collector.add({
        keyRow: loc,
        flag: CRUD_TYPE.MODIFY,
        yyyymmdd: key.slice(2),
        measure: cellOf(row, 'MEASURE'),
        price: String(value),
        prcRpsn,
      });
    }
  }
  return false;
};

const bundlesOf = (rows: ModelGroupRow[]): ModelGroupRow[][] => {
  const map = new Map<string, ModelGroupRow[]>();
  for (const row of rows) {
    const key = isInsertRow(row) ? `I:${cellOf(row, INSERT_GROUP_ID)}` : `E:${bundleKeyOf(row)}`;
    const list = map.get(key) ?? [];
    list.push(row);
    map.set(key, list);
  }
  return [...map.values()];
};

const locOf = (bundle: ModelGroupRow[]): ModelGroupRow | undefined =>
  bundle.find(r => cellOf(r, 'MEASURE') === MEASURE_CODE.LOC);

export interface MainSaveInput {
  rows: ModelGroupRow[];
  originals: Originals;
  weeksByMonth: Map<string, string[]>;
  monday: string;
  rateMap: ExchangeRateMap;
}

// 메인 그리드 저장 행 구성 (설계서 [개요] grid-1 Save H26, 사용자 결정 2026-11-06).
//   신규 Y : LOC 입력 칸(주 · 월)을 주로 펼쳐 I. 입력이 하나도 없으면 막는다(0 으로 모델 판가를 덮지 않게).
//   신규 N : 조회 기간의 이번 주 이후 주를 빈 값으로 I (패키지가 0 으로 저장).
//   기존 Y : 고친 LOC 칸을 M (0 · 빈 값은 D). N → Y 로 바꾼 묶음은 이번 주 이후 값 있는 LOC 칸도 함께 M.
//   기존 N : PRC_RPSN 을 Y → N 으로 바꿨을 때만 표식 행 1개. LOC 는 바꾸지 않는다(Y → N 은 PRC_RPSN 만 바뀜).
export const buildMainSaveEntries = (input: MainSaveInput): SaveBuildResult => {
  const { rows, originals, weeksByMonth, monday, rateMap } = input;
  const collector = new SaveCollector();
  const periodWeeks = [...weeksByMonth.values()].flat().filter(week => week >= monday).sort();

  for (const bundle of bundlesOf(rows)) {
    const loc = locOf(bundle);
    if (!loc) continue;
    const prcRpsn = cellOf(loc, 'PRC_RPSN');
    const writer: LocWriter = { collector, keyRow: loc, prcRpsn, rateMap };

    if (isInsertRow(loc)) {
      if (prcRpsn === PRC_RPSN.NO) {
        if (periodWeeks.length === 0) return { ok: false, error: 'NO_FUTURE_WEEK', row: loc };
        periodWeeks.forEach(week => writeLocWeek(writer, week, null, CRUD_TYPE.INSERT));
        continue;
      }
      let written = false;
      for (const key of orderPeriodKeys(Object.keys(loc))) {
        const value = numberOf(loc[key]);
        if (value === null) continue;
        for (const week of weeksOfKey(key, weeksByMonth, monday)) {
          written = writeLocWeek(writer, week, value, CRUD_TYPE.INSERT) || written;
        }
      }
      if (!written) return { ok: false, error: 'NO_PRICE', row: loc };
      continue;
    }

    const prcChanged = bundle.some(r => {
      const rec = originals?.get(r);
      return !!rec && 'PRC_RPSN' in rec;
    });
    const locRec = originals?.get(loc);
    const changedLocKeys = locRec ? Object.keys(locRec).filter(k => WEEK_KEY_RE.test(k) || MONTH_KEY_RE.test(k)) : [];
    if (!prcChanged && changedLocKeys.length === 0) continue;

    if (prcRpsn !== PRC_RPSN.YES) {
      if (prcChanged && !writeMarker(collector, bundle, loc, prcRpsn, originals)) {
        return { ok: false, error: 'NO_LOC_INPUT', row: loc };
      }
      continue;
    }

    let written = false;
    for (const key of orderPeriodKeys(changedLocKeys)) {
      // 고친 칸을 비우면 0 과 같다 — LOC 0 저장 = 삭제(사용자 결정 2026-11-06).
      const value = numberOf(loc[key]) ?? 0;
      for (const week of weeksOfKey(key, weeksByMonth, monday)) {
        written = writeLocWeek(writer, week, value, CRUD_TYPE.MODIFY) || written;
      }
    }
    if (prcChanged) {
      for (const key of orderPeriodKeys(Object.keys(loc)).filter(k => WEEK_KEY_RE.test(k))) {
        if (isPastPeriodKey(key, monday)) continue;
        const value = numberOf(loc[key]);
        if (value === null) continue;
        written = writeLocWeek(writer, key.slice(2), value, CRUD_TYPE.MODIFY) || written;
      }
      if (!written && !writeMarker(collector, bundle, loc, prcRpsn, originals)) {
        // N → Y 로 바꿨는데 가격이 하나도 없다 — 신규 Y 와 같은 경우다.
        return { ok: false, error: 'NO_PRICE', row: loc };
      }
    }
  }
  return { ok: true, entries: collector.list() };
};

export interface BatchSaveInput {
  rows: ModelGroupRow[];
  originals: Originals;
  weeks: string[];
  rateMap: ExchangeRateMap;
}

// Price Batch Input 저장 행 구성 (설계서 popup-1 Save I36).
//   PRC_RPSN = Y 이고 Batch Price 를 넣은 행 : 팝업 기간의 모든 주에 같은 LOC (0 이면 D) + KRW · USD.
//   PRC_RPSN 만 바꾼 행 : 표식 행 1개 (값은 그대로, PRC_RPSN 만 전 구간 반영).
//   PRC_RPSN = N 인 행의 Batch Price 는 쓰지 않는다(N 이면 Measure 값 갱신 없음).
export const buildBatchSaveEntries = (input: BatchSaveInput): SaveBuildResult => {
  const { rows, originals, weeks, rateMap } = input;
  const collector = new SaveCollector();
  for (const row of rows) {
    const prcRpsn = cellOf(row, 'PRC_RPSN');
    const rec = originals?.get(row);
    const prcChanged = !!rec && 'PRC_RPSN' in rec;
    const batch = numberOf(row.PRICE_ALL);
    if (prcRpsn === PRC_RPSN.YES && batch !== null) {
      const writer: LocWriter = { collector, keyRow: row, prcRpsn, rateMap };
      weeks.forEach(week => writeLocWeek(writer, week, batch, CRUD_TYPE.MODIFY));
      continue;
    }
    if (prcChanged && !writeMarker(collector, [row], row, prcRpsn, originals)) {
      return { ok: false, error: 'NO_LOC_INPUT', row };
    }
  }
  return { ok: true, entries: collector.list() };
};

// 저장 행 → 프로시저 인자 (칸마다 '^' 로 잇기). fromYyyymmdd 는 52주 채우기 시작(패키지 3-5).
export const toSavePayload = (entries: SaveEntry[], fromYyyymmdd: string): SavePayload => {
  const col = (pick: (e: SaveEntry) => string) => entries.map(pick).join('^');
  return {
    activeFlag: col(e => e.flag),
    divisionId: col(e => cellOf(e.keyRow, 'DIVISION_ID')),
    projectCode: col(e => cellOf(e.keyRow, 'PROJECT_CODE')),
    scmSiteId: col(e => cellOf(e.keyRow, 'SCM_SITE_ID')),
    mdlGr: col(e => cellOf(e.keyRow, 'MDL_GR')),
    incoterms: col(e => cellOf(e.keyRow, 'INCOTERMS')),
    fcstType: col(e => cellOf(e.keyRow, 'FCST_TYPE')),
    currency: col(e => cellOf(e.keyRow, 'CURRENCY')),
    yyyymmdd: col(e => e.yyyymmdd),
    measure: col(e => e.measure),
    price: col(e => e.price),
    prcRpsn: col(e => e.prcRpsn),
    fromYyyymmdd,
  };
};

// 신규 묶음 키가 다른 묶음(신규 · 조회)과 같은지 — 같으면 MSG00428 (패키지는 같은 키를 한 묶음으로 합쳐 버린다).
export const findDuplicateInsertBundle = (rows: ModelGroupRow[]): ModelGroupRow | undefined => {
  const locRows = rows.filter(row => cellOf(row, 'MEASURE') === MEASURE_CODE.LOC);
  const owners = new Map<string, Set<string>>();
  for (const row of locRows) {
    const key = bundleKeyOf(row);
    const set = owners.get(key) ?? new Set<string>();
    set.add(isInsertRow(row) ? `I:${cellOf(row, INSERT_GROUP_ID)}` : 'E');
    owners.set(key, set);
  }
  return locRows.find(row => isInsertRow(row) && (owners.get(bundleKeyOf(row))?.size ?? 0) > 1);
};

export const describeRow = (row: ModelGroupRow): string =>
  [cellOf(row, 'SCM_SITE_ID'), cellOf(row, 'PROJECT_CODE'), cellOf(row, 'MDL_GR')].filter(Boolean).join(' / ');

// ===== 저장 호출 =====
export type SaveResult = { ok: true } | { ok: false; message: string };

// main / SAVE 호출 — 메인 그리드와 Price Batch Input 이 같이 쓴다(설계서 popup-1 Save D36 = main / SAVE).
//   useProcMutation 을 쓰지 않는 이유: 이 프로시저는 칸마다 '^' 로 이은 인자 한 벌을 받고, 전역
//   responseErrorInterceptor 가 500(ORA 오류)을 정상 응답으로 넘겨 훅의 onSuccess(저장 완료 토스트)가 뜬다.
//   그래서 응답 상태와 code 를 직접 본다(STR-07 예외 — 직접 호출 직후 실패 분기). 원천 DMF0020 저장과 같은 방식.
//   패키지 검증 거부(O_RESULT_CURSOR CODE='-1')는 responseInterceptor 가 MSG 로 throw 한다 → catch 에서 사유를 돌려준다.
export const postSave = async (payload: SavePayload, fallbackMessage: string): Promise<SaveResult> => {
  try {
    const res = await apiClient.post<Record<string, unknown>, SavePayload>(
      `/${MENU_ID}/${SHEETS.MAIN}/${BUTTON_TYPE.SAVE}/call-proc`,
      payload
    );
    if (res.status >= 400 || Number(res.data?.code)) {
      return { ok: false, message: res.data?.message?.trim() || fallbackMessage };
    }
    return { ok: true };
  } catch (e) {
    return { ok: false, message: e instanceof Error && e.message ? e.message : fallbackMessage };
  }
};
