import type { MeasureMeta } from 'features/master/src/components';

import { apiClient } from '@foundation/apis';
import dayjs from '@foundation/dayjs';
import _ from '@foundation/lodash';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { toColumnLayoutSettings, type ColumnLayoutRow } from '@shared/components';
import { createPersistedStoreWithTab } from '@shared/stores';

import {
  BUCKET_TYPE,
  BUCKET2_TYPE,
  GUBUN,
  GUBUN_SHEET,
  MENU_ID,
  SHEETS,
  type Gubun,
} from './demand-plan-waterfall.constants';
import type { SearchParams } from './demand-plan-waterfall.types';

interface Filters {
  [SHEETS.MKT_FCST]?: ProcRequest<MENU_ID, SHEETS.MKT_FCST>;
  [SHEETS.SALES_PLAN]?: ProcRequest<MENU_ID, SHEETS.SALES_PLAN>;
  [SHEETS.BIZ_PLAN]?: ProcRequest<MENU_ID, SHEETS.BIZ_PLAN>;
  [SHEETS.MKT_FCST_TITLE]?: ProcRequest<MENU_ID, SHEETS.MKT_FCST_TITLE>;
  [SHEETS.SALES_PLAN_TITLE]?: ProcRequest<MENU_ID, SHEETS.SALES_PLAN_TITLE>;
  [SHEETS.BIZ_PLAN_TITLE]?: ProcRequest<MENU_ID, SHEETS.BIZ_PLAN_TITLE>;
}

interface DemandPlanWaterfallState {
  searchParams: SearchParams;
  filters: Filters;
  isOpenSearchArea: boolean;
  staticColumns: RawFlexGridColumnConfig[];
  /** [E20260831-MEASURE] 공통 메저 선택 — SHEET_MEASURE 메타 (활성 GUBUN 종속 PROGRAM 기준) */
  staticMeasures: MeasureMeta[];
  /** [E20260831-MEASURE] GUBUN 별 표시 메저 선택 (null = 전체 — MeasureSelectModal OK 결과) */
  visibleMeasures: Record<Gubun, string[] | null>;
  /**
   * ⭐ GUBUN 별 GRID COLUMN SET (ColumnLayoutModal OK 결과 — null = 미설정 = TITLE SP 기본).
   *   GUBUN 마다 PROGRAM_ID·SHEET_NAME 이 전부 다르므로 절대 공유하지 않는다.
   *   Division 변경 시에는 해당 GUBUN 만 null 로 되돌린다(SHEET_COLUMNS 가 division 별로 다름).
   */
  columnSettings: Record<Gubun, ColumnLayoutRow[] | null>;
  /** F6 저장 조회조건 복원 1회 가드 (탭 오픈당) — MotherStore PRESERVED_ON_CONDITION_RESET 보존 키 */
  initialized: boolean;
}

interface DemandPlanWaterfallAction {
  reset: () => void;
  /** [COND 2026-08-27] UI 오픈 시 F6 저장 조회조건(SCM_ADM_USER_MNU_SRCH_COND_M) 복원 — 정본 sales-future-price */
  restoreSearchConditions: () => Promise<void>;
  setSearchParams: (searchParams: Partial<SearchParams>) => void;
  setFilters: (input: { userId: string }) => boolean;
  setOpenSearchArea: (open?: boolean) => void;
  fetchStaticColumns: (input: {
    divisionId: string;
    sheetNm: string;
    /** [E20260831-METASHEET] 종속 PROGRAM_ID (SALES=DMF0022 / BIZ=DMF0051) — 미지정 = MENU_ID */
    programId?: string;
    /** 시드 대상 GUBUN (미지정 = 시드 안 함) */
    gubun?: Gubun;
    /** true = 기존 값이 있어도 **덮어쓴다**(화면 진입·division/GUBUN 변경). false/미지정 = 비어 있을 때만 */
    reseed?: boolean;
  }) => Promise<void>;
  /** [E20260831-MEASURE] SHEET_MEASURE 메타 fetch — 활성 GUBUN 의 종속 PROGRAM/메저 시트명 기준 */
  fetchStaticMeasures: (input: {
    divisionId: string;
    measureSheetNm: string;
    programId: string;
    /** 시드 대상 GUBUN (미지정 = 시드 안 함) */
    gubun?: Gubun;
    /** true = 기존 값이 있어도 **덮어쓴다**(화면 진입·division/GUBUN 변경). false/미지정 = 비어 있을 때만 */
    reseed?: boolean;
  }) => Promise<void>;
  /** [E20260831-MEASURE] MeasureSelectModal OK — GUBUN 별 표시 메저 적용 (null = 전체) */
  applyVisibleMeasures: (gubun: Gubun, codes: string[] | null) => void;
  /** ColumnLayoutModal OK — GUBUN 별 컬럼 표시/순서/폭/색 적용 (null = 미설정 복귀) */
  applyColumnSettings: (gubun: Gubun, rows: ColumnLayoutRow[] | null) => void;
  /** UM-01 (#59 §1.4) — Division 변경 = 조회 결과 비움 (AS-IS cboDivision_SelectedIndexChanged → InitSpread .cs:1397) */
  clearData: () => void;
  /**
   * UM-08 — bucket 경계 전환(AS-IS InitSpread .cs:1594~1610): 활성 GUBUN 의 메인 데이터는 비우고
   * 타이틀만 새 bucket 으로 즉시 재조회해 빈 그리드에 새 헤더를 그린다.
   */
  resetForBucket: (bucket: string) => void;
}

/** AS-IS PR_GET_DAY_RANGE(p_month=6) — 당월 1일 ~ +6개월 말일 (.cs:2101-2115) */
// [E20260831-PERIOD6M] AS-IS PR_GET_DAY_RANGE(p_month=6) 1:1 — FROM=당월 1일 / TO=FROM+6개월−1일.
//   구 구현 `dayjs().add(6,'month').endOf('month')` 는 "오늘+6개월 달의 말일"이라 최대 7개월 구간
//   (8월 실측: 2027-02-28 — 사용자 신고 W08/W35 "종료일자 잘못됨. 6개월").
//   forecast-price 2026-08-10 동일 함정 정정 선례(.add(6,'month') 하루 초과) 1:1.
const defaultPeriod = () => {
  const from = dayjs().startOf('month');
  return {
    startYyyymmdd: from.format('YYYYMMDD'),
    endYyyymmdd: from.add(6, 'month').subtract(1, 'day').format('YYYYMMDD'),
  };
};

const initSearchParams: SearchParams = {
  gubun: GUBUN.MKT_FCST, // 사용자 확정 — 초기값 MKT FCST
  divisionId: '',
  deptIds: [],
  endCustomers: [],
  salesSiteIds: [],
  plantSiteIds: [],
  bizTypes: [],
  itemTypes: [],
  projectCodes: [],
  itemIds: [],
  owners: [],
  // [E20260831-VERCUR] MKT 기본 버전 = 'CURRENT' (사용자 지시 2026-08-31 — SP 1급 값 실측: PKG_DMF0035 L645/L850)
  version: 'CURRENT',
  ...defaultPeriod(),
  bucket: BUCKET_TYPE.MONTHLY, // 3화면 공통 기본 MONTHLY (AS-IS .cs:430/445/318)
  senderCodes: [],
  isSumChecked: false,
  isCellQtyChecked: false,
  isQtyNotZeroChecked: false,
  krw: '1',
  usd: '1',
  loc: '1',
  qty: '1',
};

const initState: DemandPlanWaterfallState = {
  searchParams: initSearchParams,
  filters: {},
  isOpenSearchArea: true,
  staticColumns: [],
  staticMeasures: [],
  visibleMeasures: {
    [GUBUN.MKT_FCST]: null,
    [GUBUN.SALES_PLAN]: null,
    [GUBUN.BIZ_PLAN]: null,
  },
  columnSettings: {
    [GUBUN.MKT_FCST]: null,
    [GUBUN.SALES_PLAN]: null,
    [GUBUN.BIZ_PLAN]: null,
  },
  initialized: false,
};

/**
 * [COND 2026-08-27] 저장 조회조건 역파싱 키 분류 — 저장(GridAction.personalizeCondition)은 모든 값을
 * 문자열로 coerce(배열=콤마 join / 불리언=String)하므로 SearchParams 타입대로 되돌린다.
 * 저장돼 있어도 현재 SearchParams 에 없는 키(구버전 잔재)는 버린다.
 */
const ARRAY_KEYS = new Set<string>(
  Object.entries(initSearchParams)
    .filter(([, v]) => Array.isArray(v))
    .map(([k]) => k)
);
const BOOL_KEYS = new Set<string>(
  Object.entries(initSearchParams)
    .filter(([, v]) => typeof v === 'boolean')
    .map(([k]) => k)
);
const GUBUN_VALUES = new Set<string>(Object.values(GUBUN));

/**
 * 멀티 필터 → SP 규약: 빈 배열 = 'ALL' (⚠ '' 전달 시 SP 의 <> 'ALL' 분기가 빈 토큰으로
 * DELETE 전멸 — 빈 필터 NULL-LIKE 전멸 계보). 텍스트(LIKE) 항목은 '' = 전체.
 */
const orAll = (arr: string[]): string => (arr.length > 0 ? arr.join(',') : 'ALL');

/**
 * p_now(실적/계획 경계일) — AS-IS DMF0022 .cs:1077-1081 실측 산식 1:1:
 * 이번주 월요일, 단 from≥이번주월요일이면 from, to<now 면 to+1일.
 */
const calcNowYyyymmdd = (fromYyyymmdd: string, toYyyymmdd: string): string => {
  const today = dayjs();
  const monday = today.subtract((today.day() + 6) % 7, 'day');
  const from = dayjs(fromYyyymmdd, 'YYYYMMDD');
  const to = dayjs(toYyyymmdd, 'YYYYMMDD');
  let now = monday;
  if (!from.isBefore(monday, 'day')) now = from;
  if (to.isBefore(now, 'day')) now = to.add(1, 'day');
  return now.format('YYYYMMDD');
};

export const useDemandPlanWaterfallStore = createPersistedStoreWithTab<
  DemandPlanWaterfallState & DemandPlanWaterfallAction
>(
  (set, get) => ({
    ...initState,
    reset: () =>
      set(state => {
        state.searchParams = { ...initSearchParams, ...defaultPeriod() };
        state.filters = {};
        state.isOpenSearchArea = true;
        state.staticColumns = [];
      }),
    // ⭐ [COND 2026-08-27] F6 저장 조회조건 복원 — 탭 오픈 시 1회(initialized 가드). F10(Reset Condition) 은
    //   SubTitle 공통이 DB 삭제 + MotherStore.resetSearchCondition(reset() 후 initialized 보존) 으로 처리하므로
    //   초기화 직후 재복원되지 않는다. 저장조건 없음/조회 실패 = 기본값 유지.
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
          const val = paramCtn ?? '';
          if (ARRAY_KEYS.has(paramNm)) patch[paramNm] = val ? val.split(',').filter(Boolean) : [];
          else if (BOOL_KEYS.has(paramNm)) patch[paramNm] = val === 'true';
          else patch[paramNm] = val;
        }
        // 열거형 키는 유효값만 채택 (구버전 저장값·오염 방어)
        if (typeof patch.gubun === 'string' && !GUBUN_VALUES.has(patch.gubun)) delete patch.gubun;
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
        const fromYyyymmdd = p.startYyyymmdd;
        const toYyyymmdd = p.endYyyymmdd;
        const nowYyyymmdd = calcNowYyyymmdd(fromYyyymmdd, toYyyymmdd);

        // 공통 14 + 표준 감사 (userDeptId/groupId 는 AS-IS SP 본문 미사용 실측(dead) — 시그니처 유지용 빈값)
        const common = {
          divisionId: p.divisionId,
          deptId: orAll(p.deptIds),
          endCustomer: orAll(p.endCustomers),
          scmSiteId: orAll(p.salesSiteIds),
          projectCode: p.projectCodes.join(','),
          itemId: p.itemIds.join(','),
          itemType: orAll(p.itemTypes),
          fromYyyymmdd,
          toYyyymmdd,
          sesUserId: userId,
          plantSiteId: orAll(p.plantSiteIds),
          bizType: orAll(p.bizTypes),
          owner: p.owners.join(','),
          userId,
          menuId: MENU_ID,
        };

        const gubunFilters: Filters =
          p.gubun === GUBUN.MKT_FCST
            ? {
                [SHEETS.MKT_FCST]: {
                  ...common,
                  versionNo: p.version || 'CURRENT',
                  bucket: p.bucket,
                  cellYn: p.isCellQtyChecked ? 'Y' : 'N',
                  senderCode: p.divisionId === '81' ? orAll(p.senderCodes) : 'ALL',
                  userDeptId: '',
                  groupId: '',
                },
              }
            : p.gubun === GUBUN.SALES_PLAN
              ? {
                  [SHEETS.SALES_PLAN]: {
                    ...common,
                    nowYyyymmdd,
                    versionType: p.version,
                    bucket: p.bucket,
                    // AS-IS Designer Visible=false 정책 승계 — 미표시 고정값
                    internalYn: 'N',
                    cellYn: 'N',
                    userDeptId: '',
                    groupId: '',
                  },
                }
              : {
                  [SHEETS.BIZ_PLAN]: {
                    ...common,
                    nowYyyymmdd,
                    versionType: p.version,
                    cellYn: p.isCellQtyChecked ? 'Y' : 'N',
                    qtyYn: p.isQtyNotZeroChecked ? 'Y' : 'N',
                  },
                };

        const titleSheet = GUBUN_SHEET[p.gubun].title;
        const titleFilter = {
          divisionId: p.divisionId,
          bucket: p.bucket,
          fromYyyymmdd,
          toYyyymmdd,
          sesUserId: userId,
          userId,
        };

        const newFilters: Filters = {
          ...state.filters,
          ...gubunFilters,
          [titleSheet]: titleFilter,
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
    // [E20260831-METASHEET] 메타 조회 = AS-IS 시트명 + 종속 PROGRAM_ID 경로 (GUBUN_META — constants 주석 참조).
    //   programId 미지정 시 기존 동작(MENU_ID) 유지.
    fetchStaticColumns: async ({ divisionId, sheetNm, programId, gubun, reseed }) => {
      const result = await apiClient.post<RawFlexGridColumnConfig[]>(
        `/admin/menu/${programId ?? MENU_ID}/column`,
        { sheetNm, divisionId }
      );
      set(state => {
        state.staticColumns = result.data.result;
        // ⭐ [E20260904-METASEED] 모달을 열지 않아도 **사용자·division 별 저장 설정이 첫 조회부터 적용**되게 한다
        //   (사용자 신고 2026-09-04). 이 응답의 `display` 는 개인화(titleset 'C')가 반영된 값이라
        //   Column Setting 모달이 보여주는 것과 같은 원천이다 — 그래서 모달 없이도 그리드가 일치한다.
        //   이미 사용자가 이번 세션에서 지정한 값이 있으면 덮지 않는다(null 일 때만 시드).
        //   ⚠ `reseed` 가 필요한 이유: 이 스토어는 탭을 닫아도 값이 남는다. 재오픈 시 "비어 있을 때만"
        //   채우면 **이전 세션의 선택이 서버 저장분을 이긴다**(사용자 신고 2026-09-04 — 모달을 열면 3개인데
        //   안 열고 조회하면 직전 2개로 조회). 화면 진입·division/GUBUN 변경에서는 항상 서버값으로 되돌린다.
        if (gubun && (reseed || state.columnSettings[gubun] == null)) {
          state.columnSettings[gubun] = toColumnLayoutSettings(result.data.result);
        }
      });
    },
    // [E20260831-MEASURE] SHEET_MEASURE fetch — DMF0003 정본형(/admin/menu/{pgm}/measure). SALES 는 메저 시트명이
    //   컬럼 축과 다름('Sales Plan Waterfall' — GUBUN_META.measureSheetNm 실측 표기).
    fetchStaticMeasures: async ({ divisionId, measureSheetNm, programId, gubun, reseed }) => {
      const result = await apiClient.post<MeasureMeta[]>(`/admin/menu/${programId}/measure`, {
        sheetNm: measureSheetNm,
        divisionId,
      });
      set(state => {
        const measures = result.data.result ?? [];
        state.staticMeasures = measures;
        // ⭐ [E20260904-METASEED] 위와 같은 이유 — `display` 가 곧 Measure 모달의 우측(표시) 집합이다.
        //   시드하지 않으면 필터가 무효(null)라 SP 가 덧붙인 종속 메저까지 전부 그려져
        //   "모달 열고 OK 해야 반영된다"로 보인다(실측: div81 저장 2종 + 종속 3종 = 5종 표시).
        if (gubun && (reseed || state.visibleMeasures[gubun] == null)) {
          const shown = measures.filter(m => m.display !== false).map(m => m.colNm);
          if (shown.length > 0) state.visibleMeasures[gubun] = shown;
        }
      });
    },
    applyVisibleMeasures: (gubun, codes) =>
      set(state => {
        state.visibleMeasures[gubun] = codes;
      }),
    applyColumnSettings: (gubun, rows) =>
      set(state => {
        state.columnSettings[gubun] = rows;
      }),
    clearData: () =>
      set(state => {
        state.filters = {};
      }),
    resetForBucket: bucket =>
      set(state => {
        const { main, title } = GUBUN_SHEET[state.searchParams.gubun];
        const current = state.filters as Record<string, unknown>;
        const titleFilter = current[title] as Record<string, unknown> | undefined;
        const next: Record<string, unknown> = { ...current };
        delete next[main];
        if (titleFilter) next[title] = { ...titleFilter, bucket };
        state.filters = next as Filters;
      }),
  }),
  'demand-plan-waterfall'
);

/** GUBUN 전환 시 리셋 값 — 버킷 체계 스왑(M/Q/Y ↔ D/W/M/OW) + 버전·전용 조건 클리어 */
export const gubunResetParams = (gubun: SearchParams['gubun']): Partial<SearchParams> => ({
  gubun,
  // [E20260831-VERCUR] waterfall type 변경 시 버전 초기값 = 'CURRENT' (전 타입 — 사용자 지시 2026-08-31 2차.
  //   1차는 MKT 한정이었으나 "변경 시 초기값 CURRENT" 로 전 타입 확정. SALES/BIZ 는 팝업으로 교체 선택 가능)
  version: 'CURRENT',
  senderCodes: [],
  isQtyNotZeroChecked: false,
  isCellQtyChecked: false,
  bucket: gubun === GUBUN.BIZ_PLAN ? BUCKET2_TYPE.MONTHLY : BUCKET_TYPE.MONTHLY,
  // [E20260831-PERIOD6M] waterfall type 변경 시 PERIOD 도 6개월 초기값 재설정 (사용자 지시 2026-08-31)
  ...defaultPeriod(),
});
