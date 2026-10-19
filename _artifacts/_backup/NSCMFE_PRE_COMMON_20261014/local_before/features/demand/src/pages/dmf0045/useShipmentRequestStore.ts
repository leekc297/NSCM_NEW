import { apiClient } from '@foundation/apis';
import dayjs from '@foundation/dayjs';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab, useSessionStore } from '@shared/stores';

import {
  BUCKET_TYPE,
  MENU_ID,
  PERIOD_DEFAULT_DAYS,
  SHEETS,
  TITLESET_COLUMN_TYPE,
} from './dmf0045.constants';
import type { ActiveSheet, SearchCondition } from './dmf0045.types';
import type { PlantSiteSource, SearchComboTrigger } from './utils/dmf0045.searchCombos';

// GET_SHIPMENT_REQUEST payload (PKG_DMF0045.P_DMF0045_GET_SHIPMENT_REQUEST 11 IN — ora.py 실측 2026-09-26).
//   P_CREATED_BY(11) 는 BE 세션 자동주입 — request 미포함. positional 매핑은 SCM_ADM_PROC_M.COL_NM 기준.
//   화면이 procedures.d.ts 미등재(Base index-signature fallback)라 ProcRequest 가 느슨해진다 —
//   payload 구조를 명시 타입으로 고정해 SP 계약을 코드에서 자기문서화한다(memory procedures-dts-base).
// type alias(인터페이스 아님) — ProcRequest Base fallback = Record<string, JsonPrimitive> 에
//   대입 가능하려면 암시적 index signature 가 필요하다. interface 는 이를 갖지 않아 대입 실패한다.
type GetShipmentRequestFilter = {
  sheetName: string; // 1  P_SHEET_NAME (Pack Biz / Cell Biz)
  divisionId: string; // 2  P_DIVISION_ID
  teamId: string; // 3  P_TEAM_ID (Team, 콤마 delim / 'ALL')
  customer: string; // 4  P_CUSTOMER (End Customer)
  scmSiteId: string; // 5  P_SCM_SITE_ID (Sales Site)
  plantSiteId: string; // 6  P_PLANT_SITE_ID (Plant Site)
  projectCode: string; // 7  P_PROJECT_CODE (팝업 raw, 빈값 '')
  itemId: string; // 8  P_ITEM_ID (Model/Item, 팝업 raw)
  fromYyyymmdd: string; // 9  P_FROM_YYYYMMDD
  toYyyymmdd: string; // 10 P_TO_YYYYMMDD
}

// GET_SPREAD_TITLE payload (P_DMF0045_GET_SPREAD_TITLE 5 IN — P_CREATED_BY(3) BE 주입).
//   조회(setFilter)와 버킷 전환(setBucketType)이 같은 규칙으로 만들어야 헤더 기간 구조가 갈라지지 않는다.
type GetSpreadTitleFilter = {
  startYyyymmdd: string; // 1  P_START_DT
  endYyyymmdd: string; // 2  P_END_DT
  sheetName: string; // 4  P_SHEET_NAME
  divisionId: string; // 5  P_DIVISION_ID
}

// setFilter 결과 payload — useTabProcQuery enabled 가드. 활성 시트(Pack/Cell)와 spreadTitle 동시 보유.
//   활성 시트가 Pack↔Cell 로 바뀌면 sheetName 이 갱신되며 새 queryKey 로 재조회된다.
type FiltersBySheet = {
  data?: GetShipmentRequestFilter;
  [SHEETS.SPREAD_TITLE]?: GetSpreadTitleFilter;
};

// SCM_MST_SHEET_MEASURE 동적 fetch row — /admin/menu/{MENU_ID}/measure (BE GridMeasure camelCase 직렬화.
//   DMF0003 사고 계보: UPPER_SNAKE 가정 금지 — colNm/colLblNm/sClsLblNm/personalizable/display).
export interface MeasureMeta {
  colNm: string;
  colLblNm?: string;
  sClsLblNm?: string;
  lClsLblNm?: string;
  personalizable?: boolean;
  display?: boolean;
}

/** ColumnLayoutModal 개인화 1행 — 표시/순서/폭/색 (sales-plan 동형). */
export interface ColumnLayoutSetting {
  colNm: string;
  visible: boolean;
  width: number;
  cellColor: string;
  textColor: string;
  order: number;
}

interface State {
  initialized: boolean;
  filters: FiltersBySheet;
  searchCondition: SearchCondition;
  // 활성 시트(Pack Biz / Cell Biz) — 조회·컬럼메타·measure·팝업 sBizType 스코프.
  //   AS-IS 는 시트 탭 전환이 곧 재조회 대상 시트 변경이다(design 01 §1 spdMain 2시트).
  activeSheet: ActiveSheet;
  // 조회조건 콤보를 다시 만든 계기 — cascade 축 판정용(utils/dmf0045.searchCombos 참조).
  //   searchCondition 밖에 두는 이유: setFilter 가 조회조건을 SP 파라미터로 옮겨 담으므로
  //   화면 상태가 payload 로 새어 나가면 안 된다(sales-plan 선례).
  comboTrigger: SearchComboTrigger;
  // Plant Site 원천 — 진입은 고객 기준, Division 을 한 번이라도 바꾸면 사업부 기준으로 굳는다.
  plantSiteSource: PlantSiteSource;
  openSearchArea: boolean;
  staticColumns: RawFlexGridColumnConfig[];
  // 개인화 적용 전 admin 메타 원본 — 팝업 Default 버튼의 원복 기준.
  originalStaticColumns: RawFlexGridColumnConfig[];
  // ColumnLayoutModal OK 결과 (null = 미설정) — 표시/순서 + 폭/색.
  //   fetchStaticColumns 는 mount/Search/division/시트 변경마다 admin 메타를 다시 덮으므로, 이 값으로
  //   재적용하지 않으면 컬럼 설정 직후 조회 한 번에 개인화가 통째로 원복된다(sales-plan 선례).
  userColumnLayout: ColumnLayoutSetting[] | null;
  staticMeasures: MeasureMeta[];
  // MeasureSelectModal 선택 measure(표시 대상). null = 미설정(전체 표시).
  visibleMeasures: string[] | null;
}

interface Action {
  reset: () => void;
  setSearchCondition: (p: Partial<SearchCondition>, comboTrigger?: SearchComboTrigger) => void;
  setActiveSheet: (sheet: ActiveSheet) => void;
  setFilter: () => void;
  clearFilters: () => void;
  // Bucket 전환 — AS-IS cboBucketType_SelectedIndexChanged. 조회조건 bucketType 만 바꾼다.
  //   Insert/변경분 존재 시 전환 차단(MSG00227)은 그리드 상태를 아는 컴포넌트 책임 — store 는 값만 스왑.
  setBucketType: (bucketType: BUCKET_TYPE) => void;
  setOpenSearchArea: (open?: boolean) => void;
  fetchStaticColumns: () => Promise<void>;
  fetchStaticMeasures: () => Promise<void>;
  /** ColumnLayoutModal onSave — 표시/순서/width/색상을 staticColumns 에 즉시 반영 (영구 저장은 titleSet SAVE 별도). */
  applyColumnLayout: (settings: ColumnLayoutSetting[]) => void;
  /** 저장된 컬럼 개인화(titleSet) 복원 — fetchStaticColumns 가 await 후 메타에 적용. */
  fetchUserColumnLayout: () => Promise<ColumnLayoutSetting[] | null>;
  /**
   * 컬럼 개인화 무효화 — division/시트 전환 시 필수.
   *
   * 주의: SCM_MST_TITLESET_USER 에는 division 컬럼이 없어 개인화가 division 무관 1벌인데,
   *   컬럼 세트는 division·시트별로 다르다(SP 서버 필터). 이전 레이아웃을 새 컬럼에 적용하면
   *   "목록에 없는 컬럼 = 비표시" 규칙 때문에 전 컬럼이 사라진다(sales-plan 선례).
   */
  clearUserColumnLayout: () => void;
  // MeasureSelectModal onSave — 표시할 measure 코드 목록 적용 (null = 전체).
  applyVisibleMeasures: (measureCodes: string[] | null) => void;
}

// BE 가 폭을 안 내려줄 때의 기본 폭 (ColumnLayoutModal DEFAULT_COL_WIDTH 와 동일 계약).
const DEFAULT_COL_WIDTH = 100;

// ColumnLayoutModal 개인화 override — 표시/순서/폭/색을 admin 메타 위에 덧씌운다(sales-plan applyLayoutToColumns 동형).
//   주의: 표시 게이트는 `display` 만 건드린다 — VISIBLE_FLAG(관리 노출)은 사용자 조작으로 덮지 않는다.
//   주의: 개인화는 비표시 컬럼(visible:false)까지 전부 담고 있어야 한다 — 표시분만 담으면
//     '미등록 = admin 기본값' 분기가 사용자가 끈 컬럼을 되살린다.
const applyLayoutToColumns = (
  cols: RawFlexGridColumnConfig[],
  settings: ColumnLayoutSetting[]
): RawFlexGridColumnConfig[] => {
  const byCol = new Map(settings.map(s => [s.colNm, s]));
  return cols
    .map(c => {
      const s = byCol.get(c.colNm);
      // 개인화에 없는 컬럼 = 개인화 저장 이후 admin 메타에 추가된 컬럼 — 관리자 기본값(DEFAULT_FLAG)
      //   을 그대로 따른다. 여기서 display:false 로 죽이면 기존 사용자에게 신규 컬럼이 영원히 안 보인다.
      if (!s) return c;
      return {
        ...c,
        display: s.visible,
        colWth: s.width || DEFAULT_COL_WIDTH,
        cellColor: s.cellColor,
        textColor: s.textColor,
      };
    })
    // 팝업 순서대로 재정렬 — grid 는 배열 순서를 컬럼 순서로 사용. 미매칭 컬럼은 뒤로.
    .sort(
      (a, b) =>
        (byCol.get(a.colNm)?.order ?? Number.MAX_SAFE_INTEGER) -
        (byCol.get(b.colNm)?.order ?? Number.MAX_SAFE_INTEGER)
    );
};

// 조회 기간 기본값 — 오늘 ~ 오늘+55일(8주). drpPeriod readOnly (design 02 §4, cs:229).
//   Division/Team 변경 시에는 리셋하지 않는다 — 사용자가 지정한 기간 유지(sales-plan 선례).
const SHIPMENT_INIT_PERIOD = {
  start: dayjs().format('YYYYMMDD'),
  end: dayjs().add(PERIOD_DEFAULT_DAYS, 'day').format('YYYYMMDD'),
};
const { start: todayYyyymmdd, end: plus55Yyyymmdd } = SHIPMENT_INIT_PERIOD;

const initSearch: SearchCondition = {
  // 빈 값으로 시작 — 화면(ShipmentRequest.tsx)의 division 자동선택 effect 가 세션/콤보 데이터로 채운다
  //   (sales-plan/DMF0003/DMF0020 정본과 동일).
  divisionId: '',
  deptIds: [],
  endCustomers: [],
  scmSiteIds: [],
  plantSiteIds: [],
  projectCodes: [],
  itemIds: [],
  startYyyymmdd: todayYyyymmdd,
  endYyyymmdd: plus55Yyyymmdd,
  bucketType: BUCKET_TYPE.DAILY, // 기본 Daily (AS-IS OnShown cs:179 — design 02 §4)
  sumYn: false, // AS-IS chkSum uncheck (상위 버킷 합계 컬럼 표시 토글)
};

// GET_SPREAD_TITLE payload — 조회(setFilter)와 버킷 전환(setBucketType)이 같은 규칙으로 만든다.
const buildSpreadTitleFilter = (c: SearchCondition, sheet: ActiveSheet): GetSpreadTitleFilter => ({
  startYyyymmdd: c.startYyyymmdd,
  endYyyymmdd: c.endYyyymmdd,
  sheetName: sheet,
  divisionId: c.divisionId,
});

const initState: State = {
  initialized: false,
  filters: {},
  searchCondition: initSearch,
  activeSheet: SHEETS.PACK,
  comboTrigger: 'entry',
  plantSiteSource: 'entry',
  openSearchArea: true,
  staticColumns: [],
  originalStaticColumns: [],
  userColumnLayout: null,
  staticMeasures: [],
  visibleMeasures: null,
};

// 멀티선택 콤보 = 콤마 delim (AS-IS CheckedList ControlValues 1:1). 빈 배열 = 'ALL' sentinel.
const j = (arr?: string[]): string => (!arr || arr.length === 0 ? 'ALL' : arr.join(','));
// 텍스트+팝업 필드(Project/Model) = raw 텍스트, 빈값 '' (AS-IS txt*.Text 1:1).
const raw = (arr?: string[]): string => (!arr || arr.length === 0 ? '' : arr.join(','));

export const useShipmentRequestStore = createPersistedStoreWithTab<State & Action>(
  (set, get) => ({
    ...initState,
    reset: () =>
      set(state => {
        const staticMeasures = state.staticMeasures;
        Object.assign(state, initState);
        state.staticMeasures = staticMeasures;
      }),
    setSearchCondition: (p, comboTrigger) =>
      set(state => {
        state.searchCondition = { ...get().searchCondition, ...p };
        if (comboTrigger) state.comboTrigger = comboTrigger;
        // Plant Site 원천은 Division 을 바꾼 뒤로 고정 — AS-IS 는 Team·End Customer 변경 핸들러에서
        //   Plant Site 를 다시 만들지 않으므로 직전 목록이 그대로 남는다(sales-plan 선례).
        if (comboTrigger === 'division') state.plantSiteSource = 'division';
      }),
    // 시트 탭 전환(Pack Biz ↔ Cell Biz) — 활성 시트 변경 시 컬럼/measure/조회 대상이 함께 바뀐다.
    //   filters 는 clear 하지 않는다 — 재조회는 Search 로만(초기화 규약). 진입 후 fetchStaticColumns/
    //   fetchStaticMeasures 를 화면에서 다시 호출해 새 시트 메타를 덮는다.
    setActiveSheet: sheet =>
      set(state => {
        if (state.activeSheet === sheet) return;
        state.activeSheet = sheet;
      }),
    setFilter: () => {
      // BE makeProcedure(BaseService) 가 SCM_ADM_PROC_M.COL_NM 기준 positional 매핑.
      //   P_CREATED_BY(GET 11 / SPREAD_TITLE 3)는 BE 세션 자동주입 — request 미포함.
      const session = useSessionStore.getState().session;
      // sesUserId 는 BE 주입이라 payload 미포함 — 세션 참조는 향후 권한 파라미터 확장 지점 표식.
      void session;
      set(state => {
        // persist(sessionStorage) rehydrate 가 구버전 shape 일 수 있어 기본값 머지로 완전한 조회조건 보장
        //   (누락 필드 → SP NULL payload → ORA 사고 차단. sales-plan 선례).
        const c: SearchCondition = { ...initSearch, ...state.searchCondition };
        const sheet = state.activeSheet;
        state.filters = {
          // ── P_DMF0045_GET_SHIPMENT_REQUEST (11 IN, P_CREATED_BY BE주입) ──
          data: {
            sheetName: sheet, // 1
            divisionId: c.divisionId, // 2
            teamId: j(c.deptIds), // 3  Team
            customer: j(c.endCustomers), // 4  End Customer
            scmSiteId: j(c.scmSiteIds), // 5  Sales Site
            plantSiteId: j(c.plantSiteIds), // 6  Plant Site (40 비활성 'ALL')
            projectCode: raw(c.projectCodes), // 7  (40 비활성 '')
            itemId: raw(c.itemIds), // 8  Model/Item
            fromYyyymmdd: c.startYyyymmdd, // 9
            toYyyymmdd: c.endYyyymmdd, // 10
          },
          // ── P_DMF0045_GET_SPREAD_TITLE (5 IN — sesUserId BE주입) ──
          [SHEETS.SPREAD_TITLE]: buildSpreadTitleFilter(c, sheet),
        };
      });
    },

    setBucketType: bucketType =>
      set(state => {
        if (state.searchCondition.bucketType === bucketType) return;
        state.searchCondition = { ...state.searchCondition, bucketType };
        // AS-IS cboBucketType_SelectedIndexChanged — 조회 없이 D/W/M 컬럼 표시 전환.
        //   조회해 둔 데이터를 유지한 채 SPREAD_TITLE 만 새 queryKey 로 재조회(헤더 기간 구조 갱신).
        //   미조회 상태(SPREAD_TITLE 미보유)면 그릴 헤더가 없으므로 건드리지 않는다.
        if (state.filters[SHEETS.SPREAD_TITLE]) {
          state.filters[SHEETS.SPREAD_TITLE] = buildSpreadTitleFilter(
            { ...initSearch, ...state.searchCondition },
            state.activeSheet
          );
        }
      }),
    // mount 시 sessionStorage 의 이전 filters cache 무효화 — incomplete payload 재사용 회피.
    clearFilters: () =>
      set(state => {
        state.filters = {};
      }),
    setOpenSearchArea: open =>
      set(state => {
        state.openSearchArea = open ?? !state.openSearchArea;
      }),

    // master hook §2.3 "UI 생성의 동적 속성관리" — Column 동적 fetch (SHEET_COLUMNS, division 서버 필터).
    //   admin 변경 즉시 반영 (mount + Search + division 변경 + 시트 전환 시 호출). 하드코딩 fallback 없음.
    fetchStaticColumns: async () => {
      try {
        // 진입 시 개인화 복원 — 저장된 titleSet 을 먼저 조회해 override 확보 후 메타에 적용.
        //   이미 있으면(모달 OK 직후 재조회) 서버 재조회 없이 그 값을 유지(sales-plan 선례).
        if (get().userColumnLayout === null) await get().fetchUserColumnLayout();

        const result = await apiClient.post<RawFlexGridColumnConfig[]>(
          `/admin/menu/${MENU_ID}/column`,
          {
            sheetNm: get().activeSheet, // 활성 시트(Pack Biz / Cell Biz) — 등록명 그대로 (룰 #91)
            divisionId: get().searchCondition.divisionId,
          }
        );
        set(state => {
          const fetched = result.data.result ?? [];
          // 개인화 적용 전 원본 보관 — 팝업 Default 원복 기준(개인화로 덮이지 않는다).
          state.originalStaticColumns = fetched;
          // 컬럼 설정(OK) 이후 재조회(Search/division/시트 변경)가 개인화를 덮지 않도록 override 재적용.
          const layout = get().userColumnLayout;
          state.staticColumns =
            layout && layout.length > 0 ? applyLayoutToColumns(fetched, layout) : fetched;
        });

        if (get().initialized) return;
        set(state => {
          state.initialized = true;
        });
      } catch {
        // BE 메타 미응답 시 silent — 빈 배열 유지 (console 금지 룰)
      }
    },

    // master hook §5 — Measure 동적 fetch (SHEET_MEASURE — Measure Select 팝업 대상)
    fetchStaticMeasures: async () => {
      try {
        const result = await apiClient.post<MeasureMeta[]>(`/admin/menu/${MENU_ID}/measure`, {
          sheetNm: get().activeSheet,
          divisionId: get().searchCondition.divisionId,
        });
        set(state => {
          state.staticMeasures = result.data.result ?? [];
        });
      } catch {
        // silent — 메타 미응답 시 빈 목록 유지 (하드코딩 fallback 금지)
      }
    },

    // 저장된 컬럼 개인화 복원 — ColumnLayoutModal 이 쓰는 SP 와 동일 계약(DMF0002_GET_TITLESET_POPUP).
    //   조회 키(sheetName/columnType)는 팝업·저장과 반드시 같아야 한다. SP 는 관리자 기본값과
    //   사용자값(USER_* 별칭)을 따로 내려주며, 사용자값을 우선하지 않으면 저장 폭/순서가 안 보인다.
    fetchUserColumnLayout: async () => {
      try {
        const res = await apiClient.post<{ o_rc1?: Record<string, string>[] }>(
          `${MENU_ID}/titleSet/SEARCH/call-proc`,
          {
            programId: MENU_ID,
            sheetName: get().activeSheet,
            columnType: TITLESET_COLUMN_TYPE,
            divisionId: get().searchCondition.divisionId,
          }
        );
        const rows = res.data.result?.o_rc1 ?? [];
        const orderOf = (r: Record<string, string>): number =>
          Number(r.USER_SORT_ORDER_NO ?? r.SORT_ORDER_NO ?? 0);
        // 표시 여부 = 사용자 저장값(USER_FLAG) 우선, 없으면 관리자 기본값(DEFAULT_FLAG).
        //   VISIBLE_FLAG 는 폴백으로 쓰지 않는다(관리 노출 여부라 기본 미표시 컬럼까지 켜진다).
        const isShown = (r: Record<string, string>): boolean =>
          String(r.USER_FLAG ?? r.DEFAULT_FLAG ?? 'Y')
            .trim()
            .toUpperCase() === 'Y';
        const toSetting = (
          r: Record<string, string>,
          order: number,
          visible: boolean
        ): ColumnLayoutSetting => {
          const width = Number(r.USER_COLUMN_WIDTH ?? r.COLUMN_WIDTH ?? 0);
          return {
            colNm: String(r.COLUMN_NAME ?? ''),
            visible,
            width: Number.isFinite(width) && width > 0 ? width : DEFAULT_COL_WIDTH,
            cellColor: String(r.CELL_COLOR ?? ''),
            textColor: String(r.TEXT_COLOR ?? ''),
            order,
          };
        };
        const shown = rows
          .filter(isShown)
          .sort((a, b) => orderOf(a) - orderOf(b))
          .map((r, i) => toSetting(r, i + 1, true))
          .filter(s => s.colNm);
        // 비표시 컬럼도 함께 보관 — applyLayoutToColumns 는 '개인화에 없는 컬럼 = admin 기본값'
        //   이므로, 빠뜨리면 사용자가 끈 컬럼이 재조회마다 되살아난다.
        const hidden = rows
          .filter(r => !isShown(r))
          .map(r => toSetting(r, Number.MAX_SAFE_INTEGER, false))
          .filter(s => s.colNm);
        // 표시 컬럼이 하나도 없으면 개인화 없음으로 본다 — admin 메타 그대로 두어 빈 그리드 방지.
        if (shown.length === 0) return null;
        const layout = [...shown, ...hidden];
        set(state => {
          state.userColumnLayout = layout;
          // 메타가 이미 도착해 있으면 소급 적용(호출 순서 무관하게 개인화 유실 방지).
          if (state.staticColumns.length > 0) {
            state.staticColumns = applyLayoutToColumns(state.staticColumns, layout);
          }
        });
        return layout;
      } catch {
        // 개인화 조회 실패 = 기본 컬럼 세트로 동작(화면 차단 금지, console 금지 룰)
        return null;
      }
    },

    clearUserColumnLayout: () =>
      set(state => {
        state.userColumnLayout = null;
      }),

    // ColumnLayoutModal OK — 표시/순서/폭/색을 grid 에 즉시 반영(영구 저장은 titleSet SAVE 별도).
    applyColumnLayout: settings => {
      set(state => {
        // 표시 컬럼은 순서대로 1..n, 비표시 컬럼도 visible:false 로 함께 보관한다
        //   (applyLayoutToColumns 는 미등록 컬럼을 admin 기본값으로 두므로, 버리면 방금 끈 컬럼이
        //   재조회 때 되살아난다).
        const shown = settings
          .filter(s => s.visible)
          .sort((a, b) => a.order - b.order)
          .map((s, i) => ({ ...s, order: i + 1 }));
        const hidden = settings
          .filter(s => !s.visible)
          .map(s => ({ ...s, order: Number.MAX_SAFE_INTEGER }));
        const layout = [...shown, ...hidden];
        state.userColumnLayout = layout;
        const cur = state.staticColumns;
        if (!cur || cur.length === 0) return;
        state.staticColumns = applyLayoutToColumns(cur, layout);
      });
    },

    // MeasureSelectModal OK — 표시할 measure 코드만 보관 (null = 전체 표시).
    applyVisibleMeasures: measureCodes => {
      set(state => {
        state.visibleMeasures = measureCodes;
      });
    },
  }),
  'shipment-request'
);
