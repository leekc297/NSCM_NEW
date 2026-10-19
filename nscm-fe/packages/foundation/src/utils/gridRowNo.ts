import { CellType, type FlexGrid } from '@mescius/wijmo.grid';

import { CELL_CONTROL_TYPE, CELL_INPUT_EDIT_TYPE } from '@foundation/constants';
import type { RawFlexGridColumnConfig } from '@foundation/models';

// No 컬럼/헤더 — SYS0011 그리드 공통 (사용자 요구 2026-06-28), 팝업(*Modal.tsx) 그리드 공통 적용
//   (2026-09-03)으로 foundation 으로 승격.
//   · 체크박스 없는 그리드: rowHeader 인덱스 컬럼이 행번호 표시 → 헤더(코너)에 'No' 라벨만
//     (attachRowNoHeader).
//   · 체크박스 그리드(useCheckbox → rowHeader 가 체크박스): 행번호 컬럼 없음 → 별도 No 컬럼 주입
//     (buildNoColumn) + ROW_NO 값 주입(withRowNo).
//   라벨 = LBL00674('No') i18n (호출부 t()).
export const ROW_NO_BINDING = 'ROW_NO';

// (체크박스 그리드) No 데이터 컬럼 — itemsSource 의 ROW_NO 값 표시.
export const buildNoColumn = (label: string): RawFlexGridColumnConfig => ({
  colNm: ROW_NO_BINDING,
  colLblNm: label,
  horzAlgnCd: 'C',
  cellCtrlObjTpCd: CELL_CONTROL_TYPE.TEXT,
  cellCboDataTp: 'string',
  inputTpCd: CELL_INPUT_EDIT_TYPE.SEARCH_ONLY, // 'S' — 정적
  colWth: 56,
  fixed: false,
  uppercase: false,
  visible: true,
  display: true,
});

// itemsSource 각 행에 ROW_NO(=index+1) 주입 (읽기전용 그리드라 무해).
export const withRowNo = <T extends object>(rows: T[]): Array<T & { ROW_NO: number }> =>
  rows.map((r, i) => ({ ...r, ROW_NO: i + 1 }));

// (체크박스 없는 그리드) 기존 rowHeader 순번(1,2,3…) 컬럼의 좌상단 코너 헤더(TopLeft 패널)에
//   'No' 라벨 추가. CellType.TopLeft 로 코너 셀 직접 타겟 (formatItem 1회 부착 가드 + invalidate).
export const attachRowNoHeader = (grid: FlexGrid, label: string): void => {
  const g = grid as FlexGrid & { __rowNoHdr?: boolean };
  if (g.__rowNoHdr) return;
  g.__rowNoHdr = true;
  grid.formatItem.addHandler((_, e) => {
    if (e.panel.cellType === CellType.TopLeft) {
      e.cell.textContent = label;
      e.cell.style.fontWeight = 'normal'; // 헤더 기본 bold 해제 (사용자 요구 2026-06-28)
    }
  });
  grid.invalidate();
};
