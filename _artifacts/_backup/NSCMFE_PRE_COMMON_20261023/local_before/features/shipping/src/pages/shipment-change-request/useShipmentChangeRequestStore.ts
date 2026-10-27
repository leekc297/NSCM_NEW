import { apiClient } from '@foundation/apis';
import dayjs from '@foundation/dayjs';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab, useSessionStore } from '@shared/stores';

import {
  ADMIN_SHEET_NAME,
  ALL,
  DEFAULT_PLAN_TYPE,
  DEFAULT_STATUS,
  FIXED_DIVISION,
  MENU_ID,
  PERIOD_OFFSET_DAY,
  PLAN_TYPE_P_FROM_OFFSET,
  PLAN_TYPE_PLAN,
  SHEETS,
} from './shipment-change-request.constants';
import type { RequestInfo, SearchCondition } from './shipment-change-request.types';

type FiltersBySheet = {
  [SHEETS.MAIN]?: ProcRequest<MENU_ID, SHEETS.MAIN>;
  [SHEETS.SUB]?: ProcRequest<MENU_ID, SHEETS.SUB>;
};

type StaticColumnsBySheet = {
  [SHEETS.MAIN]: RawFlexGridColumnConfig[];
  [SHEETS.SUB]: RawFlexGridColumnConfig[];
};

interface State {
  initialized: boolean;
  searchCondition: SearchCondition;
  filters: FiltersBySheet;
  openSearchArea: boolean;
  requestInfo: RequestInfo;
  // ui-dynamic-property-management §2.3 — admin SCM_MST_SHEET_COLUMNS 동적 fetch(메인/서브 2회).
  staticColumns: StaticColumnsBySheet;
}

interface Action {
  reset: () => void;
  setSearchCondition: (p: Partial<SearchCondition>) => void;
  setPeriod: (fromYyyymmdd: string, toYyyymmdd: string) => void;
  // GAP-08: mount 시 Period 기본값(30일) 세팅. Plan Type 변경 시 재계산 + 그리드 clear.
  initPeriodDefault: () => void;
  changePlanType: (changeType: string) => void;
  setFilter: () => void;
  clearFilters: () => void;
  setOpenSearchArea: (open?: boolean) => void;
  setRequestInfo: (p: Partial<RequestInfo>) => void;
  clearRequestInfo: () => void;
  fetchStaticColumns: () => Promise<void>;
}

const emptyRequestInfo: RequestInfo = {
  requestNo: '',
  title: '',
  requestor: useSessionStore.getState().session.userId ?? '',
  requestDeptName: '',
  approval: '',
  approvalId: '',
  appDeptName: '',
  appDeptId: '',
  changeReason: '',
  reasonDetail: '',
};

const initSearch: SearchCondition = {
  divisionId: FIXED_DIVISION, // R3 고정 '40'
  fromSiteIds: [],
  toSiteIds: [],
  changeType: DEFAULT_PLAN_TYPE, // 'C'
  status: DEFAULT_STATUS, // 'ALL'
  itemId: '',
  fromYyyymmdd: '',
  toYyyymmdd: '',
  erpSoNo: '',
  confirmId: '',
};

const emptyStaticColumns: StaticColumnsBySheet = {
  [SHEETS.MAIN]: [],
  [SHEETS.SUB]: [],
};

const initState: State = {
  initialized: false,
  searchCondition: initSearch,
  filters: {},
  openSearchArea: true,
  requestInfo: emptyRequestInfo,
  staticColumns: emptyStaticColumns,
};

// design 02 §2-3/§3: Period 기본 = GetDayRange(base) = [base, base+PERIOD_OFFSET_DAY(30)].
//   base = Plan Type 'P' 이면 오늘+9D(design 02 §3 cascade#2), 그 외 오늘.
//   주의: AS-IS 는 SCM0001_GET_SCP_DAY_PERIOD(타임존/영업일 반영) 서버계산 — TO-BE 는 클라 근사(dayjs,
//     business-plan 동일 패턴). 정밀 영업일 계산은 convert-sp(SP 배포) 후 대조.
const OFFSET_DAY = Number(PERIOD_OFFSET_DAY);
const periodByPlanType = (changeType: string): { from: string; to: string } => {
  const base = changeType === PLAN_TYPE_PLAN ? dayjs().add(PLAN_TYPE_P_FROM_OFFSET, 'day') : dayjs();
  return { from: base.format('YYYYMMDD'), to: base.add(OFFSET_DAY, 'day').format('YYYYMMDD') };
};

// 다중/단일/다건 -> SP 파라미터 문자열. ALL/빈값 = '' (전체, GET SP TRIM 무시).
const joinOrEmpty = (arr: string[]): string => (arr.length === 0 ? '' : arr.join(','));
const oneOrEmpty = (v: string): string => (v && v !== ALL ? v : '');
// 개행/콤마 다건 -> 콤마 join (AS-IS UsrMultiLineEditor .Text, GET SP FN_GET_IN_STR IN절).
const multiLine = (v: string): string =>
  v
    ? v
        .split(/[\n,]/)
        .map(s => s.trim())
        .filter(Boolean)
        .join(',')
    : '';

export const useShipmentChangeRequestStore = createPersistedStoreWithTab<State & Action>(
  (set, get) => ({
    ...initState,
    // F10(조회조건 초기화) 전용 — MotherStore.resetSearchCondition 이 이 reset() 을 부른다.
    //   자매 SSP0200 ac551790 과 동일 규약:
    //   · 조회된 그리드(filters)는 비우지 않는다 — 조회조건만 초기화하고 조회 데이터는 유지한다.
    //     (종전 `set(initState)` 는 filters 까지 날려 F10 이 그리드까지 비웠다.)
    //   · staticColumns/initialized 는 MotherStore 가 별도 보존하므로 함께 유지한다.
    //   · Period 는 initSearch 에서 ''이므로 삭제만 되지 않도록 기본값을 재산출한다.
    reset: () => {
      const { filters, staticColumns, initialized } = get();
      set({ ...initState, filters, staticColumns, initialized });
      // Plan Type 기준 30일 기본값 재산출(dayjs 근사 — GET_SCP_DAY_PERIOD 메타 미등록, 아래 주석 참조).
      get().initPeriodDefault();
    },
    setSearchCondition: p =>
      set(state => {
        state.searchCondition = { ...get().searchCondition, ...p };
      }),
    setPeriod: (fromYyyymmdd, toYyyymmdd) =>
      set(state => {
        state.searchCondition.fromYyyymmdd = fromYyyymmdd;
        state.searchCondition.toYyyymmdd = toYyyymmdd;
      }),
    // GAP-08: mount 최초 진입 시 Period 기본값(현 Plan Type 기준 30일 범위) 세팅.
    initPeriodDefault: () =>
      set(state => {
        const { from, to } = periodByPlanType(get().searchCondition.changeType);
        state.searchCondition.fromYyyymmdd = from;
        state.searchCondition.toYyyymmdd = to;
      }),
    // GAP-08: Plan Type 변경(design 02 §3 cascade#2) — Period 재계산 + 그리드/요청정보 clear(InitSpread).
    changePlanType: changeType =>
      set(state => {
        const { from, to } = periodByPlanType(changeType);
        state.searchCondition.changeType = changeType;
        state.searchCondition.fromYyyymmdd = from;
        state.searchCondition.toYyyymmdd = to;
        state.filters = {};
        state.requestInfo = {
          ...emptyRequestInfo,
          requestor: useSessionStore.getState().session.userId ?? '',
        };
      }),
    setFilter: () => {
      set(state => {
        const c = state.searchCondition;
        // GET SP SSP0201_GET_SHIPMENT_CHANGE_REQUEST(메인) 파라미터 (design 02 §1):
        //   p_division_id / p_from_site / p_to_site / p_change_type / p_status / p_item_id /
        //   p_from_yyyymmdd / p_to_yyyymmdd / p_erp_so_no / p_confirm_id / p_language(@sesLangCd 세션)
        const language = useSessionStore.getState().session.langCd ?? '';
        const base = {
          divisionId: c.divisionId,
          fromSite: joinOrEmpty(c.fromSiteIds),
          toSite: joinOrEmpty(c.toSiteIds),
          changeType: c.changeType,
          status: oneOrEmpty(c.status),
          itemId: multiLine(c.itemId),
          fromYyyymmdd: c.fromYyyymmdd,
          toYyyymmdd: c.toYyyymmdd,
          erpSoNo: multiLine(c.erpSoNo),
          confirmId: multiLine(c.confirmId),
          language,
        };
        state.filters = {
          // 메인/서브는 동일 조회조건, 서브 GET SP 는 내부적으로 request_status='D' 필터.
          [SHEETS.MAIN]: base,
          [SHEETS.SUB]: base,
        };
      });
    },
    clearFilters: () =>
      set(state => {
        state.filters = {};
      }),
    setOpenSearchArea: open =>
      set(state => {
        state.openSearchArea = open ?? !state.openSearchArea;
      }),
    setRequestInfo: p =>
      set(state => {
        state.requestInfo = { ...get().requestInfo, ...p };
      }),
    clearRequestInfo: () =>
      set(state => {
        // R9 ClearRequestInfo — Requestor/Dept 세션값은 유지, 편집필드만 초기화.
        state.requestInfo = {
          ...emptyRequestInfo,
          requestor: useSessionStore.getState().session.userId ?? '',
        };
      }),

    fetchStaticColumns: async () => {
      // 메인/서브 2 시트 컬럼메타 각각 fetch (design 03 §4.1). 미등록/실패 시 빈 배열 유지.
      for (const sheet of [SHEETS.MAIN, SHEETS.SUB]) {
        try {
          const res = await apiClient.post<RawFlexGridColumnConfig[]>(
            `/admin/menu/${MENU_ID}/column`,
            { sheetNm: ADMIN_SHEET_NAME[sheet] }
          );
          const next = res.data.result ?? [];
          if (next.length > 0) {
            set(state => {
              if (JSON.stringify(state.staticColumns[sheet]) !== JSON.stringify(next)) {
                state.staticColumns[sheet] = next;
              }
            });
          }
        } catch {
          // 미등록/실패 = 빈 배열(console 금지 룰)
        }
      }
      // 저장된 조회조건 복원(최초 1회) — 자매 SSP0200 ac551790 item4 와 동일 규약.
      //   F6(personalizeCondition) 저장은 되는데 복원 경로가 없어 재진입 시 사라졌다.
      //   다중선택(fromSiteIds/toSiteIds)은 저장 시 콤마 join 되므로(gridAction personalizeCondition)
      //   배열로 되돌린다. 직접 set 이라 Plan Type cascade 미발동(복원값 그대로 유지).
      //   실패/미등록은 무시한다 — 명시 Search 전에는 어차피 조회가 나가지 않는다.
      if (!get().initialized) {
        try {
          const res = await apiClient.get<{ paramNm: string; paramCtn: string }[]>(
            `/admin/menu/${MENU_ID}/search-conditions`
          );
          const list = res.data.result ?? [];
          if (list.length > 0) {
            const restored: Partial<SearchCondition> = {};
            for (const { paramNm, paramCtn } of list) {
              if (paramNm === 'fromSiteIds' || paramNm === 'toSiteIds') {
                restored[paramNm] = paramCtn ? paramCtn.split(',').filter(Boolean) : [];
              } else {
                (restored as Record<string, unknown>)[paramNm] = paramCtn;
              }
            }
            set(state => {
              state.searchCondition = { ...get().searchCondition, ...restored };
            });
          }
        } catch {
          // 복원 실패 무시
        }
      }
      set(state => {
        state.initialized = true;
      });
    },
  }),
  'shipment-change-request-store'
);
