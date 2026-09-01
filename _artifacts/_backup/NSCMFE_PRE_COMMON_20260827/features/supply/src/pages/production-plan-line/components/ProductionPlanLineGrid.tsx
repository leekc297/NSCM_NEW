import type { FlexGrid as FlexGridType, FormatItemEventArgs } from '@mescius/wijmo.grid';
import { AllowMerging, CellType } from '@mescius/wijmo.grid';
import { type MutableRefObject, useEffect, useMemo } from 'react';

import { DataGrid } from '@shared/components';

import {
  DIV40_ONLY_COLUMNS,
  EE_ELECTRODE_GROUP_COLUMNS,
  EE_ONLY_COLUMNS,
  MAIN_COLUMNS,
  SHEETS,
} from '../production-plan-line.constants';
import type { ProductionPlanLineRow } from '../production-plan-line.types';
import { useProductionPlanLineStore } from '../useProductionPlanLineStore';

interface ProductionPlanLineGridProps {
  gridRef: MutableRefObject<FlexGridType<ProductionPlanLineRow> | undefined>;
  rows: ProductionPlanLineRow[];
}

// SCP0013 메인 그리드 (AS-IS spdMain 'Line' 시트) — Phase A: read-only shell.
//   - staticColumns = admin SCM_MST_SHEET_COLUMNS 동적 fetch(사내 'Line' 27행 실측) + MAIN_COLUMNS fallback.
//   - Division 별 컬럼 노출 분기 = AS-IS InitSpread L339~370 1:1 (메타 DIVISION_ID 공란 → 코드 분기).
//   - 동적 기간 컬럼(D_/W_/M_ 3단 헤더)·계층 세로머지·Fix Green·편집 Yellow 는 SP 변환 후
//     조회 활성화와 함께 배선 (A5 handoff — Phase A 는 데이터 0행이므로 shell 까지).
//   - ⭐ hook #108 — rowHeader(순번) TopLeft 'No.' 단일 머지 + allowMerging.
//   - ⭐ hook #95 — 3색 표준: read-only 화면은 White+zebra (전체 회색 금지, 클래스 미부여).
export const ProductionPlanLineGrid = ({ gridRef, rows }: ProductionPlanLineGridProps) => {
  const staticColumnsBySheet = useProductionPlanLineStore(s => s.staticColumns);
  const divisionId = useProductionPlanLineStore(s => s.searchCondition.divisionId);
  const operationGroup = useProductionPlanLineStore(s => s.searchCondition.operationGroup);

  // admin 동적 fetch 우선, 미적재 시 fallback (hook: visible fallback 손실 금지 — 빈 배열일 때만 대체).
  const fetched = staticColumnsBySheet[SHEETS.MAIN];
  const baseColumns = fetched.length > 0 ? fetched : MAIN_COLUMNS;

  // ⭐ Division 별 컬럼 노출 (AS-IS InitSpread L339~370 1:1):
  //   비 EE: ORIGIN_DIVISION_ID/ELECTRODE_TYPE/UNIT/CELL_ID 숨김, '40' 만 CELL_TYPE_GROUP_CODE/EXTRA_SPEC 표시.
  //   EE   : ORIGIN_DIVISION_ID/ELECTRODE_TYPE 표시, operationGroup 'E' 만 UNIT/CELL_ID 표시.
  const visibleColumns = useMemo(() => {
    const isEE = divisionId === 'EE';
    const hidden = new Set<string>();
    if (!isEE) {
      EE_ONLY_COLUMNS.forEach(c => hidden.add(c));
      EE_ELECTRODE_GROUP_COLUMNS.forEach(c => hidden.add(c));
      if (divisionId !== '40') DIV40_ONLY_COLUMNS.forEach(c => hidden.add(c));
    } else {
      if (operationGroup !== 'E') EE_ELECTRODE_GROUP_COLUMNS.forEach(c => hidden.add(c));
      DIV40_ONLY_COLUMNS.forEach(c => hidden.add(c));
    }
    return baseColumns.filter(c => !hidden.has(c.colNm));
  }, [baseColumns, divisionId, operationGroup]);

  // ⭐ hook #108 — TopLeft 코너 'No.' 라벨 (setCellData 현재값 비교 재귀 가드) + 중앙 정렬.
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;

    const formatHandler = (_s: FlexGridType<ProductionPlanLineRow>, e: FormatItemEventArgs) => {
      if (e.panel.cellType === CellType.TopLeft) {
        if (e.panel.getCellData(e.row, e.col, false) !== 'No.') {
          e.panel.setCellData(e.row, e.col, 'No.');
        }
        e.cell.style.textAlign = 'center';
        return;
      }
      if (e.panel.cellType === CellType.ColumnHeader) {
        e.cell.style.textAlign = 'center';
      }
    };
    g.formatItem.addHandler(formatHandler);
    return () => {
      g.formatItem.removeHandler(formatHandler);
    };
    // dependency = 컬럼 재구성 시 재등록 (mount 1회 금지 — hook #70 런타임 사고 7종)
  }, [gridRef, visibleColumns]);

  return (
    <DataGrid<ProductionPlanLineRow>
      gridRef={gridRef}
      isReadOnly
      selectionMode='Row'
      allowMerging={AllowMerging.All}
      staticColumns={visibleColumns}
      itemsSource={rows}
    />
  );
};
