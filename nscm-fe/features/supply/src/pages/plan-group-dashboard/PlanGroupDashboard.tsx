import { type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef } from 'react';

import type { HotkeyConfig, PageProps } from '@foundation/models';
import { MainTitle, SubTitle } from '@shared/components';
import { useTabBtnPermissions, useTabProcQuery } from '@shared/hooks';
import { useMessageStore } from '@shared/stores';

import { PlanGroupDashboardForm } from './components/PlanGroupDashboardForm';
import { PlanGroupDashboardGrid } from './components/PlanGroupDashboardGrid';
import { MENU_ID, SHEETS } from './plan-group-dashboard.constants';
import { validatePeriodRange } from './plan-group-dashboard.util';
import { usePlanGroupDashboardStore } from './usePlanGroupDashboardStore';

/**
 * SCP0124 Plan Group Dashboard — Search 전용 단일 그리드 대시보드.
 * AS-IS entryPoints/buttonGuards 에 Insert/Delete/Save 신호가 0건이고(00_checklist.md §4d),
 * 그리드 전체가 read-only(gridSignals LockColumn, 03_grid-columns.md §3)라 CRUD 배선이 없다.
 * hotkeyConfig 는 SEARCH 만 실동작 — 나머지 키는 명시적 NO-OP(`false`)으로 남긴다(convert-core
 * §3 self-check 게이트, 01_layout.md §4 #4).
 *
 * PKG_SCP0124 PACKAGE/BODY VALID 배포됨(ora.py 2026-10-13). Plant/Plan Group 조회조건은 공용
 * P_SCP0121_GET_SEARCH_INFO(searchInfo 시트)로 공급 — AS-IS GetSearchInfo() 와 동일.
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
  const fetchStaticColumns = usePlanGroupDashboardStore(state => state.fetchStaticColumns);
  const restoreSearchConditions = usePlanGroupDashboardStore(
    state => state.restoreSearchConditions
  );

  const { t } = useTranslation();
  const setAlert = useMessageStore(state => state.setAlert);

  // 컬럼 메타는 **mount 시** 로드한다 — AS-IS 는 Form_Load 의 CreateSpread 로 진입 즉시 컬럼 헤더가
  //   보이는 빈 그리드를 만든다(cs:113). Search 때만 fetch 하면 조회 전까지 컬럼이 없어 빈 화면이
  //   된다. persist 복원값을 1회 가드로 굳히지 않는다(admin 메타 변경이 재진입으로 반영돼야 함, hook #65).
  useEffect(() => {
    void fetchStaticColumns();
    // SubTitle F6 저장분 복원(1회 가드) — 저장은 되나 복원 배선이 없으면 재진입 시 조건 소실(basic-check #3).
    void restoreSearchConditions();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [tabId]);

  // 조회 트리거 — AS-IS FindData_Main 의 DateUtil.Check_PeriodDate(기간 검증)를 Search 직전에 돌린다.
  //   무효면 메시지만 띄우고 조회하지 않는다. SearchArea Search 버튼(Form)과 SubTitle F5 가 공유한다.
  const handleSearch = () => {
    const err = validatePeriodRange(searchParams.startDate, searchParams.endDate);
    if (err) {
      void setAlert({ type: 'alert', content: t(err.id, err.fallback).replace('{0}', err.arg ?? '') });
      return;
    }
    setFilters();
    void fetchStaticColumns();
  };

  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });

  const { data } = useTabProcQuery<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
    filters,
    enabled: !!filters,
  });

  const rows = useMemo(() => data?.o_rc1 ?? [], [data]);

  // 사용자 지시(2026-10-15): AS-IS 는 조회 전용이고 CRUD 배선이 없어 Insert/Delete/Save 버튼을
  //   **숨긴다**. insert/delete/save 를 false 로 넘기면 SubTitle 이 해당 버튼을 렌더하지 않는다
  //   (SubTitle.tsx `buttonActions.* === false` 분기). 이전(2026-10-13)에는 키를 생략해 기본동작을
  //   노출했으나, 실동작이 없는 버튼이라 숨김으로 되돌린다. useTabProcQuery 는 filters 참조 교체로
  //   재조회한다(refetch 직접 호출 금지, nscm-patterns §5-1).
  const hotkeyConfig: HotkeyConfig = {
    search: hasButton('SEARCH') ? handleSearch : false,
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
      <PlanGroupDashboardForm onSearch={handleSearch} />
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
