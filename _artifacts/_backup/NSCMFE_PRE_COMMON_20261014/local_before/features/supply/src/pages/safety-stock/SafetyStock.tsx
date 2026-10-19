import { type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useMemo, useRef, useState } from 'react';

import type { HotkeyConfig, PageProps } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { GridAction } from '@foundation/utils';
import { MainTitle, SubTitle } from '@shared/components';
import { useProcMutation, useSaveWithValidation, useTabBtnPermissions, useTabProcQuery } from '@shared/hooks';
import { useMessageStore } from '@shared/stores';

import { SafetyStockForm } from './components/SafetyStockForm';
import { SafetyStockGrid } from './components/SafetyStockGrid';
import { MENU_ID, MSG, SHEETS } from './safety-stock.constants';
import { useSafetyStockStore } from './useSafetyStockStore';
import { safetyStockInsertDefaults } from './utils/safetyStockEditLock';
import { findDuplicateSafetyStockRows, validateSafetyStockRow } from './utils/safetyStockSaveValidation';

/**
 * SCP0128 Safety Stock — 단일 그리드 CRUD 마스터(SCP0122/SCP0127 계열 구조).
 *
 * 신규(NEW) 판정 — convert-flow/goal.md ①. domain=SCP(형제 트리 실측 + namespace + SCP0122
 * 선례 3중 근거, 00_checklist.md §0). nscmPath 는 goal.md ①에서 확정한 `features/supply/src/
 * pages/safety-stock/`.
 *
 * 버튼 4건 NO-OP/실동작 판정(design/01_layout.md §2 NO-OP/실동작 판정표) — 순수 NO-OP 0건:
 *   - FindButton/SaveButton/DeleteButton/InsertButton = 전건 실동작 확정(SP 호출·gridSignals 근거).
 *   - EditButton = TO-BE 미이식(asis_to_tobe.md §11 전 화면 공통 결정, SCP0127 과 달리 "확인
 *     필요"가 아니라 명시적 제외) — hotkeyConfig 에 edit 키 자체를 두지 않는다(공용 기본핸들러
 *     미보유라 생략해도 부작용 없음, 01_layout.md §2 NO-OP/실동작 판정표 하단 주의).
 *
 * PKG_SCP0128 는 TO-BE 미배포(all_objects 0건, goal.md ②) — 화면 구현은 진행하되 실제 조회·저장은
 * SP 배포(convert-sp 후속) 전까지 동작하지 않는다.
 *
 * 조회조건 Plan Group/Site/Type/Stage/Valid 5개 중 Site/Type/Stage 3개는 데이터소스 미확정으로
 * 필드 자체를 노출하지 않는다(safety-stock.constants COMBO 주석, __asis-mapping__.md 참조).
 */
export const SafetyStock = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();

  const gridRef = useRef<FlexGrid<ResponseData<MENU_ID, SHEETS.MAIN>>>();
  const gridFilterRef = useRef<FlexGridFilter>();
  const editTrackerRef = useRef<EditTracker<ResponseData<MENU_ID, SHEETS.MAIN>>>();

  const isOpenSearchArea = useSafetyStockStore(state => state.isOpenSearchArea);
  const setOpenSearchArea = useSafetyStockStore(state => state.setOpenSearchArea);
  const filters = useSafetyStockStore(state => state.filters);
  const setFilters = useSafetyStockStore(state => state.setFilters);
  const staticColumns = useSafetyStockStore(state => state.staticColumns);
  const fetchStaticColumns = useSafetyStockStore(state => state.fetchStaticColumns);
  const searchParams = useSafetyStockStore(state => state.searchParams);

  const [itemModalOpen, setItemModalOpen] = useState(false);

  const { hasButton } = useTabBtnPermissions({ menuId: MENU_ID });
  const { saveWithValidation } = useSaveWithValidation();
  const { setToast, setAlert } = useMessageStore.getState();

  const { data } = useTabProcQuery<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
    filters,
    enabled: !!filters,
  });

  const { mutate } = useProcMutation<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
  });

  const rows = useMemo(() => data?.o_rc1 ?? [], [data]);

  const onSearch = () => {
    setFilters();
    void fetchStaticColumns();
  };

  // InsertButton — 실동작(design 01 §2 L5, gridSignals#7~#10). 사전조건 가드는 확인 필요
  //   (buttonGuards 미포착) — 보수적으로 조회 전에도 허용(SCP0122 선례, __asis-mapping__.md 확인필요).
  const onInsert = () => {
    if (!gridRef.current) return;
    GridAction.addRow(gridRef.current, safetyStockInsertDefaults(searchParams.divisionId));
  };

  // buttonGuards#1 — fps==null(선택 행 없음) 시 무동작 return(design/01_layout.md §2 L4).
  const onDelete = () => {
    if (!gridRef.current) return;
    if ((gridRef.current.selection?.row ?? -1) < 0) return;
    GridAction.removeRow(gridRef.current, false);
  };

  const onSave = () => {
    const dirtyRows = (gridRef.current?.collectionView?.sourceCollection ?? []).filter(
      row => row.CRUD_TYPE
    );
    if (dirtyRows.length === 0) {
      setToast({ type: 'error', message: t(MSG.NO_CHANGE, '_수정한 내용이 없습니다.') });
      return;
    }

    // design/03_grid-columns.md §3.2/00_checklist.md §4d 검증 재현 — 중복은 행 조합 대사,
    //   나머지는 행별 가드.
    const duplicate = findDuplicateSafetyStockRows(dirtyRows);
    if (duplicate) {
      void setAlert({ type: 'alert', content: t(duplicate.msgId, duplicate.message) });
      return;
    }
    for (const row of dirtyRows) {
      const violation = validateSafetyStockRow(row);
      if (violation) {
        void setAlert({ type: 'alert', content: t(violation.msgId, violation.message) });
        return;
      }
    }

    saveWithValidation(dirtyRows, staticColumns, mutate, dirtyRows);
  };

  const hotkeyConfig: HotkeyConfig = {
    search: hasButton('SEARCH') ? onSearch : false,
    insert: hasButton('INSERT') ? onInsert : false,
    delete: hasButton('DELETE') ? onDelete : false,
    save: hasButton('SAVE') ? onSave : false,
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
      <SafetyStockForm />
      <SubTitle
        menuId={MENU_ID}
        grid={gridRef}
        gridFilter={gridFilterRef}
        dataCount={rows.length}
        excelFileName='SafetyStock'
        hotkeyConfig={hotkeyConfig}
        searchParam={searchParams}
      />
      <SafetyStockGrid
        gridRef={gridRef}
        gridFilterRef={gridFilterRef}
        editTrackerRef={editTrackerRef}
        data={rows}
        staticColumns={staticColumns}
        divisionId={searchParams.divisionId}
        itemModalOpen={itemModalOpen}
        onItemModalOpenChange={setItemModalOpen}
      />
    </>
  );
};
