import { type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import type { MutableRefObject } from 'react';

import type { RawFlexGridColumnConfig } from '@foundation/models';
import { DataGrid } from '@shared/components';

import type { MENU_ID, SHEETS } from '../plan-group-dashboard.constants';

type PlanGroupDashboardRow = ResponseData<MENU_ID, SHEETS.MAIN>;

interface PlanGroupDashboardGridProps {
  gridRef: MutableRefObject<FlexGrid<PlanGroupDashboardRow> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  data: PlanGroupDashboardRow[];
  staticColumns: RawFlexGridColumnConfig[];
}

/**
 * 조회 전용 단일 그리드 — AS-IS `LockColumn(0, GetMaxColumnIndex(), true)`(00_checklist.md §3
 * gridSignals#4)로 전 컬럼 잠금. `SCM_MST_SHEET_COLUMNS` 13건 전부 `INPUT_TP_CD='S'`(03_grid-
 * columns.md §1)로 등록되어 있어, staticColumns 를 그대로 반영하면 편집 UI가 자동으로 생기지
 * 않는다 — 별도 read-only 리터럴 오버라이드를 걸지 않는다(CLAUDE.md §2 항목4, admin 메타 그대로).
 * 셀 콤보/Measure/병합 규칙 없음(03_grid-columns.md §1 "셀 콤보 해당 없음"/§2 "Measure 해당
 * 없음", grid-behavior-parity.md 판별 결과 SmartColMerge/LockRange/SetCellTypeCombo 토큰 0건).
 */
export const PlanGroupDashboardGrid = ({
  gridRef,
  gridFilterRef,
  data,
  staticColumns,
}: PlanGroupDashboardGridProps) => (
  <DataGrid<PlanGroupDashboardRow>
    gridRef={gridRef}
    gridFilterRef={gridFilterRef}
    itemsSource={data}
    staticColumns={staticColumns}
  />
);
