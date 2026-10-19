import type { FlexGrid } from '@mescius/wijmo.grid';

import dayjs from '@foundation/dayjs';
import type { EditTracker } from '@foundation/utils';

import { MEASURE } from '../capa-mobility-it.constants';
import type { CapaRowItem } from '../capa-mobility-it.types';

import { kindOf } from './capa-mobility-it.dynamicColumns';

export type BulkInputError =
  | 'INVALID_YN' // NO_WORK Y/N 아님
  | 'INVALID_LOAD_RATE' // 0.0~100.0 벗어남
  | 'INVALID_RAMP_UP' // 0.0~1.0 벗어남
  | 'INVALID_DAILY_CAPA' // 빈 값 또는 정수 < 0
  | 'WEEKDAY_NOT_ALLOWED'; // DAILY_CAPA 에 요일 Type

/** AS-IS Day Type(cboDayWeek) 9옵션 — EveryDay/SelectDay 는 범위 지정, Mon~Sun 은 일(D_) 컬럼의 요일 필터. */
export const BULK_TYPE = {
  EVERY_DAY: 'EveryDay',
  SELECT_DAY: 'SelectDay',
  MON: 'Mon',
  TUE: 'Tue',
  WED: 'Wed',
  THU: 'Thu',
  FRI: 'Fri',
  SAT: 'Sat',
  SUN: 'Sun',
} as const;

export type BulkType = (typeof BULK_TYPE)[keyof typeof BULK_TYPE];

const RANGE_TYPES: readonly BulkType[] = [BULK_TYPE.EVERY_DAY, BULK_TYPE.SELECT_DAY];

/** 요일 Type → dayjs().day() 값(일요일=0). */
const WEEKDAY_INDEX: Partial<Record<BulkType, number>> = {
  [BULK_TYPE.SUN]: 0,
  [BULK_TYPE.MON]: 1,
  [BULK_TYPE.TUE]: 2,
  [BULK_TYPE.WED]: 3,
  [BULK_TYPE.THU]: 4,
  [BULK_TYPE.FRI]: 5,
  [BULK_TYPE.SAT]: 6,
};

/** 팝업 Type 선택지 — AS-IS 와 같은 9개를 항상 보인다. DAILY_CAPA 에 요일을 고르면 검증(validateBulkType)이 거부한다. */
export const BULK_TYPE_OPTIONS: { label: string; value: BulkType }[] = Object.values(BULK_TYPE).map(type => ({
  label: type,
  value: type,
}));

interface BulkInputArgs {
  grid: FlexGrid;
  tracker: EditTracker;
  category: string; // measure code (NO_WORK/LOAD_RATE/RAMP_UP/DAILY_CAPA)
  type: BulkType;
  value: string;
  isCellEditable: (binding: string, row: CapaRowItem) => boolean;
}

/** Type 과 measure 조합 검증. null = 통과. AS-IS: DAILY_CAPA 는 월 입력이라 요일 Type 을 거부한다(.cs:3892~3897). */
export const validateBulkType = (category: string, type: BulkType): BulkInputError | null =>
  category === MEASURE.DAILY_CAPA && !RANGE_TYPES.includes(type) ? 'WEEKDAY_NOT_ALLOWED' : null;

/** 값 검증 (design 03 §R2 / buttonGuards #19~27). null = 통과, 그 외 = 에러코드. */
export const validateBulkValue = (category: string, value: string): BulkInputError | null => {
  const v = value.trim();
  if (category === MEASURE.NO_WORK) {
    // AS-IS btnInput_Click: NO_WORK 빈값은 'N'으로 치환 후 통과(SCP0098_CAPAReprotSmall.cs:3831).
    return v === '' || v === 'Y' || v === 'N' ? null : 'INVALID_YN';
  }
  const n = Number(v);
  if (category === MEASURE.LOAD_RATE) {
    return Number.isFinite(n) && n >= 0 && n <= 100 ? null : 'INVALID_LOAD_RATE';
  }
  if (category === MEASURE.RAMP_UP) {
    return Number.isFinite(n) && n >= 0 && n <= 1 ? null : 'INVALID_RAMP_UP';
  }
  if (category === MEASURE.DAILY_CAPA) {
    // AS-IS int.Parse("") 는 예외라 빈 값을 거부한다. Number('') 는 0 이라 따로 막는다.
    return v !== '' && Number.isFinite(n) && Number.isInteger(n) && n >= 0 ? null : 'INVALID_DAILY_CAPA';
  }
  return null;
};

/** 그리드에 유효한 선택이 있는지. SelectDay 는 선택 영역이 범위를 정한다. */
export const hasBulkSelection = (grid: FlexGrid): boolean =>
  grid.selectedRanges.some(range => range.isValid);

/** 일(D_) 컬럼의 요일이 Type 과 같은지. 요일 Type 이 아니면 항상 참. */
const matchesWeekday = (binding: string, type: BulkType): boolean => {
  const target = WEEKDAY_INDEX[type];
  if (target === undefined) return true;
  const ymd = binding.slice(2); // D_YYYYMMDD
  return dayjs(`${ymd.slice(0, 4)}-${ymd.slice(4, 6)}-${ymd.slice(6, 8)}`).day() === target;
};

/**
 * Bulk Update 일괄입력 (AS-IS btnInput_Click 통합 — Type + Input Value).
 *   - 대상 컬럼 종류: DAILY_CAPA→M_(월), 그 외→D_(일). 대상 행: MEASURE_UI === category 인 행.
 *   - EveryDay: 대상 행 x 대상 컬럼 전체.
 *   - SelectDay: 그리드 선택 영역(다중 범위)의 행 x 컬럼 교집합만. 행·컬럼·셀 선택을 한 규칙으로 처리한다.
 *     DAILY_CAPA(M_ 대상)는 선택한 일(D_) 셀이 속한 월의 M_ 에 입력한다.
 *   - Mon~Sun: 대상 행의 D_ 컬럼 중 요일이 일치하는 컬럼.
 *   - 값은 검증(validateBulkType, validateBulkValue) 통과 후 호출한다. 반환값 = 변경한 셀 수.
 */
export const applyBulkInput = (args: BulkInputArgs): number => {
  const { grid, tracker, category, type, value, isCellEditable } = args;
  const targetKind = category === MEASURE.DAILY_CAPA ? 'M' : 'D';
  const next = category === MEASURE.NO_WORK ? value.trim().toUpperCase() || 'N' : Number(value);

  // SelectDay 범위. 월(M_)이 대상이면 선택한 일(D_) 셀이 속한 월을 `행:YYYYMM` 으로 모은다.
  // M_ 컬럼은 Daily 에서 숨겨져 있어 인덱스 교집합으로는 대응되지 않고, 월 사이에 낀 숨은 M_ 가 우연히 걸리는 것도 막는다.
  const inScope = new Set<string>();
  if (type === BULK_TYPE.SELECT_DAY) {
    grid.selectedRanges.forEach(range => {
      if (!range.isValid) return;
      for (let r = range.topRow; r <= range.bottomRow; r++) {
        for (let c = range.leftCol; c <= range.rightCol; c++) {
          if (targetKind === 'M') {
            const binding = grid.columns[c]?.binding ?? '';
            if (kindOf(binding) === 'D') inScope.add(`${r}:${binding.slice(2, 8)}`);
          } else {
            inScope.add(`${r}:${c}`);
          }
        }
      }
    });
  }

  let changed = 0;
  grid.rows.forEach((gridRow, rowIndex) => {
    const row = gridRow.dataItem as CapaRowItem | undefined;
    if (!row) return;
    if ((typeof row.MEASURE_UI === 'string' ? row.MEASURE_UI : '') !== category) return;
    grid.columns.forEach((col, colIndex) => {
      const binding = col.binding ?? '';
      if (kindOf(binding) !== targetKind) return;
      if (type === BULK_TYPE.SELECT_DAY) {
        const key = targetKind === 'M' ? `${rowIndex}:${binding.slice(2)}` : `${rowIndex}:${colIndex}`;
        if (!inScope.has(key)) return;
      }
      if (targetKind === 'D' && !matchesWeekday(binding, type)) return;
      if (!isCellEditable(binding, row)) return;
      const old = (row as Record<string, unknown>)[binding];
      tracker.storeChange(row as never, binding, old as never, next as never);
      (row as Record<string, unknown>)[binding] = next;
      changed++;
    });
  });
  grid.invalidate();
  return changed;
};
