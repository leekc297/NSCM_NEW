import { type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useMemo, useRef } from 'react';

import type { HotkeyConfig, PageProps } from '@foundation/models';
import { MainTitle, SubTitle } from '@shared/components';
import { useTabBtnPermissions, useTabProcQuery } from '@shared/hooks';

import { PlanGroupDashboardForm } from './components/PlanGroupDashboardForm';
import { PlanGroupDashboardGrid } from './components/PlanGroupDashboardGrid';
import { MENU_ID, SHEETS } from './plan-group-dashboard.constants';
import { usePlanGroupDashboardStore } from './usePlanGroupDashboardStore';

/**
 * SCP0124 Plan Group Dashboard — Search 전용 단일 그리드 대시보드.
 * AS-IS entryPoints/buttonGuards 에 Insert/Delete/Save 신호가 0건이고(00_checklist.md §4d),
 * 그리드 전체가 read-only(gridSignals LockColumn, 03_grid-columns.md §3)라 CRUD 배선이 없다.
 * hotkeyConfig 는 SEARCH 만 실동작 — 나머지 키는 명시적 NO-OP(`false`)으로 남긴다(convert-core
 * §3 self-check 게이트, 01_layout.md §4 #4).
 *
 * PKG_SCP0124 는 TO-BE 미배포(all_objects 0건, goal.md ②) — 화면 구현은 진행하되 실제 조회는
 * SP 배포(convert-sp 후속) 전까지 동작하지 않는다.
 */
export const PlanGroupDashboard = ({ tabId, title }: PageProps<MENU_ID>) => {
  const gridRef = useRef<FlexGrid<ResponseData<MENU_ID, SHEETS.MAIN>>>();
  const gridFilterRef = useRef<FlexGridFilter>();

  const isOpenSearchArea = usePlanGroupDashboardStore(state => state.isOpenSearchArea);
  const setOpenSearchArea = usePlanGroupDashboardStore(state => state.setOpenSearchArea);
  const filters = usePlanGroupDashboardStore(state => state.filters);
  const setFilters = usePlanGroupDashboardStore(state => state.setFilters);
  const staticColumns = usePlanGroupDashboardStore(state => state.staticColumns);
  const searchParams = usePlanGroupDashboardStore(state => state.searchParams);

  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });

  const { data } = useTabProcQuery<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
    filters,
    enabled: !!filters,
  });

  const rows = useMemo(() => data?.o_rc1 ?? [], [data]);

  // SEARCH 만 실동작(useTabProcQuery 는 filters 참조 교체로 재조회 — refetch 직접 호출 금지,
  // nscm-patterns.md §5 함정 1). 나머지 버튼은 admin 메타에 등록된 적이 없어(01_layout.md §2.5
  // SCM_ADM_MNU_BTN_MPG_M 0 rows) hasButton() 이 자연히 false 를 반환하지만, 명시적으로도
  // false 를 남겨 self-check NO-OP 게이트(convert-core §3)를 통과시킨다.
  const hotkeyConfig: HotkeyConfig = {
    search: hasButton('SEARCH') ? setFilters : false,
    insert: false,
    delete: false,
    save: false,
    manual: false,
    upload: false,
  };

  return (
    <>
      <MainTitle
        title={title}
        menuId={MENU_ID}
        openSearchArea={isOpenSearchArea}
        toggleOpenSearchArea={setOpenSearchArea}
      />
      <PlanGroupDashboardForm />
      <SubTitle
        menuId={MENU_ID}
        grid={gridRef}
        gridFilter={gridFilterRef}
        dataCount={rows.length}
        excelFileName='PlanGroupDashboard'
        hotkeyConfig={hotkeyConfig}
        searchParam={searchParams}
      />
      <PlanGroupDashboardGrid
        gridRef={gridRef}
        gridFilterRef={gridFilterRef}
        data={rows}
        staticColumns={staticColumns}
      />
    </>
  );
};
