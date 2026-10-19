import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab } from '@shared/stores';

import { MENU_ID, RUN_STATUS_ALL, SHEETS } from './batch-log.constants';

interface SearchParamProps {
  runStatus: string;
}

type FiltersBySheet = {
  [SHEETS.BATCH_LOG]?: ProcRequest<MENU_ID, SHEETS.BATCH_LOG>;
  [SHEETS.STEP_INFO]?: ProcRequest<MENU_ID, SHEETS.STEP_INFO>;
  [SHEETS.BATCH_LOG_HIST]?: ProcRequest<MENU_ID, SHEETS.BATCH_LOG_HIST>;
};

// admin(SCM_MST_SHEET_COLUMNS) 등록 컬럼. 시트별 배열. 미등록/실패면 빈 배열(그리드 constants fallback).
type AdminColumnsBySheet = {
  [SHEETS.BATCH_LOG]: RawFlexGridColumnConfig[];
  [SHEETS.STEP_INFO]: RawFlexGridColumnConfig[];
  [SHEETS.BATCH_LOG_HIST]: RawFlexGridColumnConfig[];
};

interface BatchLogState {
  isOpenSearchArea: boolean;
  filters: FiltersBySheet;
  searchParams: SearchParamProps;
  adminColumns: AdminColumnsBySheet;
}

interface BatchLogAction {
  reset: () => void;
  setOpenSearchArea: (open?: boolean) => void;
  setSearchParams: (searchParams: Partial<SearchParamProps>) => void;
  // Find 버튼 — Main(Batch Log) 조회. 상세(Step/Hist)는 비운다(새 조회 = 선택 초기화).
  setListFilter: () => void;
  // Main 행 더블클릭 — 선택 JOB_ID 로 Step/Hist 재조회(master->detail). run_status 필터 미적용.
  setDetailFilter: (jobId: string) => void;
  clearDetail: () => void;
  // admin 등록 컬럼 3시트 동적 fetch(마운트 1회). 미등록/실패는 constants fallback(tact-time 패턴).
  fetchAdminColumns: () => Promise<void>;
}

const initSearchParams: SearchParamProps = {
  runStatus: RUN_STATUS_ALL,
};

const initBatchLogState: BatchLogState = {
  isOpenSearchArea: true,
  filters: {
    [SHEETS.BATCH_LOG]: undefined,
    [SHEETS.STEP_INFO]: undefined,
    [SHEETS.BATCH_LOG_HIST]: undefined,
  },
  searchParams: initSearchParams,
  adminColumns: {
    [SHEETS.BATCH_LOG]: [],
    [SHEETS.STEP_INFO]: [],
    [SHEETS.BATCH_LOG_HIST]: [],
  },
} as const;

export const useBatchLogStore = createPersistedStoreWithTab<BatchLogState & BatchLogAction>(
  (set, get) => ({
    ...initBatchLogState,
    reset: () => set(initBatchLogState),
    setOpenSearchArea: open => {
      set(state => {
        state.isOpenSearchArea = open ?? !state.isOpenSearchArea;
      });
    },
    setSearchParams: searchParams => {
      set(state => {
        state.searchParams = { ...get().searchParams, ...searchParams };
      });
    },
    setListFilter: () => {
      set(state => {
        // ALL/빈값이면 PKG 가 전체로 처리. 개별 선택이면 코드 그대로 전달(단일선택 = CSV 아님).
        const runStatus = state.searchParams.runStatus;
        state.filters[SHEETS.BATCH_LOG] = {
          runStatus: runStatus === RUN_STATUS_ALL ? '' : runStatus,
        };
        state.filters[SHEETS.STEP_INFO] = undefined;
        state.filters[SHEETS.BATCH_LOG_HIST] = undefined;
      });
    },
    setDetailFilter: (jobId: string) => {
      set(state => {
        state.filters[SHEETS.STEP_INFO] = { jobId };
        state.filters[SHEETS.BATCH_LOG_HIST] = { jobId };
      });
    },
    clearDetail: () => {
      set(state => {
        state.filters[SHEETS.STEP_INFO] = undefined;
        state.filters[SHEETS.BATCH_LOG_HIST] = undefined;
      });
    },
    // 등록 sheetNm = FE SHEETS 값(SCM_MST_SHEET_COLUMNS.SHEET_NAME 과 동일 등재). 별도 매핑 불필요.
    fetchAdminColumns: async () => {
      const sheets: (keyof AdminColumnsBySheet)[] = [
        SHEETS.BATCH_LOG,
        SHEETS.STEP_INFO,
        SHEETS.BATCH_LOG_HIST,
      ];
      await Promise.all(
        sheets.map(async sheet => {
          try {
            const res = await apiClient.post<RawFlexGridColumnConfig[]>(
              `/admin/menu/${MENU_ID}/column`,
              { sheetNm: sheet }
            );
            const next = res.data.result ?? [];
            if (next.length === 0) return;
            set(state => {
              if (JSON.stringify(state.adminColumns[sheet]) !== JSON.stringify(next)) {
                state.adminColumns[sheet] = next;
              }
            });
          } catch {
            // 미등록/실패 = constants fallback (console 금지 룰)
          }
        })
      );
    },
  }),
  'batch-log'
);
