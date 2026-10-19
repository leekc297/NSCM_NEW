import { COLUMN, MEASURE } from '../capa-speed-plan.constants';
import type { Scp0105Row } from '../capa-speed-plan.types';

import { isEditablePeriodColumn } from './capaSpeedPlan.dateColumns';

/**
 * PPM 자동계산 — AS-IS `RecalcSheet`(cs:2676~2879) / `GetQtyRowIndex`(cs:2594~2618).
 *
 * 한 블록은 **정확히 3행**이다. AS-IS GET SP 실측(`SCP0105_GET_CAPA_SPEED_PLAN_CURRENT_ASSEMBLY`
 * 최종 `ORDER BY ... A.ELTR_LN_TP_CD, M.SORT_ORDER_NO`)상 행은 `SPEED_UNIT_GROUP` 3종
 * (`EQP_NBU` / `EQP_SPED` / `PPM`)으로만 나오고, measure 정렬번호가 EQP_NBU(10) < 속도
 * measure(MMS 20 / PPM_AVG 30 / TTT 40 / CPM 50) < PPM(60) 이라 항상 아래 순서로 쌓인다:
 *   수량행 `EQP_NBU` -> 속도행(`MMS`|`PPM_AVG`|`TTT`|`CPM` 중 **그 공정의 1종**) -> `PPM`
 * 속도 measure 가 공정별로 하나만 붙는 것은 AS-IS 주석이 근거다(cs:2845~2857 — MMS=A5000 /
 * CPM=A7000·A7400 / PPM_AVG=A8000·A8400). 6종이 한 블록에 같이 쌓이지 않는다.
 *
 * AS-IS 는 그 배치를 전제로 **행 오프셋**으로 수량/속도/PPM 행을 찾는다.
 *   qtyRow  : `EQP_NBU` 면 현재행 / `MMS`·`PPM_AVG`·`TTT`·`CPM` 면 현재행-1 / `PPM` 이면 현재행-2
 *   speedRow: qtyRow + 1
 *   ppmRow  : qtyRow + 2
 * **조회 정렬을 바꾸면 이 계산이 통째로 깨진다** — 그리드 기본정렬을 건드리지 않는다(V-29).
 *
 * 산식은 speedRow 의 measure 로 갈린다(cs:2843~2861):
 *   `MMS`     -> (speed * 60) / mms_cf * qty
 *   `CPM`     -> speed / eltr_qty * qty
 *   `PPM_AVG` -> speed * qty
 *   `TTT`     -> 60 / speed * qty
 * 0 방어: `eltr_qty === 0 -> 1`, `mms_cf === 0 -> 1` (cs:2754~2772).
 */

// 행 값은 인덱스 시그니처라 `unknown` 이다. 원시값만 문자열로 바꾼다(객체는 '[object Object]' 로 새지 않게).
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
 * 한 블록을 식별하는 키 — AS-IS GET SP 최종 `ORDER BY` 에서 **Measure 정렬축(`M.SORT_ORDER_NO`)만
 * 뺀 나머지 전건**이다(실측: `VER_ID, VER_SEQ, DIVISION_ID, COMPANY_ID, SITE_NAME, PLANT_NAME,
 * FACTORY_NAME, LINE_NAME, ITEM_ID, NICK_NAME, OPERATION_ID, ELTR_LN_TP_CD`). 정렬은 NAME 축이지만
 * 그 NAME 은 ID 의 1:1 조인 결과라 블록 경계 판정에는 ID 를 쓴다(행에 항상 실려 있다).
 * 행 오프셋(-1/-2)으로 잡은 이웃이 **같은 블록인지** 확인하는 데 쓴다.
 *
 * `ELTR_LN_TP_CD` 가 빠지면 안 된다 — 같은 라인x모델x공정에 Anode/Cathode 처럼 설비유형만 다른
 * 블록이 **연속으로** 쌓이므로(SP 주석 `NICK_NAME='E129A' AND ELTR_LN_TP_CD='Anode'`), 앞 블록의
 * 행 수가 3보다 적으면 오프셋이 다음 블록 첫 행을 가리킨 채 이 가드를 통과한다.
 *
 * 주의: 이 함수에 넘기는 `rows` 는 **원본 순서**(`collectionView.sourceCollection`)여야 한다 —
 * 오프셋은 조회 정렬이 만든 measure 배치에만 의미가 있고, AS-IS spread 는 정렬·필터가 없어
 * 원본 순서가 곧 AS-IS 의미다. 표시 순서를 넘기면 F3 정렬·F4 필터가 걸린 순간 이웃이 다른
 * measure 행으로 바뀐다(호출부 `useCapaSpeedPlanCellEdit` 주석 참조). 블록 가드와 아래 measure
 * 정체성 검사는 그 위의 2차 방어이며, 온전한 3행 블록에서는 항상 통과라 동작 차이가 없다.
 */
const BLOCK_KEYS: readonly string[] = [
  COLUMN.VER_ID,
  COLUMN.VER_SEQ,
  COLUMN.DIVISION_ID,
  COLUMN.COMPANY_ID,
  COLUMN.SITE_ID,
  COLUMN.PLANT_ID,
  COLUMN.FACTORY_ID,
  COLUMN.LINE_ID,
  COLUMN.ITEM_ID,
  COLUMN.NICK_NAME,
  COLUMN.OPERATION_ID,
  COLUMN.ELTR_LN_TP_CD,
];

const isSameBlock = (left: Scp0105Row, right: Scp0105Row): boolean =>
  BLOCK_KEYS.every(key => toText(left[key]) === toText(right[key]));

/** 오프셋으로 잡은 속도행의 measure — 이 4종이 아니면 산식이 없다(cs:2845~2860). */
const SPEED_MEASURES: readonly string[] = [
  MEASURE.MMS,
  MEASURE.CPM,
  MEASURE.PPM_AVG,
  MEASURE.TTT,
];

/** 편집한 행에서 수량(qty) 행까지의 오프셋. 대상 measure 가 아니면 null. */
export const qtyRowOffsetOf = (measure: string): number | null => {
  if (measure === MEASURE.EQP_NBU) return 0;
  if (
    measure === MEASURE.MMS ||
    measure === MEASURE.PPM_AVG ||
    measure === MEASURE.TTT ||
    measure === MEASURE.CPM
  ) {
    return -1;
  }
  if (measure === MEASURE.PPM) return -2;
  return null;
};

export interface RecalcResult {
  /** 값이 들어갈 PPM 행의 인덱스 */
  ppmRowIndex: number;
  /** 계산 결과 */
  value: number;
  /** 덮어쓰기 전 값 — EditTracker 원본 기록용 */
  previousValue: unknown;
}

/**
 * 편집된 셀 하나에 대한 PPM 재계산. 계산 대상이 아니면 null.
 *
 * 발동 조건은 호출부가 함께 건다(03 R-18 / V-30):
 *   - ASSEMBLY 시트일 것 (ELTR 은 미실행)
 *   - 편집한 컬럼이 `BASE_QTY` 또는 `M_`/`Y_` 기간열일 것
 *   - **PPM 행의 같은 셀이 lock 상태일 것** (cs:2914 — 사용자가 직접 넣을 수 있는 셀이면 덮지 않는다)
 */
export const recalcPpmCell = (
  rows: readonly Scp0105Row[],
  editedRowIndex: number,
  columnName: string
): RecalcResult | null => {
  if (columnName !== COLUMN.BASE_QTY && !isEditablePeriodColumn(columnName)) return null;

  const editedRow = rows[editedRowIndex];
  if (!editedRow) return null;

  const offset = qtyRowOffsetOf(toText(editedRow[COLUMN.MSR_TP_CD]));
  if (offset === null) return null;

  const qtyRowIndex = editedRowIndex + offset;
  const speedRowIndex = qtyRowIndex + 1;
  const ppmRowIndex = qtyRowIndex + 2;
  if (qtyRowIndex < 0) return null;
  if (speedRowIndex >= rows.length || ppmRowIndex >= rows.length) return null;

  const qtyRow = rows[qtyRowIndex];
  const speedRow = rows[speedRowIndex];
  const ppmRow = rows[ppmRowIndex];
  if (!qtyRow || !speedRow || !ppmRow) return null;
  // 이웃 3행이 편집행과 같은 블록일 때만 계산한다(위 BLOCK_KEYS 주석).
  if (
    !isSameBlock(editedRow, qtyRow) ||
    !isSameBlock(editedRow, speedRow) ||
    !isSameBlock(editedRow, ppmRow)
  ) {
    return null;
  }

  const speedMeasure = toText(speedRow[COLUMN.MSR_TP_CD]);
  /**
   * 블록이 같아도 **그 이웃이 정말 수량/속도/PPM 행인지**까지 확인한다. 블록 안 행이 3행보다 적게
   * 오면(측정 누락·SP 변형) 오프셋이 같은 블록의 엉뚱한 measure 행을 가리킬 수 있고, 그 상태로
   * 계산하면 값이 다른 measure 행에 써지고 `CRUD_TYPE='M'` 까지 찍혀 저장된다.
   * AS-IS 는 정렬·필터가 없고 블록이 항상 3행이라 이 검사 없이도 같은 행을 가리킨다 —
   * 즉 온전한 데이터에서는 **판정이 바뀌지 않는다**(파리티 유지, 결손 데이터만 차단).
   */
  if (toText(qtyRow[COLUMN.MSR_TP_CD]) !== MEASURE.EQP_NBU) return null;
  if (toText(ppmRow[COLUMN.MSR_TP_CD]) !== MEASURE.PPM) return null;
  if (!SPEED_MEASURES.includes(speedMeasure)) return null;

  const qty = toNumber(qtyRow[columnName]);
  const speed = toNumber(speedRow[columnName]);
  const eltrQty = toNumber(qtyRow[COLUMN.ELTR_QTY]) || 1;
  const mmsCf = toNumber(qtyRow[COLUMN.MMS_CF]) || 1;

  let ppm = 0;
  if (speedMeasure === MEASURE.MMS) ppm = ((speed * 60) / mmsCf) * qty;
  else if (speedMeasure === MEASURE.CPM) ppm = (speed / eltrQty) * qty;
  else if (speedMeasure === MEASURE.PPM_AVG) ppm = speed * qty;
  else if (speedMeasure === MEASURE.TTT) ppm = speed === 0 ? 0 : (60 / speed) * qty;
  // 위 `SPEED_MEASURES` 검사를 통과했으면 이 분기는 도달하지 않는다 — 산식 추가 시의 안전망으로 남긴다.
  else return null;

  if (!Number.isFinite(ppm)) ppm = 0;

  // 더미 모델이면서 MMS/CPM 이면 기입하지 않는다(cs:2866).
  //   AS-IS `IsModelDummy`(cs:2653~2674)는 `NICK_NAME_DUMMY_YN` 이 아니라 `_fixed_column_name`(=IDX)
  //   컬럼을 읽는 구현 결함이 있어 실제로는 항상 false 다. 한편 ASSEMBLY GET SP 는
  //   `NICK_NAME_DUMMY_YN` 을 `'N'` 리터럴로 고정 반환하므로(03 R-20) **어느 쪽으로 읽어도 이 분기는
  //   발동하지 않는다** — 런타임 동등. 의미가 성립하는 쪽(NICK_NAME_DUMMY_YN)으로 이식하고
  //   AS-IS 결함은 04 리포트/__asis-mapping__ 에 기록한다.
  if (
    toText(qtyRow[COLUMN.NICK_NAME_DUMMY_YN]) === 'Y' &&
    (speedMeasure === MEASURE.MMS || speedMeasure === MEASURE.CPM)
  ) {
    return null;
  }

  return { ppmRowIndex, value: ppm, previousValue: ppmRow[columnName] };
};
