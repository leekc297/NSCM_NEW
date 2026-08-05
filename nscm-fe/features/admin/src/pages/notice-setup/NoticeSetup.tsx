import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useRef } from 'react';

import { CRUD_TYPE } from '@foundation/constants';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import { MainTitle, SubTitle } from '@shared/components';
import { useProcMutation, useTabProcQuery } from '@shared/hooks';
import { useMessageStore } from '@shared/stores';

import { NoticePreviewDialog } from './components/NoticePreviewDialog';
import { NoticeSetupDialog } from './components/NoticeSetupDialog';
import { NoticeSetupForm } from './components/NoticeSetupForm';
import { NoticeSetupGrid } from './components/NoticeSetupGrid';
import { MENU_ID, type RESPONSE_SET, SHEETS } from './notice-setup.constants';
import type { NoticeSetupRow } from './notice-setup.types';
import { sanitizeNoticeHtml } from './notice-setup.util';
import { useNoticeSetupStore } from './useNoticeSetupStore';

const trimValue = (value?: string | null) => value?.trim() ?? '';

export const NoticeSetup = ({ tabId, title }: PageProps<MENU_ID>) => {
  const gridRef = useRef<FlexGrid<NoticeSetupRow>>();
  const gridFilterRef = useRef<FlexGridFilter>();

  const filters = useNoticeSetupStore(state => state.filters);
  const setFilters = useNoticeSetupStore(state => state.setFilters);
  const fetchStaticColumns = useNoticeSetupStore(state => state.fetchStaticColumns);
  const isOpenSearchArea = useNoticeSetupStore(state => state.isOpenSearchArea);
  const setOpenSearchArea = useNoticeSetupStore(state => state.setOpenSearchArea);
  const searchParams = useNoticeSetupStore(state => state.searchParams);
  const openCreateEditor = useNoticeSetupStore(state => state.openCreateEditor);
  const dialogMode = useNoticeSetupStore(state => state.dialogMode);
  const draft = useNoticeSetupStore(state => state.draft);
  const closeEditor = useNoticeSetupStore(state => state.closeEditor);
  const setAlert = useMessageStore(state => state.setAlert);

  const { t } = useTranslation();

  const { data } = useTabProcQuery<MENU_ID, SHEETS.MAIN>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
    filters,
    enabled: !!filters?.module,
  });

  const { mutate, isPending } = useProcMutation<MENU_ID, SHEETS.MAIN, RESPONSE_SET.OUTPUT>({
    menuId: MENU_ID,
    sheetName: SHEETS.MAIN,
    tabId,
  });

  const handleSearch = () => {
    setFilters();
    void fetchStaticColumns();
  };

  const handleSave = () => {
    const sanitizedContent = sanitizeNoticeHtml(draft.NOTICE_CONTENT);
    const hasRequiredValues =
      trimValue(draft.MODULE) &&
      trimValue(draft.SUB_MODULE) &&
      trimValue(draft.NOTICE) &&
      trimValue(draft.ACTIVE);

    if (!hasRequiredValues) {
      void setAlert({
        type: 'alert',
        content: t('MSG00023', '_Please enter all required values.'),
      });
      return;
    }

    if (draft.START_DATE && draft.END_DATE && draft.START_DATE > draft.END_DATE) {
      void setAlert({
        type: 'alert',
        content: t('MSG00108', '_The end date must be on or after the start date.'),
      });
      return;
    }

    const saveData: NoticeSetupRow = {
      ...draft,
      NOTICE: trimValue(draft.NOTICE),
      NOTICE_TITLE: trimValue(draft.NOTICE_TITLE),
      NOTICE_CONTENT: sanitizedContent,
      NOTICE_IMAGE: trimValue(draft.NOTICE_IMAGE),
      IMAGE_FILE_NM: trimValue(draft.IMAGE_FILE_NM),
      CRUD_TYPE: dialogMode === 'create' ? CRUD_TYPE.INSERT : CRUD_TYPE.MODIFY,
    };

    mutate([saveData], { onSuccess: closeEditor });
  };

  const handleDelete = () => {
    if (dialogMode !== 'edit' || !draft.NOTICE_ID) return;

    void (async () => {
      const confirmed = await setAlert({
        type: 'confirm',
        content: t('MSG00024', '_Are you sure you want to delete this notice?'),
      });
      if (!confirmed) return;

      mutate(
        [
          {
            ...draft,
            CRUD_TYPE: CRUD_TYPE.DELETE,
          },
        ],
        { onSuccess: closeEditor }
      );
    })();
  };

  useEffect(() => {
    void fetchStaticColumns();
  }, [tabId, fetchStaticColumns]);

  const hotkeyConfig: HotkeyConfig = {
    manual: false,
    sort: false,
    filter: false,
    search: handleSearch,
    condition: false,
    save: false,
    insert: openCreateEditor,
    delete: false,
    resetCondition: false,
    excel: false,
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
      <NoticeSetupForm onSearch={handleSearch} />
      <SubTitle
        menuId={MENU_ID}
        grid={gridRef}
        gridFilter={gridFilterRef}
        dataCount={data?.o_rc1.length ?? 0}
        hotkeyConfig={hotkeyConfig}
        searchParam={searchParams}
      />
      <NoticeSetupGrid gridRef={gridRef} gridFilterRef={gridFilterRef} data={data?.o_rc1 ?? []} />
      <NoticeSetupDialog onSave={handleSave} onDelete={handleDelete} isSaving={isPending} />
      <NoticePreviewDialog />
    </>
  );
};
