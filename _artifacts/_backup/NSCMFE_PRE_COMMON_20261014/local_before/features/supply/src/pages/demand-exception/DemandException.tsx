import { type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useMemo, useRef, useState } from 'react';

import type { HotkeyConfig, PageProps } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { GridAction } from '@foundation/utils';
import { MainTitle, SubTitle } from '@shared/components';
import { useProcMutation, useSaveWithValidation, useTabBtnPermissions, useTabProcQuery } from '@shared/hooks';
import { useMessageStore } from '@shared/stores';

import { DemandExceptionForm } from './components/DemandExceptionForm';
import { DemandExceptionGrid } from './components/DemandExceptionGrid';
import { MENU_ID, MSG, SHEETS } from './demand-exception.constants';
import { useDemandExceptionStore } from './useDemandExceptionStore';
import { demandExceptionInsertDefaults } from './utils/demandExceptionEditLock';
import {
  findSafetyStockBlockedRows,
  validateDemandExceptionRow,
} from './utils/demandExceptionSaveValidation';

/**
 * SCP0129 Demand Exception — 단일 그리드 CRUD 마스터(SCP0122/SCP0127/SCP0128 계열 구조).
 *
 * 신규(NEW) 판정 — convert-flow/goal.md ①. domain=SCP(형제 트리 실측 + namespace, 00_checklist.md
 * §0). nscmPath 는 goal.md ①에서 확정한 `features/supply/src/pages/demand-exception/`.
 *
 * 버튼 5건 NO-OP/실동작 판정(design/01_layout.md §2) — 순수 NO-OP 0건:
 *   - FindButton/SaveButton = 실 SP 호출 존재로 실동작 확정.
 *   - DeleteButton = buttonGuards#1(`fps==null`) 재현, 무메시지 조용한 return.
 *   - InsertButton = gridSignals#8~#11(결과 로직) 실동작 확정, override 사전조건 가드는 확인
 *     필요(AS-IS 원본 소스 부재) — 보수적으로 조회 전에도 허용(SCP0122/SCP0128 선례).
 *   - EditButton = TO-BE 미이식(asis_to_tobe.md §11 전 화면 공통 결정) — hotkeyConfig 에 edit 키
 *     자체를 두지 않는다(공용 기본핸들러 미보유라 생략해도 부작용 없음).
 *
 * PKG_SCP0129 는 TO-BE 미배포(all_objects 0건, goal.md ②) — 화면 구현은 진행하되 실제 조회·저장은
 * SP 배포(convert-sp 후속) 전까지 동작하지 않는다.
 *
 * 조회조건 Site/PlanGroup/Stage/ValidYn 4개는 데이터소스 확인 필요(AS-IS 원본 소스·AS-IS MSSQL
 * 둘 다 확보 실패) — UI 골격만 노출한다(demand-exception.constants COMBO 주석, __asis-mapping__.md
 * 참조).
 */
export const DemandException = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();

  const gridRef = useRef<FlexGrid<ResponseData<MENU_ID, SHEETS.MAIN>>>();
  const gridFilterRef = useRef<FlexGridFilter>();
  const editTrackerRef = useRef<EditTracker<ResponseData<MENU_ID, SHEETS.MAIN>>>();

  const isOpenSearchArea = useDemandExceptionStore(state => state.isOpenSearchArea);
  const setOpenSearchArea = useDemandExceptionStore(state => state.setOpenSearchArea);
  const filters = useDemandExceptionStore(state => state.filters);
  const setFilters = useDemandExceptionStore(state => state.setFilters);
  const staticColumns = useDemandExceptionStore(state => state.staticColumns);
  const fetchStaticColumns = useDemandExceptionStore(state => state.fetchStaticColumns);
  const searchParams = useDemandExceptionStore(state => state.searchParams);

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

  // InsertButton — 실동작(design 01 §2 규칙#9, gridSignals#8~#11). 사전조건 가드는 확인 필요
  //   (buttonGuards 미포착) — 보수적으로 조회 전에도 허용(SCP0122/SCP0128 선례).
  const onInsert = () => {
    if (!gridRef.current) return;
    GridAction.addRow(gridRef.current, demandExceptionInsertDefaults(searchParams.divisionId));
  };

  // buttonGuards#1 — fps==null(선택 행 없음) 시 무동작 return(design 01 §2 규칙#5).
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

    // design 01 §2 규칙#1(MSG00260, 안전재고 존재 시 저장 차단) — 신규행이 이미 조회된 기존행과
    //   7컬럼 완전일치하면 저장 차단(클라 로컬 비교, PKG_SCP0129 미배포로 서버측 대사는 후속).
    const blocked = findSafetyStockBlockedRows(dirtyRows, rows);
    if (blocked) {
      void setAlert({ type: 'alert', content: t(blocked.msgId, blocked.message) });
      return;
    }
    for (const row of dirtyRows) {
      const violation = validateDemandExceptionRow(row);
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
      <DemandExceptionForm />
      <SubTitle
        menuId={MENU_ID}
        grid={gridRef}
        gridFilter={gridFilterRef}
        dataCount={rows.length}
        excelFileName='DemandException'
        hotkeyConfig={hotkeyConfig}
        searchParam={searchParams}
      />
      <DemandExceptionGrid
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
