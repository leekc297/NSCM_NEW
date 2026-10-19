import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab } from '@shared/stores';

import { ADMIN_SHEET_NAME, ALL, MENU_ID, SHEETS } from './bod-item.constants';
import type { SearchParamProps } from './bod-item.types';

type FiltersBySheet = {
  [SHEETS.BOD_ITEM]?: ProcRequest<MENU_ID, SHEETS.BOD_ITEM>;
  [SHEETS.BOD_EXCLUDED]?: ProcRequest<MENU_ID, SHEETS.BOD_EXCLUDED>;
};

type StaticColumnsBySheet = Record<SHEETS, RawFlexGridColumnConfig[]>;

interface BodItemState {
  initialized: boolean;
  isOpenSearchArea: boolean;
  searchParams: SearchParamProps;
  filters: FiltersBySheet;
  staticColumns: StaticColumnsBySheet;
}

interface BodItemAction {
  reset: () => void;
  setOpenSearchArea: (open?: boolean) => void;
  setSearchParams: (searchParams: Partial<SearchParamProps>) => void;
  setFilters: () => void;
  fetchStaticColumns: () => Promise<void>;
}

const initSearchParams: SearchParamProps = {
  // 기본 미선택(전체) — AS-IS SCP0030 은 MyDivision 자동선택 등 기본값을 두지 않는다(02 §4.2).
  divisionId: ALL,
  fromSite: ALL,
  toSite: ALL,
  incoterms: ALL,
  transMode: ALL,
  planGroupId: ALL,
  validYn: ALL,
  itemId: '',
  nickName: '',
};

const initState: BodItemState = {
  initialized: false,
  isOpenSearchArea: true,
  searchParams: initSearchParams,
  filters: {},
  staticColumns: {
    [SHEETS.BOD_ITEM]: [],
    [SHEETS.BOD_EXCLUDED]: [],
  },
};

/** SP 파라미터 payload — bodItem/Excluded 공통 8필드. valid=cboValidYN, itemId/nickName=텍스트. */
const buildBaseFilter = (sp: SearchParamProps) => ({
  divisionId: sp.divisionId,
  fromSite: sp.fromSite,
  toSite: sp.toSite,
  incoterms: sp.incoterms,
  transMode: sp.transMode,
  itemId: sp.itemId,
  nickName: sp.nickName,
  valid: sp.validYn,
});

export const useBodItemStore = createPersistedStoreWithTab<BodItemState & BodItemAction>(
  (set, get) => ({
    ...initState,
    reset: () => set(initState),
    setOpenSearchArea: open => {
      set(state => {
        state.isOpenSearchArea = open ?? !state.isOpenSearchArea;
      });
    },
    // Division 변경 시 하위 cascade 콤보(From/To Site/Plan Group)를 'ALL' 로 리셋한다 —
    // AS-IS SetChangeControl()(cs:315-326)이 division 변경마다 하위 후보를 재필터한다(02 §3).
    // 그리드 재조회는 Search 로만(AS-IS 도 division 을 SP 재호출하지 않음, 02 §3.2) — 자매화면
    // SCP0007 과 동일 규약(멀티선택 토글마다 그리드가 사라지는 문제 방지).
    setSearchParams: searchParams => {
      set(state => {
        const next = { ...get().searchParams, ...searchParams };
        if (
          searchParams.divisionId !== undefined &&
          searchParams.divisionId !== get().searchParams.divisionId
        ) {
          next.fromSite = ALL;
          next.toSite = ALL;
          next.planGroupId = ALL;
        }
        state.searchParams = next;
      });
    },
    // bodItem GET 은 planGroupId 미전달(AS-IS 메인 SP 주석처리, 02 §5.3 — 비기능 유지),
    // Excluded GET 만 planGroupId 를 받는다(PROC_M 실측).
    setFilters: () => {
      set(state => {
        const sp = get().searchParams;
        const base = buildBaseFilter(sp);
        state.filters = {
          [SHEETS.BOD_ITEM]: base,
          [SHEETS.BOD_EXCLUDED]: { ...base, planGroupId: sp.planGroupId },
        };
      });
    },
    // 컬럼 메타는 admin(SCM_MST_SHEET_COLUMNS)에서 동적 fetch — 하드코딩 금지(#65/#66).
    // 조회 SP(PR_GET_SHEET_COLUMN_LIST)는 SHEET_NAME 을 정확히 일치 비교하므로 admin 원본명 전송.
    fetchStaticColumns: async () => {
      const fetchOne = (sheet: SHEETS) =>
        apiClient.post<RawFlexGridColumnConfig[]>(`/admin/menu/${MENU_ID}/column`, {
          sheetNm: ADMIN_SHEET_NAME[sheet],
        });

      const [bodItem, excluded] = await Promise.all([
        fetchOne(SHEETS.BOD_ITEM),
        fetchOne(SHEETS.BOD_EXCLUDED),
      ]);
      set(state => {
        state.staticColumns = {
          [SHEETS.BOD_ITEM]: bodItem.data.result,
          [SHEETS.BOD_EXCLUDED]: excluded.data.result,
        };
      });

      if (get().initialized) return;
      const param = await apiClient.get<{ paramNm: keyof SearchParamProps; paramCtn: string }[]>(
        `/admin/menu/${MENU_ID}/search-conditions`
      );
      if (param.data.result?.length > 0) {
        const restored = param.data.result.reduce(
          (acc, curr) => {
            acc[curr.paramNm] = curr.paramCtn;
            return acc;
          },
          { ...initSearchParams } as SearchParamProps
        );
        set(state => {
          state.searchParams = restored;
        });
      }
      set(state => {
        state.initialized = true;
      });
    },
  }),
  'bod-item'
);
