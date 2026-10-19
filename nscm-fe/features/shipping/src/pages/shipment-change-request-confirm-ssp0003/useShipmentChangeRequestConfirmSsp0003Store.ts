import { apiClient } from '@foundation/apis';
import dayjs from '@foundation/dayjs';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab, useSessionStore } from '@shared/stores';

import {
  ADMIN_SHEET_NAME,
  ALL,
  DEFAULT_CHANGE_TYPE,
  DEFAULT_STATUS,
  MASTER_USER_COLUMNS,
  MENU_ID,
  PERIOD_OFFSET_DAY,
  SHEETS,
} from './shipment-change-request-confirm-ssp0003.constants';
import type { SearchCondition } from './shipment-change-request-confirm-ssp0003.types';

type FiltersBySheet = {
  [SHEETS.MAIN]?: ProcRequest<MENU_ID, SHEETS.MAIN>;
  [SHEETS.SUB]?: ProcRequest<MENU_ID, SHEETS.SUB>;
  [SHEETS.DELEGATE]?: ProcRequest<MENU_ID, SHEETS.DELEGATE>;
};

type StaticColumnsBySheet = {
  [SHEETS.MAIN]: RawFlexGridColumnConfig[];
  [SHEETS.SUB]: RawFlexGridColumnConfig[];
};

interface State {
  initialized: boolean;
  // 개인화 조회조건 복원 1회 가드 (SubTitle F6 저장분 mount 복원 — initialized 는 컬럼 fetch 전용이라 별도).
  conditionsRestored: boolean;
  searchCondition: SearchCondition;
  filters: FiltersBySheet;
  openSearchArea: boolean;
  // 마스터 더블클릭 행 — 액션버튼 Visibility(userId 비교) + changeType(컬럼분기) + division(저장 라우팅) 판정 원천.
  selectedMasterRow: Record<string, unknown> | null;
  // 반려/자기반려 사유(디테일 폼 유일 입력 필드, design 01 §2-C3).
  rejectReason: string;
  // siSub CHK 체크된 행의 CONFIRM_ID 목록(design 03 §3.4 CHK 상태머신 + §4.4 per-row 저장 원천).
  //   서버데이터(subData) 는 React Query SSOT — 여기엔 선택 상태(UI)만 둔다(convert-core §2.4 store=UI 상태).
  checkedIds: string[];
  // ui-dynamic-property-management §2.3 — admin SCM_MST_SHEET_COLUMNS 동적 fetch(메인/서브 2회).
  staticColumns: StaticColumnsBySheet;
}

interface Action {
  reset: () => void;
  setSearchCondition: (p: Partial<SearchCondition>) => void;
  setPeriod: (fromYyyymmdd: string, toYyyymmdd: string) => void;
  initPeriodDefault: () => void;
  setFilter: () => void;
  clearFilters: () => void;
  setOpenSearchArea: (open?: boolean) => void;
  // 마스터 더블클릭 -> 디테일/위임자 조회 + 선택행 세팅(design 01 §2-A/§2-C).
  loadDetail: (row: Record<string, unknown>) => void;
  clearDetail: () => void;
  setRejectReason: (v: string) => void;
  // CHK 상태머신 — 조회 초기 세팅(setCheckedIds)·사용자 토글(toggleCheck, design 03 §3.4).
  setCheckedIds: (ids: string[]) => void;
  toggleCheck: (id: string) => void;
  fetchStaticColumns: () => Promise<void>;
  // 개인화 조회조건 복원 — GET /admin/menu/{MENU_ID}/search-conditions → searchCondition 패치(1회).
  restoreSearchConditions: () => Promise<void>;
}

// 개인화 조건 복원 시 배열 역직렬화 키(SubTitle F6 저장은 배열=콤마join 평문화 — gridAction.personalizeCondition).
const ARRAY_KEYS = new Set<string>(['divisionIds', 'fromSiteIds']);

const initSearch: SearchCondition = {
  divisionIds: [], // 미선택(ALL) — 권한범위 EE 제외 목록 표시
  fromSiteIds: [],
  status: DEFAULT_STATUS, // 'D'(Drafting) — AS-IS index2 패리티
  changeType: DEFAULT_CHANGE_TYPE, // 'ALL'
  requestId: '',
  itemId: '',
  fromYyyymmdd: '',
  toYyyymmdd: '',
};

const emptyStaticColumns: StaticColumnsBySheet = {
  [SHEETS.MAIN]: [],
  [SHEETS.SUB]: [],
};

const initState: State = {
  initialized: false,
  conditionsRestored: false,
  searchCondition: initSearch,
  filters: {},
  openSearchArea: true,
  selectedMasterRow: null,
  rejectReason: '',
  checkedIds: [],
  staticColumns: emptyStaticColumns,
};

// design 02 §2.5: Period 기본 = D-14 (from=오늘-14, to=오늘).
//   주의: AS-IS 는 SCM0001_GET_SCP_DAY_PERIOD(offset -14, 타임존/영업일 반영) 서버계산 — TO-BE 는
//     클라 근사(dayjs, 자매 SSP0202 동일 패턴). 정밀 영업일 계산은 SP 응답 대조로 확정.
const defaultPeriod = (): { from: string; to: string } => {
  const to = dayjs();
  return { from: to.subtract(PERIOD_OFFSET_DAY, 'day').format('YYYYMMDD'), to: to.format('YYYYMMDD') };
};

// 콤보 -> SP 파라미터. ALL/미선택은 'ALL' 로 보낸다(사용자 지시 2026-09-30 — SP 가 'ALL'=전체 처리).
//   과거엔 '' 로 보냈으나, 화면 표기(ALL)와 전송값을 일치시킨다. 다중선택은 실제 선택값을 콤마 join.
const joinOrAll = (arr: string[]): string =>
  arr.length === 0 || arr.includes(ALL) ? ALL : arr.join(',');
const oneOrAll = (v: string): string => (v && v !== ALL ? v : ALL);
// 개행/콤마 다건 -> 콤마 join (AS-IS UsrMultiLineEditor .Text, GET SP FN_GET_IN_STR IN절).
const multiLine = (v: string): string =>
  v
    ? v
        .split(/[\n,]/)
        .map(s => s.trim())
        .filter(Boolean)
        .join(',')
    : '';

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

export const useShipmentChangeRequestConfirmSsp0003Store = createPersistedStoreWithTab<
  State & Action
>((set, get) => ({
  ...initState,
  reset: () => set(initState),
  setSearchCondition: p =>
    set(state => {
      // Division 변경 시 From Site 를 무조건 비우지 않는다(사용자 지시 2026-10-07): From Site 는 div
      //   cascade 라 옵션은 재조회되지만, 선택값은 유지하고 새 옵션에 없어 무효가 된 것만 Form 이 정리한다
      //   (ShipmentChangeRequestConfirmSsp0003Form 의 prune effect). div 변경만으로 선택이 사라지지 않게 한다.
      state.searchCondition = { ...get().searchCondition, ...p };
    }),
  setPeriod: (fromYyyymmdd, toYyyymmdd) =>
    set(state => {
      state.searchCondition.fromYyyymmdd = fromYyyymmdd;
      state.searchCondition.toYyyymmdd = toYyyymmdd;
    }),
  initPeriodDefault: () =>
    set(state => {
      const { from, to } = defaultPeriod();
      state.searchCondition.fromYyyymmdd = from;
      state.searchCondition.toYyyymmdd = to;
    }),
  setFilter: () => {
    set(state => {
      const c = state.searchCondition;
      // GET SP P_SSP0003_GET_CHG_REQ_CONFIRM(메인) 9 파라미터 (design 02 §1/§5):
      //   p_division_id / p_from_site / p_request_id / p_from_yyyymmdd / p_to_yyyymmdd /
      //   p_status / p_language / p_item_id / p_change_type
      const language = useSessionStore.getState().session.langCd ?? '';
      state.filters = {
        [SHEETS.MAIN]: {
          divisionId: joinOrAll(c.divisionIds), // p_division_id (다중 콤마, ALL->'ALL')
          fromSite: joinOrAll(c.fromSiteIds), // p_from_site (ALL->'ALL')
          requestId: multiLine(c.requestId), // p_request_id (Requestor)
          fromYyyymmdd: c.fromYyyymmdd, // p_from_yyyymmdd
          toYyyymmdd: c.toYyyymmdd, // p_to_yyyymmdd
          status: oneOrAll(c.status), // p_status (ALL->'ALL')
          language, // p_language (@sesLangCd)
          itemId: multiLine(c.itemId), // p_item_id
          changeType: oneOrAll(c.changeType), // p_change_type (ALL->'ALL')
        },
      };
      // 조회 시 디테일 폼/그리드/위임자/선택행/CHK 초기화 (design 01 §2-C1).
      state.selectedMasterRow = null;
      state.rejectReason = '';
      state.checkedIds = [];
    });
  },
  clearFilters: () =>
    set(state => {
      state.filters = { [SHEETS.MAIN]: undefined };
      state.selectedMasterRow = null;
      state.rejectReason = '';
      state.checkedIds = [];
    }),
  setOpenSearchArea: open =>
    set(state => {
      state.openSearchArea = open ?? !state.openSearchArea;
    }),
  // 마스터 더블클릭 -> 디테일 GET(FindData_Sub, o_rc1=그리드/o_rc2=폼) + 위임자 GET(Delegate_Load).
  loadDetail: row =>
    set(state => {
      const language = useSessionStore.getState().session.langCd ?? '';
      const changeRequestNo = str(row[MASTER_USER_COLUMNS.CHANGE_REQ_NO]);
      const approval = str(row[MASTER_USER_COLUMNS.APPROVAL_USER]);
      const division = str(row[MASTER_USER_COLUMNS.DIVISION_ID]);
      state.selectedMasterRow = row;
      state.rejectReason = '';
      state.checkedIds = []; // 새 마스터행 → CHK 재초기화(page effect 가 status 기준 재세팅)
      state.filters = {
        ...get().filters,
        // 디테일 조회 — FindData_Sub. P_SSP0003_GET_REQ_DRAFTING 은 IN 2개뿐. 키는 PROC_M COL_NM
        //   실측(ora.py) 과 정확히 일치해야 한다: changeRequestNo(SORT_ORD 1) / language(2). BaseService.makeProcedure
        //   가 COL_NM 키로 값을 찾으므로 오타 키는 예외 없이 NULL 바인딩된다
        //   ([[generic-callproc-param-key-must-match-proc-m-colnm]], SSP0003-12). division/changeType 는 selectedMasterRow 로 참조.
        [SHEETS.SUB]: { changeRequestNo, language },
        // 위임자 조회 — Delegate_Load(division+approval). PROC_M COL_NM 실측: divisionId(1) / apploval(2, SP
        //   파라미터명 오타가 그대로 등재됨). apploval 로 보내야 승인자가 바인딩된다(SSP0003-13).
        //   반환 DELEGATEE_USER 로 승인/반려 판정.
        [SHEETS.DELEGATE]: { divisionId: division, apploval: approval },
      };
    }),
  clearDetail: () =>
    set(state => {
      state.selectedMasterRow = null;
      state.rejectReason = '';
      state.checkedIds = [];
      state.filters = { ...get().filters, [SHEETS.SUB]: undefined, [SHEETS.DELEGATE]: undefined };
    }),
  setRejectReason: v =>
    set(state => {
      state.rejectReason = v;
    }),
  setCheckedIds: ids =>
    set(state => {
      state.checkedIds = ids;
    }),
  toggleCheck: id =>
    set(state => {
      state.checkedIds = state.checkedIds.includes(id)
        ? state.checkedIds.filter(x => x !== id)
        : [...state.checkedIds, id];
    }),

  fetchStaticColumns: async () => {
    // 메인/서브 2 시트 컬럼메타 각각 fetch (design 03 §4). 미등록/실패 시 빈 배열 유지.
    for (const sheet of [SHEETS.MAIN, SHEETS.SUB] as const) {
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
    set(state => {
      state.initialized = true;
    });
  },

  // 개인화 조회조건 복원 (SubTitle F6 저장분 되불러오기, 1회) — 형제 화면 파리티.
  //   GET /admin/menu/{MENU_ID}/search-conditions → PRAM_NM/PRAM_CTN 을 searchCondition 에 역직렬화.
  //   배열키(divisionIds/fromSiteIds)만 콤마 split, 나머지는 그대로. 저장분 없으면 기본값 유지.
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
        if (!(paramNm in initSearch)) continue;
        const val = paramCtn ?? '';
        patch[paramNm] = ARRAY_KEYS.has(paramNm) ? (val ? val.split(',').filter(Boolean) : []) : val;
      }
      set(state => {
        state.searchCondition = { ...state.searchCondition, ...patch } as SearchCondition;
      });
    } catch {
      // 미저장/실패 = 기본값 유지 (console 금지)
    }
  },
}),
  'shipment-change-request-confirm-ssp0003-store'
);
