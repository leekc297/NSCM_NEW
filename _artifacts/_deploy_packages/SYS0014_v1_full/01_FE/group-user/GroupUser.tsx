import { type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useRef } from 'react';

import type { HotkeyConfig, PageProps } from '@foundation/models';
import { useQueryClient } from '@foundation/query-client';
import { GridAction } from '@foundation/utils';
import { MainTitle, SubTitle } from '@shared/components';
import { useProcMutation, useTabProcQuery } from '@shared/hooks';
import { Button, TitleArea } from '@shared/lges';
import { useMessageStore } from '@shared/stores';

import { GroupUserForm } from './components/GroupUserForm';
import { GroupUserInfoGrid } from './components/GroupUserInfoGrid';
import { GroupUserMainGrid } from './components/GroupUserMainGrid';
import { GroupUserUnitGrid } from './components/GroupUserUnitGrid';
import { MENU_ID, SHEETS, UNIT_TP_CD } from './group-user.constants';
import styles from './GroupUser.module.scss';
import { useGroupUserStore } from './useGroupUserStore';

const collectRowsWithSheet = <T extends { CRUD_TYPE?: string }>(
  grid: FlexGrid | undefined,
  sheetName: string,
  extra: Record<string, unknown> = {}
): (T & { SHT_NM: string })[] => {
  if (!grid) return [];
  const rows: (T & { SHT_NM: string })[] = [];
  for (let i = 0; i < grid.rows.length; i += 1) {
    const item = grid.rows[i]?.dataItem as T | undefined;
    if (!item?.CRUD_TYPE) continue;
    rows.push({ ...item, ...extra, SHT_NM: sheetName } as T & { SHT_NM: string });
  }
  return rows;
};

export const GroupUser = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();
  const queryClient = useQueryClient();
  const { setAlert, setToast } = useMessageStore();

  const mainGridRef = useRef<FlexGrid>();
  const mainGridFilterRef = useRef<FlexGridFilter>();
  const userGridRef = useRef<FlexGrid>();
  const userGridFilterRef = useRef<FlexGridFilter>();
  const divisionGridRef = useRef<FlexGrid>();
  const divisionGridFilterRef = useRef<FlexGridFilter>();
  const plantGridRef = useRef<FlexGrid>();
  const plantGridFilterRef = useRef<FlexGridFilter>();
  const customerGridRef = useRef<FlexGrid>();
  const customerGridFilterRef = useRef<FlexGridFilter>();

  const filters = useGroupUserStore(state => state.filters);
  const setMainFilter = useGroupUserStore(state => state.setMainFilter);
  const fetchStaticColumns = useGroupUserStore(state => state.fetchStaticColumns);
  const isOpenSearchArea = useGroupUserStore(state => state.isOpenSearchArea);
  const setOpenSearchArea = useGroupUserStore(state => state.setOpenSearchArea);
  const staticColumns = useGroupUserStore(state => state.staticColumns);
  const selectedUserGrId = useGroupUserStore(state => state.selectedUserGrId);
  const selectedUserId = useGroupUserStore(state => state.selectedUserId);

  const { data: mainData } = useTabProcQuery<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID, sheetName: SHEETS.MAIN, tabId,
    filters: filters[SHEETS.MAIN], enabled: !!filters[SHEETS.MAIN],
  });
  const { data: userData } = useTabProcQuery<MENU_ID, SHEETS.USER_INFO>({
    menuId: MENU_ID, sheetName: SHEETS.USER_INFO, tabId,
    filters: filters[SHEETS.USER_INFO], enabled: !!filters[SHEETS.USER_INFO],
  });
  const { data: divisionData } = useTabProcQuery<MENU_ID, SHEETS.DIVISION>({
    menuId: MENU_ID, sheetName: SHEETS.DIVISION, tabId,
    filters: filters[SHEETS.DIVISION], enabled: !!filters[SHEETS.DIVISION],
  });
  const { data: plantData } = useTabProcQuery<MENU_ID, SHEETS.PLANT>({
    menuId: MENU_ID, sheetName: SHEETS.PLANT, tabId,
    filters: filters[SHEETS.PLANT], enabled: !!filters[SHEETS.PLANT],
  });
  const { data: customerData } = useTabProcQuery<MENU_ID, SHEETS.CUSTOMER>({
    menuId: MENU_ID, sheetName: SHEETS.CUSTOMER, tabId,
    filters: filters[SHEETS.CUSTOMER], enabled: !!filters[SHEETS.CUSTOMER],
  });

  const { mutate: mutateSave } = useProcMutation<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID, sheetName: SHEETS.MAIN, tabId,
  });

  useEffect(() => {
    void fetchStaticColumns();
    if (!filters[SHEETS.MAIN]) setMainFilter();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  // — CRUD handlers per-grid —
  const onInsertGroup = () => {
    if (!mainGridRef.current) return;
    GridAction.addRow(mainGridRef.current, { USE_YN: 'Y' });
  };
  const onDeleteGroup = () => {
    if (!mainGridRef.current) return;
    GridAction.removeRow(mainGridRef.current, true);
  };
  const onInsertUser = () => {
    if (!selectedUserGrId) {
      void setAlert({ type: 'alert', content: '먼저 Group 을 선택해 주십시오.' });
      return;
    }
    if (!userGridRef.current) return;
    GridAction.addRow(userGridRef.current, { USER_GR_ID: selectedUserGrId, USE_YN: 'Y' });
  };
  const onDeleteUser = () => {
    if (!userGridRef.current) return;
    GridAction.removeRow(userGridRef.current, true);
  };
  const insertUnit = (gridRef: { current: FlexGrid | undefined }, unitTpCd: string) => {
    if (!selectedUserGrId || !selectedUserId) {
      void setAlert({ type: 'alert', content: '먼저 Group 과 User 를 선택해 주십시오.' });
      return;
    }
    if (!gridRef.current) return;
    GridAction.addRow(gridRef.current, {
      USER_GR_ID: selectedUserGrId,
      USER_ID: selectedUserId,
      UNIT_TP_CD: unitTpCd,
      UPPR_UNIT_ID: '-',
      EDIT_YN: 'Y',
      USE_YN: 'Y',
    });
  };
  const deleteUnit = (gridRef: { current: FlexGrid | undefined }) => {
    if (!gridRef.current) return;
    GridAction.removeRow(gridRef.current, true);
  };

  // — SAVE (4 sheet 통합 — main/userInfo/division/plant/customer 의 모든 CRUD row) —
  const onSave = () => {
    const mainRows = collectRowsWithSheet(mainGridRef.current, SHEETS.MAIN);
    const userRows = collectRowsWithSheet(userGridRef.current, SHEETS.USER_INFO, {
      USER_GR_ID: selectedUserGrId,
    });
    const divRows = collectRowsWithSheet(divisionGridRef.current, SHEETS.DIVISION, {
      USER_GR_ID: selectedUserGrId, USER_ID: selectedUserId, UNIT_TP_CD: UNIT_TP_CD.DIVISION,
    });
    const plantRows = collectRowsWithSheet(plantGridRef.current, SHEETS.PLANT, {
      USER_GR_ID: selectedUserGrId, USER_ID: selectedUserId, UNIT_TP_CD: UNIT_TP_CD.PLANT,
    });
    const custRows = collectRowsWithSheet(customerGridRef.current, SHEETS.CUSTOMER, {
      USER_GR_ID: selectedUserGrId, USER_ID: selectedUserId, UNIT_TP_CD: UNIT_TP_CD.CUSTOMER,
    });
    const payload = [...mainRows, ...userRows, ...divRows, ...plantRows, ...custRows];
    if (payload.length === 0) {
      void setAlert({ type: 'alert', content: '변경 사항이 없습니다.' });
      return;
    }
    mutateSave(payload as never[], {
      onSuccess: () => {
        void queryClient.invalidateQueries({ queryKey: [tabId] });
        setToast({ type: 'success', message: '저장 완료' });
      },
    });
  };

  // ⭐ master hook §2.4 — Search 시 admin SYS0004 메타 refetch
  const handleSearch = () => {
    setMainFilter();
    void fetchStaticColumns();
  };
  const hotkeyConfig: HotkeyConfig = {
    search: handleSearch,
    save: onSave,
    insert: onInsertGroup,
    delete: onDeleteGroup,
    manual: false,
    upload: false,
  };

  const renderTitleBtns = (insert: () => void, del: () => void) => (
    <>
      <Button appearance='outlined' priority='normal' size='small' buttonLabel='Add'    onClick={insert} />
      <Button appearance='outlined' priority='normal' size='small' buttonLabel='Delete' onClick={del} />
    </>
  );

  return (
    <>
      <MainTitle
        title={title}
        menuId={MENU_ID}
        openSearchArea={isOpenSearchArea}
        toggleOpenSearchArea={setOpenSearchArea}
      />
      <GroupUserForm />
      <SubTitle
        menuId={MENU_ID}
        grid={mainGridRef}
        gridFilter={mainGridFilterRef}
        dataCount={(mainData as { o_rc1?: unknown[] })?.o_rc1?.length ?? 0}
        excelFileName='GroupUser'
        hotkeyConfig={hotkeyConfig}
      />
      <div className={styles.contents}>
        <div className={styles.row}>
          <div className={styles.module}>
            <TitleArea isSubTitle title={t('LBL00601', 'Authority')} depth='h4' />
            <GroupUserMainGrid
              gridRef={mainGridRef}
              gridFilterRef={mainGridFilterRef}
              data={(mainData as { o_rc1?: unknown[] })?.o_rc1 as never[] ?? []}
            />
          </div>
          <div className={styles.module}>
            <TitleArea
              isSubTitle
              title='Group User'
              depth='h4'
              rightButtons={renderTitleBtns(onInsertUser, onDeleteUser)}
            />
            <GroupUserInfoGrid
              gridRef={userGridRef}
              gridFilterRef={userGridFilterRef}
              data={(userData as { o_rc1?: unknown[] })?.o_rc1 as never[] ?? []}
            />
          </div>
        </div>
        <div className={styles.row}>
          <div className={styles.module}>
            <TitleArea
              isSubTitle
              title={t('LBL00602', 'Division')}
              depth='h4'
              rightButtons={renderTitleBtns(
                () => insertUnit(divisionGridRef, UNIT_TP_CD.DIVISION),
                () => deleteUnit(divisionGridRef)
              )}
            />
            <GroupUserUnitGrid
              gridRef={divisionGridRef}
              gridFilterRef={divisionGridFilterRef}
              data={(divisionData as { o_rc1?: unknown[] })?.o_rc1 as never[] ?? []}
              staticColumns={staticColumns[SHEETS.DIVISION]}
            />
          </div>
          <div className={styles.module}>
            <TitleArea
              isSubTitle
              title={t('LBL00030', 'Plant')}
              depth='h4'
              rightButtons={renderTitleBtns(
                () => insertUnit(plantGridRef, UNIT_TP_CD.PLANT),
                () => deleteUnit(plantGridRef)
              )}
            />
            <GroupUserUnitGrid
              gridRef={plantGridRef}
              gridFilterRef={plantGridFilterRef}
              data={(plantData as { o_rc1?: unknown[] })?.o_rc1 as never[] ?? []}
              staticColumns={staticColumns[SHEETS.PLANT]}
            />
          </div>
          <div className={styles.module}>
            <TitleArea
              isSubTitle
              title='Customer'
              depth='h4'
              rightButtons={renderTitleBtns(
                () => insertUnit(customerGridRef, UNIT_TP_CD.CUSTOMER),
                () => deleteUnit(customerGridRef)
              )}
            />
            <GroupUserUnitGrid
              gridRef={customerGridRef}
              gridFilterRef={customerGridFilterRef}
              data={(customerData as { o_rc1?: unknown[] })?.o_rc1 as never[] ?? []}
              staticColumns={staticColumns[SHEETS.CUSTOMER]}
            />
          </div>
        </div>
      </div>
    </>
  );
};
