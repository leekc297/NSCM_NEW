import { CellType, type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { type MutableRefObject } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import { DataGrid } from '@shared/components';

import type { MasterValidationRow } from '../master-validation.types';

import styles from './MasterValidationMasterGrid.module.scss';

interface Props {
  gridRef: MutableRefObject<FlexGrid<MasterValidationRow> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  data: MasterValidationRow[];
  // "Validation Info" 메타(admin fetch — 하드코딩 금지). QUERY/OPEN 액션 컬럼 포함.
  staticColumns: RawFlexGridColumnConfig[];
  onQuery: (row: MasterValidationRow) => void;
  onOpen: (row: MasterValidationRow) => void;
  onRowSelect: (row: MasterValidationRow) => void;
  // 모든 셀 클릭 공통(QUERY/OPEN 포함) — CONSTRAINTS01 조회조건 잠금 재계산.
  onCellClick: (row: MasterValidationRow) => void;
  gotFocus?: () => void;
}

// 마스터 목록(siMain "Validation Info") — read-only. QUERY/OPEN 액션셀만 클릭 동작(design 01 R20).
//   QUERY 클릭 = 해당 행 검증 SP dispatch, OPEN 클릭 = PROGRAM_ID 네비게이션. 그 외 셀 클릭 = 행 선택
//   (CONSTRAINTS01 파싱으로 조회조건 잠금 + detail sheet 프리뷰 전환, design 01 §2-C R15).
export const MasterValidationMasterGrid = ({
  gridRef,
  gridFilterRef,
  data,
  staticColumns,
  onQuery,
  onOpen,
  onRowSelect,
  onCellClick,
  gotFocus,
}: Props) => {
  // QUERY/OPEN 컬럼은 데이터 바인딩이 없는 액션셀 — formatItem 으로 버튼(FPButton 등가, design 03 §1.1)을
  //   렌더한다. 버튼은 시각 표현일 뿐이고 실제 클릭 처리는 handleClick 의 hitTest(binding) 가 맡는다.
  //   PROCEDURE_NAME='-' 행(Sales Site 등 비활성)은 QUERY 를 비워 조회 불가를 시각화한다(design 03 §3).
  //   주의: useEffect([gridRef]) 로 붙이면 첫 렌더에 grid 미초기화 시 핸들러가 영영 미등록된다
  //   ([[formatitem-effect-grid-ready-dep]]). DataGrid initialized(grid 준비 직후 1회)에서 등록한다.
  const handleInitialized = (grid: FlexGrid<MasterValidationRow>) => {
    grid.formatItem.addHandler(
      (_s: unknown, e: { cell: HTMLElement; row: number; col: number; panel: { cellType: CellType } }) => {
        if (e.panel.cellType !== CellType.Cell || e.row < 0) return;
        const binding = grid.columns[e.col]?.binding;
        if (binding !== 'QUERY' && binding !== 'OPEN') return;
        const row = grid.rows[e.row]?.dataItem as MasterValidationRow | undefined;
        // QUERY = 조회가능 행(PROCEDURE_NAME 유효), OPEN = PROGRAM_ID 유효 행만 버튼 노출.
        const enabled =
          binding === 'QUERY'
            ? (row?.PROCEDURE_NAME ?? '').trim() !== '' && (row?.PROCEDURE_NAME ?? '') !== '-'
            : (row?.PROGRAM_ID ?? '').trim() !== '';
        if (!row || !enabled) {
          e.cell.replaceChildren();
          return;
        }
        const button = globalThis.document.createElement('button');
        button.type = 'button';
        button.className = styles.actionButton;
        button.textContent = binding; // 'QUERY' | 'OPEN'
        // 고정 높이(16px) 버튼을 셀 안에서 세로 가운데 정렬 — 셀을 flex 로(버튼 scss height 와 함께,
        //   PlanManagement cellButton 선례: 기본 셀 높이에 버튼이 커 보이던 문제 해소).
        e.cell.style.padding = '0 4px';
        e.cell.style.display = 'flex';
        e.cell.style.alignItems = 'center';
        e.cell.style.justifyContent = 'center';
        e.cell.replaceChildren(button);
      }
    );
  };

  const handleClick = (mouseEvent: MouseEvent) => {
    const grid = gridRef.current;
    if (!grid) return;
    const ht = grid.hitTest(mouseEvent);
    if (ht.cellType !== CellType.Cell || ht.row < 0) return;
    const row = grid.rows[ht.row]?.dataItem as MasterValidationRow | undefined;
    if (!row) return;
    // 조회조건 잠금은 QUERY/OPEN 포함 모든 셀 클릭마다 재계산(AS-IS SpdMain_CellClick cs:1011~1040 은
    //   분기 뒤 공통 수행 — 다른 행 QUERY 클릭 시에도 잠금 해제).
    onCellClick(row);
    const binding = grid.columns[ht.col]?.binding;
    if (binding === 'QUERY') {
      if ((row.PROCEDURE_NAME ?? '').trim() !== '' && row.PROCEDURE_NAME !== '-') onQuery(row);
    } else if (binding === 'OPEN') {
      if ((row.PROGRAM_ID ?? '').trim() !== '') onOpen(row);
    } else {
      onRowSelect(row);
    }
  };

  return (
    <DataGrid<MasterValidationRow>
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      isReadOnly
      itemsSource={data}
      staticColumns={staticColumns}
      initialized={handleInitialized}
      click={handleClick}
      gotFocus={gotFocus}
    />
  );
};
