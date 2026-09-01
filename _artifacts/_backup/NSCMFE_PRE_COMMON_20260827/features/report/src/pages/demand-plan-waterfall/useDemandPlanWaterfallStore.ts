import { apiClient } from '@foundation/apis';
import dayjs from '@foundation/dayjs';
import _ from '@foundation/lodash';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab } from '@shared/stores';

import { BUCKET_TYPE, BUCKET2_TYPE, GUBUN, GUBUN_SHEET, MENU_ID, SHEETS } from './demand-plan-waterfall.constants';
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
}

interface DemandPlanWaterfallAction {
  reset: () => void;
  setSearchParams: (searchParams: Partial<SearchParams>) => void;
  setFilters: (input: { userId: string }) => boolean;
  setOpenSearchArea: (open?: boolean) => void;
  fetchStaticColumns: (input: { divisionId: string; sheetNm: string }) => Promise<void>;
}

/** AS-IS PR_GET_DAY_RANGE(p_month=6) — 당월 1일 ~ +6개월 말일 (.cs:2101-2115) */
const defaultPeriod = () => ({
  startYyyymmdd: dayjs().startOf('month').format('YYYYMMDD'),
  endYyyymmdd: dayjs().add(6, 'month').endOf('month').format('YYYYMMDD'),
});

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
  version: '',
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
  rowTotals: 'GrandTotals', // AS-IS footer SUM 대응 기본값
};

const initState: DemandPlanWaterfallState = {
  searchParams: initSearchParams,
  filters: {},
  isOpenSearchArea: true,
  staticColumns: [],
};

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
  set => ({
    ...initState,
    reset: () =>
      set(state => {
        state.searchParams = { ...initSearchParams, ...defaultPeriod() };
        state.filters = {};
        state.isOpenSearchArea = true;
        state.staticColumns = [];
      }),
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
    fetchStaticColumns: async ({ divisionId, sheetNm }) => {
      const result = await apiClient.post<RawFlexGridColumnConfig[]>(
        `/admin/menu/${MENU_ID}/column`,
        { sheetNm, divisionId }
      );
      set(state => {
        state.staticColumns = result.data.result;
      });
    },
  }),
  'demand-plan-waterfall'
);

/** GUBUN 전환 시 리셋 값 — 버킷 체계 스왑(M/Q/Y ↔ D/W/M/OW) + 버전·전용 조건 클리어 */
export const gubunResetParams = (gubun: SearchParams['gubun']): Partial<SearchParams> => ({
  gubun,
  version: '',
  senderCodes: [],
  isQtyNotZeroChecked: false,
  isCellQtyChecked: false,
  bucket: gubun === GUBUN.BIZ_PLAN ? BUCKET2_TYPE.MONTHLY : BUCKET_TYPE.MONTHLY,
});
