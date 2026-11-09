import {
  COLUMN,
  DIVISION_TYPE,
  FORMATION_OPERATION_ID,
  MEASURE,
  PROGRESS_STATUS,
  SHEET_TYPE,
  type DivisionType,
  type SheetType,
} from '../capa-loss-plan.constants';
import type { MeasureTargetRow, Scp0106Row } from '../capa-loss-plan.types';

import { assignPriorityKeyOf, isEditablePeriodColumn, toPeriodKey } from './capaLossPlan.dateColumns';

/**
 * 조건부 셀 편집잠금 — AS-IS `SetLockColumnsAll` 분기 C1(CURRENT) / C2(1차컷오프 x LINE).
 *
 * AS-IS 는 `LockRange2(...)` 로 좌표 범위를 잠그지만 TO-BE 는 **좌표가 아니라 의미**로 재현한다
 * (hook #130 — `LockRange`/컬럼명 상수 배열 이식 금지). 판정 입력은
 * (시트 상태, 컬럼 binding, 행 데이터, 편집가능 measure 집합)뿐이라 순수 함수로 두고
 * `beginningEdit` / `pastingCell` / `formatItem` 이 **같은 함수**를 쓴다.
 *
 * **편집 가능 measure 는 코드 상수가 아니다** — GET measure 결과셋의 `*_TARGET_YN` 이 단일 원천이다
 * (03 V-23, hook #130). 실측 기대값은 CURRENT 10종(`PF_RT` 제외) / 1차xLINE 4종
 * (`SCP_PROD_PLAN SD_RT TD_RT MC_RT`) / 1차xMODEL 0종 / 2차 0종이지만, 그 목록을 코드에 박지 않는다.
 * SP 미배포라 결과셋이 비면 편집 가능 measure 도 0건이 된다 — **닫히는 쪽으로 실패**하는 것이 안전하다.
 */

// 행 값은 인덱스 시그니처라 `unknown` 이다. 객체가 섞여 들어와도 `'[object Object]'` 로 새지 않게
//   원시값만 문자열로 바꾼다(그 외는 빈 문자열 = "값 없음" 취급, AS-IS GetText 의 공백 동작과 같다).
const toText = (value: unknown): string => {
  if (typeof value === 'string') return value;
  if (typeof value === 'number' || typeof value === 'boolean') return String(value);
  return '';
};

/**
 * 이 (진행상태 x SheetType) 조합에서 편집가능 여부를 들고 있는 measure 메타 컬럼명(03 R-05/R-06).
 * CURRENT(`-`/`0`) -> `CURRENT_TARGET_YN` / 1차+MODEL -> `FIRST_MODEL_TARGET_YN` /
 * 1차+LINE -> `FIRST_LINE_TARGET_YN` / 2차(MODEL·LINE 무관) -> `SECOND_TARGET_YN`.
 */
export const targetYnFieldOf = (
  progressStatus: string,
  sheetType: SheetType
): keyof MeasureTargetRow => {
  if (progressStatus === PROGRESS_STATUS.SECOND_CUTOFF) return 'SECOND_TARGET_YN';
  if (progressStatus === PROGRESS_STATUS.FIRST_CUTOFF) {
    return sheetType === SHEET_TYPE.MODEL ? 'FIRST_MODEL_TARGET_YN' : 'FIRST_LINE_TARGET_YN';
  }
  return 'CURRENT_TARGET_YN';
};

/** GET measure 결과셋 -> 이 시트에서 편집 가능한 measure 코드 집합. */
export const buildEditableMeasures = (
  rows: readonly MeasureTargetRow[] | undefined,
  progressStatus: string,
  sheetType: SheetType
): Set<string> => {
  const field = targetYnFieldOf(progressStatus, sheetType);
  const editable = new Set<string>();
  for (const row of rows ?? []) {
    if (toText(row[field]) !== 'Y') continue;
    // 결과셋의 measure 코드 컬럼은 **`LOSS_CD`** 다 — 그리드 행의 `MEASURE` 와 이름이 다르다.
    //   AS-IS: `DBUtils.GetStringColumnValues(tbl, "LOSS_CD")`(`SCP0106_CAPA_Loss_Plan.cs:2743`).
    //   AS-IS GET SP 의 'Measure - UI 계산용' 결과셋도 `A.SEGMENT1 AS LOSS_CD` 로 내린다.
    //   `MEASURE` 로 읽으면 집합이 **항상 비어** 전 셀이 잠기고 저장이 "변경 0건" 으로 빠진다.
    const measure = toText(row.LOSS_CD);
    if (measure) editable.add(measure);
  }
  return editable;
};

/** `_ASSIGN_PRIORITY` 값이 0/공백이면 "우선순위 없음" = 그 기간 셀은 잠긴다(03 R-27, V-27). */
export const isPriorityNone = (row: Scp0106Row | undefined, periodColumn: string): boolean => {
  if (!row) return true;
  const raw = toText(row[assignPriorityKeyOf(periodColumn)]);
  if (raw === '') return true;
  const parsed = Number(raw);
  // 숫자로 못 읽으면 AS-IS 도 decimal.Parse 실패로 0 을 유지한다(= 잠금).
  return !Number.isFinite(parsed) || parsed === 0;
};

/**
 * 생산확정기간 잠금의 **AS-IS 실동작을 정밀 재현**한 잠금 컬럼 집합
 * (C-16 / I-04 — 2026-11-04 사용자 확정: "AS-IS 정밀 재현").
 *
 * AS-IS(cs:2235~2280)는 `isScpPlanFixed` 를 행 루프 시작 시 `false` 로 두고(cs:2178),
 * 컬럼 루프에서 **6자리(월) 컬럼일 때만** `(startYm <= 월 <= endYm)` 으로 **재계산**한다
 * (cs:2258 `yyyymm.Length == 6` 가드). 즉:
 *   - 확정기간 안 월 컬럼 → 잠금
 *   - 확정기간 **이후** 월 컬럼 → 매번 재계산되어 **해제**(순수 latch 아님)
 *   - 4자리 연(`Y_yyyy`) 컬럼 → 재계산하지 않아 **바로 앞 월 컬럼값을 상속**
 *     (AS-IS 의 리셋 누락 quirk — 설계 V-29 의도와는 다르지만 AS-IS 파리티로 유지)
 *
 * 과거 구현은 "한번 켜지면 끝까지"인 순수 latch 라 확정기간 이후 월까지 과잠금했으나,
 * AS-IS 는 월 컬럼을 매번 재계산하므로 아래처럼 바로잡았다.
 *
 * 컬럼 순서(월→연)에 의존하므로 순수 함수 인자로 **정렬된 기간 컬럼명 목록**을 받는다
 * (그리드 좌표를 읽지 않는다 — hook #130 유지).
 */
export const buildScpPlanFixedColumns = (
  orderedPeriodColumns: readonly string[],
  startYm: string,
  endYm: string
): Set<string> => {
  const locked = new Set<string>();
  if (!startYm || !endYm) return locked;
  // AS-IS isScpPlanFixed: 행 시작 false → 6자리 월 컬럼마다 재계산, 4자리 연 컬럼은 앞 값 상속.
  let isScpPlanFixed = false;
  for (const columnName of orderedPeriodColumns) {
    const key = toPeriodKey(columnName);
    if (key.length === 6) {
      isScpPlanFixed = key >= startYm && key <= endYm;
    }
    // key.length !== 6 (연 컬럼 등) 이면 재계산하지 않고 직전 월 컬럼값을 그대로 쓴다(상속).
    if (isScpPlanFixed) locked.add(columnName);
  }
  return locked;
};

/** LINE 시트의 생산확정기간 2값은 전 행 동일이라 첫 행에서 1회만 읽는다(03 R-06). */
export const readScpPlanRange = (
  rows: readonly Scp0106Row[]
): { startYm: string; endYm: string } => {
  const first = rows[0];
  return {
    startYm: toText(first?.[COLUMN.SCP_PRDN_PLAN_REF_ST_YM]),
    endYm: toText(first?.[COLUMN.SCP_PRDN_PLAN_REF_END_YM]),
  };
};

export interface EditableInput {
  binding: string;
  row: Scp0106Row | undefined;
  isEditMode: boolean;
  /** 화면에서 고른 Status — measure 메타 축 선택에 쓴다. */
  progressStatus: string;
  sheetType: SheetType;
  divisionType: DivisionType;
  /** GET measure 결과셋에서 만든 편집가능 measure 집합. 비면 전 셀 잠금(닫히는 쪽 실패). */
  editableMeasures: Set<string>;
  /** LINE 시트에서만 채워지는 생산확정기간 잠금 컬럼 집합(`buildScpPlanFixedColumns`). */
  scpPlanFixedColumns?: Set<string>;
}

/**
 * 이 셀이 지금 편집 가능한가. `beginningEdit`/`pastingCell`/`formatItem` 공통 판정.
 * 조회 직후에는 전 셀이 읽기전용이다(03 R-15 — `AfterFindData` 가 전 컬럼을 잠근다).
 *
 * 분기(03 R-05 C1 / R-06 C2):
 *   (a) 고정영역 — 기간열도 `BASE_QTY` 도 아니면 전 행 잠금.
 *   (b) `BASE_QTY` — **CURRENT 와 (1차 x MODEL) 에서만** measure 기준 잠금 판정(V-30).
 *                    LINE 계열에는 컬럼 자체가 없다.
 *   (c) CURRENT 기간열 — `priorityNone || !editableMeasures.has(measure)`.
 *       단 `OPERATION_ID === 'AFFFF' && divisionType !== ELTR` 이면 **덮어쓰기**:
 *       `priorityNone || measure !== 'PROD_CAPA_D'` (Formation 행은 일 생산능력만 연다).
 *   (d) 1차컷오프 x LINE 기간열 — 위 (c) 기본식에 `measure === 'SCP_PROD_PLAN'` 이면
 *       생산확정기간 잠금을 추가로 AND 한다.
 */
export const isCellEditable = ({
  binding,
  row,
  isEditMode,
  progressStatus,
  sheetType,
  divisionType,
  editableMeasures,
  scpPlanFixedColumns,
}: EditableInput): boolean => {
  if (!isEditMode || !row || !binding) return false;

  const measure = toText(row[COLUMN.MEASURE]);
  const isMeasureLocked = !editableMeasures.has(measure);
  const isCurrent =
    progressStatus === PROGRESS_STATUS.PRE || progressStatus === PROGRESS_STATUS.CURRENT;

  // (b) BASE_QTY — CURRENT / (1차 x MODEL) 에서만 measure 기준 판정(V-30).
  if (binding === COLUMN.BASE_QTY) {
    const isFirstModel =
      progressStatus === PROGRESS_STATUS.FIRST_CUTOFF && sheetType === SHEET_TYPE.MODEL;
    if (!isCurrent && !isFirstModel) return false;
    return !isMeasureLocked;
  }

  // (a) 기간열이 아니면 전부 고정영역 — AS-IS `LockRange2(0,0,rowCnt-1,_fixed_column_idx,true)` 등가.
  if (!isEditablePeriodColumn(binding)) return false;

  if (isPriorityNone(row, binding)) return false;

  // (c) CURRENT 의 Formation 예외 — ELTR 축에는 적용하지 않는다.
  if (
    isCurrent &&
    divisionType !== DIVISION_TYPE.ELTR &&
    toText(row[COLUMN.OPERATION_ID]) === FORMATION_OPERATION_ID
  ) {
    return measure === MEASURE.PROD_CAPA_D;
  }

  if (isMeasureLocked) return false;

  // (d) 1차컷오프 x LINE 의 생산확정기간 잠금 — `SCP_PROD_PLAN` 행에만 건다.
  if (
    progressStatus === PROGRESS_STATUS.FIRST_CUTOFF &&
    sheetType === SHEET_TYPE.LINE &&
    measure === MEASURE.SCP_PROD_PLAN &&
    scpPlanFixedColumns?.has(binding)
  ) {
    return false;
  }

  return true;
};
