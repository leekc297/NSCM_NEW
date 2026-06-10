import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useRef, useState } from 'react';

import type { HotkeyConfig, PageProps } from '@foundation/models';
import { useQueryClient } from '@foundation/query-client';
import { GridUtils } from '@foundation/utils';
import { MainTitle, SubTitle } from '@shared/components';
import { useProcMutation, useTabProcQuery } from '@shared/hooks';
import { Button, TitleArea } from '@shared/lges';
import { useMessageStore, useSessionStore } from '@shared/stores';

import type { RESPONSE_SET } from './auth-request.constants';
import { ACTIVE_FLAG, APPROVAL_RESULT, MENU_ID, SHEETS } from './auth-request.constants';
import styles from './AuthRequest.module.scss';
import { AuthorityGrid } from './components/AuthorityGrid';
import { DivisionGrid } from './components/DivisionGrid';
import { MyAuthorityListGrid } from './components/MyAuthorityListGrid';
import { UserInfoDetail } from './components/UserInfoDetail';
import { useAuthRequestStore } from './useAuthRequestStore';

const collectCheckedRows = <T,>(grid: FlexGrid<T> | null | undefined): T[] => {
  if (!grid) return [];
  const rows: T[] = [];
  for (let i = 0; i < grid.rows.length; i += 1) {
    const row = grid.rows[i];
    if (row?.isSelected) rows.push(row.dataItem as T);
  }
  return rows;
};

export const AuthRequest = ({ tabId, title }: PageProps<MENU_ID>) => {
  const { t } = useTranslation();

  const authorityGridRef = useRef<FlexGrid<ResponseData<MENU_ID, SHEETS.AUTHORITY>>>();
  const authorityGridFilterRef = useRef<FlexGridFilter>();
  const divisionGridRef = useRef<FlexGrid<ResponseData<MENU_ID, SHEETS.DIVISION>>>();
  const divisionGridFilterRef = useRef<FlexGridFilter>();
  const myAuthGridRef = useRef<FlexGrid<ResponseData<MENU_ID, SHEETS.MY_AUTHORITY_LIST>>>();
  const myAuthGridFilterRef = useRef<FlexGridFilter>();

  const queryClient = useQueryClient();
  const session = useSessionStore(state => state.session);
  const [recentlyAddedKeys, setRecentlyAddedKeys] = useState<Set<string>>(() => new Set());
  const initialized = useAuthRequestStore(state => state.initialized);
  const filters = useAuthRequestStore(state => state.filters);
  const langCd = useAuthRequestStore(state => state.langCd);
  const tmzCd = useAuthRequestStore(state => state.tmzCd);
  const initFilters = useAuthRequestStore(state => state.initFilters);
  const fetchStaticColumns = useAuthRequestStore(state => state.fetchStaticColumns);
  const setAlert = useMessageStore(state => state.setAlert);
  const setToast = useMessageStore(state => state.setToast);

  const { data: myAuthData } = useTabProcQuery<MENU_ID, SHEETS.MY_AUTHORITY_LIST>({
    menuId: MENU_ID,
    sheetName: SHEETS.MY_AUTHORITY_LIST,
    tabId,
    filters: filters[SHEETS.MY_AUTHORITY_LIST],
    enabled: !!filters[SHEETS.MY_AUTHORITY_LIST],
  });

  const { data: userInfoData } = useTabProcQuery<MENU_ID, SHEETS.USER_INFO>({
    menuId: MENU_ID,
    sheetName: SHEETS.USER_INFO,
    tabId,
    filters: filters[SHEETS.USER_INFO],
    enabled: !!filters[SHEETS.USER_INFO],
  });

  const { mutate: mutateMyAuth } = useProcMutation<
    MENU_ID,
    SHEETS.MY_AUTHORITY_LIST,
    RESPONSE_SET.OUTPUT
  >({
    menuId: MENU_ID,
    sheetName: SHEETS.MY_AUTHORITY_LIST,
    tabId,
  });

  const { mutate: mutateUserInfo } = useProcMutation<
    MENU_ID,
    SHEETS.USER_INFO,
    RESPONSE_SET.OUTPUT
  >({
    menuId: MENU_ID,
    sheetName: SHEETS.USER_INFO,
    tabId,
  });

  useEffect(() => {
    if (!session.userId) return;
    if (!initialized) {
      initFilters();
      void fetchStaticColumns();
    }
  }, [session.userId, initialized, initFilters, fetchStaticColumns]);

  const handleAdd = () => {
    const selectedAuthority = GridUtils.getSelectedRows(authorityGridRef.current)?.[0];
    const checkedDivisions = collectCheckedRows(divisionGridRef.current);

    if (!selectedAuthority) {
      void setAlert({
        content: t('LBL00608', 'Please select an Authority row.'),
      });
      return;
    }
    if (checkedDivisions.length === 0) {
      void setAlert({
        content: t('LBL00609', 'Please check at least one Division checkbox.'),
      });
      return;
    }

    const rows: ResponseData<MENU_ID, SHEETS.MY_AUTHORITY_LIST, RESPONSE_SET.OUTPUT>[] =
      checkedDivisions.map(div => ({
        USER_ID: session.userId ?? '',
        USER_GR_ID: selectedAuthority.USER_GR_ID,
        USER_GR_NM: selectedAuthority.USER_GR_NM,
        DIVISION_ID: div.DIVISION_ID,
        DIVISION_NAME: div.DIVISION_NAME,
        CREATION_DATE: '',
        APPROVAL_RESULT: '',
        REJECT_REASON: '',
        LAST_UPDATED_BY: session.userId ?? '',
        LAST_UPDATE_DATE: '',
        CRUD_TYPE: ACTIVE_FLAG.ADD,
      })) as ResponseData<MENU_ID, SHEETS.MY_AUTHORITY_LIST, RESPONSE_SET.OUTPUT>[];

    const addedKeys = new Set(
      checkedDivisions.map(div => `${selectedAuthority.USER_GR_ID}::${div.DIVISION_ID}`)
    );

    mutateMyAuth(rows, {
      onSuccess: () => {
        setRecentlyAddedKeys(addedKeys);
        const divGrid = divisionGridRef.current;
        if (divGrid) {
          for (let i = 0; i < divGrid.rows.length; i += 1) {
            const r = divGrid.rows[i];
            if (r) r.isSelected = false;
          }
        }
        void queryClient.invalidateQueries({ queryKey: [tabId] });
        setToast({ type: 'success', message: t('MSG00002', '_성공적으로 저장되었습니다!') });
      },
    });
  };

  const handleDelete = () => {
    if ((myAuthData?.o_rc?.length ?? 0) === 0) {
      void setAlert({ content: t('MSG00005', '_등록된 요청 권한이 없습니다.') });
      return;
    }

    const checkedRows = collectCheckedRows(myAuthGridRef.current);
    if (checkedRows.length === 0) {
      void setAlert({ content: t('MSG00021', '_요청 권한을 선택해 주십시오.') });
      return;
    }

    const rows = checkedRows.map(row => ({
      ...row,
      USER_ID: session.userId ?? '',
      LAST_UPDATED_BY: session.userId ?? '',
      CRUD_TYPE: ACTIVE_FLAG.DELETE,
    })) as ResponseData<MENU_ID, SHEETS.MY_AUTHORITY_LIST, RESPONSE_SET.OUTPUT>[];

    mutateMyAuth(rows, {
      onSuccess: () => {
        setRecentlyAddedKeys(new Set());
        void queryClient.invalidateQueries({ queryKey: [tabId] });
        setToast({ type: 'success', message: t('MSG00031', '_삭제되었습니다.') });
      },
    });
  };

  const handleRequest = () => {
    if ((myAuthData?.o_rc?.length ?? 0) === 0) {
      void setAlert({ content: t('MSG00005', '_등록된 요청 권한이 없습니다.') });
      return;
    }

    const checkedRows = collectCheckedRows(myAuthGridRef.current);

    // eslint-disable-next-line no-console
    console.log('[SCM0008 handleRequest]', {
      myAuthLen: myAuthData?.o_rc?.length,
      checkedRowsLen: checkedRows.length,
      checkedApprovalResults: checkedRows.map(r => r.APPROVAL_RESULT),
      langCd,
      tmzCd,
      userInfoLangCd: userInfoData?.o_rc?.[0]?.LANG_CD,
      userInfoTmzCd: userInfoData?.o_rc?.[0]?.TMZ_CD,
    });

    if (checkedRows.length === 0) {
      void setAlert({ content: t('MSG00021', '_요청 권한을 선택해 주십시오.') });
      return;
    }

    const currentLangCd = langCd || userInfoData?.o_rc?.[0]?.LANG_CD || '';
    const currentTmzCd = tmzCd || userInfoData?.o_rc?.[0]?.TMZ_CD || '';

    if (!currentLangCd) {
      void setAlert({ content: t('LBL00611', 'Please select Language.') });
      return;
    }
    if (!currentTmzCd) {
      void setAlert({ content: t('LBL00612', 'Please select Time Zone.') });
      return;
    }

    const requestRows = checkedRows
      .filter(row => (row.APPROVAL_RESULT ?? '').trim() !== (APPROVAL_RESULT.REQUESTING as string))
      .map(row => ({
        ...row,
        USER_ID: session.userId ?? '',
        LAST_UPDATED_BY: session.userId ?? '',
        CRUD_TYPE: ACTIVE_FLAG.REQUEST,
      })) as ResponseData<MENU_ID, SHEETS.MY_AUTHORITY_LIST, RESPONSE_SET.OUTPUT>[];

    if (requestRows.length === 0) {
      void setAlert({ content: t('LBL00610', 'Selected rows are already in REQUEST status.') });
      return;
    }

    const userInfoRow = userInfoData?.o_rc?.[0];
    const userInfoUpdate: ResponseData<MENU_ID, SHEETS.USER_INFO, RESPONSE_SET.OUTPUT>[] =
      userInfoRow
        ? [
            {
              ...userInfoRow,
              LANG_CD: currentLangCd,
              TMZ_CD: currentTmzCd,
              CRUD_TYPE: ACTIVE_FLAG.REQUEST,
            },
          ]
        : [];

    mutateMyAuth(requestRows, {
      onSuccess: () => {
        if (userInfoUpdate.length > 0) mutateUserInfo(userInfoUpdate);
        void queryClient.invalidateQueries({ queryKey: [tabId] });
        setToast({ type: 'success', message: t('MSG00158', '_요청되었습니다.') });
      },
    });
  };

  const customButtons = [
    { label: t('LBL00605', 'Request'), action: handleRequest },
  ];

  const handleSearch = () => {
    void queryClient.invalidateQueries({ queryKey: [tabId] });
  };

  const myAuthListButtons = (
    <>
      <Button
        appearance='outlined'
        priority='normal'
        size='small'
        buttonLabel={t('LBL00606', 'Add')}
        onClick={handleAdd}
      />
      <Button
        appearance='outlined'
        priority='normal'
        size='small'
        buttonLabel={t('LBL00607', 'Delete')}
        onClick={handleDelete}
      />
    </>
  );

  const hotkeyConfig: HotkeyConfig = {
    search: handleSearch,
    insert: false,
    delete: false,
    save: false,
    condition: false,
    resetCondition: false,
    manual: false,
    upload: false,
  };

  return (
    <>
      <MainTitle title={title} menuId={MENU_ID} disableSearchArea />
      <SubTitle
        menuId={MENU_ID}
        grid={myAuthGridRef}
        gridFilter={myAuthGridFilterRef}
        dataCount={myAuthData?.o_rc?.length ?? 0}
        excelFileName='Auth Request'
        hotkeyConfig={hotkeyConfig}
        customButtons={customButtons}
      />
      <div className={styles.contents}>
        <div className={styles.row}>
          <div className={styles.module}>
            <TitleArea isSubTitle title={t('LBL00601', 'Authority')} depth='h4' />
            <AuthorityGrid gridRef={authorityGridRef} gridFilterRef={authorityGridFilterRef} />
          </div>
          <div className={styles.module}>
            <TitleArea isSubTitle title={t('LBL00602', 'Division')} depth='h4' />
            <DivisionGrid gridRef={divisionGridRef} gridFilterRef={divisionGridFilterRef} />
          </div>
        </div>
        <div className={styles.row}>
          <div className={styles.userInfoModule}>
            <TitleArea isSubTitle title={t('LBL00603', 'User Info')} depth='h4' />
            <UserInfoDetail />
          </div>
          <div className={styles.module}>
            <TitleArea
              isSubTitle
              title={t('LBL00604', 'My Authority List')}
              depth='h4'
              rightButtons={myAuthListButtons}
            />
            <MyAuthorityListGrid
              gridRef={myAuthGridRef}
              gridFilterRef={myAuthGridFilterRef}
              data={myAuthData?.o_rc ?? []}
              recentlyAddedKeys={recentlyAddedKeys}
            />
          </div>
        </div>
      </div>
    </>
  );
};
