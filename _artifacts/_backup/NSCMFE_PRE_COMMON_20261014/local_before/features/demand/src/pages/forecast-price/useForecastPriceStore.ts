import { apiClient } from '@foundation/apis';
import dayjs from '@foundation/dayjs';
import type { FlexGridColumnConfig, RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab, useSessionStore } from '@shared/stores';

import { MENU_ID, SAVE_PRICE_META_SHEET, SHEETS } from './forecast-price.constants';
import { TEMPLATE_META_SHEET } from './utils/forecast-price.excelForm';
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
  // ⭐ measure 별 "시간창 因 잠금" (drop3 EDIT_AUTH_YN==='T' — [E20260826-AUTHVIEW]).
  //   보유그룹의 시간창 정의 행이 있으나 지금이 창 밖 → 편집 시도 시 MSG00477 안내 대상.
  //   (그룹 미보유 因 'N' 과 구분 — DM Viewer 등에는 시간 메시지를 띄우지 않는다.)
  measureTimeGate: Record<string, boolean>;
  // 현재 주차 binding (GET drop2 THIS_YYYYMMWW) — 과거 잠금 경계 산출 입력.
  thisYyyymmww: string;
  // ⭐ 배분 캘린더 (GET drop4=O_RC5) — 'D_YYYYMMDD' → {monthDayCnt, weekDayCnt}. 월(M_) 배분(#1) 입력.
  calendar: Record<string, { monthDayCnt: number; weekDayCnt: number }>;
  // ⭐ M+3 기준월 'YYYYMM' (GET drop1=O_RC2 첫 행 M3_CUTOFF_DATE) — M+4 월잠금(#4) 입력.
  m3CutoffYyyymm: string;
  // ⭐ SavePricePeriodModal 고정 컬럼 메타 (SHEET_NAME='Sales Price Save All' 25 컬럼 —
  //   admin UI Category Setup 동적 fetch, hook ui-category-setup-column-meta).
  savePriceColumns: RawFlexGridColumnConfig[];
  // ⭐ [E20260921-XLSFORMASIS] ForecastTemplateModal(Excel Form 양식) 컬럼 메타
  //   (SHEET_NAME='Sales Price Template' 19행 — AS-IS DMF0020 팝업이 읽는 그 메타와 동일 축).
  //   AS-IS 는 division 별 헤더를 메타에서 가져온다([PJ2024-50611]) — 그 구조를 그대로 맞춘 것.
  templateColumns: RawFlexGridColumnConfig[];
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
  // 컬럼 admin 기본 정렬(titleSet SORT_ORDER_NO) colNm→순번 — 개인화에 누락된 필수 컬럼을
  //   자동 추가할 때 admin 순서상 제자리에 끼우기 위한 기준. (/column 응답 배열 순서는 숨김-먼저라 부정확)
  adminColOrder: Record<string, number>;
  // ⭐ 개인화 적용 전 admin 메타 원본 — 팝업 Default 버튼의 원복 기준.
  //   staticColumns 는 개인화로 mutate 되므로 별도 스냅샷이 필요하다.
  originalStaticColumns: RawFlexGridColumnConfig[];
  // F6 저장 조회조건 복원 1회 가드 (탭 오픈당) — MotherStore PRESERVED_ON_CONDITION_RESET 보존 키.
  initialized: boolean;
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
  /** [RESET 2026-08-26] 조회조건 전체 초기화 — AS-IS 공통 [Reset Condition](F10) 파리티.
   *  persisted store 라 저장된 조건도 함께 초기값으로 돌아간다. division 변경이 수반되면
   *  ForecastPrice.tsx 의 division-변경 effect 가 그리드 초기화·CRUD reset 을 수행한다. */
  resetSearchParams: () => void;
  /**
   * F6 로 저장한 조회조건(SCM_ADM_USER_MNU_SRCH_COND_M)을 탭 진입 시 1회 복원한다.
   * initialized 가드 — F10(초기화)은 MotherStore 가 initialized 를 보존하므로 재복원되지 않는다.
   */
  restoreSearchConditions: () => Promise<void>;
  setSearchParams: (searchParams: Partial<SearchParamProps>) => void;
  setFilters: () => boolean;
  /** 조회조건 무효화 — division 전환 시 이전 division 조회결과가 그리드에 잔존하는 것을 막는다. */
  clearFilters: () => void;
  setOpenSearchArea: (open?: boolean) => void;
  fetchStaticColumns: () => void;
  fetchStaticMeasures: () => void;
  fetchSavePriceColumns: (divisionId: string) => void;
  fetchTemplateColumns: (divisionId: string) => void;
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

// 주의: 상수가 아니라 함수다. 모듈 최상위 상수로 굳히면 session.div 를 DMF0082 청크가 처음
//   로드되던 그 순간 한 번만 읽는다. 로그아웃은 스토어와 sessionStorage 만 비우고 새로고침을
//   하지 않으므로(useClearAppData.clearAllData) 모듈은 계속 살아 있고, 다른 계정으로 재로그인해도
//   앞 계정의 division 이 그대로 얼어붙는다. 스토어는 탭별로 생성되므로 생성 시점에 세션을 읽어야
//   항상 현재 계정 기준이 된다 (business-plan useBusinessPlanStore.makeInitSearch 와 동일 규약).
const makeInitSearchParams = (): SearchParamProps => ({
  // 진입 division 기본값 = 로그인 세션 권한 division (mkt-fcst useMktFcstStore.ts 1:1).
  //   '40' 하드코딩 시 40 권한이 없는 사용자(예: 81 단일권한)는 콤보 옵션에 '40'이 없어
  //   Division 칸이 공백으로 뜬다(2026-09-03 실측 — FilterMyDivision 이 81 한 행만 반환).
  //   fallback '40' 은 세션 미확립(로그인 전 진입) 대비 규칙 기본값 1건.
  divisionId: useSessionStore.getState().session.div ?? '40',
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
});

const makeInitState = (): ForecastPriceState => ({
  searchParams: makeInitSearchParams(),
  isOpenSearchArea: true,
  staticColumns: [],
  staticMeasures: [],
  dateColumns: [],
  measureAuth: {},
  measureTimeGate: {},
  thisYyyymmww: '',
  calendar: {},
  m3CutoffYyyymm: '',
  savePriceColumns: [],
  templateColumns: [],
  authGroup: '',
  wsPlannerYn: false,
  userColumnLayout: null,
  adminColOrder: {},
  originalStaticColumns: [],
  initialized: false,
});

// 키 분류/복원 검증 전용 shape - 값이 아니라 "어떤 키가 어떤 타입인가"만 쓴다.
const SEARCH_PARAM_SHAPE: SearchParamProps = makeInitSearchParams();

/**
 * F6 저장 조회조건 역파싱 키 분류.
 *
 * 저장(GridAction.personalizeCondition)은 모든 값을 문자열로 coerce 한다(배열=콤마 join /
 * 불리언=String). 복원은 그 반대로 SearchParamProps 타입대로 되돌린다:
 *   배열키 = 콤마 split / 불리언키 = 'true' 비교 / 그 외 = 문자열.
 * 분류는 SEARCH_PARAM_SHAPE 의 실제 값 타입에서 파생한다 — 조회조건 필드가 늘어도 자동 반영된다.
 */
const ARRAY_KEYS = new Set<string>(
  Object.entries(SEARCH_PARAM_SHAPE)
    .filter(([, v]) => Array.isArray(v))
    .map(([k]) => k)
);
const BOOL_KEYS = new Set<string>(
  Object.entries(SEARCH_PARAM_SHAPE)
    .filter(([, v]) => typeof v === 'boolean')
    .map(([k]) => k)
);
// Bucket 은 유효값(Daily/Weekly/Monthly)만 채택 — 구버전 저장값/오염이 들어오면 콤보가 빈 선택으로 떨어진다.
const BUCKET_VALUES = new Set<string>(['D', 'W', 'M']);
// 저장 포맷 = yyyymmdd 8자리. 다른 포맷이면 기간 필드가 SP 로 그대로 새어 나간다.
const isYyyymmdd = (v: unknown): v is string => typeof v === 'string' && /^\d{8}$/.test(v);

// BE 가 폭을 안 내려줄 때의 기본 폭 (ColumnLayoutModal DEFAULT_COL_WIDTH 와 동일 계약).
const DEFAULT_COL_WIDTH = 100;

// ⚠️ BE PR_GET_SHEET_COLUMN_LIST 는 SHEET_PRSL_YN 미등록 화면에 개인화를 반영하지 않는다
//   (DMF0003/DMF0043 실측 — mkt-fcst·sales-monitoring 선례 주석 동일). 따라서 titleSet 'C' 로
//   저장한 개인화를 FE 가 직접 admin 메타에 덧씌운다. settings 순서 = 화면 컬럼 순서.
const applyLayoutToColumns = (
  cols: RawFlexGridColumnConfig[],
  settings: ColumnLayoutSetting[],
  adminColOrder: Record<string, number> = {}
): RawFlexGridColumnConfig[] => {
  const byCol = new Map(settings.map(s => [s.colNm, s]));
  // 개인화에 없는 필수 컬럼(USER_SELECT_FLAG='N' = personalizable:false)을 자동 추가할 때의 정렬 위치 —
  //   admin 순서(SORT_ORDER_NO)상 자기 앞에 있는 '개인화된' 컬럼들의 최대 user order 바로 뒤(+0.5)에
  //   끼워 제자리에 붙인다(맨 앞 키 컬럼이면 앞쪽, MEASURE 처럼 뒤 키 컬럼이면 뒤쪽).
  //   ⚠️ /column 응답 배열 순서는 숨김-컬럼-먼저라 위치 기준으로 못 쓴다 → titleSet SORT_ORDER_NO 사용.
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
    // 개인화에 없는 필수 컬럼 = admin 상대 위치로, 그 외(사용자가 숨긴) = 맨 뒤(어차피 미표시).
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
      //   - USER_SELECT_FLAG='N'(personalizable===false, 사용자가 숨길 수 없는 필수 컬럼)이고
      //     **표시용 컬럼(visible===true)** 이면, division 변경 등으로 개인화 저장 내역에 누락됐어도
      //     자동 표시한다. (사용자 요구 2026-09-03 — 변경된 division 의 필수 컬럼 누락 보완)
      //     ⚠️ display=true 를 강제한다 — BE /column 이 개인화 USER_FLAG='N' 을 반영해 display:false 로
      //       내려주므로(실측 r193 CELL_PROD_SITE_ID) c 를 그대로 두면 여전히 숨겨진다.
      //     ⚠️ visible===true 로 좁힌다 — VMI_STD_DIO 처럼 personalizable:false 지만 visible:false·colWth:0
      //       인 내부/시스템 컬럼은 표시 대상이 아니다(좁은 폭으로 새어나오던 것 차단).
      //   - 그 외(사용자가 숨길 수 있는데 목록에 없는)는 사용자가 비표시로 저장한 것 → 숨김.
      if (c.personalizable === false && c.visible === true) return { ...c, display: true };
      return { ...c, visible: false, display: false };
    })
    .sort((a, b) => orderKey(a) - orderKey(b));
};

// 멀티선택 → SP 파라미터: ⚠️ DMF0082 는 콤마 구분 (PKG_DMF0082 REGEXP_SUBSTR '[^,]+' 실측).
//   빈 배열 = 'ALL' (AS-IS 전체 조회 sentinel).
const joinComma = (arr: string[]): string => (arr.length === 0 ? 'ALL' : arr.join(','));

export const useForecastPriceStore = createPersistedStoreWithTab<
  ForecastPriceState & ForecastPriceAction
>(
  (set, get) => ({
    ...makeInitState(),
    reset: () => set(makeInitState()),
    resetSearchParams: () =>
      set(state => {
        state.searchParams = makeInitSearchParams();
      }),

    // F6 저장 조회조건 복원 — 탭 수명 내 1회(initialized 가드). 저장조건 없음/조회 실패는
    //   기본값 유지(화면 차단 금지, console 금지 룰). F10(Reset Condition)은 SubTitle 공통이
    //   MotherStore.resetSearchCondition 으로 처리하는데, 그 쪽이 initialized 를 보존하므로
    //   초기화 직후 이 함수가 다시 복원해 버리는 일은 없다.
    //   복원이 divisionId 를 바꾸면 division-키 effect(컬럼/메저 재fetch)가 알아서 따라온다.
    restoreSearchConditions: async () => {
      if (get().initialized) return;
      set(state => {
        state.initialized = true; // 먼저 세운다 — 마운트 중복 호출/재마운트 재복원 방지.
      });
      try {
        const res = await apiClient.get<{ paramNm: string; paramCtn: string }[]>(
          `/admin/menu/${MENU_ID}/search-conditions`
        );
        const rows = res.data.result ?? [];
        if (rows.length === 0) return;

        const patch: Record<string, unknown> = {};
        for (const { paramNm, paramCtn } of rows) {
          // 현재 SearchParamProps 에 없는 키(구버전 잔재)는 버린다.
          if (!(paramNm in SEARCH_PARAM_SHAPE)) continue;
          const val = paramCtn ?? '';
          if (ARRAY_KEYS.has(paramNm)) patch[paramNm] = val ? val.split(',').filter(Boolean) : [];
          else if (BOOL_KEYS.has(paramNm)) patch[paramNm] = val === 'true';
          else patch[paramNm] = val;
        }
        if (typeof patch.bucketType === 'string' && !BUCKET_VALUES.has(patch.bucketType))
          delete patch.bucketType;
        if (!isYyyymmdd(patch.startYyyymmdd)) delete patch.startYyyymmdd;
        if (!isYyyymmdd(patch.endYyyymmdd)) delete patch.endYyyymmdd;
        // versionType 은 버전 팝업이 주입하는 값이라 없는 버전일 수 있다. 그래도 사용자가 저장한
        //   조건이므로 그대로 복원한다 — 없는 버전이면 조회가 0건을 돌려줄 뿐이다.

        set(state => {
          // 부분 병합 — 저장분에 없는 키는 기본값 유지 (신규 조회조건 추가 시 유실 방지).
          state.searchParams = {
            ...state.searchParams,
            ...(patch as Partial<SearchParamProps>),
          };
        });
      } catch {
        // 저장조건 미존재/조회 실패 시 기본값 유지 (console 금지 룰)
      }
    },
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
      const sp: SearchParamProps = { ...makeInitSearchParams(), ...get().searchParams };

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
            // USER_SELECT_FLAG='N'(personalizable:false) + 표시용(visible:true) 필수 컬럼은 개인화/BE
            //   display 와 무관하게 항상 표시한다 — BE /column 이 개인화 USER_FLAG='N' 을 display:false 로
            //   반영해 내려주므로(실측 r193 CELL_PROD_SITE_ID) 개인화 미적용 경로에서도 여기서 되살린다.
            //   visible:false 내부 컬럼(VMI_STD_DIO 등, colWth:0)은 제외 — 표시 대상이 아니다.
            const fetched = (result.data.result ?? []).map(c =>
              c.personalizable === false && c.visible === true ? { ...c, display: true } : c
            );
            // 개인화 적용 전 원본 보관 — 팝업 Default 원복 기준 (개인화로 덮이지 않는다).
            state.originalStaticColumns = fetched;
            state.staticColumns =
              layout && layout.length > 0
                ? applyLayoutToColumns(fetched, layout, get().adminColOrder)
                : fetched;
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
        // admin 기본 정렬(SORT_ORDER_NO) — 개인화에 누락된 필수 컬럼을 제자리에 끼울 때 쓴다.
        //   전체 행(USER_FLAG 무관)에서 뽑는다. layout 유무와 무관하게 보관.
        const adminColOrder: Record<string, number> = {};
        for (const r of rows) {
          const nm = String(r.COLUMN_NAME ?? '');
          if (nm) adminColOrder[nm] = Number(r.SORT_ORDER_NO ?? 0);
        }
        set(state => {
          state.adminColOrder = adminColOrder;
        });
        if (layout.length === 0) return null;
        set(state => {
          state.userColumnLayout = layout;
          // ⚠️ 이 조회는 fetchStaticColumns 와 독립 발사라 응답 순서가 보장되지 않는다.
          //   /column 이 먼저 도착했으면 override 가 생략됐으므로 여기서 소급 적용한다.
          if (state.staticColumns.length > 0) {
            state.staticColumns = applyLayoutToColumns(state.staticColumns, layout, adminColOrder);
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
        state.staticColumns = applyLayoutToColumns(
          state.staticColumns,
          state.userColumnLayout,
          state.adminColOrder
        );
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
    // ⭐ [E20260921-XLSFORMASIS] Excel Form 양식 컬럼 메타 — division 필터는 SP 서버측
    //   (fetchSavePriceColumns 와 동일 경로/계약). 실패 시 빈 배열 유지 →
    //   buildExcelFormColumns 가 FALLBACK_TEMPLATE_COLUMNS 로 폴백해 양식이 비지 않는다.
    fetchTemplateColumns: divisionId => {
      void (async () => {
        try {
          const result = await apiClient.post<RawFlexGridColumnConfig[]>(
            `/admin/menu/${MENU_ID}/column`,
            {
              sheetNm: TEMPLATE_META_SHEET,
              divisionId,
            }
          );
          set(state => {
            // `?? []` — fetchStaticColumns 와 동일 이유(200 + result:null 방어).
            state.templateColumns = result.data.result ?? [];
          });
        } catch {
          /* 메타 미적재 시 빈 배열 유지 — buildExcelFormColumns 가 폴백 */
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
      //   'T' = 시간창 因 잠금([E20260826-AUTHVIEW]) — 편집은 false, MSG00477 안내 대상으로 별도 맵.
      //   같은 MEASURE 다행(요일 축 분리)이 올 수 있어 or-병합한다.
      const auth: Record<string, boolean> = {};
      const timeGate: Record<string, boolean> = {};
      rows.forEach(r => {
        const m = typeof r.MEASURE === 'string' ? r.MEASURE : '';
        if (!m) return;
        const v = r.EDIT_AUTH_YN ?? '';
        auth[m] = (auth[m] ?? false) || v === 'Y';
        timeGate[m] = (timeGate[m] ?? false) || v === 'T';
      });
      set(state => {
        state.measureAuth = auth;
        state.measureTimeGate = timeGate;
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
