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
  // ⭐ P_USERINFO 권한 그룹 (CMBO 'FcstPriceUserAuthGroup' 1행) — 세션 groupId 유령 필드 대체.
  //   2026-07-15 sales-plan(DMF0021) 선례. 미매칭 시 '' → setFilters 가 userId fallback.
  authGroup: string;
  /**
   * ⭐ 로그인 사용자가 'DM Planner (W/S)' 그룹인가 (CMBO 'MktFcstWsPlannerYn' 단일행 CODE='Y'/'N').
   *   authGroup 과 용도가 다르다 — authGroup 은 ADMIN 우선 **단일** 그룹이라 겸직자가 ADMIN 으로
   *   해석되면 W/S 판정이 무너진다. 이 값은 소속 여부만 직접 묻는다 (mkt-fcst 선례 동일 CMBO).
   *   용도: AS_In_Req measure 개방 / FCST Type W/S 후보 자격 판정.
   */
  wsPlannerYn: boolean;
  // ⭐ 저장된 컬럼 개인화 (titleSet 'C') — 표시/순서 + width/색상.
  //   저장 이력이 없으면 null → 서버 메타 기본값 그대로 사용.
  userColumnLayout: ColumnLayoutSetting[] | null;
  // ⭐ 개인화 적용 전 admin 메타 원본 — 팝업 Default 버튼의 원복 기준.
  //   staticColumns 는 개인화로 mutate 되므로 별도 스냅샷이 필요하다.
  originalStaticColumns: RawFlexGridColumnConfig[];
}

/** ColumnLayoutModal 개인화 1행 — 표시/순서/폭/색. */
export interface ColumnLayoutSetting {
  colNm: string;
  visible: boolean;
  width: number;
  cellColor: string;
  textColor: string;
  order: number;
}

interface ForecastPriceAction {
  reset: () => void;
  setSearchParams: (searchParams: Partial<SearchParamProps>) => void;
  setFilters: () => boolean;
  /** 조회조건 무효화 — division 전환 시 이전 division 조회결과가 그리드에 잔존하는 것을 막는다. */
  clearFilters: () => void;
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
  setAuthGroup: (group: string) => void;
  setWsPlannerYn: (yn: boolean) => void;
  /** 저장된 컬럼 개인화 복원 (진입 시 1회) — staticColumns 에 소급 적용. */
  fetchUserColumnLayout: () => Promise<ColumnLayoutSetting[] | null>;
  /** ColumnLayoutModal onSave — 표시/순서/width/색상을 staticColumns 에 즉시 반영. */
  applyColumnLayout: (settings: ColumnLayoutSetting[]) => void;
}

const initSearchParams: SearchParamProps = {
  divisionId: '40',
  deptIds: [],
  endCustomers: [],
  salesSites: [],
  bizTypes: [],
  itemIds: [],
  // ⭐ 조회기간 기본값 = AS-IS `DM.PR_GET_DAY_RANGE(@p_month=6)` 두 번째 결과셋 1:1
  //   (AsIs_LGCE_SCMDEV_SP2_DDL.sql:117212~117213 — "해당 월 1일 ~ @p_month 개월의 마지막 날").
  //   FROM = 당월 1일 / TO = FROM +6개월 -1일 (= FROM 기준 5개월 후 달의 말일).
  //   AS-IS .cs L3105 `request.Parameters["p_month"] = 6` (13→6 축소 [PJ2025-50188]).
  //   ⚠️ 구현 `.add(6,'month')` 는 -1일 누락으로 AS-IS 보다 하루 길었다(2026-08-10 정정).
  startYyyymmdd: dayjs().startOf('month').format('YYYYMMDD'),
  endYyyymmdd: dayjs().startOf('month').add(6, 'month').subtract(1, 'day').format('YYYYMMDD'),
  bucketType: 'W',
  versionType: 'Current',
  qtyYn: false,
  sumYn: false,
  // [UICATEGORY 2026-08-07] DMF0003 파리티 조회조건 — persist rehydrate 구버전 shape 보호(기본값 필수)
  plantSiteIds: [],
  projectCodes: [],
  owners: [],
  senderCodes: [],
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
  authGroup: '',
  wsPlannerYn: false,
  userColumnLayout: null,
  originalStaticColumns: [],
};

// BE 가 폭을 안 내려줄 때의 기본 폭 (ColumnLayoutModal DEFAULT_COL_WIDTH 와 동일 계약).
const DEFAULT_COL_WIDTH = 100;

// ⚠️ BE PR_GET_SHEET_COLUMN_LIST 는 SHEET_PRSL_YN 미등록 화면에 개인화를 반영하지 않는다
//   (DMF0003/DMF0043 실측 — mkt-fcst·sales-monitoring 선례 주석 동일). 따라서 titleSet 'C' 로
//   저장한 개인화를 FE 가 직접 admin 메타에 덧씌운다. settings 순서 = 화면 컬럼 순서.
const applyLayoutToColumns = (
  cols: RawFlexGridColumnConfig[],
  settings: ColumnLayoutSetting[]
): RawFlexGridColumnConfig[] => {
  const byCol = new Map(settings.map(s => [s.colNm, s]));
  return cols
    .map(c => {
      const s = byCol.get(c.colNm);
      // 개인화 목록에 없는 컬럼 = 사용자가 비표시로 저장한 것.
      if (!s) return { ...c, visible: false, display: false };
      return {
        ...c,
        visible: s.visible,
        display: s.visible,
        colWth: s.width,
        cellColor: s.cellColor,
        textColor: s.textColor,
      };
    })
    .sort(
      (a, b) =>
        (byCol.get(a.colNm)?.order ?? Number.MAX_SAFE_INTEGER) -
        (byCol.get(b.colNm)?.order ?? Number.MAX_SAFE_INTEGER)
    );
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
    setAuthGroup: (group: string) =>
      set(state => {
        state.authGroup = group;
      }),
    setWsPlannerYn: (yn: boolean) =>
      set(state => {
        state.wsPlannerYn = yn;
      }),
    setSearchParams: searchParams => {
      set(state => {
        state.searchParams = { ...get().searchParams, ...searchParams };
      });
    },
    setFilters: () => {
      // AS-IS L1727~1738 1:1 — p_created_by=UserId / p_user_group=NowGroupID.
      //   ⚠️ session.groupId 는 유령 필드(전 계층 부재, 2026-07-15 실측)라 항상 userId 가 전송돼
      //   GET_ADMIN_GROUP_MEASURE(SEGMENT1=그룹명) 미매칭 → 편집권한 전무 사고(40 편집불가).
      //   해법(sales-plan/DMF0021 선례): CMBO 'FcstPriceUserAuthGroup' 로 해석한 authGroup 사용.
      //   미보유(0행) 시 userId fallback (= lookup 미매칭 = 편집권한 없음, 정상 동작).
      const sesUserId = useSessionStore.getState().session.userId ?? '';
      const userGroup = get().authGroup || sesUserId;
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
        // [UICATEGORY 2026-08-07] Plant Site(기존 SP IN 13 — 미전송 결함 동시 수정) + Project/Owner/SenderCode(IN 14~16)
        plantSiteId: joinComma(sp.plantSiteIds),
        projectCode: joinComma(sp.projectCodes),
        owner: joinComma(sp.owners),
        senderCode: joinComma(sp.senderCodes),
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
    // ⭐ Division 전환 시 그리드 초기화 — filters/titleFilters 를 비우면 useTabProcQuery 의 queryKey 가
    //   바뀌고 enabled=false 가 되어 이전 division 의 응답이 그리드에서 즉시 사라진다.
    //   (mkt-fcst/metal-link-price/sales-future-price clearFilters 선례 1:1. 재조회는 Search 로만.)
    clearFilters: () => {
      set(state => {
        state.filters = undefined;
        state.titleFilters = undefined;
      });
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
            // ⭐ 저장된 개인화가 있으면 admin 메타 위에 덧씌운다 — 안 하면 매 재조회마다
            //   사용자가 저장한 표시/순서/폭/색이 관리자 기본값으로 되돌아간다.
            const layout = get().userColumnLayout;
            // ⚠️ `?? []` 필수 — BE 가 200 으로 `result: null` 을 주는 경우가 있다(division 별 메타
            //   미적재 등). null 이 그대로 들어가면 staticColumns 를 쓰는 전 지점(staticBindingSet /
            //   inputTpRef / FlexGridFilter filterColumns / toColumnLayoutSettings)이 `.map` 에서
            //   터져 화면이 통째로 에러 바운더리로 떨어진다 (2026-08-13 division 81 실측).
            //   실패(catch)와 달리 이 경로는 예외가 아니라 **정상 응답**이라 try/catch 로는 못 막는다.
            const fetched = result.data.result ?? [];
            // 개인화 적용 전 원본 보관 — 팝업 Default 원복 기준 (개인화로 덮이지 않는다).
            state.originalStaticColumns = fetched;
            state.staticColumns =
              layout && layout.length > 0 ? applyLayoutToColumns(fetched, layout) : fetched;
          });
        } catch {
          /* 메타 미적재 시 빈 배열 유지 — 화면은 fallback 없이 메타 주도 */
        }
      })();
    },

    // ⭐ 저장된 개인화 복원 — ColumnLayoutModal 이 쓰는 SP 와 동일 계약
    //   (DMF0002_GET_TITLESET_POPUP / columnType='C'). USER_FLAG='Y' 행 = 사용자가 표시로 저장한 컬럼.
    //   ⚠️ COLUMN_WIDTH/CELL_COLOR/TEXT_COLOR 는 BE 확장(SCM_MST_TITLESET_USER 3컬럼)으로 내려오는
    //     사용자 값. 미지원/미저장이면 각각 관리자 폭·빈 문자열로 떨어져 기존 동작과 동일하다.
    fetchUserColumnLayout: async () => {
      try {
        const res = await apiClient.post<{ o_rc1?: Record<string, string>[] }>(
          `${MENU_ID}/titleSet/SEARCH/call-proc`,
          {
            programId: MENU_ID,
            sheetName: SHEETS.FCST_N_PRICE_40,
            columnType: 'C',
            divisionId: get().searchParams.divisionId,
          }
        );
        const rows = res.data.result?.o_rc1 ?? [];
        // ⭐ 사용자 저장값 별칭 우선 — SP 는 관리자 기본값(COLUMN_WIDTH/SORT_ORDER_NO)과
        //   사용자값(USER_COLUMN_WIDTH/USER_SORT_ORDER_NO)을 따로 내려준다(2026-07-27 실측).
        const orderOf = (r: Record<string, string>): number =>
          Number(r.USER_SORT_ORDER_NO ?? r.SORT_ORDER_NO ?? 0);
        const layout = rows
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
        if (layout.length === 0) return null;
        set(state => {
          state.userColumnLayout = layout;
          // ⚠️ 이 조회는 fetchStaticColumns 와 독립 발사라 응답 순서가 보장되지 않는다.
          //   /column 이 먼저 도착했으면 override 가 생략됐으므로 여기서 소급 적용한다.
          if (state.staticColumns.length > 0) {
            state.staticColumns = applyLayoutToColumns(state.staticColumns, layout);
          }
        });
        return layout;
      } catch {
        // 개인화 조회 실패 = 기본 컬럼 세트로 동작 (화면 차단 금지, console 금지 룰)
        return null;
      }
    },

    // ColumnLayoutModal onSave — 서버 저장과 별개로 grid 에 즉시 반영 (표시/순서/width/색상).
    applyColumnLayout: settings => {
      set(state => {
        // 표시 컬럼만 보관 — fetchStaticColumns 재조회 후 재적용 기준이자 팝업 재진입 복원값.
        state.userColumnLayout = settings
          .filter(s => s.visible)
          .sort((a, b) => a.order - b.order)
          .map((s, i) => ({ ...s, order: i + 1 }));
        if (state.staticColumns.length === 0) return;
        state.staticColumns = applyLayoutToColumns(state.staticColumns, state.userColumnLayout);
      });
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
            // `?? []` — fetchStaticColumns 와 동일 이유(200 + result:null 방어).
            state.staticMeasures = result.data.result ?? [];
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
            // `?? []` — fetchStaticColumns 와 동일 이유(200 + result:null 방어).
            state.savePriceColumns = result.data.result ?? [];
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
      const cutoff =
        typeof first?.M3_CUTOFF_DATE === 'string' ? first.M3_CUTOFF_DATE.slice(0, 6) : '';
      set(state => {
        state.m3CutoffYyyymm = cutoff;
      });
    },
  }),
  'forecast-price'
);
