import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab } from '@shared/stores';

import { ADMIN_SHEET_NAME, DIVISION_FIXED, MENU_ID, SHEETS } from './inventory-raw.constants';
import type { InventoryRawSearchParams } from './inventory-raw.types';

interface InventoryRawState {
  searchParams: InventoryRawSearchParams;
  filters?: ProcRequest<MENU_ID, SHEETS.MAIN>;
  staticColumns: RawFlexGridColumnConfig[];
  isOpenSearchArea: boolean;
  openItemModal: boolean;
  // 개인화 조회조건 복원 1회 가드 (SubTitle F6 저장분 mount 복원). reset()=initState 로 false 복귀 → F10 후 재복원 허용.
  conditionsRestored: boolean;
}

interface InventoryRawAction {
  reset: () => void;
  setSearchParams: (patch: Partial<InventoryRawSearchParams>) => void;
  setFilters: () => void;
  clearFilters: () => void;
  fetchStaticColumns: () => Promise<void>;
  setOpenSearchArea: (open?: boolean) => void;
  setOpenItemModal: (open: boolean) => void;
  // 개인화 조회조건 복원 — GET /admin/menu/{MENU_ID}/search-conditions → searchParams 패치(1회).
  restoreSearchConditions: () => Promise<void>;
}

// 개인화 조건 복원 역직렬화 키(SubTitle F6 저장은 배열=콤마join·null=''·그 외 String 평문화 —
//   gridAction.ts personalizeCondition). plantSiteIds = 멀티셀렉트(콤마 결합 → split).
//   불리언 조회조건 없음. planStartYyyymmdd 는 저장측 EXCLUDED_DATE_PARAM(/yyyymmdd$/i)에 걸려
//   애초에 저장 제외이므로(AS-IS ConditionNotUseList.Add(cboPlanDate) 파리티) 복원 대상이 아니다.
const RESTORE_ARRAY_KEYS = new Set<string>(['plantSiteIds']);

const initSearchParams: InventoryRawSearchParams = {
  divisionId: DIVISION_FIXED,
  plantSiteIds: [],
  inventoryType: '',
  planStartYyyymmdd: '',
  itemId: '',
};

const initState: InventoryRawState = {
  searchParams: initSearchParams,
  filters: undefined,
  staticColumns: [],
  isOpenSearchArea: true,
  openItemModal: false,
  conditionsRestored: false,
};

export const useInventoryRawStore = createPersistedStoreWithTab<
  InventoryRawState & InventoryRawAction
>(
  (set, get) => ({
    ...initState,
    reset: () => set(initState),
    setSearchParams: patch => {
      set(state => {
        state.searchParams = { ...get().searchParams, ...patch };
      });
    },
    // SP `SSP.SSP0017_GET_INVENTORY_RAW` IN 5개(division/plant_site/item_id/inventory_type/
    //   plan_start_yyyymmdd) — user_id/program_id/sheet_name/language 는 BE 세션·라우트 자동 주입
    //   (convert-core §3.5 @LoginUser 주입 규약과 동일, DMF0004 SalesSite 표준과 일치).
    setFilters: () => {
      const sp = get().searchParams;
      set(state => {
        state.filters = {
          divisionId: sp.divisionId,
          plantSite: sp.plantSiteIds.join(','),
          itemId: sp.itemId,
          inventoryType: sp.inventoryType,
          planStartYyyymmdd: sp.planStartYyyymmdd,
        };
      });
    },
    // keep-alive 탭에 남은 이전 filters 무효화(nscm-patterns §5-7 진입 자동조회 금지 게이트).
    clearFilters: () => {
      set(state => {
        state.filters = undefined;
      });
    },
    fetchStaticColumns: async () => {
      const result = await apiClient.post<RawFlexGridColumnConfig[]>(
        `/admin/menu/${MENU_ID}/column`,
        { sheetNm: ADMIN_SHEET_NAME[SHEETS.MAIN] }
      );
      set(state => {
        state.staticColumns = result.data.result;
      });
    },
    setOpenSearchArea: open => {
      set(state => {
        state.isOpenSearchArea = open ?? !state.isOpenSearchArea;
      });
    },
    setOpenItemModal: open => {
      set(state => {
        state.openItemModal = open;
      });
    },

    // 개인화 조회조건 복원 (SubTitle F6 저장분 되불러오기, 1회) — 정본 1:1 = scp-bom(SCP0053).
    //   GET /admin/menu/{MENU_ID}/search-conditions → paramNm/paramCtn 역직렬화(배열 split, 그 외 평문).
    //   저장분 없거나 조회 실패면 기본값 유지. divisionId 는 '40' 고정+disabled 라 저장돼 있어도 복원값이 동일.
    //   setSearchParams(단순 merge)가 아니라 직접 병합 — 복원이 다른 액션 cascade 를 타지 않도록(SCP0053 패턴).
    restoreSearchConditions: async () => {
      if (get().conditionsRestored) return;
      set(state => {
        state.conditionsRestored = true;
      });
      try {
        const res = await apiClient.get<{ paramNm: string; paramCtn: string }[]>(
          `/admin/menu/${MENU_ID}/search-conditions`
        );
        const rows = res.data.result ?? [];
        if (rows.length === 0) return;
        const patch: Record<string, unknown> = {};
        for (const { paramNm, paramCtn } of rows) {
          if (!(paramNm in initSearchParams)) continue; // SearchParams 필드만 allowlist
          const val = paramCtn ?? '';
          if (RESTORE_ARRAY_KEYS.has(paramNm)) {
            patch[paramNm] = val ? val.split(',').filter(Boolean) : [];
          } else {
            patch[paramNm] = val;
          }
        }
        set(state => {
          state.searchParams = { ...state.searchParams, ...patch } as InventoryRawSearchParams;
        });
      } catch {
        // 미저장/실패 = 기본값 유지 (console 금지 룰)
      }
    },
  }),
  'inventory-raw'
);
