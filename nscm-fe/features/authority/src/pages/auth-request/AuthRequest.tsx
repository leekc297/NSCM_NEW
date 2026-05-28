import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useRef } from 'react';

import type { HotkeyConfig, PageProps } from '@foundation/models';
import { GridUtils } from '@foundation/utils';
import { MainTitle, SubTitle } from '@shared/components';
import { useProcMutation, useTabProcQuery } from '@shared/hooks';
import { TitleArea } from '@shared/lges';
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

  const session = useSessionStore(state => state.session);
  const initialized = useAuthRequestStore(state => state.initialized);
  const filters = useAuthRequestStore(state => state.filters);
  const langCd = useAuthRequestStore(state => state.langCd);
  const tmzCd = useAuthRequestStore(state => state.tmzCd);
  const initFilters = useAuthRequestStore(state => state.initFilters);
  const fetchStaticColumns = useAuthRequestStore(state => state.fetchStaticColumns);
  const setAlert = useMessageStore(state => state.setAlert);

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

    if (!selectedAuthority || checkedDivisions.length === 0) {
      void setAlert({
        content: t('MSG00013', '_Please enter the required fields.'),
      });
      return;
    }

    const rows: ResponseData<MENU_ID, SHEETS.MY_AUTHORITY_LIST, RESPONSE_SET.OUTPUT>[] =
      checkedDivisions.map(div => ({
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
      }));

    mutateMyAuth(rows);
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
      LAST_UPDATED_BY: session.userId ?? '',
      CRUD_TYPE: ACTIVE_FLAG.DELETE,
    }));

    mutateMyAuth(rows, {
      onSuccess: () => {
        void setAlert({ content: t('MSG00031', '_삭제되었습니다.') });
      },
    });
  };

  const handleRequest = () => {
    if ((myAuthData?.o_rc?.length ?? 0) === 0) {
      void setAlert({ content: t('MSG00005', '_등록된 요청 권한이 없습니다.') });
      return;
    }

    const checkedRows = collectCheckedRows(myAuthGridRef.current);
    if (checkedRows.length === 0) {
      void setAlert({ content: t('MSG00021', '_요청 권한을 선택해 주십시오.') });
      return;
    }

    const currentLangCd = langCd || userInfoData?.o_rc?.[0]?.LANG_CD || '';
    const currentTmzCd = tmzCd || userInfoData?.o_rc?.[0]?.TMZ_CD || '';

    if (!currentLangCd) {
      void setAlert({ content: t('MSG00002', '_필수 항목을 입력해 주십시오.') });
      return;
    }
    if (!currentTmzCd) {
      void setAlert({ content: t('MSG00002', '_필수 항목을 입력해 주십시오.') });
      return;
    }

    const requestRows = checkedRows
      .filter(row => row.APPROVAL_RESULT.trim() !== (APPROVAL_RESULT.REQUESTING as string))
      .map(row => ({
        ...row,
        LAST_UPDATED_BY: session.userId ?? '',
        CRUD_TYPE: ACTIVE_FLAG.REQUEST,
      }));

    if (requestRows.length === 0) return;

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
        void setAlert({ content: t('MSG00158', '_요청되었습니다.') });
      },
    });
  };

  const customButtons = [
    { label: t('', '_Request'), action: handleRequest },
    { label: t('', '_Add'), action: handleAdd },
    { label: t('', '_Delete'), action: handleDelete },
  ];

  const hotkeyConfig: HotkeyConfig = {
    insert: false,
    delete: false,
    save: false,
    search: false,
    condition: false,
    resetCondition: false,
    excel: false,
    upload: false,
    manual: false,
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
            <TitleArea isSubTitle title={t('', '_Authority')} depth='h4' />
            <AuthorityGrid gridRef={authorityGridRef} gridFilterRef={authorityGridFilterRef} />
          </div>
          <div className={styles.module}>
            <TitleArea isSubTitle title={t('', '_Division')} depth='h4' />
            <DivisionGrid gridRef={divisionGridRef} gridFilterRef={divisionGridFilterRef} />
          </div>
        </div>
        <div className={styles.row}>
          <div className={styles.userInfoModule}>
            <TitleArea isSubTitle title={t('', '_User Info')} depth='h4' />
            <UserInfoDetail />
          </div>
          <div className={styles.module}>
            <TitleArea isSubTitle title={t('', '_My Authority List')} depth='h4' />
            <MyAuthorityListGrid
              gridRef={myAuthGridRef}
              gridFilterRef={myAuthGridFilterRef}
              data={myAuthData?.o_rc ?? []}
            />
          </div>
        </div>
      </div>
    </>
  );
};
