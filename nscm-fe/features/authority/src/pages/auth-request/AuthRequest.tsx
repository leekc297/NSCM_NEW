import { CommunicationSendIcon, ControlAddIcon, EditDeleteIcon } from '@lges/design-system/icon';
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
  for (const element of grid.rows) {
    const row = element;
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

  // 건수는 각 영역 제목 줄에 따로 표시한다 — Authority/Division 조회를 부모로 끌어올려
  // 영역별 totalCases 를 계산한다 (Lookup.tsx 의 master/detail 건수 분리 패턴과 동일).
  const { data: authorityData } = useTabProcQuery<MENU_ID, SHEETS.AUTHORITY>({
    menuId: MENU_ID,
    sheetName: SHEETS.AUTHORITY,
    tabId,
    filters: filters[SHEETS.AUTHORITY],
    enabled: !!filters[SHEETS.AUTHORITY],
  });

  const { data: divisionData } = useTabProcQuery<MENU_ID, SHEETS.DIVISION>({
    menuId: MENU_ID,
    sheetName: SHEETS.DIVISION,
    tabId,
    filters: filters[SHEETS.DIVISION],
    enabled: !!filters[SHEETS.DIVISION],
  });

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

  const handleInsert = () => {
    const selectedAuthority = GridUtils.getSelectedRows(authorityGridRef.current)?.[0];
    const checkedDivisions = collectCheckedRows(divisionGridRef.current);

    if (!selectedAuthority) {
      void setAlert({
        content: t('LBL00730', 'Please select an Authority row.'),
      });
      return;
    }
    if (checkedDivisions.length === 0) {
      void setAlert({
        content: t('LBL00731', 'Please check at least one Division checkbox.'),
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
          for (const element of divGrid.rows) {
            const r = element;
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
      void setAlert({ content: t('MSG00020', '_등록된 요청 권한이 없습니다.') });
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
      void setAlert({ content: t('MSG00020', '_등록된 요청 권한이 없습니다.') });
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
      void setAlert({ content: t('LBL00611', 'Please select Language.') });
      return;
    }
    if (!currentTmzCd) {
      void setAlert({ content: t('LBL00733', 'Please select Time Zone.') });
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
      void setAlert({ content: t('LBL00732', 'Selected rows are already in REQUEST status.') });
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
    {
      label: t('LBL00620', 'Request'),
      action: handleRequest,
      iconComponent: <CommunicationSendIcon appearance='lined' iconSize={20} />,
    },
  ];

  const handleSearch = () => {
    void queryClient.invalidateQueries({ queryKey: [tabId] });
    // ⭐ master hook §2.4 — Search 시 admin SYS0004 메타 refetch
    void fetchStaticColumns();
  };

  // 사용자 요구 2026-06-28: My Authority List 중단 Add/Delete 제거 → 상단 공통버튼 INSERT/DELETE 로 일원화.
  //   SubTitle 공통버튼은 hotkeyConfig 핸들러만으로 표시(메타 비-gating). 기능(handleInsert/handleDelete) 동일.
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

  const authorityCount = authorityData?.o_rc?.length ?? 0;
  const divisionCount = divisionData?.o_rc?.length ?? 0;
  const myAuthCount = myAuthData?.o_rc?.length ?? 0;

  const myAuthListButtons = (
    <>
      <Button
        appearance='outlined'
        priority='normal'
        size='small'
        buttonLabel={t('LBL00621', 'Add')}
        onClick={handleInsert}
        iconComponent={<ControlAddIcon size='default' />}
      />
      <Button
        appearance='outlined'
        priority='normal'
        size='small'
        buttonLabel={t('LBL00622', 'Delete')}
        onClick={handleDelete}
        iconComponent={<EditDeleteIcon appearance='lined' />}
      />
    </>
  );

  return (
    <>
      <MainTitle title={title} menuId={MENU_ID} disableSearchArea />
      <SubTitle
        menuId={MENU_ID}
        grid={myAuthGridRef}
        gridFilter={myAuthGridFilterRef}
        dataCount={myAuthCount}
        // 그리드별 건수를 각 영역 제목 줄에서 표시하므로, 어느 그리드인지 모호한
        // 상단 툴바 줄의 건수 배지는 숨긴다(툴바 동작 대상은 그대로 myAuthGridRef).
        hideTotalCases
        excelFileName='Auth Request'
        hotkeyConfig={hotkeyConfig}
        customButtons={customButtons}
      />
      <div className={styles.contents}>
        <div className={styles.row}>
          <div className={styles.module}>
            <TitleArea
              isSubTitle
              title={t('LBL00640', 'Authority')}
              depth='h4'
              totalCases={authorityCount === 0 ? undefined : authorityCount}
            />
            <AuthorityGrid
              gridRef={authorityGridRef}
              gridFilterRef={authorityGridFilterRef}
              data={authorityData?.o_rc ?? []}
            />
          </div>
          <div className={styles.module}>
            <TitleArea
              isSubTitle
              title={t('LBL00641', 'Division')}
              depth='h4'
              totalCases={divisionCount === 0 ? undefined : divisionCount}
            />
            <DivisionGrid
              gridRef={divisionGridRef}
              gridFilterRef={divisionGridFilterRef}
              data={divisionData?.o_rc ?? []}
            />
          </div>
        </div>
        <div className={styles.row}>
          <div className={styles.userInfoModule}>
            <TitleArea isSubTitle title={t('LBL00658', 'User Info')} depth='h4' />
            <UserInfoDetail />
          </div>
          <div className={styles.module}>
            <TitleArea
              isSubTitle
              title={t('LBL00673', 'My Authority List')}
              depth='h4'
              totalCases={myAuthCount === 0 ? undefined : myAuthCount}
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
