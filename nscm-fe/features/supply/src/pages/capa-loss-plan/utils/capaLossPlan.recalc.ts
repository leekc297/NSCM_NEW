import {
  COLUMN,
  DEFAULT_DAY_CNT,
  DIVISION_TYPE,
  ELTR_DOUBLE_LINE_TYPE,
  LD_RT_LOSS_MEASURES,
  MEASURE,
  MINUTES_PER_DAY,
  OP_RT_LOSS_MEASURES,
  RATE_DIVISOR,
  type DivisionType,
} from '../capa-loss-plan.constants';
import type { DayCountRow, Scp0106Row } from '../capa-loss-plan.types';

import { toPeriodKey } from './capaLossPlan.dateColumns';

/**
 * 파생 재계산 — AS-IS `AssemblyUtils.RecalcSelf()`(A:665~731) / `EltrUtils.RecalcSelf()`(E:859~934).
 *
 * **7단계 순서가 고정**이다(03 R-08, V-35). 순서를 바꾸면 뒤 단계가 앞 단계의 갱신 전 값을 읽는다:
 *   OP_RT -> LD_RT -> TEEP -> PROD_OP_RT -> THRY_CAPA_D -> PROD_CAPA_D -> PROD_CAPA_M
 *
 * 산식 주의점:
 *   - `TEEP` 에는 `AV_RT` 가 **포함**되고 `PROD_OP_RT` 에는 **미포함**이다(V-36). 두 식은 그 한 항만 다르다.
 *   - ELTR 의 `THRY_CAPA_D` 에만 `EQP_TYPE_QTY`(`ELTR_LN_TP_CD === 'W' ? 2 : 1`)를 곱한다(V-37).
 *   - **반올림·클램프가 없다**(V-38). `Math.round`/`toFixed` 를 넣으면 AS-IS 와 값이 달라진다.
 *   - `DAY_CNT` 조회 실패 시 기본 30(V-41). 연 컬럼(`Y_yyyy`)은 dayCnt 결과셋이 6자리 월 키만 갖기
 *     때문에 **항상 매칭 실패 -> 30** 이다 — AS-IS 실동작이자 결함 후보(C-15). 고치지 않는다.
 *
 * AS-IS 의 setter 부수효과(대입 **전에** recalc 호출 -> stale)는 이식하지 않는다(C-21).
 * TO-BE 는 "입력 반영 -> RecalcSelf 7단계" 순수 함수다 — 값 결과는 같고 stale 경로만 사라진다.
 */

const toText = (value: unknown): string => {
  if (typeof value === 'string') return value;
  if (typeof value === 'number' || typeof value === 'boolean') return String(value);
  return '';
};

const toNumber = (value: unknown): number => {
  if (typeof value === 'number') return Number.isFinite(value) ? value : 0;
  const parsed = Number(toText(value).trim());
  // AS-IS 는 decimal.Parse 실패를 catch 로 삼키고 0 을 유지한다.
  return Number.isFinite(parsed) ? parsed : 0;
};

/**
 * 한 "엔티티 블록"을 식별하는 키 — 같은 라인x모델의 measure 행들이 한 블록이다.
 *
 * AS-IS 는 `GetRowIdxOfMeasure(curr, target) = curr - (IDX(curr) - IDX(target))` 로 **행 오프셋**을
 * 쓰지만(R-11), 그건 조회 정렬(`SORT_ORDER_NO_GR` -> `SORT_ORDER_NO` -> `IDX`)에 전적으로 의존해
 * 사용자가 F3 정렬·F4 필터를 걸면 엉뚱한 행에 값을 쓴다. TO-BE 는 **키 + measure 맵**으로 바꾼다
 * (R-11 의 TO-BE 권장안). AS-IS 정렬 계약 자체는 그대로 유지하므로 무정렬 상태에서 결과가 같다.
 */
const BLOCK_KEYS: readonly string[] = [
  COLUMN.DIVISION_ID,
  COLUMN.COMPANY_ID,
  COLUMN.SITE_ID,
  COLUMN.PLANT_ID,
  COLUMN.FACTORY_ID,
  COLUMN.LINE_ID,
  COLUMN.OPERATION_ID,
  COLUMN.ELTR_LN_TP_CD,
  COLUMN.ITEM_ID,
  COLUMN.NICK_NAME,
];

export const blockKeyOf = (row: Scp0106Row): string =>
  BLOCK_KEYS.map(key => toText(row[key])).join('');

/** 블록 안의 measure -> 행 맵. 같은 measure 가 두 번 오면 첫 행을 쓴다(AS-IS 도 첫 매칭). */
export const buildMeasureMap = (
  rows: readonly Scp0106Row[],
  blockKey: string
): Map<string, Scp0106Row> => {
  const map = new Map<string, Scp0106Row>();
  for (const row of rows) {
    if (blockKeyOf(row) !== blockKey) continue;
    const measure = toText(row[COLUMN.MEASURE]);
    if (!measure || map.has(measure)) continue;
    map.set(measure, row);
  }
  return map;
};

/**
 * DAY_CNT 결과셋(GET 3번 커서)의 조회 키 — AS-IS 필터 11축과 **같은 순서**로 둔다.
 * AS-IS `AssemblyUtils.GetValueFromDayCntTable`(A:129~174)은
 * `DBUtils.GetAndFilterString(["VER_ID","VER_SEQ","DIVISION_ID","COMPANY_ID","SITE_ID","PLANT_ID",
 *  "FACTORY_ID","LINE_ID","NICK_NAME","OPERATION_ID","ELTR_LN_TP_CD"] + "YYYYMM")` 로 한 행을 집는다.
 * 결과셋 자체가 이 11축 + `YYYYMM` 으로 GROUP BY 돼 있어(AS-IS GET SP "DAY_CNT - UI 계산용" 블록)
 * **기간만으로 키를 만들면 한 달에 여러 엔티티 행이 겹쳐 마지막 행이 전 라인에 적용된다.**
 */
const DAY_CNT_KEYS: readonly string[] = [
  COLUMN.VER_ID,
  COLUMN.VER_SEQ,
  COLUMN.DIVISION_ID,
  COLUMN.COMPANY_ID,
  COLUMN.SITE_ID,
  COLUMN.PLANT_ID,
  COLUMN.FACTORY_ID,
  COLUMN.LINE_ID,
  COLUMN.NICK_NAME,
  COLUMN.OPERATION_ID,
  COLUMN.ELTR_LN_TP_CD,
];

const dayCntKeyOf = (source: Record<string, unknown>, periodKey: string): string =>
  `${DAY_CNT_KEYS.map(key => toText(source[key])).join('')}${periodKey}`;

/** 기간별 파생 입력 1건. `SPEED_PPM` 은 **월별** 값이다(정적 컬럼의 전기간 평균이 아니다). */
export interface DayCountEntry {
  dayCnt: number;
  speedPpm: number;
}

/**
 * (엔티티 11축 + 기간) -> `{DAY_CNT, SPEED_PPM}`.
 * 결과셋의 `YYYYMM` 은 6자리 월만이라 연 컬럼(`Y_yyyy`)은 매칭 실패 -> 기본 30 으로 떨어진다(C-15, AS-IS 동일).
 */
export const buildDayCountMap = (
  rows: readonly DayCountRow[] | undefined
): Map<string, DayCountEntry> => {
  const map = new Map<string, DayCountEntry>();
  for (const row of rows ?? []) {
    const periodKey = toText(row.YYYYMM);
    if (!periodKey) continue;
    map.set(dayCntKeyOf(row as unknown as Record<string, unknown>, periodKey), {
      dayCnt: toNumber(row.DAY_CNT),
      speedPpm: toNumber(row.SPEED_PPM),
    });
  }
  return map;
};

const dayCountEntryOf = (
  dayCounts: Map<string, DayCountEntry>,
  row: Scp0106Row | undefined,
  columnName: string
): DayCountEntry | undefined =>
  row ? dayCounts.get(dayCntKeyOf(row, toPeriodKey(columnName))) : undefined;

/**
 * 재계산에 쓸 일수.
 * AS-IS `AssemblyUtils.DAY_CNT`(A:178~200): 편집 컬럼이 `BASE_QTY` 면 **행의 `DAY_CNT_BASE`**,
 * 기간 컬럼(`Y_`/`M_00`/`M_01`)이면 DAY_CNT 결과셋 조회, 둘 다 아니면 기본 30.
 */
export const dayCountOf = (
  dayCounts: Map<string, DayCountEntry>,
  row: Scp0106Row | undefined,
  columnName: string
): number => {
  if (columnName === COLUMN.BASE_QTY) {
    const base = toNumber(row?.[COLUMN.DAY_CNT_BASE]);
    return base > 0 ? base : DEFAULT_DAY_CNT;
  }
  const dayCnt = dayCountEntryOf(dayCounts, row, columnName)?.dayCnt ?? 0;
  return dayCnt > 0 ? dayCnt : DEFAULT_DAY_CNT;
};

/**
 * 재계산에 쓸 PPM.
 * AS-IS `AssemblyUtils.SPEED_PPM`(A:202~228) / `EltrUtils.PPM`(E:441~459):
 * 편집 컬럼이 `BASE_QTY` 면 **행의 `SPEED_BASE_PPM`**, 그 외에는 DAY_CNT 결과셋의 **월별** `SPEED_PPM`.
 * 그리드의 정적 `SPEED_PPM` 컬럼은 GET SP 가 `AVG(SPEED_PPM)`(전기간 평균)으로 내려주는 값이라
 * 월별 파생 계산의 입력으로 쓰면 모든 달이 같은 값이 된다 — 그래서 여기서는 쓰지 않는다.
 */
export const speedPpmOf = (
  dayCounts: Map<string, DayCountEntry>,
  row: Scp0106Row | undefined,
  columnName: string
): number => {
  if (columnName === COLUMN.BASE_QTY) return toNumber(row?.[COLUMN.SPEED_BASE_PPM]);
  return dayCountEntryOf(dayCounts, row, columnName)?.speedPpm ?? 0;
};

/** 재계산 결과 1건 — 호출부가 값을 반영하고 `EditTracker` 에 기록한다. */
export interface RecalcChange {
  row: Scp0106Row;
  columnName: string;
  previousValue: unknown;
  nextValue: number;
}

const sumMeasures = (
  measures: Map<string, Scp0106Row>,
  codes: readonly string[],
  columnName: string
): number => codes.reduce((total, code) => total + toNumber(measures.get(code)?.[columnName]), 0);

const pushChange = (
  changes: RecalcChange[],
  measures: Map<string, Scp0106Row>,
  measureCode: string,
  columnName: string,
  nextValue: number
): void => {
  const row = measures.get(measureCode);
  // 그 measure 행이 이 시트에 없으면 건너뛴다 — 시트마다 measure 세트가 다르다(20/25/6/6/...).
  if (!row) return;
  const value = Number.isFinite(nextValue) ? nextValue : 0;
  changes.push({ row, columnName, previousValue: row[columnName], nextValue: value });
};

export interface RecalcCurrentInput {
  /** 편집한 행이 속한 블록의 measure 맵. */
  measures: Map<string, Scp0106Row>;
  /** 편집한 기간 컬럼(또는 `BASE_QTY`). */
  columnName: string;
  divisionType: DivisionType;
  dayCounts: Map<string, DayCountEntry>;
  /**
   * 블록의 대표 행(엔티티 컬럼은 블록 안 어느 행이나 같은 값).
   * DAY_CNT 결과셋 조회 키(11축)와 `BASE_QTY` 경로의 `DAY_CNT_BASE`/`SPEED_BASE_PPM` 을 여기서 읽는다.
   */
  representativeRow: Scp0106Row | undefined;
}

/**
 * CURRENT 시트 재계산 — `RecalcSelf()` 7단계(03 R-08).
 * 반환 순서가 곧 계산 순서다. 호출부는 순서대로 반영한다.
 */
export const recalcCurrentColumn = ({
  measures,
  columnName,
  divisionType,
  dayCounts,
  representativeRow,
}: RecalcCurrentInput): RecalcChange[] => {
  const changes: RecalcChange[] = [];

  // 1) OP_RT = 100 - (BM+CM+PD+PM+UD+PP+MR)
  const opRt = RATE_DIVISOR - sumMeasures(measures, OP_RT_LOSS_MEASURES, columnName);
  pushChange(changes, measures, MEASURE.OP_RT, columnName, opRt);

  // 2) LD_RT = 100 - (ID+NM)
  const ldRt = RATE_DIVISOR - sumMeasures(measures, LD_RT_LOSS_MEASURES, columnName);
  pushChange(changes, measures, MEASURE.LD_RT, columnName, ldRt);

  const avRt = toNumber(measures.get(MEASURE.AV_RT)?.[columnName]);
  const pfRt = toNumber(measures.get(MEASURE.PF_RT)?.[columnName]);
  const qlRt = toNumber(measures.get(MEASURE.QL_RT)?.[columnName]);

  // 3) TEEP — AV_RT 포함
  const teep =
    (avRt / RATE_DIVISOR) *
    (ldRt / RATE_DIVISOR) *
    (opRt / RATE_DIVISOR) *
    (pfRt / RATE_DIVISOR) *
    (qlRt / RATE_DIVISOR) *
    RATE_DIVISOR;
  pushChange(changes, measures, MEASURE.TEEP, columnName, teep);

  // 4) PROD_OP_RT — 위와 같되 AV_RT 미포함
  const prodOpRt =
    (ldRt / RATE_DIVISOR) *
    (opRt / RATE_DIVISOR) *
    (pfRt / RATE_DIVISOR) *
    (qlRt / RATE_DIVISOR) *
    RATE_DIVISOR;
  pushChange(changes, measures, MEASURE.PROD_OP_RT, columnName, prodOpRt);

  // 5) THRY_CAPA_D = SPEED_PPM * 1440 (ELTR 은 x EQP_TYPE_QTY)
  //    PPM 은 월별 값이다 — 정적 `SPEED_PPM` 컬럼(전기간 AVG)이 아니라 `speedPpmOf` 경유.
  const speedPpm = speedPpmOf(dayCounts, representativeRow, columnName);
  const equipmentTypeQty =
    divisionType === DIVISION_TYPE.ELTR &&
    toText(representativeRow?.[COLUMN.ELTR_LN_TP_CD]) === ELTR_DOUBLE_LINE_TYPE
      ? 2
      : 1;
  const thryCapaD = speedPpm * MINUTES_PER_DAY * equipmentTypeQty;
  pushChange(changes, measures, MEASURE.THRY_CAPA_D, columnName, thryCapaD);

  // 6) PROD_CAPA_D = THRY_CAPA_D * (PROD_OP_RT/100)
  const prodCapaD = thryCapaD * (prodOpRt / RATE_DIVISOR);
  pushChange(changes, measures, MEASURE.PROD_CAPA_D, columnName, prodCapaD);

  // 7) PROD_CAPA_M = PROD_CAPA_D * DAY_CNT
  pushChange(
    changes,
    measures,
    MEASURE.PROD_CAPA_M,
    columnName,
    prodCapaD * dayCountOf(dayCounts, representativeRow, columnName)
  );

  return changes;
};

/**
 * LINE 계열(1차 컷오프 x LINE) `PROD_CAPA_D` 조회 키.
 * 이 값은 measure 행이 아니라 **GET 의 별도 결과셋**(`RS(prodCapaD)` 12컬럼)에서 온다(03 §4.2).
 * LINE 시트 measure 는 6종(`SCP_PROD_PLAN SCP_PROD_PLAN_DDN SD_RT WT_RT TD_RT MC_RT`)뿐이라
 * `PROD_CAPA_D` measure 행이 존재하지 않는다 — 결과셋을 안 쓰면 DDN 분모를 구할 수 없다.
 */
export interface ProdCapaDRow {
  DIVISION_ID?: string;
  NICK_NAME?: string;
  PLANT_ID?: string;
  LINE_ID?: string;
  OPERATION_ID?: string;
  COMPANY_ID?: string;
  SITE_ID?: string;
  FACTORY_ID?: string;
  YYYYMM?: string;
  PROD_CAPA_D?: number | string | null;
}

const PROD_CAPA_D_KEYS: readonly (keyof ProdCapaDRow)[] = [
  'DIVISION_ID',
  'NICK_NAME',
  'PLANT_ID',
  'LINE_ID',
  'OPERATION_ID',
  'COMPANY_ID',
  'SITE_ID',
  'FACTORY_ID',
];

export const buildProdCapaDMap = (
  rows: readonly ProdCapaDRow[] | undefined
): Map<string, number> => {
  const map = new Map<string, number>();
  for (const row of rows ?? []) {
    const key = [...PROD_CAPA_D_KEYS.map(field => toText(row[field])), toText(row.YYYYMM)].join(
      ''
    );
    map.set(key, toNumber(row.PROD_CAPA_D));
  }
  return map;
};

export const prodCapaDKeyOf = (row: Scp0106Row, columnName: string): string =>
  [
    toText(row[COLUMN.DIVISION_ID]),
    toText(row[COLUMN.NICK_NAME]),
    toText(row[COLUMN.PLANT_ID]),
    toText(row[COLUMN.LINE_ID]),
    toText(row[COLUMN.OPERATION_ID]),
    toText(row[COLUMN.COMPANY_ID]),
    toText(row[COLUMN.SITE_ID]),
    toText(row[COLUMN.FACTORY_ID]),
    toPeriodKey(columnName),
  ].join('');

export interface RecalcLineInput {
  /** 편집한 행이 속한 라인 블록의 행 전체(모델 행 + 라인집계 행 `NICK_NAME='-'`). */
  blockRows: readonly Scp0106Row[];
  columnName: string;
  divisionType: DivisionType;
  dayCounts: Map<string, DayCountEntry>;
  prodCapaD: Map<string, number>;
}

/**
 * 1차 컷오프 x LINE 재계산 — `RecalcSheetSelfLine`(03 R-18 디스패치).
 *
 *   `SCP_PROD_PLAN_DDN = SCP_PROD_PLAN / PROD_CAPA_D` (모델 행마다, 03 V-42)
 *     - ELTR: 분모 0 이면 **0 대입**(명시 가드)
 *     - ASSEMBLY: 분모 0 이면 AS-IS 가 예외를 삼켜 **이전 값을 유지**한다 -> 변경을 만들지 않는다
 *   `WT_RT = DAY_CNT - (SD_RT + TD_RT + MC_RT + SCP_PROD_PLAN_DDN)` (라인집계 행, 03 V-43)
 *     - CURRENT 는 자기 DDN 이지만 **LINE 은 라인 합계 DDN** 이다 — 모델 행들의 DDN 을 합산한다.
 *
 * 한계(04 리포트 "확인필요"): 분모 결과셋(`RS(prodCapaD)`)과 라인집계 행(`NICK_NAME='-'`)의
 * 실제 형태는 `PKG_SCP0106` 미배포라 런타임으로 확인하지 못했다. 설계 §4.2 의 컬럼 계약대로
 * 구현했고 배포 후 `convert-sp` 단계에서 대사가 필요하다.
 */
export const recalcLineColumn = ({
  blockRows,
  columnName,
  divisionType,
  dayCounts,
  prodCapaD,
}: RecalcLineInput): RecalcChange[] => {
  const changes: RecalcChange[] = [];
  let lineTotalDdn = 0;

  // 모델 행(`NICK_NAME !== '-'`)마다 DDN 재계산 + 라인 합계 누적.
  for (const row of blockRows) {
    if (toText(row[COLUMN.MEASURE]) !== MEASURE.SCP_PROD_PLAN) continue;
    const measures = buildMeasureMap(blockRows, blockKeyOf(row));
    const ddnRow = measures.get(MEASURE.SCP_PROD_PLAN_DDN);
    if (!ddnRow) continue;

    const plan = toNumber(row[columnName]);
    const capa = prodCapaD.get(prodCapaDKeyOf(row, columnName)) ?? 0;
    if (capa === 0) {
      if (divisionType === DIVISION_TYPE.ELTR) {
        changes.push({ row: ddnRow, columnName, previousValue: ddnRow[columnName], nextValue: 0 });
      }
      // ASSEMBLY 는 이전 값 유지 — 변경을 만들지 않는다(V-42).
      lineTotalDdn += toNumber(ddnRow[columnName]);
      continue;
    }
    const ddn = plan / capa;
    changes.push({ row: ddnRow, columnName, previousValue: ddnRow[columnName], nextValue: ddn });
    lineTotalDdn += ddn;
  }

  // 라인집계 행의 WT_RT — 비조업 measure 는 `NICK_NAME = '-'` 행에 있다(03 §4.2 GeFilterModel 규칙).
  const aggregateRows = blockRows.filter(row => toText(row[COLUMN.NICK_NAME]) === '-');
  const aggregate = new Map<string, Scp0106Row>();
  for (const row of aggregateRows) {
    const measure = toText(row[COLUMN.MEASURE]);
    if (measure && !aggregate.has(measure)) aggregate.set(measure, row);
  }
  const wtRow = aggregate.get(MEASURE.WT_RT);
  if (wtRow) {
    const dayCnt = dayCountOf(dayCounts, wtRow, columnName);
    const sd = toNumber(aggregate.get(MEASURE.SD_RT)?.[columnName]);
    const td = toNumber(aggregate.get(MEASURE.TD_RT)?.[columnName]);
    const mc = toNumber(aggregate.get(MEASURE.MC_RT)?.[columnName]);
    const nextValue = dayCnt - (sd + td + mc + lineTotalDdn);
    changes.push({
      row: wtRow,
      columnName,
      previousValue: wtRow[columnName],
      nextValue: Number.isFinite(nextValue) ? nextValue : 0,
    });
  }

  return changes;
};
