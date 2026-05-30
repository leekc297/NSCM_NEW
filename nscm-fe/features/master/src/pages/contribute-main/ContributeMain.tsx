/**
 * DMF0043 Contribute_Main — 메인 페이지
 *
 * AS-IS: Doc/_legacy_source/06_UIL/domain_DM/GSCM.DM.Master.UIL/DMF0043_Contribute_Main.cs
 * 4축 매핑: Doc/_analysis/domain_DM/screens/DMF0043_Contribute_Main/__asis-mapping__.md
 * To-Be 설계: Doc/_analysis/domain_DM/screens/DMF0043_Contribute_Main/tobe_design.md
 *
 * 룰 25 §1 5종 자료 모두 Read 완료 (.cs/.Designer.cs/xlsx/8 MD/캡쳐본)
 */
import { type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useRef } from 'react';

import type { HotkeyConfig, PageProps } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { MainTitle, SubTitle } from '@shared/components';
import { useProcMutation, useSaveWithValidation, useTabProcQuery } from '@shared/hooks';
import { useMessageStore } from '@shared/stores';

import { ContributeMainForm } from './components/ContributeMainForm';
import { ContributeMainGrid } from './components/ContributeMainGrid';
import { ContributeRateModal } from './components/modals/ContributeRateModal';
import { MENU_ID } from './contribute-main.constants';
import type { ContributeMainRow } from './contribute-main.types';
import { useContributeMainExpression } from './hooks/useContributeMainExpression';
import { useContributeMainValidation } from './hooks/useContributeMainValidation';
import { useContributeMainStore } from './useContributeMainStore';

export const ContributeMain = ({ tabId, title }: PageProps<MenuId>) => {
  const { t } = useTranslation();
  const { setAlert } = useMessageStore();
  const { saveWithValidation } = useSaveWithValidation();

  const gridRef = useRef<FlexGrid<ContributeMainRow>>();
  const gridFilterRef = useRef<FlexGridFilter>();
  const editTrackerRef = useRef<EditTracker<ContributeMainRow>>();

  // -------------------------------------------------------------------------
  // Store
  // -------------------------------------------------------------------------
  const filters = useContributeMainStore(state => state.filters);
  const setFilters = useContributeMainStore(state => state.setFilters);
  const isOpenSearchArea = useContributeMainStore(state => state.isOpenSearchArea);
  const setOpenSearchArea = useContributeMainStore(state => state.setOpenSearchArea);
  const isOpenContributeRate = useContributeMainStore(state => state.isOpenContributeRate);
  const setOpenContributeRate = useContributeMainStore(state => state.setOpenContributeRate);
  const searchParams = useContributeMainStore(state => state.searchParams);

  // -------------------------------------------------------------------------
  // Validation / Expression hooks
  // -------------------------------------------------------------------------
  const { validateRatioSum, validateDivisionValueSet, confirmSaveData } =
    useContributeMainValidation();
  const { buildYearSumColumnGroups: _buildYearSumColumnGroups } = useContributeMainExpression();

  // -------------------------------------------------------------------------
  // Data — 메인 SP (long-format, PivotGrid 가 client-side PIVOT)
  // AS-IS: .cs:251 FindData → DMF0043_GET_CONTRIBUTE_MAIN_DATA
  //
  // ⚠ boolean 필드는 BE 로 전송 시 'Y'/'N' string 변환 필수.
  //   Oracle JDBC 가 java.lang.Boolean → PL/SQL BOOLEAN 매핑하여 SP 의 VARCHAR2
  //   파라미터와 type mismatch → PLS-00306. AS-IS .cs:293-294 도 string 전송.
  // -------------------------------------------------------------------------
  const beFilters = filters
    ? {
        yearId: filters.yearId,
        isYearByYear: filters.isYearByYear ? 'Y' : 'N',
        isMismatch: filters.isMismatch ? 'Y' : 'N',
        isHistory: filters.isHistory ? 'Y' : 'N',
      }
    : {};
  const { data, refetch } = useTabProcQuery({
    menuId: MENU_ID as MenuId,
    sheetName: 'main' as never,
    tabId,
    filters: beFilters as never,
    enabled: filters !== undefined,
  });

  const { mutate } = useProcMutation({
    menuId: MENU_ID as MenuId,
    sheetName: 'main' as never,
    tabId,
    onSuccess: () => void refetch(),
  });

  // -------------------------------------------------------------------------
  // Handlers
  // -------------------------------------------------------------------------

  /** F5 조회 — AS-IS .cs:162 FindButton */
  const onSearch = () => {
    if (!searchParams.yearId) {
      void setAlert({ type: 'alert', content: t('MSG00019', '_조회조건을 입력해 주세요.') });
      return;
    }
    setFilters();
    editTrackerRef.current?.clearChanges();
    gridRef.current?.invalidate();
  };

  /** F7 저장 — AS-IS .cs:209 SaveButton → SaveData → DMF0043_SAVE_DM_MST_CONTRIBUTE_RATIO */
  const onSave = () => {
    const rows = (data as { o_rc1?: ContributeMainRow[] } | undefined)?.o_rc1 ?? [];
    const saveData = rows.filter(item => item.CRUD_TYPE);
    if (saveData.length === 0) {
      void setAlert({ type: 'alert', content: t('MSG00018', '_변경된 사항이 없습니다.') });
      return;
    }
    if (!validateRatioSum(saveData)) return;
    if (!validateDivisionValueSet(saveData)) return;
    confirmSaveData(() => {
      saveWithValidation(saveData as never, [], mutate as never);
    });
  };

  const hotkeyConfig: HotkeyConfig = {
    search: onSearch,
    save: onSave,
    manual: false,
  };

  const rows = (data as { o_rc1?: ContributeMainRow[] } | undefined)?.o_rc1 ?? [];

  return (
    <>
      <MainTitle
        title={title}
        menuId={MENU_ID}
        openSearchArea={isOpenSearchArea}
        toggleOpenSearchArea={setOpenSearchArea}
      />

      <ContributeMainForm
        onSearch={onSearch}
        onOpenContributeRate={() => setOpenContributeRate(true)}
      />

      <SubTitle
        menuId={MENU_ID}
        grid={gridRef as never}
        gridFilter={gridFilterRef}
        dataCount={rows.length}
        excelFileName='ContributeMain'
        hotkeyConfig={hotkeyConfig}
        searchParam={searchParams}
      />

      <ContributeMainGrid
        gridRef={gridRef}
        gridFilterRef={gridFilterRef}
        editTrackerRef={editTrackerRef}
        data={rows}
      />

      {/* AS-IS .cs:537 DMF0043_ContributeRatePopup (공유 모달) */}
      <ContributeRateModal
        open={isOpenContributeRate}
        modalClose={() => setOpenContributeRate(false)}
        parentMenuId={MENU_ID}
      />
    </>
  );
};
