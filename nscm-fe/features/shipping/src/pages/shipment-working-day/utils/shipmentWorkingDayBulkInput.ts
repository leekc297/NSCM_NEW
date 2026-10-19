import type { FlexGrid } from '@mescius/wijmo.grid';

import type { EditTracker } from '@foundation/utils';

import { DAY_BINDING_RE, DAY_WEEK } from '../shipment-working-day.constants';
import type { ShipmentWorkingDayRow } from '../shipment-working-day.types';

interface BulkInputArgs {
  grid: FlexGrid<ShipmentWorkingDayRow>;
  // 공용 EditTracker — 저장 payload 의 단일 진실원.
  tracker?: EditTracker<ShipmentWorkingDayRow>;
  // WEEK_WORK_TIME lookup 값(EveryDay / SelectDay / Mon~Sun).
  dayWeekCode: string;
  // cboInputValue 값(Y/N).
  value: string;
  // binding -> DAY_CODE(MON~SUN). 요일별 분기 판정 원천.
  dayCodeByBinding: Map<string, string>;
}

// AS-IS 가드 #4(.cs:694-701) 등가 — "SelectDay 인데 선택영역이 없다" 판정.
//   AS-IS FarPoint GetSelections() 는 드래그·행헤더·열헤더로 만든 선택영역만 돌려주고 단일 셀
//   클릭에는 빈 배열이었다. Wijmo selectedRanges 는 현재 셀 하나만 있어도 1x1 범위를 돌려주므로
//   length 로 판정하면 이 가드가 영구 false 가 된다 — 2셀 이상 덮는 범위를 요구해 등가를 만든다.
export const hasCellRangeSelection = (grid: FlexGrid<ShipmentWorkingDayRow>): boolean =>
  (grid.selectedRanges ?? []).some(range => range.rowSpan > 1 || range.columnSpan > 1);

// AS-IS BtnInput_Click(.cs:671-822)의 일괄 입력 5분기.
//
//   | 모드                         | 대상                                   | AS-IS       |
//   |------------------------------|----------------------------------------|-------------|
//   | SelectDay + 행 선택          | 그 행의 모든 D_ 컬럼                   | .cs:744-757 |
//   | SelectDay + 열 선택          | 전 행 x 선택 열 범위의 D_ 컬럼         | .cs:758-772 |
//   | SelectDay + 블록 선택        | 블록 안의 D_ 컬럼                      | .cs:773-787 |
//   | EveryDay                     | 전 행 x 전 D_ 컬럼                     | .cs:800-803 |
//   | Mon~Sun                      | 전 행 x DAY_CODE 일치 D_ 컬럼          | .cs:804-811 |
//
//   AS-IS 는 FarPoint `GetSelections()` 가 행 선택을 col=-1, 열 선택을 row=-1 로 돌려주는 것을
//   분기 조건으로 썼다. Wijmo `selectedRanges` 는 항상 사각 범위라 -1 이 없으므로, 범위가 전 컬럼을
//   덮으면 행 선택 / 전 행을 덮으면 열 선택으로 환산한다. 세 분기 모두 "범위 안의 D_ 셀"이라는
//   같은 결과로 수렴하지만, 행 선택은 AS-IS 문언대로 "그 행의 모든 D_" 를 명시적으로 쓴다.
//
//   필수: 모든 write 는 EditTracker.storeChange 를 거친다. grid.setCellData 만 부르면 CRUD_TYPE 이
//   안 찍혀 저장 대상에서 통째로 빠진다(AS-IS 가 `Modify()` 를 건너뛰어 빠진 것과 같은 축, 03 §3-c).
export const applyBulkInput = ({
  grid,
  tracker,
  dayWeekCode,
  value,
  dayCodeByBinding,
}: BulkInputArgs): number => {
  const rowCount = grid.rows.length;
  const colCount = grid.columns.length;
  if (rowCount === 0 || colCount === 0) return 0;

  const bindingAt = (col: number): string => grid.columns[col]?.binding ?? '';
  const isDayCol = (col: number): boolean => DAY_BINDING_RE.test(bindingAt(col));

  // 대상 셀 좌표 집합. 같은 셀이 여러 선택영역에 겹쳐도 한 번만 쓴다.
  const targets = new Set<string>();
  const mark = (row: number, col: number) => {
    if (row < 0 || row >= rowCount || col < 0 || col >= colCount) return;
    if (!isDayCol(col)) return;
    targets.add(`${row}:${col}`);
  };
  const markWholeRow = (row: number) => {
    for (let col = 0; col < colCount; col++) mark(row, col);
  };

  if (dayWeekCode === DAY_WEEK.SELECT_DAY) {
    const ranges = grid.selectedRanges ?? [];
    for (const range of ranges) {
      const isFullRowSelection = range.leftCol <= 0 && range.rightCol >= colCount - 1;
      const isFullColSelection = range.topRow <= 0 && range.bottomRow >= rowCount - 1;
      if (isFullRowSelection) {
        // 행 선택 — 그 행의 모든 D_ 컬럼(.cs:744-757).
        for (let row = range.topRow; row <= range.bottomRow; row++) markWholeRow(row);
        continue;
      }
      if (isFullColSelection) {
        // 열 선택 — 전 행 x 선택 열(.cs:758-772).
        for (let col = range.leftCol; col <= range.rightCol; col++) {
          for (let row = 0; row < rowCount; row++) mark(row, col);
        }
        continue;
      }
      // 블록 선택 — 블록 안의 D_ 컬럼(.cs:773-787).
      for (let row = range.topRow; row <= range.bottomRow; row++) {
        for (let col = range.leftCol; col <= range.rightCol; col++) mark(row, col);
      }
    }
  } else {
    // EveryDay = 전 D_ / 요일별 = DAY_CODE 일치 D_. 대소문자 무시 비교는 AS-IS .cs:808 ToUpper 1:1
    //   (lookup 값은 Mon/Tue.. 혼합, DAY_CODE 는 MON/TUE.. 대문자라 정규화가 필수다).
    const isEveryDay = dayWeekCode === DAY_WEEK.EVERY_DAY;
    const wanted = dayWeekCode.toUpperCase();
    for (let col = 0; col < colCount; col++) {
      if (!isDayCol(col)) continue;
      if (!isEveryDay && (dayCodeByBinding.get(bindingAt(col)) ?? '') !== wanted) continue;
      for (let row = 0; row < rowCount; row++) mark(row, col);
    }
  }

  if (targets.size === 0) return 0;

  let written = 0;
  // 대량 write 를 한 번의 레이아웃 갱신으로 묶는다(AS-IS CanModelChange 로 이벤트 재진입을
  //   막고 일괄 SetText 하던 구간의 등가, .cs:720-730).
  grid.deferUpdate(() => {
    for (const key of targets) {
      const [rowText, colText] = key.split(':');
      const row = Number(rowText);
      const col = Number(colText);
      const item = (grid.rows[row] as { dataItem?: ShipmentWorkingDayRow } | undefined)?.dataItem;
      if (!item) continue;
      const binding = bindingAt(col);
      const original = grid.getCellData(row, col, false) as WijmoPrimitive;
      grid.setCellData(row, col, value, true);
      tracker?.storeChange(item, binding, original, value);
      written += 1;
    }
  });
  return written;
};
