import type { CellRangeEventArgs, FlexGrid as FlexGridType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { type MutableRefObject, useEffect, useMemo } from 'react';

import type { FlexGridColumnConfig, RawFlexGridColumnConfig } from '@foundation/models';
import { GridUtils, type EditTracker } from '@foundation/utils';
import { DataGrid } from '@shared/components';

import type { SHEETS } from '../shipment-request-pack.constants';
import { ADMIN_SHEET_NAME } from '../shipment-request-pack.constants';
import type { CellRow, PackRow, SearchParamProps } from '../shipment-request-pack.types';
import {
  dailyKeysOfMonth,
  dailyKeysOfWeek,
  distributeToDaily,
  monthKeyOfDaily,
  sumValues,
  weekKeyOfDaily,
  weekKeysOfMonth,
} from '../utils/shipment-request-pack.autoSync';
import { isDynamicColumnVisible, parseDynamicColumnTag } from '../utils/shipment-request-pack.dynamicColumn';
import { isMainGridCellEditable } from '../utils/shipment-request-pack.editLock';

interface Props<Row extends PackRow | CellRow> {
  sheet: SHEETS.PACK | SHEETS.CELL;
  rows: Row[];
  gridRef: MutableRefObject<FlexGridType<Row> | undefined>;
  gridFilterRef?: MutableRefObject<FlexGridFilter | undefined>;
  editTrackerRef?: MutableRefObject<EditTracker<Row> | undefined>;
  staticColumns: RawFlexGridColumnConfig[];
  bucketType: SearchParamProps['bucketType'];
  isEditMode: boolean;
  onFocus: () => void;
}

/**
 * spdMain(siMain) — Pack Biz / Cell Biz 공용 pivot 그리드(design 03 §1.1/§1.2). 조회 직후
 * 전 컬럼 read-only(design 01 R6), Edit 버튼 클릭 시 기존행은 unlock(R7), 신규행(CRUD_TYPE='I')은
 * Edit 버튼과 무관하게 `INSERT_EDITABLE_COLUMNS_MAIN` 화이트리스트만 unlock 된다(R9,
 * `shipment-request-pack.editLock.isMainGridCellEditable`).
 *
 * Auto-Sync 3방향 배분(D↔W↔M, 03_grid-columns.md R20)은 아래 useEffect(`cellEditEnded`/
 * `pastedCell`)가 처리한다 — production-plan-line(productionPlanLineDerive.ts)의 검증된
 * "균등분배 + 나머지 마지막 셀" 산식을 그대로 확장했다. `DefaultBucketDay`(기본요일 전량배정)
 * 분기는 그 콤보가 DB 실측되지 않아(§6 확인 필요) 구현하지 않는다 — 04_react-gap.md 이월.
 *
 * 미완(04_react-gap.md — 임의 구현 금지, 후속 회차):
 * - Measure=="SHIP_REQ" 행 확정구간(CONFIRM_DAY) 이후만 unlock 하는 행/컬럼 단위 lock 세분화(R7,
 *   신규행 동적 pivot 컬럼 추가 unlock 포함) — CONFIRM_DAY 판정 부재로 기존행은 전체 unlock 으로 남김
 * - Measure 4색 배경 + 확정구간 회색(R18)
 * - Auto-Sync 저장 전 7개 필수값 검증 + 실패 시 입력 롤백(R22)
 * - BOD_ID 자동세팅(Incoterms/TrMode 셀콤보 변경 시 GET_BOD_ITEM 백그라운드 재조회, R10/R14)
 */
export const ShipmentRequestPackMainGrid = <Row extends PackRow | CellRow>({
  sheet,
  rows,
  gridRef,
  gridFilterRef,
  editTrackerRef,
  staticColumns,
  bucketType,
  isEditMode,
  onFocus,
}: Props<Row>) => {
  const handleBeginningEdit = (grid: FlexGridType<Row>, e: CellRangeEventArgs) => {
    const column = grid.columns[e.col];
    const dataItem = GridUtils.getRow(grid, e.row) as (Row & { CRUD_TYPE?: string }) | undefined;
    if (!column?.binding || !dataItem) return;
    const editable = isMainGridCellEditable({
      columnBinding: column.binding,
      crudType: dataItem.CRUD_TYPE,
      isEditMode,
    });
    if (!editable) e.cancel = true;
  };

  // Auto-Sync 3방향 배분(design 03 §2-4/R20) — D 입력 시 소속 W/M 재집계, W/M 입력 시 소속 D 균등분배
  //   (+나머지 마지막 셀), 음수 입력은 하위 D 합계로 원복(production-plan-line 선례 그대로 확장).
  //   화면이 직접 cellEditEnded 에 붙이되, DataGrid 의 EditTracker 등록(initialized 시점) 뒤에
  //   mount 되는 이 useEffect 순서를 그대로 따른다(DataGrid.tsx 주석 규약, production-plan-line 동일).
  useEffect(() => {
    const g = gridRef.current;
    if (!g) return;

    const handler = (sender: FlexGridType<Row>, e: { row: number; col: number }) => {
      const binding = sender.columns[e.col]?.binding ?? '';
      const tag = parseDynamicColumnTag(binding);
      if (!tag) return;
      const row = sender.rows[e.row]?.dataItem as (Row & Record<string, unknown>) | undefined;
      if (!row) return;

      const tracker = editTrackerRef?.current;
      const setCell = (key: string, value: number) => {
        const prev = row[key];
        tracker?.storeChange(row as never, key, prev as never, value as never);
        row[key] = value;
      };
      const rowKeys = Object.keys(row);

      if (tag.bucket === 'D') {
        const weekKey = weekKeyOfDaily(rowKeys, binding);
        if (weekKey) setCell(weekKey, sumValues(dailyKeysOfWeek(rowKeys, weekKey).map(k => row[k])));
        const monthKey = monthKeyOfDaily(rowKeys, binding);
        if (monthKey) setCell(monthKey, sumValues(dailyKeysOfMonth(rowKeys, monthKey).map(k => row[k])));
      } else if (tag.bucket === 'W') {
        const dayKeys = dailyKeysOfWeek(rowKeys, binding);
        const weekVal = Number(String(row[binding]).replace(/,/g, '')) || 0;
        if (weekVal < 0) {
          setCell(binding, sumValues(dayKeys.map(k => row[k])));
        } else if (dayKeys.length > 0) {
          distributeToDaily(weekVal, dayKeys.length).forEach((v, i) => setCell(dayKeys[i], v));
        }
        const monthKey = dayKeys.length > 0 ? monthKeyOfDaily(rowKeys, dayKeys[0]) : undefined;
        if (monthKey) setCell(monthKey, sumValues(dailyKeysOfMonth(rowKeys, monthKey).map(k => row[k])));
      } else if (tag.bucket === 'M') {
        const dayKeys = dailyKeysOfMonth(rowKeys, binding);
        const monthVal = Number(String(row[binding]).replace(/,/g, '')) || 0;
        if (monthVal < 0) {
          setCell(binding, sumValues(dayKeys.map(k => row[k])));
        } else if (dayKeys.length > 0) {
          distributeToDaily(monthVal, dayKeys.length).forEach((v, i) => setCell(dayKeys[i], v));
        }
        weekKeysOfMonth(rowKeys, binding).forEach(weekKey => {
          setCell(weekKey, sumValues(dailyKeysOfWeek(rowKeys, weekKey).map(k => row[k])));
        });
      }
      sender.invalidate();
    };

    g.cellEditEnded.addHandler(handler);
    g.pastedCell.addHandler(handler);
    return () => {
      try {
        g.cellEditEnded?.removeHandler(handler);
        g.pastedCell?.removeHandler(handler);
      } catch {
        /* unmount race */
      }
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  // 동적 pivot 컬럼(design 03 §2) — GET SP 반환 행에서 D_/W_/M_ 태그 키만 뽑아 Bucket 선택에 맞는
  //   세트만 노출한다. 헤더 3단 병합(R17)은 이번 회차 미착수(정적 컬럼 배열 금지 원칙만 우선 준수).
  const dynamicColumns = useMemo<FlexGridColumnConfig[]>(() => {
    const bindings = new Set<string>();
    rows.forEach(row => {
      Object.keys(row as Record<string, unknown>).forEach(key => {
        if (parseDynamicColumnTag(key)) bindings.add(key);
      });
    });
    return [...bindings]
      .filter(binding => isDynamicColumnVisible(binding, bucketType))
      .sort()
      .map(binding => ({
        binding,
        header: binding,
        align: 'right',
        width: 90,
        allowSorting: false,
        visible: true,
      }));
  }, [rows, bucketType]);

  return (
    <DataGrid<Row>
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      editTrackerRef={editTrackerRef}
      itemsSource={rows}
      staticColumns={staticColumns}
      dynamicColumns={dynamicColumns}
      sheetName={ADMIN_SHEET_NAME[sheet]}
      beginningEdit={handleBeginningEdit}
      gotFocus={onFocus}
      emptyCellAsZero={binding => !!parseDynamicColumnTag(binding)}
    />
  );
};
