/**
 * DMF0072 NNMasterMapping — 메인 페이지
 *
 * AS-IS: Doc/_legacy_source/06_UIL/domain_DM/GSCM.DM.Forms.UIL/Master/DMF0072_NNMasterMapping/DMF0072_NNMasterMapping.cs (1,577 줄)
 * 4축 매핑: Doc/_analysis/domain_DM/screens/DMF0072_NNMasterMapping/__asis-mapping__.md
 * 룰 25 §1 5종 자료 모두 Read 완료 (.cs/.Designer.cs/xlsx/8 MD/캡쳐본)
 *
 * POPUPs (3 — 공통 모달 재사용 또는 신규):
 *   - SCM0002_ProjectbyDivisionPopupEx
 *   - DM0002_ItembyDivisionPopupEx
 *   - SCM0002_CustomerbyDivisionPopup (DblClick SOLDTO/SHIPTO I 행)
 */
import { type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useRef } from 'react';

import type { HotkeyConfig, PageProps } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { MainTitle, SubTitle } from '@shared/components';
import { useProcMutation, useSaveWithValidation, useTabProcQuery } from '@shared/hooks';

import { NNMasterMappingForm } from './components/NNMasterMappingForm';
import { NNMasterMappingGrid } from './components/NNMasterMappingGrid';
import { useNNMasterMappingExpression } from './hooks/useNNMasterMappingExpression';
import { useNNMasterMappingValidation } from './hooks/useNNMasterMappingValidation';
import { MENU_ID } from './nn-master-mapping.constants';
import type { NNMasterMappingRow } from './nn-master-mapping.types';
import { useNNMasterMappingStore } from './useNNMasterMappingStore';

export const NNMasterMapping = ({ tabId, title }: PageProps<MenuId>) => {
  const gridRef = useRef<FlexGrid<NNMasterMappingRow>>();
  const gridFilterRef = useRef<FlexGridFilter>();
  const editTrackerRef = useRef<EditTracker<NNMasterMappingRow>>();

  const { saveWithValidation } = useSaveWithValidation();

  // -------------------------------------------------------------------------
  // Store
  // -------------------------------------------------------------------------
  const filters = useNNMasterMappingStore(state => state.filters);
  const setFilters = useNNMasterMappingStore(state => state.setFilters);
  const isOpenSearchArea = useNNMasterMappingStore(state => state.isOpenSearchArea);
  const setOpenSearchArea = useNNMasterMappingStore(state => state.setOpenSearchArea);
  const searchParams = useNNMasterMappingStore(state => state.searchParams);
  const setOpenProjectPopup = useNNMasterMappingStore(state => state.setOpenProjectPopup);
  const setOpenModelPopup = useNNMasterMappingStore(state => state.setOpenModelPopup);

  // -------------------------------------------------------------------------
  // Validation / Expression hooks
  // -------------------------------------------------------------------------
  const {
    validateDivisionSelected,
    validateHasChanges,
    validateRequiredFields,
    validateDateFormat,
    validateDateRangeOrder,
    validatePeriodConsistency,
    showSaveSuccess: _showSaveSuccess,
    showSavedError,
  } = useNNMasterMappingValidation();
  const { lockEdiRpaRows, togglePROJECTColumn } = useNNMasterMappingExpression();

  /** AS-IS clbDivision_SelectedIndexChanged — Division=40 시 PROJECT_CODE 컬럼 비활성 */
  useEffect(() => {
    togglePROJECTColumn(gridRef.current, searchParams.divisionId);
  }, [searchParams.divisionId, togglePROJECTColumn]);

  /** AS-IS SetLockRow — DATA_TYPE_CODE != 'SCM' 행 잠금 (data 변경 시 재적용) */
  useEffect(() => {
    if (gridRef.current) lockEdiRpaRows(gridRef.current);
  }, [data, lockEdiRpaRows]);

  // -------------------------------------------------------------------------
  // Data — AS-IS .cs:~477 FindData → DMF0072_GET_NNMASTER_MAPPING
  // -------------------------------------------------------------------------
  const { data, refetch } = useTabProcQuery({
    menuId: MENU_ID as MenuId,
    sheetName: 'main' as never,
    tabId,
    filters: (filters ?? {}) as never,
    enabled: filters !== undefined,
  });

  const { mutate } = useProcMutation({
    menuId: MENU_ID as MenuId,
    sheetName: 'main' as never,
    tabId,
    onSuccess: () => void refetch(),
  });

  // -------------------------------------------------------------------------
  // Handlers — F5/F7/F8/F9
  // -------------------------------------------------------------------------

  /** F5 — AS-IS .cs:~470 FindData */
  const onSearch = () => {
    if (!validateDivisionSelected(searchParams.divisionId)) return;
    setFilters();
    editTrackerRef.current?.clearChanges();
    gridRef.current?.invalidate();
  };

  /** F7 — AS-IS .cs:~610 SaveData → DMF0072_SAVE_NNMASTER_MAPPING */
  const onSave = () => {
    const rows = (data as { o_rc1?: NNMasterMappingRow[] } | undefined)?.o_rc1 ?? [];
    if (!validateHasChanges(rows)) return;
    const dirty = rows.filter(r => r.CRUD_TYPE);
    if (!validateRequiredFields(dirty)) return;
    if (!validateDateFormat(dirty)) return;
    if (!validateDateRangeOrder(dirty)) return;
    if (!validatePeriodConsistency(dirty)) return;

    saveWithValidation(
      dirty as never,
      [],
      mutate as never,
      (resultSet?: { result_msg?: string; result_code?: string }) => {
        // AS-IS MSG00284 처리 — result_code 'F' 또는 catch Exception
        if (resultSet?.result_code === 'F') {
          showSavedError(resultSet.result_msg);
        }
      }
    );
  };

  const hotkeyConfig: HotkeyConfig = {
    search: onSearch,
    save: onSave,
    manual: false,
  };

  const rows = (data as { o_rc1?: NNMasterMappingRow[] } | undefined)?.o_rc1 ?? [];

  return (
    <>
      <MainTitle
        title={title}
        menuId={MENU_ID}
        openSearchArea={isOpenSearchArea}
        toggleOpenSearchArea={setOpenSearchArea}
      />

      <NNMasterMappingForm
        onSearch={onSearch}
        onOpenProjectPopup={() => setOpenProjectPopup(true)}
        onOpenModelPopup={() => setOpenModelPopup(true)}
      />

      <SubTitle
        menuId={MENU_ID}
        grid={gridRef as never}
        gridFilter={gridFilterRef}
        dataCount={rows.length}
        excelFileName='NNMasterMapping'
        hotkeyConfig={hotkeyConfig}
        searchParam={searchParams}
      />

      <NNMasterMappingGrid
        gridRef={gridRef}
        gridFilterRef={gridFilterRef}
        editTrackerRef={editTrackerRef}
        data={rows}
      />

      {/* TODO POPUPs (3) — 공통 모달 재사용 또는 신규 생성 필요
          AS-IS: SCM0002_ProjectbyDivisionPopupEx / DM0002_ItembyDivisionPopupEx / SCM0002_CustomerbyDivisionPopup */}
    </>
  );
};
