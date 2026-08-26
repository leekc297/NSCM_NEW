import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef } from 'react';

import { apiClient } from '@foundation/apis';
import { CRUD_MSG, CRUD_TYPE } from '@foundation/constants';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import { useQueryClient } from '@foundation/query-client';
import { MainTitle, SubTitle } from '@shared/components';
import { useTabProcQuery } from '@shared/hooks';
import { useMessageStore } from '@shared/stores';

import { MailCategoryGrid } from './components/MailCategoryGrid';
import { MailContentDialog } from './components/MailContentDialog';
import { MailMessageGrid } from './components/MailMessageGrid';
import { MailReceiverPanel } from './components/MailReceiverPanel';
import { MailSetupForm } from './components/MailSetupForm';
import { MailSqlDialog } from './components/MailSqlDialog';
import { MENU_ID, SHEETS, USE_TYPE_CODE } from './mail-setup.constants';
import type { AllReceiverRow, CategoryRow, MessageRow, SelReceiverRow } from './mail-setup.types';
import { joinBulk, pickChangedRows, validateCyclePeriod } from './mail-setup.util';
import styles from './MailSetup.module.scss';
import { useMailSetupStore } from './useMailSetupStore';

const today = () => new Date().toISOString().slice(0, 10).replace(/-/g, '');

export const MailSetup = ({ tabId, title }: PageProps<MENU_ID>) => {
  const categoryGridRef = useRef<FlexGrid<CategoryRow>>();
  const categoryFilterRef = useRef<FlexGridFilter>();
  const messageGridRef = useRef<FlexGrid<MessageRow>>();
  const messageFilterRef = useRef<FlexGridFilter>();
  const allReceiverGridRef = useRef<FlexGrid<AllReceiverRow>>();
  const allReceiverFilterRef = useRef<FlexGridFilter>();
  const selReceiverGridRef = useRef<FlexGrid<SelReceiverRow>>();
  const selReceiverFilterRef = useRef<FlexGridFilter>();

  const filters = useMailSetupStore(state => state.filters);
  const receiverFilters = useMailSetupStore(state => state.receiverFilters);
  const searchParams = useMailSetupStore(state => state.searchParams);
  const setFilters = useMailSetupStore(state => state.setFilters);
  const setReceiverFilters = useMailSetupStore(state => state.setReceiverFilters);
  const receiverSearchParams = useMailSetupStore(state => state.receiverSearchParams);
  const fetchStaticColumns = useMailSetupStore(state => state.fetchStaticColumns);
  const isOpenSearchArea = useMailSetupStore(state => state.isOpenSearchArea);
  const setOpenSearchArea = useMailSetupStore(state => state.setOpenSearchArea);
  const activeTab = useMailSetupStore(state => state.activeTab);
  const setActiveTab = useMailSetupStore(state => state.setActiveTab);
  const selectedCategoryId = useMailSetupStore(state => state.selectedCategoryId);
  const selectedCategoryDesc = useMailSetupStore(state => state.selectedCategoryDesc);
  const selectedModuleCode = useMailSetupStore(state => state.selectedModuleCode);
  const selectedSubModuleCode = useMailSetupStore(state => state.selectedSubModuleCode);
  const selectCategory = useMailSetupStore(state => state.selectCategory);
  const openSqlDialog = useMailSetupStore(state => state.openSqlDialog);
  const closeSqlDialog = useMailSetupStore(state => state.closeSqlDialog);
  const openContentDialog = useMailSetupStore(state => state.openContentDialog);
  const closeContentDialog = useMailSetupStore(state => state.closeContentDialog);
  const contentTargetLanguage = useMailSetupStore(state => state.contentTargetLanguage);
  const setAlert = useMessageStore(state => state.setAlert);
  const setToast = useMessageStore(state => state.setToast);
  const queryClient = useQueryClient();

  const { t } = useTranslation();

  const { data: categoryData, refetch: refetchCategory } = useTabProcQuery<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
    filters,
    enabled: !!filters,
  });

  // useTabProcQuery 는 filters 를 참조 비교(prevKeyRef !== filters)하므로
  // 인라인 객체를 넘기면 매 렌더 새 참조 → 무한 재조회. 반드시 메모이즈한 참조를 전달한다.
  const categoryDetailFilters = useMemo(
    () => ({ useType: USE_TYPE_CODE, categoryId: selectedCategoryId }),
    [selectedCategoryId]
  );

  const { data: messageData, refetch: refetchMessage } = useTabProcQuery<MENU_ID, SHEETS.MESSAGE>({
    menuId: MENU_ID,
    sheetName: SHEETS.MESSAGE,
    tabId,
    filters: categoryDetailFilters,
    enabled: !!selectedCategoryId,
  });

  const { data: allReceiverData } = useTabProcQuery<MENU_ID, SHEETS.ALL_RECEIVER>({
    menuId: MENU_ID,
    sheetName: SHEETS.ALL_RECEIVER,
    tabId,
    filters: receiverFilters,
    enabled: !!receiverFilters,
  });

  const { data: selReceiverData, refetch: refetchSelReceiver } = useTabProcQuery<
    MENU_ID,
    SHEETS.SEL_RECEIVER
  >({
    menuId: MENU_ID,
    sheetName: SHEETS.SEL_RECEIVER,
    tabId,
    filters: categoryDetailFilters,
    enabled: !!selectedCategoryId,
  });

  const categoryRows = categoryData?.o_rc1 ?? [];
  const messageRows = messageData?.o_rc1 ?? [];
  const allReceiverRows = allReceiverData?.o_rc1 ?? [];
  const selReceiverRows = selReceiverData?.o_rc1 ?? [];

  const handleSearch = () => {
    setFilters();
    void fetchStaticColumns();
  };

  const handleSearchReceiver = () => {
    if (!receiverSearchParams.dept.trim() && !receiverSearchParams.user.trim()) {
      void setAlert({
        type: 'alert',
        content: t('MSG00691', '_Enter one of the search criteria {0}.'),
      });
      return;
    }
    setReceiverFilters();
  };

  const afterSave = (refetch?: () => void) => {
    void queryClient.invalidateQueries({ queryKey: [MENU_ID] });
    refetch?.();
    // Alert 대신 Toast 로 통일 (useCustomQueryClient.ts 기본 onSuccess 와 동일 패턴)
    // void setAlert({
    //   type: 'alert',
    //   content: t('MSG00672', '_{0} data saved.').replace('{0}', String(savedCount)),
    // });
    setToast({ type: 'success', message: t(CRUD_MSG.SAVED.id, CRUD_MSG.SAVED.fallback) });
  };

  /** Category 저장 — '^' bulk payload (apiClient.post 직접 호출 의무) */
  const handleSaveCategory = async () => {
    const changed = pickChangedRows(
      categoryGridRef.current?.itemsSource as CategoryRow[] | undefined
    );
    if (!changed.length) return;

    // 검증 대상은 화면에 보이는 행이 아니라 편집 흔적이 남은 모든 행 — 스크롤 밖 행도 포함된다.
    for (const row of changed) {
      if (row.CRUD_TYPE === CRUD_TYPE.DELETE) continue;
      const violation = validateCyclePeriod(row);
      if (violation) {
        void setAlert({
          type: 'alert',
          content: t(violation, '_Required period value is missing.'),
        });
        return;
      }
    }

    if (changed.some(row => row.CRUD_TYPE === CRUD_TYPE.DELETE)) {
      const confirmed = await setAlert({
        type: 'confirm',
        content: t('MSG00694', '_Deleting a category also deletes its messages and recipients.'),
      });
      if (!confirmed) return;
    }

    const createdBy = changed.map(() => '');
    try {
      await apiClient.post(`/${MENU_ID}/${SHEETS.MAIN}/SAVE/call-proc`, {
        activeFlag: joinBulk(changed.map(row => row.CRUD_TYPE)),
        useType: joinBulk(changed.map(() => USE_TYPE_CODE)),
        module: joinBulk(changed.map(row => row.MODULE_CODE)),
        submodule: joinBulk(changed.map(row => row.SUB_MODULE_CODE)),
        categoryId: joinBulk(changed.map(row => row.CATEGORY_ID)),
        categoryDesc: joinBulk(changed.map(row => row.CATEGORY_DESC)),
        cycleClassCode: joinBulk(changed.map(row => row.CYCLE_CLASS_CODE)),
        detailClassCode: joinBulk(changed.map(row => row.DETAIL_CLASS_CODE)),
        sendTimeText: joinBulk(changed.map(row => row.SEND_TIME_TEXT)),
        sendMinTimeText: joinBulk(changed.map(row => row.SEND_MIN_TIME_TEXT)),
        active: joinBulk(changed.map(row => row.ACTIVE_FLAG)),
        createdBy: joinBulk(createdBy),
        creationDate: joinBulk(changed.map(() => today())),
        lastUpdatedBy: joinBulk(createdBy),
      });
      afterSave(refetchCategory);
    } catch {
      void setAlert({ type: 'alert', content: t('MSG00690', '_Failed to save.') });
    }
  };

  /** Message 저장 — '^' bulk payload */
  const handleSaveMessage = async () => {
    const changed = pickChangedRows(
      messageGridRef.current?.itemsSource as MessageRow[] | undefined
    );
    if (!changed.length) return;

    if (changed.some(row => row.CRUD_TYPE !== CRUD_TYPE.DELETE && !row.LANGUAGE_CODE)) {
      void setAlert({ type: 'alert', content: t('MSG00429', '_{0} is a required value.') });
      return;
    }

    try {
      await apiClient.post(`/${MENU_ID}/${SHEETS.MESSAGE}/SAVE/call-proc`, {
        activeFlag: joinBulk(changed.map(row => row.CRUD_TYPE)),
        useType: joinBulk(changed.map(() => USE_TYPE_CODE)),
        categoryId: joinBulk(changed.map(row => row.CATEGORY_ID || selectedCategoryId)),
        language: joinBulk(changed.map(row => row.LANGUAGE_CODE)),
        title: joinBulk(changed.map(row => row.MAIL_TITLE)),
        content: joinBulk(changed.map(row => row.MESSAGE_CONTENT)),
        createdBy: joinBulk(changed.map(() => '')),
        creationDate: joinBulk(changed.map(() => today())),
        lastUpdatedBy: joinBulk(changed.map(() => '')),
      });
      afterSave(refetchMessage);
    } catch {
      void setAlert({ type: 'alert', content: t('MSG00690', '_Failed to save.') });
    }
  };

  /** 수신자 저장 — '^' bulk payload */
  const handleSaveReceiver = async () => {
    const changed = pickChangedRows(
      selReceiverGridRef.current?.itemsSource as SelReceiverRow[] | undefined
    );
    if (!changed.length) return;

    try {
      await apiClient.post(`/${MENU_ID}/${SHEETS.SEL_RECEIVER}/SAVE/call-proc`, {
        activeFlag: joinBulk(changed.map(row => row.CRUD_TYPE)),
        useType: joinBulk(changed.map(() => USE_TYPE_CODE)),
        categoryId: joinBulk(changed.map(row => row.CATEGORY_ID || selectedCategoryId)),
        userId: joinBulk(changed.map(row => row.USERID)),
        createdBy: joinBulk(changed.map(() => '')),
        creationDate: joinBulk(changed.map(() => today())),
        lastUpdatedBy: joinBulk(changed.map(() => '')),
      });
      afterSave(refetchSelReceiver);
    } catch {
      void setAlert({ type: 'alert', content: t('MSG00690', '_Failed to save.') });
    }
  };

  const handleSave = () => {
    void (activeTab === 'message' ? handleSaveMessage() : handleSaveReceiver());
    void handleSaveCategory();
  };

  /** 수신자 추가 — 좌측 선택 행을 우측으로 (중복 차단) */
  const handleAddReceiver = () => {
    if (!selectedCategoryId) return;

    const selected = allReceiverGridRef.current?.selectedItems as AllReceiverRow[] | undefined;
    if (!selected?.length) return;

    const target = selReceiverGridRef.current?.itemsSource as SelReceiverRow[] | undefined;
    if (!target) return;

    const duplicated = selected.find(item =>
      target.some(row => row.USERID === item.USERID && row.CRUD_TYPE !== CRUD_TYPE.DELETE)
    );
    if (duplicated) {
      void setAlert({ type: 'alert', content: t('MSG00060', '_Duplicate key exists.') });
      return;
    }

    selected.forEach(item => {
      target.push({
        USE_TYPE_CODE: USE_TYPE_CODE,
        CATEGORY_ID: selectedCategoryId,
        CATEGORY_DESC: selectedCategoryDesc,
        USERID: item.USERID,
        USERNAME: item.USERNAME,
        DEPT_NAME: item.DEPT_NAME,
        EMAIL: item.EMAIL,
        CELLPHONENUM: item.CELLPHONENUM,
        LANGUAGE: item.LANGUAGE,
        CRUD_TYPE: CRUD_TYPE.INSERT,
      });
    });
    selReceiverGridRef.current?.collectionView?.refresh();
  };

  /** 수신자 제거 — 우측 선택 행 삭제 마킹 */
  const handleRemoveReceiver = () => {
    const selected = selReceiverGridRef.current?.selectedItems as SelReceiverRow[] | undefined;
    if (!selected?.length) return;

    selected.forEach(row => {
      row.CRUD_TYPE = CRUD_TYPE.DELETE;
    });
    selReceiverGridRef.current?.collectionView?.refresh();
  };

  const handleSaveSqlText = async (sqlText: string) => {
    try {
      await apiClient.post(`/${MENU_ID}/${SHEETS.SQL_TEXT}/SAVE/call-proc`, {
        useType: USE_TYPE_CODE,
        module: selectedModuleCode,
        submodule: selectedSubModuleCode,
        categoryId: selectedCategoryId,
        // P_SYS0017_SAVE_RECIPIENT_MASTER_U 의 IN 파라미터명은 P_SQL — 키는 반드시 sql
        sql: sqlText,
        lastUpdatedBy: '',
      });
      closeSqlDialog();
      afterSave();
    } catch {
      void setAlert({ type: 'alert', content: t('MSG00690', '_Failed to save.') });
    }
  };

  const handleApplyContent = (content: string) => {
    const rows = messageGridRef.current?.itemsSource as MessageRow[] | undefined;
    const target = rows?.find(row => row.LANGUAGE_CODE === contentTargetLanguage);
    if (target) {
      target.MESSAGE_CONTENT = content;
      // 다이얼로그 편집은 셀 편집 이벤트를 타지 않아 EditTracker 가 못 잡는다 — 수동으로 M 표시.
      target.CRUD_TYPE = target.CRUD_TYPE ?? CRUD_TYPE.MODIFY;
      messageGridRef.current?.collectionView?.refresh();
    }
    closeContentDialog();
  };

  useEffect(() => {
    void fetchStaticColumns();
  }, [tabId, fetchStaticColumns]);

  // sort/filter/condition/resetCondition/excel 은 미지정 = 기본 활성(DefaultButtonActions) — 공통버튼 표준
  const hotkeyConfig: HotkeyConfig = {
    manual: false,
    search: handleSearch,
    save: handleSave,
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
      <MailSetupForm onSearch={handleSearch} />
      <SubTitle
        menuId={MENU_ID}
        grid={categoryGridRef}
        gridFilter={categoryFilterRef}
        dataCount={categoryRows.length}
        hotkeyConfig={hotkeyConfig}
        searchParam={searchParams}
      />
      <MailCategoryGrid
        gridRef={categoryGridRef}
        gridFilterRef={categoryFilterRef}
        data={categoryRows}
        onOpenSqlDialog={row => {
          selectCategory(row);
          openSqlDialog();
        }}
      />

      <div className={styles.tabBar}>
        <button
          type='button'
          className={activeTab === 'message' ? styles.tabActive : styles.tab}
          onClick={() => setActiveTab('message')}
        >
          {t('LBL00383', '_Message Setup')}
        </button>
        <button
          type='button'
          className={activeTab === 'receiver' ? styles.tabActive : styles.tab}
          onClick={() => setActiveTab('receiver')}
        >
          {t('LBL00774', '_Receiver Setup')}
        </button>
      </div>

      {activeTab === 'message' ? (
        <MailMessageGrid
          gridRef={messageGridRef}
          gridFilterRef={messageFilterRef}
          data={messageRows}
          onOpenContent={row =>
            openContentDialog(row.LANGUAGE_CODE, row.MESSAGE_CONTENT ?? '', false)
          }
        />
      ) : (
        <MailReceiverPanel
          allGridRef={allReceiverGridRef}
          allGridFilterRef={allReceiverFilterRef}
          selGridRef={selReceiverGridRef}
          selGridFilterRef={selReceiverFilterRef}
          allReceivers={allReceiverRows}
          selReceivers={selReceiverRows}
          onSearchReceiver={handleSearchReceiver}
          onAddReceiver={handleAddReceiver}
          onRemoveReceiver={handleRemoveReceiver}
        />
      )}

      <MailContentDialog onApply={handleApplyContent} />
      <MailSqlDialog tabId={tabId} onSave={handleSaveSqlText} />
    </>
  );
};
