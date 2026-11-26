import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useMemo, useRef } from 'react';

import { CRUD_TYPE } from '@foundation/constants';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import { useQueryClient } from '@foundation/query-client';
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
import { useSaveNoticeAttachments } from './useNoticeAttachments';
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
  const attachments = useNoticeSetupStore(state => state.attachments);
  const setAlert = useMessageStore(state => state.setAlert);

  const { t } = useTranslation();

  const { data, refetch } = useTabProcQuery<MENU_ID, SHEETS.MAIN>({
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

  const { mutateAsync: saveAttachments } = useSaveNoticeAttachments();
  const queryClient = useQueryClient();

  // 그리드 데이터 참조를 안정화한다. data?.o_rc1 ?? [] 를 렌더마다 새로 만들면 다이얼로그 입력(타이핑)으로
  // NoticeSetup 이 리렌더될 때마다 NoticeSetupGrid 의 data effect 가 grid.invalidate() 를 호출해 깜빡인다.
  const gridData = useMemo(() => data?.o_rc1 ?? [], [data?.o_rc1]);

  const handleSearch = () => {
    setFilters();
    void fetchStaticColumns();
  };

  const persistAttachments = async (noticeId: string) => {
    if (!noticeId) return;
    try {
      await saveAttachments({ noticeId, fileIds: attachments.map(a => a.fileId) });
      // 같은 공지를 다시 열 때 방금 저장한 첨부가 보이도록 캐시를 무효화한다.
      await queryClient.invalidateQueries({ queryKey: ['notice-attachments', noticeId] });
    } catch {
      void setAlert({ type: 'alert', content: '공지는 저장됐으나 첨부 저장에 실패했습니다.' });
    }
  };

  // 콘텐츠 SAVE 는 생성된 NOTICE_ID 를 돌려주지 않으므로, 신규는 목록을 재조회해
  // 방금 저장한 공지를 비즈니스키(MODULE + NOTICE)로 찾고 최대 NOTICE_ID 로 확정한다.
  const resolveNewNoticeId = async (): Promise<string> => {
    const res = await refetch();
    const rows = res.data?.o_rc1 ?? [];
    const candidates = rows.filter(
      r => r.MODULE === draft.MODULE && r.NOTICE === trimValue(draft.NOTICE)
    );
    if (candidates.length === 0) return '';
    const newest = candidates.reduce((max, r) =>
      Number(r.NOTICE_ID) > Number(max.NOTICE_ID) ? r : max
    );
    return String(newest.NOTICE_ID);
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

    mutate([saveData], {
      onSuccess: async () => {
        const noticeId =
          dialogMode === 'create' ? await resolveNewNoticeId() : String(draft.NOTICE_ID ?? '');
        if (!noticeId) {
          void setAlert({
            type: 'alert',
            content: '공지는 저장됐으나 첨부 연결용 ID를 찾지 못했습니다. 다시 열어 첨부를 확인해 주세요.',
          });
          closeEditor();
          return;
        }
        await persistAttachments(noticeId);
        closeEditor();
      },
    });
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
        {
          onSuccess: async () => {
            if (draft.NOTICE_ID) {
              try {
                await saveAttachments({ noticeId: String(draft.NOTICE_ID), fileIds: [] });
              } catch {
                // 공지는 삭제됨 - 첨부 정리 실패는 무시(orphan 매핑만 남음)
              }
            }
            closeEditor();
          },
        }
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
        dataCount={gridData.length}
        hotkeyConfig={hotkeyConfig}
        searchParam={searchParams}
      />
      <NoticeSetupGrid gridRef={gridRef} gridFilterRef={gridFilterRef} data={gridData} />
      <NoticeSetupDialog onSave={handleSave} onDelete={handleDelete} isSaving={isPending} />
      <NoticePreviewDialog />
    </>
  );
};
