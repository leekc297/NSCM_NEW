import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab } from '@shared/stores';

import { ALL, MENU_ID, SHEETS, USE_TYPE_CODE } from './mail-setup.constants';
import type {
  AllReceiverRow,
  CategoryRow,
  MailSearchParams,
  ReceiverSearchParams,
  ReceiverTab,
} from './mail-setup.types';

/** F5(조회) 분기 대상 포커스 영역 — AS-IS FindButton(E01)·Tx_Click(E13) 대응 */
export type FocusedArea = 'category' | 'receiver';

interface MailSetupState {
  initialized: boolean;
  filters?: ProcRequest<MENU_ID, SHEETS.MAIN>;
  searchParams: MailSearchParams;
  receiverSearchParams: ReceiverSearchParams;
  receiverFilters?: ProcRequest<MENU_ID, SHEETS.ALL_RECEIVER>;
  categoryColumns: RawFlexGridColumnConfig[];
  messageColumns: RawFlexGridColumnConfig[];
  allReceiverColumns: RawFlexGridColumnConfig[];
  selReceiverColumns: RawFlexGridColumnConfig[];
  isOpenSearchArea: boolean;
  activeTab: ReceiverTab;
  /** F5 분기 — Receiver 탭 검색조건/All Receiver 포커스 시 'receiver' (E01/E13) */
  focusedArea: FocusedArea;
  /** ▶ 이동으로 좌측(All Receiver)에서 제거된 행 백업 — AS-IS dtAllReceiver (E14-4/E15) */
  movedReceivers: AllReceiverRow[];
  selectedCategoryId: string;
  selectedCategoryDesc: string;
  selectedModuleCode: string;
  selectedSubModuleCode: string;
  isSqlDialogOpen: boolean;
  isContentDialogOpen: boolean;
  contentDialogReadOnly: boolean;
  contentDraft: string;
  contentTargetLanguage: string;
}

interface MailSetupAction {
  reset: () => void;
  setSearchParams: (searchParams: Partial<MailSearchParams>) => void;
  setReceiverSearchParams: (searchParams: Partial<ReceiverSearchParams>) => void;
  setFilters: () => void;
  setReceiverFilters: () => void;
  fetchStaticColumns: () => Promise<void>;
  setOpenSearchArea: (open?: boolean) => void;
  setActiveTab: (tab: ReceiverTab) => void;
  setFocusedArea: (area: FocusedArea) => void;
  /** ▶ 이동 성공분 백업 push — 좌측 표시는 backup 제외 파생 목록이 담당 */
  pushMovedReceivers: (rows: AllReceiverRow[]) => void;
  /** ◀ 제거된 신규('I') 행 복원 — backup 에서 제거 → 좌측 목록 재등장 (E15) */
  restoreMovedReceivers: (userIds: string[]) => void;
  selectCategory: (row?: CategoryRow) => void;
  openSqlDialog: () => void;
  closeSqlDialog: () => void;
  openContentDialog: (language: string, content: string, readOnly: boolean) => void;
  closeContentDialog: () => void;
  setContentDraft: (content: string) => void;
}

const initialSearchParams: MailSearchParams = {
  module: ALL,
  submodule: ALL,
  active: 'Y',
};

const createInitialState = (): MailSetupState => ({
  initialized: false,
  filters: undefined,
  searchParams: initialSearchParams,
  receiverSearchParams: { user: '', dept: '' },
  receiverFilters: undefined,
  categoryColumns: [],
  messageColumns: [],
  allReceiverColumns: [],
  selReceiverColumns: [],
  isOpenSearchArea: true,
  activeTab: 'message',
  focusedArea: 'category',
  movedReceivers: [],
  selectedCategoryId: '',
  selectedCategoryDesc: '',
  selectedModuleCode: '',
  selectedSubModuleCode: '',
  isSqlDialogOpen: false,
  isContentDialogOpen: false,
  contentDialogReadOnly: false,
  contentDraft: '',
  contentTargetLanguage: '',
});

const fetchColumns = async (sheetName: SHEETS) => {
  const result = await apiClient.post<RawFlexGridColumnConfig[]>(
    `/admin/menu/${MENU_ID}/column`,
    { sheetNm: sheetName }
  );
  return result.data.result;
};

export const useMailSetupStore = createPersistedStoreWithTab<MailSetupState & MailSetupAction>(
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
        // E02-3 — 마스터 재조회 시 하위 영역 클리어 (AS-IS FindData_Main L391~393):
        //   All_Receiver 조회 결과·▶ 이동 백업까지 초기화 (Message/Sel_Receiver 는 categoryId 리셋으로 비활성).
        state.receiverFilters = undefined;
        state.movedReceivers = [];
      });
    },
    setReceiverFilters: () => {
      set(state => {
        state.receiverFilters = { ...state.receiverSearchParams };
        // AS-IS FindData_AllReceiver — 사용자 재조회 시 그리드·백업 초기화 (E03)
        state.movedReceivers = [];
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
        { paramNm: keyof MailSearchParams; paramCtn: string }[]
      >(`/admin/menu/${MENU_ID}/search-conditions`);

      if (conditions.data.result?.length > 0) {
        const restored = conditions.data.result.reduce<MailSearchParams>(
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
        // Message 탭에는 수신자 검색 영역이 없음 — F5 는 마스터 조회로 복귀 (E01)
        if (tab === 'message') state.focusedArea = 'category';
      });
    },
    setFocusedArea: area => {
      set(state => {
        state.focusedArea = area;
      });
    },
    pushMovedReceivers: rows => {
      set(state => {
        const existing = new Set(state.movedReceivers.map(row => row.USERID));
        state.movedReceivers = [
          ...state.movedReceivers,
          ...rows.filter(row => !existing.has(row.USERID)),
        ];
      });
    },
    restoreMovedReceivers: userIds => {
      if (userIds.length === 0) return;
      set(state => {
        state.movedReceivers = state.movedReceivers.filter(row => !userIds.includes(row.USERID));
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
      });
    },
    openSqlDialog: () => {
      set(state => {
        state.isSqlDialogOpen = true;
      });
    },
    closeSqlDialog: () => {
      set(state => {
        state.isSqlDialogOpen = false;
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
  'mail-setup'
);
