import { apiClient } from '@foundation/apis';
import dayjs from '@foundation/dayjs';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab, useSessionStore } from '@shared/stores';

import {
  ADMIN_SHEET_NAME,
  ALL,
  DEFAULT_CHANGE_TYPE,
  DEFAULT_STATUS,
  FIXED_DIVISION,
  MASTER_USER_COLUMNS,
  MENU_ID,
  PERIOD_OFFSET_DAY,
  SHEETS,
} from './shipment-change-request-confirm.constants';
import type { SearchCondition } from './shipment-change-request-confirm.types';

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
  // 개인화 조회조건 복원 1회 가드 — `initialized`(컬럼메타 축)와 분리한다. 컬럼메타는 매 mount 마다
  //   refetch 하므로 그 플래그에 얹으면 복원이 재실행되어 사용자가 바꾼 조건을 덮는다.
  conditionsRestored: boolean;
  searchCondition: SearchCondition;
  filters: FiltersBySheet;
  openSearchArea: boolean;
  // 마스터 더블클릭 행 — 액션버튼 Visibility(userId 비교) + changeType(컬럼분기) 판정 원천.
  selectedMasterRow: Record<string, unknown> | null;
  // 반려/자기반려 사유(디테일 폼 유일 입력 필드, B4).
  rejectReason: string;
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
  // 마스터 더블클릭 -> 디테일/위임자 조회 + 선택행 세팅(B1/A8).
  loadDetail: (row: Record<string, unknown>) => void;
  clearDetail: () => void;
  setRejectReason: (v: string) => void;
  fetchStaticColumns: () => Promise<void>;
  // 개인화 조회조건 복원 — GET /admin/menu/{MENU_ID}/search-conditions → searchCondition 패치(1회).
  restoreSearchConditions: () => Promise<void>;
}

// 복원 시 배열로 역직렬화할 키 — SubTitle F6 저장(gridAction.personalizeCondition)이 배열을 콤마 join
//   평문으로 눕히기 때문이다. 이 화면에서 배열인 조회조건은 fromSiteIds 뿐이다
//   (divisionId 는 '40' 고정 단일 — 자매 SSP0003 의 divisionIds 와 다르다).
const ARRAY_KEYS = new Set<string>(['fromSiteIds']);

const initSearch: SearchCondition = {
  divisionId: FIXED_DIVISION, // C1 고정 '40'
  fromSiteIds: [],
  status: DEFAULT_STATUS, // 'Q'
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
  staticColumns: emptyStaticColumns,
};

// design 02 §2.5: Period 기본 = D-14 (from=오늘-14, to=오늘).
//   주의: AS-IS 는 SCM0001_GET_SCP_DAY_PERIOD(offset -14, 타임존/영업일 반영) 서버계산 — TO-BE 는
//     클라 근사(dayjs, 자매 SSP0201 동일 패턴). 정밀 영업일 계산은 convert-sp(SP 배포) 후 대조.
const defaultPeriod = (): { from: string; to: string } => {
  const to = dayjs();
  return { from: to.subtract(PERIOD_OFFSET_DAY, 'day').format('YYYYMMDD'), to: to.format('YYYYMMDD') };
};

// 다중/다건 -> SP 파라미터 문자열. ALL/빈값 = '' (전체, GET SP TRIM 무시).
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

const str = (v: unknown): string =>
  typeof v === 'string' ? v : typeof v === 'number' ? String(v) : '';

export const useShipmentChangeRequestConfirmStore = createPersistedStoreWithTab<State & Action>(
  (set, get) => ({
    ...initState,
    // F10(조회조건 초기화) 전용 — MotherStore.resetSearchCondition 이 이 reset() 을 부른다.
    //   자매 SSP0201 / SSP0005(0a2b7512) 과 동일 규약:
    //   · 조회된 그리드(filters)는 비우지 않는다 — 조회조건만 초기화하고 조회 데이터는 유지한다.
    //     (종전 `set(initState)` 는 filters 까지 날려 F10 이 그리드까지 비웠다.)
    //   · staticColumns/initialized 는 MotherStore 가 별도 보존하나, reset() 단독 호출 대비 함께 유지한다.
    //   · Period 는 initSearch 에서 ''이므로 삭제만 되지 않도록 기본값(D-14)을 재산출한다.
    reset: () => {
      const { filters, staticColumns, initialized } = get();
      set({ ...initState, filters, staticColumns, initialized });
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
    initPeriodDefault: () =>
      set(state => {
        const { from, to } = defaultPeriod();
        state.searchCondition.fromYyyymmdd = from;
        state.searchCondition.toYyyymmdd = to;
      }),
    setFilter: () => {
      set(state => {
        const c = state.searchCondition;
        // GET SP SSP0202_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM(메인) 9 파라미터 (design 02 §5):
        //   p_division_id / p_from_site / p_request_id / p_from_yyyymmdd / p_to_yyyymmdd /
        //   p_status / p_language / p_item_id / p_change_type
        const language = useSessionStore.getState().session.langCd ?? '';
        state.filters = {
          [SHEETS.MAIN]: {
            divisionId: c.divisionId, // p_division_id ('40')
            fromSite: joinOrEmpty(c.fromSiteIds), // p_from_site
            requestId: multiLine(c.requestId), // p_request_id (Requestor)
            fromYyyymmdd: c.fromYyyymmdd, // p_from_yyyymmdd
            toYyyymmdd: c.toYyyymmdd, // p_to_yyyymmdd
            status: oneOrEmpty(c.status), // p_status
            language, // p_language (@sesLangCd)
            itemId: multiLine(c.itemId), // p_item_id
            changeType: oneOrEmpty(c.changeType), // p_change_type
          },
        };
        // 조회 시 디테일 폼/그리드/위임자/선택행 초기화 (B2/B3).
        state.selectedMasterRow = null;
        state.rejectReason = '';
      });
    },
    clearFilters: () =>
      set(state => {
        state.filters = { [SHEETS.MAIN]: undefined };
        state.selectedMasterRow = null;
        state.rejectReason = '';
      }),
    setOpenSearchArea: open =>
      set(state => {
        state.openSearchArea = open ?? !state.openSearchArea;
      }),
    // 마스터 더블클릭 -> 디테일 GET(FindData_Sub, Tables[0]=그리드/Tables[1]=폼) + 위임자 GET(Delegate_Load).
    loadDetail: row =>
      set(state => {
        const language = useSessionStore.getState().session.langCd ?? '';
        const changeReqNo = str(row[MASTER_USER_COLUMNS.CHANGE_REQ_NO]);
        const approval = str(row[MASTER_USER_COLUMNS.APPROVAL_USER]);
        const division = str(row.DIVISION_ID) || get().searchCondition.divisionId;
        const changeType = str(row[MASTER_USER_COLUMNS.CHANGE_TYPE]);
        state.selectedMasterRow = row;
        state.rejectReason = '';
        state.filters = {
          ...get().filters,
          // 디테일 조회 — FindData_Sub. p_change_req_no/p_division_id/p_change_type/p_language.
          [SHEETS.SUB]: { changeReqNo, divisionId: division, changeType, language },
          // 위임자 조회 — Delegate_Load(division+approval). 반환 DELEGATEE_USER 로 A1/A7 판정.
          [SHEETS.DELEGATE]: { divisionId: division, approvalUser: approval },
        };
      }),
    clearDetail: () =>
      set(state => {
        state.selectedMasterRow = null;
        state.rejectReason = '';
        state.filters = { ...get().filters, [SHEETS.SUB]: undefined, [SHEETS.DELEGATE]: undefined };
      }),
    setRejectReason: v =>
      set(state => {
        state.rejectReason = v;
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

    // 개인화 조회조건 복원 (SubTitle F6 저장분 되불러오기, 1회) — 자매 SSP0003 과 동일 구현.
    //   GET /admin/menu/{MENU_ID}/search-conditions → PRAM_NM/PRAM_CTN(BE 가 paramNm/paramCtn 으로
    //   매핑) 을 searchCondition 에 역직렬화. 배열키만 콤마 split, 나머지는 그대로.
    //   주의: 저장(gridAction.personalizeCondition)은 **날짜 파라미터와 빈값을 제외**하므로
    //   기간은 복원 대상이 아니다 — 기간은 mount 의 initPeriodDefault 기본값을 그대로 쓴다.
    //   저장분이 없거나 실패하면 기본값을 유지한다(조용히 넘어간다).
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
          // 저장 당시와 조회조건 스키마가 달라졌을 수 있다 — 현재 키만 받는다.
          if (!(paramNm in initSearch)) continue;
          const val = paramCtn ?? '';
          patch[paramNm] = ARRAY_KEYS.has(paramNm)
            ? val
              ? val.split(',').filter(Boolean)
              : []
            : val;
        }
        set(state => {
          state.searchCondition = { ...state.searchCondition, ...patch } as SearchCondition;
        });
      } catch {
        // 미저장/실패 = 기본값 유지 (console 금지)
      }
    },
  }),
  'shipment-change-request-confirm-store'
);
