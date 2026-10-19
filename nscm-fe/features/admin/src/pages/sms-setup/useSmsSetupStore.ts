import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab } from '@shared/stores';

import { ALL, MENU_ID, SHEETS, USE_TYPE_CODE } from './sms-setup.constants';
import type { CategoryRow, ReceiverSearchParams, ReceiverTab, SmsSearchParams } from './sms-setup.types';

interface SmsSetupState {
  initialized: boolean;
  filters?: ProcRequest<MENU_ID, SHEETS.MAIN>;
  searchParams: SmsSearchParams;
  receiverSearchParams: ReceiverSearchParams;
  receiverFilters?: ProcRequest<MENU_ID, SHEETS.ALL_RECEIVER>;
  categoryColumns: RawFlexGridColumnConfig[];
  messageColumns: RawFlexGridColumnConfig[];
  allReceiverColumns: RawFlexGridColumnConfig[];
  selReceiverColumns: RawFlexGridColumnConfig[];
  isOpenSearchArea: boolean;
  activeTab: ReceiverTab;
  selectedCategoryId: string;
  selectedCategoryDesc: string;
  selectedModuleCode: string;
  selectedSubModuleCode: string;
  isContentDialogOpen: boolean;
  contentDialogReadOnly: boolean;
  contentDraft: string;
  contentTargetLanguage: string;
}

interface SmsSetupAction {
  reset: () => void;
  setSearchParams: (searchParams: Partial<SmsSearchParams>) => void;
  setReceiverSearchParams: (searchParams: Partial<ReceiverSearchParams>) => void;
  setFilters: () => void;
  setReceiverFilters: () => void;
  fetchStaticColumns: () => Promise<void>;
  setOpenSearchArea: (open?: boolean) => void;
  setActiveTab: (tab: ReceiverTab) => void;
  selectCategory: (row?: CategoryRow) => void;
  openContentDialog: (language: string, content: string, readOnly: boolean) => void;
  closeContentDialog: () => void;
  setContentDraft: (content: string) => void;
}

const initialSearchParams: SmsSearchParams = {
  module: ALL,
  submodule: ALL,
  active: 'Y',
};

const createInitialState = (): SmsSetupState => ({
  initialized: false,
  filters: undefined,
  searchParams: initialSearchParams,
  receiverSearchParams: { group: '', phone: '' },
  receiverFilters: { group: '', phone: '' }, // 빈 group/phone 은 SP 에서 전체 그룹을 반환한다 — Receiver 탭 진입 시(카테고리 선택 전)에도 전체 그룹이 기본으로 보이도록 초기값을 채워둔다(Mail Setup 과 동일 정책).
  categoryColumns: [],
  messageColumns: [],
  allReceiverColumns: [],
  selReceiverColumns: [],
  isOpenSearchArea: true,
  activeTab: 'message',
  selectedCategoryId: '',
  selectedCategoryDesc: '',
  selectedModuleCode: '',
  selectedSubModuleCode: '',
  isContentDialogOpen: false,
  contentDialogReadOnly: false,
  contentDraft: '',
  contentTargetLanguage: '',
});

const fetchColumns = async (sheetName: SHEETS) => {
  const result = await apiClient.post<RawFlexGridColumnConfig[]>(`/admin/menu/${MENU_ID}/column`, {
    sheetNm: sheetName,
  });
  return result.data.result;
};

export const useSmsSetupStore = createPersistedStoreWithTab<SmsSetupState & SmsSetupAction>(
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
          ...(isModuleChanged ? { submodule: ALL } : {}),
        };
      });
    },
    setReceiverSearchParams: searchParams => {
      set(state => {
        state.receiverSearchParams = { ...state.receiverSearchParams, ...searchParams };
      });
    },
    setFilters: () => {
      set(state => {
        state.filters = {
          useType: USE_TYPE_CODE,
          module: state.searchParams.module === ALL ? '' : state.searchParams.module,
          submodule: state.searchParams.submodule === ALL ? '' : state.searchParams.submodule,
          active: state.searchParams.active === ALL ? '' : state.searchParams.active,
        };
        state.selectedCategoryId = '';
        state.selectedCategoryDesc = '';
        state.selectedModuleCode = '';
        state.selectedSubModuleCode = '';
        // Category 선택이 해제되므로 selectCategory 가 채운 검색조건은 되돌리되, All_Receiver 는 빈 값(전체 그룹)으로 다시 채워 기본값(전체 표시)을 유지한다.
        state.receiverFilters = { group: '', phone: '' };
      });
    },
    setReceiverFilters: () => {
      set(state => {
        state.receiverFilters = { ...state.receiverSearchParams };
      });
    },
    fetchStaticColumns: async () => {
      const [category, message, allReceiver, selReceiver] = await Promise.all([
        fetchColumns(SHEETS.MAIN),
        fetchColumns(SHEETS.MESSAGE),
        fetchColumns(SHEETS.ALL_RECEIVER),
        fetchColumns(SHEETS.SEL_RECEIVER),
      ]);

      set(state => {
        state.categoryColumns = category;
        state.messageColumns = message;
        state.allReceiverColumns = allReceiver;
        state.selReceiverColumns = selReceiver;
      });

      if (get().initialized) return;

      const conditions = await apiClient.get<
        { paramNm: keyof SmsSearchParams; paramCtn: string }[]
      >(`/admin/menu/${MENU_ID}/search-conditions`);

      if (conditions.data.result?.length > 0) {
        const restored = conditions.data.result.reduce<SmsSearchParams>(
          (acc, condition) => ({
            ...acc,
            [condition.paramNm]: condition.paramCtn || ALL,
          }),
          { ...initialSearchParams }
        );
        set(state => {
          state.searchParams = restored;
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
    setActiveTab: tab => {
      set(state => {
        state.activeTab = tab;
      });
    },
    selectCategory: row => {
      // 그리드 selectionChanged 는 렌더마다 재발화할 수 있어 동일 선택이면 무시(불필요 리렌더·재조회 차단)
      const nextId = row?.CATEGORY_ID ?? '';
      if (get().selectedCategoryId === nextId) return;

      set(state => {
        state.selectedCategoryId = nextId;
        state.selectedCategoryDesc = row?.CATEGORY_DESC ?? '';
        state.selectedModuleCode = row?.MODULE_CODE ?? '';
        state.selectedSubModuleCode = row?.SUB_MODULE_CODE ?? '';
        // AS-IS SprCategory_CellClick(cs:1056) 는 Category 행 선택 시 현재 검색조건(초기값 빈 값)
        // 그대로 All_Receiver 를 즉시 조회한다 — Receiver Setup 탭의 Search 버튼을 누르기 전에도
        // 왼쪽 그리드가 이미 채워져 보이는 이유. 카테고리 선택이 해제돼도 빈 값(전체 그룹)으로 되돌려 기본값(전체 표시)을 유지한다.
        state.receiverFilters = nextId ? { ...state.receiverSearchParams } : { group: '', phone: '' };
      });
    },
    openContentDialog: (language, content, readOnly) => {
      set(state => {
        state.isContentDialogOpen = true;
        state.contentTargetLanguage = language;
        state.contentDraft = content;
        state.contentDialogReadOnly = readOnly;
      });
    },
    closeContentDialog: () => {
      set(state => {
        state.isContentDialogOpen = false;
        state.contentDraft = '';
        state.contentTargetLanguage = '';
        state.contentDialogReadOnly = false;
      });
    },
    setContentDraft: content => {
      set(state => {
        state.contentDraft = content;
      });
    },
  }),
  'sms-setup'
);
