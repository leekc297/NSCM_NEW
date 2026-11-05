import { apiClient } from '@foundation/apis';
import dayjs from '@foundation/dayjs';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { fetchTitleSet } from '@shared/components';
import { createPersistedStoreWithTab, useSessionStore } from '@shared/stores';

import {
  ADMIN_SHEET_NAME,
  MENU_ID,
  PERIOD_BUSINESS_DAYS,
  SHEETS,
  TITLESET_COLUMN_TYPE,
} from './shipment-plan-confirm-detail.constants';
import type { SearchCondition } from './shipment-plan-confirm-detail.types';

/** ColumnLayoutModal 개인화 1행 — 표준 공용 모달(POP-13)이 다루는 표시/순서 + 폭/색.
 *   width=0 은 '미설정'으로 보고 admin 메타 폭을 유지한다(applyLayoutToColumns). */
export interface ColumnLayoutSetting {
  colNm: string;
  visible: boolean;
  order: number;
  width: number;
  cellColor: string;
  textColor: string;
}

type FiltersBySheet = {
  [SHEETS.MAIN]?: ProcRequest<MENU_ID, SHEETS.MAIN>;
};

type StaticColumnsBySheet = {
  [SHEETS.MAIN]: RawFlexGridColumnConfig[];
};

interface State {
  initialized: boolean;
  // 개인화 조회조건(F6 저장분) 복원 1회 가드. initialized 는 컬럼메타 전용이라 분리
  //   (로드 전용 플래그). 형제 화면(shipment-plan-mobility-it) restoreSearchConditions 와 동일 패턴.
  conditionsRestored: boolean;
  searchCondition: SearchCondition;
  filters: FiltersBySheet;
  openSearchArea: boolean;
  // L1 권한 게이트(design 01 §2) — MyDivision(EE 제외) 콤보 0건이면 false → 조회영역 disable.
  hasDivisionAuth: boolean;
  // AS-IS GetDayRange(SCM0001_GET_SCP_DAY_PERIOD) 서버 산출 기본구간. Form 콤보가 도착 시 채운다.
  //   비어 있으면(콤보 미도착/실패) dayjs 주말근사로 폴백. mount·Division 변경·F10 리셋이 이 값을 기본값으로 쓴다.
  serverPeriod: { from: string; to: string };
  // ui-dynamic-property-management §2.3 — admin SCM_MST_SHEET_COLUMNS 동적 fetch(mount + Search).
  staticColumns: StaticColumnsBySheet;
  // 개인화 적용 전 admin 메타 원본(MAIN) — ColumnLayoutModal Default 버튼의 원복 기준.
  //   staticColumns 는 개인화로 덮이므로 별도 스냅샷이 필요하다 (business-plan originalStaticColumns 동일).
  originalStaticColumns: RawFlexGridColumnConfig[];
  // ColumnLayoutModal OK 결과(null = 미설정) — 표시/순서 + 폭/색.
  //   fetchStaticColumns 가 Search/mount 마다 admin 메타를 다시 덮으므로, 이 값으로 재적용하지 않으면
  //   컬럼 설정 직후 조회 한 번에 개인화가 통째로 원복된다 (business-plan userColumnLayout 동일).
  userColumnLayout: ColumnLayoutSetting[] | null;
}

interface Action {
  reset: () => void;
  setSearchCondition: (p: Partial<SearchCondition>) => void;
  setPeriod: (fromYyyymmdd: string, toYyyymmdd: string) => void;
  // design 02 §3: Division 변경 = From Site cascade 재조회(콤보 payload) + Period 기본값 리셋(cs:380).
  setDivisions: (divisionIds: string[]) => void;
  // mount 시 Period 기본값 세팅(서버 산출 구간 우선, 미도착 시 dayjs 근사).
  initPeriodDefault: () => void;
  // Form 의 SCM0001_GET_SCP_DAY_PERIOD 콤보 결과("from","to") 수신 — serverPeriod 저장 + 현재 Period 반영.
  setServerPeriod: (fromYyyymmdd: string, toYyyymmdd: string) => void;
  // F6(개인화 조회조건) 저장분 복원 — GET /admin/menu/{MENU_ID}/search-conditions → searchCondition 패치(1회).
  restoreSearchConditions: () => Promise<void>;
  setFilter: () => void;
  clearFilters: () => void;
  setOpenSearchArea: (open?: boolean) => void;
  setDivisionAuth: (has: boolean) => void;
  fetchStaticColumns: () => Promise<void>;
  /** ColumnLayoutModal onSave — 표시/순서/폭/색을 staticColumns[MAIN] 에 즉시 반영. */
  applyColumnLayout: (settings: ColumnLayoutSetting[]) => void;
  /** 저장된 컬럼 개인화(titleSet) 복원 — fetchStaticColumns 가 await 후 메타에 적용. */
  fetchUserColumnLayout: () => Promise<void>;
}

const initSearch: SearchCondition = {
  divisionIds: [],
  fromSiteIds: [],
  itemId: '',
  fromYyyymmdd: '',
  toYyyymmdd: '',
  soldToParty: '',
  shipToParty: '',
};

const emptyStaticColumns: StaticColumnsBySheet = {
  [SHEETS.MAIN]: [],
};

// F6 복원 역직렬화 키셋. 저장 직렬화(gridAction.personalizeCondition)가 배열을 콤마 join 하므로
//   복원 시 콤마 split 로 되돌린다. 날짜/기간(fromYyyymmdd·toYyyymmdd)은 저장단 EXCLUDED_DATE_PARAM
//   으로 애초에 저장되지 않아 복원 대상이 아니다. 불리언 조회조건은 이 화면에 없다.
const ARRAY_KEYS = new Set<string>(['divisionIds', 'fromSiteIds']);

const initState: State = {
  initialized: false,
  conditionsRestored: false,
  searchCondition: initSearch,
  filters: {},
  openSearchArea: true,
  hasDivisionAuth: true,
  serverPeriod: { from: '', to: '' },
  staticColumns: emptyStaticColumns,
  originalStaticColumns: [],
  userColumnLayout: null,
};

// ColumnLayoutModal 개인화 override — 표시(display)/순서 + 폭(colWth)/색(cellColor·textColor)을
//   admin 메타 위에 덧씌운다(공용 DataGrid 가 이 필드로 폭·색을 렌더). `visible` 은 admin VISIBLE_FLAG
//   (관리 노출)이라 사용자 조작으로 덮어쓰지 않고 `display` 만 건드린다. width=0(미설정)이면 admin 폭 유지.
const applyLayoutToColumns = (
  cols: RawFlexGridColumnConfig[],
  settings: ColumnLayoutSetting[]
): RawFlexGridColumnConfig[] => {
  const byCol = new Map(settings.map(s => [s.colNm, s]));
  return (
    cols
      .map(c => {
        const s = byCol.get(c.colNm);
        // 개인화 목록에 없는 컬럼 = 사용자가 비표시로 저장한 것. 폭/색은 보존.
        if (!s) return { ...c, display: false };
        return {
          ...c,
          display: s.visible,
          colWth: s.width > 0 ? s.width : c.colWth,
          cellColor: s.cellColor,
          textColor: s.textColor,
        };
      })
      // 팝업 순서대로 재정렬 — grid 는 배열 순서를 컬럼 순서로 사용. 미매칭 컬럼은 뒤로.
      .sort(
        (a, b) =>
          (byCol.get(a.colNm)?.order ?? Number.MAX_SAFE_INTEGER) -
          (byCol.get(b.colNm)?.order ?? Number.MAX_SAFE_INTEGER)
      )
  );
};

// design 02 §2/§4: Period 기본 = 오늘 ~ 오늘 +55영업일(주말 제외 근사).
//   주의: AS-IS 는 SCM0001_GET_SCP_DAY_PERIOD(타임존/휴일 반영) 서버계산 — TO-BE 미배포라 클라 근사(dayjs).
//   정밀 영업일(공휴일 포함) 계산은 convert-sp(SP 배포) 후 대조(goal §②/§⑦-1).
const addBusinessDays = (from: dayjs.Dayjs, days: number): dayjs.Dayjs => {
  let cursor = from;
  let remaining = days;
  while (remaining > 0) {
    cursor = cursor.add(1, 'day');
    const dow = cursor.day(); // 0=일, 6=토
    if (dow !== 0 && dow !== 6) remaining -= 1;
  }
  return cursor;
};
const defaultPeriod = (): { from: string; to: string } => {
  const base = dayjs();
  return {
    from: base.format('YYYYMMDD'),
    to: addBusinessDays(base, PERIOD_BUSINESS_DAYS).format('YYYYMMDD'),
  };
};
// 기본 Period 산출 — AS-IS GetDayRange 서버 구간(serverPeriod)이 있으면 그것(휴일/타임존 반영), 없으면 dayjs 근사.
const effectivePeriod = (sp: { from: string; to: string }): { from: string; to: string } =>
  sp.from && sp.to ? sp : defaultPeriod();

// 다중/개행 -> SP 파라미터 문자열. 빈값 = '' (전체, GET SP TRIM 무시).
const joinOrEmpty = (arr: string[]): string => (arr.length === 0 ? '' : arr.join(','));
// 개행/콤마 다건 -> 콤마 join (AS-IS UsrMultiLineEditor .Text, GET SP FN_GET_IN_STR IN절).
const multiLine = (v: string): string =>
  v
    ? v
        .split(/[\n,]/)
        .map(s => s.trim())
        .filter(Boolean)
        .join(',')
    : '';

export const useShipmentPlanConfirmDetailStore = createPersistedStoreWithTab<State & Action>(
  (set, get) => ({
    ...initState,
    // F10(조회조건 초기화): '삭제'(빈값)가 아니라 '기본값 복원'. 공용 resetSearchCondition→reset() 경로가
    //   이 액션을 탄다. initState 는 Period(fromYyyymmdd/toYyyymmdd)가 공백('')이라 그대로 두면 기간이
    //   지워져 Search 가 즉시 MSG00013(필수)으로 막힌다 — AS-IS F10/InitValue=GetDayRange(cs:380) 리셋과
    //   불일치. 그래서 Division/From Site/Model/Sold To/Ship To 는 초기 상수(빈값=기본값)로, Period 만
    //   mount 와 동일한 기본값(오늘~+55영업일)으로 되돌린다.
    reset: () => {
      // serverPeriod 는 보존한다 — 콤보는 파라미터(오늘) 불변이라 리셋 후 재발사되지 않으므로,
      //   AS-IS F10 재-GetDayRange 등가로 저장된 서버 구간으로 되돌린다(미도착 시 dayjs 폴백).
      const sp = get().serverPeriod;
      const { from, to } = effectivePeriod(sp);
      set({
        ...initState,
        serverPeriod: sp,
        searchCondition: { ...initSearch, fromYyyymmdd: from, toYyyymmdd: to },
      });
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
    // design 02 §3 cascade: Division 변경 시 From Site 초기화(재조회 콤보가 divisionId 로 재발사) +
    //   Period 기본값 리셋(SetChangedControl cs:380).
    setDivisions: divisionIds =>
      set(state => {
        // AS-IS SetChangedControl(cs:381): Division 변경 시 drpPeriod.InitValue=GetDayRange() 재설정.
        //   fromDate=오늘 고정이라 서버 구간은 불변 — 저장된 serverPeriod(없으면 dayjs)로 되돌린다.
        const { from, to } = effectivePeriod(state.serverPeriod);
        state.searchCondition.divisionIds = divisionIds;
        state.searchCondition.fromSiteIds = [];
        state.searchCondition.fromYyyymmdd = from;
        state.searchCondition.toYyyymmdd = to;
      }),
    initPeriodDefault: () =>
      set(state => {
        const { from, to } = effectivePeriod(state.serverPeriod);
        state.searchCondition.fromYyyymmdd = from;
        state.searchCondition.toYyyymmdd = to;
      }),
    // Form 의 SCM0001_GET_SCP_DAY_PERIOD 콤보 결과 반영 — serverPeriod 저장 + 현재 Period 를 서버 구간으로 교체.
    //   콤보는 1회 도착(파라미터 불변)하며, 그 시점에 dayjs 초기 근사를 AS-IS 서버 구간으로 덮는다.
    setServerPeriod: (fromYyyymmdd, toYyyymmdd) =>
      set(state => {
        state.serverPeriod = { from: fromYyyymmdd, to: toYyyymmdd };
        state.searchCondition.fromYyyymmdd = fromYyyymmdd;
        state.searchCondition.toYyyymmdd = toYyyymmdd;
      }),
    // F6(개인화 조회조건) 저장분 복원 — 진입/새로고침 시 GET /admin/menu/{MENU_ID}/search-conditions
    //   → PRAM_NM/PRAM_CTN 을 searchCondition 에 역직렬화(1회 가드). 저장분 0건이면 기본값 유지.
    //   날짜/기간축은 저장 제외라 복원 후에도 initPeriodDefault 기본값이 그대로 유지된다.
    restoreSearchConditions: async () => {
      if (get().conditionsRestored) return;
      set(state => {
        state.conditionsRestored = true; // 먼저 세운다(중복/재마운트 재복원 방지)
      });
      try {
        const res = await apiClient.get<{ paramNm: string; paramCtn: string }[]>(
          `/admin/menu/${MENU_ID}/search-conditions`
        );
        const rows = res.data.result ?? [];
        if (rows.length === 0) return;
        const patch: Record<string, unknown> = {};
        for (const { paramNm, paramCtn } of rows) {
          if (!(paramNm in initSearch)) continue; // 모르는 키(구버전 잔재) 제외
          const val = paramCtn ?? '';
          if (ARRAY_KEYS.has(paramNm)) patch[paramNm] = val ? val.split(',').filter(Boolean) : [];
          else patch[paramNm] = val;
        }
        set(state => {
          state.searchCondition = { ...state.searchCondition, ...patch } as SearchCondition;
        });
      } catch {
        // 미저장/실패 = 기본값 유지 (하드코딩 fallback·console 금지)
      }
    },
    setFilter: () => {
      set(state => {
        const c = state.searchCondition;
        // GET SP P_SSP0012_GET_SHIPMENT_PLAN_CONFIRM_DETAIL 파라미터 9종 (design 03 §4, cs:420-428):
        //   p_division_id / p_from_site / p_item_id / p_from_yyyymmdd / p_to_yyyymmdd /
        //   p_Sold_To_Party / p_Ship_To_Party / debug_mode='F' / p_language(@sesLangCd 세션)
        const language = useSessionStore.getState().session.langCd ?? '';
        state.filters = {
          [SHEETS.MAIN]: {
            divisionId: joinOrEmpty(c.divisionIds),
            fromSite: joinOrEmpty(c.fromSiteIds),
            itemId: multiLine(c.itemId),
            fromYyyymmdd: c.fromYyyymmdd,
            toYyyymmdd: c.toYyyymmdd,
            soldToParty: c.soldToParty,
            shipToParty: c.shipToParty,
            debugMode: 'F',
            language,
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
    setDivisionAuth: has =>
      set(state => {
        state.hasDivisionAuth = has;
      }),

    fetchStaticColumns: async () => {
      // 진입 시 개인화 복원 — 저장된 titleSet 을 먼저 조회해 override 를 확보한 뒤 메타에 적용한다.
      //   (별도 effect 로 분리하면 메타 응답과 순서 경쟁 → 늦게 온 쪽이 덮어쓰는 사고.)
      //   이미 조회했으면(모달 OK 직후 재조회) 서버 재조회 없이 그 값을 유지 (business-plan 동일).
      if (get().userColumnLayout === null) await get().fetchUserColumnLayout();

      // 단일 시트 컬럼메타 fetch (design 03 §4). 미등록/실패 시 빈 배열 유지(그리드 공백).
      try {
        const res = await apiClient.post<RawFlexGridColumnConfig[]>(
          `/admin/menu/${MENU_ID}/column`,
          { sheetNm: ADMIN_SHEET_NAME[SHEETS.MAIN] }
        );
        const fetched = res.data.result ?? [];
        if (fetched.length > 0) {
          set(state => {
            // 개인화 적용 전 원본 보관 — 팝업 Default 원복 기준(개인화로 덮이지 않는다).
            //   재적용이 항상 일어나야 하므로 비교 가드는 원본(originalStaticColumns) 기준으로 둔다 —
            //   메타가 바뀌지 않았어도 userColumnLayout 이 바뀌면 재적용해야 한다.
            const metaChanged =
              JSON.stringify(state.originalStaticColumns) !== JSON.stringify(fetched);
            const layout = get().userColumnLayout;
            const next =
              layout && layout.length > 0 ? applyLayoutToColumns(fetched, layout) : fetched;
            if (metaChanged) state.originalStaticColumns = fetched;
            if (JSON.stringify(state.staticColumns[SHEETS.MAIN]) !== JSON.stringify(next)) {
              state.staticColumns[SHEETS.MAIN] = next;
            }
          });
        }
      } catch {
        // 미등록/실패 = 빈 배열(console 금지 룰)
      }
      set(state => {
        state.initialized = true;
      });
    },

    // ColumnLayoutModal OK — 표시/순서/폭/색을 grid 에 즉시 반영 (영구 저장은 saveTitleSet 별도).
    applyColumnLayout: settings => {
      set(state => {
        // 표시 컬럼만 보관 — fetchStaticColumns 재조회 후 재적용 기준.
        const layout = settings
          .filter(s => s.visible)
          .sort((a, b) => a.order - b.order)
          .map((s, i) => ({ ...s, order: i + 1 }));
        state.userColumnLayout = layout;
        const cur = state.staticColumns[SHEETS.MAIN];
        if (!cur || cur.length === 0) return;
        state.staticColumns[SHEETS.MAIN] = applyLayoutToColumns(cur, layout);
      });
    },

    // 저장된 컬럼 개인화 복원 — 공용 fetchTitleSet(고정 admin 엔드포인트 /admin/menu/{id}/titleset/search).
    //   조회 키(sheetName/columnType/divisionId)는 모달·저장과 반드시 같아야 한다.
    //   표시(USER_FLAG)/순서(USER_SORT_ORDER_NO) + 폭(USER_COLUMN_WIDTH/COLUMN_WIDTH)/색(CELL/TEXT_COLOR)을
    //     읽는다(ColumnLayoutModal 표준). 폭 0/미설정은 applyLayoutToColumns 에서 admin 폭으로 유지.
    //   divisionId: SSP0012 는 다중 division 이나 개인화는 division 독립이므로 divisionIds[0] ?? '' 로 통일
    //     (모달·saveTitleSet·이 조회 세 곳이 동일 값이어야 저장/복원 키가 일치한다).
    fetchUserColumnLayout: async () => {
      try {
        const rows =
          (await fetchTitleSet({
            menuId: MENU_ID,
            sheetName: ADMIN_SHEET_NAME[SHEETS.MAIN],
            columnType: TITLESET_COLUMN_TYPE,
            divisionId: get().searchCondition.divisionIds[0] ?? '',
          })) ?? [];
        const orderOf = (r: Record<string, string>): number =>
          Number(r.USER_SORT_ORDER_NO ?? r.SORT_ORDER_NO ?? 0);
        const widthOf = (r: Record<string, string>): number => {
          const w = Number(r.USER_COLUMN_WIDTH ?? r.COLUMN_WIDTH ?? 0);
          return Number.isFinite(w) && w > 0 ? w : 0; // 0 = 미설정 → admin 폭 유지
        };
        const layout = rows
          .filter(r => String(r.USER_FLAG ?? '') === 'Y')
          .sort((a, b) => orderOf(a) - orderOf(b))
          .map((r, i) => ({
            colNm: String(r.COLUMN_NAME ?? ''),
            visible: true,
            order: i + 1,
            width: widthOf(r),
            cellColor: String(r.CELL_COLOR ?? ''),
            textColor: String(r.TEXT_COLOR ?? ''),
          }))
          .filter(s => s.colNm);
        if (layout.length === 0) return;
        set(state => {
          state.userColumnLayout = layout;
          // 메타가 이미 도착해 있으면 소급 적용 (호출 순서 무관하게 개인화가 유실되지 않게).
          if (state.staticColumns[SHEETS.MAIN].length > 0) {
            state.staticColumns[SHEETS.MAIN] = applyLayoutToColumns(
              state.staticColumns[SHEETS.MAIN],
              layout
            );
          }
        });
      } catch {
        // 개인화 조회 실패 = 기본 컬럼 세트로 동작 (화면 차단 금지, console 금지 룰)
      }
    },
  }),
  'shipment-plan-confirm-detail-store'
);
