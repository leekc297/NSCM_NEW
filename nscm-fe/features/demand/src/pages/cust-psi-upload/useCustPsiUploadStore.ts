import { apiClient } from '@foundation/apis';
import dayjs from '@foundation/dayjs';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab, useSessionStore } from '@shared/stores';

import { BUCKET_TYPE, MENU_ID, SHEETS } from './cust-psi-upload.constant';
import type { SearchParamProps } from './cust-psi-upload.types';

// SP filter payload — useTabProcQuery enabled 가드
//   MAIN = DM.DMF0013_GET_CUST_PSI_UPLOAD_DATA / SPREAD_TITLE = 공유 DM.DMF0014_GET_SPREAD_TITLE
//   DAY_RANGE = PR_GET_DAY_RANGE (기본 조회구간 — AS-IS GetDayRange p_month=6)
type FiltersBySheet = {
  [SHEETS.MAIN]?: ProcRequest<MENU_ID, SHEETS.MAIN>;
  [SHEETS.SPREAD_TITLE]?: ProcRequest<MENU_ID, SHEETS.SPREAD_TITLE>;
};

interface CustPsiUploadState {
  initialized: boolean;
  isOpenSearchArea: boolean;
  searchParams: SearchParamProps;
  filters: FiltersBySheet;
  staticColumn: RawFlexGridColumnConfig[];
  // PR_GET_DAY_RANGE 기본 Period 적용 1회성 (persist — 탭 재진입 remount 시
  //   사용자가 변경한 Period 를 서버 기본값이 다시 덮지 않도록. DMF0048 A-4 선례)
  dayRangeApplied: boolean;
}

interface CustPsiUploadAction {
  reset: () => void;
  setOpenSearchArea: (open?: boolean) => void;
  setSearchParams: (searchParams: Partial<SearchParamProps>) => void;
  setFilters: () => void;
  clearFilters: () => void;
  fetchStaticColumns: () => Promise<void>;
  applyDayRange: (range: string | undefined) => void;
}

// Period 조회조건 초기값 — MktFcst(DMF0003)/CustomerFcstUpload(DMF0014) 기본값과 동일 규칙.
//   PR_GET_DAY_RANGE(p_month=6) o_rc2 = "당월 1일 ~ 6개월째 되는 달의 말일" 을 FE 에서 계산.
//   toISOString(UTC) 금지 — dayjs = 로컬 날짜 (DMF0048 A-3 선례).
export const CUST_PSI_UPLOAD_INIT_PERIOD = {
  start: dayjs().startOf('month').format('YYYYMMDD'),
  end: dayjs().startOf('month').add(6, 'month').subtract(1, 'day').format('YYYYMMDD'),
};
const { start: monthStart, end: sixMonthEnd } = CUST_PSI_UPLOAD_INIT_PERIOD;

const initCustPsiUploadState: CustPsiUploadState = {
  initialized: false,
  isOpenSearchArea: true,
  searchParams: {
    divisionId: useSessionStore.getState().session.div ?? '40',
    team: '',
    endCustomer: '',
    salesSite: '',
    project: '',
    plantSite: '',
    modelNickname: '',
    customsHandbook: '',
    startYyyymmdd: monthStart,
    endYyyymmdd: sixMonthEnd,
    bucket: BUCKET_TYPE.WEEKLY, // AS-IS DefineProperty cboBucketType = WEEKLY (원장 §E01 1.2)
  },
  filters: {},
  staticColumn: [],
  dayRangeApplied: false,
};

export const useCustPsiUploadStore = createPersistedStoreWithTab<
  CustPsiUploadState & CustPsiUploadAction
>(
  (set, get) => ({
    ...initCustPsiUploadState,
    reset: () => set(initCustPsiUploadState),
    setOpenSearchArea: open => {
      set(state => {
        state.isOpenSearchArea = open ?? !state.isOpenSearchArea;
      });
    },
    setSearchParams: searchParams => {
      set(state => {
        state.searchParams = { ...get().searchParams, ...searchParams };
      });
    },
    setFilters: () => {
      // 키명 = PROC_M COL_NM. 구분자 = 콤마 (FN_SCM_GET_WHERE_SQL: 'A,B' → IN('A','B') / 'ALL'·NULL → 조건 생략).
      //   콤보 멀티 빈값 = 'ALL' sentinel, 텍스트(project/modelNickname) 빈값 = '' 그대로.
      //   createdBy/sesUserId/mnuId 는 BE 세션 자동(보강 전송).
      const sesUserId = useSessionStore.getState().session.userId ?? '';
      // AS-IS p_userinfo = NowGroupID — 세션 groupId 미구현 시 USER_ID fallback
      const userinfo = useSessionStore.getState().session.groupId || sesUserId;
      set(state => {
        const p = state.searchParams;
        const orAll = (v: string): string => (v && v.trim() !== '' ? v : 'ALL');
        state.filters = {
          // ── DM.DMF0013_GET_CUST_PSI_UPLOAD_DATA (13 IN + 세션 2) — 원장 §E10 L435~448 ──
          [SHEETS.MAIN]: {
            divisionId: p.divisionId, // 1  P_DIVISION_ID (단일 필수 — validateFind 가드)
            deptId: orAll(p.team), // 2  P_DEPT_ID (Team)
            endCustomer: orAll(p.endCustomer), // 3  P_END_CUSTOMER
            scmSiteId: orAll(p.salesSite), // 4  P_SCM_SITE_ID (Sales Site)
            plantSiteId: orAll(p.plantSite), // 5  P_PLANT_SITE_ID
            projectCode: p.project, // 6  P_PROJECT_CODE (AS-IS txtProject.Text raw)
            itemId: p.modelNickname, // 7  P_ITEM_ID (AS-IS txtItemId.Text raw)
            startYyyymmdd: p.startYyyymmdd, // 8  P_START_YYYYMMDD
            endYyyymmdd: p.endYyyymmdd, // 9  P_END_YYYYMMDD
            bucketType: p.bucket, // 10 P_BUCKET_TYPE ('DAILY'/'WEEKLY'/'MONTHLY' full-word)
            domExp: orAll(p.customsHandbook), // 11 P_DOM_EXP (Customs Handbook)
            createdBy: sesUserId, // 12 P_CREATED_BY (BE 자동 — 보강 전송)
            userinfo, // 13 P_USERINFO (AS-IS NowGroupID)
            sesUserId, // 14 P_USER_ID (BE 자동)
            mnuId: MENU_ID, // 15 P_MENU_ID (BE 자동)
          },
          // ── 공유 DM.DMF0014_GET_SPREAD_TITLE (3 IN + 세션 2) — 동적 기간 헤더 ──
          [SHEETS.SPREAD_TITLE]: {
            startYyyymmdd: p.startYyyymmdd,
            endYyyymmdd: p.endYyyymmdd,
            bucketType: p.bucket,
            sesUserId,
            mnuId: MENU_ID,
          },
        };
      });
    },
    clearFilters: () =>
      set(state => {
        state.filters = {};
      }),

    // ui-dynamic-property-management — Column 동적 fetch (SCM_MST_SHEET_COLUMNS, admin 즉시 반영)
    fetchStaticColumns: async () => {
      try {
        const result = await apiClient.post<RawFlexGridColumnConfig[]>(
          `/admin/menu/${MENU_ID}/column`,
          {
            sheetNm: SHEETS.MAIN, // 'PSI Upload' — 등록명 그대로
          }
        );
        set(state => {
          state.staticColumn = result.data.result ?? [];
          state.initialized = true;
        });
      } catch {
        // BE 메타 미응답 시 silent fallback — MAIN_COLUMNS 하드코딩 유지 (console 금지 룰)
      }
    },

    // PR_GET_DAY_RANGE o_rc2 DAY_RANGE('yyyymmdd:yyyymmdd') → 기본 Period (AS-IS drpPeriod.InitValue)
    applyDayRange: range => {
      if (!range || !/^\d{8}:\d{8}$/.test(range)) return;
      if (get().dayRangeApplied) return;
      const [start, end] = range.split(':');
      set(state => {
        state.searchParams = {
          ...state.searchParams,
          startYyyymmdd: start,
          endYyyymmdd: end,
        };
        state.dayRangeApplied = true;
      });
    },
  }),
  'cust-psi-upload'
);
