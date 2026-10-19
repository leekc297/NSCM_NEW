import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab } from '@shared/stores';

import { MENU_ID, SHEETS } from './notice-setup.constants';
import type { NoticeDialogMode, NoticeSearchParams, NoticeSetupRow } from './notice-setup.types';
import { createEmptyNotice, sanitizeNoticeHtml } from './notice-setup.util';

interface NoticeSetupState {
  initialized: boolean;
  filters?: ProcRequest<MENU_ID, SHEETS.MAIN>;
  searchParams: NoticeSearchParams;
  staticColumns: RawFlexGridColumnConfig[];
  isOpenSearchArea: boolean;
  isEditorOpen: boolean;
  isPreviewOpen: boolean;
  dialogMode: NoticeDialogMode;
  draft: NoticeSetupRow;
  previewNotice?: NoticeSetupRow;
  previewHideToday: boolean;
}

interface NoticeSetupAction {
  reset: () => void;
  setSearchParams: (searchParams: Partial<NoticeSearchParams>) => void;
  setFilters: () => void;
  fetchStaticColumns: () => Promise<void>;
  setOpenSearchArea: (open?: boolean) => void;
  openCreateEditor: () => void;
  openEditEditor: (notice: NoticeSetupRow) => void;
  closeEditor: () => void;
  setDraft: (draft: Partial<NoticeSetupRow>) => void;
  openPreview: (notice: NoticeSetupRow) => void;
  openDraftPreview: () => void;
  closePreview: () => void;
  setPreviewHideToday: (checked: boolean) => void;
}

const initialSearchParams: NoticeSearchParams = {
  module: 'ALL',
  subModule: 'ALL',
  activeYn: 'ALL',
};

const createInitialState = (): NoticeSetupState => ({
  initialized: false,
  filters: undefined,
  searchParams: initialSearchParams,
  staticColumns: [],
  isOpenSearchArea: true,
  isEditorOpen: false,
  isPreviewOpen: false,
  dialogMode: 'create',
  draft: createEmptyNotice(),
  previewNotice: undefined,
  previewHideToday: false,
});

export const useNoticeSetupStore = createPersistedStoreWithTab<
  NoticeSetupState & NoticeSetupAction
>(
  (set, get) => ({
    ...createInitialState(),
    reset: () => set(createInitialState()),
    setSearchParams: searchParams => {
      const currentModule = get().searchParams.module;
      const isModuleChanged =
        searchParams.module !== undefined && searchParams.module !== currentModule;

      set(state => {
        state.searchParams = {
          ...state.searchParams,
          ...searchParams,
          ...(isModuleChanged ? { subModule: 'ALL' } : {}),
        };
      });
    },
    setFilters: () => {
      set(state => {
        state.filters = { ...state.searchParams };
      });
    },
    fetchStaticColumns: async () => {
      const result = await apiClient.post<RawFlexGridColumnConfig[]>(
        `/admin/menu/${MENU_ID}/column`,
        { sheetNm: SHEETS.MAIN }
      );
      set(state => {
        state.staticColumns = result.data.result;
      });

      if (get().initialized) return;

      const conditions = await apiClient.get<
        { paramNm: keyof NoticeSearchParams; paramCtn: string }[]
      >(`/admin/menu/${MENU_ID}/search-conditions`);

      if (conditions.data.result?.length > 0) {
        const restoredSearchParams = conditions.data.result.reduce<NoticeSearchParams>(
          (
            restored: NoticeSearchParams,
            condition: { paramNm: keyof NoticeSearchParams; paramCtn: string }
          ) => ({
            ...restored,
            [condition.paramNm]: condition.paramCtn || 'ALL',
          }),
          { ...initialSearchParams }
        );
        set(state => {
          state.searchParams = restoredSearchParams;
        });
      }

      set(state => {
        state.initialized = true;
      });
    },
    setOpenSearchArea: open => {
      set(state => {
        state.isOpenSearchArea = open ?? !state.isOpenSearchArea;
      });
    },
    openCreateEditor: () => {
      set(state => {
        state.dialogMode = 'create';
        state.draft = createEmptyNotice();
        state.isEditorOpen = true;
      });
    },
    openEditEditor: notice => {
      set(state => {
        state.dialogMode = 'edit';
        state.draft = {
          ...notice,
          NOTICE_CONTENT: sanitizeNoticeHtml(notice.NOTICE_CONTENT),
        };
        state.isEditorOpen = true;
      });
    },
    closeEditor: () => {
      set(state => {
        state.isEditorOpen = false;
        state.draft = createEmptyNotice();
      });
    },
    setDraft: draft => {
      set(state => {
        state.draft = { ...state.draft, ...draft };
      });
    },
    openPreview: notice => {
      set(state => {
        state.previewNotice = {
          ...notice,
          NOTICE_CONTENT: sanitizeNoticeHtml(notice.NOTICE_CONTENT),
        };
        state.previewHideToday = false;
        state.isPreviewOpen = true;
      });
    },
    openDraftPreview: () => {
      const draft = get().draft;
      set(state => {
        state.previewNotice = {
          ...draft,
          NOTICE_CONTENT: sanitizeNoticeHtml(draft.NOTICE_CONTENT),
        };
        state.previewHideToday = false;
        state.isPreviewOpen = true;
      });
    },
    closePreview: () => {
      set(state => {
        state.isPreviewOpen = false;
        state.previewNotice = undefined;
        state.previewHideToday = false;
      });
    },
    setPreviewHideToday: checked => {
      set(state => {
        state.previewHideToday = checked;
      });
    },
  }),
  'notice-setup'
);
