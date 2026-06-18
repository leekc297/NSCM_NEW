import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab } from '@shared/stores';

import { BUCKET_TYPE, DIVISION, MENU_ID, SHEETS } from './mkt-forecast-master.constants';
import type { MeasureMeta, SearchCondition } from './mkt-forecast-master.types';

// Phase 7 격차 G1 — Search condition 저장/복원 (memory feedback_search_fields_catalog)
//   zustand persist 자동 동작 — createPersistedStoreWithTab 가 localStorage 'mkt-forecast-master-' key 로 저장
//   F6 (Condition) / F10 (Reset) SubTitle DefaultButtonActions 가 자동 활성

// SP filter payload — useTabProcQuery enabled 가드
type FiltersBySheet = {
  [SHEETS.MAIN]?: ProcRequest<MENU_ID, SHEETS.MAIN>;
};

// ⭐ master hook "UI 생성의 동적 속성관리" — Column / Measure 동적 fetch state
type StaticColumnsBySheet = { [key in SHEETS]: RawFlexGridColumnConfig[] };
type StaticMeasuresBySheet = { [key in SHEETS]: MeasureMeta[] };

interface State {
  initialized: boolean;
  filters: FiltersBySheet;
  searchCondition: SearchCondition;
  openSearchArea: boolean;
  // 사용자 명시 요구 (2026-06-07): Measure popup 에서 선택된 Measure 만 grid 표시
  //   AS-IS DMF0003_1_MktFcst.cs L4916 btnMeasure_Click + SCM_MST_TITLESET_USER (USER_INQUIRY_COLUMN_TYPE_CODE='M')
  //   AS-IS editable Measure = MKT_FCST 만 (MKT_FCST_RP 는 L1954 자동 setValue + L2909 SSP sync 색 표시 전용)
  //   default = ['MKT_FCST', 'MKT_FCST_RP'] — AS-IS Selected 기본 2개
  selectedMeasures: string[];
  // ⭐ master hook §2.3 / §5 — admin SYS0004 UI Category Setup 동적 메타
  staticColumns: StaticColumnsBySheet;
  staticMeasures: StaticMeasuresBySheet;
  // ⭐ grid-column-setting-popup-pattern.md (#58) — ColumnSettingModal OK 결과 저장.
  //   빈 array = default (모든 base 컬럼 visible). 값 있음 = list 에 포함된 컬럼만 표시.
  visibleBaseColumns: string[];
}

interface Action {
  reset: () => void;
  setSearchCondition: (p: Partial<SearchCondition>) => void;
  setFilter: () => void;
  setOpenSearchArea: (open?: boolean) => void;
  setSelectedMeasures: (measures: string[]) => void;
  fetchStaticColumns: () => Promise<void>;
  fetchStaticMeasures: () => Promise<void>;
  setVisibleBaseColumns: (names: string[]) => void;
}

// AS-IS Form_Load 기본값 (DMF0003_1_MktFcst.cs L318):
//   Division : 40 (Mobility & IT Battery) — Form_Load 후 cboDivision_SelectedIndexChanged 자동 firing
//   Period   : 오늘 ~ 90일 후 (AS-IS PR_GET_DAY_RANGE, 최대 3년 — MSG00164)
//   Bucket   : W (Weekly) — Div 40 default (8주 관리)
//   Lookup   : 모두 빈 값 (Project / Item / Owner)
//   Checkbox : 모두 false (AS / Qty / Cell / Color / Sum)
const yyyymmdd = (d: Date) => d.toISOString().slice(0, 10).replace(/-/g, '');
const today = yyyymmdd(new Date());
const ninetyDaysAhead = yyyymmdd(new Date(Date.now() + 90 * 24 * 3600 * 1000));

const initSearch: SearchCondition = {
  divisionId: DIVISION.MOBILITY,
  teamIds: [],
  endCustomers: [],
  bizTypes: [],
  scmSiteIds: [],
  plantSiteIds: [],
  itemTypes: [],
  ediSenders: [],
  startYyyymmdd: today,
  endYyyymmdd: ninetyDaysAhead,
  bucketType: BUCKET_TYPE.WEEKLY,
  projectCode: '',
  itemId: '',
  owner: '',
  asFromSite: false,
  qtyFilter: false,
  cellQty: false,
  colorYn: false,
  sumYn: false,
};

const emptyCols: StaticColumnsBySheet = Object.values(SHEETS).reduce((acc, k) => {
  (acc as Record<string, RawFlexGridColumnConfig[]>)[k] = [];
  return acc;
}, {} as StaticColumnsBySheet);

const emptyMeasures: StaticMeasuresBySheet = Object.values(SHEETS).reduce((acc, k) => {
  (acc as Record<string, MeasureMeta[]>)[k] = [];
  return acc;
}, {} as StaticMeasuresBySheet);

const initState: State = {
  initialized: false,
  filters: {},
  searchCondition: initSearch,
  openSearchArea: true,
  selectedMeasures: ['MKT_FCST', 'MKT_FCST_RP'],
  staticColumns: emptyCols,
  staticMeasures: emptyMeasures,
  visibleBaseColumns: [],
};

// SP DMF0003_GET_MKT_FCST_DATA — 22 IN parameter 매핑 (archive line 1546~1574):
//   multi-value 항목은 ^ 구분 join (teamIds/endCustomers/...), 비어있으면 'ALL'
//   sesUserId / mnuId / createdBy / userGroup / userDeptId / invalidExec : BE 자동 채움 (PROC_M COL_NM)
//   senderCode : Phase 6 (EDI Sender 다중)
export const useMktForecastMasterStore = createPersistedStoreWithTab<State & Action>(
  (set, get) => ({
    ...initState,
    reset: () => set(initState),
    setSearchCondition: p => set(state => {
      state.searchCondition = { ...get().searchCondition, ...p };
    }),
    setFilter: () => set(state => {
      const c = state.searchCondition;
      const j = (arr: string[]): string => (arr.length === 0 ? 'ALL' : arr.join('^'));
      state.filters = {
        [SHEETS.MAIN]: {
          divisionId:   c.divisionId,
          scmSiteId:    j(c.scmSiteIds),
          plantSiteId:  j(c.plantSiteIds),
          teamId:       j(c.teamIds),
          customer:     j(c.endCustomers),
          bizType:      j(c.bizTypes),
          // ⭐ SP body line 1014/1010 의 LIKE 패턴 (`'%' || token || '%'`) 통과 위해
          //   빈 시 '%' wildcard (split → ['%'] → LIKE '%%%' 모든 row 매치).
          //   'ALL' 보내면 ITEM_ID LIKE '%ALL%' = 0 row → GT_SITE_ITEM_ALL 0 → 메인 cursor 0.
          projectCode:  c.projectCode || '%',
          itemId:       c.itemId || '%',
          fromYyyymmdd: c.startYyyymmdd,
          toYyyymmdd:   c.endYyyymmdd,
          itemType:     j(c.itemTypes),
          // ⭐ SP body line 1055-1057 의 `P_OWNER IS NULL OR P_OWNER = ''` 첫 절 통과 위해
          //   빈 시 '' (NULL 동등). 'ALL' 보내면 F.OWNER IN ('ALL') = 0 row.
          owner:        c.owner || '',
          qtyYn:        c.qtyFilter ? 'Y' : 'N',
          cellYn:       c.cellQty ? 'Y' : 'N',
          asYn:         c.asFromSite ? 'Y' : 'N',
          senderCode:   j(c.ediSenders),
        } as never,
      };
    }),
    setOpenSearchArea: open => set(state => {
      state.openSearchArea = open ?? !state.openSearchArea;
    }),
    setSelectedMeasures: measures => set(state => {
      state.selectedMeasures = measures;
    }),

    // ⭐ master hook §2.3 / child hook ui-category-setup-column-meta §2.2 —
    //   admin SYS0004 UI Category Setup `SCM_MST_SHEET_COLUMNS` 변경 즉시 반영.
    //   mount + Search 시 호출 (admin 변경 + division 변경 cross-reflect).
    fetchStaticColumns: async () => {
      try {
        const sheets: SHEETS[] = [SHEETS.MAIN];
        const responses = await Promise.all(
          sheets.map(sheetNm =>
            apiClient.post<RawFlexGridColumnConfig[]>(`/admin/menu/${MENU_ID}/column`, { sheetNm }),
          ),
        );
        set(state => {
          sheets.forEach((s, i) => { state.staticColumns[s] = responses[i].data.result ?? []; });
        });
      } catch (e) {
        // BE 메타 미등록 시 fallback (MAIN_COLUMNS 하드코딩) — 화면 작동 보장
        // master hook §8 anti-pattern 5.4 회피 — 빈 결과는 fallback 트리거
        console.warn('[DMF0003] fetchStaticColumns failed', e);
      }
    },

    // ⭐ master hook §5 / child hook ui-category-setup-column-meta §8 —
    //   admin SYS0004 UI Category Setup Measure 탭 `SCM_MST_SHEET_MEASURE` 변경 즉시 반영.
    //   PIVOT 화면 (DMF0003 main grid + MeasureSelectModal) 의무.
    fetchStaticMeasures: async () => {
      try {
        const sheets: SHEETS[] = [SHEETS.MAIN];
        const responses = await Promise.all(
          sheets.map(sheetNm =>
            apiClient.post<MeasureMeta[]>(`/admin/menu/${MENU_ID}/measure`, { sheetNm }),
          ),
        );
        set(state => {
          sheets.forEach((s, i) => { state.staticMeasures[s] = responses[i].data.result ?? []; });
        });
      } catch (e) {
        console.warn('[DMF0003] fetchStaticMeasures failed', e);
      }
    },
    // ⭐ grid-column-setting-popup-pattern.md (#58) §1.1 — ColumnSettingModal OK 결과 저장.
    setVisibleBaseColumns: names =>
      set(state => {
        state.visibleBaseColumns = names;
      }),
  }),
  'mkt-forecast-master',
);
