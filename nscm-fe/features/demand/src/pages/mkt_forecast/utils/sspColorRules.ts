import type { MktFcstRow } from '../mkt-forecast-master.types';

// AS-IS DMF0003_1_MktFcst.cs L4829 chkColor_CheckedChanged + L1768 SSP sync color
//   - 색상 표시 (chkColor ON 시):
//     - 동기화 O = 파랑 (rgb(173, 216, 230))
//     - 미동기 = 빨강 (rgb(255, 182, 193))
//     - 동기화 수량 이상 = 경고 (rgb(255, 255, 0))
//   - SSP Sync vs DP 수량 차이 (iWeeklySum < iWkSum_Sync) 시 색상 강조
//   - 2번 롤백 이력 (2020-10-29 원복 → 2020-12-28 재활성화)
//
// Phase 6 적용 — Wijmo FlexGrid formatItem callback 으로 cell.style 적용

export type CellStyle = {
  background?: string;
  color?: string;
  fontWeight?: string;
};

const COLOR_BLUE = 'rgb(173, 216, 230)';  // 동기화 O
const COLOR_RED = 'rgb(255, 182, 193)';   // 미동기
const COLOR_YELLOW = 'rgb(255, 255, 0)';  // 경고

// Cell 색상 결정 — formatItem callback 안에서 호출
export function getCellColor(
  row: MktFcstRow,
  colKey: string,
  showColor: boolean,
): CellStyle | null {
  if (!showColor) return null;

  // bucket cell 만 색상 적용 (D_/W_/M_YYYYMMDD)
  if (!/^[DWM]_\d{6,8}$/.test(colKey)) return null;

  const value = row[colKey];
  if (value === undefined || value === '' || value === null) return null;

  // SSP 동기화 측 row — MEASURE 가 'SYNC' 류 인 경우
  if (typeof row.MEASURE === 'string' && row.MEASURE.includes('SYNC')) {
    return { background: COLOR_BLUE };
  }

  // MKT_FCST_RP (실적) row 는 미동기 빨강
  if (row.MEASURE === 'MKT_FCST_RP') {
    return { background: COLOR_RED };
  }

  // 합계 변수 비교 — Phase 3 expression 의 iWeeklySum vs iWkSum_Sync (Phase 6 보강 시)
  return null;
}

// Wijmo FlexGrid formatItem helper — sender + cellRange
export function applyCellColor(
  panel: { rows: { [n: number]: { dataItem: unknown } }; columns: { [n: number]: { binding: string } } },
  rowIndex: number,
  colIndex: number,
  cell: HTMLElement,
  showColor: boolean,
): void {
  const row = panel.rows[rowIndex]?.dataItem as MktFcstRow | undefined;
  const colKey = panel.columns[colIndex]?.binding;
  if (!row || !colKey) return;

  const style = getCellColor(row, colKey, showColor);
  if (style?.background) cell.style.backgroundColor = style.background;
  if (style?.color) cell.style.color = style.color;
  if (style?.fontWeight) cell.style.fontWeight = style.fontWeight;
}

export { COLOR_BLUE, COLOR_RED, COLOR_YELLOW };
