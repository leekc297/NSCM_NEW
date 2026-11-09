import type { MeasureMeta } from 'features/master/src/components';

import { apiClient } from '@foundation/apis';
import dayjs from '@foundation/dayjs';
import _ from '@foundation/lodash';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab } from '@shared/stores';

import { BUCKET_TYPE, MENU_ID, SHEETS } from './mkt-fcst-comparison.constants';
import type { SearchParams } from './mkt-fcst-comparison.types';

interface Filters {
  [SHEETS.MAIN]?: ProcRequest<MENU_ID, SHEETS.MAIN>;
  [SHEETS.SPREAD_TITLE]?: ProcRequest<MENU_ID, SHEETS.SPREAD_TITLE>;
}

/** ColumnLayoutModal 개인화 1행 — 표시/순서/폭/색 (forecast-price(DMF0082)·mkt-fcst(DMF0003) 선례 1:1). */
export interface ColumnLayoutSetting {
  colNm: string;
  visible: boolean;
  width: number;
  cellColor: string;
  textColor: string;
  order: number;
}

interface MktFcstComparisonState {
  searchParams: SearchParams;
  filters: Filters;
  isOpenSearchArea: boolean;
  staticColumns: RawFlexGridColumnConfig[];
  /** 개인화 적용 전 원본 컬럼 — 팝업 Default 원복 기준 (개인화로 덮이지 않는다). */
  originalStaticColumns: RawFlexGridColumnConfig[];
  /** 저장된 컬럼 개인화(titleSet 'C') — 표시/순서/폭/색. fetchStaticColumns 재조회 시 재적용. */
  userColumnLayout: ColumnLayoutSetting[] | null;
  /**
   * userColumnLayout 을 받아온 division — [2026-09-14] titleSet 'C' 조회는 division 별로 다른 컬럼을 준다
   *   (40 = END_CUSTOMER40/SCM_SITE_ID40/ITEM_ID40, 그 외 = END_CUSTOMER/SCM_SITE_ID/ITEM_ID).
   *   division 이 바뀌면 다시 받아야 한다 — 최초 division 레이아웃을 재사용하면 해당 컬럼이 숨김 처리된다.
   */
  userColumnLayoutDivision: string;
  /** 컬럼 admin 기본 정렬(SORT_ORDER_NO) colNm→순번 — 개인화 누락 필수 컬럼 제자리 삽입 기준. */
  adminColOrder: Record<string, number>;
  staticMeasures: MeasureMeta[];
  /** F6 저장 조회조건 복원 1회 가드 (탭 오픈당) — MotherStore PRESERVED_ON_CONDITION_RESET 보존 키 */
  initialized: boolean;
}

interface MktFcstComparisonAction {
  reset: () => void;
  /** [COND 2026-08-27] UI 오픈 시 F6 저장 조회조건(SCM_ADM_USER_MNU_SRCH_COND_M) 복원 — 정본 sales-future-price */
  restoreSearchConditions: () => Promise<void>;
  setSearchParams: (searchParams: Partial<SearchParams>) => void;
  setFilters: (input: { userId: string }) => boolean;
  setOpenSearchArea: (open?: boolean) => void;
  fetchStaticColumns: (input: { divisionId: string }) => Promise<void>;
  /**
   * 저장된 컬럼 개인화(titleSet 'C') 복원 — userColumnLayout 세팅. fetchStaticColumns 가 먼저 await 해
   * override 를 확보한 뒤 admin 메타에 적용한다(별도 effect 로 분리하면 응답 순서 경쟁 사고).
   */
  fetchUserColumnLayout: (input: { divisionId: string }) => Promise<void>;
  fetchStaticMeasures: (input: { divisionId: string }) => Promise<void>;
  /** ColumnLayoutModal onSave — 표시/순서/폭/색을 staticColumns 에 즉시 반영 (forecast-price 선례). */
  applyColumnLayout: (
    settings: {
      colNm: string;
      visible: boolean;
      width?: number;
      cellColor?: string;
      textColor?: string;
      order?: number;
    }[]
  ) => void;
  /** UC-03 / hook #132 §2-2 — 설정 저장 시 기존 조회 데이터 Reset (그리드 비움, Search 로 재조회). */
  clearData: () => void;
  /**
   * UM-08 — bucket 경계 전환(AS-IS InitSpread): 메인 데이터는 비우고 스프레드 타이틀만 새 bucket 으로
   * 즉시 재조회해 빈 그리드에 새 헤더를 그린다 (.cs L1141~1160 — GetSpdTitle + CreateSheetHeaderColumn).
   */
  resetForBucket: (bucket: string) => void;
}

/**
 * Period 기본 종료일 = 이번달 +5개월 말일 (2026-09-01 기준 2027-02-28).
 *
 * AS-IS 실화면 실측 (사용자 확정 2026-09-01). 종전 add(6, 'month') 는 2027-03-31 이 되어
 * 한 달 더 나갔다. ComparisonVersionModal 의 폴백도 이 함수를 쓴다 - 같은 날짜식이 두 곳에
 * 흩어져 있으면 한쪽만 고쳐져 다시 어긋난다.
 */
export const defaultPeriodEnd = (): string =>
  dayjs().add(5, 'month').endOf('month').format('YYYYMMDD');

/** 조회조건 기간 기본값 — 이번달 1일 ~ +5개월 말일 */
const defaultPeriod = () => ({
  startYyyymmdd: dayjs().startOf('month').format('YYYYMMDD'),
  endYyyymmdd: defaultPeriodEnd(),
});

const initSearchParams: SearchParams = {
  divisionId: '',
  deptIds: [],
  endCustomers: [],
  bizTypes: [],
  salesSiteIds: [],
  plantSiteIds: [],
  projectCodes: [],
  itemIds: [],
  itemTypes: [],
  owners: [],
  version: '', // 기본 = Division 결정 후 최근 MF_W 2개 자동 세팅 (AS-IS GetDefaultVersion — Form 담당)
  ...defaultPeriod(),
  bucket: BUCKET_TYPE.MONTHLY, // AS-IS DefineProperty L370
  qty: '1',
  isSumChecked: false, // AS-IS chkSum.Checked=false (L323)
  isDiffOnly: false,
};

const initState: MktFcstComparisonState = {
  searchParams: initSearchParams,
  filters: {},
  isOpenSearchArea: true,
  staticColumns: [],
  originalStaticColumns: [],
  userColumnLayout: null,
  userColumnLayoutDivision: '',
  adminColOrder: {},
  staticMeasures: [],
  initialized: false,
};

/** BE 가 폭을 안 내려줄 때의 기본 폭 (ColumnLayoutModal DEFAULT_COL_WIDTH 와 동일 계약). */
const DEFAULT_COL_WIDTH = 100;

/**
 * 저장된 컬럼 개인화(titleSet 'C')를 admin 컬럼 메타 위에 덧씌운다 (forecast-price(DMF0082) 선례 1:1).
 *
 * 주의: BE PR_GET_SHEET_COLUMN_LIST 는 SHEET_PRSL_YN 미등록 화면(DMF0040)에 개인화를 반영하지 않는다
 *   — 그래서 titleSet 'C' 로 저장한 값을 FE 가 직접 얹지 않으면 매 재조회(그리고 새 창 진입)마다
 *   관리자 기본값(현재 7컬럼)으로 되돌아간다. 이것이 "새 창을 열면 저장 컬럼이 안 뜨는" 사고의 원인.
 */
const applyLayoutToColumns = (
  cols: RawFlexGridColumnConfig[],
  settings: ColumnLayoutSetting[],
  adminColOrder: Record<string, number> = {}
): RawFlexGridColumnConfig[] => {
  const byCol = new Map(settings.map(s => [s.colNm, s]));
  // 개인화에 없는 필수 컬럼(USER_SELECT_FLAG='N' = personalizable:false)을 자동 추가할 때의 정렬 위치 —
  //   admin 순서(SORT_ORDER_NO)상 자기 앞에 있는 '개인화된' 컬럼들의 최대 user order 바로 뒤(+0.5)에
  //   끼워 제자리에 붙인다(맨 앞 키 컬럼이면 앞쪽, MEASURE 처럼 뒤 키 컬럼이면 뒤쪽).
  const autoAddOrder = (colNm: string): number => {
    const myAdmin = adminColOrder[colNm] ?? Number.MAX_SAFE_INTEGER;
    let anchor = 0;
    for (const s of settings) {
      const sAdmin = adminColOrder[s.colNm] ?? Number.MAX_SAFE_INTEGER;
      if (sAdmin < myAdmin) anchor = Math.max(anchor, s.order);
    }
    return anchor + 0.5;
  };
  const orderKey = (c: RawFlexGridColumnConfig): number => {
    const s = byCol.get(c.colNm);
    if (s) return s.order;
    return c.personalizable === false ? autoAddOrder(c.colNm) : Number.MAX_SAFE_INTEGER;
  };
  return cols
    .map(c => {
      const s = byCol.get(c.colNm);
      if (s)
        return {
          ...c,
          visible: s.visible,
          display: s.visible,
          colWth: s.width,
          cellColor: s.cellColor,
          textColor: s.textColor,
        };
      // 개인화 목록에 없는 컬럼:
      //   - personalizable===false(사용자가 숨길 수 없는 필수 컬럼)이고 표시용(visible===true)이면,
      //     저장 내역에 누락됐어도 자동 표시한다 (VERSION_NO/MEASURE 등 필수 컬럼 보완).
      //     ⚠ display=true 강제 — BE /column 이 개인화 USER_FLAG='N' 을 display:false 로 반영해 내려준다.
      //   - 그 외(사용자가 숨길 수 있는데 목록에 없는)는 비표시로 저장한 것 → 숨김.
      if (c.personalizable === false && c.visible === true) return { ...c, display: true };
      return { ...c, visible: false, display: false };
    })
    .sort((a, b) => orderKey(a) - orderKey(b));
};

/** [COND 2026-08-27] 저장 조회조건 역파싱 키 분류 — 저장은 문자열 coerce(배열=콤마 join / 불리언=String) */
const ARRAY_KEYS = new Set<string>(
  Object.entries(initSearchParams)
    .filter(([, v]) => Array.isArray(v))
    .map(([k]) => k)
);
/**
 * 저장 조회조건(F6) 복원에서 제외할 키 — 기간은 조회 시점 기준으로 다시 계산한다.
 *
 * 저장은 절대 날짜(YYYYMMDD)라 그대로 되살리면 저장한 달의 구간이 그대로 뜬다. 지난달에
 * 저장해 두면 이번달에도 지난달 기준 기간이 올라와 "기본값을 고쳤는데 화면은 그대로"가 된다
 * (2026-09-01 실사고 — Period 종료일이 계속 2027-03-31 로 보임).
 *
 * defaultPeriod() 의 키를 그대로 쓴다 - 기간 칸이 늘거나 이름이 바뀌어도 따라온다.
 */
const PERIOD_KEYS = new Set<string>(Object.keys(defaultPeriod()));

const BOOL_KEYS = new Set<string>(
  Object.entries(initSearchParams)
    .filter(([, v]) => typeof v === 'boolean')
    .map(([k]) => k)
);

/** 멀티 필터 → SP 규약: 빈 배열 = 'ALL' (빈 토큰 전멸 계보 — DMF0035 orAll 동일) */
const orAll = (arr: string[]): string => (arr.length > 0 ? arr.join(',') : 'ALL');

export const useMktFcstComparisonStore = createPersistedStoreWithTab<
  MktFcstComparisonState & MktFcstComparisonAction
>(
  (set, get) => ({
    ...initState,
    reset: () =>
      set(state => {
        state.searchParams = { ...initSearchParams, ...defaultPeriod() };
        state.filters = {};
        state.isOpenSearchArea = true;
        state.staticColumns = [];
        state.originalStaticColumns = [];
        state.userColumnLayout = null;
        state.userColumnLayoutDivision = '';
        state.adminColOrder = {};
      }),
    // ⭐ [COND 2026-08-27] F6 저장 조회조건 복원 — 탭 오픈 시 1회(initialized 가드). F10(Reset Condition) 은
    //   SubTitle 공통이 DB 삭제 + MotherStore.resetSearchCondition(reset() 후 initialized 보존) 으로 처리.
    //   복원된 version 이 있으면 Form 의 기본 Version 자동세팅(version 빈값일 때만)은 건너뛴다.
    restoreSearchConditions: async () => {
      if (get().initialized) return;
      set(state => {
        state.initialized = true;
      });
      try {
        const res = await apiClient.get<{ paramNm: string; paramCtn: string }[]>(
          `/admin/menu/${MENU_ID}/search-conditions`
        );
        const rows = res.data.result ?? [];
        if (rows.length === 0) return;
        const patch: Record<string, unknown> = {};
        for (const { paramNm, paramCtn } of rows) {
          if (!(paramNm in initSearchParams)) continue;
          if (PERIOD_KEYS.has(paramNm)) continue; // 기간은 항상 오늘 기준 기본값이 이긴다
          const val = paramCtn ?? '';
          if (ARRAY_KEYS.has(paramNm)) patch[paramNm] = val ? val.split(',').filter(Boolean) : [];
          else if (BOOL_KEYS.has(paramNm)) patch[paramNm] = val === 'true';
          else patch[paramNm] = val;
        }
        set(state => {
          state.searchParams = { ...state.searchParams, ...(patch as Partial<SearchParams>) };
        });
      } catch {
        // 저장조건 미존재/조회 실패 시 기본값 유지 (console 금지 룰)
      }
    },
    setSearchParams: searchParams =>
      set(state => {
        state.searchParams = { ...state.searchParams, ...searchParams };
      }),
    setFilters: ({ userId }) => {
      let changed = false;
      set(state => {
        const p = state.searchParams;
        const newFilters: Filters = {
          // PKG_DMF0040.P_DMF0040_GET_MKT_FCST_COMPARISON — PROC_M positional 18 (seed_meta.py 실측)
          [SHEETS.MAIN]: {
            divisionId: p.divisionId,
            scmSiteId: orAll(p.salesSiteIds),
            plantSiteId: orAll(p.plantSiteIds),
            teamId: orAll(p.deptIds),
            customer: orAll(p.endCustomers),
            bizType: orAll(p.bizTypes),
            projectCode: p.projectCodes.join(','),
            itemId: p.itemIds.join(','),
            fromYyyymmdd: p.startYyyymmdd,
            toYyyymmdd: p.endYyyymmdd,
            sesUserId: userId,
            versionNo: p.version,
            itemType: orAll(p.itemTypes),
            owner: p.owners.join(','),
            // AS-IS p_diff_only = cboDiff.Checked bool 직렬화 ('True'/'False' — .cs L735 파리티)
            diffOnly: p.isDiffOnly ? 'True' : 'False',
            bucket: p.bucket,
            userId,
            mnuId: MENU_ID,
          },
          [SHEETS.SPREAD_TITLE]: {
            startYyyymmdd: p.startYyyymmdd,
            endYyyymmdd: p.endYyyymmdd,
            sesUserId: userId,
            divisionId: p.divisionId,
            bucket: p.bucket,
          },
        };
        if (!_.isEqual(newFilters, state.filters)) {
          state.filters = newFilters;
          changed = true;
        }
      });
      return changed;
    },
    setOpenSearchArea: open =>
      set(state => {
        state.isOpenSearchArea = open ?? !state.isOpenSearchArea;
      }),
    // ⭐ 정적 컬럼 = 서버 직접 비교 (#113 — divisionId 전송·division 변경 시 재fetch. 정본 DMF0021/DMF0035)
    fetchStaticColumns: async ({ divisionId }) => {
      // 진입 시 개인화 복원 — 저장된 titleSet 을 먼저 조회해 override 를 확보한 뒤 메타에 적용한다.
      //   (별도 effect 로 분리하면 메타 응답과 순서 경쟁 → 늦게 온 쪽이 덮어쓰는 사고.)
      //   userColumnLayout 이 이미 있으면(모달 OK 직후 재조회) 서버 재조회 없이 그 값을 유지.
      //   ⭐ [2026-09-14] 단, 받아온 division 과 다르면 다시 받는다 — 40 ↔ 81/82 전환 시 End Customer·
      //   Sales Site·Model 컬럼이 숨겨지던 결함(이전 division 레이아웃에 해당 컬럼명이 없어 숨김 처리).
      if (get().userColumnLayout === null || get().userColumnLayoutDivision !== divisionId)
        await get().fetchUserColumnLayout({ divisionId });

      const result = await apiClient.post<RawFlexGridColumnConfig[]>(
        `/admin/menu/${MENU_ID}/column`,
        { sheetNm: 'Mkt Fcst Waterfall', divisionId }
      );
      set(state => {
        // UM-06 (#93) — 정적 컬럼은 1단 헤더: AS-IS 는 3행 헤더에서 정적 컬럼을 세로 병합해 1단으로 보였다.
        //   메타 SMALL/LARGE 가 라벨과 다른 행이 있으면 foundation getColumnDepth 가 정적 블록까지 2~3단으로
        //   벌리므로 라벨로 정규화한다 (DMF0053 정본 useCustFcstWaterfallStore L195~202 동형).
        const fetched = (result.data.result ?? []).map(col => ({
          ...col,
          sClsLblNm: col.colLblNm,
          lClsLblNm: col.colLblNm,
        }));
        // 개인화 적용 전 원본 보관 — 팝업 Default 원복 기준 (개인화로 덮이지 않는다).
        state.originalStaticColumns = fetched;
        // 저장된 개인화가 있으면 admin 메타 위에 덧씌운다 — 안 하면 재조회/새 창 진입마다
        //   사용자가 저장한 표시/순서/폭/색이 관리자 기본값으로 되돌아간다(이 화면 원 사고).
        const layout = get().userColumnLayout;
        state.staticColumns =
          layout && layout.length > 0
            ? applyLayoutToColumns(fetched, layout, get().adminColOrder)
            : fetched;
      });
    },
    // ⭐ 저장된 컬럼 개인화 복원 (진입 시 1회) — ColumnLayoutModal 이 쓰는 SP 와 동일 계약:
    //   SCM0002_GET_TITLESET_POPUP (titleSet/SEARCH/call-proc, columnType='C'). USER_FLAG='Y' = 표시 저장 컬럼.
    //   sheetName 은 titleSet 정본(saveTitleSet TITLESET_SHEET)과 동일한 'Mkt Fcst Waterfall'.
    fetchUserColumnLayout: async ({ divisionId }) => {
      try {
        const res = await apiClient.post<{ o_rc1?: Record<string, string>[] }>(
          `${MENU_ID}/titleSet/SEARCH/call-proc`,
          {
            programId: MENU_ID,
            sheetName: 'Mkt Fcst Waterfall',
            columnType: 'C',
            divisionId,
          }
        );
        const rows = res.data.result?.o_rc1 ?? [];
        // 사용자 저장값 별칭 우선 — SP 는 관리자 기본값(COLUMN_WIDTH/SORT_ORDER_NO)과
        //   사용자값(USER_COLUMN_WIDTH/USER_SORT_ORDER_NO)을 따로 내려준다.
        const orderOf = (r: Record<string, string>): number =>
          Number(r.USER_SORT_ORDER_NO ?? r.SORT_ORDER_NO ?? 0);
        const layout: ColumnLayoutSetting[] = rows
          .filter(r => String(r.USER_FLAG ?? '') === 'Y')
          .sort((a, b) => orderOf(a) - orderOf(b))
          .map((r, i) => {
            const width = Number(r.USER_COLUMN_WIDTH ?? r.COLUMN_WIDTH ?? 0);
            return {
              colNm: String(r.COLUMN_NAME ?? ''),
              visible: true,
              width: Number.isFinite(width) && width > 0 ? width : DEFAULT_COL_WIDTH,
              cellColor: String(r.CELL_COLOR ?? ''),
              textColor: String(r.TEXT_COLOR ?? ''),
              order: i + 1,
            };
          })
          .filter(s => s.colNm);
        // admin 기본 정렬(SORT_ORDER_NO) — 개인화 누락 필수 컬럼을 제자리에 끼울 때 쓴다(전 행에서 뽑음).
        const adminColOrder: Record<string, number> = {};
        for (const r of rows) {
          const nm = String(r.COLUMN_NAME ?? '');
          if (nm) adminColOrder[nm] = Number(r.SORT_ORDER_NO ?? 0);
        }
        set(state => {
          state.adminColOrder = adminColOrder;
          state.userColumnLayoutDivision = divisionId;
          // 이 division 에 저장 개인화가 없으면 이전 division 레이아웃을 남기지 않는다(admin 기본으로 표시).
          if (layout.length === 0) state.userColumnLayout = null;
        });
        if (layout.length === 0) return;
        set(state => {
          state.userColumnLayout = layout;
          // 이 조회가 /column 보다 늦게 와도 개인화가 유실되지 않게 이미 받아둔 컬럼에 소급 적용.
          if (state.staticColumns.length > 0) {
            state.staticColumns = applyLayoutToColumns(state.staticColumns, layout, adminColOrder);
          }
        });
      } catch {
        // 개인화 조회 실패 = 기본 컬럼 세트로 동작 (화면 차단 금지, console 금지 룰)
      }
    },
    // ⭐ Measure 목록 (SCM_MST_SHEET_MEASURE PROGRAM_ID='DMF0040' — seed_meta.py 49행 시딩) — 서버 직접 비교 (#113)
    fetchStaticMeasures: async ({ divisionId }) => {
      try {
        const result = await apiClient.post<MeasureMeta[]>(`/admin/menu/${MENU_ID}/measure`, {
          sheetNm: 'Mkt Fcst Waterfall',
          divisionId,
        });
        set(state => {
          state.staticMeasures = result.data.result ?? [];
        });
      } catch {
        /* 미적재 시 빈 배열 유지 — 모달 fallback */
      }
    },
    applyColumnLayout: settings =>
      set(state => {
        // 표시 컬럼만 userColumnLayout 으로 보관 — fetchStaticColumns 재조회(Search) 후 재적용 기준이자
        //   새 창 진입 전까지의 세션 내 복원값. 이 보관이 없으면 저장 직후 Search 재조회가 선택을 덮는다.
        const layout: ColumnLayoutSetting[] = settings
          .filter(s => s.visible)
          .sort((a, b) => (a.order ?? 0) - (b.order ?? 0))
          .map((s, i) => ({
            colNm: s.colNm,
            visible: true,
            width: s.width ?? DEFAULT_COL_WIDTH,
            cellColor: s.cellColor ?? '',
            textColor: s.textColor ?? '',
            order: i + 1,
          }));
        state.userColumnLayout = layout;
        // 모달은 현재 division 기준으로 저장한다 — 이후 fetchStaticColumns 가 재조회 없이 이 값을 쓰도록 표시.
        state.userColumnLayoutDivision = state.searchParams.divisionId;
        if (state.staticColumns.length === 0) return;
        state.staticColumns = applyLayoutToColumns(state.staticColumns, layout, state.adminColOrder);
      }),
    clearData: () =>
      set(state => {
        state.filters = {};
      }),
    resetForBucket: bucket =>
      set(state => {
        const title = state.filters[SHEETS.SPREAD_TITLE];
        // 조회 전(타이틀 미조회)이면 비울 것도 없다 — 메인만 제거, 타이틀은 bucket 만 갈아 즉시 재조회
        state.filters = title ? { [SHEETS.SPREAD_TITLE]: { ...title, bucket } } : {};
      }),
  }),
  'mkt-fcst-comparison'
);
