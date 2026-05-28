import { type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useRef, useState } from 'react';

import type { HotkeyConfig, PageProps } from '@foundation/models';
import { MainTitle, SubTitle } from '@shared/components';
import { useProcMutation, useSaveWithValidation, useTabProcQuery } from '@shared/hooks';
import { Label } from '@shared/lges';

import { ButtonGrid } from './components/ButtonGrid';
import { GroupGrid } from './components/GroupGrid';
import { MenuGrid } from './components/MenuGrid';
import type { RESPONSE_SET } from './group-menu.constants';
import { MENU_ID, SHEET_INDEX, SHEETS } from './group-menu.constants';
import styles from './GroupMenuManagement.module.scss';
import { useGroupMenuStore } from './useGroupMenuStore';

export const GroupMenu = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();
  const { saveWithValidation } = useSaveWithValidation();
  const gridRefs = [
    useRef<FlexGrid<ResponseData<MENU_ID, SHEETS.GROUP, RESPONSE_SET.OUTPUT>>>(),
    useRef<FlexGrid<ResponseData<MENU_ID, SHEETS.MENU, RESPONSE_SET.OUTPUT>>>(),
    useRef<FlexGrid<ResponseData<MENU_ID, SHEETS.BUTTON, RESPONSE_SET.OUTPUT>>>(),
  ] as const;
  const gridFilterRefs = [
    useRef<FlexGridFilter>(),
    useRef<FlexGridFilter>(),
    useRef<FlexGridFilter>(),
  ];
  const initialized = useGroupMenuStore(state => state.initialized);
  const filters = useGroupMenuStore(state => state.filters);
  const setFilters = useGroupMenuStore(state => state.setFilters);
  const staticColumns = useGroupMenuStore(state => state.staticColumns);
  const fetchStaticColumns = useGroupMenuStore(state => state.fetchStaticColumns);
  const isOpenSearchArea = useGroupMenuStore(state => state.isOpenSearchArea);
  const menuGridCleared = useGroupMenuStore(state => state.menuGridCleared);
  const buttonGridCleared = useGroupMenuStore(state => state.buttonGridCleared);

  const [activeTab, setActiveTab] = useState<SHEET_INDEX>(SHEET_INDEX.GROUP);

  const queries = [
    useTabProcQuery<MENU_ID, SHEETS.GROUP>({
      menuId: MENU_ID,
      sheetName: SHEETS.GROUP,
      tabId,
      filters: filters[SHEETS.GROUP],
      enabled: !!filters[SHEETS.GROUP],
    }),
    useTabProcQuery<MENU_ID, SHEETS.MENU>({
      menuId: MENU_ID,
      sheetName: SHEETS.MENU,
      tabId,
      filters: filters[SHEETS.MENU],
      enabled: !!filters[SHEETS.MENU],
    }),
    useTabProcQuery<MENU_ID, SHEETS.BUTTON>({
      menuId: MENU_ID,
      sheetName: SHEETS.BUTTON,
      tabId,
      filters: filters[SHEETS.BUTTON],
      enabled: !!filters[SHEETS.BUTTON],
    }),
  ] as const;

  const mutates = [
    useProcMutation<MENU_ID>({
      menuId: MENU_ID,
      sheetName: SHEETS.GROUP,
      tabId,
    }).mutate,
    useProcMutation<MENU_ID>({
      menuId: MENU_ID,
      sheetName: SHEETS.MENU,
      tabId,
    }).mutate,
    useProcMutation<MENU_ID>({
      menuId: MENU_ID,
      sheetName: SHEETS.BUTTON,
      tabId,
    }).mutate,
  ] as const;

  const rows = [
    queries[SHEET_INDEX.GROUP].data?.o_rc ?? [],
    queries[SHEET_INDEX.MENU].data?.o_rc ?? [],
    queries[SHEET_INDEX.BUTTON].data?.o_rc ?? [],
  ] as const;

  const onSave = () => {
    const mutate = mutates[activeTab];
    const staticColumn =
      staticColumns[
        activeTab === SHEET_INDEX.GROUP
          ? SHEETS.GROUP
          : activeTab === SHEET_INDEX.BUTTON
            ? SHEETS.BUTTON
            : SHEETS.MENU
      ];
    if (!mutate) return;

    const data = rows[activeTab]?.filter(item => item.CRUD_TYPE) ?? [];
    saveWithValidation(data, staticColumn, mutate);
  };

  const hotkeyConfig: HotkeyConfig = {
    search: () => setFilters(SHEETS.GROUP, filters[SHEETS.GROUP]),
    save: onSave,
    insert: false,
    delete: false,
    manual: false,
    condition: false,
    resetCondition: false,
    upload: false,
  };

  useEffect(() => {
    if (!initialized) {
      fetchStaticColumns();
      setFilters(SHEETS.GROUP, {});
    }
  }, [tabId]);

  return (
    <>
      <MainTitle
        title={title}
        menuId={MENU_ID}
        openSearchArea={isOpenSearchArea}
        disableSearchArea
      />
      <SubTitle
        menuId={MENU_ID}
        grid={gridRefs[activeTab]}
        gridFilter={gridFilterRefs[activeTab]}
        dataCount={0}
        excelFileName='Menu'
        hotkeyConfig={hotkeyConfig}
      />
      <div className={styles.gridWrapper}>
        <div className={styles.mainGridWrapper}>
          <Label className={styles.labelGrid} labelText={t('LBL00357', '_Group Info')} />
          <GroupGrid
            gridRef={gridRefs[SHEET_INDEX.GROUP]}
            gridFilterRef={gridFilterRefs[SHEET_INDEX.GROUP]}
            setActiveTab={setActiveTab}
            data={rows[SHEET_INDEX.GROUP]}
          />
        </div>
        <div className={styles.subGridWrapper}>
          <div className={styles.menuGridWrapper}>
            <Label className={styles.labelGrid} labelText={t('LBL00356', '_Menu Item Info')} />
            <MenuGrid
              gridRef={gridRefs[SHEET_INDEX.MENU]}
              gridFilterRef={gridFilterRefs[SHEET_INDEX.MENU]}
              setActiveTab={setActiveTab}
              data={menuGridCleared ? [] : rows[SHEET_INDEX.MENU]}
            />
          </div>
          <div className={styles.buttonGridWrapper}>
            <Label className={styles.labelGrid} labelText={t('LBL00355', '_Sheet Auth')} />
            <ButtonGrid
              gridRef={gridRefs[SHEET_INDEX.BUTTON]}
              gridFilterRef={gridFilterRefs[SHEET_INDEX.BUTTON]}
              setActiveTab={setActiveTab}
              data={buttonGridCleared ? [] : rows[SHEET_INDEX.BUTTON]}
            />
          </div>
        </div>
      </div>
    </>
  );
};
