import type { MeasureMeta } from 'features/master/src/components';

import { apiClient } from '@foundation/apis';
import dayjs from '@foundation/dayjs';
import _ from '@foundation/lodash';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab } from '@shared/stores';

import { BUCKET_TYPE, MENU_ID, SHEETS } from './cust-fcst-waterfall.constants';
import type { SearchParams } from './cust-fcst-waterfall.types';

interface Filters {
  [SHEETS.MAIN]?: ProcRequest<MENU_ID, SHEETS.MAIN>;
  [SHEETS.SPREAD_TITLE]?: ProcRequest<MENU_ID, SHEETS.SPREAD_TITLE>;
}

interface CustFcstWaterfallState {
  searchParams: SearchParams;
  filters: Filters;
  isOpenSearchArea: boolean;
  staticColumns: RawFlexGridColumnConfig[];
  staticMeasures: MeasureMeta[];
}

interface CustFcstWaterfallAction {
  reset: () => void;
  setSearchParams: (searchParams: Partial<SearchParams>) => void;
  setFilters: (input: { userId: string }) => boolean;
  setOpenSearchArea: (open?: boolean) => void;
  fetchStaticColumns: (input: { divisionId: string }) => Promise<void>;
  fetchStaticMeasures: (input: { divisionId: string }) => Promise<void>;
  /** ColumnLayoutModal onSave — 표시/순서/폭/색을 staticColumns 에 즉시 반영 (DMF0040 계보). */
  applyColumnLayout: (
    settings: { colNm: string; visible: boolean; width?: number; cellColor?: string; textColor?: string; order?: number }[]
  ) => void;
  /** UC-03 / hook #132 §2-2 — 설정 저장 시 기존 조회 데이터 Reset (그리드 비움, Search 로 재조회). */
  clearData: () => void;
}

/** AS-IS PR_GET_DAY_RANGE — Period p_month=6 / Input Date p_month=1 (.cs GetDayRange L1534~1554) */
const defaultPeriod = () => ({
  startYyyymmdd: dayjs().startOf('month').format('YYYYMMDD'),
  endYyyymmdd: dayjs().add(6, 'month').endOf('month').format('YYYYMMDD'),
  fromCreateYyyymmdd: dayjs().startOf('month').format('YYYYMMDD'),
  toCreateYyyymmdd: dayjs().add(1, 'month').endOf('month').format('YYYYMMDD'),
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
  ...defaultPeriod(),
  bucket: BUCKET_TYPE.MONTHLY, // AS-IS DefineProperty L374
  qty: '1',
  isSumChecked: false, // AS-IS chkSum.Checked=false (L323)
};

const initState: CustFcstWaterfallState = {
  searchParams: initSearchParams,
  filters: {},
  isOpenSearchArea: true,
  staticColumns: [],
  staticMeasures: [],
};

/** 멀티 필터 → SP 규약: 빈 배열 = 'ALL' (빈 토큰 전멸 계보 — DMF0035/DMF0040 orAll 동일) */
const orAll = (arr: string[]): string => (arr.length > 0 ? arr.join(',') : 'ALL');

export const useCustFcstWaterfallStore = createPersistedStoreWithTab<
  CustFcstWaterfallState & CustFcstWaterfallAction
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
        const newFilters: Filters = {
          // PKG_DMF0053.P_DMF0053_GET_CUST_FCST_WATERFALL — PROC_M positional 21 (seed_meta.sql 실측)
          // P_USER_DEPT_ID/P_GROUP_ID/P_USER_ID/P_MENU_ID 는 BODY 미사용 실측 — 파리티 안전값 전달
          [SHEETS.MAIN]: {
            divisionId: p.divisionId,
            deptId: orAll(p.deptIds),
            endCustomer: orAll(p.endCustomers),
            scmSiteId: orAll(p.salesSiteIds),
            projectCode: p.projectCodes.join(','),
            itemId: p.itemIds.join(','),
            itemType: orAll(p.itemTypes),
            fromYyyymmdd: p.startYyyymmdd,
            toYyyymmdd: p.endYyyymmdd,
            sesUserId: userId,
            plantSiteId: orAll(p.plantSiteIds),
            bizType: orAll(p.bizTypes),
            owner: p.owners.join(','),
            bucket: p.bucket,
            userDeptId: '',
            groupId: '',
            versionNo: '', // Version 조회조건 미구현 (AS-IS 숨김 — E21/E22)
            fromCreatedate: p.fromCreateYyyymmdd,
            toCreatedate: p.toCreateYyyymmdd,
            userId,
            mnuId: MENU_ID,
          },
          [SHEETS.SPREAD_TITLE]: {
            startYyyymmdd: p.startYyyymmdd,
            endYyyymmdd: p.endYyyymmdd,
            sesUserId: userId,
            divisionId: p.divisionId,
            bucket: p.bucket,
            userId,
            mnuId: MENU_ID,
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
    // ⭐ 정적 컬럼 = 서버 직접 비교 (#113 — divisionId 전송·division 변경 시 재fetch. 정본 DMF0021/DMF0040)
    fetchStaticColumns: async ({ divisionId }) => {
      const result = await apiClient.post<RawFlexGridColumnConfig[]>(
        `/admin/menu/${MENU_ID}/column`,
        { sheetNm: 'CUST Fcst Waterfall', divisionId }
      );
      set(state => {
        // 정적 컬럼은 1단 헤더 — AS-IS 는 3행 헤더에서 정적 컬럼을 세로 병합해 1단으로 보였다.
        //   메타 SMALL/LARGE 가 라벨과 다른 행(PROJECT_NAME/DMS_* 등)이 있으면 foundation getColumnDepth 가
        //   2단으로 판정해 정적 컬럼까지 2단으로 벌어지므로 라벨로 정규화한다 (사용자 지시 2026-08-27).
        state.staticColumns = (result.data.result ?? []).map(col => ({
          ...col,
          sClsLblNm: col.colLblNm,
          lClsLblNm: col.colLblNm,
        }));
      });
    },
    // ⭐ Measure 목록 (SCM_MST_SHEET_MEASURE PROGRAM_ID='DMF0053' — 기시딩 2행 CUST_FCST/CUST_FCST_EDI)
    fetchStaticMeasures: async ({ divisionId }) => {
      try {
        const result = await apiClient.post<MeasureMeta[]>(`/admin/menu/${MENU_ID}/measure`, {
          sheetNm: 'CUST Fcst Waterfall',
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
        const bySetting = new Map(settings.map(s => [s.colNm, s]));
        const next = state.staticColumns.map(c => {
          const s = bySetting.get(c.colNm);
          if (!s) return c;
          return {
            ...c,
            visible: s.visible,
            display: s.visible,
            ...(s.width ? { colWth: s.width } : {}),
            ...(s.cellColor !== undefined ? { cellColor: s.cellColor } : {}),
            ...(s.textColor !== undefined ? { textColor: s.textColor } : {}),
          };
        });
        const order = new Map(settings.map((s, i) => [s.colNm, s.order ?? i]));
        next.sort((a, b) => (order.get(a.colNm) ?? 9999) - (order.get(b.colNm) ?? 9999));
        state.staticColumns = next;
      }),
    clearData: () =>
      set(state => {
        state.filters = {};
      }),
  }),
  'cust-fcst-waterfall'
);
