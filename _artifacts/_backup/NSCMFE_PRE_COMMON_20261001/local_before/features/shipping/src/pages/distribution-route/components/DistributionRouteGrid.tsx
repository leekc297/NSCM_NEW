import { CellType, type FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FormatItemEventArgs } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { type MutableRefObject, useEffect, useMemo, useRef } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import { type EditTracker, safeString } from '@foundation/utils';
import { DataGrid } from '@shared/components';
import { useMessageStore } from '@shared/stores';

import {
  DAYS_AUTO_MODES,
  FROM_CELL_BINDINGS,
  LT_SEGMENT_COLUMNS,
  LT_SUM_MAX,
  MSG,
  NUM_999_COLUMNS,
  NUM_CELL_MAX,
  PRIORITY_MAX,
  ROUTE_COLUMNS,
  TO_CELL_BINDINGS,
} from '../distribution-route.constants';
import type { DistributionRouteRow, InvalidCell } from '../distribution-route.types';
import { lookupCityName } from '../utils/distributionRoute.cityLookup';
import { buildColumns } from '../utils/distributionRoute.columns';
import { clampIntRange, daysAllYes, portsDash, sumLeadTime } from '../utils/distributionRoute.derive';
import { isRouteCellEditable } from '../utils/distributionRoute.editLock';

interface Props {
  rows: DistributionRouteRow[];
  gridRef: MutableRefObject<FlexGridType | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  editTrackerRef: MutableRefObject<EditTracker | undefined>;
  adminColumns?: RawFlexGridColumnConfig[];
  // 저장검증(R17/G4)·저장응답(R14/R15) 위반 셀 — formatItem 영속 하이라이트(gap G3).
  invalidCells: InvalidCell[];
  onFromCellDblClick: (row: DistributionRouteRow, rowIndex: number) => void;
  onToCellDblClick: (row: DistributionRouteRow, rowIndex: number) => void;
  onFocus: () => void;
}

const s = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

// 위반 셀 배경 (design 03 R17). formatItem 이 매 렌더에 재적용해 스크롤/refresh 시 셀 DOM
//   재사용에도 유지된다(gap G3 — DOM 직접 set 비영속 방식 대체).
const INVALID_BG = '#ffd7d7';

export const DistributionRouteGrid = ({
  rows,
  gridRef,
  gridFilterRef,
  editTrackerRef,
  adminColumns,
  invalidCells,
  onFromCellDblClick,
  onToCellDblClick,
  onFocus,
}: Props) => {
  const { t } = useTranslation();
  const setToast = useMessageStore.getState().setToast;

  const columns = useMemo(() => buildColumns(ROUTE_COLUMNS, adminColumns), [adminColumns]);

  // 위반 셀 목록을 ref 로 들고 formatItem 이 읽는다(핸들러 재바인딩 없이 최신값 참조). prop 변경 시
  //   ref 갱신 + invalidate 로 즉시 재색칠(design 03 R16/R17, gap G3).
  const invalidRef = useRef<InvalidCell[]>(invalidCells);
  useEffect(() => {
    invalidRef.current = invalidCells;
    gridRef.current?.invalidate();
  }, [invalidCells, gridRef]);

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

      // R1: 숫자 셀 정수범위 강제 — PRIORITY 0~99, SHIP_DOC·LT 5종 0~999(design 03 R1 SetReNumerCellType).
      //   DB DATA_MAX_LENGTH 공란이라 컬럼메타로는 안 실려 여기서 클램프한다(gap G7). 이미 범위 내 정수면
      //   무변경(불필요 dirty 방지).
      if (binding === 'PRIORITY') {
        const clamped = clampIntRange(row.PRIORITY, 0, PRIORITY_MAX);
        if (safeString(row.PRIORITY) !== clamped) setCell('PRIORITY', clamped);
      } else if ((NUM_999_COLUMNS as readonly string[]).includes(binding)) {
        const clamped = clampIntRange(row[binding], 0, NUM_CELL_MAX);
        if (safeString(row[binding]) !== clamped) setCell(binding, clamped);
      }

      // R13: LT 5종 변경 → LT_SUM 재계산. 합>999 면 방금 바꾼 컬럼 0 리셋 + alert(차단).
      //   (위 R1 클램프로 개별 셀은 이미 0~999 정수. 합계 상한은 별도로 검사한다.)
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

      // G1: FROM/TO CITY 직접 키인 → city_name 파생(AS-IS SetCityCode, design 03 R11/R12·§6#6).
      //   도시팝업 경로(setRegion)는 프로그램 세팅이라 cellEditEnded 를 안 타므로 여기서 겹치지 않는다.
      //   비동기 조회 후 잠금 컬럼 *_CITY_NAME 갱신 — 매칭 없으면 name 을 비워 저장검증에서 차단되게 한다.
      if (binding === 'FROM_CITY' || binding === 'TO_CITY') {
        const prefix = binding === 'FROM_CITY' ? 'FROM' : 'TO';
        const country = safeString(row[`${prefix}_COUNTRY`]);
        const city = safeString(row[binding]);
        void lookupCityName(country, city).then(name => {
          if (name === null) return; // 조회 보류(country/city 미비 or 실패) — 기존 name 유지
          setCell(`${prefix}_CITY_NAME`, name);
          sender.invalidate();
        });
      }

      sender.invalidate();
    };
    g.cellEditEnded.addHandler(cellEditEndedHandler);
    g.pastedCell.addHandler(cellEditEndedHandler);

    // FROM/TO 도시 셀 더블클릭 → 도시팝업 (R11/R12).
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
      }
    };
    g.hostElement.addEventListener('dblclick', dblclickHandler);

    // formatItem: 위반 셀 영속 색칠(R16/R17·R14/R15, gap G3). 매 셀 렌더에 재적용하므로 스크롤/refresh
    //   시 셀 DOM 이 재사용돼도 유지된다. 미해당 셀은 속성을 반드시 '' 로 해제한다(DOM 재사용 대비).
    const formatItemHandler = (sndr: FlexGridType, e: FormatItemEventArgs) => {
      if (e.panel.cellType !== CellType.Cell) return;
      const binding = sndr.columns[e.col]?.binding ?? '';
      const dataItem = sndr.rows[e.row]?.dataItem as Record<string, unknown> | undefined;
      const isInvalid =
        !!dataItem && invalidRef.current.some(c => c.row === dataItem && c.column === binding);
      e.cell.style.backgroundColor = isInvalid ? INVALID_BG : '';
    };
    g.formatItem.addHandler(formatItemHandler);

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
        g.formatItem?.removeHandler(formatItemHandler);
        g.updatedLayout?.removeHandler(applyLeafHeaderHeight);
      } catch {
        /* unmount race */
      }
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [columns, onFromCellDblClick, onToCellDblClick]);

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
