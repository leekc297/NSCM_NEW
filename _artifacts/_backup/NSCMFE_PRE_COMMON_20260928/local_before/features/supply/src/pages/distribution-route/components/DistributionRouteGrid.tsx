import { CellType, type FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { type MutableRefObject, useEffect, useMemo } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { DataGrid } from '@shared/components';
import { useMessageStore } from '@shared/stores';

import {
  DAYS_AUTO_MODES,
  FROM_CELL_BINDINGS,
  LT_SEGMENT_COLUMNS,
  LT_SUM_MAX,
  MSG,
  ROUTE_COLUMNS,
  ROUTE_ID_BINDING,
  TO_CELL_BINDINGS,
} from '../distribution-route.constants';
import type { DistributionRouteRow } from '../distribution-route.types';
import { buildColumns } from '../utils/distributionRoute.columns';
import { daysAllYes, portsDash, sumLeadTime } from '../utils/distributionRoute.derive';
import { isRouteCellEditable } from '../utils/distributionRoute.editLock';

interface Props {
  rows: DistributionRouteRow[];
  gridRef: MutableRefObject<FlexGridType | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  editTrackerRef: MutableRefObject<EditTracker | undefined>;
  adminColumns?: RawFlexGridColumnConfig[];
  onFromCellDblClick: (row: DistributionRouteRow, rowIndex: number) => void;
  onToCellDblClick: (row: DistributionRouteRow, rowIndex: number) => void;
  onRouteIdDblClick: (row: DistributionRouteRow) => void;
  onFocus: () => void;
}

const s = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

export const DistributionRouteGrid = ({
  rows,
  gridRef,
  gridFilterRef,
  editTrackerRef,
  adminColumns,
  onFromCellDblClick,
  onToCellDblClick,
  onRouteIdDblClick,
  onFocus,
}: Props) => {
  const { t } = useTranslation();
  const setToast = useMessageStore.getState().setToast;

  const columns = useMemo(() => buildColumns(ROUTE_COLUMNS, adminColumns), [adminColumns]);

  // 편집잠금(beginningEdit) + 파생 Auto-Sync(cellEditEnded) + 도시/이력 팝업(dblclick) 핸들러.
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;

    // 항상-잠금 컬럼(키/파생명/합계/감사) 편집 차단, 그 외 편집 허용 (design 03 §1 — editLock white-list).
    const beginningEditHandler = (
      sender: FlexGridType,
      e: { cancel: boolean; row: number; col: number }
    ) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      if (!isRouteCellEditable(binding)) e.cancel = true;
    };
    g.beginningEdit.addHandler(beginningEditHandler);

    // 파생 Auto-Sync (design 03 R9/R10/R13).
    const cellEditEndedHandler = (sender: FlexGridType, e: { row: number; col: number }) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      const row = sender.rows[e.row]?.dataItem as Record<string, unknown> | undefined;
      if (!row) return;
      const tracker = editTrackerRef.current;
      const setCell = (key: string, value: unknown) => {
        const prev = row[key];
        if (prev === value) return;
        tracker?.storeChange(row as never, key, prev as never, value as never);
        row[key] = value;
      };

      // R9: TRANSPORT_MODE 가 TRK/AIR → 요일 7개 전부 'Y'. R10: TRK → 港·Forwarder 7개 '-'.
      if (binding === 'TRANSPORT_MODE') {
        const mode = s(row.TRANSPORT_MODE).toUpperCase();
        if ((DAYS_AUTO_MODES as readonly string[]).includes(mode)) {
          const days = daysAllYes();
          Object.keys(days).forEach(k => setCell(k, days[k]));
        }
        if (mode === 'TRK') {
          const dash = portsDash();
          Object.keys(dash).forEach(k => setCell(k, dash[k]));
        }
      }

      // R13: LT 5종 변경 → LT_SUM 재계산. 합>999 면 방금 바꾼 컬럼 0 리셋 + alert(차단).
      if ((LT_SEGMENT_COLUMNS as readonly string[]).includes(binding)) {
        let total = sumLeadTime(row);
        if (total > LT_SUM_MAX) {
          setCell(binding, 0);
          total = sumLeadTime(row);
          void setToast({
            type: 'error',
            message: t(MSG.LT_SUM_MAX, '_Only values equal to or below {0} are allowed.').replace(
              '{0}',
              String(LT_SUM_MAX)
            ),
          });
        }
        setCell('LT_SUM', total);
      }

      sender.invalidate();
    };
    g.cellEditEnded.addHandler(cellEditEndedHandler);
    g.pastedCell.addHandler(cellEditEndedHandler);

    // FROM/TO 도시 셀 더블클릭 → 도시팝업 (R11/R12), ROUTE_ID 더블클릭 → 이력팝업 (R8).
    const dblclickHandler = (ev: MouseEvent) => {
      const ht = g.hitTest(ev);
      if (ht.cellType !== CellType.Cell) return;
      const binding = g.columns[ht.col]?.binding ?? '';
      const row = g.rows[ht.row]?.dataItem as DistributionRouteRow | undefined;
      if (!row) return;
      if ((FROM_CELL_BINDINGS as readonly string[]).includes(binding)) {
        onFromCellDblClick(row, ht.row);
      } else if ((TO_CELL_BINDINGS as readonly string[]).includes(binding)) {
        onToCellDblClick(row, ht.row);
      } else if (binding === ROUTE_ID_BINDING) {
        onRouteIdDblClick(row);
      }
    };
    g.hostElement.addEventListener('dblclick', dblclickHandler);

    // 2단 그룹 헤더(To Site / Lead Time / Logistics Cost)의 리프(2단) 라벨은 여러 단어라 좁은 컬럼에서
    //   2줄로 줄바꿈되는데(.wj-cell.wj-header white-space:normal), Wijmo 기본 리프 행(24px)에서는 아랫줄이
    //   잘린다. 그룹 라벨(1단)은 1줄이라 그대로 두고 리프 행(마지막 헤더 row)만 40px 로 키운다.
    //   공용 mapRawColumnsToWijmoColumns 가 depth 별 height(2단=24)를 컬럼에 박고 wijmo _buildColumnGroups
    //   가 그 값을 헤더 row 의 명시 height 로 박아 rows 설정을 이긴다 — 그래서 매 updatedLayout 마다
    //   재강제한다(형제 다단 헤더 그리드 동형, #93). 목표 높이면 즉시 빠져나와 무한 invalidate 를 막는다.
    const GROUP_HEADER_HEIGHT = 24; // 1단(그룹 라벨) — 1줄, 기본 유지
    const LEAF_HEADER_HEIGHT = 40; // 2단(리프) — 2줄 라벨 수용
    const applyLeafHeaderHeight = () => {
      const headerRows = g.columnHeaders?.rows;
      if (!headerRows || headerRows.length < 2) return; // 단일 헤더(그룹 없음/로딩 중)는 기본 유지
      const last = headerRows.length - 1;
      let changed = false;
      // 형제 다단 헤더 그리드처럼 전 헤더 row 를 명시 설정한다 — 리프만 건드리면 wijmo 가 baked
      //   컬럼 height(24)로 되돌린다. 마지막(리프) row 만 키우고 나머지(그룹)는 24 로 고정.
      for (let i = 0; i <= last; i += 1) {
        const target = i === last ? LEAF_HEADER_HEIGHT : GROUP_HEADER_HEIGHT;
        if (Math.round(headerRows[i].height ?? headerRows.defaultSize) !== target) {
          headerRows[i].height = target;
          changed = true;
        }
      }
      if (changed) g.invalidate(true);
    };
    applyLeafHeaderHeight();
    g.updatedLayout.addHandler(applyLeafHeaderHeight);
    g.invalidate(true);

    return () => {
      try {
        g.beginningEdit?.removeHandler(beginningEditHandler);
        g.cellEditEnded?.removeHandler(cellEditEndedHandler);
        g.pastedCell?.removeHandler(cellEditEndedHandler);
        g.hostElement?.removeEventListener('dblclick', dblclickHandler);
        g.updatedLayout?.removeHandler(applyLeafHeaderHeight);
      } catch {
        /* unmount race */
      }
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [columns, onFromCellDblClick, onToCellDblClick, onRouteIdDblClick]);

  return (
    <DataGrid
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      editTrackerRef={editTrackerRef}
      itemsSource={rows as unknown as WijmoRowItem[]}
      staticColumns={columns}
      gotFocus={onFocus}
    />
  );
};
