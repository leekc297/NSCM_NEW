import { apiClient } from '@foundation/apis';
import dayjs from '@foundation/dayjs';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab, useSessionStore } from '@shared/stores';

import { MENU_ID, SHEETS } from './metal-link-price.constants';
import type { SearchParamProps } from './metal-link-price.types';

// SP filter payload — useTabProcQuery enabled 가드.
//   MAIN = PKG_DMF0074.P_DMF0074_GET_METAL_LINK_PRICE (PROC_M SORT_ORD 1~12 IN — ALL_ARGUMENTS 실측)
type FiltersBySheet = {
  [SHEETS.MAIN]?: ProcRequest<MENU_ID, SHEETS.MAIN>;
};

interface MetalLinkPriceState {
  initialized: boolean;
  isOpenSearchArea: boolean;
  searchParams: SearchParamProps;
  filters: FiltersBySheet;
  staticColumn: RawFlexGridColumnConfig[];
}

interface MetalLinkPriceAction {
  reset: () => void;
  setOpenSearchArea: (open?: boolean) => void;
  setSearchParams: (searchParams: Partial<SearchParamProps>) => void;
  setFilters: () => void;
  clearFilters: () => void;
  fetchStaticColumns: () => Promise<void>;
}

// AS-IS drpPeriodMonth 기본 당월 ~ +6개월 (.cs L167~168 1:1). dayjs = 로컬 날짜 (UTC 금지).
const thisMonth = dayjs().format('YYYYMMDD');
const sixMonthsAhead = dayjs().add(6, 'month').format('YYYYMMDD');

const initMetalLinkPriceState: MetalLinkPriceState = {
  initialized: false,
  isOpenSearchArea: true,
  searchParams: {
    // 기본 '40' — 저장된 개인화 Condition 이 있으면 fetchStaticColumns 에서 덮음 (사용자 요구 2026-07-10)
    divisionId: '40',
    team: '',
    endCustomer: '',
    salesSite: '',
    plantSite: '',
    project: '',
    modelNickname: '',
    fromYyyymm: thisMonth,
    toYyyymm: sixMonthsAhead,
    version: 'Current', // AS-IS txtVersion 기본 "Current" (.cs L222)
  },
  filters: {},
  staticColumn: [],
};

export const useMetalLinkPriceStore = createPersistedStoreWithTab<
  MetalLinkPriceState & MetalLinkPriceAction
>(
  (set, get) => ({
    ...initMetalLinkPriceState,
    reset: () => set(initMetalLinkPriceState),
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
    setFilters: () => {
      // ⭐ 키명 = PKG_DMF0074 PROC_M COL_NM (ALL_ARGUMENTS 실측 2026-07-10 —
      //   _deploy_packages/_dmf0074_metal_link_price_fe_20260710/04_VERIFY).
      //   콤보 멀티 빈값 = 'ALL' sentinel / 텍스트(project/modelNickname) 빈값 = '' raw (DMF0014 선례).
      //   sesUserId/mnuId 는 BE 세션 자동 (division-gate 키 — 보강 전송).
      const sesUserId = useSessionStore.getState().session.userId ?? '';
      set(state => {
        const p = state.searchParams;
        const orAll = (v: string): string => (v && v.trim() !== '' ? v : 'ALL');
        state.filters = {
          // ── PKG_DMF0074.P_DMF0074_GET_METAL_LINK_PRICE (10 IN + 세션 2) ──
          [SHEETS.MAIN]: {
            divisionId: p.divisionId, // 1  P_DIVISION_ID (단일 필수 — MSG00097 가드)
            deptId: orAll(p.team), // 2  P_DEPT_ID (Team)
            endCustomer: orAll(p.endCustomer), // 3  P_END_CUSTOMER
            scmSiteId: orAll(p.salesSite), // 4  P_SCM_SITE_ID (Sales Site)
            plantSiteId: orAll(p.plantSite), // 5  P_PLANT_SITE_ID (81* 전용 — 그 외 'ALL')
            projectCode: p.project, // 6  P_PROJECT_CODE (AS-IS txtProject.Text raw)
            itemId: p.modelNickname, // 7  P_ITEM_ID (AS-IS txtItemId.Text raw)
            fromYyyymmdd: p.fromYyyymm, // 8  P_FROM_YYYYMMDD (AS-IS MonthText '-' 제거 YYYYMM)
            toYyyymmdd: p.toYyyymm, // 9  P_TO_YYYYMMDD (YYYYMM)
            versionType: p.version, // 10 P_VERSION_TYPE ('Current' | 버전NO 콤마 최대 2)
            sesUserId, // 11 P_USER_ID (BE 자동 — division-gate)
            mnuId: MENU_ID, // 12 P_MENU_ID (BE 자동 — division-gate)
          },
        };
      });
    },
    clearFilters: () =>
      set(state => {
        state.filters = {};
      }),

    // ⭐ ui-dynamic-property-management — Column 동적 fetch (SCM_MST_SHEET_COLUMNS 58행, admin 즉시 반영)
    //   + 저장된 개인화 조회조건(F6 Condition) 1회 적용 — 없으면 기본값('40' 등) 유지 (user-management 표준)
    fetchStaticColumns: async () => {
      try {
        const result = await apiClient.post<RawFlexGridColumnConfig[]>(
          `/admin/menu/${MENU_ID}/column`,
          {
            sheetNm: SHEETS.MAIN, // 'Metal Link Price' — 등록명 그대로 (룰 #91)
            // ⭐ #92 개정 (사용자 지시 2026-07-10) — DIVISION_ID 직접 사용: 서버측 토큰 필터
            //   (PKG_NSCM_UI_COM_MENU L164/214 INSTR 매칭). ATTRIBUTE3 복사 방식 폐기.
            divisionId: get().searchParams.divisionId || null,
          }
        );
        set(state => {
          state.staticColumn = result.data.result ?? [];
        });
      } catch {
        // BE 메타 미응답 시 silent fallback — MAIN_COLUMNS 스냅샷 유지 (console 금지 룰)
      }
      // 개인화 Condition — 탭 수명 내 1회 (columns 는 매 조회 갱신, guard 밖 — 룰 준수)
      if (get().initialized) return;
      try {
        const param = await apiClient.get<{ paramNm: keyof SearchParamProps; paramCtn: string }[]>(
          `/admin/menu/${MENU_ID}/search-conditions`
        );
        if (param.data.result?.length > 0) {
          const saved = param.data.result.reduce(
            (acc, curr) => {
              acc[curr.paramNm] = curr.paramCtn;
              return acc;
            },
            {} as Record<keyof SearchParamProps, string>
          );
          set(state => {
            // 부분 병합 — 저장분에 없는 키는 기본값 유지 (전체 교체 시 신규 키 유실 방지)
            state.searchParams = { ...state.searchParams, ...saved };
          });
        }
      } catch {
        // 저장 조건 미존재/미응답 = 기본값 유지 (console 금지 룰)
      }
      set(state => {
        state.initialized = true;
      });
    },
  }),
  'metal-link-price'
);
