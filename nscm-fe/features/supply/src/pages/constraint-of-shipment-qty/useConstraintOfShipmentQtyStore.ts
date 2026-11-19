import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab } from '@shared/stores';

import {
  ADMIN_SHEET_NAME,
  MENU_ID,
  SHEETS,
  VALID_DEFAULT,
} from './constraint-of-shipment-qty.constants';
import type { SearchCondition } from './constraint-of-shipment-qty.types';
import { type SearchOptions, toSearchParam } from './utils/constraint-of-shipment-qty.cascadeCombo';

type FiltersBySheet = {
  [SHEETS.MAIN]?: ProcRequest<MENU_ID, SHEETS.MAIN>;
};

type StaticColumnsBySheet = {
  [SHEETS.MAIN]: RawFlexGridColumnConfig[];
};

interface State {
  initialized: boolean;
  // 개인화 조회조건 복원 1회 가드 (SubTitle F6 저장분 mount 복원 — initialized 는 컬럼 fetch 전용이라 별도).
  conditionsRestored: boolean;
  searchCondition: SearchCondition;
  filters: FiltersBySheet;
  openSearchArea: boolean;
  // ui-dynamic-property-management — admin SCM_MST_SHEET_COLUMNS 동적 fetch(실측 23행 등록됨, design 03 §1).
  staticColumns: StaticColumnsBySheet;
}

interface Action {
  reset: () => void;
  setSearchCondition: (p: Partial<SearchCondition>) => void;
  setDivision: (divisionId: string) => void;
  setFilter: (options: SearchOptions) => void;
  clearFilters: () => void;
  setOpenSearchArea: (open?: boolean) => void;
  fetchStaticColumns: () => Promise<void>;
  // 개인화 조회조건 복원 — GET /admin/menu/{MENU_ID}/search-conditions → searchCondition 패치(1회).
  restoreSearchConditions: () => Promise<void>;
  // Period 기본값 세팅 — AS-IS setPeriod() 파리티. fromDate/toDate 가 비어 있을 때만 채운다.
  setDefaultPeriod: () => void;
}

// 개인화 조건 복원 역직렬화 키(SubTitle F6 저장은 배열=콤마join·불리언=String 평문화 — personalizeCondition).
//   멀티셀렉트 5종(planGroup/fromSite/toSite/stage/modelGroup) = 콤마 결합 → split 역직렬화.
//   불리언 조회조건 없음.
//   Period(fromDate/toDate)는 저장 대상이 아니다(갭분석 C-11) — 화면이 F6 저장 조건에서 빼고, 이미 저장된
//   행이 남아 있어도 여기서 복원하지 않아 진입마다 AS-IS 기본 기간(setDefaultPeriod)이 적용된다.
const RESTORE_ARRAY_KEYS = new Set<string>([
  'planGroupIds',
  'fromSiteIds',
  'toSiteIds',
  'stageIds',
  'modelGroupIds',
]);

const RESTORE_EXCLUDED_KEYS = new Set<string>(['fromDate', 'toDate']);

const initSearch: SearchCondition = {
  divisionId: '',
  planGroupIds: [],
  fromSiteIds: [],
  toSiteIds: [],
  stageIds: [],
  modelGroupIds: [],
  itemId: '',
  fromDate: '',
  toDate: '',
  validYn: VALID_DEFAULT,
};

const toYyyymmdd = (d: Date): string =>
  `${d.getFullYear()}${String(d.getMonth() + 1).padStart(2, '0')}${String(d.getDate()).padStart(2, '0')}`;

// AS-IS setPeriod()(.cs:891~906) Period 기본값: From = 이번 주 월요일, To = 그 월요일 + 52주(364일).
//   C# DateTime.Today.AddDays(DayOfWeek.Monday - today.DayOfWeek) 와 동일 — JS getDay()도 일=0·월=1 이라
//   (1 - getDay()) 일을 더하면 이번 주 월요일이 된다(일요일이면 +1 = 바로 다음날 월요일, AS-IS 동일).
//   기본값은 화면 진입 시점 기준이어야 해서 모듈 상수가 아니라 호출 시 계산한다(persist 고정 방지).
const defaultPeriod = (): { fromDate: string; toDate: string } => {
  const today = new Date();
  const monday = new Date(today);
  monday.setDate(today.getDate() + (1 - today.getDay()));
  const to = new Date(monday);
  to.setDate(monday.getDate() + 52 * 7);
  return { fromDate: toYyyymmdd(monday), toDate: toYyyymmdd(to) };
};

const emptyStaticColumns: StaticColumnsBySheet = {
  [SHEETS.MAIN]: [],
};

const initState: State = {
  initialized: false,
  conditionsRestored: false,
  searchCondition: initSearch,
  filters: {},
  openSearchArea: true,
  staticColumns: emptyStaticColumns,
};

export const useConstraintOfShipmentQtyStore = createPersistedStoreWithTab<State & Action>(
  (set, get) => ({
    ...initState,
    reset: () => set(initState),
    setSearchCondition: p =>
      set(state => {
        state.searchCondition = { ...get().searchCondition, ...p };
      }),
    // Division 변경(싱글 콤보) = TO-BE 공통 요건: Division·기간(from/to)·Active 를 제외한 검색조건을 전부 초기화하고
    //   그리드도 초기화(filters clear)한다(사용자 지시 2026-10-02 — TO-BE 공통 요건이 AS-IS 핸들러보다 우선).
    //   Active 는 AS-IS 도 유지하고 표준도 「Div 변경 시 초기화 N」이다(.cs ClbDivision_SelectedIndexChanged, 갭분석 표-09).
    //   planGroup/fromSite/toSite/stage/modelGroup/item 은 initSearch 로 되돌린다.
    //   편집중(dirty) 확인 가드(MSG00704)는 Form 의 onChange 가 confirmIfDirtyKey 로 처리한다(commit 51d4e9fa 패턴).
    //   그리드는 itemsSource=rows(=filters 기반 쿼리)라 filters 를 비우면 신규행·미저장 편집이 함께 폐기된다(자매 SCP0131 동형).
    setDivision: divisionId =>
      set(state => {
        const cur = get().searchCondition;
        state.searchCondition = {
          ...initSearch, // Division·기간·Active 제외 전 조건 초기화(planGroup/fromSite/toSite/stage/modelGroup/item)
          divisionId,
          fromDate: cur.fromDate,
          toDate: cur.toDate,
          validYn: cur.validYn,
        };
        state.filters = {}; // 그리드 초기화 — 재조회(Search) 전까지 빈 상태
      }),
    // GET SP 파라미터 매핑(design 03 §4, SCP0132_GET_CONSTRAINT_OF_SHIPMENT_QTY 10 param):
    //   Division/PlanGroup/FromSite/ToSite/ModelGroupName/Item/Stage/FromDate/ToDate/ValidYn
    //   목록 전체 선택(SELECT ALL)은 빈 값으로 보낸다(AS-IS .cs:444~449, toSearchParam, 갭분석 C-05).
    setFilter: options => {
      set(state => {
        const c = state.searchCondition;
        state.filters = {
          [SHEETS.MAIN]: {
            divisionId: c.divisionId,
            planGroupId: toSearchParam(c.planGroupIds, options.planGroup),
            fromSiteId: toSearchParam(c.fromSiteIds, options.fromSite),
            toSiteId: toSearchParam(c.toSiteIds, options.toSite),
            modelGroupName: toSearchParam(c.modelGroupIds, options.modelGroup),
            itemId: c.itemId,
            stage: toSearchParam(c.stageIds, options.stage),
            fromDate: c.fromDate,
            toDate: c.toDate,
            // AS-IS .cs:452 pValidYn = sValidYn.Equals("ALL") ? string.Empty : sValidYn —
            //   콤보 ALL 선택(기본값)은 빈 문자열로 보내 Y/N 필터 없이 전건 조회한다.
            validYn: c.validYn === 'ALL' ? '' : c.validYn,
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

    // 개인화 조회조건 복원 (SubTitle F6 저장분 되불러오기, 1회) — 자매 SCP0053(scp-bom) 파리티.
    //   GET /admin/menu/{MENU_ID}/search-conditions → paramNm/paramCtn 역직렬화(배열 split).
    //   저장분 없거나 조회 실패면 기본값 유지. 저장은 EXCLUDED_DATE_PARAM·빈값 필터 후 재삽입이라
    //   (gridAction.ts personalizeCondition) 응답에 없는 키는 initSearch 기본값 그대로 둔다.
    //   주의: setDivision(cascade·Div/기간 외 전조건 초기화)·setFilter 경유 금지 — 직접 병합해야 복원값이 산다.
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
          if (!(paramNm in initSearch)) continue; // SearchCondition 필드만 allowlist
          if (RESTORE_EXCLUDED_KEYS.has(paramNm)) continue;
          const val = paramCtn ?? '';
          if (RESTORE_ARRAY_KEYS.has(paramNm))
            patch[paramNm] = val ? val.split(',').filter(Boolean) : [];
          else patch[paramNm] = val;
        }
        set(state => {
          state.searchCondition = { ...state.searchCondition, ...patch } as SearchCondition;
        });
      } catch {
        // 미저장/실패 = 기본값 유지 (console 금지 룰)
      }
    },

    // AS-IS setPeriod()(.cs:891~906, InitControls L194)는 persist 가 없어 진입마다 From/To 를 무조건 덮는다.
    //   TO-BE 는 persist + F6 개인화 복원이 fromDate/toDate 를 저장/복원할 수 있으므로(restoreSearchConditions),
    //   복원값이 있으면 그것을 존중하고 둘 다 비어 있을 때만 AS-IS 기본값(이번 주 월요일 ~ +52주)을 채운다.
    //   주의: restoreSearchConditions 이후에 호출해야 복원값을 덮지 않는다(ConstraintOfShipmentQty mount effect).
    setDefaultPeriod: () =>
      set(state => {
        const c = state.searchCondition;
        if (c.fromDate || c.toDate) return;
        const { fromDate, toDate } = defaultPeriod();
        state.searchCondition.fromDate = fromDate;
        state.searchCondition.toDate = toDate;
      }),
  }),
  'constraint-of-shipment-qty-store'
);
