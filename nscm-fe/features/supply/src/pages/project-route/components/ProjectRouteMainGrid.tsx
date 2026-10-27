import { toggleClass } from '@mescius/wijmo';
import { CellType, type FlexGrid, type FormatItemEventArgs } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { type MutableRefObject, useEffect, useMemo } from 'react';

import type { FlexGridColumnConfig, RawFlexGridColumnConfig } from '@foundation/models';
import { DataGrid } from '@shared/components';

import { SITE_HIDE_ON_82_40, isProjectHiddenDivision } from '../project-route.constants';
import type { SiteKey, SiteRow } from '../project-route.types';

interface Props {
  gridRef: MutableRefObject<FlexGrid<SiteRow> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  data: SiteRow[];
  staticColumns: RawFlexGridColumnConfig[];
  monthColumns: FlexGridColumnConfig[];
  divisionId: string;
  // Main 더블클릭 → site key 확정(design/00 A2). 편집상태 아님(read-only 그리드).
  onRowDblClick: (siteKey: SiteKey) => void;
  // 툴바 Filter(F4) 대상 추적용 — 이 그리드가 포커스를 얻으면 화면이 focusedSheetRef 를 갱신한다.
  gotFocus?: () => void;
}

// Main(siSite) — read-only. 로드후 전열 잠금은 staticColumns 가 read-only 로 배포된 것으로 보고
//   DataGrid 기본(비편집)에 맡긴다. Div 82/40 시 SCM_SITE_NAME/PROJECT_CODE/SALES_MODEL 숨김(R-DYN).
export const ProjectRouteMainGrid = ({
  gridRef,
  gridFilterRef,
  data,
  staticColumns,
  monthColumns,
  divisionId,
  onRowDblClick,
  gotFocus,
}: Props) => {
  // R-DYN(design/03 §3.3) — 82/40 은 3개 컬럼 숨김. 메타가 아니라 코드가 division 으로 처리.
  const columns = useMemo(() => {
    if (!isProjectHiddenDivision(divisionId)) return staticColumns;
    const hidden: readonly string[] = SITE_HIDE_ON_82_40;
    return staticColumns.filter(c => !hidden.includes(c.colNm));
  }, [staticColumns, divisionId]);

  // 수요 없는 Demand Group 모델 행(NO_DEMAND=1) 전체 배경색 — AS-IS E20260713-000141(2026-07-15) 화면 캡처 기준.
  //   82·40 조회 SP(P_SCP0006_GET_PROJECT_ROUTE_SITE_82)가 lookup SCP_OPT_ENG_CONST_DEMAND_GROUP 에서
  //   같은 Project·모델 앞 12자리 그룹인데 수요가 없는 모델을 행으로 추가하며 NO_DEMAND=1 을 붙인다.
  //   셀 DOM 은 스크롤 때 재활용되므로 formatItem 에서 행 값으로 매번 판정한다(TactTimeMainGrid 와 같은 방식).
  useEffect(() => {
    const grid = gridRef.current;
    if (!grid) return;
    const formatItemHandler = (sender: FlexGrid<SiteRow>, e: FormatItemEventArgs) => {
      if (e.panel.cellType !== CellType.Cell) return;
      // 응답 값은 숫자 1 또는 문자 '1' 로 올 수 있어 둘 다 받는다.
      const noDemand = (sender.rows[e.row]?.dataItem as { NO_DEMAND?: number | string } | undefined)
        ?.NO_DEMAND;
      toggleClass(e.cell, 'project-route-no-demand-row', noDemand === 1 || noDemand === '1');
    };
    grid.formatItem.addHandler(formatItemHandler);
    grid.invalidate();
    return () => {
      grid.formatItem.removeHandler(formatItemHandler);
    };
  }, [gridRef, data]);

  const handleDblClick = (mouseEvent: MouseEvent) => {
    const grid = gridRef.current;
    if (!grid) return;
    const ht = grid.hitTest(mouseEvent);
    if (ht.cellType !== CellType.Cell || ht.row < 0) return;
    const row = grid.rows[ht.row]?.dataItem as SiteRow | undefined;
    if (!row) return;
    onRowDblClick({
      divisionId: String(row.DIVISION_ID ?? ''),
      scmSiteId: String(row.SCM_SITE_ID ?? ''),
      itemId: String(row.ITEM_ID ?? ''),
      projectCode: String(row.PROJECT_CODE ?? ''),
    });
  };

  return (
    <DataGrid<SiteRow>
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      itemsSource={data}
      staticColumns={columns}
      dynamicColumns={monthColumns}
      dblClick={handleDblClick}
      gotFocus={gotFocus}
    />
  );
};
