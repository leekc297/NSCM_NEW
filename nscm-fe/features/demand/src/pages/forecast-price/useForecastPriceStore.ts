import { apiClient } from '@foundation/apis';
import dayjs from '@foundation/dayjs';
import type { FlexGridColumnConfig, RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab, useSessionStore } from '@shared/stores';

import { MENU_ID, SAVE_PRICE_META_SHEET, SHEETS } from './forecast-price.constants';
import type {
  CalendarRow,
  MeasureAuthRow,
  MonthInfoRow,
  SearchParamProps,
} from './forecast-price.types';

/** SCM_MST_SHEET_MEASURE 동적 fetch row — /admin/menu/{MENU_ID}/measure (camelCase). */
export interface MeasureMeta {
  colNm: string;
  colLblNm?: string;
  sClsLblNm?: string;
  // ⚠️ BE GridMeasure DTO 는 DISPLAY_FLAG/USER_SELECTABLE_FLAG 를 boolean(true/false) 으로 직렬화한다.
  //    (구: string 'Y'/'N' 로 오선언 → 모달이 === 'Y' 비교 시 전부 false → Visible 그리드 0개 사고)
  display?: boolean;
  personalizable?: boolean;
  sortOrd?: number;
}

interface ForecastPriceState {
  searchParams: SearchParamProps;
  filters?: ProcRequest<MENU_ID, SHEETS.FCST_N_PRICE_40>;
  titleFilters?: ProcRequest<MENU_ID, SHEETS.SPREAD_TITLE>;
  isOpenSearchArea: boolean;
  staticColumns: RawFlexGridColumnConfig[];
  staticMeasures: MeasureMeta[];
  dateColumns: FlexGridColumnConfig[];
  // ⭐ measure 별 편집권한 (GET drop3 커서 — AS-IS bEDIT_AUTH_SCM_FCST/MKT_FCST/LOC/VMI_IN_REQ 1:1).
  //   key=MEASURE, value=EDIT_FLAG==='Y'. 조회 응답 갱신 시 setMeasureAuth 로 반영.
  measureAuth: Record<string, boolean>;
  // 현재 주차 binding (GET drop2 THIS_YYYYMMWW) — 과거 잠금 경계 산출 입력.
  thisYyyymmww: string;
  // ⭐ 배분 캘린더 (GET drop4=O_RC5) — 'D_YYYYMMDD' → {monthDayCnt, weekDayCnt}. 월(M_) 배분(#1) 입력.
  calendar: Record<string, { monthDayCnt: number; weekDayCnt: number }>;
  // ⭐ M+3 기준월 'YYYYMM' (GET drop1=O_RC2 첫 행 M3_CUTOFF_DATE) — M+4 월잠금(#4) 입력.
  m3CutoffYyyymm: string;
  // ⭐ SavePricePeriodModal 고정 컬럼 메타 (SHEET_NAME='Sales Price Save All' 25 컬럼 —
  //   admin UI Category Setup 동적 fetch, hook ui-category-setup-column-meta).
  savePriceColumns: RawFlexGridColumnConfig[];
}

interface ForecastPriceAction {
  reset: () => void;
  setSearchParams: (searchParams: Partial<SearchParamProps>) => void;
  setFilters: () => boolean;
  setOpenSearchArea: (open?: boolean) => void;
  fetchStaticColumns: () => void;
  fetchStaticMeasures: () => void;
  fetchSavePriceColumns: (divisionId: string) => void;
  setStaticColumns: (staticColumns: RawFlexGridColumnConfig[]) => void;
  setDateColumns: (dateColumns: FlexGridColumnConfig[]) => void;
  setMeasureAuth: (rows: MeasureAuthRow[]) => void;
  setThisYyyymmww: (v: string) => void;
  setCalendar: (rows: CalendarRow[]) => void;
  setM3Cutoff: (rows: MonthInfoRow[]) => void;
}

const initSearchParams: SearchParamProps = {
  divisionId: '40',
  deptIds: [],
  endCustomers: [],
  salesSites: [],
  bizTypes: [],
  itemIds: [],
  // ⭐ 2026-07-23 조회조건 AS-IS 정합 — AS-IS PR_GET_DAY_RANGE(p_month=6) 1:1:
  //   해당 월 1일 ~ (+6개월 시점 월의 1일 - 1일). (구: 당일~+6개월 당일 — DMF0003 P6 동형 차이)
  startYyyymmdd: dayjs().startOf('month').format('YYYYMMDD'),
  endYyyymmdd: dayjs().add(6, 'month').startOf('month').subtract(1, 'day').format('YYYYMMDD'),
  bucketType: 'W',
  versionType: 'Current',
  qtyYn: false,
  sumYn: false,
};

const initState: ForecastPriceState = {
  searchParams: initSearchParams,
  isOpenSearchArea: true,
  staticColumns: [],
  staticMeasures: [],
  dateColumns: [],
  measureAuth: {},
  thisYyyymmww: '',
  calendar: {},
  m3CutoffYyyymm: '',
  savePriceColumns: [],
};

// 멀티선택 → SP 파라미터: ⚠️ DMF0082 는 콤마 구분 (PKG_DMF0082 REGEXP_SUBSTR '[^,]+' 실측).
//   빈 배열 = 'ALL' (AS-IS 전체 조회 sentinel).
const joinComma = (arr: string[]): string => (arr.length === 0 ? 'ALL' : arr.join(','));

export const useForecastPriceStore = createPersistedStoreWithTab<
  ForecastPriceState & ForecastPriceAction
>(
  (set, get) => ({
    ...initState,
    reset: () => set(initState),
    setSearchParams: searchParams => {
      set(state => {
        state.searchParams = { ...get().searchParams, ...searchParams };
      });
    },
    setFilters: () => {
      // AS-IS L1727~1738 1:1 — p_created_by=UserId / p_user_group=NowGroupID.
      //   To-Be 세션 groupId 부재 시 USER_ID fallback (GET_ADMIN_GROUP lookup 이 USER_ID row 보유).
      const sesUserId = useSessionStore.getState().session.userId ?? '';
      const userGroup = useSessionStore.getState().session.groupId || sesUserId;
      // persist rehydrate 가 구버전 shape 일 수 있어 기본값 머지로 완전한 조회조건 보장.
      const sp: SearchParamProps = { ...initSearchParams, ...get().searchParams };

      const newFilters: ProcRequest<MENU_ID, SHEETS.FCST_N_PRICE_40> = {
        divisionId: sp.divisionId,
        deptId: joinComma(sp.deptIds),
        endCustomer: joinComma(sp.endCustomers),
        bizType: joinComma(sp.bizTypes),
        fromYyyymmdd: sp.startYyyymmdd,
        toYyyymmdd: sp.endYyyymmdd,
        salesSite: joinComma(sp.salesSites),
        itemId: sp.itemIds.length === 0 ? '' : sp.itemIds.join(','),
        versionType: sp.versionType,
        qtyYn: sp.qtyYn ? 'Y' : 'N',
        sesUserId,
        userGroup,
      };
      const newTitleFilters: ProcRequest<MENU_ID, SHEETS.SPREAD_TITLE> = {
        startYyyymmdd: sp.startYyyymmdd,
        endYyyymmdd: sp.endYyyymmdd,
        sesUserId,
        divisionId: sp.divisionId,
      };

      const isSame =
        JSON.stringify(get().filters) === JSON.stringify(newFilters) &&
        JSON.stringify(get().titleFilters) === JSON.stringify(newTitleFilters);

      set(state => {
        state.filters = newFilters;
        state.titleFilters = newTitleFilters;
      });
      return isSame;
    },
    setOpenSearchArea: open => {
      set(state => {
        state.isOpenSearchArea = open ?? !state.isOpenSearchArea;
      });
    },
    fetchStaticColumns: () => {
      void (async () => {
        try {
          const result = await apiClient.post<RawFlexGridColumnConfig[]>(
            `/admin/menu/${MENU_ID}/column`,
            {
              sheetNm: SHEETS.FCST_N_PRICE_40,
              divisionId: get().searchParams.divisionId,
            }
          );
          set(state => {
            state.staticColumns = result.data.result;
          });
        } catch {
          /* 메타 미적재 시 빈 배열 유지 — 화면은 fallback 없이 메타 주도 */
        }
      })();
    },
    fetchStaticMeasures: () => {
      void (async () => {
        try {
          // SHEET_MEASURE 등록명 = 'fcstNPrice' (2026-07-12 대소문자 통일 — titleSet 43명 기준)
          const result = await apiClient.post<MeasureMeta[]>(`/admin/menu/${MENU_ID}/measure`, {
            sheetNm: 'FcstNPrice',
            divisionId: get().searchParams.divisionId,
          });
          set(state => {
            state.staticMeasures = result.data.result;
          });
        } catch {
          /* SCM_MST_SHEET_MEASURE 14종 등록 확인(실측) — 실패 시 빈 배열 */
        }
      })();
    },
    // ⭐ SavePricePeriodModal 고정 컬럼 — division 필터는 SP(PR_GET_SHEET_COLUMN_LIST) 서버측
    //   (DMF0020 fetchBatchColumns 선례 동일. 실패 시 빈 배열 유지 → modal fallback 컬럼 사용).
    fetchSavePriceColumns: divisionId => {
      void (async () => {
        try {
          const result = await apiClient.post<RawFlexGridColumnConfig[]>(
            `/admin/menu/${MENU_ID}/column`,
            {
              sheetNm: SAVE_PRICE_META_SHEET,
              divisionId,
            }
          );
          set(state => {
            state.savePriceColumns = result.data.result;
          });
        } catch {
          /* 메타 미적재 시 빈 배열 유지 — modal 이 FALLBACK_FIXED 사용 */
        }
      })();
    },
    setStaticColumns: staticColumns => {
      set({ staticColumns });
    },
    setDateColumns: dateColumns => {
      set({ dateColumns });
    },
    setMeasureAuth: rows => {
      // drop3 실측 컬럼 = EDIT_AUTH_YN (요일제한 TODAY_* 는 PKG 가 행별 EDIT_FLAG 에 종합 반영).
      const auth: Record<string, boolean> = {};
      rows.forEach(r => {
        const m = typeof r.MEASURE === 'string' ? r.MEASURE : '';
        if (m) auth[m] = (r.EDIT_AUTH_YN ?? '') === 'Y';
      });
      set(state => {
        state.measureAuth = auth;
      });
    },
    setThisYyyymmww: v => {
      set(state => {
        state.thisYyyymmww = v;
      });
    },
    // drop4 (O_RC5) → 'D_YYYYMMDD' 키 배분 캘린더 맵.
    setCalendar: rows => {
      const cal: Record<string, { monthDayCnt: number; weekDayCnt: number }> = {};
      rows.forEach(r => {
        const ymd = typeof r.BASIS_YYYYMMDD === 'string' ? r.BASIS_YYYYMMDD : '';
        if (ymd.length !== 8) return;
        cal[`D_${ymd}`] = {
          monthDayCnt: Number(r.MONTH_DAY_CNT ?? 0) || 0,
          weekDayCnt: Number(r.WEEK_DAY_CNT ?? 0) || 0,
        };
      });
      set(state => {
        state.calendar = cal;
      });
    },
    // drop1 (O_RC2) 첫 행 M3_CUTOFF_DATE 앞 6자리 = M+4 잠금 경계월.
    setM3Cutoff: rows => {
      const first = rows[0];
      const cutoff = typeof first?.M3_CUTOFF_DATE === 'string' ? first.M3_CUTOFF_DATE.slice(0, 6) : '';
      set(state => {
        state.m3CutoffYyyymm = cutoff;
      });
    },
  }),
  'forecast-price'
);
