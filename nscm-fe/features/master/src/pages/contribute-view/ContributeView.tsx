/**
 * DMF0043_01 Contribute_View — 메인 페이지 (조회 전용)
 *
 * AS-IS: Doc/_legacy_source/06_UIL/domain_DM/GSCM.DM.Master.UIL/DMF0043_Contribute_View.cs
 * 4축 매핑: Doc/_analysis/domain_DM/screens/DMF0043_Contribute_View/__asis-mapping__.md
 * 룰 25 §1 5종 자료 모두 Read 완료
 *
 * 공유 모달: ContributeRateModal (Main 폴더에서 import)
 * 전용 모달: ContributeVersionModal
 */
import { type FlexGrid } from '@mescius/wijmo.grid';
import { useRef } from 'react';

import type { HotkeyConfig, PageProps } from '@foundation/models';
import { MainTitle, SubTitle } from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';

import { ContributeRateModal } from '../contribute-main/components/modals/ContributeRateModal';

import { ContributeViewForm } from './components/ContributeViewForm';
import { ContributeViewGrid } from './components/ContributeViewGrid';
import { ContributeVersionModal } from './components/modals/ContributeVersionModal';
import { MENU_ID } from './contribute-view.constants';
import type { ContributeViewRow } from './contribute-view.types';
import { useContributeViewValidation } from './hooks/useContributeViewValidation';
import { useContributeViewStore } from './useContributeViewStore';

export const ContributeView = ({ tabId, title }: PageProps<MenuId>) => {
  const gridRef = useRef<FlexGrid<ContributeViewRow>>();

  // -------------------------------------------------------------------------
  // Store
  // -------------------------------------------------------------------------
  const filters = useContributeViewStore(state => state.filters);
  const setFilters = useContributeViewStore(state => state.setFilters);
  const isOpenSearchArea = useContributeViewStore(state => state.isOpenSearchArea);
  const setOpenSearchArea = useContributeViewStore(state => state.setOpenSearchArea);
  const searchParams = useContributeViewStore(state => state.searchParams);
  const setSearchParams = useContributeViewStore(state => state.setSearchParams);
  const isOpenContributeRate = useContributeViewStore(state => state.isOpenContributeRate);
  const setOpenContributeRate = useContributeViewStore(state => state.setOpenContributeRate);
  const isOpenContributeVersion = useContributeViewStore(state => state.isOpenContributeVersion);
  const setOpenContributeVersion = useContributeViewStore(state => state.setOpenContributeVersion);
  const isOpenColumnTitleSet = useContributeViewStore(state => state.isOpenColumnTitleSet);
  const setOpenColumnTitleSet = useContributeViewStore(state => state.setOpenColumnTitleSet);

  // -------------------------------------------------------------------------
  // Validation
  // -------------------------------------------------------------------------
  const { validateVersionSelected } = useContributeViewValidation();

  // -------------------------------------------------------------------------
  // Data
  // AS-IS: .cs:308 FindData → DMF0043_GET_CONTRIBUTION_SALES_LIST
  // -------------------------------------------------------------------------
  const { data } = useTabProcQuery({
    menuId: MENU_ID as MenuId,
    sheetName: 'main' as never,
    tabId,
    filters: (filters ?? {}) as never,
    enabled: filters !== undefined,
  });

  /** F5 조회 — AS-IS .cs:287 MSG00283 (Version 필수) */
  const onSearch = () => {
    if (!validateVersionSelected(searchParams.versionId)) return;
    setFilters();
  };

  const hotkeyConfig: HotkeyConfig = {
    search: onSearch,
    manual: false,
  };

  const rows = (data as { o_rc1?: ContributeViewRow[] } | undefined)?.o_rc1 ?? [];

  return (
    <>
      <MainTitle
        title={title}
        menuId={MENU_ID}
        openSearchArea={isOpenSearchArea}
        toggleOpenSearchArea={setOpenSearchArea}
      />

      <ContributeViewForm
        onSearch={onSearch}
        onOpenContributeRate={() => setOpenContributeRate(true)}
        onOpenContributeVersion={() => setOpenContributeVersion(true)}
        onOpenColumnTitleSet={() => setOpenColumnTitleSet(true)}
      />

      <SubTitle
        menuId={MENU_ID}
        grid={gridRef as never}
        dataCount={rows.length}
        excelFileName='ContributeView'
        hotkeyConfig={hotkeyConfig}
        searchParam={searchParams}
      />

      <ContributeViewGrid gridRef={gridRef} data={rows} />

      {/* AS-IS .cs:446 ContributeRatePopup (Main 과 공유) */}
      <ContributeRateModal
        open={isOpenContributeRate}
        modalClose={() => setOpenContributeRate(false)}
        parentMenuId={MENU_ID}
      />

      {/* AS-IS .cs:461 DMF0043_VersionPopup (View 전용) */}
      <ContributeVersionModal
        open={isOpenContributeVersion}
        modalClose={() => setOpenContributeVersion(false)}
        onApply={versionId => setSearchParams({ versionId })}
      />

      {/* TODO AS-IS .cs:475 DM0002_TitleSetForm_Popup (공통 모달 — 별도 구현 필요) */}
      {isOpenColumnTitleSet && (
        <div onClick={() => setOpenColumnTitleSet(false)} />
      )}
    </>
  );
};
