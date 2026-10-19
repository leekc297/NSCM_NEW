import { type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useRef, useState } from 'react';

import type { HotkeyConfig, PageProps } from '@foundation/models';
import { GridAction } from '@foundation/utils';
import { MainTitle, SubTitle, TabItem, TabWrapper } from '@shared/components';
import { useTabProcQuery, useSaveWithValidation } from '@shared/hooks';

import { UICategoryColumnGrid } from './components/UICategoryColumnGrid';
import { UICategoryMeasureGrid } from './components/UICategoryMeasureGrid';
import { UICategorySetupForm } from './components/UICategorySetupForm';
import type { RESPONSE_SET } from './ui-category-setup.constants';
import { MENU_ID, SHEET_INDEX, SHEETS } from './ui-category-setup.constants';
import { useUICategorySetupSave } from './useUICategorySetupSave';
import { useUICategorySetupStore } from './useUICategorySetupStore';

export const UICategorySetup = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();

  const gridRef = {
    [SHEET_INDEX.COLUMN]: useRef<FlexGrid>(),
    [SHEET_INDEX.MEASURE]: useRef<FlexGrid>(),
  };
  const gridFilterRef = {
    [SHEET_INDEX.COLUMN]: useRef<FlexGridFilter>(),
    [SHEET_INDEX.MEASURE]: useRef<FlexGridFilter>(),
  };

  const [activeIndex, setActiveIndex] = useState<SHEET_INDEX>(SHEET_INDEX.COLUMN);

  const initialized = useUICategorySetupStore(state => state.initialized);
  const filters = useUICategorySetupStore(state => state.filters);
  const setFilters = useUICategorySetupStore(state => state.setFilters);
  const staticColumns = useUICategorySetupStore(state => state.staticColumns);
  const fetchStaticColumns = useUICategorySetupStore(state => state.fetchStaticColumns);
  const searchParams = useUICategorySetupStore(state => state.searchParams);

  const isOpenSearchArea = useUICategorySetupStore(state => state.isOpenSearchArea);
  const setOpenSearchArea = useUICategorySetupStore(state => state.setOpenSearchArea);

  const { saveWithValidation } = useSaveWithValidation();

  const { data } = useTabProcQuery<MENU_ID>({
    menuId: MENU_ID,
    sheetName: SHEETS.COLUMN,
    tabId,
    filters,
    enabled: !!filters,
  });
  // 저장 실패(HTTP 500)를 성공으로 처리하던 공통 useProcMutation 대신 화면 전용 훅을 쓴다 —
  //   사유 전문은 useUICategorySetupSave 주석 참조(정본 = sales-site-project-model).
  const { mutate: mutateColumn } = useUICategorySetupSave<SHEETS.COLUMN, RESPONSE_SET.COLUMN>({
    sheetName: SHEETS.COLUMN,
    tabId,
  });
  const { mutate: mutateMeasure } = useUICategorySetupSave<SHEETS.MEASURE, RESPONSE_SET.MEASURE>({
    sheetName: SHEETS.MEASURE,
    tabId,
  });

  useEffect(() => {
    if (!initialized) void fetchStaticColumns();
  }, [tabId]);

  // VALID_YN 으로 사용 여부를 관리하는 그리드라 삭제는 신규행 제거 전용으로만 쓴다.
  // removeRow 두 번째 인자 deleteOnlyNew=true 로 기존행에 D flag 를 찍지 않는다
  //   (기존 항목 비활성은 VALID_YN='N' 으로 처리). activeIndex 기준이라 Column/Measure 탭 공통 적용된다.
  const handleDelete = () => {
    if (!gridRef[activeIndex].current) return;
    GridAction.removeRow(gridRef[activeIndex].current, true);
  };

  const handleSave = () => {
    if (activeIndex === SHEET_INDEX.COLUMN) {
      const saveData = (data?.[SHEETS.COLUMN] ?? []).filter(item => item.CRUD_TYPE);
      saveWithValidation(saveData, staticColumns[SHEETS.COLUMN], mutateColumn);
    } else {
      const saveData = (data?.[SHEETS.MEASURE] ?? []).filter(item => item.CRUD_TYPE);
      saveWithValidation(saveData, staticColumns[SHEETS.MEASURE], mutateMeasure);
    }
  };

  const hotkeyConfig: HotkeyConfig = {
    save: handleSave,
    delete: handleDelete,
    search: setFilters,
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
      <UICategorySetupForm />
      <SubTitle
        menuId={MENU_ID}
        grid={gridRef[activeIndex]}
        gridFilter={gridFilterRef[activeIndex]}
        dataCount={data?.[activeIndex ? 'measure' : 'column'].length ?? 0}
        excelFileName='UI-Category'
        hotkeyConfig={hotkeyConfig}
        searchParam={searchParams}
      />
      <TabWrapper
        persist
        activeTabIndex={activeIndex}
        setActiveTabIndex={inx => setActiveIndex(inx)}
      >
        <TabItem label={t('LBL00309', '_Column')}>
          <UICategoryColumnGrid
            gridRef={gridRef[SHEET_INDEX.COLUMN]}
            gridFilterRef={gridFilterRef[SHEET_INDEX.COLUMN]}
            data={data?.column ?? []}
          />
        </TabItem>
        <TabItem label={t('LBL00310', '_Measure')}>
          <UICategoryMeasureGrid
            gridRef={gridRef[SHEET_INDEX.MEASURE]}
            gridFilterRef={gridFilterRef[SHEET_INDEX.MEASURE]}
            data={data?.measure ?? []}
          />
        </TabItem>
      </TabWrapper>
    </>
  );
};
