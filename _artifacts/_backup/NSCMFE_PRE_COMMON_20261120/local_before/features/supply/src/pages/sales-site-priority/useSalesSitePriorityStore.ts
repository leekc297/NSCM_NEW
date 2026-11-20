import dayjs from 'dayjs';

import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab } from '@shared/stores';

import { ADMIN_SHEET_NAME, MENU_ID, SHEETS, VALID_DEFAULT } from './sales-site-priority.constants';
import type { SearchCondition } from './sales-site-priority.types';

type FiltersBySheet = {
  [SHEETS.MAIN]?: ProcRequest<MENU_ID, SHEETS.MAIN>;
};

type StaticColumnsBySheet = {
  [SHEETS.MAIN]: RawFlexGridColumnConfig[];
};

interface State {
  initialized: boolean;
  searchCondition: SearchCondition;
  filters: FiltersBySheet;
  openSearchArea: boolean;
  // ui-dynamic-property-management — admin SCM_MST_SHEET_COLUMNS 동적 fetch(실측 14행 등록됨, design 03 §1).
  staticColumns: StaticColumnsBySheet;
}

interface Action {
  reset: () => void;
  setSearchCondition: (p: Partial<SearchCondition>) => void;
  restoreSearchCondition: () => Promise<void>;
  setDivision: (divisionId: string) => void;
  setFilter: () => void;
  clearFilters: () => void;
  setOpenSearchArea: (open?: boolean) => void;
  fetchStaticColumns: () => Promise<void>;
}

// AS-IS setPeriod(.cs:815~830): 이번 주 월요일 ~ 월요일+52주. AS-IS 는 `Monday - DayOfWeek` 라 일요일(0)에는
//   내일(다음 주 월요일)이 된다 — 파리티를 위해 그대로 재현한다(dayjs.day(): 일=0).
const defaultPeriod = () => {
  const today = dayjs();
  const monday = today.add(1 - today.day(), 'day');
  return {
    fromDate: monday.format('YYYYMMDD'),
    toDate: monday.add(52 * 7, 'day').format('YYYYMMDD'),
  };
};

const initSearch: SearchCondition = {
  divisionId: '',
  planGroupIds: [],
  siteIds: [],
  itemId: '',
  ...defaultPeriod(),
  validYn: VALID_DEFAULT,
};

const emptyStaticColumns: StaticColumnsBySheet = {
  [SHEETS.MAIN]: [],
};

const initState: State = {
  initialized: false,
  searchCondition: initSearch,
  filters: {},
  openSearchArea: true,
  staticColumns: emptyStaticColumns,
};

export const useSalesSitePriorityStore = createPersistedStoreWithTab<State & Action>(
  (set, get) => ({
    ...initState,
    reset: () => set(initState),
    setSearchCondition: p =>
      set(state => {
        state.searchCondition = { ...get().searchCondition, ...p };
      }),
    // F6 로 서버에 저장해 둔 조회조건을 진입(mount) 시 1회 되읽어 폼에 복원한다.
    //   createPersistedStoreWithTab 은 새로고침 때 영속화하지 않으므로(store 는 비영속), 이 GET
    //   복원이 없으면 F6 저장이 성공해도 새로고침/재진입 후 initSearch 기본값만 떠서 저장한 조건이
    //   사라진다(기본점검 #3, 자매 constraint-mgmt·SCP0028 동형). 저장분이 없으면 기본값을 그대로 둔다.
    //   자동조회는 하지 않는다 — filters 는 mount 의 clearFilters 가 비운 채라 사용자가 Search 를
    //   눌러야 조회된다(AS-IS FindWhenOpen 미설정 파리티). personalizeCondition 이 배열을 콤마로 접어
    //   저장하고 저장 SP 가 빈 값을 skip 하므로, 다중(planGroup/site)은 콤마 분해하고 미저장 키는 유지한다.
    restoreSearchCondition: async () => {
      const res = await apiClient.get<{ paramNm: string; paramCtn: string }[]>(
        `/admin/menu/${MENU_ID}/search-conditions`
      );
      const saved = res.data.result;
      if (!saved?.length) return;
      const map = new Map(saved.map(r => [r.paramNm, r.paramCtn]));
      set(state => {
        const next: SearchCondition = { ...initSearch };
        const divisionId = map.get('divisionId');
        if (divisionId !== undefined) next.divisionId = divisionId;
        const planGroupIds = map.get('planGroupIds');
        if (planGroupIds !== undefined)
          next.planGroupIds = planGroupIds.split(',').filter(v => v !== '');
        const siteIds = map.get('siteIds');
        if (siteIds !== undefined) next.siteIds = siteIds.split(',').filter(v => v !== '');
        const itemId = map.get('itemId');
        if (itemId !== undefined) next.itemId = itemId;
        const validYn = map.get('validYn');
        if (validYn !== undefined) next.validYn = validYn;
        const fromDate = map.get('fromDate');
        if (fromDate !== undefined) next.fromDate = fromDate;
        const toDate = map.get('toDate');
        if (toDate !== undefined) next.toDate = toDate;
        state.searchCondition = next;
      });
    },
    // Division 변경(싱글 콤보) = TO-BE 공통 요건: Division·기간(from/to) 을 제외한 검색조건을 전부 초기화하고
    //   그리드도 초기화(filters clear)한다(사용자 지시 2026-10-02 — TO-BE 공통 요건이 AS-IS 핸들러보다 우선).
    //   기간(from/to)·Division(새 값)만 유지하고 planGroup/site/item/valid 는 initSearch 로 되돌린다
    //   (종전 onChange 는 cascade 로 planGroup/site 만 비웠다 — item/valid 잔존 + 그리드 미초기화 결함 해소).
    //   편집중(dirty) 확인 가드(MSG00704)는 Form 의 onChange 가 confirmIfDirtyKey 로 처리한다(commit 51d4e9fa 패턴).
    //   그리드는 itemsSource=rows(=filters 기반 쿼리)라 filters 를 비우면 신규행·미저장 편집이 함께 폐기된다.
    setDivision: divisionId =>
      set(state => {
        const cur = get().searchCondition;
        state.searchCondition = {
          ...initSearch, // Division·기간 제외 전 조건 초기화(planGroup/site/item/valid)
          divisionId,
          fromDate: cur.fromDate,
          toDate: cur.toDate,
        };
        state.filters = {}; // 그리드 초기화 — 재조회(Search) 전까지 빈 상태
      }),
    // GET SP 파라미터 매핑(design 00 §4 spCalls#2, SCP0131_GET_SALES_SITE_PRIORITY 7 param):
    //   1 p_division_id / 2 p_plan_group_id / 3 p_scm_site_id / 4 p_item_id / 5 p_valid_yn /
    //   6 p_period_from / 7 p_period_to
    setFilter: () => {
      set(state => {
        const c = state.searchCondition;
        state.filters = {
          [SHEETS.MAIN]: {
            divisionId: c.divisionId, // 1
            planGroupId: c.planGroupIds.join(','), // 2
            scmSiteId: c.siteIds.join(','), // 3
            itemId: c.itemId, // 4
            validYn: c.validYn, // 5
            periodFrom: c.fromDate, // 6
            periodTo: c.toDate, // 7
          },
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

    // admin SCM_MST_SHEET_COLUMNS 동적 fetch — 미등록/실패 시 빈 배열 유지(그리드 하드코딩 없음).
    fetchStaticColumns: async () => {
      try {
        const res = await apiClient.post<RawFlexGridColumnConfig[]>(
          `/admin/menu/${MENU_ID}/column`,
          { sheetNm: ADMIN_SHEET_NAME[SHEETS.MAIN] ?? SHEETS.MAIN }
        );
        const next = res.data.result ?? [];
        if (next.length > 0) {
          set(state => {
            if (JSON.stringify(state.staticColumns[SHEETS.MAIN]) !== JSON.stringify(next)) {
              state.staticColumns[SHEETS.MAIN] = next;
            }
          });
        }
      } catch {
        // 미등록/실패 = 빈 배열 유지(console 금지 룰)
      }
      set(state => {
        state.initialized = true;
      });
    },
  }),
  'sales-site-priority-store'
);
