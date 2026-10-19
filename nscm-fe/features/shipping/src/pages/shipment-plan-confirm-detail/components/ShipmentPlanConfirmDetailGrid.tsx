import {
  AllowMerging,
  CellType,
  type FlexGrid as FlexGridType,
} from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { type MutableRefObject, useEffect } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import { GridUtils } from '@foundation/utils';
import { DataGrid } from '@shared/components';

import {
  BOD_ID_COLUMN,
  DIVISION_ID_COLUMN,
  DRILLDOWN,
  EE_DIVISION,
  MENU_ID,
  ORIGIN_FROM_DIVISION_ID_COLUMN,
} from '../shipment-plan-confirm-detail.constants';
import type { DrilldownParams, MainRow } from '../shipment-plan-confirm-detail.types';

interface Props {
  rows: MainRow[];
  gridRef: MutableRefObject<FlexGridType | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  adminColumns?: RawFlexGridColumnConfig[];
  // 셀 클릭 드릴다운(design 03 W9/W10) — 페이지가 모달 오픈.
  onDrilldown: (params: DrilldownParams) => void;
}

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

const DRILLDOWN_COLUMNS = new Set<string>([DRILLDOWN.INCOTERMS, DRILLDOWN.CHANGE_REQ_NO]);

// AS-IS spdMain "Shipment Plan Confirm Detail" (47컬럼, 전량 읽기전용 cs:439). 동적 PIVOT 없음(03 §2).
//   컬럼셋/2단 머지헤더/FIXED(INCOTERMS)/FCST_TYPE lookup 콤보는 admin SCM_MST_SHEET_COLUMNS 메타가 authoritative
//   (design 03 §0: 47행 배포됨) — 하드코딩 fallback 없음(#130, 47행 수기 전사 = anti-simplification 위반).
export const ShipmentPlanConfirmDetailGrid = ({
  rows,
  gridRef,
  gridFilterRef,
  adminColumns,
  onDrilldown,
}: Props) => {
  const columns = adminColumns ?? [];

  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;

    // W8: INCOTERMS/CHANGE_REQ_NO 셀에 드릴다운 어포던스(포인터 + 밑줄). CHANGE_REQ_NO 는 값 있을 때만.
    const formatItemHandler = (
      sender: FlexGridType,
      e: { panel: unknown; row: number; col: number; cell: HTMLElement }
    ) => {
      if (e.panel !== sender.cells) return;
      const binding = sender.columns[e.col]?.binding ?? '';
      if (!DRILLDOWN_COLUMNS.has(binding)) {
        e.cell.classList.remove('drilldown-cell');
        e.cell.style.cursor = '';
        return;
      }
      const row = GridUtils.getRow(sender, e.row) as Record<string, unknown> | undefined;
      const hasTarget =
        binding === DRILLDOWN.CHANGE_REQ_NO ? str(row?.[DRILLDOWN.CHANGE_REQ_NO]).trim() !== '' : true;
      e.cell.classList.toggle('drilldown-cell', hasTarget);
      e.cell.style.cursor = hasTarget ? 'pointer' : '';
    };
    g.formatItem.addHandler(formatItemHandler);

    // W9/W10 셀 클릭 드릴다운 + 가드(G1 빈 그리드 / G2 컬럼 판정 / G3 CHANGE_REQ_NO 공백).
    const clickHandler = (ev: MouseEvent) => {
      if (g.rows.length === 0) return; // G1
      const ht = g.hitTest(ev);
      if (ht.cellType !== CellType.Cell) return;
      const binding = g.columns[ht.col]?.binding ?? '';
      if (!DRILLDOWN_COLUMNS.has(binding)) return; // G2
      const row = GridUtils.getRow(g, ht.row) as Record<string, unknown> | undefined;
      if (!row) return;

      if (binding === DRILLDOWN.INCOTERMS) {
        // BOD 상세 — EE 분기면 ORIGIN_FROM_DIVISION_ID, 아니면 DIVISION_ID (design 03 §4 드릴다운).
        const divisionRaw = str(row[DIVISION_ID_COLUMN]);
        const divisionId = divisionRaw.includes(EE_DIVISION)
          ? str(row[ORIGIN_FROM_DIVISION_ID_COLUMN])
          : divisionRaw;
        onDrilldown({ kind: 'BOD', divisionId, bodId: str(row[BOD_ID_COLUMN]) });
        return;
      }
      // CHANGE_REQ_NO → 변경요청 상세. G3: 공백이면 미오픈.
      const changeReqNo = str(row[DRILLDOWN.CHANGE_REQ_NO]).trim();
      if (changeReqNo === '') return; // G3
      onDrilldown({ kind: 'REQUEST', changeReqNo });
    };
    g.hostElement.addEventListener('click', clickHandler);

    return () => {
      try {
        g.formatItem?.removeHandler(formatItemHandler);
        g.hostElement?.removeEventListener('click', clickHandler);
      } catch {
        /* unmount race */
      }
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [columns]);

  return (
    <DataGrid
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      // 전 컬럼 읽기전용(AS-IS 전열 잠금 cs:439). 편집/저장 없음 — EditTracker 미배선.
      isReadOnly
      itemsSource={rows as unknown as WijmoRowItem[]}
      // 47컬럼 admin 메타 소비(2단 머지헤더 SMALL_CLASS + INCOTERMS FIXED_FLAG=Y + FCST_TYPE FPComboBox lookup).
      staticColumns={columns}
      // FCST_TYPE 표시매핑(SALES_TYPE_CODE) 자동 콤보 @mnuId 토큰.
      comboParams={{ mnuId: `'${MENU_ID}'` }}
      // W1/W3/W7 세로 머지 sticky(design 03 §3, hook #69) + 2단 헤더 단독 컬럼 세로 병합(design 03 §1.1).
      //   All = 데이터 셀 + 컬럼 헤더 병합. Cells 만 주면 단독 컬럼 헤더가 2 tier 로 라벨 중복 노출됨.
      allowMerging={AllowMerging.All}
    />
  );
};
